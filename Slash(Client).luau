-- discord: scp_deneyleri roblox: scp_deneylerist
local abilityinfo_module = require(game.ReplicatedStorage.Modules.AbilityInfo)
local events = game.ReplicatedStorage.Events

local animation = game.ReplicatedStorage.Animations.Slash
local oncooldown = false

return function(tool : Tool, player : Player) -- i think its clear what this does
	tool.Activated:Connect(function()
		if oncooldown then return end -- if its on cooldown skip allat
		oncooldown = true

		local char = player.Character or player.CharacterAdded:Wait()

		local track : AnimationTrack = char.Humanoid.Animator:LoadAnimation(animation)
		track:Play()
		track:AdjustSpeed(1.25)

		local conn = track:GetMarkerReachedSignal("Attack"):Connect(function()
			events.Ability:FireServer(tool.Name)
			game.SoundService.Slash:Play()
		end)

		task.delay(abilityinfo_module[tool.Name].Cooldown, function() -- wait for cooldown
			oncooldown = false
			conn:Disconnect() -- deleting the event so no memory leaks
		end)
	end)
end