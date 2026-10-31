--!strict
--[=[
    Модуль: Automated Egg Collector UI & Bot Logic
    Назначение: Автоматизированный сбор яиц с настраиваемым фильтром заработка и кастомным GUI.
]=]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Настройки бота
local BotSettings = {
    MinEggValue = 100, -- Минимальный заработок для сбора
    ScanRadius = 200,  -- Радиус поиска
    IsActive = false,
}

-- Создание графического интерфейса (GUI)
local function createCollectorUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "EggCollectorUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CoreGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 320, 0, 420)
    mainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 12)
    uiCorner.Parent = mainFrame

    -- Заголовок
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🤖 Авто-сборщик яиц"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = mainFrame

    -- Кнопка старт/стоп
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.9, 0, 0, 45)
    toggleButton.Position = UDim2.new(0.05, 0, 0.13, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
    toggleButton.Text = "Статус: ВЫКЛЮЧЕН"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 15
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = mainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = toggleButton

    -- Скролл-контейнер для списка яиц и юнитов
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(0.9, 0, 0.65, 0)
    scrollingFrame.Position = UDim2.new(0.05, 0, 0.26, 0)
    scrollingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
    scrollingFrame.Parent = mainFrame

    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 8)
    scrollCorner.Parent = scrollingFrame

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 5)
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.Parent = scrollingFrame

    -- Логика переключения кнопки
    toggleButton.MouseButton1Click:Connect(function()
        BotSettings.IsActive = not BotSettings.IsActive
        if BotSettings.IsActive then
            toggleButton.Text = "Статус: ВКЛЮЧЕН"
            toggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        else
            toggleButton.Text = "Статус: ВЫКЛЮЧЕН"
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
        end
    end)

    return scrollingFrame
end

-- Функция добавления элемента в интерфейс (Иконка, Юнит, Заработок)
local function addEggUIEntry(container: ScrollingFrame, eggName: string, unitName: string, unitValue: number, iconId: string)
    local entryFrame = Instance.new("Frame")
    entryFrame.Size = UDim2.new(1, -10, 0, 55)
    entryFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    entryFrame.BorderSizePixel = 0
    entryFrame.Parent = container

    local entryCorner = Instance.new("UICorner")
    entryCorner.CornerRadius = UDim.new(0, 6)
    entryCorner.Parent = entryFrame

    -- Иконка яйца / юнита
    local iconLabel = Instance.new("ImageLabel")
    iconLabel.Size = UDim2.new(0, 40, 0, 40)
    iconLabel.Position = UDim2.new(0.02, 0, 0.1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Image = iconId ~= "" and iconId or "rbxassetid://6031094678" -- Стандартная иконка-заглушка
    iconLabel.Parent = entryFrame

    -- Текст с информацией
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(0.75, 0, 1, 0)
    infoLabel.Position = UDim2.new(0.22, 0, 0, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = string.format("🥚 %s\n⚔️ Юнит: %s | 💵 Доход: +%d", eggName, unitName, unitValue)
    infoLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    infoLabel.TextSize = 12
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.Parent = entryFrame
end

-- Функция проверки ценности объекта
local function isEggWorthCollecting(eggModel: Instance): boolean
    local valueAttribute = eggModel:GetAttribute("EggValue")
    if valueAttribute and typeof(valueAttribute) == "number" then
        return valueAttribute >= BotSettings.MinEggValue
    end
    return false
end

-- Основная логика поиска и сканирования мира
local function startCollectorBot()
    local uiContainer = createCollectorUI()

    task.spawn(function()
        while true do
            if BotSettings.IsActive then
                local character = LocalPlayer.Character
                local rootPart = character and character.PrimaryPart
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")

                if rootPart and humanoid then
                    local eggsFolder = Workspace:FindFirstChild("Eggs")
                    
                    if eggsFolder then
                        -- Очищаем старый интерфейс списка перед обновлением (опционально)
                        for _, child in ipairs(uiContainer:GetChildren()) do
                            if child:IsA("Frame") then child:Destroy() end
                        end

                        for _, egg in ipairs(eggsFolder:GetChildren()) do
                            if egg:IsA("Model") then
                                local eggValue = egg:GetAttribute("EggValue") :: number or 0
                                local unitName = egg:GetAttribute("UnitName") or "Неизвестно"
                                local iconId = egg:GetAttribute("IconAssetId") or ""

                                -- Выводим информацию в UI
                                addEggUIEntry(uiContainer, egg.Name, unitName, eggValue, iconId)

                                -- Проверяем условие сбора по минимальному заработку
                                if
                    
