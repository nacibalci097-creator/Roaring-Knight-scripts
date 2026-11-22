-- discord: scp_deneyleri roblox: scp_deneylerist
local abilityinfo_module = require(game.ReplicatedStorage.Modules.AbilityInfo)
local damage_module = require(game.ServerScriptService.Modules.Damage)

return function(player : Player, ability : string, targets : {any})
	local swordpositions = {}
	local ignored = {}

	for i = 1, abilityinfo_module["Tunnel"].Amount do
		local even = i % 2 == 0
		local rng = math.random(-3,3)
		local offset = CFrame.new(even and 5 or -5, 3, 15) * CFrame.new(rng, 0, 0) -- edit offset depending on left or right
		local rotation = CFrame.Angles(math.rad(0), math.rad(0), even and math.rad(90) or math.rad(-90)) -- edit rotation depending on left or right

		swordpositions[i] = {
			Offset = offset,
			Rotation = rotation
		}
	end

	task.defer(function()
		for i, info in swordpositions do -- loop all swords
			for ii = 1, 2 do -- this make it so swords appear on both left and right side
				local clone = game.ReplicatedStorage.Other.Blade:Clone()
				local char = player.Character or player.CharacterAdded:Wait()
				local target = char:GetPivot() * info.Offset * info.Rotation

				clone.CFrame = target

				task.defer(function()
					for i = 1, 400 do
						clone.CFrame *= CFrame.new(0,0, i <= 50 and -0.2 or -0.5) -- slowly speed up the swords

						for _, model : Model in targets do
							if (model:GetPivot().Position - clone.Position).Magnitude <= 4 and not ignored[model] then -- if the distance is less than 4 and has no immunity
								ignored[model] = true -- immunity frame

								task.delay(0.1, function() -- 0.1 sec delay
									ignored[model] = nil -- remove immunity frame
								end)
								
								damage_module(model, ability) -- deal damage
							end
						end

						task.wait()
					end
					clone:Destroy()
				end)
			end
			task.wait(0.025)
		end
	end)

	return swordpositions
end