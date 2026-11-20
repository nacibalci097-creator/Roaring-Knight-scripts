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

		game.SoundService.Star:Play()
		task.wait(1)

		task.delay(abilityinfo_module[tool.Name].Cooldown, function() -- wait for cooldown
			oncooldown = false
		end)

		local startpositions : {any} = events.AbilityFunction:InvokeServer(tool.Name) -- getting the positions server craeted for each star
		local finished = 0 -- this exist so torso can be unanchored at the right time

		char.Torso.Anchored = true

		for i, targetpos in startpositions do
			local clone = game.ReplicatedStorage.Other.Star:Clone()
			clone.Size = clone.Size * 0.1
			clone.Position = char["Left Arm"].Position
			clone.Parent = workspace.Effects

			task.defer(function() -- i thnik its clear what these do just simple tweens and proprety changes
				tweenservice:Create(clone, TweenInfo.new(4), {Color = Color3.fromRGB(255)}):Play()
				local tween = tweenservice:Create(clone, TweenInfo.new(2), {Size = clone.Size * 10, Position = targetpos})
				tween:Play()
				tween.Completed:Wait()

				local part = Instance.new("Part")
				part.Size = Vector3.new(0.1, 0.1, 0.1)
				part.Position = clone.Position
				part.Color = Color3.fromRGB(255,255,255)
				part.Material = "Neon" -- this is like this cus enum is way too long
				part.Shape = Enum.PartType.Ball
				part.CanCollide = false
				part.CastShadow = false
				part.Anchored = true
				part.Parent = workspace.Effects
				
				tweenservice:Create(part, TweenInfo.new(0.2), {Size = Vector3.new(7,7,7)}):Play()

				local tween = tweenservice:Create(clone, TweenInfo.new(0.2), {Transparency = 1})
				tween:Play()
				tween.Completed:Wait()
				clone:Destroy()

				game.SoundService.StarExplode:Play()

				local tween = tweenservice:Create(part, TweenInfo.new(0.2), {Transparency = 1})
				tween:Play()
				tween.Completed:Wait()
				part:Destroy()

				finished += 1

				if finished >= #startpositions then -- wait for all stars to finish its tweens before unanchoring + stopping anim
					track.Looped = false
					track:Stop()
					char.Torso.Anchored = false
				end
			end)	

			task.wait(0.1)
		end
	end)
end