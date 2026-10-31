--!strict
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Удаляем старое меню, если оно было
if PlayerGui:FindFirstChild("AirStealEggGui") then
    PlayerGui.AirStealEggGui:Destroy()
end

-- Создаем GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AirStealEggGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Главное окно (передвигаемое)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 310, 0, 420)
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

-- Шапка окна (для перетаскивания)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🦅 Air Steal: Eggs & Flight"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = topBar

-- Логика перетаскивания окна пальцем
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
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Кнопка Старт/Стоп
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 45)
toggleBtn.Position = UDim2.new(0.05, 0, 0.13, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
toggleBtn.Text = "Статус: ВЫКЛЮЧЕН"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 14
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleBtn

-- Контейнер со списком (логи)
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(0.9, 0, 0.65, 0)
scrollingFrame.Position = UDim2.new(0.05, 0, 0.27, 0)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.CanvasSize = UDim2.new(0, 0, 3, 0)
scrollingFrame.Parent = mainFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = scrollingFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.Parent = scrollingFrame

-- Состояние бота
local botActive = false

toggleBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    if botActive then
        toggleBtn.Text = "Статус: ВКЛЮЧЕН (Полет за яйцами)"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    else
        toggleBtn.Text = "Статус: ВЫКЛЮЧЕН"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
    end
end)

-- Функция вывода логов
local function addLog(text: string)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 35)
    label.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = " " .. text
    label.Parent = scrollingFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = label
end

-- Основная логика полета по воздуху к яйцу и возврата к линии
task.spawn(function()
    while true do
        if botActive then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            for _, child in ipairs(scrollingFrame:GetChildren()) do
                if child:IsA("TextLabel") then
                    child:Destroy()
                end
            end
            
            local eggsFolder = Workspace:FindFirstChild("Eggs")
            if eggsFolder and root and hum then
                addLog("☁️ Поиск яиц для воздушной кражи...")
                
                for _, egg in ipairs(eggsFolder:GetChildren()) do
                    if not botActive then break end
                    if egg:IsA("Model") then
                        local val = egg:GetAttribute("EggValue") :: number or 0
                        local unit = egg:GetAttribute("UnitName") :: string or "Яйцо"
                        
                        addLog(string.format("🥚 Найдено: %s (+%d)", unit, val))
                        
                        -- Если яйцо ценное, летим к нему
                        if val >= 50 then
                            local part = egg.PrimaryPart or egg:FindFirstChildWhichIsA("BasePart")
                            if part then
                                addLog("🚀 Взлет и полет к яйцу...")
                                
                                -- Отключаем падение/физику ног на время полета
                                hum.PlatformStand = true
                                
                                -- Плавный полет по воздуху к яйцу (на высоте +10 блоков над ним)
                                local targetPos = part.Position + Vector3.new(0, 10, 0)
                                local startPosAnim = root.Position
                                
                                local duration = 1.2
                                local elapsed = 0
                                
                                while elapsed < duration and botActive do
                                    local dt = RunService.RenderStepped:Wait()
                                    elapsed = elapsed + dt
                                    local alpha = math.clamp(elapsed / duration, 0, 1)
                                    root.CFrame = CFrame.new(startPosAnim:Lerp(targetPos, alpha))
                                    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                end
                                
                                -- Опускаемся прямо на яйцо для захвата
                                root.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                                task.wait(0.4)
                                
                                addLog("📦 Яйцо захвачено! Несем к линии...")
                                
                                -- Точка доставки (линия). Если у вас есть конкретная позиция базы/линии, замените вектор ниже:
                                -- Например: Vector3.new(0, 5, 0) или позиция вашего тайкона/базы
                                local deliveryPos = root.Position + Vector3.new(0, 20, -50) -- Условный возврат назад к линии
                                
                                local returnElapsed = 0
                                local currentPos = root.Position
                                while returnElapsed < 1.2 and botActive do
                                    local dt = RunService.RenderStepped:Wait()
                                    returnElapsed = returnElapsed + dt
                                    local alpha = math.clamp(returnElapsed / 1.2, 0, 1)
                                    root.CFrame = CFrame.new(currentPos:Lerp(deliveryPos, alpha))
                                    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                end
                                
                                -- Возвращаем персонажу обычное состояние
                                hum.PlatformStand = false
                                task.wait(0.5)
                            end
                        end
                    end
                end
            else
                addLog("⚠️ Папка Eggs или персонаж не найдены")
            end
        end
        task.wait(2)
    end
end)
