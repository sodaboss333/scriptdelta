--!strict
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local parent = gethui and gethui() or CoreGui

if parent:FindFirstChild("TikTokHub_TOH") then
    parent.TikTokHub_TOH:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TikTokHub_TOH"
screenGui.ResetOnSpawn = false
screenGui.Parent = parent

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 540, 0, 380)
mainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Левая панель (Категории и профиль)
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 160, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 8)
sideCorner.Parent = sidebar

local logoTitle = Instance.new("TextLabel")
logoTitle.Size = UDim2.new(1, 0, 0, 30)
logoTitle.Position = UDim2.new(0, 0, 0, 8)
logoTitle.BackgroundTransparency = 1
logoTitle.Text = "TikTok: @4sv_soda"
logoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
logoTitle.Font = Enum.Font.GothamBold
logoTitle.TextSize = 12
logoTitle.Parent = sidebar

-- Аватарка и ник игрока в панели
local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(0, 40, 0, 40)
avatarImg.Position = UDim2.new(0, 12, 0, 45)
avatarImg.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
avatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
avatarImg.Parent = sidebar

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarImg

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(0, 95, 0, 20)
nameLabel.Position = UDim2.new(0, 58, 0, 48)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = LocalPlayer.Name
nameLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 11
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = sidebar

local tagProfileLabel = Instance.new("TextLabel")
tagProfileLabel.Size = UDim2.new(0, 95, 0, 15)
tagProfileLabel.Position = UDim2.new(0, 58, 0, 68)
tagProfileLabel.BackgroundTransparency = 1

-- Проверка на ваш ник (sodaklav)
local isOwner = (string.lower(LocalPlayer.Name) == "sodaklav" or string.lower(LocalPlayer.DisplayName) == "sodaklav")
tagProfileLabel.Text = isOwner and "[ BOSS ]" or "[ who is this? ]"
tagProfileLabel.TextColor3 = isOwner and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(150, 150, 150)
tagProfileLabel.Font = Enum.Font.GothamBold
tagProfileLabel.TextSize = 11
tagProfileLabel.TextXAlignment = Enum.TextXAlignment.Left
tagProfileLabel.Parent = sidebar

-- Правая панель (Контент)
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(0, 360, 1, -20)
contentFrame.Position = UDim2.new(0, 170, 0, 10)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 550)
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

-- Переменные
local speedEnabled = false
local speedVal = 48
local jumpEnabled = false
local jumpVal = 150
local flyEnabled = false
local flySpeedVal = 60
local infJumpEnabled = false

local function createToggle(name, posY, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 30)
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
    toggleBtn.Position = UDim2.new(0.85, 0, 0, posY + 5)
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

local function createSlider(name, defaultVal, minVal, maxVal, posY, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, posY)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. tostring(defaultVal)
    label.TextColor3 = Color3.fromRGB(170, 170, 180)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = contentFrame

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(1, 0, 0, 6)
    sliderBg.Position = UDim2.new(0, 0, 0, posY + 22)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    sliderBg.Text = ""
    sliderBg.AutoButtonColor = false
    sliderBg.Parent = contentFrame

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = sliderBg

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(1, 0)
    fCorner.Parent = sliderFill

    local dragging = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = input.Position.X
            local absPos = sliderBg.AbsolutePosition.X
            local absSize = sliderBg.AbsoluteSize.X
            local percent = math.clamp((pos - absPos) / absSize, 0, 1)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            
            local val = math.floor(minVal + (maxVal - minVal) * percent)
            label.Text = name .. ": " .. tostring(val)
            callback(val)
        end
    end)
end

createToggle("Speed Boost", 35, function(state) speedEnabled = state end)
createSlider("Speed Value", 48, 16, 200, 70, function(v) speedVal = v end)

createToggle("Super Jump", 140, function(state) jumpEnabled = state end)
createSlider("Jump Value", 150, 50, 350, 175, function(v) jumpVal = v end)

createToggle("Fly", 245, function(state) flyEnabled = state end)
createSlider("Fly Speed", 60, 10, 150, 280, function(v) flySpeedVal = v end)

createToggle("Infinite Jump", 350, function(state) infJumpEnabled = state end)

-- Создание визуального тега над персонажами
local function setupTag(char, player)
    if char:FindFirstChild("Head") and not char.Head:FindFirstChild("TagGui") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "TagGui"
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = char.Head

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        
        local isThisOwner = (string.lower(player.Name) == "sodaklav" or string.lower(player.DisplayName) == "sodaklav")
        textLabel.Text = isThisOwner and "[ BOSS ]" or "[ who is this? ]"
        textLabel.TextColor3 = isThisOwner and Color3.fromRGB(255, 30, 30) or Color3.fromRGB(200, 200, 200)
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 14
        textLabel.Parent = billboard
    end
end

for _, p in pairs(Players:GetPlayers()) do
    if p.Character then setupTag(p.Character, p) end
    p.CharacterAdded:Connect(function(c) setupTag(c, p) end)
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c) setupTag(c, p) end)
end)

-- Логика движения и полета
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local rootPart = char.HumanoidRootPart
        
        if speedEnabled then hum.WalkSpeed = speedVal end
        if jumpEnabled then hum.JumpPower = jumpVal end

        local bg = rootPart:FindFirstChild("TikTokFlyBodyGyro")
        local bv = rootPart:FindFirstChild("TikTokFlyBodyVelocity")

        if flyEnabled then
            hum.PlatformStand = true
            if not bg then
                bg = Instance.new("BodyGyro")
                bg.Name = "TikTokFlyBodyGyro"
                bg.MaxTorque = Vector3.new(90000, 90000, 90000)
                bg.Parent = rootPart
            end
            if not bv then
                bv = Instance.new("BodyVelocity")
                bv.Name = "TikTokFlyBodyVelocity"
                bv.MaxForce = Vector3.new(90000, 90000, 90000)
                bv.Parent = rootPart
            end
            
            bg.CFrame = workspace.CurrentCamera.CFrame
            local camera = workspace.CurrentCamera
            local moveDir = Vector3.new(0,0,0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then
                moveDir = moveDir + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then
                moveDir = moveDir - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then
                moveDir = moveDir + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then
                moveDir = moveDir - camera.CFrame.RightVector
            end
            
            bv.Velocity = moveDir * flySpeedVal
        else
            hum.PlatformStand = false
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
