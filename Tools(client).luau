-- discord: scp_deneyleri roblox: scp_deneylerist
local player = game.Players.LocalPlayer
local tools = player.Backpack:GetChildren()
local abilities = game.ReplicatedStorage.AbilityModules

local tweenservice = game:GetService("TweenService")
local tinfo = TweenInfo.new(1, Enum.EasingStyle.Linear)

local char = player.Character or player.CharacterAdded:Wait()

local parts = {}

for _, tool : Tool in tools do -- loop all the tools
	require(abilities[tool.Name])(tool, player) -- call its module
end

local function renew(char : Model)
	parts = {}

	for i, v in char:GetDescendants() do -- loop character's all childs
		if v:IsA("MeshPart") or v:IsA("Part") then -- if its these
			table.insert(parts, v) -- add it to the table
		end
	end
end

renew(char)

player.CharacterAdded:Connect(renew)

for i, model : Model in workspace.Targets:GetChildren() do -- loop all the targets
	local humanoid : Humanoid = model.Humanoid
	local oldhealth = humanoid.Health
	humanoid:GetPropertyChangedSignal("Health"):Connect(function() -- when it takes damage
		local clone = game.ReplicatedStorage.Other.Gui:Clone()
		clone.Gui.TextLabel.Text = "-" .. oldhealth - humanoid.Health -- show how much damage it took
		clone.Position = model:GetPivot().Position
		clone.Parent = workspace.Effects
		
		game.SoundService.Hit:Play()
		oldhealth = humanoid.Health -- update the hold health so the 2nd hit doesnt show wrong values
		
		local tween = tweenservice:Create(clone, TweenInfo.new(0.5), {Position = clone.Position + Vector3.new(math.random(-3,3), math.random(5,10), math.random(-3,3))}) -- choose a random position to tween
		tween:Play()
		tween.Completed:Wait()
		
		tweenservice:Create(clone.Gui.TextLabel.UIStroke, TweenInfo.new(1), {Transparency = 1}):Play()
		tween = tweenservice:Create(clone.Gui.TextLabel, TweenInfo.new(1), {TextTransparency = 1})
		
		tween:Play()
		tween.Completed:Wait()
		clone:Destroy()
	end)
end

while task.wait(1 / 12) do
	local model = Instance.new("Model")
	-- directly cloning the model has cframe issues for some reason????
	for i, v : Part in parts do 
		local clone = v:Clone()
		
		if clone.Name == "HumanoidRootPart" then model.PrimaryPart = clone end
		
		for _, vv in clone:GetDescendants() do -- loop all the childs
			if vv:IsA("Attachment") or vv:IsA("Motor6D") or vv:IsA("Decal") then -- if child has these delete them
				vv:Destroy()
			end
		end
		
		clone.Material = Enum.Material.SmoothPlastic
		clone.CFrame = v.CFrame
		clone.CanCollide = false
		clone.CastShadow = false
		clone.Anchored = true
		
		clone.Parent = model
	end
	
	model.Parent = workspace.Effects

	task.defer(function()
		for i, v in model:GetChildren() do -- loop all childs
			tweenservice:Create(v, tinfo, {Transparency = 1}):Play() -- slowly make them invisible
		end
		
		for i = 1, 200 do
			model:PivotTo(model:GetPivot() * CFrame.new(0, 0, 0.02)) -- doing this instead of tween cus cframe issues BJHASJGHDJGHBAJSHGB
			task.wait()
		end
		
		model:Destroy()
	end)
end
