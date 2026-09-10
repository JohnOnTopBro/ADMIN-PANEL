--==================================================
-- JOHNONTOP HUB 👑
-- EGG SPAWNER + RANDOM EGG STEALER
-- FULL GUI + TOP LOADING SCREEN
--==================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local REMOTE_NAME = "JohnOnTopEggSpawner"
local CIRCLE_IMAGE = "rbxassetid://134112829099529"

local Remote = ReplicatedStorage:WaitForChild(REMOTE_NAME)

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "JohnOnTopHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
Gui.DisplayOrder = 999999
Gui.Parent = PlayerGui

--==================================================
-- LOADING SCREEN
--==================================================

local Loading = Instance.new("Frame")
Loading.Name = "LoadingScreen"
Loading.Size = UDim2.fromScale(1, 1)
Loading.Position = UDim2.fromScale(0, 0)
Loading.BackgroundColor3 = Color3.fromRGB(8, 18, 35)
Loading.BorderSizePixel = 0
Loading.ZIndex = 10000
Loading.Parent = Gui

local LoadTitle = Instance.new("TextLabel")
LoadTitle.BackgroundTransparency = 1
LoadTitle.Size = UDim2.new(1, 0, 0, 50)
LoadTitle.Position = UDim2.new(0, 0, 0.36, 0)
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.Text = "JOHN ON TOP 👑"
LoadTitle.TextColor3 = Color3.fromRGB(70, 200, 255)
LoadTitle.TextSize = 28
LoadTitle.ZIndex = 10001
LoadTitle.Parent = Loading

local LoadText = Instance.new("TextLabel")
LoadText.BackgroundTransparency = 1
LoadText.Size = UDim2.new(1, 0, 0, 30)
LoadText.Position = UDim2.new(0, 0, 0.46, 0)
LoadText.Font = Enum.Font.Gotham
LoadText.Text = "Starting..."
LoadText.TextColor3 = Color3.fromRGB(210, 225, 240)
LoadText.TextSize = 15
LoadText.ZIndex = 10001
LoadText.Parent = Loading

local Percent = Instance.new("TextLabel")
Percent.BackgroundTransparency = 1
Percent.Size = UDim2.new(1, 0, 0, 25)
Percent.Position = UDim2.new(0, 0, 0.51, 0)
Percent.Font = Enum.Font.GothamBold
Percent.Text = "0%"
Percent.TextColor3 = Color3.fromRGB(70, 200, 255)
Percent.TextSize = 14
Percent.ZIndex = 10001
Percent.Parent = Loading

local BarBack = Instance.new("Frame")
BarBack.Size = UDim2.new(0, 400, 0, 12)
BarBack.Position = UDim2.new(0.5, -200, 0.57, 0)
BarBack.BackgroundColor3 = Color3.fromRGB(25, 40, 60)
BarBack.BorderSizePixel = 0
BarBack.ZIndex = 10001
BarBack.Parent = Loading

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(0, 6)
BarCorner.Parent = BarBack

local Bar = Instance.new("Frame")
Bar.Size = UDim2.new(0, 0, 1, 0)
Bar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Bar.BorderSizePixel = 0
Bar.ZIndex = 10002
Bar.Parent = BarBack

local BarFillCorner = Instance.new("UICorner")
BarFillCorner.CornerRadius = UDim.new(0, 6)
BarFillCorner.Parent = Bar

--==================================================
-- MAIN FRAME
--==================================================

local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 340, 0, 430)
Main.Position = UDim2.new(1, -360, 0.5, -215)
Main.BackgroundColor3 = Color3.fromRGB(8, 18, 35)
Main.BorderSizePixel = 0
Main.Visible = false
Main.ZIndex = 10
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 170, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.25
MainStroke.Parent = Main

--==================================================
-- TOP BAR
--==================================================

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 65)
Top.BackgroundColor3 = Color3.fromRGB(10, 30, 55)
Top.BorderSizePixel = 0
Top.ZIndex = 11
Top.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 14)
TopCorner.Parent = Top

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 18, 0, 8)
Title.Size = UDim2.new(1, -70, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "JohnOnTop Hub 👑"
Title.TextColor3 = Color3.fromRGB(70, 200, 255)
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Top

local Subtitle = Instance.new("TextLabel")
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 19, 0, 34)
Subtitle.Size = UDim2.new(1, -70, 0, 20)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "EGG SPAWNER"
Subtitle.TextColor3 = Color3.fromRGB(150, 175, 200)
Subtitle.TextSize = 11
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 12
Subtitle.Parent = Top

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 38, 0, 38)
Close.Position = UDim2.new(1, -49, 0, 13)
Close.BackgroundColor3 = Color3.fromRGB(20, 80, 125)
Close.BorderSizePixel = 0
Close.Font = Enum.Font.GothamBold
Close.Text = "×"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.TextSize = 22
Close.ZIndex = 13
Close.Parent = Top

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = Close

--==================================================
-- HELPER
--==================================================

local function makeLabel(text, y)
	local L = Instance.new("TextLabel")
	L.BackgroundTransparency = 1
	L.Position = UDim2.new(0, 18, 0, y)
	L.Size = UDim2.new(1, -36, 0, 22)
	L.Font = Enum.Font.GothamBold
	L.Text = text
	L.TextColor3 = Color3.fromRGB(190, 210, 230)
	L.TextSize = 12
	L.TextXAlignment = Enum.TextXAlignment.Left
	L.ZIndex = 12
	L.Parent = Main
	return L
end

local function makeBox(y, placeholder)
	local B = Instance.new("TextBox")
	B.Size = UDim2.new(1, -36, 0, 38)
	B.Position = UDim2.new(0, 18, 0, y)
	B.BackgroundColor3 = Color3.fromRGB(15, 30, 48)
	B.BorderSizePixel = 0
	B.ClearTextOnFocus = false
	B.Font = Enum.Font.Gotham
	B.PlaceholderText = placeholder
	B.PlaceholderColor3 = Color3.fromRGB(100, 125, 150)
	B.Text = ""
	B.TextColor3 = Color3.fromRGB(235, 245, 255)
	B.TextSize = 13
	B.ZIndex = 12
	B.Parent = Main

	local C = Instance.new("UICorner")
	C.CornerRadius = UDim.new(0, 9)
	C.Parent = B

	local S = Instance.new("UIStroke")
	S.Color = Color3.fromRGB(0, 130, 210)
	S.Transparency = 0.45
	S.Parent = B

	return B
end

local function makeButton(text, y)
	local B = Instance.new("TextButton")
	B.Size = UDim2.new(1, -36, 0, 40)
	B.Position = UDim2.new(0, 18, 0, y)
	B.BackgroundColor3 = Color3.fromRGB(0, 125, 210)
	B.BorderSizePixel = 0
	B.Font = Enum.Font.GothamBold
	B.Text = text
	B.TextColor3 = Color3.new(1, 1, 1)
	B.TextSize = 13
	B.ZIndex = 12
	B.Parent = Main

	local C = Instance.new("UICorner")
	C.CornerRadius = UDim.new(0, 9)
	C.Parent = B

	return B
end

--==================================================
-- EGG SECTION
--==================================================

makeLabel("EGG NAME", 82)

local EggBox = makeBox(106, "Enter exact egg name")

local EggList = Instance.new("ScrollingFrame")
EggList.Size = UDim2.new(1, -36, 0, 85)
EggList.Position = UDim2.new(0, 18, 0, 151)
EggList.BackgroundColor3 = Color3.fromRGB(12, 26, 43)
EggList.BorderSizePixel = 0
EggList.ScrollBarThickness = 4
EggList.CanvasSize = UDim2.new()
EggList.ZIndex = 12
EggList.Parent = Main

local EggListCorner = Instance.new("UICorner")
EggListCorner.CornerRadius = UDim.new(0, 9)
EggListCorner.Parent = EggList

local EggLayout = Instance.new("UIListLayout")
EggLayout.Padding = UDim.new(0, 4)
EggLayout.Parent = EggList

local SpawnEgg = makeButton("SPAWN EGG", 245)

--==================================================
-- PLAYER SECTION
--==================================================

makeLabel("PLAYER", 295)

local PlayerBox = makeBox(319, "Enter username")

local StealButton = makeButton("RANDOM EGG → PLAYER", 365)

--==================================================
-- STATUS
--==================================================

local Status = Instance.new("TextLabel")
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0, 18, 1, -25)
Status.Size = UDim2.new(1, -36, 0, 18)
Status.Font = Enum.Font.Gotham
Status.Text = "Ready."
Status.TextColor3 = Color3.fromRGB(130, 190, 225)
Status.TextSize = 11
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.ZIndex = 12
Status.Parent = Main

--==================================================
-- FLOATING BUTTON
--==================================================

local Circle = Instance.new("ImageButton")
Circle.Name = "FloatingButton"
Circle.Size = UDim2.new(0, 55, 0, 55)
Circle.Position = UDim2.new(1, -75, 0.5, -27)
Circle.BackgroundColor3 = Color3.fromRGB(8, 30, 50)
Circle.BorderSizePixel = 0
Circle.Image = CIRCLE_IMAGE
Circle.Visible = false
Circle.ZIndex = 50
Circle.Parent = Gui

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = Circle

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Color = Color3.fromRGB(0, 170, 255)
CircleStroke.Thickness = 2
CircleStroke.Parent = Circle

--==================================================
-- EGG LIST REFRESH
--==================================================

local function refreshEggList()
	for _, v in ipairs(EggList:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end

	local folder = workspace:FindFirstChild("SpawnedEggs")

	if not folder then
		EggList.CanvasSize = UDim2.new(0, 0, 0, 0)
		return
	end

	for _, egg in ipairs(folder:GetChildren()) do
		local Button = Instance.new("TextButton")
		Button.Size = UDim2.new(1, -8, 0, 28)
		Button.BackgroundColor3 = Color3.fromRGB(20, 45, 68)
		Button.BorderSizePixel = 0
		Button.Font = Enum.Font.Gotham
		Button.Text = egg.Name
		Button.TextColor3 = Color3.fromRGB(220, 235, 250)
		Button.TextSize = 12
		Button.ZIndex = 13
		Button.Parent = EggList

		local C = Instance.new("UICorner")
		C.CornerRadius = UDim.new(0, 6)
		C.Parent = Button

		Button.MouseButton1Click:Connect(function()
			EggBox.Text = egg.Name
			Status.Text = "Selected: " .. egg.Name
		end)
	end

	EggList.CanvasSize = UDim2.new(0, 0, 0, EggLayout.AbsoluteContentSize.Y + 5)
end

--==================================================
-- BUTTON ACTIONS
--==================================================

SpawnEgg.MouseButton1Click:Connect(function()
	local Name = EggBox.Text:gsub("^%s+", ""):gsub("%s+$", "")

	if Name == "" then
		Status.Text = "Enter an egg name."
		return
	end

	Status.Text = "Spawning " .. Name .. "..."
	Remote:FireServer("Spawn", Name)

	task.wait(0.2)
	refreshEggList()

	Status.Text = "Egg spawned."
end)

StealButton.MouseButton1Click:Connect(function()
	local Name = PlayerBox.Text:gsub("^%s+", ""):gsub("%s+$", "")

	if Name == "" then
		Status.Text = "Enter a username."
		return
	end

	Status.Text = "Finding random spawned egg..."
	Remote:FireServer("SpawnPlayer", Name)

	task.wait(0.2)
	refreshEggList()

	Status.Text = "Player sent to random egg."
end)

--==================================================
-- CLOSE / OPEN
--==================================================

Close.MouseButton1Click:Connect(function()
	Main.Visible = false
	Circle.Visible = true
end)

Circle.MouseButton1Click:Connect(function()
	Main.Visible = true
	Circle.Visible = false
end)

--==================================================
-- DRAGGING
--==================================================

local function drag(Frame)
	local dragging = false
	local dragStart
	local startPos

	Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragStart = input.Position
			startPos = Frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if not dragging then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			local delta = input.Position - dragStart

			Frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

drag(Main)
drag(Circle)

--==================================================
-- REFRESH WHEN EGGS CHANGE
--==================================================

task.spawn(function()
	while Gui.Parent do
		refreshEggList()
		task.wait(1)
	end
end)

--==================================================
-- LOADING
--==================================================

task.spawn(function()
	local steps = {
		"Loading interface...",
		"Checking player...",
		"Loading egg system...",
		"Loading spawn system...",
		"Loading random egg system...",
		"Starting JohnOnTop Hub...",
		"Ready!"
	}

	for i, text in ipairs(steps) do
		LoadText.Text = text

		local percent = math.floor((i / #steps) * 100)
		Percent.Text = percent .. "%"

		TweenService:Create(
			Bar,
			TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Size = UDim2.new(i / #steps, 0, 1, 0)}
		):Play()

		task.wait(0.35)
	end

	task.wait(0.3)

	Main.Visible = true

	TweenService:Create(
		Loading,
		TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundTransparency = 1}
	):Play()

	for _, obj in ipairs(Loading:GetDescendants()) do
		if obj:IsA("TextLabel") then
			TweenService:Create(
				obj,
				TweenInfo.new(0.35),
				{TextTransparency = 1}
			):Play()
		elseif obj:IsA("Frame") then
			TweenService:Create(
				obj,
				TweenInfo.new(0.35),
				{BackgroundTransparency = 1}
			):Play()
		end
	end

	task.wait(0.6)
	Loading:Destroy()
end)
