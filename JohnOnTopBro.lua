--==================================================
-- JOHNONTOP HUB 👑
-- EGG SPAWNER + PLAYER SPAWNER
-- SERVER-SIDE
--==================================================

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--==================================================
-- SETTINGS
--==================================================

local HUB_NAME = "JohnOnTop Hub 👑"
local EGG_FOLDER_NAME = "Eggs"
local SPAWN_FOLDER_NAME = "EggSpawnPoints"
local ACTIVE_FOLDER_NAME = "SpawnedEggs"
local REMOTE_NAME = "JohnOnTopEggSpawner"

local CIRCLE_IMAGE = "rbxassetid://134112829099529"

--==================================================
-- FOLDERS
--==================================================

local EggsFolder = ServerStorage:FindFirstChild(EGG_FOLDER_NAME)

if not EggsFolder then
	EggsFolder = Instance.new("Folder")
	EggsFolder.Name = EGG_FOLDER_NAME
	EggsFolder.Parent = ServerStorage
end

local SpawnPoints = workspace:FindFirstChild(SPAWN_FOLDER_NAME)

if not SpawnPoints then
	SpawnPoints = Instance.new("Folder")
	SpawnPoints.Name = SPAWN_FOLDER_NAME
	SpawnPoints.Parent = workspace
end

local SpawnedEggs = workspace:FindFirstChild(ACTIVE_FOLDER_NAME)

if not SpawnedEggs then
	SpawnedEggs = Instance.new("Folder")
	SpawnedEggs.Name = ACTIVE_FOLDER_NAME
	SpawnedEggs.Parent = workspace
end

--==================================================
-- REMOTE
--==================================================

local Remote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)

if not Remote then
	Remote = Instance.new("RemoteEvent")
	Remote.Name = REMOTE_NAME
	Remote.Parent = ReplicatedStorage
end

--==================================================
-- STATE
--==================================================

local LastSpawnedEgg = {}
local LastEggOwner = {}

--==================================================
-- HELPERS
--==================================================

local function getSpawnPoints()
	local points = {}

	for _, obj in ipairs(SpawnPoints:GetChildren()) do
		if obj:IsA("BasePart") then
			table.insert(points, obj)
		end
	end

	return points
end

local function getEggTemplates()
	local eggs = {}

	for _, obj in ipairs(EggsFolder:GetChildren()) do
		if obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("Tool") then
			table.insert(eggs, obj)
		end
	end

	table.sort(eggs, function(a, b)
		return a.Name:lower() < b.Name:lower()
	end)

	return eggs
end

local function moveObjectTo(obj, cf)
	if obj:IsA("Model") then
		if obj.PrimaryPart then
			obj:PivotTo(cf)
		else
			local part = obj:FindFirstChildWhichIsA("BasePart", true)

			if part then
				obj.PrimaryPart = part
				obj:PivotTo(cf)
			end
		end
	elseif obj:IsA("BasePart") then
		obj.CFrame = cf
	elseif obj:IsA("Tool") then
		local handle = obj:FindFirstChild("Handle")

		if handle and handle:IsA("BasePart") then
			handle.CFrame = cf
		end
	end
end

local function getObjectPosition(obj)
	if obj:IsA("Model") then
		return obj:GetPivot().Position
	elseif obj:IsA("BasePart") then
		return obj.Position
	elseif obj:IsA("Tool") then
		local handle = obj:FindFirstChild("Handle")

		if handle and handle:IsA("BasePart") then
			return handle.Position
		end
	end

	return nil
end

--==================================================
-- SPAWN EGG
--==================================================

local function spawnEgg(player, eggName)
	if typeof(eggName) ~= "string" then
		return nil
	end

	local template = EggsFolder:FindFirstChild(eggName)

	if not template then
		return nil
	end

	local points = getSpawnPoints()

	if #points == 0 then
		warn("JohnOnTop: No parts found inside Workspace.EggSpawnPoints")
		return nil
	end

	-- Remove previous egg spawned by this player
	local oldEgg = LastSpawnedEgg[player]

	if oldEgg and oldEgg.Parent then
		oldEgg:Destroy()
	end

	local newEgg = template:Clone()
	newEgg.Name = eggName
	newEgg.Parent = SpawnedEggs

	local point = points[math.random(1, #points)]

	moveObjectTo(
		newEgg,
		point.CFrame + Vector3.new(0, 3, 0)
	)

	LastSpawnedEgg[player] = newEgg
	LastEggOwner[player] = player

	return newEgg
end

--==================================================
-- SPAWN PLAYER TO EGG
--==================================================

local function spawnPlayerToEgg(admin, username)
	if typeof(username) ~= "string" then
		return false
	end

	username = username:gsub("^%s+", ""):gsub("%s+$", "")

	if username == "" then
		return false
	end

	local target = Players:FindFirstChild(username)

	if not target then
		-- Try username ignoring capitalization
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Name:lower() == username:lower() then
				target = p
				break
			end
		end
	end

	if not target then
		return false
	end

	local egg = LastSpawnedEgg[admin]

	if not egg or not egg.Parent then
		return false
	end

	local eggPosition = getObjectPosition(egg)

	if not eggPosition then
		return false
	end

	local character = target.Character

	if not character then
		target:LoadCharacter()
		character = target.Character or target.CharacterAdded:Wait()
	end

	local root = character:FindFirstChild("HumanoidRootPart")

	if not root then
		return false
	end

	-- Spawn the player beside the exact egg
	root.CFrame = CFrame.new(
		eggPosition + Vector3.new(0, 3, 4)
	)

	--==================================================
	-- GENERIC STEAL
	--==================================================
	-- If the egg is a Tool, give the exact egg to the player.
	-- Otherwise, create an inventory folder and put a copy there.
	-- The world egg is then removed.

	local stolenEgg = egg:Clone()

	local backpack = target:FindFirstChildOfClass("Backpack")

	if stolenEgg:IsA("Tool") and backpack then
		stolenEgg.Parent = backpack
	else
		local inventory = target:FindFirstChild("EggInventory")

		if not inventory then
			inventory = Instance.new("Folder")
			inventory.Name = "EggInventory"
			inventory.Parent = target
		end

		stolenEgg.Parent = inventory
	end

	egg:Destroy()

	LastSpawnedEgg[admin] = nil
	LastEggOwner[admin] = nil

	return true
end

--==================================================
-- GUI
--==================================================

local function createGUI(player)

	local playerGui = player:WaitForChild("PlayerGui")

	local old = playerGui:FindFirstChild("JohnOnTopHub")

	if old then
		old:Destroy()
	end

	--==================================================
	-- LOADING SCREEN
	--==================================================

	local LoadingGui = Instance.new("ScreenGui")
	LoadingGui.Name = "JohnOnTopLoading"
	LoadingGui.ResetOnSpawn = false
	LoadingGui.IgnoreGuiInset = true
	LoadingGui.DisplayOrder = 2147483647
	LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	LoadingGui.Parent = playerGui

	local LoadingFrame = Instance.new("Frame")
	LoadingFrame.Size = UDim2.fromScale(1, 1)
	LoadingFrame.BackgroundColor3 = Color3.fromRGB(8, 18, 35)
	LoadingFrame.BorderSizePixel = 0
	LoadingFrame.ZIndex = 200
	LoadingFrame.Parent = LoadingGui

	local Title = Instance.new("TextLabel")
	Title.BackgroundTransparency = 1
	Title.AnchorPoint = Vector2.new(0.5, 0.5)
	Title.Position = UDim2.fromScale(0.5, 0.42)
	Title.Size = UDim2.new(0, 500, 0, 50)
	Title.Font = Enum.Font.GothamBold
	Title.Text = "JOHN ON TOP 👑"
	Title.TextColor3 = Color3.fromRGB(70, 200, 255)
	Title.TextSize = 30
	Title.ZIndex = 201
	Title.Parent = LoadingFrame

	local LoadingText = Instance.new("TextLabel")
	LoadingText.BackgroundTransparency = 1
	LoadingText.AnchorPoint = Vector2.new(0.5, 0.5)
	LoadingText.Position = UDim2.fromScale(0.5, 0.49)
	LoadingText.Size = UDim2.new(0, 500, 0, 30)
	LoadingText.Font = Enum.Font.Gotham
	LoadingText.Text = "Starting..."
	LoadingText.TextColor3 = Color3.fromRGB(200, 220, 235)
	LoadingText.TextSize = 15
	LoadingText.ZIndex = 201
	LoadingText.Parent = LoadingFrame

	local Percent = Instance.new("TextLabel")
	Percent.BackgroundTransparency = 1
	Percent.AnchorPoint = Vector2.new(0.5, 0.5)
	Percent.Position = UDim2.fromScale(0.5, 0.54)
	Percent.Size = UDim2.new(0, 500, 0, 25)
	Percent.Font = Enum.Font.GothamBold
	Percent.Text = "0%"
	Percent.TextColor3 = Color3.fromRGB(70, 200, 255)
	Percent.TextSize = 14
	Percent.ZIndex = 201
	Percent.Parent = LoadingFrame

	local BarBackground = Instance.new("Frame")
	BarBackground.AnchorPoint = Vector2.new(0.5, 0.5)
	BarBackground.Position = UDim2.fromScale(0.5, 0.59)
	BarBackground.Size = UDim2.new(0, 400, 0, 12)
	BarBackground.BackgroundColor3 = Color3.fromRGB(25, 40, 55)
	BarBackground.BorderSizePixel = 0
	BarBackground.ZIndex = 201
	BarBackground.Parent = LoadingFrame

	local BarCorner = Instance.new("UICorner")
	BarCorner.CornerRadius = UDim.new(1, 0)
	BarCorner.Parent = BarBackground

	local Bar = Instance.new("Frame")
	Bar.Size = UDim2.new(0, 0, 1, 0)
	Bar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	Bar.BorderSizePixel = 0
	Bar.ZIndex = 202
	Bar.Parent = BarBackground

	local BarFillCorner = Instance.new("UICorner")
	BarFillCorner.CornerRadius = UDim.new(1, 0)
	BarFillCorner.Parent = Bar

	--==================================================
	-- MAIN GUI
	--==================================================

	local Gui = Instance.new("ScreenGui")
	Gui.Name = "JohnOnTopHub"
	Gui.ResetOnSpawn = false
	Gui.IgnoreGuiInset = true
	Gui.DisplayOrder = 999999
	Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	Gui.Parent = playerGui

	local Main = Instance.new("Frame")
	Main.Name = "MainFrame"
	Main.Size = UDim2.new(0, 350, 0, 470)
	Main.Position = UDim2.new(1, -370, 0.5, -235)
	Main.BackgroundColor3 = Color3.fromRGB(8, 18, 35)
	Main.BorderSizePixel = 0
	Main.Visible = false
	Main.Active = true
	Main.Draggable = true
	Main.Parent = Gui

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 14)
	MainCorner.Parent = Main

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(0, 170, 255)
	Stroke.Thickness = 1.5
	Stroke.Transparency = 0.25
	Stroke.Parent = Main

	--==================================================
	-- TOP BAR
	--==================================================

	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 65)
	TopBar.BackgroundColor3 = Color3.fromRGB(10, 30, 55)
	TopBar.BorderSizePixel = 0
	TopBar.Parent = Main

	local TopCorner = Instance.new("UICorner")
	TopCorner.CornerRadius = UDim.new(0, 14)
	TopCorner.Parent = TopBar

	local HubTitle = Instance.new("TextLabel")
	HubTitle.BackgroundTransparency = 1
	HubTitle.Position = UDim2.new(0, 18, 0, 8)
	HubTitle.Size = UDim2.new(1, -70, 0, 25)
	HubTitle.Font = Enum.Font.GothamBold
	HubTitle.Text = "JohnOnTop Hub 👑"
	HubTitle.TextColor3 = Color3.fromRGB(70, 200, 255)
	HubTitle.TextSize = 19
	HubTitle.TextXAlignment = Enum.TextXAlignment.Left
	HubTitle.Parent = TopBar

	local Subtitle = Instance.new("TextLabel")
	Subtitle.BackgroundTransparency = 1
	Subtitle.Position = UDim2.new(0, 19, 0, 34)
	Subtitle.Size = UDim2.new(1, -70, 0, 20)
	Subtitle.Font = Enum.Font.Gotham
	Subtitle.Text = "EGG SPAWNER"
	Subtitle.TextColor3 = Color3.fromRGB(140, 165, 185)
	Subtitle.TextSize = 11
	Subtitle.TextXAlignment = Enum.TextXAlignment.Left
	Subtitle.Parent = TopBar

	local Close = Instance.new("TextButton")
	Close.Size = UDim2.new(0, 38, 0, 38)
	Close.Position = UDim2.new(1, -50, 0, 13)
	Close.BackgroundColor3 = Color3.fromRGB(0, 120, 210)
	Close.BorderSizePixel = 0
	Close.Text = "×"
	Close.TextColor3 = Color3.new(1, 1, 1)
	Close.Font = Enum.Font.GothamBold
	Close.TextSize = 25
	Close.Parent = TopBar

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 9)
	CloseCorner.Parent = Close

	--==================================================
	-- EGG NAME
	--==================================================

	local EggLabel = Instance.new("TextLabel")
	EggLabel.BackgroundTransparency = 1
	EggLabel.Position = UDim2.new(0, 16, 0, 80)
	EggLabel.Size = UDim2.new(1, -32, 0, 20)
	EggLabel.Font = Enum.Font.GothamBold
	EggLabel.Text = "EGG NAME"
	EggLabel.TextColor3 = Color3.fromRGB(180, 205, 225)
	EggLabel.TextSize = 12
	EggLabel.TextXAlignment = Enum.TextXAlignment.Left
	EggLabel.Parent = Main

	local EggInput = Instance.new("TextBox")
	EggInput.Size = UDim2.new(1, -32, 0, 38)
	EggInput.Position = UDim2.new(0, 16, 0, 103)
	EggInput.BackgroundColor3 = Color3.fromRGB(15, 30, 48)
	EggInput.BorderSizePixel = 0
	EggInput.PlaceholderText = "Enter egg name..."
	EggInput.PlaceholderColor3 = Color3.fromRGB(100, 125, 145)
	EggInput.Text = ""
	EggInput.TextColor3 = Color3.new(1, 1, 1)
	EggInput.Font = Enum.Font.Gotham
	EggInput.TextSize = 13
	EggInput.ClearTextOnFocus = false
	EggInput.Parent = Main

	local EggInputCorner = Instance.new("UICorner")
	EggInputCorner.CornerRadius = UDim.new(0, 8)
	EggInputCorner.Parent = EggInput

	--==================================================
	-- EGG LIST
	--==================================================

	local ListTitle = Instance.new("TextLabel")
	ListTitle.BackgroundTransparency = 1
	ListTitle.Position = UDim2.new(0, 16, 0, 150)
	ListTitle.Size = UDim2.new(1, -32, 0, 20)
	ListTitle.Font = Enum.Font.GothamBold
	ListTitle.Text = "EGGS"
	ListTitle.TextColor3 = Color3.fromRGB(180, 205, 225)
	ListTitle.TextSize = 12
	ListTitle.TextXAlignment = Enum.TextXAlignment.Left
	ListTitle.Parent = Main

	local EggList = Instance.new("ScrollingFrame")
	EggList.Size = UDim2.new(1, -32, 0, 115)
	EggList.Position = UDim2.new(0, 16, 0, 174)
	EggList.BackgroundColor3 = Color3.fromRGB(12, 25, 40)
	EggList.BorderSizePixel = 0
	EggList.ScrollBarThickness = 4
	EggList.CanvasSize = UDim2.new()
	EggList.Parent = Main

	local ListCorner = Instance.new("UICorner")
	ListCorner.CornerRadius = UDim.new(0, 8)
	ListCorner.Parent = EggList

	local ListLayout = Instance.new("UIListLayout")
	ListLayout.Padding = UDim.new(0, 5)
	ListLayout.Parent = EggList

	local Selected = Instance.new("TextLabel")
	Selected.Size = UDim2.new(1, -32, 0, 30)
	Selected.Position = UDim2.new(0, 16, 0, 298)
	Selected.BackgroundTransparency = 1
	Selected.Font = Enum.Font.GothamBold
	Selected.Text = "Selected: None"
	Selected.TextColor3 = Color3.fromRGB(70, 200, 255)
	Selected.TextSize = 12
	Selected.TextXAlignment = Enum.TextXAlignment.Left
	Selected.Parent = Main

	--==================================================
	-- SPAWN EGG BUTTON
	--==================================================

	local SpawnEgg = Instance.new("TextButton")
	SpawnEgg.Size = UDim2.new(1, -32, 0, 42)
	SpawnEgg.Position = UDim2.new(0, 16, 0, 330)
	SpawnEgg.BackgroundColor3 = Color3.fromRGB(0, 130, 220)
	SpawnEgg.BorderSizePixel = 0
	SpawnEgg.Text = "SPAWN EGG"
	SpawnEgg.TextColor3 = Color3.new(1, 1, 1)
	SpawnEgg.Font = Enum.Font.GothamBold
	SpawnEgg.TextSize = 13
	SpawnEgg.Parent = Main

	local SpawnCorner = Instance.new("UICorner")
	SpawnCorner.CornerRadius = UDim.new(0, 9)
	SpawnCorner.Parent = SpawnEgg

	--==================================================
	-- PLAYER INPUT
	--==================================================

	local PlayerLabel = Instance.new("TextLabel")
	PlayerLabel.BackgroundTransparency = 1
	PlayerLabel.Position = UDim2.new(0, 16, 0, 382)
	PlayerLabel.Size = UDim2.new(1, -32, 0, 20)
	PlayerLabel.Font = Enum.Font.GothamBold
	PlayerLabel.Text = "PLAYER"
	PlayerLabel.TextColor3 = Color3.fromRGB(180, 205, 225)
	PlayerLabel.TextSize = 12
	PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
	PlayerLabel.Parent = Main

	local PlayerInput = Instance.new("TextBox")
	PlayerInput.Size = UDim2.new(1, -32, 0, 38)
	PlayerInput.Position = UDim2.new(0, 16, 0, 405)
	PlayerInput.BackgroundColor3 = Color3.fromRGB(15, 30, 48)
	PlayerInput.BorderSizePixel = 0
	PlayerInput.PlaceholderText = "Enter username..."
	PlayerInput.PlaceholderColor3 = Color3.fromRGB(100, 125, 145)
	PlayerInput.Text = ""
	PlayerInput.TextColor3 = Color3.new(1, 1, 1)
	PlayerInput.Font = Enum.Font.Gotham
	PlayerInput.TextSize = 13
	PlayerInput.ClearTextOnFocus = false
	PlayerInput.Parent = Main

	local PlayerCorner = Instance.new("UICorner")
	PlayerCorner.CornerRadius = UDim.new(0, 8)
	PlayerCorner.Parent = PlayerInput

	--==================================================
	-- SPAWN PLAYER BUTTON
	--==================================================

	local SpawnPlayer = Instance.new("TextButton")
	SpawnPlayer.Size = UDim2.new(1, -32, 0, 42)
	SpawnPlayer.Position = UDim2.new(0, 16, 0, 450)
	SpawnPlayer.BackgroundColor3 = Color3.fromRGB(35, 180, 100)
	SpawnPlayer.BorderSizePixel = 0
	SpawnPlayer.Text = "SPAWN PLAYER TO EGG"
	SpawnPlayer.TextColor3 = Color3.new(1, 1, 1)
	SpawnPlayer.Font = Enum.Font.GothamBold
	SpawnPlayer.TextSize = 12
	SpawnPlayer.Parent = Main

	local PlayerButtonCorner = Instance.new("UICorner")
	PlayerButtonCorner.CornerRadius = UDim.new(0, 9)
	PlayerButtonCorner.Parent = SpawnPlayer

	-- Increase frame slightly because of button
	Main.Size = UDim2.new(0, 350, 0, 510)
	Main.Position = UDim2.new(1, -370, 0.5, -255)

	--==================================================
	-- CIRCLE BUTTON
	--==================================================

	local Circle = Instance.new("ImageButton")
	Circle.Size = UDim2.new(0, 55, 0, 55)
	Circle.Position = UDim2.new(1, -75, 0.5, -27)
	Circle.BackgroundColor3 = Color3.fromRGB(8, 18, 35)
	Circle.BorderSizePixel = 0
	Circle.Image = CIRCLE_IMAGE
	Circle.Visible = false
	Circle.Active = true
	Circle.Draggable = true
	Circle.Parent = Gui

	local CircleCorner = Instance.new("UICorner")
	CircleCorner.CornerRadius = UDim.new(1, 0)
	CircleCorner.Parent = Circle

	local CircleStroke = Instance.new("UIStroke")
	CircleStroke.Color = Color3.fromRGB(0, 170, 255)
	CircleStroke.Thickness = 2
	CircleStroke.Parent = Circle

	--==================================================
	-- LIST REFRESH
	--==================================================

	local function refreshList(filter)
		for _, child in ipairs(EggList:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end

		filter = (filter or ""):lower()

		for _, egg in ipairs(getEggTemplates()) do
			if filter == "" or egg.Name:lower():find(filter, 1, true) then

				local Button = Instance.new("TextButton")
				Button.Size = UDim2.new(1, -8, 0, 30)
				Button.BackgroundColor3 = Color3.fromRGB(18, 38, 58)
				Button.BorderSizePixel = 0
				Button.Text = egg.Name
				Button.TextColor3 = Color3.fromRGB(220, 235, 245)
				Button.Font = Enum.Font.Gotham
				Button.TextSize = 12
				Button.Parent = EggList

				local Corner = Instance.new("UICorner")
				Corner.CornerRadius = UDim.new(0, 6)
				Corner.Parent = Button

				Button.MouseButton1Click:Connect(function()
					EggInput.Text = egg.Name
					Selected.Text = "Selected: " .. egg.Name
				end)
			end
		end

		task.wait()

		EggList.CanvasSize = UDim2.new(
			0,
			0,
			0,
			ListLayout.AbsoluteContentSize.Y + 8
		)
	end

	EggInput:GetPropertyChangedSignal("Text"):Connect(function()
		refreshList(EggInput.Text)
	end)

	--==================================================
	-- BUTTONS
	--==================================================

	SpawnEgg.MouseButton1Click:Connect(function()
		Remote:FireServer(
			"Spawn",
			EggInput.Text
		)
	end)

	SpawnPlayer.MouseButton1Click:Connect(function()
		Remote:FireServer(
			"SpawnPlayer",
			PlayerInput.Text
		)
	end)

	Close.MouseButton1Click:Connect(function()
		Main.Visible = false
		Circle.Visible = true
	end)

	Circle.MouseButton1Click:Connect(function()
		Main.Visible = true
		Circle.Visible = false
	end)

	--==================================================
	-- LOADING
	--==================================================

	task.spawn(function()

		local steps = {
			"Loading interface...",
			"Loading egg list...",
			"Loading spawn system...",
			"Loading player system...",
			"Starting JohnOnTop Hub...",
			"Ready!"
		}

		for i, text in ipairs(steps) do
			LoadingText.Text = text

			local percent = math.floor(
				(i / #steps) * 100
			)

			Percent.Text = percent .. "%"

			Bar:Tween
