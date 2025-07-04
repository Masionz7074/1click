local Players = game:GetService("Players")
local player = Players.LocalPlayer
local autoCollect = false
local collectDelay = 1

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "PlayerTeleportGui"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 480)
mainFrame.Position = UDim2.new(0, 100, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local titleBar = Instance.new("TextLabel", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.Text = "🧍 Player Teleporter"
titleBar.TextColor3 = Color3.new(1, 1, 1)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 20
titleBar.BorderSizePixel = 0

local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 0.4, 0.4)
closeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.BorderSizePixel = 0
closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

local tabButtons = Instance.new("Frame", mainFrame)
tabButtons.Size = UDim2.new(0, 80, 1, -30)
tabButtons.Position = UDim2.new(0, 0, 0, 30)
tabButtons.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabButtons.BorderSizePixel = 0

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -80, 1, -30)
contentFrame.Position = UDim2.new(0, 80, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentFrame.BorderSizePixel = 0

local pages = {}
local function createPage(name)
	local page = Instance.new("Frame", contentFrame)
	page.Name = name
	page.Size = UDim2.new(1, 0, 1, 0)
	page.Visible = false
	page.BackgroundTransparency = 1
	pages[name] = page
	return page
end

local function switchTab(tabName)
	for name, page in pairs(pages) do
		page.Visible = (name == tabName)
	end
end

local tabCount = 0
local function addTabButton(tabName)
	tabCount += 1
	local btn = Instance.new("TextButton", tabButtons)
	btn.Size = UDim2.new(1, 0, 0, 35)
	btn.Position = UDim2.new(0, 0, 0, (tabCount - 1) * 35)
	btn.Text = tabName
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 18

	btn.MouseButton1Click:Connect(function()
		switchTab(tabName)
	end)
end

-- MAIN PAGE
local mainPage = createPage("Main")
addTabButton("Main")

local autoButton = Instance.new("TextButton", mainPage)
autoButton.Size = UDim2.new(1, -20, 0, 30)
autoButton.Position = UDim2.new(0, 10, 0, 10)
autoButton.Text = "Auto Collect: OFF"
autoButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
autoButton.TextColor3 = Color3.new(1, 1, 1)
autoButton.Font = Enum.Font.SourceSans
autoButton.TextSize = 18
autoButton.MouseButton1Click:Connect(function()
	autoCollect = not autoCollect
	autoButton.Text = "Auto Collect: " .. (autoCollect and "ON" or "OFF")
end)

-- Player teleport buttons (dynamic)
local function updatePlayerButtons()
	for _, child in ipairs(mainPage:GetChildren()) do
		if child:IsA("TextButton") and child.Name == "PlayerBtn" then
			child:Destroy()
		end
	end

	local yOffset = 50
	for _, target in ipairs(Players:GetPlayers()) do
		if target ~= player then
			local btn = Instance.new("TextButton", mainPage)
			btn.Name = "PlayerBtn"
			btn.Size = UDim2.new(1, -20, 0, 30)
			btn.Position = UDim2.new(0, 10, 0, yOffset)
			btn.Text = "Go to " .. target.Name
			btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Font = Enum.Font.SourceSans
			btn.TextSize = 18

			btn.MouseButton1Click:Connect(function()
				local char = target.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					player.Character.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
				end
			end)

			yOffset += 35
		end
	end
end

-- Update list initially and when players join/leave
updatePlayerButtons()
Players.PlayerAdded:Connect(updatePlayerButtons)
Players.PlayerRemoving:Connect(updatePlayerButtons)

-- +10 Coins Button
local coinBtn = Instance.new("TextButton", mainPage)
coinBtn.Size = UDim2.new(1, -20, 0, 30)
coinBtn.Position = UDim2.new(0, 10, 1, -70)
coinBtn.Text = "➕ +10 Coins"
coinBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
coinBtn.TextColor3 = Color3.new(1, 1, 1)
coinBtn.Font = Enum.Font.SourceSans
coinBtn.TextSize = 18

coinBtn.MouseButton1Click:Connect(function()
	local stats = player:FindFirstChild("leaderstats")
	if stats and stats:FindFirstChild("Coins") then
		stats.Coins.Value += 10
	end
end)

-- +1 Size Button
local sizeBtn = Instance.new("TextButton", mainPage)
sizeBtn.Size = UDim2.new(1, -20, 0, 30)
sizeBtn.Position = UDim2.new(0, 10, 1, -35)
sizeBtn.Text = "📏 +1 Size"
sizeBtn.BackgroundColor3 = Color3.fromRGB(70, 90, 70)
sizeBtn.TextColor3 = Color3.new(1, 1, 1)
sizeBtn.Font = Enum.Font.SourceSans
sizeBtn.TextSize = 18

sizeBtn.MouseButton1Click:Connect(function()
	local stats = player:FindFirstChild("leaderstats")
	if stats and stats:FindFirstChild("Size") then
		stats.Size.Value += 1
	end
end)

-- SETTINGS PAGE
local settingsPage = createPage("Settings")
addTabButton("Settings")

local delayLabel = Instance.new("TextLabel", settingsPage)
delayLabel.Size = UDim2.new(1, -20, 0, 30)
delayLabel.Position = UDim2.new(0, 10, 0, 10)
delayLabel.Text = "⏱ Delay: " .. tostring(collectDelay) .. "s"
delayLabel.TextColor3 = Color3.new(1, 1, 1)
delayLabel.BackgroundTransparency = 1
delayLabel.Font = Enum.Font.SourceSans
delayLabel.TextSize = 18

local delaySlider = Instance.new("TextButton", settingsPage)
delaySlider.Size = UDim2.new(1, -20, 0, 30)
delaySlider.Position = UDim2.new(0, 10, 0, 50)
delaySlider.Text = "Increase Delay"
delaySlider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
delaySlider.TextColor3 = Color3.new(1, 1, 1)
delaySlider.Font = Enum.Font.SourceSans
delaySlider.TextSize = 18
delaySlider.MouseButton1Click:Connect(function()
	collectDelay += 0.5
	if collectDelay > 5 then collectDelay = 0.5 end
	delayLabel.Text = "⏱ Delay: " .. tostring(collectDelay) .. "s"
end)

local resetBtn = Instance.new("TextButton", settingsPage)
resetBtn.Size = UDim2.new(1, -20, 0, 30)
resetBtn.Position = UDim2.new(0, 10, 0, 90)
resetBtn.Text = "Reset Delay"
resetBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
resetBtn.TextColor3 = Color3.new(1, 1, 1)
resetBtn.Font = Enum.Font.SourceSans
resetBtn.TextSize = 18
resetBtn.MouseButton1Click:Connect(function()
	collectDelay = 1
	delayLabel.Text = "⏱ Delay: " .. tostring(collectDelay) .. "s"
end)

switchTab("Main")

-- Auto Teleport Loop (to all other players)
task.spawn(function()
	while true do
		if autoCollect and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			for _, target in ipairs(Players:GetPlayers()) do
				if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
					player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
					task.wait(collectDelay)
				end
			end
		end
		task.wait(1)
	end
end)
