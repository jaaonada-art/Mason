-- Fishing Wars - Visual Admin Panel Replica
-- VISUAL ONLY: This creates a local UI and does not grant server admin permissions
-- or execute server-side commands.
-- Intended for use in a Roblox Studio test place you control.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove an older copy if the script is run again.
local oldGui = playerGui:FindFirstChild("FWAdminReplica")
if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "FWAdminReplica"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.Parent = playerGui

local function make(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties) do
        object[key] = value
    end
    object.Parent = parent
    return object
end

local main = make("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(620, 430),
    Position = UDim2.new(0.5, -310, 0.5, -215),
    BackgroundColor3 = Color3.fromRGB(22, 24, 31),
    BorderSizePixel = 0,
    Visible = true,
}, gui)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, main)
make("UIStroke", {Color = Color3.fromRGB(75, 82, 105), Thickness = 1.3}, main)

local top = make("Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = Color3.fromRGB(31, 35, 46),
    BorderSizePixel = 0,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, top)

make("TextLabel", {
    Name = "Title",
    Size = UDim2.new(1, -100, 1, 0),
    Position = UDim2.fromOffset(18, 0),
    BackgroundTransparency = 1,
    Text = "FISHING WARS  /  ADMIN PANEL",
    TextColor3 = Color3.fromRGB(240, 243, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
}, top)

local close = make("TextButton", {
    Name = "Close",
    Size = UDim2.fromOffset(34, 30),
    Position = UDim2.new(1, -44, 0, 9),
    BackgroundColor3 = Color3.fromRGB(180, 61, 72),
    Text = "X",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BorderSizePixel = 0,
}, top)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, close)
close.MouseButton1Click:Connect(function()
    main.Visible = false
end)

local sidebar = make("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 155, 1, -60),
    Position = UDim2.fromOffset(12, 55),
    BackgroundColor3 = Color3.fromRGB(27, 30, 39),
    BorderSizePixel = 0,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, sidebar)

local content = make("Frame", {
    Name = "Content",
    Size = UDim2.new(1, -183, 1, -66),
    Position = UDim2.fromOffset(171, 55),
    BackgroundTransparency = 1,
}, main)

local heading = make("TextLabel", {
    Name = "SectionHeading",
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Text = "COMMANDS",
    TextColor3 = Color3.fromRGB(242, 244, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
}, content)

local search = make("TextBox", {
    Name = "Search",
    Size = UDim2.new(1, 0, 0, 34),
    Position = UDim2.fromOffset(0, 34),
    BackgroundColor3 = Color3.fromRGB(35, 39, 51),
    PlaceholderText = "Search visual examples...",
    PlaceholderColor3 = Color3.fromRGB(145, 151, 170),
    Text = "",
    TextColor3 = Color3.fromRGB(240, 243, 255),
    Font = Enum.Font.Gotham,
    TextSize = 13,
    ClearTextOnFocus = false,
    BorderSizePixel = 0,
}, content)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, search)

local list = make("ScrollingFrame", {
    Name = "CommandList",
    Size = UDim2.new(1, 0, 1, -80),
    Position = UDim2.fromOffset(0, 76),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 5,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, content)

local layout = make("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, list)

make("UIPadding", {
    PaddingTop = UDim.new(0, 2),
    PaddingBottom = UDim.new(0, 6),
    PaddingRight = UDim.new(0, 5),
}, list)

local pages = {
    ["Commands"] = {
        "Teleport Player (visual demo)",
        "Freeze Player (visual demo)",
        "Heal Player (visual demo)",
        "Broadcast Message (visual demo)",
        "View Player Info (visual demo)",
    },
    ["Game Data"] = {
        "Player List (visual demo)",
        "Round Information (visual demo)",
        "Fishing Statistics (visual demo)",
        "Server Information (visual demo)",
    },
    ["Admin Abuse"] = {
        "Event Preview (visual demo)",
        "Effects Preview (visual demo)",
        "Announcement Preview (visual demo)",
    },
}

local currentPage = "Commands"
local function renderItems(filter)
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local count = 0
    for _, itemName in ipairs(pages[currentPage]) do
        if filter == "" or string.find(string.lower(itemName), string.lower(filter), 1, true) then
            count += 1
            local row = make("TextButton", {
                Name = "Example_" .. count,
                Size = UDim2.new(1, -3, 0, 48),
                BackgroundColor3 = Color3.fromRGB(34, 38, 50),
                Text = "",
                AutoButtonColor = true,
                BorderSizePixel = 0,
                LayoutOrder = count,
            }, list)
            make("UICorner", {CornerRadius = UDim.new(0, 7)}, row)
            make("TextLabel", {
                Size = UDim2.new(1, -18, 1, 0),
                Position = UDim2.fromOffset(12, 0),
                BackgroundTransparency = 1,
                Text = itemName,
                TextColor3 = Color3.fromRGB(224, 229, 245),
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, row)
            row.MouseButton1Click:Connect(function()
                heading.Text = "VISUAL PREVIEW"
                heading.TextColor3 = Color3.fromRGB(111, 210, 170)
                task.delay(1.5, function()
                    if heading and heading.Parent then
                        heading.Text = string.upper(currentPage)
                        heading.TextColor3 = Color3.fromRGB(242, 244, 255)
                    end
                end)
            end)
        end
    end

    if count == 0 then
        make("TextLabel", {
            Size = UDim2.new(1, -3, 0, 42),
            BackgroundTransparency = 1,
            Text = "No matching examples",
            TextColor3 = Color3.fromRGB(145, 151, 170),
            Font = Enum.Font.Gotham,
            TextSize = 13,
        }, list)
    end
end

local tabNames = {"Commands", "Game Data", "Admin Abuse"}
for index, tabName in ipairs(tabNames) do
    local tab = make("TextButton", {
        Name = tabName:gsub("%s", "") .. "Tab",
        Size = UDim2.new(1, -16, 0, 38),
        Position = UDim2.fromOffset(8, 12 + (index - 1) * 46),
        BackgroundColor3 = tabName == currentPage and Color3.fromRGB(67, 88, 139) or Color3.fromRGB(37, 41, 53),
        Text = tabName,
        TextColor3 = Color3.fromRGB(235, 239, 255),
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        BorderSizePixel = 0,
    }, sidebar)
    make("UICorner", {CornerRadius = UDim.new(0, 6)}, tab)

    tab.MouseButton1Click:Connect(function()
        currentPage = tabName
        heading.Text = string.upper(currentPage)
        for _, sibling in ipairs(sidebar:GetChildren()) do
            if sibling:IsA("TextButton") then
                sibling.BackgroundColor3 =
                    sibling == tab and Color3.fromRGB(67, 88, 139)
                    or Color3.fromRGB(37, 41, 53)
            end
        end
        renderItems(search.Text)
    end)
end

make("TextLabel", {
    Name = "Footer",
    Size = UDim2.new(1, -16, 0, 48),
    Position = UDim2.new(0, 8, 1, -56),
    BackgroundTransparency = 1,
    Text = "LOCAL UI ONLY\nPress G to hide/show",
    TextColor3 = Color3.fromRGB(145, 151, 170),
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextWrapped = true,
}, sidebar)

search:GetPropertyChangedSignal("Text"):Connect(function()
    renderItems(search.Text)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        main.Visible = not main.Visible
    end
end)

renderItems("")
