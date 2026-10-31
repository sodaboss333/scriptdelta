--!strict
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Удаляем старое меню, если оно уже было открыто
if PlayerGui:FindFirstChild("TowerOfHellGui") then
    PlayerGui.TowerOfHellGui:Destroy()
end

-- Создаем главный GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TowerOfHellGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Главное окно (передвигаемое)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 240)
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

-- Шапка окна для перетаскивания
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🗼 Tower of Hell Assistant"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = topBar

-- Перетаскивание окна пальцем
local dragging, dragInput, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Переключатель: Infinite Jump
local infJumpBtn = Instance.new("TextButton")
infJumpBtn.Size = UDim2.new(0.9, 0, 0, 50)
infJumpBtn.Position = UDim2.new(0.05, 0, 0.22, 0)
infJumpBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
infJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
infJumpBtn.Text = "Infinite Jump: ВЫКЛ"
infJumpBtn.TextSize = 13
infJumpBtn.Font = Enum.Font.GothamBold
infJumpBtn.Parent = mainFrame

local btnCorner1 = Instance.new("UICorner")
btnCorner1.CornerRadius = UDim.new(0, 8)
btnCorner1.Parent = infJumpBtn

-- Переключатель: Auto Climb (Автоподъем наверх)
local autoClimbBtn = Instance.new("TextButton")
autoClimbBtn.Size = UDim2.new(0.9, 0, 0, 50)
autoClimbBtn.Position = UDim2.new(0.05, 0, 0.58, 0)
autoClimbBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
autoClimbBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoClimbBtn.Text = "Auto Climb (Авто-проход): ВЫКЛ"
autoClimbBtn.TextSize: UDim2 = UDim2.new()
autoClimbBtn.TextSize = 12
autoClimbBtn.Font = Enum.Font.GothamBold
autoClimbBtn.Parent = mainFrame

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 8)
btnCorner2.Parent = autoClimbBtn

-- Логика Infinite Jump
local infJumpEnabled = false
infJumpBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    if infJumpEnabled then
        infJumpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
        infJumpBtn.Text = "Infinite Jump: ВКЛ"
    else
        infJumpBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        infJumpBtn.Text = "Infinite Jump: ВЫКЛ"
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local character = LocalPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Логика Auto Climb (плавный подъем персонажа вверх к финишу)
local autoClimbEnabled = false
autoClimbBtn.MouseButton1Click:Connect(function()
    autoClimbEnabled = not autoClimbEnabled
    if autoClimbEnabled then
        autoClimbBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
        autoClimbBtn.Text = "Auto Climb (Авто-проход): ВКЛ"
    else
        autoClimbBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        autoClimbBtn.Text = "Auto Climb (Авто-проход): ВЫКЛ"
    end
end)

RunService.RenderStepped:Connect(function()
    if autoClimbEnabled then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            -- Плавное перемещение персонажа строго вверх по башне
            hrp.Velocity = Vector3.new(0, 35, 0)
        end
    end
end)
