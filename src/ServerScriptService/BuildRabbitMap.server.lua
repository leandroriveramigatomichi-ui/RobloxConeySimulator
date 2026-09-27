-- Rabbit Simulator: first map generator
-- Paste this Script into ServerScriptService in Roblox Studio and press Play.
-- It safely rebuilds only the folder named "RabbitWorld".

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local WORLD_NAME = "RabbitWorld"
local existing = Workspace:FindFirstChild(WORLD_NAME)
if existing then
	existing:Destroy()
end

local world = Instance.new("Folder")
world.Name = WORLD_NAME
world.Parent = Workspace

local COLORS = {
	grass = Color3.fromRGB(164, 214, 153),
	grassLight = Color3.fromRGB(205, 239, 174),
	wood = Color3.fromRGB(111, 67, 42),
	woodLight = Color3.fromRGB(157, 100, 58),
	gold = Color3.fromRGB(255, 221, 118),
	pink = Color3.fromRGB(255, 179, 203),
	violet = Color3.fromRGB(142, 82, 184),
	red = Color3.fromRGB(201, 63, 102),
	cream = Color3.fromRGB(255, 246, 215),
}

local function part(name, size, position, color, material, parent, shape)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Position = position
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Anchored = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent or world
	return p
end

local function cylinder(name, radius, height, position, color, material, parent)
	return part(name, Vector3.new(radius * 2, height, radius * 2), position, color, material, parent, Enum.PartType.Cylinder)
end

local function ball(name, size, position, color, material, parent)
	return part(name, size, position, color, material, parent, Enum.PartType.Ball)
end

local function billboardText(parent, text, color, offset)
	local gui = Instance.new("BillboardGui")
	gui.Name = "WelcomeSign"
	gui.Size = UDim2.fromOffset(260, 70)
	gui.StudsOffset = offset or Vector3.new(0, 5, 0)
	gui.AlwaysOnTop = true
	gui.Parent = parent
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color
	label.TextStrokeTransparency = 0.45
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.Parent = gui
end

-- Lighting: pastel, soft and readable, while still keeping a realistic atmosphere.
Lighting.ClockTime = 14
Lighting.Brightness = 2.2
Lighting.Ambient = Color3.fromRGB(176, 160, 190)
Lighting.OutdoorAmbient = Color3.fromRGB(190, 205, 225)
Lighting.EnvironmentDiffuseScale = 0.45
Lighting.EnvironmentSpecularScale = 0.35

local atmosphere = Lighting:FindFirstChild("RabbitAtmosphere") or Instance.new("Atmosphere")
atmosphere.Name = "RabbitAtmosphere"
atmosphere.Color = Color3.fromRGB(196, 218, 255)
atmosphere.Decay = Color3.fromRGB(255, 186, 205)
atmosphere.Density = 0.24
atmosphere.Glare = 0.18
atmosphere.Haze = 0.65
atmosphere.Parent = Lighting

local bloom = Instance.new("BloomEffect")
bloom.Name = "RabbitSoftBloom"
bloom.Intensity = 0.18
bloom.Size = 24
bloom.Threshold = 1.1
bloom.Parent = Lighting

-- A clean, pastel sky. Skybox texture IDs can be swapped later for custom art.
local sky = Lighting:FindFirstChild("RabbitSky") or Instance.new("Sky")
sky.Name = "RabbitSky"
sky.CelestialBodiesShown = true
sky.StarCount = 1200
sky.SunAngularSize = 18
sky.MoonAngularSize = 8
sky.SkyboxBk = "rbxasset://sky"
sky.SkyboxDn = "rbxasset://sky"
sky.SkyboxFt = "rbxasset://sky"
sky.SkyboxLf = "rbxasset://sky"
sky.SkyboxRt = "rbxasset://sky"
sky.SkyboxUp = "rbxasset://sky"
sky.Parent = Lighting

-- Large base island and a soft decorative border.
part("Island", Vector3.new(520, 8, 520), Vector3.new(0, -6, 0), COLORS.grass, Enum.Material.Grass)
cylinder("IslandBorder", 260, 3, Vector3.new(0, -1.5, 0), COLORS.grassLight, Enum.Material.SmoothPlastic)

-- Main circular platform: deliberately spacious around the 50+ stud tree.
cylinder("CentralGarden", 64, 5, Vector3.new(0, 3, 0), COLORS.cream, Enum.Material.Marble)
cylinder("GardenGrass", 59, 1.2, Vector3.new(0, 6.1, 0), COLORS.grassLight, Enum.Material.Grass)
cylinder("GardenTrim", 64.5, 1, Vector3.new(0, 5.3, 0), COLORS.gold, Enum.Material.Neon)

-- Four wide paths and their small stair approaches.
local paths = {
	{ name = "North", direction = Vector3.new(0, 0, -1) },
	{ name = "East", direction = Vector3.new(1, 0, 0) },
	{ name = "South", direction = Vector3.new(0, 0, 1) },
	{ name = "West", direction = Vector3.new(-1, 0, 0) },
}
for _, data in ipairs(paths) do
	local d = data.direction
	local perpendicular = Vector3.new(-d.Z, 0, d.X)
	for i = 1, 5 do
		local distance = 61 - (i - 1) * 2.1
		local center = d * distance + Vector3.new(0, 4.5 - i * 0.35, 0)
		local step = part(data.name .. "Step" .. i, Vector3.new(15, 1.2, 4), center, COLORS.cream, Enum.Material.Marble)
		if math.abs(d.X) > 0 then step.Size = Vector3.new(4, 1.2, 15) end
	end
	local center = d * 113 + Vector3.new(0, 1, 0)
	local path = part(data.name .. "Path", Vector3.new(15, 2, 105), center, COLORS.cream, Enum.Material.Slate)
	if math.abs(d.X) > 0 then path.Size = Vector3.new(105, 2, 15) end
	part(data.name .. "PathGlow", Vector3.new(2, 0.15, 105), center + perpendicular * 6.1 + Vector3.new(0, 1.08, 0), COLORS.gold, Enum.Material.Neon)
	if math.abs(d.X) > 0 then
		local glow = path:Clone(); glow.Name = data.name .. "PathGlow"; glow.Size = Vector3.new(105, 0.15, 2); glow.Position = center + perpendicular * 6.1 + Vector3.new(0, 1.08, 0); glow.Parent = world
	end
end

-- Central fantasy tree: buried root flare, textured-looking layered bark, and two-tone canopy.
local trunk = cylinder("AncientRabbitTreeTrunk", 9, 54, Vector3.new(0, 31, 0), COLORS.wood, Enum.Material.Wood)
local root = cylinder("BuriedRootFlare", 17, 7, Vector3.new(0, 8.5, 0), COLORS.woodLight, Enum.Material.Wood)
for i = 1, 8 do
	local angle = math.pi * 2 * i / 8
	local rootPos = Vector3.new(math.cos(angle) * 13, 8, math.sin(angle) * 13)
	local r = part("TreeRoot", Vector3.new(5, 2, 18), rootPos, COLORS.woodLight, Enum.Material.Wood)
	r.CFrame = CFrame.lookAt(rootPos, Vector3.new(0, 8, 0)) * CFrame.Angles(0, math.pi / 2, 0)
end
for i = 1, 7 do
	local y = 16 + i * 5
	local ring = cylinder("BarkDetail", 9.2 - i * 0.25, 0.35, Vector3.new(0, y, 0), COLORS.woodLight, Enum.Material.Wood)
	ring.Transparency = 0.25
end
local canopy = {
	{Vector3.new(0, 64, 0), 22, COLORS.violet},
	{Vector3.new(-17, 60, 3), 17, COLORS.red},
	{Vector3.new(17, 59, -2), 17, COLORS.violet},
	{Vector3.new(0, 57, 16), 16, COLORS.red},
	{Vector3.new(0, 55, -16), 16, COLORS.violet},
	{Vector3.new(-12, 52, -15), 13, COLORS.red},
	{Vector3.new(14, 52, 14), 13, COLORS.red},
}
for i, leaf in ipairs(canopy) do
	ball("FantasyLeafMass" .. i, Vector3.new(leaf[2] * 2, leaf[2] * 1.35, leaf[2] * 2), leaf[1], leaf[3], Enum.Material.SmoothPlastic)
end
-- Small glowing fruits make the tree memorable without blocking the view.
for i = 1, 12 do
	local a = i * math.pi * 2 / 12
	local fruit = ball("GlowFruit", Vector3.new(1.6, 1.6, 1.6), Vector3.new(math.cos(a) * 15, 57 + (i % 3) * 4, math.sin(a) * 15), COLORS.gold, Enum.Material.Neon)
	local light = Instance.new("PointLight"); light.Color = COLORS.gold; light.Range = 9; light.Brightness = 0.35; light.Parent = fruit
end
billboardText(trunk, "🐰  RABBIT GARDEN  🐰", COLORS.cream, Vector3.new(0, 26, 0))

-- Four transparent spawn pads around the tree, aligned with the four paths.
for i, data in ipairs(paths) do
	local d = data.direction
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "RabbitSpawn" .. i
	spawn.Size = Vector3.new(12, 0.5, 12)
	spawn.Position = d * 38 + Vector3.new(0, 7.1, 0)
	spawn.Transparency = 0.35
	spawn.Color = COLORS.pink
	spawn.Material = Enum.Material.Neon
	spawn.Anchored = true
	spawn.CanCollide = true
	spawn.Neutral = true
	spawn.Duration = 1
	spawn.Parent = world
	local ring = cylinder("SpawnRing" .. i, 7.2, 0.25, spawn.Position + Vector3.new(0, 0.35, 0), COLORS.gold, Enum.Material.Neon)
	ring.Transparency = 0.25
end

-- Decorative little trees around the garden perimeter.
for i = 1, 12 do
	local a = i * math.pi * 2 / 12 + math.pi / 12
	local position = Vector3.new(math.cos(a) * 50, 10, math.sin(a) * 50)
	cylinder("DecorativeTreeTrunk", 2.2, 9, position, COLORS.woodLight, Enum.Material.Wood)
	ball("DecorativeTreeCrown", Vector3.new(11, 13, 11), position + Vector3.new(0, 8, 0), i % 2 == 0 and COLORS.violet or COLORS.red, Enum.Material.Grass)
end

-- Warm lanterns at each path entrance improve navigation and screenshots.
for _, data in ipairs(paths) do
	local d = data.direction
	local p = d * 66 + Vector3.new(0, 11, 0)
	cylinder("PathLanternPost", 0.5, 8, p, COLORS.wood, Enum.Material.Wood)
	local lamp = ball("PathLantern", Vector3.new(2.4, 2.4, 2.4), p + Vector3.new(0, 5, 0), COLORS.gold, Enum.Material.Neon)
	local light = Instance.new("PointLight"); light.Color = COLORS.gold; light.Range = 20; light.Brightness = 1.2; light.Parent = lamp
end

-- Keep new players at a valid central spawn if Roblox has not selected one yet.
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local rootPart = character:WaitForChild("HumanoidRootPart", 10)
		if rootPart and not character:GetAttribute("RabbitSpawned") then
			character:SetAttribute("RabbitSpawned", true)
			rootPart.CFrame = CFrame.new(0, 10, -38)
		end
	end)
end)

print("RabbitWorld creado: árbol central, 4 spawns y 4 pasillos de 100 studs.")
