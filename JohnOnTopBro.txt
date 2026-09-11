--==================================================
-- JOHNONTOP HUB 👑
-- SAFE GUI VERSION
-- ONE LOCAL SCRIPT
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CLEAN OLD GUI
--==================================================

local oldGui = PlayerGui:FindFirstChild("JohnOnTopHub")
if oldGui then
	oldGui:Destroy()
end

local oldLoading = PlayerGui:FindFirstChild("JohnOnTopLoading")
if oldLoading then
	oldLoading:Destroy()
end

--==================================================
-- COLORS
--==================================================

local COLORS = {
	panel = Color3.fromRGB(8, 18, 35),
	surface = Color3.fromRGB(10, 30, 55),
	surfaceDark = Color3.fromRGB(7, 22, 42),

	blue = Color3.fromRGB(0, 150, 255),
	blueBright = Color3.fromRGB(70, 200, 255),
	blueSoft = Color3.fromRGB(30, 90, 145),

	line = Color3.fromRGB(30, 75, 110),

	text = Color3.fromRGB(220, 240, 255),
	muted = Color3.fromRGB(130, 165, 190),

	green = Color3.fromRGB(60, 255, 140),
	red = Color3.fromRGB(255, 60, 80),
}

--==================================================
-- HELPERS
--==================================================

local function create(className, properties, parent)
	local obj = Instance.new(className)

	for property, value in pairs(properties or {}) do
		obj[property] = value
	end

	obj.Parent = parent
	return obj
end

local function corner(parent, radius)
	return create("UICorner", {
		CornerRadius = UDim.new(0, radius)
	}, parent)
end

local function stroke(parent, color, transparency, thickness)
	return create("UIStroke", {
		Color = color,
		Transparency = transparency or 0,
		Thickness = thickness or 1
	}, parent)
end

local function label(parent, text, position, size, textSize, color, alignment)
	return create("TextLabel", {
		BackgroundTransparency = 1,
		Position = position,
		Size = size,

		Font = Enum.Font.Gotham,
		Text = text,
		TextColor3 = color or COLORS.text,
		TextSize = textSize,

		TextXAlignment = alignment or Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
	}, parent)
end

--==================================================
-- LOADING GUI
--==================================================

local loadingGui = create("ScreenGui", {
	Name = "JohnOnTopLoading",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Global,
	DisplayOrder = 999999,
}, PlayerGui)

local loadingBackground = create("Frame", {
	BackgroundColor3 = COLORS.panel,
	BorderSizePixel = 0,
	Size = UDim2.fromScale(1, 1),
	ZIndex = 100,
}, loadingGui)

local loadingTitle = label(
	loadingBackground,
	"JOHN ON TOP 👑",
	UDim2.new(0.5, -200, 0.5, -75),
	UDim2.fromOffset(400, 40),
	28,
	COLORS.blueBright,
	Enum.TextXAlignment.Center
)

loadingTitle.Font = Enum.Font.GothamBold

local loadingStatus = label(
	loadingBackground,
	"Starting...",
	UDim2.new(0.5, -200, 0.5, -25),
	UDim2.fromOffset(400, 25),
	13,
	COLORS.text,
	Enum.TextXAlignment.Center
)

local loadingPercent = label(
	loadingBackground,
	"0%",
	UDim2.new(0.5, -200, 0.5, 5),
	UDim2.fromOffset(400, 20),
	11,
	COLORS.muted,
	Enum.TextXAlignment.Center
)

local progressBackground = create("Frame", {
	BackgroundColor3 = Color3.fromRGB(15, 35, 55),
	BorderSizePixel = 0,
	Position = UDim2.new(0.5, -200, 0.5, 35),
	Size = UDim2.fromOffset(400, 12),
	ZIndex = 101,
}, loadingBackground)

corner(progressBackground, 6)

local progressFill = create("Frame", {
	BackgroundColor3 = COLORS.blue,
	BorderSizePixel = 0,
	Size = UDim2.new(0, 0, 1, 0),
	ZIndex = 102,
}, progressBackground)

corner(progressFill, 6)

local loadingSteps = {
	"Loading interface...",
	"Checking player...",
	"Loading egg selector...",
	"Loading spawn system...",
	"Loading controls...",
	"Starting JohnOnTop Hub...",
	"Ready!",
}

for i, step in ipairs(loadingSteps) do
	task.wait(0.08)

	loadingStatus.Text = step

	local percent = math.floor((i / #loadingSteps) * 100)
	loadingPercent.Text = percent .. "%"

	TweenService:Create(
		progressFill,
		TweenInfo.new(0.12, Enum.EasingStyle.Linear),
		{
			Size = UDim2.new(i / #loadingSteps, 0, 1, 0)
		}
	):Play()
end

task.wait(0.25)

local fadeObjects = {
	loadingBackground,
	loadingTitle,
	loadingStatus,
	loadingPercent,
	progressBackground,
	progressFill,
}

for _, object in ipairs(fadeObjects) do
	if object:IsA("Frame") then
		TweenService:Create(
			object,
			TweenInfo.new(0.25),
			{BackgroundTransparency = 1}
		):Play()

	elseif object:IsA("TextLabel") then
		TweenService:Create(
			object,
			TweenInfo.new(0.25),
			{TextTransparency = 1}
		):Play()
	end
end

task.wait(0.3)
loadingGui:Destroy()

--==================================================
-- MAIN GUI
--==================================================

local gui = create("ScreenGui", {
	Name = "JohnOnTopHub",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Global,
	DisplayOrder = 999998,
}, PlayerGui)

--==================================================
-- MAIN PANEL
--==================================================

local panel = create("Frame", {
	Name = "MainFrame",

	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(1, -170, 0.5, 0),

	Size = UDim2.fromOffset(300, 390),

	BackgroundColor3 = COLORS.panel,
	BorderSizePixel = 0,

	ClipsDescendants = true,
}, gui)

corner(panel, 12)
stroke(panel, COLORS.blue, 0.25, 1.5)

--==================================================
-- HEADER
--==================================================

local header = create("Frame", {
	Name = "Header",

	BackgroundColor3 = COLORS.surface,
	BorderSizePixel = 0,

	Size = UDim2.new(1, 0, 0, 62),

	ZIndex = 5,
}, panel)

local title = label(
	header,
	"JOHNONTOP HUB 👑",
	UDim2.fromOffset(14, 5),
	UDim2.new(1, -55, 0, 27),
	16,
	COLORS.blueBright
)

title.Font = Enum.Font.GothamBold

local subtitle = label(
	header,
	"STEAL AN EGG",
	UDim2.fromOffset(15, 31),
	UDim2.new(1, -70, 0, 20),
	9,
	COLORS.muted
)

subtitle.Font = Enum.Font.GothamMedium

local closeButton = create("TextButton", {
	Name = "Close",

	AutoButtonColor = false,

	BackgroundColor3 = Color3.fromRGB(15, 55, 85),
	BorderSizePixel = 0,

	Position = UDim2.new(1, -40, 0, 12),
	Size = UDim2.fromOffset(28, 28),

	Font = Enum.Font.GothamBold,
	Text = "×",
	TextColor3 = COLORS.text,
	TextSize = 20,
}, header)

corner(closeButton, 7)
stroke(closeButton, COLORS.blue, 0.45, 1)

--==================================================
-- CONTENT
--==================================================

local content = create("ScrollingFrame", {
	Name = "Content",

	BackgroundTransparency = 1,
	BorderSizePixel = 0,

	Position = UDim2.fromOffset(0, 62),
	Size = UDim2.new(1, 0, 1, -62),

	CanvasSize = UDim2.fromOffset(0, 600),

	ScrollBarThickness = 2,
	ScrollBarImageColor3 = COLORS.blue,

	ScrollingDirection = Enum.ScrollingDirection.Y,
}, panel)

--==================================================
-- STATUS
--==================================================

local statusBox = create("Frame", {
	BackgroundColor3 = COLORS.surfaceDark,
	BorderSizePixel = 0,

	Position = UDim2.fromOffset(12, 10),
	Size = UDim2.fromOffset(276, 43),
}, content)

corner(statusBox, 7)
stroke(statusBox, COLORS.line, 0.45, 1)

label(
	statusBox,
	"STATUS",
	UDim2.fromOffset(10, 2),
	UDim2.fromOffset(60, 17),
	8,
	COLORS.muted
)

local statusLabel = label(
	statusBox,
	"Ready.",
	UDim2.fromOffset(10, 18),
	UDim2.new(1, -20, 0, 20),
	10,
	COLORS.green
)

statusLabel.Font = Enum.Font.GothamMedium

--==================================================
-- EGG SELECTION
--==================================================

label(
	content,
	"SELECT EGG",
	UDim2.fromOffset(13, 63),
	UDim2.fromOffset(130, 22),
	10,
	COLORS.muted
)

local mutationNames = {
	"Unicorn",
	"Kitsune",
	"Nightflame",
	"Archdemon",
	"Dreadscale",
	"Mecha",
	"Shattered",
}

local selectedEgg = "Unicorn"
local mutationButtons = {}

for index, eggName in ipairs(mutationNames) do
	local column = (index - 1) % 3
	local row = math.floor((index - 1) / 3)

	local x = 12 + column * 92
	local y = 87 + row * 37

	local eggButton = create("TextButton", {
		Name = eggName,

		AutoButtonColor = false,

		BackgroundColor3 =
			index == 1
			and Color3.fromRGB(0, 100, 170)
			or Color3.fromRGB(18, 42, 65),

		BorderSizePixel = 0,

		Position = UDim2.fromOffset(x, y),
		Size = UDim2.fromOffset(87, 31),

		Font = Enum.Font.GothamMedium,
		Text = eggName,

		TextColor3 = COLORS.text,
		TextSize = 9,
	}, content)

	corner(eggButton, 6)

	stroke(
		eggButton,
		index == 1 and COLORS.blueBright or COLORS.line,
		0.45,
		1
	)

	mutationButtons[eggName] = eggButton

	eggButton.MouseButton1Click:Connect(function()
		selectedEgg = eggName

		for name, buttonObject in pairs(mutationButtons) do
			local selected = name == selectedEgg

			buttonObject.BackgroundColor3 =
				selected
				and Color3.fromRGB(0, 100, 170)
				or Color3.fromRGB(18, 42, 65)

			local buttonStroke = buttonObject:FindFirstChildOfClass("UIStroke")

			if buttonStroke then
				buttonStroke.Color =
					selected
					and COLORS.blueBright
					or COLORS.line
			end
		end

		statusLabel.Text = "Selected: " .. selectedEgg
		statusLabel.TextColor3 = COLORS.blueBright
	end)
end

--==================================================
-- INPUT FUNCTION
--==================================================

local function createInput(name, caption, placeholder, y)
	local row = create("Frame", {
		Name = name,

		BackgroundColor3 = COLORS.surfaceDark,
		BorderSizePixel = 0,

		Position = UDim2.fromOffset(12, y),
		Size = UDim2.fromOffset(276, 34),
	}, content)

	corner(row, 6)
	stroke(row, COLORS.line, 0.5, 1)

	label(
		row,
		caption,
		UDim2.fromOffset(9, 0),
		UDim2.fromOffset(70, 34),
		9,
		COLORS.text
	)

	local input = create("TextBox", {
		Name = "Input",

		BackgroundColor3 = Color3.fromRGB(9, 28, 47),
		BorderSizePixel = 0,

		Position = UDim2.fromOffset(80, 4),
		Size = UDim2.fromOffset(187, 26),

		ClearTextOnFocus = false,

		Font = Enum.Font.Gotham,

		PlaceholderText = placeholder,
		PlaceholderColor3 = COLORS.muted,

		Text = "",
		TextColor3 = COLORS.text,
		TextSize = 10,

		TextXAlignment = Enum.TextXAlignment.Center,
	}, row)

	corner(input, 5)

	return input
end

local quantityInput = createInput(
	"QuantityRow",
	"Quantity:",
	"1",
	178
)

quantityInput.Text = "1"

local playerInput = createInput(
	"PlayerRow",
	"Player:",
	"Username",
	218
)

--==================================================
-- ACTION BUTTON
--==================================================

local function createAction(name, text, y)
	local action = create("TextButton", {
		Name = name,

		AutoButtonColor = false,

		BackgroundColor3 = Color3.fromRGB(18, 42, 65),
		BorderSizePixel = 0,

		Position = UDim2.fromOffset(12, y),
		Size = UDim2.fromOffset(276, 36),

		Font = Enum.Font.GothamMedium,
		Text = text,

		TextColor3 = COLORS.text,
		TextSize = 10,

		TextXAlignment = Enum.TextXAlignment.Left,
	}, content)

	corner(action, 6)
	stroke(action, COLORS.line, 0.45, 1)

	create("UIPadding", {
		PaddingLeft = UDim.new(0, 10)
	}, action)

	action.MouseEnter:Connect(function()
		action.BackgroundColor3 = Color3.fromRGB(25, 62, 92)
	end)

	action.MouseLeave:Connect(function()
		action.BackgroundColor3 = Color3.fromRGB(18, 42, 65)
	end)

	return action
end

local spawnEggs = createAction(
	"SpawnEggs",
	"🥚  Spawn Eggs",
	260
)

local spawnToPlayer = createAction(
	"SpawnEggsToPlayer",
	"🥚  Spawn Eggs to Player",
	302
)

local spawnServer = createAction(
	"SpawnEggsInServer",
	"🥚  Spawn Eggs in Server",
	344
)

local startRift = createAction(
	"StartRift",
	"🌌  Start Rift",
	386
)

local giveAdmin = createAction(
	"GiveAdmin",
	"👑  Give Admin",
	428
)

local botInput = createInput(
	"BotNameRow",
	"Bot Name:",
	"Roblox username",
	470
)

local createBot = createAction(
	"CreateBot",
	"🤖  Create Bot",
	510
)

--==================================================
-- SAFE STATUS HANDLER
--==================================================

local function safeAction(message)
	statusLabel.Text = message
	statusLabel.TextColor3 = COLORS.blueBright

	task.delay(2, function()
		if statusLabel and statusLabel.Parent then
			statusLabel.Text = "Ready."
			statusLabel.TextColor3 = COLORS.green
		end
	end)
end

spawnEggs.MouseButton1Click:Connect(function()
	safeAction("Spawn request selected: " .. selectedEgg)
end)

spawnToPlayer.MouseButton1Click:Connect(function()
	local target = playerInput.Text

	if target == "" then
		safeAction("Enter a player username.")
		return
	end

	safeAction("Player target: " .. target)
end)

spawnServer.MouseButton1Click:Connect(function()
	safeAction("Server spawn selected: " .. selectedEgg)
end)

startRift.MouseButton1Click:Connect(function()
	safeAction("Rift request selected.")
end)

giveAdmin.MouseButton1Click:Connect(function()
	safeAction("Admin action requires server authorization.")
end)

createBot.MouseButton1Click:Connect(function()
	local username = botInput.Text

	if username == "" then
		safeAction("Enter a bot username.")
		return
	end

	safeAction("Bot request selected: " .. username)
end)

--==================================================
-- CLOSE
--==================================================

closeButton.MouseButton1Click:Connect(function()
	panel.Visible = false
end)

--==================================================
-- FLOATING BUTTON
--==================================================

local floatingButton = create("ImageButton", {
	Name = "JohnOnTopFloatingButton",

	BackgroundColor3 = COLORS.surface,

	BorderSizePixel = 0,

	Position = UDim2.new(1, -70, 0.5, -27),
	Size = UDim2.fromOffset(55, 55),

	Image = "rbxassetid://134112829099529",
	ImageTransparency = 0,

	Visible = true,

	AutoButtonColor = false,
}, gui)

corner(floatingButton, 100)
stroke(floatingButton, COLORS.blue, 0.15, 1.5)

floatingButton.MouseButton1Click:Connect(function()
	panel.Visible = not panel.Visible
end)

--==================================================
-- F7 TOGGLE
--==================================================

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end

	if input.KeyCode == Enum.KeyCode.F7 then
		panel.Visible = not panel.Visible
	end
end)

--==================================================
-- DRAGGING
--==================================================

local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = panel.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - dragStart

		panel.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

--==================================================
-- FINISHED
--==================================================

panel.Visible = true
statusLabel.Text = "JohnOnTop Hub loaded."
statusLabel.TextColor3 = COLORS.green
