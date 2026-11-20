-- discord: scp_deneyleri roblox: scp_deneylerist
local tweenservice = game:GetService("TweenService")

local abilityinfo_module = require(game.ReplicatedStorage.Modules.AbilityInfo)
local events = game.ReplicatedStorage.Events

local animation = game.ReplicatedStorage.Animations.Slash
local oncooldown = false

return function(tool : Tool, player : Player) -- this is mostly the same thing as slash except with guis
	local gui = player.PlayerGui:WaitForChild("ScreenGui")

	tool.Activated:Connect(function()
		if oncooldown then return end -- if its on cooldown skip allat
		oncooldown = true

		local char = player.Character or player.CharacterAdded:Wait()

		local track : AnimationTrack = char.Humanoid.Animator:LoadAnimation(animation)
		track:Play()
		track:AdjustSpeed(1.5)

		local conn = track:GetMarkerReachedSignal("Attack"):Connect(function()
			events.Ability:FireServer(tool.Name)
			game.SoundService.Swoon:Play()

			gui.Swoon.BackgroundTransparency = 0
			gui.Swoon.ImageTransparency = 0

			tweenservice:Create(gui.Swoon, TweenInfo.new(2), {BackgroundTransparency = 1, ImageTransparency = 1}):Play()
		end)

		task.delay(abilityinfo_module[tool.Name].Cooldown, function() -- wait for cooldown
			oncooldown = false
			conn:Disconnect() -- remove the anim event so no memory leak
		end)
	end)
end