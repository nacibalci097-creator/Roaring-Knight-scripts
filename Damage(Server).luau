-- discord: scp_deneyleri roblox: scp_deneylerist
local abilityinfo_module = require(game.ReplicatedStorage.Modules.AbilityInfo)

return function(model : Model, ability : string)
	local damage : NumberRange = abilityinfo_module[ability].Damage -- get ability's damage stat
	local newdamage = 0
	
	newdamage = typeof(damage) == "NumberRange" and math.random(damage.Min, damage.Max) or damage -- if its a numer range choose a random value or just deal the damage
	
	model.Humanoid.Health -= newdamage
end