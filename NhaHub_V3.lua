-- NhaHub | Survive Deep in the Woods
-- UI inspired by the uploaded gameplay video.
-- Place in a LocalScript in your own Roblox Studio test place.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

local old = player:WaitForChild("PlayerGui"):FindFirstChild("NhaHub")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "NhaHub"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(250, 350)
main.Position = UDim2.new(0, 18, 0.25, 0)
main.BackgroundColor3 = Color3.fromRGB(19, 21, 30)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local uiScale = Instance.new("UIScale")
uiScale.Parent = main

local function fitToScreen()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local view = camera.ViewportSize
    uiScale.Scale = math.clamp(math.min(view.X / 390, view.Y / 540), 0.72, 1)
    main.Position = UDim2.new(0, 12, 0.18, 0)
end
fitToScreen()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitToScreen)
end

local outline = Instance.new("UIStroke", main)
outline.Color = Color3.fromRGB(86, 130, 255)
outline.Thickness = 1.4

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -44, 0, 42)
title.Position = UDim2.fromOffset(12, 2)
title.BackgroundTransparency = 1
title.Text = "NhaHub"
title.TextColor3 = Color3.fromRGB(225, 232, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30, 30)
close.Position = UDim2.new(1, -38, 0, 7)
close.BackgroundColor3 = Color3.fromRGB(48, 52, 69)
close.Text = "×"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 20
close.Parent = main
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
close.Activated:Connect(function() main.Visible = false end)

local sub = Instance.new("TextLabel")
sub.Position = UDim2.fromOffset(12, 40)
sub.Size = UDim2.new(1, -24, 0, 20)
sub.BackgroundTransparency = 1
sub.Text = "SURVIVE DEEP IN THE WOODS"
sub.TextColor3 = Color3.fromRGB(145, 155, 180)
sub.Font = Enum.Font.Gotham
sub.TextSize = 9
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.Parent = main

local panel = Instance.new("ScrollingFrame")
panel.Position = UDim2.fromOffset(10, 66)
panel.Size = UDim2.new(1, -20, 1, -76)
panel.BackgroundTransparency = 1
panel.BorderSizePixel = 0
panel.ScrollBarThickness = 3
panel.ScrollBarImageColor3 = Color3.fromRGB(86, 130, 255)
panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
panel.CanvasSize = UDim2.new(0, 0, 0, 0)
panel.ScrollingDirection = Enum.ScrollingDirection.Y
panel.Parent = main

local layout = Instance.new("UIListLayout", panel)
layout.Padding = UDim.new(0, 7)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function character()
    return player.Character
end

local function humanoid()
    local c = character()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local flags = {Speed = false, Jump = false, ESP = false, LowFX = false, FPSBoost = false}
local original = {WalkSpeed = 16, JumpPower = 50}
local highlights = {}
local espColors = {
    Color3.fromRGB(255, 95, 95),
    Color3.fromRGB(80, 190, 255),
    Color3.fromRGB(105, 255, 155),
    Color3.fromRGB(255, 205, 75),
}
local espColorIndex = 1

local function setESP(enabled)
    for _, h in pairs(highlights) do
        if h then h:Destroy() end
    end
    table.clear(highlights)
    if not enabled then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local h = Instance.new("Highlight")
            h.Name = "NhaHubHighlight"
            h.FillColor = espColors[espColorIndex]
            h.OutlineColor = Color3.fromRGB(255, 255, 255)
            h.FillTransparency = 0.65
            h.Adornee = p.Character
            h.Parent = gui
            highlights[p] = h
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if flags.ESP then setESP(true) end
    end)
end)

Players.PlayerRemoving:Connect(function(p)
    if highlights[p] then highlights[p]:Destroy() end
    highlights[p] = nil
end)

local function refreshMovement()
    local h = humanoid()
    if not h then return end
    h.WalkSpeed = flags.Speed and 28 or original.WalkSpeed
    h.UseJumpPower = true
    h.JumpPower = flags.Jump and 85 or original.JumpPower
end

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    local h = humanoid()
    if h then
        original.WalkSpeed = h.WalkSpeed
        original.JumpPower = h.JumpPower
        refreshMovement()
    end
    if flags.ESP then setESP(true) end
end)

local function addToggle(label, key, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 34)
    b.BackgroundColor3 = Color3.fromRGB(36, 39, 54)
    b.TextColor3 = Color3.fromRGB(224, 228, 242)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 12
    b.AutoButtonColor = false
    b.Parent = panel
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)

    local function draw()
        b.Text = label .. "     [" .. (flags[key] and "ON" or "OFF") .. "]"
        b.BackgroundColor3 = flags[key]
            and Color3.fromRGB(35, 79, 66)
            or Color3.fromRGB(36, 39, 54)
    end

    b.Activated:Connect(function()
        flags[key] = not flags[key]
        if callback then callback(flags[key]) end
        draw()
    end)
    draw()
end

addToggle("Speed", "Speed", refreshMovement)
addToggle("Super Jump", "Jump", refreshMovement)
addToggle("Player ESP", "ESP", setESP)

local espColorButton = Instance.new("TextButton")
espColorButton.Size = UDim2.new(1, 0, 0, 34)
espColorButton.BackgroundColor3 = Color3.fromRGB(36, 39, 54)
espColorButton.TextColor3 = Color3.fromRGB(224, 228, 242)
espColorButton.Font = Enum.Font.GothamMedium
espColorButton.TextSize = 12
espColorButton.Text = "ESP Color: Red"
espColorButton.Parent = panel
Instance.new("UICorner", espColorButton).CornerRadius = UDim.new(0, 7)
local espColorNames = {"Red", "Blue", "Green", "Gold"}
espColorButton.Activated:Connect(function()
    espColorIndex = (espColorIndex % #espColors) + 1
    espColorButton.Text = "ESP Color: " .. espColorNames[espColorIndex]
    if flags.ESP then setESP(true) end
end)

-- Keep original values so visual settings can be restored when toggled off.
local visualBackup = {}
local function applyFPSBoost(enabled)
    if enabled then
        visualBackup.GlobalShadows = Lighting.GlobalShadows
        visualBackup.Effects = {}
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("PostEffect") then
                visualBackup.Effects[obj] = obj.Enabled
                obj.Enabled = false
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail")
                or obj:IsA("Beam") or obj:IsA("Fire")
                or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                visualBackup.Effects[obj] = obj.Enabled
                obj.Enabled = false
            end
        end
        Lighting.GlobalShadows = false
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
    else
        if visualBackup.GlobalShadows ~= nil then
            Lighting.GlobalShadows = visualBackup.GlobalShadows
        end
        for obj, wasEnabled in pairs(visualBackup.Effects or {}) do
            if obj and obj.Parent then
                pcall(function() obj.Enabled = wasEnabled end)
            end
        end
        table.clear(visualBackup)
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end)
    end
end

addToggle("Low Graphics", "LowFX", function(on)
    Lighting.GlobalShadows = not on
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj.Enabled = not on
        end
    end
end)

addToggle("FPS Boost", "FPSBoost", applyFPSBoost)

-- Drag panel by its title; works with mouse and touch.
local dragging, dragInput, dragStart, startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragInput = true, input
        dragStart, startPos = input.Position, main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input == dragInput or input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Reopen button remains available after closing the panel.
local reopen = Instance.new("TextButton")
reopen.Size = UDim2.fromOffset(58, 58)
reopen.Position = UDim2.new(0, 12, 0.25, 0)
reopen.BackgroundColor3 = Color3.fromRGB(38, 48, 78)
reopen.Text = "NH"
reopen.TextColor3 = Color3.new(1, 1, 1)
reopen.Font = Enum.Font.GothamBold
reopen.TextSize = 16
reopen.Visible = false
reopen.Parent = gui
Instance.new("UICorner", reopen).CornerRadius = UDim.new(1, 0)
local reopenStroke = Instance.new("UIStroke", reopen)
reopenStroke.Color = Color3.fromRGB(86, 130, 255)
reopenStroke.Thickness = 2
close.Activated:Connect(function() reopen.Visible = true end)
reopen.Activated:Connect(function()
    main.Visible = true
    reopen.Visible = false
end)

-- Lightweight FPS counter; updates once per second to minimize overhead.
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPSCounter"
fpsLabel.AnchorPoint = Vector2.new(1, 0)
fpsLabel.Position = UDim2.new(1, -12, 0, 12)
fpsLabel.Size = UDim2.fromOffset(112, 28)
fpsLabel.BackgroundColor3 = Color3.fromRGB(19, 21, 30)
fpsLabel.BackgroundTransparency = 0.12
fpsLabel.TextColor3 = Color3.fromRGB(145, 255, 185)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 12
fpsLabel.Text = "FPS: --"
fpsLabel.Parent = gui
Instance.new("UICorner", fpsLabel).CornerRadius = UDim.new(0, 7)

local frames, elapsed = 0, 0
local fpsConnection
fpsConnection = RunService.RenderStepped:Connect(function(dt)
    frames += 1
    elapsed += dt
    if elapsed >= 1 then
        fpsLabel.Text = "FPS: " .. tostring(math.floor(frames / elapsed + 0.5))
        frames, elapsed = 0, 0
    end
end)

print("NhaHub loaded.")
