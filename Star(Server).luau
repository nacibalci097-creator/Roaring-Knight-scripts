-- discord: scp_deneyleri roblox: scp_deneylerist
local abilityinfo_module = require(game.ReplicatedStorage.Modules.AbilityInfo)
local damage_module = require(game.ServerScriptService.Modules.Damage)

local function target(center: Vector3, radius: number) : Vector3
	local x = center.X
	local y = center.Y
	local z = center.Z

	return Vector3.new(math.random(x - radius, x + radius), math.random(y, y + 1), math.random(z - radius, z + radius))
end

return function(player : Player, ability : string, targets : {any})
	local char = player.Character or player.CharacterAdded:Wait()
	local stars = {}
	
	for i = 1, abilityinfo_module.Star.Amount do
		local pos = target((char:GetPivot() * CFrame.new(0,2, -30)).Position, 15) -- decide where the star should go

		stars[i] = pos

		task.delay(2 + 0.1 * (i - 1), function() -- delay each hitbox's check by that value so it matches the client
			for i, model : Model in targets do -- for all targets
				if (model:GetPivot().Position - pos).Magnitude <= 5 then -- if the distance is closer than 5 studs
					damage_module(model, ability) -- deal damage
				end
			end
		end)
	end
	
	return stars
end