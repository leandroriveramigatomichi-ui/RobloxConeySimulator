-- Rabbit Simulator: Final Map Generator
-- Clean, elegant, and properly structured for Roblox
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

-- Natural color palette (no excessive contrast)
local COLORS = {
	grassDark = Color3.fromRGB(106, 168, 79),
	grassMid = Color3.fromRGB(134, 189, 102),
	grassLight = Color3.fromRGB(169, 209, 142),
	woodDark = Color3.fromRGB(92, 64, 42),
	woodMid = Color3.fromRGB(126, 89, 55),
	woodLight = Color3.fromRGB(166, 125, 83),
	stone = Color3.fromRGB(200, 195, 185),
	stoneLight = Color3.fromRGB(220, 215, 205),
	gold = Color3.fromRGB(230, 200, 90),
	goldLight = Color3.fromRGB(245, 220, 140),
	pink = Color3.fromRGB(220, 160, 190),
	pinkLight = Color3.fromRGB(240, 190, 215),
	violet = Color3.fromRGB(140, 100, 170),
	violetLight = Color3.fromRGB(170, 130, 200),
	red = Color3.fromRGB(180, 70, 110),
	redLight = Color3.fromRGB(210, 110, 150),
}

-- Helper functions
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
	spawn.Transparency = 0.2
	spawn.Color = COLORS.pink
	spawn.Material = Enum.Material.Neon
	spawn.Neutral = true
	spawn.Duration = 1
	spawn.Parent = world
	return spawn
end

-- LAYER 1: LIGHTING - Natural and balanced
Lighting.ClockTime = 14
Lighting.Brightness = 1.5
Lighting.Ambient = Color3.fromRGB(135, 145, 160)
Lighting.OutdoorAmbient = Color3.fromRGB(145, 155, 170)
Lighting.GlobalShadows = true
Lighting.ShadowSoftness = 0.4

local sun = Instance.new("SunLight")
sun.Name = "RabbitSun"
sun.Brightness = 1.0
sun.Angle = 35
sun.Parent = Lighting

local atmosphere = Instance.new("Atmosphere")
atmosphere.Name = "RabbitAtmosphere"
atmosphere.Color = Color3.fromRGB(180, 200, 220)
atmosphere.Decay = Color3.fromRGB(230, 210, 200)
atmosphere.Density = 0.2
atmosphere.Glare = 0.08
atmosphere.Haze = 0.5
atmosphere.Parent = Lighting

-- LAYER 2: TERRAIN BASE
part("IslandBase", Vector3.new(550, 15, 550), Vector3.new(0, -12, 0), COLORS.grassDark, Enum.Material.Grass)
part("IslandTop", Vector3.new(520, 2, 520), Vector3.new(0, -2.5, 0), COLORS.grassMid, Enum.Material.Grass)

-- LAYER 3: CENTRAL CIRCULAR PLATFORM
cylinder("PlatformBase", 75, 4, Vector3.new(0, 3.5, 0), COLORS.stone, Enum.Material.Marble)
cylinder("PlatformTop", 72, 1.5, Vector3.new(0, 6.5, 0), COLORS.stoneLight, Enum.Material.Marble)
cylinder("PlatformGrass", 68, 1.2, Vector3.new(0, 7.4, 0), COLORS.grassLight, Enum.Material.Grass)

-- Platform edge ring
cylinder("PlatformEdge", 75.5, 0.6, Vector3.new(0, 5.2, 0), COLORS.gold, Enum.Material.SmoothPlastic)

-- Decorative marble rings
for i = 1, 3 do
	local radius = 55 - i * 12
	cylinder("PlatformDecor" .. i, radius, 0.3, Vector3.new(0, 7.2 + i * 0.25, 0), i % 2 == 0 and COLORS.violet or COLORS.red, Enum.Material.SmoothPlastic)
end

-- Garden flowers (8 positions)
local flowerPositions = {
	Vector3.new(50, 7.8, 0),
	Vector3.new(-50, 7.8, 0),
	Vector3.new(0, 7.8, 50),
	Vector3.new(0, 7.8, -50),
	Vector3.new(35, 7.8, 35),
	Vector3.new(-35, 7.8, 35),
	Vector3.new(35, 7.8, -35),
	Vector3.new(-35, 7.8, -35),
}
for i, pos in ipairs(flowerPositions) do
	local color = i % 2 == 0 and COLORS.violetLight or COLORS.redLight
	local flower = ball("Flower" .. i, Vector3.new(3, 3, 3), pos, color, Enum.Material.SmoothPlastic)
	pointLight(flower, color, 10, 0.3)
end

-- LAYER 4: CENTRAL TREE (Main focal point)
-- Roots
cylinder("RootFlare", 18, 6, Vector3.new(0, 7.5, 0), COLORS.woodLight, Enum.Material.Wood)

for i = 1, 8 do
	local angle = (math.pi * 2 / 8) * i
	local rootPos = Vector3.new(math.cos(angle) * 14, 6, math.sin(angle) * 14)
	local root = cylinder("Root" .. i, 3.5, 3, rootPos, COLORS.woodMid, Enum.Material.Wood)
	root.CFrame = root.CFrame * CFrame.Angles(math.pi / 2, angle, 0)
end

-- Main trunk (60 studs tall)
local trunk = cylinder("TreeTrunk", 11, 60, Vector3.new(0, 34, 0), COLORS.woodMid, Enum.Material.Wood)

-- Bark texture layers
for i = 1, 7 do
	local y = 12 + i * 6
	cylinder("BarkLayer" .. i, 11.3 - i * 0.3, 0.4, Vector3.new(0, y, 0), COLORS.woodDark, Enum.Material.Wood)
end

-- Canopy: Red and Violet leaves in natural layers
local canopyLayers = {
	-- Main crown
	{Vector3.new(0, 70, 0), 26, COLORS.violet},
	{Vector3.new(0, 64, 0), 20, COLORS.red},
	-- Side clusters
	{Vector3.new(-18, 62, 3), 16, COLORS.violetLight},
	{Vector3.new(18, 61, -3), 16, COLORS.redLight},
	{Vector3.new(0, 59, 16), 14, COLORS.red},
	{Vector3.new(0, 57, -16), 14, COLORS.violet},
	-- Edge detail
	{Vector3.new(-20, 54, -12), 11, COLORS.redLight},
	{Vector3.new(20, 53, 12), 11, COLORS.violetLight},
}
for i, data in ipairs(canopyLayers) do
	ball("LeafCluster" .. i, Vector3.new(data[2] * 2, data[2] * 1.3, data[2] * 2), data[1], data[3], Enum.Material.SmoothPlastic)
end

-- Magic fruits on the canopy
for i = 1, 12 do
	local angle = (math.pi * 2 / 12) * i
	local radius = 10 + (i % 3) * 2.5
	local fruitPos = Vector3.new(math.cos(angle) * radius, 54 + (i % 4) * 4, math.sin(angle) * radius)
	local fruit = ball("Fruit" .. i, Vector3.new(1.8, 1.8, 1.8), fruitPos, COLORS.gold, Enum.Material.Neon)
	pointLight(fruit, COLORS.gold, 12, 0.5)
end

-- Tree label
local sign = Instance.new("BillboardGui")
sign.Name = "TreeSign"
sign.Size = UDim2.fromOffset(250, 50)
sign.AlwaysOnTop = true
sign.StudsOffset = Vector3.new(0, 30, 0)
sign.Parent = trunk

local label = Instance.new("TextLabel")
label.Size = UDim2.fromScale(1, 1)
label.BackgroundTransparency = 1
label.Text = "🐰 RABBIT GARDEN 🐰"
label.TextColor3 = Color3.fromRGB(60, 40, 20)
label.TextStrokeTransparency = 0.5
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.Parent = sign

-- LAYER 5: FOUR SPAWN LOCATIONS
local spawnPositions = {
	{Vector3.new(0, 7.8, -38), "North"},
	{Vector3.new(38, 7.8, 0), "East"},
	{Vector3.new(0, 7.8, 38), "South"},
	{Vector3.new(-38, 7.8, 0), "West"},
}

for i, data in ipairs(spawnPositions) do
	local pos = data[1]
	local spawn = spawnLocation("RabbitSpawn_" .. data[2], pos, Vector3.new(13, 0.8, 13))
	
	-- Spawn ring decorations
	cylinder("SpawnRing_Outer" .. i, 7.5, 0.2, pos + Vector3.new(0, 0.5, 0), COLORS.gold, Enum.Material.SmoothPlastic)
	cylinder("SpawnRing_Inner" .. i, 5.5, 0.15, pos + Vector3.new(0, 0.6, 0), COLORS.pink, Enum.Material.SmoothPlastic)
	
	pointLight(spawn, COLORS.pink, 12, 0.4)
end

-- LAYER 6: FOUR PATHS AND STAIRS (100 studs long, 15 studs wide)
local pathData = {
	{"North", Vector3.new(0, 0, -1)},
	{"East", Vector3.new(1, 0, 0)},
	{"South", Vector3.new(0, 0, 1)},
	{"West", Vector3.new(-1, 0, 0)},
}

for _, pathInfo in ipairs(pathData) do
	local pathName = pathInfo[1]
	local pathDir = pathInfo[2]
	
	-- Stairs (7 steps from platform to main path)
	for step = 1, 7 do
		local distance = 45 - step * 2.5
		local height = 7 - step * 0.4
		local stepCenter = pathDir * distance + Vector3.new(0, height - 0.6, 0)
		local stepPart = part(pathName .. "Stair" .. step, Vector3.new(15, 0.8, 3.5), stepCenter, COLORS.stoneLight, Enum.Material.Marble)
		
		if math.abs(pathDir.X) > 0 then
			stepPart.Size = Vector3.new(3.5, 0.8, 15)
		end
	end
	
	-- Main path (100 studs long, 15 studs wide)
	local pathEnd = pathDir * 115
	local pathCenterY = 1.5
	local mainPath = part(pathName .. "Path", Vector3.new(15, 2, 100), pathEnd + Vector3.new(0, pathCenterY, 0), COLORS.stoneLight, Enum.Material.Marble)
	
	if math.abs(pathDir.X) > 0 then
		mainPath.Size = Vector3.new(100, 2, 15)
	end
	
	-- Path edge lines (gold trim)
	local perpendicular = Vector3.new(-pathDir.Z, 0, pathDir.X)
	local edge1 = part(pathName .. "EdgeLeft", Vector3.new(1.5, 0.15, 100), pathEnd + perpendicular * 8 + Vector3.new(0, 2.2, 0), COLORS.gold, Enum.Material.SmoothPlastic)
	local edge2 = part(pathName .. "EdgeRight", Vector3.new(1.5, 0.15, 100), pathEnd - perpendicular * 8 + Vector3.new(0, 2.2, 0), COLORS.gold, Enum.Material.SmoothPlastic)
	
	if math.abs(pathDir.X) > 0 then
		edge1.Size = Vector3.new(100, 0.15, 1.5)
		edge2.Size = Vector3.new(100, 0.15, 1.5)
	end
end

-- LAYER 7: DECORATIVE TREES CIRCLE (border)
for i = 1, 12 do
	local angle = (math.pi * 2 / 12) * i
	local treePos = Vector3.new(math.cos(angle) * 60, 9, math.sin(angle) * 60)
	
	-- Trunk
	cylinder("DecorTreeTrunk" .. i, 2.2, 9, treePos, COLORS.woodMid, Enum.Material.Wood)
	
	-- Crown
	local crownColor = i % 2 == 0 and COLORS.red or COLORS.violet
	local crown = ball("DecorTreeCrown" .. i, Vector3.new(11, 13, 11), treePos + Vector3.new(0, 8, 0), crownColor, Enum.Material.SmoothPlastic)
	
	pointLight(crown, crownColor, 8, 0.2)
end

-- LAYER 8: PATH LANTERNS
for _, pathInfo in ipairs(pathData) do
	local pathName = pathInfo[1]
	local pathDir = pathInfo[2]
	
	for i = 1, 3 do
		local lanternPos = pathDir * (75 + i * 18) + Vector3.new(0, 9, 0)
		
		-- Post
		cylinder(pathName .. "LanternPost" .. i, 0.6, 7, lanternPos - Vector3.new(0, 3.5, 0), COLORS.woodMid, Enum.Material.Wood)
		
		-- Lantern light
		local lantern = ball(pathName .. "Lantern" .. i, Vector3.new(2.5, 2.5, 2.5), lanternPos, COLORS.goldLight, Enum.Material.SmoothPlastic)
		pointLight(lantern, COLORS.gold, 18, 0.6)
	end
end

-- Player spawn handling
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local hrp = character:WaitForChild("HumanoidRootPart", 10)
		if hrp then
			hrp.CFrame = CFrame.new(0, 10, -38)
		end
	end)
end)

print("✓ RabbitWorld Final: Mapa completado correctamente")
print("✓ Componentes: Plataforma circular, Árbol central, 4 Spawns, 4 Pasillos (100x15 studs)")
