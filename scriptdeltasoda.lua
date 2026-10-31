--!strict
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local parent = gethui and gethui() or CoreGui

if parent:FindFirstChild("RyuHub_TOH") then
    parent.RyuHub_TOH:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RyuHub_TOH"
screenGui.ResetOnSpawn = false
screenGui.Parent = parent

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 340)
mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Левая панель (Категории)
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 150, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 8)
sideCorner.Parent = sidebar

local logoTitle = Instance.new("TextLabel")
logoTitle.Size = UDim2.new(1, 0, 0, 50)
logoTitle.BackgroundTransparency = 1
logoTitle.Text = "RYU HUB"
logoTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
logoTitle.Font = Enum.Font.GothamBold
logoTitle.TextSize = 16
logoTitle.Parent = sidebar

local logoSub = Instance.new("TextLabel")
logoSub.Size = UDim2.new(1, 0, 0, 20)
logoSub.Position = UDim2.new(0, 0, 0, 35)
logoSub.BackgroundTransparency = 1
logoSub.Text = "Tower of Hell Suite"
logoSub.TextColor3 = Color3.fromRGB(130, 130, 140)
logoSub.Font = Enum.Font.Gotham
logoSub.TextSize = 10
logoSub.Parent = sidebar

-- Правая панель (Контент)
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(0, 355, 1, -20)
contentFrame.Position = UDim2.new(0, 160, 0, 10)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
contentFrame.ScrollBarThickness = 4
contentFrame.Parent = mainFrame

local sectionTitle = Instance.new("TextLabel")
sectionTitle.Size = UDim2.new(1, 0, 0, 30)
sectionTitle.BackgroundTransparency = 1
sectionTitle.Text = "Movement Adjustments"
sectionTitle.TextColor3 = Color3.fromRGB(200, 200, 210)
sectionTitle.Font = Enum.Font.GothamBold
sectionTitle.TextSize = 13
sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
sectionTitle.Parent = contentFrame

-- Переменные функций
local speedEnabled = false
local speedVal = 48
local jumpEnabled = false
local jumpVal = 150
local flyEnabled = false
local flySpeedVal = 60
local infJumpEnabled = false

-- Функция создания строк с переключателями (Toggle)
local function createToggle(name, posY, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 35)
    label.Position = UDim2.new(0, 0, 0, posY)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(190, 190, 200)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = contentFrame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 20)
    toggleBtn.Position = UDim2.new(0.85, 0, 0, posY + 7)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    toggleBtn.Text = ""
    toggleBtn.Parent = contentFrame

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0, 2, 0, 2)
    circle.BackgroundColor3 = Color3.fromRGB(150, 150, 160)
    circle.Parent = toggleBtn

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = circle

    local active = false
    toggleBtn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
            circle.Position = UDim2.new(0, 22, 0, 2)
            circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            circle.Position = UDim2.new(0, 2, 0, 2)
            circle.BackgroundColor3 = Color3.fromRGB(150, 150, 160)
        end
        callback(active)
    end)
end

-- Добавляем элементы по образцу со скриншота
createToggle("Speed Boost", 40, function(state)
    speedEnabled = state
end)

createToggle("Super Jump", 110, function(state)
    jumpEnabled = state
end)

createToggle("Fly", 180, function(state)
    flyEnabled = state
end)

createToggle("Infinite Jump", 250, function(state)
    infJumpEnabled = state
end)

-- Логика применения улучшений движения
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if speedEnabled then
            hum.WalkSpeed = speedVal
        end
        if jumpEnabled then
            hum.JumpPower = jumpVal
        end
    end
end)

-- Бесконечный прыжок
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
