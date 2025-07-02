local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local autoCollect = false
local partsToCollect = {"Apple", "Banana", "Kiwi", "Lemon", "Pizza", "Steak", "Strawberry", "Taco", "Watermelon"}

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "ItemTeleportGui"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 260, 0, 400)
mainFrame.Position = UDim2.new(0, 100, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

-- Title bar
local titleBar = Instance.new("TextLabel", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.Text = "🍉 Item Teleporter"
titleBar.TextColor3 = Color3.new(1, 1, 1)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 20
titleBar.BorderSizePixel = 0

-- Close Button (X)
local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 0.5, 0.5)
closeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.BorderSizePixel = 0
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tab Buttons
local tabButtons = Instance.new("Frame", mainFrame)
tabButtons.Size = UDim2.new(0, 70, 1, -30)
tabButtons.Position = UDim2.new(0, 0, 0, 30)
tabButtons.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabButtons.BorderSizePixel = 0

-- Main Content Area
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -70, 1, -30)
contentFrame.Position = UDim2.new(0, 70, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentFrame.BorderSizePixel = 0

-- Tabs
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

-- Main Page
local mainPage = createPage("Main")

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

-- Create teleport buttons
for i, itemName in ipairs(partsToCollect) do
    local btn = Instance.new("TextButton", mainPage)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 50 + (i - 1) * 35)
    btn.Text = "Go to " .. itemName
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18

    btn.MouseButton1Click:Connect(function()
        local part = workspace:FindFirstChild(itemName)
        if part and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 5, 0)
        end
    end)
end

-- Settings Page
local settingsPage = createPage("Settings")
local label = Instance.new("TextLabel", settingsPage)
label.Size = UDim2.new(1, -20, 0, 30)
label.Position = UDim2.new(0, 10, 0, 10)
label.Text = "⚙️ Settings page (customize later)"
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundTransparency = 1
label.Font = Enum.Font.SourceSans
label.TextSize = 18

-- Tab Buttons
local function addTabButton(tabName)
    local btn = Instance.new("TextButton", tabButtons)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = tabName
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18

    btn.MouseButton1Click:Connect(function()
        for name, page in pairs(pages) do
            page.Visible = (name == tabName)
        end
    end)
end

addTabButton("Main")
addTabButton("Settings")

pages["Main"].Visible = true

-- Auto Collect loop
task.spawn(function()
    while true do
        if autoCollect and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, itemName in ipairs(partsToCollect) do
                local part = workspace:FindFirstChild(itemName)
                if part then
                    player.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                    task.wait(0.5)
                end
            end
        end
        task.wait(1)
    end
end)
