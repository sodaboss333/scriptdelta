-- PS99 Stairway to Heaven - Ultimate Auto-Climb & Temple Scanner для Delta
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer

-- Создание UI интерфейса
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PS99AutoTempleUI"
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
MainFrame.Size = UDim2.new(0, 240, 0, 185)
MainFrame.Position = UDim2.new(0.5, -120, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
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
Title.Text = "Auto-Climb & Temple Finder"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Кнопка Старт/Стоп
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.85, 0, 0, 38)
ToggleButton.Position = UDim2.new(0.075, 0, 0.22, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.Text = "AUTO-FLY: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleButton

-- Индикатор статуса
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 0.46, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Waiting to start..."
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- Настройка максимальной скорости
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0, 0, 0.63, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Fly Speed: 15"
SpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedLabel.TextSize = 12
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Parent = MainFrame

local MinusBtn = Instance.new("TextButton")
MinusBtn.Size = UDim2.new(0.35, 0, 0, 26)
MinusBtn.Position = UDim2.new(0.1, 0, 0.78, 0)
MinusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinusBtn.Text = "- Speed"
MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusBtn.TextSize = 11
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.Parent = MainFrame

local PlusBtn = Instance.new("TextButton")
PlusBtn.Size = UDim2.new(0.35, 0, 0, 26)
PlusBtn.Position = UDim2.new(0.55, 0, 0.78, 0)
PlusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlusBtn.Text = "+ Speed"
PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusBtn.TextSize = 11
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.Parent = MainFrame

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 4)
BtnCorner1.Parent = MinusBtn

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 4)
BtnCorner2.Parent = PlusBtn

-- Логика скрипта
local autoFlyActive = false
local flySpeed = 15 -- Скорость полета вверх
local templeFound = false

ToggleButton.MouseButton1Click:Connect(function()
    autoFlyActive = not autoFlyActive
    if autoFlyActive then
        ToggleButton.Text = "AUTO-FLY: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        templeFound = false
    else
        ToggleButton.Text = "AUTO-FLY: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        StatusLabel.Text = "Status: Paused"
        StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
end)

MinusBtn.MouseButton1Click:Connect(function()
    if flySpeed > 5 then
        flySpeed = flySpeed - 5
        SpeedLabel.Text = "Fly Speed: " .. tostring(flySpeed)
    end
end)

PlusBtn.MouseButton1Click:Connect(function()
    flySpeed = flySpeed + 5
    SpeedLabel.Text = "Fly Speed: " .. tostring(flySpeed)
end)

-- Функция поиска храма/финала в пространстве
local function scanForTemple(hrp)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local name = obj.Name:lower()
            -- Ищем ключевые слова финала лестницы
            if name:find("temple") or name:find("angel") or name:find("heaven") or name:find("huge") or name:find("goal") then
                local targetPart = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
                if targetPart and (targetPart.Position - hrp.Position).Magnitude < 3000 then
                    return targetPart
                end
            end
        end
    end
    return nil
end

-- Основной цикл полета и сканирования
RunService.RenderStepped:Connect(function()
    if autoFlyActive and not templeFound then
        local character = localPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            
            -- 1. Сканируем, не появился ли храм
            local temple = scanForTemple(hrp)
            if temple then
                templeFound = true
                autoFlyActive = false
                
                -- Мгновенно телепортируемся к найденному храму
                hrp.CFrame = temple.CFrame + Vector3.new(0, 3, 0)
                
                -- Меняем интерфейс на успех
                StatusLabel.Text = "ХРАМ НАЙДЕН!"
                StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
                ToggleButton.Text = "DONE!"
                ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
                return
            end
            
            -- 2. Если храм не найден, летим строго вверх на максимальной скорости
            hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, flySpeed, 0)) * (hrp.CFrame - hrp.Position)
            
            -- Обновляем статус высоты
            StatusLabel.Text = "Height Y: " .. math.floor(hrp.Position.Y) .. " (Flying...)"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
            
            -- Держим статус персонажа, чтобы не кикало за полет
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end
end)
