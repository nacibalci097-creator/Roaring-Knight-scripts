-- discord: scp_deneyleri roblox: scp_deneylerist
local abilityinfo_module = require(game.ReplicatedStorage.Modules.AbilityInfo)
local damage_module = require(game.ServerScriptService.Modules.Damage)

return function(player : Player, ability : string, targets : {any})
	local info = {}
	local models = {} -- why not use the info table? cus then client gets info it does not need causing unneccesary recv
	
	local newtargets = {}
	
	for i, v : Model in targets do -- loop all the targets
		if v.Humanoid.Health > 0 then -- if the target is alive
			table.insert(newtargets, v) -- add it to the new list
		end
	end
	
	if #newtargets <= 0 then -- if all targets are dead just return empty table
		return {}
	end
	
	for i = 1, abilityinfo_module.SwordAim.Amount do
		local target : Model = newtargets[math.random(1, #newtargets)] -- get a random target

		table.insert(info, target:GetPivot().Position)
		table.insert(models, target)
	end
	
	task.defer(function()
		for i, pos : Vector3 in info do -- loop all the targets
			local cooldown = 1 - i * 0.1 -- this makes the swords appear faster and faster
			local target : Model = models[i]
			
			task.delay(1, function() -- wait 1 sec
				if (pos - target:GetPivot().Position).Magnitude <= 1 then -- even after that if the distance is still lower than 1 they didnt move
					damage_module(target, ability) -- deal damage
				end
			end)
			
			task.wait(math.max(0.2, cooldown)) -- limit the max speed at 0.2
		end
	end)

	return info
end