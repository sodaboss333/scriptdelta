-- Fart Obby Ultimate Hub (Infinite Farts)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer

-- Очистка старого интерфейса
for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name == "FartObbyProHub" then
        gui:Destroy()
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FartObbyProHub"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui
end

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Position = UDim2.new(0.5, -240, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Верхняя панель
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.03, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💨 Infinite Fart Hub  |  v2.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(180, 50, 50)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Левая боковая панель
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideLayout = Instance.new("UIListLayout")
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Padding = UDim.new(0, 4)
SideLayout.Parent = Sidebar

-- Контейнер страниц
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -135, 1, -45)
Container.Position = UDim2.new(0, 135, 0, 40)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local pages = {}
local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 280)
    page.ScrollBarThickness = 3
    page.Parent = Container

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page

    pages[name] = page
    return page
end

local pageAutomation = createPage("Automation")
local pageHacks = createPage("Hacks")

local function createTabButton(name, targetPage)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    btn.BackgroundTransparency = 1
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.fromRGB(180, 180, 190)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        targetPage.Visible = true
    end)
end

createTabButton("⚡ Фарм / Пуки", pageAutomation)
createTabButton("🔥 Движение", pageHacks)

pageAutomation.Visible = true

local function createToggle(page, text, callback)
    local item = Instance.new("Frame")
    item.Size = UDim2.new(1, -10, 0, 45)
    item.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    item.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = item

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.75, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = item

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 44, 0, 22)
    toggleBtn.Position = UDim2.new(1, -54, 0.5, -11)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    toggleBtn.Text = ""
    toggleBtn.Parent = item

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = UDim2.new(0, 2, 0.5, -9)
    circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    circle.Parent = toggleBtn

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = circle

    local active = false
    toggleBtn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
            circle.Position = UDim2.new(1, -20, 0.5, -9)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            circle.Position = UDim2.new(0, 2, 0.5, -9)
        end
        callback(active)
    end)
end

-- 1. БЕСКОНЕЧНЫЕ ПУКИ (Спам пакетов без КД)
createToggle(pageAutomation, "🔥 Бесконечные Пуки (No Cooldown)", function(state)
    getgenv().infFart = state
    if state then
        -- Быстрый параллельный цикл для обхода задержки
        task.spawn(function()
            while getgenv().infFart do
                pcall(function()
                    -- Поиск всех инстансов ремоутов пука в игре
                    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                        if v:IsA("RemoteEvent") and (v.Name:lower():find("fart") or v.Name:lower():find("blow") or v.Name:lower():find("boost")) then
                            v:FireServer(true)
                            v:FireServer(100)
                        end
                    end
                    
                    -- Сброс значения шкалы напрямую в персонаже (если привязано)
                    if localPlayer.Character and localPlayer.Character:FindFirstChild("FartPower") then
                        localPlayer.Character.FartPower.Value = 999999
                    end
                end)
                task.wait(0.01) -- Минимальный интервал для максимальной скорости
            end
        end)
    end
end)

createToggle(pageAutomation, "🧲 Авто-сбор монет и наград", function(state)
    getgenv().autoCollect = state
    task.spawn(function()
        while getgenv().autoCollect do
            pcall(function()
                local char = localPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower():find("coin") or obj.Name:lower():find("gem") or obj.Name:lower():find("star")) then
                            obj.CFrame = hrp.CFrame
                        end
                    end
                end
            end)
            task.wait(0.3)
        end
    end)
end)

-- 2. ДВИЖЕНИЕ
createToggle(pageHacks, "🚀 Сверхбыстрый Бег (SpeedHack)", function(state)
    getgenv().speedHack = state
    task.spawn(function()
        while getgenv().speedHack do
            pcall(function()
                local char = localPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char.Humanoid.WalkSpeed = 70
                end
            end)
            task.wait(0.1)
        end
    end)
end)

createToggle(pageHacks, "🛡️ Защита от AFK", function(state)
    local VirtualUser = game:GetService("VirtualUser")
    localPlayer.Idled:Connect(function()
        if state then
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end)
end)
