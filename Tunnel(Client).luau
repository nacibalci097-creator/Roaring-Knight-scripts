-- discord: scp_deneyleri roblox: scp_deneylerist
local tweenservice = game:GetService("TweenService")

local abilityinfo_module = require(game.ReplicatedStorage.Modules.AbilityInfo)
local events = game.ReplicatedStorage.Events

local animation = game.ReplicatedStorage.Animations.Star
local oncooldown = false

return function(tool : Tool, player : Player)
	local gui = player.PlayerGui:WaitForChild("ScreenGui")

	tool.Activated:Connect(function()
		if oncooldown then return end -- if its on cooldown skip allat
		oncooldown = true

		local char = player.Character or player.CharacterAdded:Wait()

		local track : AnimationTrack = char.Humanoid.Animator:LoadAnimation(animation)
		track:Play()

		task.wait(1)

		task.delay(abilityinfo_module[tool.Name].Cooldown, function() -- 
			oncooldown = false
		end)

		local swordpositions = events.AbilityFunction:InvokeServer(tool.Name) -- getting sword offsets from server

		char.Torso.Anchored = true
		
		for i, info in swordpositions do
			local clone = game.ReplicatedStorage.Other.Blade:Clone()
			local offset = info.Offset
			local rotation = info.Rotation
			local target = char:GetPivot() * offset * rotation

			clone.CFrame = target
			clone.Parent = workspace.Effects

			for i, v in clone:GetChildren() do -- loop the model's childs
				if v.Name == "Hitbox" or v:IsA("Highlight") then continue end -- if its the model's hitbox or highlight skip it
				tweenservice:Create(v, TweenInfo.new(0.25), {Transparency = 0}):Play() -- slowly make it vissible
			end

			tweenservice:Create(clone, TweenInfo.new(0.25), {Transparency = 0}):Play() -- this is outside of the loop cus its the "handle" of the model

			task.defer(function()
				for i = 1, 400 do
					clone.CFrame *= CFrame.new(0,0, i <= 50 and -0.2 or -0.5) -- this makes the swords start slow and then speed up like the real attack
					task.wait()
				end

				clone:Destroy()
			end)
			
			task.wait(0.025)
		end

		char.Torso.Anchored = false
		track.Looped = false
		track:Stop()
	end)
end