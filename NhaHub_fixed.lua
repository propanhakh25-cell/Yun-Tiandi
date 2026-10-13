-- NhaHub - original Cambodian sunset themed Roblox UI
-- Place this LocalScript in StarterPlayerScripts or StarterGui in a Roblox Studio project.
-- This builds the interface only; feature toggles are UI state and are not game exploits.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("NhaHub")
if old then old:Destroy() end

local C = {
    bg = Color3.fromRGB(38, 18, 12),
    panel = Color3.fromRGB(67, 30, 17),
    panel2 = Color3.fromRGB(91, 43, 20),
    orange = Color3.fromRGB(242, 143, 42),
    gold = Color3.fromRGB(255, 207, 105),
    cream = Color3.fromRGB(255, 244, 218),
    muted = Color3.fromRGB(205, 163, 115),
    green = Color3.fromRGB(120, 205, 111),
}

local gui = Instance.new("ScreenGui")
gui.Name = "NhaHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function new(className, props, parent)
    local o = Instance.new(className)
    for k, v in pairs(props or {}) do o[k] = v end
    o.Parent = parent
    return o
end
local function corner(parent, radius)
    new("UICorner", {CornerRadius = UDim.new(0, radius or 10)}, parent)
end
local function stroke(parent, color, transparency, thickness)
    new("UIStroke", {Color = color or C.orange, Transparency = transparency or 0.35, Thickness = thickness or 1}, parent)
end
local function label(parent, text, size, pos, fontSize, color, font)
    return new("TextLabel", {
        BackgroundTransparency = 1, Text = text, Size = size, Position = pos,
        Font = font or Enum.Font.Gotham, TextSize = fontSize or 14,
        TextColor3 = color or C.cream, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center, TextTruncate = Enum.TextTruncate.AtEnd,
    }, parent)
end

local main = new("Frame", {
    Name = "Main", Size = UDim2.fromOffset(590, 390),
    Position = UDim2.new(0.5, -295, 0.5, -195),
    BackgroundColor3 = C.bg, BorderSizePixel = 0,
}, gui)
corner(main, 14); stroke(main, C.orange, 0.12, 1.4)
new("UISizeConstraint", {MinSize = Vector2.new(300, 280), MaxSize = Vector2.new(720, 520)}, main)
local scale = new("UIScale", {Scale = 1}, main)
local function fitToScreen()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    scale.Scale = math.min(1, viewport.X / 620, viewport.Y / 420)
end
fitToScreen()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitToScreen)
end
new("UIGradient", {Rotation = 25, Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 40, 17)),
    ColorSequenceKeypoint.new(0.5, C.bg),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(48, 22, 14)),
})}, main)

local top = new("Frame", {Name = "Topbar", Size = UDim2.new(1, 0, 0, 58), BackgroundColor3 = C.panel, BorderSizePixel = 0}, main)
corner(top, 14)
new("Frame", {Position = UDim2.new(0, 0, 1, -14), Size = UDim2.new(1, 0, 0, 14), BackgroundColor3 = C.panel, BorderSizePixel = 0}, top)
new("UIGradient", {Rotation = 0, Color = ColorSequence.new(C.orange, C.gold)}, top)
label(top, "NHA", UDim2.fromOffset(58, 32), UDim2.fromOffset(16, 6), 24, C.bg, Enum.Font.GothamBlack)
label(top, "HUB", UDim2.fromOffset(62, 32), UDim2.fromOffset(73, 6), 24, C.cream, Enum.Font.GothamBlack)
label(top, "CAMBODIAN SUNSET EDITION", UDim2.fromOffset(230, 18), UDim2.fromOffset(18, 35), 9, C.bg, Enum.Font.GothamBold)
local close = new("TextButton", {Text = "×", Size = UDim2.fromOffset(34, 34), Position = UDim2.new(1, -45, 0, 11), BackgroundColor3 = C.panel2, TextColor3 = C.cream, Font = Enum.Font.GothamBold, TextSize = 23, BorderSizePixel = 0}, top)
corner(close, 9)

-- Drag support
local dragging, dragStart, startPos
 top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
close.Activated:Connect(function() gui.Enabled = false end)

local sidebar = new("Frame", {Position = UDim2.fromOffset(12, 70), Size = UDim2.new(0, 142, 1, -82), BackgroundColor3 = C.panel, BorderSizePixel = 0}, main)
corner(sidebar, 10)
label(sidebar, "NAVIGATION", UDim2.new(1, -20, 0, 24), UDim2.fromOffset(10, 7), 10, C.muted, Enum.Font.GothamBold)
local navList = new("Frame", {Position = UDim2.fromOffset(7, 36), Size = UDim2.new(1, -14, 1, -43), BackgroundTransparency = 1}, sidebar)
new("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, navList)

local content = new("Frame", {Position = UDim2.fromOffset(166, 70), Size = UDim2.new(1, -178, 1, -82), BackgroundColor3 = Color3.fromRGB(47, 22, 14), BorderSizePixel = 0}, main)
corner(content, 10)
local pageTitle = label(content, "Home", UDim2.new(1, -28, 0, 32), UDim2.fromOffset(14, 8), 20, C.gold, Enum.Font.GothamBold)
local pageDesc = label(content, "A clean, lightweight control panel.", UDim2.new(1, -28, 0, 22), UDim2.fromOffset(14, 38), 11, C.muted)
local pageBody = new("ScrollingFrame", {Position = UDim2.fromOffset(12, 68), Size = UDim2.new(1, -24, 1, -80), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = C.orange, CanvasSize = UDim2.new()}, content)
local bodyLayout = new("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, pageBody)
bodyLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() pageBody.CanvasSize = UDim2.fromOffset(0, bodyLayout.AbsoluteContentSize.Y + 8) end)

local pages = {Home = {}, Farm = {}, Eggs = {}, Player = {}, Visuals = {}, Settings = {}}
local currentPage = "Home"
local function clearBody()
    for _, child in ipairs(pageBody:GetChildren()) do if not child:IsA("UIListLayout") then child:Destroy() end end
end
local function addCard(title, desc)
    local card = new("Frame", {Size = UDim2.new(1, -2, 0, 58), BackgroundColor3 = C.panel, BorderSizePixel = 0}, pageBody)
    corner(card, 9); stroke(card, C.orange, 0.75, 1)
    label(card, title, UDim2.new(1, -100, 0, 25), UDim2.fromOffset(12, 5), 13, C.cream, Enum.Font.GothamBold)
    label(card, desc or "UI demonstration setting", UDim2.new(1, -100, 0, 19), UDim2.fromOffset(12, 29), 10, C.muted)
    local toggle = new("TextButton", {Size = UDim2.fromOffset(54, 28), Position = UDim2.new(1, -66, 0.5, -14), BackgroundColor3 = C.panel2, Text = "OFF", TextColor3 = C.cream, Font = Enum.Font.GothamBold, TextSize = 10, BorderSizePixel = 0}, card)
    corner(toggle, 8)
    local enabled = false
    toggle.Activated:Connect(function()
        enabled = not enabled
        toggle.Text = enabled and "ON" or "OFF"
        toggle.BackgroundColor3 = enabled and C.green or C.panel2
        toggle.TextColor3 = enabled and C.bg or C.cream
        TweenService:Create(card, TweenInfo.new(0.12), {BackgroundColor3 = enabled and Color3.fromRGB(75, 54, 25) or C.panel}):Play()
    end)
end
local function render(name)
    currentPage = name; clearBody()
    pageTitle.Text = name
    local descriptions = {
        Home = "NhaHub • Cambodian sunset interface",
        Farm = "Controls for experiences you own or are authorized to test",
        Eggs = "Egg checklist UI; entries are informational, not game automation",
        Player = "Player options UI demo only",
        Visuals = "Visual preferences and display options",
        Settings = "Interface and performance preferences",
    }
    pageDesc.Text = descriptions[name] or "NhaHub"
    if name == "Home" then
        addCard("Welcome to NhaHub", "Golden temples. Sunset colors. Compact controls.")
        addCard("Interface status", "UI loaded successfully for " .. player.DisplayName)
        addCard("Theme", "Amber / gold / deep brown palette")
    elseif name == "Farm" then
        addCard("Auto Steal", "Unavailable: this panel does not automate stealing in third-party games")
        addCard("Instant Steal", "Unavailable: no exploit or protection bypass is attached")
        addCard("Target Selector", "UI placeholder; connect only to systems in your own Roblox experience")
    elseif name == "Eggs" then
        addCard("Common Egg", "Checklist entry • informational only")
        addCard("Rare Egg", "Checklist entry • informational only")
        addCard("Epic Egg", "Checklist entry • informational only")
        addCard("Legendary Egg", "Checklist entry • informational only")
    elseif name == "Player" then
        addCard("Speed Option (UI demo)", "Toggle state only; no character changes")
        addCard("Jump Option (UI demo)", "Toggle state only; no character changes")
        addCard("Movement Preset (UI demo)", "Placeholder control for your own game")
    elseif name == "Visuals" then
        addCard("Compact Mode", "Toggle visual state")
        addCard("High Contrast", "Toggle visual state")
        addCard("Status Labels", "Toggle visual state")
    elseif name == "Settings" then
        addCard("Reduce Animations", "Toggle visual state")
        addCard("Remember Window Position", "Session-only UI option placeholder")
        addCard("Reopen NhaHub", "Close hides the panel; rerun this LocalScript to reopen")
    end
end

for i, name in ipairs({"Home", "Farm", "Eggs", "Player", "Visuals", "Settings"}) do
    local button = new("TextButton", {Name = name, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = name == currentPage and C.orange or C.panel2, Text = name, TextColor3 = name == currentPage and C.bg or C.cream, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0, LayoutOrder = i}, navList)
    corner(button, 8)
    button.Activated:Connect(function()
        for _, b in ipairs(navList:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = b == button and C.orange or C.panel2; b.TextColor3 = b == button and C.bg or C.cream end
        end
        render(name)
    end)
end
render("Home")
