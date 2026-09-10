--==================================================
-- JOHNONTOP HUB 👑
-- EGG SPAWNER + RANDOM EGG → PLAYER
-- NO LOADING GUI
--==================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local REMOTE_NAME = "JohnOnTopEggSpawner"
local CIRCLE_IMAGE = "rbxassetid://134112829099529"

--==================================================
-- REMOTE
--==================================================

local Remote = ReplicatedStorage:WaitForChild(REMOTE_NAME)

--==================================================
-- EGG FOLDER
--==================================================

local EggFolder = workspace:WaitForChild("SpawnedEggs")

--==================================================
-- GUI
--==================================================

local OldGui = PlayerGui:FindFirstChild("JohnOnTopHub")

if OldGui then
	OldGui:Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "JohnOnTopHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
Gui.DisplayOrder = 999999
Gui.Parent = PlayerGui

--==================================================
-- MAIN FRAME
--==================================================

local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 340, 0, 430)
Main.Position = UDim2.new(1, -360, 0.5, -215)
Main.BackgroundColor3 = Color3.fromRGB(8, 18, 35)
Main.BorderSizePixel = 0
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
Subtitle.Parent = Top

--==================================================
-- CLOSE
--==================================================

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 38, 0, 38)
Close.Position = UDim2.new(1, -49, 0, 13)
Close.BackgroundColor3 = Color3.fromRGB(20, 80, 125)
Close.BorderSizePixel = 0
Close.Font = Enum.Font.GothamBold
Close.Text = "×"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.TextSize = 22
Close.Parent = Top

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = Close

--==================================================
-- LABEL FUNCTION
--==================================================

local function MakeLabel(text, y)

	local Label = Instance.new("TextLabel")

	Label.BackgroundTransparency = 1
	Label.Position = UDim2.new(0, 18, 0, y)
	Label.Size = UDim2.new(1, -36, 0, 22)

	Label.Font = Enum.Font.GothamBold
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(190, 210, 230)
	Label.TextSize = 12
	Label.TextXAlignment = Enum.TextXAlignment.Left

	Label.Parent = Main

	return Label
end

--==================================================
-- TEXTBOX FUNCTION
--==================================================

local function MakeBox(y, placeholder)

	local Box = Instance.new("TextBox")

	Box.Size = UDim2.new(1, -36, 0, 38)
	Box.Position = UDim2.new(0, 18, 0, y)

	Box.BackgroundColor3 = Color3.fromRGB(15, 30, 48)
	Box.BorderSizePixel = 0

	Box.ClearTextOnFocus = false
	Box.Font = Enum.Font.Gotham

	Box.PlaceholderText = placeholder
	Box.PlaceholderColor3 = Color3.fromRGB(100, 125, 150)

	Box.Text = ""
	Box.TextColor3 = Color3.fromRGB(235, 245, 255)
	Box.TextSize = 13

	Box.Parent = Main

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 9)
	Corner.Parent = Box

	return Box
end

--==================================================
-- BUTTON FUNCTION
--==================================================

local function MakeButton(text, y)

	local Button = Instance.new("TextButton")

	Button.Size = UDim2.new(1, -36, 0, 40)
	Button.Position = UDim2.new(0, 18, 0, y)

	Button.BackgroundColor3 = Color3.fromRGB(0, 125, 210)
	Button.BorderSizePixel = 0

	Button.Font = Enum.Font.GothamBold
	Button.Text = text
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.TextSize = 13

	Button.Parent = Main

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 9)
	Corner.Parent = Button

	return Button
end

--==================================================
-- EGG SECTION
--==================================================

MakeLabel("EGG NAME", 82)

local EggBox = MakeBox(
	106,
	"Enter exact egg name"
)

--==================================================
-- EGG LIST
--==================================================

local EggList = Instance.new("ScrollingFrame")

EggList.Size = UDim2.new(1, -36, 0, 85)
EggList.Position = UDim2.new(0, 18, 0, 151)

EggList.BackgroundColor3 = Color3.fromRGB(12, 26, 43)
EggList.BorderSizePixel = 0

EggList.ScrollBarThickness = 4
EggList.CanvasSize = UDim2.new(0, 0, 0, 0)

EggList.Parent = Main

local EggCorner = Instance.new("UICorner")
EggCorner.CornerRadius = UDim.new(0, 9)
EggCorner.Parent = EggList

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 4)
Layout.Parent = EggList

--==================================================
-- SPAWN BUTTON
--==================================================

local SpawnButton = MakeButton(
	"SPAWN EGG",
	245
)

--==================================================
-- PLAYER SECTION
--==================================================

MakeLabel("PLAYER", 295)

local PlayerBox = MakeBox(
	319,
	"Enter username"
)

local PlayerButton = MakeButton(
	"RANDOM EGG → PLAYER",
	365
)

--==================================================
-- STATUS
--==================================================

local Status = Instance.new("TextLabel")

Status.BackgroundTransparency = 1

Status.Position = UDim2.new(
	0,
	18,
	1,
	-25
)

Status.Size = UDim2.new(
	1,
	-36,
	0,
	18
)

Status.Font = Enum.Font.Gotham
Status.Text = "Ready."
Status.TextColor3 = Color3.fromRGB(130, 190, 225)
Status.TextSize = 11

Status.TextXAlignment =
	Enum.TextXAlignment.Left

Status.Parent = Main

--==================================================
-- FLOATING BUTTON
--==================================================

local Circle = Instance.new("ImageButton")

Circle.Name = "FloatingButton"

Circle.Size = UDim2.new(
	0,
	55,
	0,
	55
)

Circle.Position = UDim2.new(
	1,
	-75,
	0.5,
	-27
)

Circle.BackgroundColor3 =
	Color3.fromRGB(8, 30, 50)

Circle.BorderSizePixel = 0

Circle.Image = CIRCLE_IMAGE

Circle.Visible = false

Circle.Parent = Gui

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = Circle

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Color = Color3.fromRGB(0, 170, 255)
CircleStroke.Thickness = 2
CircleStroke.Parent = Circle

--==================================================
-- REFRESH EGG LIST
--==================================================

local function RefreshEggList()

	for _, Child in ipairs(EggList:GetChildren()) do

		if Child:IsA("TextButton") then
			Child:Destroy()
		end

	end

	for _, Egg in ipairs(EggFolder:GetChildren()) do

		local Button = Instance.new("TextButton")

		Button.Size = UDim2.new(
			1,
			-8,
			0,
			28
		)

		Button.BackgroundColor3 =
			Color3.fromRGB(20, 45, 68)

		Button.BorderSizePixel = 0

		Button.Font =
			Enum.Font.Gotham

		Button.Text =
			Egg.Name

		Button.TextColor3 =
			Color3.fromRGB(220, 235, 250)

		Button.TextSize = 12

		Button.Parent = EggList

		local Corner =
			Instance.new("UICorner")

		Corner.CornerRadius =
			UDim.new(0, 6)

		Corner.Parent = Button

		Button.Activated:Connect(
			function()

				EggBox.Text =
					Egg.Name

				Status.Text =
					"Selected: "
					.. Egg.Name

			end
		)

	end

	task.defer(
		function()

			EggList.CanvasSize =
				UDim2.new(
					0,
					0,
					0,
					Layout.AbsoluteContentSize.Y + 5
				)

		end
	)
end

--==================================================
-- SPAWN EGG
--==================================================

SpawnButton.Activated:Connect(
	function()

		local Name =
			EggBox.Text:match(
				"^%s*(.-)%s*$"
			)

		if Name == "" then

			Status.Text =
				"Enter an egg name."

			return
		end

		Status.Text =
			"Spawning "
			.. Name
			.. "..."

		Remote:FireServer(
			"Spawn",
			Name
		)

	end
)

--==================================================
-- RANDOM EGG → PLAYER
--==================================================

PlayerButton.Activated:Connect(
	function()

		local Name =
			PlayerBox.Text:match(
				"^%s*(.-)%s*$"
			)

		if Name == "" then

			Status.Text =
				"Enter a username."

			return
		end

		Status.Text =
			"Finding random egg..."

		Remote:FireServer(
			"SpawnPlayer",
			Name
		)

	end
)

--==================================================
-- SERVER STATUS
--==================================================

Remote.OnClientEvent:Connect(
	function(Action, Message)

		if Action == "Status" then

			Status.Text =
				tostring(Message)

		end

	end
)

--==================================================
-- OPEN / CLOSE
--==================================================

Close.Activated:Connect(
	function()

		Main.Visible = false
		Circle.Visible = true

	end
)

Circle.Activated:Connect(
	function()

		Main.Visible = true
		Circle.Visible = false

	end
)

--==================================================
-- DRAGGING
--==================================================

local UserInputService =
	game:GetService("UserInputService")

local function MakeDraggable(Frame)

	local Dragging = false
	local DragStart
	local StartPosition

	Frame.InputBegan:Connect(
		function(Input)

			if
				Input.UserInputType ==
				Enum.UserInputType.MouseButton1
				or
				Input.UserInputType ==
				Enum.UserInputType.Touch
			then

				Dragging = true

				DragStart =
					Input.Position

				StartPosition =
					Frame.Position

			end

		end
	)

	UserInputService.InputChanged:Connect(
		function(Input)

			if not Dragging then
				return
			end

			if
				Input.UserInputType ==
				Enum.UserInputType.MouseMovement
				or
				Input.UserInputType ==
				Enum.UserInputType.Touch
			then

				local Delta =
					Input.Position
					- DragStart

				Frame.Position =
					UDim2.new(
						StartPosition.X.Scale,
						StartPosition.X.Offset
							+ Delta.X,

						StartPosition.Y.Scale,
						StartPosition.Y.Offset
							+ Delta.Y
					)

			end

		end
	)

	UserInputService.InputEnded:Connect(
		function(Input)

			if
				Input.UserInputType ==
				Enum.UserInputType.MouseButton1
				or
				Input.UserInputType ==
				Enum.UserInputType.Touch
			then

				Dragging = false

			end

		end
	)
end

MakeDraggable(Main)

--==================================================
-- REFRESH LOOP
--==================================================

task.spawn(
	function()

		while Gui.Parent do

			RefreshEggList()

			task.wait(1)

		end

	end
)

--==================================================
-- DONE
--==================================================
