-- Rabbit Simulator: Premium Map Generator
-- Clean and valid Roblox Lua script
-- Place this in ServerScriptService and press Play

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
	grass = Color3.fromRGB(160, 220, 150),
	grassDark = Color3.fromRGB(112, 169, 94),
	grassLight = Color3.fromRGB(228, 248, 211),
	woodDark = Color3.fromRGB(77, 48, 27),
	woodMid = Color3.fromRGB(118, 77, 41),
	woodLight = Color3.fromRGB(173, 118, 74),
	gold = Color3.fromRGB(255, 217, 92),
	goldLight = Color3.fromRGB(255, 239, 170),
	pink = Color3.fromRGB(255, 190, 220),
	pinkLight = Color3.fromRGB(255, 219, 235),
	violet = Color3.fromRGB(161, 96, 204),
	violetLight = Color3.fromRGB(197, 142, 230),
	red = Color3.fromRGB(212, 62, 97),
	redLight = Color3.fromRGB(255, 119, 154),
	cream = Color3.fromRGB(255, 250, 236),
	creamDark = Color3.fromRGB(241, 233, 212),
	stone = Color3.fromRGB(233, 229, 219),
}

local function part(name, size, position, color, material, parent)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Position = position
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Anchored = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent or world
	return p
end

local function cylinder(name, radius, height, position, color, material, parent)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = Vector3.new(radius * 2, height, radius * 2)
	p.Position = position
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Shape = Enum.PartType.Cylinder
	p.Anchored = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent or world
	return p
end

local function ball(name, size, position, color, material, parent)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Position = position
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Shape = Enum.PartType.Ball
	p.Anchored = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent or world
	return p
end

local function pointLight(parent, color, range, brightness)
	local light = Instance.new("PointLight")
	light.Color = color
	light.Range = range
	light.Brightness = brightness
	light.Parent = parent
	return light
end

local function spawnLocation(name, position, size)
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = name
	spawn.Size = size or Vector3.new(12, 1, 12)
	spawn.Position = position
	spawn.Anchored = true
	spawn.CanCollide = true
	spawn.Transparency = 0.25
	spawn.Color = Color3.fromRGB(255, 210, 230)
	spawn.Material = Enum.Material.Neon
	spawn.Neutral = true
	spawn.Duration = 1
	spawn.Parent = world
	return spawn
end

-- Lighting: pastel sky and warm magical day
Lighting.ClockTime = 14.5
Lighting.Brightness = 2.3
Lighting.Ambient = Color3.fromRGB(170, 185, 215)
Lighting.OutdoorAmbient = Color3.fromRGB(205, 205, 225)
Lighting.GlobalShadows = true
Lighting.ShadowSoftness = 0.6

local sun = Instance.new("SunLight")
sun.Name = "RabbitSun"
sun.Brightness = 1.4
sun.Angle = 30
sun.Parent = Lighting

local atmosphere = Instance.new("Atmosphere")
atmosphere.Name = "RabbitAtmosphere"
atmosphere.Color = Color3.fromRGB(193, 219, 255)
atmosphere.Decay = Color3.fromRGB(255, 200, 220)
atmosphere.Density = 0.24
atmosphere.Glare = 0.1
atmosphere.Haze = 0.6
atmosphere.Parent = Lighting

local bloom = Instance.new("BloomEffect")
bloom.Intensity = 0.18
bloom.Size = 18
bloom.Threshold = 1.2
bloom.Parent = Lighting

-- Big grass island
part("IslandBase", Vector3.new(540, 12, 540), Vector3.new(0, -10, 0), COLORS.grassDark, Enum.Material.Grass)
part("IslandTop", Vector3.new(500, 3, 500), Vector3.new(0, -3, 0), COLORS.grass, Enum.Material.Grass)

-- Main circular platform
cylinder("GardenBase", 72, 6, Vector3.new(0, 3, 0), COLORS.stone, Enum.Material.Marble)
cylinder("GardenTop", 69, 1.3, Vector3.new(0, 6.5, 0), COLORS.cream, Enum.Material.Marble)
cylinder("GardenGrass", 64, 1.4, Vector3.new(0, 7.2, 0), COLORS.grassLight, Enum.Material.Grass)

-- Gold trim
cylinder("GardenTrim", 72.5, 0.9, Vector3.new(0, 5.8, 0), COLORS.gold, Enum.Material.Neon)

-- Decorative inner rings
for i = 1, 4 do
	local radius = 50 - i * 9
	local y = 7.4 + i * 0.2
	local color = i % 2 == 0 and COLORS.pink or COLORS.violet
	cylinder("GardenRing" .. i, radius, 0.25, Vector3.new(0, y, 0), color, Enum.Material.Neon)
end

-- Flowers around the garden
local flowers = {
	Vector3.new(52, 7.4, 0),
	Vector3.new(-52, 7.4, 0),
	Vector3.new(0, 7.4, 52),
	Vector3.new(0, 7.4, -52),
	Vector3.new(38, 7.4, 38),
	Vector3.new(-38, 7.4, 38),
	Vector3.new(38, 7.4, -38),
	Vector3.new(-38, 7.4, -38),
}
for i, pos in ipairs(flowers) do
	local flower = ball("Flower" .. i, Vector3.new(3.5, 3.5, 3.5), pos, i % 2 == 0 and COLORS.violet or COLORS.red, Enum.Material.SmoothPlastic)
	pointLight(flower, i % 2 == 0 and COLORS.violet or COLORS.red, 12, 0.4)
end

-- Central tree trunk
local trunk = cylinder("TreeTrunk", 12, 58, Vector3.new(0, 33, 0), COLORS.woodMid, Enum.Material.Wood)

-- Root flare
local rootFlare = cylinder("Roots", 17, 8, Vector3.new(0, 8, 0), COLORS.woodLight, Enum.Material.Wood)

-- Roots around it
for i = 1, 10 do
	local angle = (math.pi * 2 / 10) * i
	local rootPos = Vector3.new(math.cos(angle) * 16, 6.5, math.sin(angle) * 16)
	local root = cylinder("Root" .. i, 4, 4, rootPos, COLORS.woodLight, Enum.Material.Wood)
	root.CFrame = root.CFrame * CFrame.Angles(0, angle, 0)
end

-- Bark layers for wood detail
for i = 1, 8 do
	local y = 12 + i * 5.5
	cylinder("BarkLayer" .. i, 12.5 - i * 0.35, 0.5, Vector3.new(0, y, 0), COLORS.woodDark, Enum.Material.Wood)
end

-- Canopy with red + violet leaves
local leaves = {
	{Vector3.new(0, 66, 0), 28, COLORS.violet},
	{Vector3.new(0, 62, 0), 22, COLORS.red},
	{Vector3.new(-22, 61, 5), 18, COLORS.violetLight},
	{Vector3.new(22, 60, -5), 18, COLORS.redLight},
	{Vector3.new(0, 58, 20), 16, COLORS.red},
	{Vector3.new(0, 56, -20), 16, COLORS.violet},
	{Vector3.new(-18, 53, -15), 14, COLORS.redLight},
	{Vector3.new(18, 52, 15), 14, COLORS.violetLight},
	{Vector3.new(-26, 57, 0), 12, COLORS.red},
	{Vector3.new(26, 56, 0), 12, COLORS.violet},
}
for i, data in ipairs(leaves) do
	local p = ball("LeafCluster" .. i, Vector3.new(data[2] * 2, data[2] * 1.4, data[2] * 2), data[1], data[3], Enum.Material.SmoothPlastic)
	pointLight(p, data[3], 16, 0.2)
end

-- Magic fruits
for i = 1, 16 do
	local angle = (math.pi * 2 / 16) * i
	local radius = 11 + (i % 4) * 3
	local fruitPos = Vector3.new(math.cos(angle) * radius, 55 + (i % 5) * 4, math.sin(angle) * radius)
	local fruit = ball("Fruit" .. i, Vector3.new(2.3, 2.3, 2.3), fruitPos, COLORS.gold, Enum.Material.Neon)
	pointLight(fruit, COLORS.gold, 14, 0.8)
end

-- Tree top sign
local sign = Instance.new("BillboardGui")
sign.Name = "TreeSign"
sign.Size = UDim2.fromOffset(260, 60)
sign.AlwaysOnTop = true
sign.StudsOffset = Vector3.new(0, 28, 0)
sign.Parent = trunk

local label = Instance.new("TextLabel")
label.Size = UDim2.fromScale(1, 1)
label.BackgroundTransparency = 1
label.Text = "🐰 RABBIT GARDEN 🐰"
label.TextColor3 = Color3.fromRGB(255, 250, 243)
label.TextStrokeTransparency = 0.35
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.Parent = sign

-- Four paths and stairs
local pathData = {
	{ "North", Vector3.new(0, 0, -1) },
	{ "East", Vector3.new(1, 0, 0) },
	{ "South", Vector3.new(0, 0, 1) },
	{ "West", Vector3.new(-1, 0, 0) },
}

for _, data in ipairs(pathData) do
	local name, dir = data[1], data[2]
	for i = 1, 7 do
		local stepCenter = dir * (65 - i * 2.8) + Vector3.new(0, 4.4 - i * 0.4, 0)
		local step = part(name .. "Step" .. i, Vector3.new(16, 1.2, 4.6), stepCenter, COLORS.cream, Enum.Material.Marble)
		if math.abs(dir.X) > 0 then
			step.Size = Vector3.new(4.6, 1.2, 16)
		end
	end

	local path = part(name .. "Path", Vector3.new(16, 2.2, 110), dir * 114 + Vector3.new(0, 1, 0), COLORS.cream, Enum.Material.Marble)
	if math.abs(dir.X) > 0 then
		path.Size = Vector3.new(110, 2.2, 16)
	end

	-- gold edge line
	local edgeDir = Vector3.new(-dir.Z, 0, dir.X)
	local edge1 = part(name .. "Edge1", Vector3.new(2.2, 0.2, 110), dir * 114 + edgeDir * 7.5 + Vector3.new(0, 1.3, 0), COLORS.gold, Enum.Material.Neon)
	local edge2 = part(name .. "Edge2", Vector3.new(2.2, 0.2, 110), dir * 114 - edgeDir * 7.5 + Vector3.new(0, 1.3, 0), COLORS.gold, Enum.Material.Neon)
	if math.abs(dir.X) > 0 then
		edge1.Size = Vector3.new(110, 0.2, 2.2)
		edge2.Size = Vector3.new(110, 0.2, 2.2)
		edge1.Position = dir * 114 + edgeDir * 7.5 + Vector3.new(0, 1.3, 0)
		edge2.Position = dir * 114 - edgeDir * 7.5 + Vector3.new(0, 1.3, 0)
	end
end

-- Lanterns along the roads
for _, data in ipairs(pathData) do
	local name, dir = data[1], data[2]
	for i = 1, 4 do
		local pos = dir * (80 + i * 16) + Vector3.new(0, 10, 0)
		local post = cylinder(name .. "LanternPost" .. i, 0.7, 8, pos - Vector3.new(0, 4, 0), COLORS.woodMid, Enum.Material.Wood)
		local lantern = ball(name .. "Lantern" .. i, Vector3.new(3, 3, 3), pos, COLORS.goldLight, Enum.Material.Neon)
		pointLight(lantern, COLORS.gold, 20, 1.2)
	end
end

-- Decorative trees around the field
for i = 1, 14 do
	local angle = (math.pi * 2 / 14) * i
	local treePos = Vector3.new(math.cos(angle) * 58, 10, math.sin(angle) * 58)
	cylinder("DecorTreeTrunk" .. i, 2.4, 10, treePos, COLORS.woodMid, Enum.Material.Wood)
	local color = i % 2 == 0 and COLORS.violet or COLORS.red
	local crown = ball("DecorTreeCrown" .. i, Vector3.new(12, 15, 12), treePos + Vector3.new(0, 9, 0), color, Enum.Material.SmoothPlastic)
	pointLight(crown, color, 12, 0.25)
end

-- Four spawn pads around the main tree
local spawnPositions = {
	Vector3.new(0, 7.2, -40),
	Vector3.new(40, 7.2, 0),
	Vector3.new(0, 7.2, 40),
	Vector3.new(-40, 7.2, 0),
}
for i, pos in ipairs(spawnPositions) do
	local spawn = spawnLocation("RabbitSpawn" .. i, pos, Vector3.new(14, 1, 14))
	local outer = cylinder("SpawnRingOuter" .. i, 8, 0.25, pos + Vector3.new(0, 0.4, 0), COLORS.gold, Enum.Material.Neon)
	local inner = cylinder("SpawnRingInner" .. i, 6, 0.2, pos + Vector3.new(0, 0.5, 0), COLORS.pink, Enum.Material.Neon)
	pointLight(spawn, COLORS.pink, 14, 0.8)
end

-- Optional soft player spawn fallback
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local hrp = character:WaitForChild("HumanoidRootPart", 10)
		if hrp then
			hrp.CFrame = CFrame.new(0, 10, -40)
		end
	end)
end)

print("RabbitWorld premium generado correctamente: cielo bonito, árbol central, 4 spawns y 4 pasillos.")
