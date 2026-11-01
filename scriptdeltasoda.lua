-- Inf Jump по нажатию кнопки прыжка с регулировкой скорости для Delta
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Создание UI интерфейса
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StairJumpUI"
ScreenGui.ResetOnSpawn = false

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Position = UDim2.new(0.5, -110, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Jump Boost (Delta)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Переключатель ON/OFF
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.85, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.075, 0, 0.22, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.Text = "BOOST: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 13
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleButton

-- Настройка высоты/скорости
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 25)
SpeedLabel.Position = UDim2.new(0, 0, 0.52, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Jump Power: 5"
SpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedLabel.TextSize = 13
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Parent = MainFrame

local MinusBtn = Instance.new("TextButton")
MinusBtn.Size = UDim2.new(0.25, 0, 0, 30)
MinusBtn.Position = UDim2.new(0.1, 0, 0.72, 0)
MinusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinusBtn.Text = "-"
MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusBtn.TextSize = 18
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.Parent = MainFrame

local PlusBtn = Instance.new("TextButton")
PlusBtn.Size = UDim2.new(0.25, 0, 0, 30)
PlusBtn.Position = UDim2.new(0.65, 0, 0.72, 0)
PlusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusBtn.TextSize = 18
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.Parent = MainFrame

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 4)
BtnCorner1.Parent = MinusBtn

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 4)
BtnCorner2.Parent = PlusBtn

-- Логика
local scriptEnabled = false
local jumpPower = 5
local isJumping = false

ToggleButton.MouseButton1Click:Connect(function()
    scriptEnabled = not scriptEnabled
    if scriptEnabled then
        ToggleButton.Text = "BOOST: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        ToggleButton.Text = "BOOST: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

MinusBtn.MouseButton1Click:Connect(function()
    if jumpPower > 1 then
        jumpPower = jumpPower - 2
        SpeedLabel.Text = "Jump Power: " .. tostring(jumpPower)
    end
end)

PlusBtn.MouseButton1Click:Connect(function()
    jumpPower = jumpPower + 3
    SpeedLabel.Text = "Jump Power: " .. tostring(jumpPower)
end)

-- Отслеживание зажатия кнопки прыжка (клавиатура / экран)
UserInputService.JumpRequest:Connect(function()
    if scriptEnabled then
        isJumping = true
    end
end)

-- Применение импульса только в момент прыжка
RunService.RenderStepped:Connect(function()
    if scriptEnabled and isJumping then
        local character = localPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            hrp.CFrame = hrp.CFrame + Vector3.new(0, jumpPower, 0) + (hrp.CFrame.LookVector * (jumpPower * 0.2))
            
            if character:FindFirstChildOfClass("Humanoid") then
                character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
        isJumping = false
    end
end)
