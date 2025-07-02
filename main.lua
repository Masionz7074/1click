-- GUI Setup
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local autoCollect = false
local partsToCollect = {"Apple", "Banana", "Kiwi", "Lemon", "Pizza", "Steak", "Strawberry", "Taco", "Watermelon"}

-- Create the GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "ItemTeleportMenu"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 220, 0, 400)
mainFrame.Position = UDim2.new(0, 20, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0

local title = Instance.new("TextLabel", mainFrame)
title.Text = "Item Teleport Menu"
title.Size = UDim2.new(1, 0, 0, 30)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.BorderSizePixel = 0
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- Auto Collect Toggle
local toggleButton = Instance.new("TextButton", mainFrame)
toggleButton.Size = UDim2.new(1, 0, 0, 30)
toggleButton.Position = UDim2.new(0, 0, 0, 35)
toggleButton.Text = "Auto Collect: OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 18

toggleButton.MouseButton1Click:Connect(function()
	autoCollect = not autoCollect
	toggleButton.Text = "Auto Collect: " .. (autoCollect and "ON" or "OFF")
end)

-- Function to teleport player to part
local function teleportTo(partName)
	local part = workspace:FindFirstChild(partName)
	if part then
		player.Character:SetPrimaryPartCFrame(part.CFrame + Vector3.new(0, 5, 0))
	end
end

-- Create item buttons
for i, itemName in ipairs(partsToCollect) do
	local button = Instance.new("TextButton", mainFrame)
	button.Size = UDim2.new(1, 0, 0, 30)
	button.Position = UDim2.new(0, 0, 0, 35 + i * 35)
	button.Text = "Go to " .. itemName
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSans
	button.TextSize = 18

	button.MouseButton1Click:Connect(function()
		teleportTo(itemName)
	end)
end

-- Auto Collect Loop
task.spawn(function()
	while true do
		if autoCollect then
			for _, itemName in ipairs(partsToCollect) do
				teleportTo(itemName)
				task.wait(0.75) -- delay between teleports
			end
		end
		task.wait(1)
	end
end)
