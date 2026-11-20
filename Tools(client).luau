-- discord: scp_deneyleri roblox: scp_deneylerist
local player = game.Players.LocalPlayer
local tools = player.Backpack:GetChildren()
local abilities = game.ReplicatedStorage.AbilityModules

for _, tool : Tool in tools do -- loop all the tools
	require(abilities[tool.Name])(tool, player) -- call its module
end