-- discord: scp_deneyleri roblox: scp_deneylerist
local tweenservice = game:GetService("TweenService")

local abilityinfo_module = require(game.ReplicatedStorage.Modules.AbilityInfo)
local events = game.ReplicatedStorage.Events

local oncooldown = false

return function(tool : Tool, player : Player)
	local gui = player.PlayerGui:WaitForChild("ScreenGui")

	tool.Activated:Connect(function()
		if oncooldown then return end -- if its on cooldown skip allat
		oncooldown = true

		local char = player.Character or player.CharacterAdded:Wait()

		task.delay(abilityinfo_module[tool.Name].Cooldown, function() -- wait for cooldown
			oncooldown = false
		end)
		
		local positions : {any} = events.AbilityFunction:InvokeServer(tool.Name) -- getting info from where each sword is aiming

		for i, target : Vector3 in positions do
			task.defer(function()
				local clone = game.ReplicatedStorage.Other.Blade:Clone()

				clone.CFrame = char:GetPivot() * CFrame.new(0, math.random(6,10), math.random(-6, 6)) -- small offset so swords appear higher than the character
				clone.CFrame = CFrame.new(clone.Position, target) * CFrame.Angles(0, math.rad(-90), math.rad(90)) -- angels exist cus the model's normal rotation is trapezoid
				clone.Parent = workspace.Effects
				game.SoundService.SwordSpawn:Play()
				tweenservice:Create(clone, TweenInfo.new(0.5), {Transparency = 0}):Play()

				task.wait(0.5)
				-- simple tweens nothing much
				local tween = tweenservice:Create(clone, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {Color = Color3.fromRGB(255)})
				tween:Play()
				tween.Completed:Wait()

				game.SoundService.SwordTarget:Play()

				tween = tweenservice:Create(clone, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {Position = target})
				tween:Play()
				tween.Completed:Wait()
				clone:Destroy()
			end)

			local cooldown = 1 - i * 0.1 -- this makes it so spawns get faster and faster

			task.wait(math.max(0.2, cooldown)) -- limit max speed at 0.2
		end
	end)
end