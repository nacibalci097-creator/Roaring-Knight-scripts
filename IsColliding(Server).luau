-- discord: scp_deneyleri roblox: scp_deneylerist
return function(position : Vector3, hitbox : Part) -- not sure how to explain this if the all 3 checks are true that means the position is inside that part
	local newpos = hitbox.CFrame:PointToObjectSpace(position)
	return (math.abs(newpos.X) <= hitbox.Size.X / 2)
		and (math.abs(newpos.Y) <= hitbox.Size.Y / 2)
		and (math.abs(newpos.Z) <= hitbox.Size.Z / 2)
end