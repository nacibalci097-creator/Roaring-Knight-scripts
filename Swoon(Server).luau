-- discord: scp_deneyleri roblox: scp_deneylerist
local abilityinfo_module = require(game.ReplicatedStorage.Modules.AbilityInfo)
local iscolliding_module = require(game.ServerScriptService.Modules.IsColliding)
local damage_module = require(game.ServerScriptService.Modules.Damage)

return function(player : Player, ability : string, targets : {any})
	local hitbox : Part = game.ReplicatedStorage.Hitboxes[ability]:Clone() -- position the hitbox
	local char = player.Character or player.CharacterAdded:Wait()

	hitbox.CFrame = char:GetPivot() * (abilityinfo_module[ability].HitboxOffset or CFrame.new()) -- add the offset if theres any

	for _, model : Model in targets do -- for all targets
		if iscolliding_module(model:GetPivot().Position, hitbox) then -- if they are inside the hitbox
			damage_module(model, ability) -- deal damage
		end
	end

	hitbox:Destroy()
end