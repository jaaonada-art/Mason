-- Fishing Wars Local Panel Demo
-- Account display lock: slimada130
-- This is a client-side UI demo only. It does not grant game admin permissions
-- or run server-side commands. Use only where permitted by the game.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
if not player or player.Name:lower() ~= "slimada130" then
    warn("This panel is configured for slimada130 only.")
    return
end

local playerGui = player:WaitForChild("PlayerGui")
local old = playerGui:FindFirstChild("FishingWarsLocalPanel")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "FishingWarsLocalPanel"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.fromOffset(390, 310)
frame.Position = UDim2.new(0.5, -195, 0.5, -155)
frame.BackgroundColor3 = Color3.fromRGB(18, 28, 39)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(53, 190, 190)
stroke.Thickness = 2
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -48, 0, 42)
title.Position = UDim2.fromOffset(14, 2)
title.BackgroundTransparency = 1
title.Text = "FISHING WARS  |  slimada130"
title.TextColor3 = Color3.fromRGB(230, 250, 250)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 30)
close.Position = UDim2.new(1, -40, 0, 7)
close.Text = "×"
close.TextSize = 22
close.Font = Enum.Font.GothamBold
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(150, 55, 65)
close.Parent = frame
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 7)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -28, 0, 34)
status.Position = UDim2.fromOffset(14, 48)
status.BackgroundColor3 = Color3.fromRGB(27, 43, 55)
status.Text = "Local panel loaded. Server admin commands are not included."
status.TextColor3 = Color3.fromRGB(175, 225, 220)
status.TextWrapped = true
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.Parent = frame
Instance.new("UICorner", status).CornerRadius = UDim.new(0, 7)

local function makeButton(text, x, y, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(172, 38)
    button.Position = UDim2.fromOffset(x, y)
    button.BackgroundColor3 = Color3.fromRGB(34, 91, 105)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = text
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 13
    button.Parent = frame
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    button.MouseButton1Click:Connect(callback)
    return button
end

makeButton("Show status", 14, 96, function()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    status.Text = humanoid and ("Ready | WalkSpeed: " .. tostring(humanoid.WalkSpeed))
        or "Character not loaded yet."
end)

makeButton("Reset local movement", 204, 96, function()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
        status.Text = "Local movement values reset to defaults."
    else
        status.Text = "Character not loaded yet."
    end
end)

makeButton("Compact panel", 14, 144, function()
    frame.Size = frame.Size == UDim2.fromOffset(390, 310)
        and UDim2.fromOffset(390, 190) or UDim2.fromOffset(390, 310)
    status.Text = "Panel size toggled."
end)

makeButton("Theme: ocean", 204, 144, function()
    frame.BackgroundColor3 = Color3.fromRGB(12, 45, 58)
    stroke.Color = Color3.fromRGB(75, 220, 205)
    status.Text = "Ocean theme enabled."
end)

local commandBox = Instance.new("TextBox")
commandBox.Size = UDim2.new(1, -28, 0, 36)
commandBox.Position = UDim2.fromOffset(14, 194)
commandBox.PlaceholderText = "Try: help, status, clear"
commandBox.Text = ""
commandBox.ClearTextOnFocus = false
commandBox.BackgroundColor3 = Color3.fromRGB(27, 43, 55)
commandBox.TextColor3 = Color3.new(1, 1, 1)
commandBox.PlaceholderColor3 = Color3.fromRGB(150, 175, 180)
commandBox.Font = Enum.Font.Code
commandBox.TextSize = 13
commandBox.Parent = frame
Instance.new("UICorner", commandBox).CornerRadius = UDim.new(0, 7)

local function runCommand(raw)
    local command = raw:lower():match("^%s*(.-)%s*$")
    if command == "help" then
        status.Text = "Commands: help, status, clear. This demo has no server-admin commands."
    elseif command == "status" then
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        status.Text = humanoid and ("Player: slimada130 | WalkSpeed: " .. humanoid.WalkSpeed)
            or "Player: slimada130 | Character not loaded."
    elseif command == "clear" then
        commandBox.Text = ""
        status.Text = "Command box cleared."
    elseif command == "" then
        status.Text = "Type help to see available demo commands."
    else
        status.Text = "Unsupported demo command: " .. command
    end
end

commandBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then runCommand(commandBox.Text) end
end)

-- Drag window by its title area.
local dragging, dragStart, startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local visible = true
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        visible = not visible
        frame.Visible = visible
    end
end)

print("Fishing Wars Local Panel loaded for slimada130. RightShift toggles visibility.")
