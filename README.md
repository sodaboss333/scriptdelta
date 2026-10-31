--!strict
-- Модуль логики для NPC-собирателя / бота-помощника

local Workspace = game:GetService("Workspace")
local PathfindingService = game:GetService("PathfindingService")

local BotSettings = {
    MinEggValue = 100, -- Минимальный заработок/ценность яйца для сбора
    ScanRadius = 150,  -- Радиус поиска
}

-- Функция проверки ценности объекта
local function isEggWorthCollecting(eggModel: Instance): boolean
    local valueAttribute = eggModel:GetAttribute("EggValue")
    if valueAttribute and typeof(valueAttribute) == "number" then
        return valueAttribute >= BotSettings.MinEggValue
    end
    return false
end

-- Функция поиска ближайшего подходящего яйца
local function findBestEgg(botPosition: Vector3): Instance?
    local bestEgg: Instance? = nil
    local highestValue = BotSettings.MinEggValue - 1

    local eggsFolder = Workspace:FindFirstChild("Eggs")
    if not eggsFolder then return nil end

    for _, egg in ipairs(eggsFolder:GetChildren()) do
        if egg:IsA("Model") and isEggWorthCollecting(egg) then
            local primaryPart = egg.PrimaryPart
            if primaryPart then
                local distance = (primaryPart.Position - botPosition).Magnitude
                local eggValue = egg:GetAttribute("EggValue") :: number

                -- Выбираем самое ценное яйцо в радиусе
                if distance <= BotSettings.ScanRadius and eggValue > highestValue then
                    highestValue = eggValue
                    bestEgg = egg
                end
            end
        end
    end

    return bestEgg
end

-- Основной цикл работы бота (использует Task Scheduler)
local function startCollectingLoop(character: Model)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character.PrimaryPart

    if not humanoid or not rootPart then return end

    task.spawn(function()
        while character.Parent do
            local targetEgg = findBestEgg(rootPart.Position)
            
            if targetEgg and targetEgg.PrimaryPart then
                -- Перемещение к объекту
                humanoid:MoveTo(targetEgg.PrimaryPart.Position)
                humanoid.MoveToFinished:Wait()

                -- Логика взаимодействия/сбора
                print("Собрано яйцо с ценностью: " .. tostring(targetEgg:GetAttribute("EggValue")))
            end

            -- Интервал проверки для снижения нагрузки на сервер
            task.wait(1)
        end
    end)
end

return {
    Settings = BotSettings,
    Start = startCollectingLoop
}
