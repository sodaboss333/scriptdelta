--!strict
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Используем PlayerGui вместо CoreGui, чтобы интерфейс точно отображался на мобильных
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("TikTokHub_TOH") then
    playerGui.TikTokHub_TOH:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TikTokHub_TOH"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 560, 0, 380)
mainFrame.Position = UDim2.new(0.5, -280, 0.5, -190) -- Строго по центру экрана
mainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Левая панель (Профиль + Вкладки)
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 160, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 8)
sideCorner.Parent = sidebar

local logoTitle = Instance.new("TextLabel")
logoTitle.Size = UDim2.new(1, 0, 0, 25)
logoTitle.Position = UDim2.new(0, 0, 0, 8)
logoTitle.BackgroundTransparency = 1
logoTitle.Text = "TikTok: @4sv_soda"
logoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
logoTitle.Font = Enum.Font.GothamBold
logoTitle.TextSize = 12
logoTitle.Parent = sidebar

-- Аватарка и ник
local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(0, 36, 0, 36)
avatarImg.Position = UDim2.new(0, 10, 0, 38)
avatarImg.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
pcall(function()
    avatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)
avatarImg.Parent = sidebar

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarImg

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(0, 100, 0, 18)
nameLabel.Position = UDim2.new(0, 52, 0, 38)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = LocalPlayer.Name
nameLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 11
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = sidebar

local tagProfileLabel = Instance.new("TextLabel")
tagProfileLabel.Size = UDim2.new(0, 100, 0, 15)
tagProfileLabel.Position = UDim2.new(0, 52, 0, 56)
tagProfileLabel.BackgroundTransparency = 1

local isOwner = (string.lower(LocalPlayer.Name) == "sodaklav" or string.lower(LocalPlayer.DisplayName) == "sodaklav")
tagProfileLabel.Text = isOwner and "[ BOSS ]" or "[ who is this? ]"
tagProfileLabel.TextColor3 = isOwner and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(150, 150, 150)
tagProfileLabel.Font = Enum.Font.GothamBold
tagProfileLabel.TextSize = 11
tagProfileLabel.TextXAlignment = Enum.TextXAlignment.Left
tagProfileLabel.Parent = sidebar

-- Контейнеры для вкладок
local tabsContainer = Instance.new("Folder")
tabsContainer.Name = "TabsContainer"
tabsContainer.Parent = mainFrame

local function createContentPanel()
    local cf = Instance.new("ScrollingFrame")
    cf.Size = UDim2.new(0, 370, 1, -20)
    cf.Position = UDim2.new(0, 175, 0, 10)
    cf.BackgroundTransparency = 1
    cf.BorderSizePixel = 0
    cf.CanvasSize = UDim2.new(0, 0, 0, 450)
    cf.ScrollBarThickness = 4
    cf.Visible = false
    cf.Parent = tabsContainer
    return cf
end

local panelBoost = createContentPanel()
local panelAutoWin = createContentPanel()
local panelVisuals = createContentPanel()
local panelTroll = createContentPanel()

panelBoost.Visible = true

local function createTabButton(name, posY, targetPanel)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 210)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = sidebar
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, panel in pairs(tabsContainer:GetChildren()) do
            panel.Visible = false
        end
        targetPanel.Visible = true
    end)
end

createTabButton("Boost", 85, panelBoost)
createTabButton("AutoWin", 125, panelAutoWin)
createTabButton("Visuals", 165, panelVisuals)
createTabButton("Troll", 205, panelTroll)
