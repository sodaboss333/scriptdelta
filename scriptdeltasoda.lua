--!strict
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Удаляем старое меню, если оно уже было открыто
if PlayerGui:FindFirstChild("SimpleEggGui") then
    PlayerGui.SimpleEggGui:Destroy()
end

-- Создаем графический интерфейс
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleEggGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 380)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "🥚 Авто-Яйца (Рабочий)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Кнопка включения/выключения
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 40)
toggleBtn.Position = UDim2.new(0.05, 0, 0.13, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 100)
toggleBtn.Text = "Статус: ВЫКЛЮЧЕН"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 14
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = toggleBtn

-- Список для вывода яиц
local scrolling = Instance.new("ScrollingFrame")
scrolling.Size = UDim2.new(0.9, 0, 0.68, 0)
scrolling.Position = UDim2.new(0.05, 0, 0.27, 0)
scrolling.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
scrolling.BorderSizePixel = 0
scrolling.CanvasSize = UDim2.new(0, 0, 2, 0)
scrolling.Parent = frame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 6)
scrollCorner.Parent = scrolling

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = scrolling

-- Переменная состояния бота
local isActive = false

toggleBtn.MouseButton1Click:Connect(function()
    isActive = not isActive
    if isActive then
        toggleBtn.Text = "Статус: ВКЛЮЧЕН"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        toggleBtn.Text = "Статус: ВЫКЛЮЧЕН"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 100)
    end
end)

-- Функция добавления строки в интерфейс
local function addEntry(name: string, unit: string, val: number)
    local item = Instance.new("TextLabel")
    item.Size = UDim2.new(1, -10, 0, 40)
    item.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    item.TextColor3 = Color3.fromRGB(240, 240, 240)
    item.TextSize = 11
    item.Font = Enum.Font.Gotham
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.Text = string.format(" 🥚 %s\n ⚔️ %s | 💵 Доход: +%d", name, unit, val)
    item.Parent = scrolling
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = item
end

-- Основной цикл работы
task.spawn(function()
    while true do
        if isActive then
            local char = LocalPlayer.Character
            local root = char and char.PrimaryPart
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            -- Очищаем старый список на экране
            for _, child in ipairs(scrolling:GetChildren()) do
                if child:IsA("TextLabel") then
                    child:Destroy()
                end
            end
            
            local eggsFolder = Workspace:FindFirstChild("Eggs")
            if eggsFolder and root and hum then
                for _, egg in ipairs(eggsFolder:GetChildren()) do
                    if egg:IsA("Model") then
                        local eggVal = egg:GetAttribute("EggValue") :: number or 0
                        local unitName = egg:GetAttribute("UnitName") :: string or "Неизвестно"
                        
                        -- Выводим информацию в GUI
                        addEntry(egg.Name, unitName, eggVal)
                        
                        -- Если яйцо ценное (больше или равно 100), подходим к нему
                        if eggVal >= 100 then
                            local part = egg.PrimaryPart or egg:FindFirstChildWhichIsA("BasePart")
                            if part then
                                hum:MoveTo(part.Position)
                                task.spawn(function()
                                    pcall(function()
                                        hum.MoveToFinished:Wait()
                                    end)
                                end)
                                break
                            end
                        end
                    end
                end
            end
        end
        task.wait(2)
    end
end)
