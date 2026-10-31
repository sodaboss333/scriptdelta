--!strict
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

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
mainFrame.Size = UDim2.new(0, 580, 0, 400)
mainFrame.Position = UDim2.new(0.5, -290, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
mainFrame.BackgroundTransparency = 0.2 -- Легкая прозрачность, чтобы фон был виден
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 170, 255)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Фоновая картинка (Патрик и Губка Боб в подгузниках)
local bgImage = Instance.new("ImageLabel")
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundTransparency = 1
-- Используем надежный ID текстуры-загрузки (или аналог картинки из декалей роблокса)
bgImage.Image = "rbxassetid://16766326162" -- Текстура или можно заменить на прямую деколь
bgImage.ImageTransparency = 0.55 -- Делаем полупрозрачной, чтобы не мешать тексту
bgImage.ZIndex = 0
bgImage.Parent = mainFrame

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 12)
bgCorner.Parent = bgImage

-- Кнопка сворачивания
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 8)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.Code
minimizeBtn.TextSize = 16
minimizeBtn.ZIndex = 10
minimizeBtn.Parent = mainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn

-- Плавающая кнопка открытия
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 50, 0, 50)
openButton.Position = UDim2.new(0, 20, 0.5, -25)
openButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
openButton.Text = "4SV"
openButton.TextColor3 = Color3.fromRGB(0, 170, 255)
openButton.Font = Enum.Font.Code
openButton.TextSize = 14
openButton.Visible = false
openButton.Active = true
openButton.Draggable = true
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = openButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(0, 170, 255)
openStroke.Thickness = 2
openStroke.Parent = openButton

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openButton.Visible = true
end)

openButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openButton.Visible = false
end)

-- Левая панель
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 170, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
sidebar.BackgroundTransparency = 0.3
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 2
sidebar.Parent = mainFrame

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 12)
sideCorner.Parent = sidebar

local logoTitle = Instance.new("TextLabel")
logoTitle.Size = UDim2.new(1, 0, 0, 25)
logoTitle.Position = UDim2.new(0, 0, 0, 10)
logoTitle.BackgroundTransparency = 1
logoTitle.ZIndex = 3
logoTitle.Text = "by: @4sv_soda"
logoTitle.TextColor3 = Color3.fromRGB(0, 170, 255)
logoTitle.Font = Enum.Font.Code
logoTitle.TextSize = 13
logoTitle.Parent = sidebar

-- Аватарка и ник
local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(0, 36, 0, 36)
avatarImg.Position = UDim2.new(0, 10, 0, 42)
avatarImg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
avatarImg.ZIndex = 3
pcall(function()
    avatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)
avatarImg.Parent = sidebar

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarImg

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(0, 110, 0, 18)
nameLabel.Position = UDim2.new(0, 52, 0, 42)
nameLabel.BackgroundTransparency = 1
nameLabel.ZIndex = 3
nameLabel.Text = LocalPlayer.Name
nameLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
nameLabel.Font = Enum.Font.Code
nameLabel.TextSize = 11
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = sidebar

local tagProfileLabel = Instance.new("TextLabel")
tagProfileLabel.Size = UDim2.new(0, 110, 0, 15)
tagProfileLabel.Position = UDim2.new(0, 52, 0, 60)
tagProfileLabel.BackgroundTransparency = 1
tagProfileLabel.ZIndex = 3

local isOwner = (string.lower(LocalPlayer.Name) == "sodaklav" or string.lower(LocalPlayer.DisplayName) == "sodaklav")
tagProfileLabel.Text = isOwner and "[ BOSS ]" or "[ who is this? ]"
tagProfileLabel.TextColor3 = isOwner and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(150, 150, 150)
tagProfileLabel.Font = Enum.Font.Code
tagProfileLabel.TextSize = 11
tagProfileLabel.TextXAlignment = Enum.TextXAlignment.Left
tagProfileLabel.Parent = sidebar

-- Вкладки
local tabsContainer = Instance.new("Folder")
tabsContainer.Name = "TabsContainer"
tabsContainer.Parent = mainFrame

local function createContentPanel()
    local cf = Instance.new("ScrollingFrame")
    cf.Size = UDim2.new(0, 385, 1, -20)
    cf.Position = UDim2.new(0, 180, 0, 10)
    cf.BackgroundTransparency = 1
    cf.BorderSizePixel = 0
    cf.CanvasSize = UDim2.new(0, 0, 0, 500)
    cf.ScrollBarThickness = 4
    cf.Visible = false
    cf.ZIndex = 2
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
    btn.Size = UDim2.new(0.9, 0, 0, 34)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.BackgroundTransparency = 0.2
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 210)
    btn.Font = Enum.Font.Code
    btn.TextSize = 12
    btn.ZIndex = 3
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

createTabButton("BOOST", 90, panelBoost)
createTabButton("AUTOWIN", 135, panelAutoWin)
createTabButton("VISUALS", 180, panelVisuals)
createTabButton("TROLL", 225, panelTroll)

local function addTitle(panel, text)
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 0, 30)
    t.BackgroundTransparency = 1
    t.ZIndex = 3
    t.Text = text
    t.TextColor3 = Color3.fromRGB(0, 170, 255)
    t.Font = Enum.Font.Code
    t.TextSize = 13
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = panel
end

local function createToggle(panel, name, posY, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 30)
    label.Position = UDim2.new(0, 0, 0, posY)
    label.BackgroundTransparency = 1
    label.ZIndex = 3
    label.Text = name
    label.TextColor3 = Color3.fromRGB(190, 190, 200)
    label.Font = Enum.Font.Code
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = panel

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 20)
    toggleBtn.Position = UDim2.new(0.85, 0, 0, posY + 5)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    toggleBtn.BackgroundTransparency = 0.2
    toggleBtn.Text = ""
    toggleBtn.ZIndex = 3
    toggleBtn.Parent = panel

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0, 2, 0, 2)
    circle.BackgroundColor3 = Color3.fromRGB(150, 150, 160)
    circle.ZIndex = 3
    circle.Parent = toggleBtn

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = circle

    local active = false
    toggleBtn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            circle.Position = UDim2.new(0, 22, 0, 2)
            circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            circle.Position = UDim2.new(0, 2, 0, 2)
            circle.BackgroundColor3 = Color3.fromRGB(150, 150, 160)
        end
        callback(active)
    end)
end

local function createSlider(panel, name, defaultVal, minVal, maxVal, posY, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, posY)
    label.BackgroundTransparency = 1
    label.ZIndex = 3
    label.Text = name .. ": " .. tostring(defaultVal)
    label.TextColor3 = Color3.fromRGB(170, 170, 180)
    label.Font = Enum.Font.Code
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = panel

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(1, 0, 0, 6)
    sliderBg.Position = UDim2.new(0, 0, 0, posY + 22)
    sliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    sliderBg.BackgroundTransparency = 0.2
    sliderBg.Text = ""
    sliderBg.ZIndex = 3
    sliderBg.AutoButtonColor = false
    sliderBg.Parent = panel

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = sliderBg

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 3
    sliderFill.Parent = sliderBg

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(1, 0)
    fCorner.Parent = sliderFill

    local dragging = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local percent = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            local val = math.floor(minVal + (maxVal - minVal) * percent)
            label.Text = name .. ": " .. tostring(val)
            callback(val)
        end
    end)
end

-- Вкладка Boost
addTitle(panelBoost, "MOVEMENT ADJUSTMENTS")
local speedEnabled, speedVal = false, 48
local jumpEnabled, jumpVal = false, 150
local flyEnabled, flySpeedVal = false, 60
local infJumpEnabled = false

createToggle(panelBoost, "SPEED BOOST", 35, function(s) speedEnabled = s end)
createSlider(panelBoost, "SPEED VALUE", 48, 16, 200, 70, function(v) speedVal = v end)
createToggle(panelBoost, "SUPER JUMP", 135, function(s) jumpEnabled = s end)
createSlider(panelBoost, "JUMP VALUE", 150, 50, 350, 170, function(v) jumpVal = v end)
createToggle(panelBoost, "FLY", 240, function(s) flyEnabled = s end)
createSlider(panelBoost, "FLY SPEED", 60, 10, 150, 275, function(v) flySpeedVal = v end)
createToggle(panelBoost, "INFINITE JUMP", 345, function(s) infJumpEnabled = s end)

-- Вкладка AutoWin
addTitle(panelAutoWin, "TOWER OF HELL AUTOWIN")
local autoWinEnabled = false
createToggle(panelAutoWin, "AUTO GO TO WHITE DOOR", 40, function(s) autoWinEnabled = s end)

-- Вкладка Visuals
addTitle(panelVisuals, "VISUAL CUSTOMIZATIONS")
createToggle(panelVisuals, "BLUE SMOKE EFFECT", 40, function(s) 
    local char = LocalPlayer.Character
    if char then
        local targetPart = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if targetPart then
            local smoke = targetPart:FindFirstChild("BlueSmokeEffect")
            if s and not smoke then
                local sm = Instance.new("Smoke", targetPart)
                sm.Name = "BlueSmokeEffect"
                sm.Color = Color3.fromRGB(0, 150, 255)
                sm.Size = 5
                sm.RiseVelocity = 10
            elseif not s and smoke then
                smoke:Destroy()
            end
        end
    end
end)

createToggle(panelVisuals, "TOH HALO EFFECT", 100, function(s) 
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Head") then
        local halo = char.Head:FindFirstChild("TOHHalo")
        if s and not halo then
            local h = Instance.new("Part", char.Head)
            h.Name = "TOHHalo"
            h.Size = Vector3.new(1.3, 0.25, 1.3)
            h.Shape = Enum.PartType.Cylinder
            h.Color = Color3.fromRGB(255, 230, 0)
            h.Material = Enum.Material.Neon
            local w = Instance.new("WeldConstraint", h)
            w.Part0 = char.Head
            w.Part1 = h
            h.CFrame = char.Head.CFrame + Vector3.new(0, 1.3, 0)
        elseif not s and halo then
            halo:Destroy()
        end
    end
end)

createToggle(panelVisuals, "CHARACTER TRAILS", 160, function(s) 
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local tr = char.HumanoidRootPart:FindFirstChild("CustomTrail")
        if s and not tr then
            local att0 = Instance.new("Attachment", char.HumanoidRootPart)
            local att1 = Instance.new("Attachment", char.HumanoidRootPart)
            att1.Position = Vector3.new(0, -3, 0)
            local t = Instance.new("Trail", char.HumanoidRootPart)
            t.Name = "CustomTrail"
            t.Attachment0 = att0
            t.Attachment1 = att1
            t.Color = ColorSequence.new(Color3.fromRGB(0, 170, 255))
            t.Lifetime = 0.5
        elseif not s and tr then
            tr:Destroy()
        end
    end
end)

-- Вкладка Troll
addTitle(panelTroll, "TROLL & FUN ACTIONS")
local touchFlingEnabled = false
createToggle(panelTroll, "TOUCH FLING", 40, function(s) touchFlingEnabled = s end)

-- Теги игроков над головой
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
        textLabel.Font = Enum.Font.Code
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

-- Основной цикл
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local rootPart = char.HumanoidRootPart
        
        if speedEnabled then hum.WalkSpeed = speedVal end
        if jumpEnabled then hum.JumpPower = jumpVal end

        -- Автоматический поиск белой двери / финиша на высоте
        if autoWinEnabled then
            local targetPart = nil
            local highestY = -math.huge
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local name = obj.Name:lower()
                    if name:find("finish") or name:find("door") or name:find("win") or (obj.Color == Color3.fromRGB(255, 255, 255) and obj.Position.Y > 50) then
                        if obj.Position.Y > highestY then
                            highestY = obj.Position.Y
                            targetPart = obj
                        end
                    end
                end
            end
            if targetPart then
                rootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
            end
        end

        -- Touch Fling
        if touchFlingEnabled then
            local bv = rootPart:FindFirstChild("FlingVelocity")
            if not bv then
                bv = Instance.new("BodyAngularVelocity", rootPart)
                bv.Name = "FlingVelocity"
                
)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local percent = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            local val = math.floor(minVal + (maxVal - minVal) * percent)
            label.Text = name .. ": " .. tostring(val)
            callback(val)
        end
    end)
end

-- Вкладка Boost
addTitle(panelBoost, "Movement Adjustments")
local speedEnabled, speedVal = false, 48
local jumpEnabled, jumpVal = false, 150
local flyEnabled, flySpeedVal = false, 60
local infJumpEnabled = false

createToggle(panelBoost, "Speed Boost", 35, function(s) speedEnabled = s end)
createSlider(panelBoost, "Speed Value", 48, 16, 200, 70, function(v) speedVal = v end)
createToggle(panelBoost, "Super Jump", 135, function(s) jumpEnabled = s end)
createSlider(panelBoost, "JumpValue", 150, 50, 350, 170, function(v) jumpVal = v end)
createToggle(panelBoost, "Fly", 240, function(s) flyEnabled = s end)
createSlider(panelBoost, "Fly Speed", 60, 10, 150, 275, function(v) flySpeedVal = v end)
createToggle(panelBoost, "Infinite Jump", 345, function(s) infJumpEnabled = s end)

-- Вкладка AutoWin
addTitle(panelAutoWin, "Tower of Hell AutoWin")
local autoWinEnabled = false
createToggle(panelAutoWin, "Auto Go To White Door", 40, function(s) autoWinEnabled = s end)

-- Вкладка Visuals
addTitle(panelVisuals, "Visual Customizations")
createToggle(panelVisuals, "Blue Smoke Effect", 40, function(s) 
    local char = LocalPlayer.Character
    if char then
        local targetPart = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if targetPart then
            local smoke = targetPart:FindFirstChild("BlueSmokeEffect")
            if s and not smoke then
                local sm = Instance.new("Smoke", targetPart)
                sm.Name = "BlueSmokeEffect"
                sm.Color = Color3.fromRGB(0, 150, 255)
                sm.Size = 5
                sm.RiseVelocity = 10
            elseif not s and smoke then
                smoke:Destroy()
            end
        end
    end
end)

createToggle(panelVisuals, "TOH Halo Effect", 100, function(s) 
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Head") then
        local halo = char.Head:FindFirstChild("TOHHalo")
        if s and not halo then
            local h = Instance.new("Part", char.Head)
            h.Name = "TOHHalo"
            h.Size = Vector3.new(1.3, 0.25, 1.3)
            h.Shape = Enum.PartType.Cylinder
            h.Color = Color3.fromRGB(255, 230, 0)
            h.Material = Enum.Material.Neon
            local w = Instance.new("WeldConstraint", h)
            w.Part0 = char.Head
            w.Part1 = h
            h.CFrame = char.Head.CFrame + Vector3.new(0, 1.3, 0)
        elseif not s and halo then
            halo:Destroy()
        end
    end
end)

createToggle(panelVisuals, "Character Trails", 160, function(s) 
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local tr = char.HumanoidRootPart:FindFirstChild("CustomTrail")
        if s and not tr then
            local att0 = Instance.new("Attachment", char.HumanoidRootPart)
            local att1 = Instance.new("Attachment", char.HumanoidRootPart)
            att1.Position = Vector3.new(0, -3, 0)
            local t = Instance.new("Trail", char.HumanoidRootPart)
            t.Name = "CustomTrail"
            t.Attachment0 = att0
            t.Attachment1 = att1
            t.Color = ColorSequence.new(Color3.fromRGB(0, 170, 255))
            t.Lifetime = 0.5
        elseif not s and tr then
            tr:Destroy()
        end
    end
end)

-- Вкладка Troll
addTitle(panelTroll, "Troll & Fun Actions")
local touchFlingEnabled = false
createToggle(panelTroll, "Touch Fling (Spread Players)", 40, function(s) touchFlingEnabled = s end)

-- Теги игроков над головой
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

-- Основной цикл
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local rootPart = char.HumanoidRootPart
        
        if speedEnabled then hum.WalkSpeed = speedVal end
        if jumpEnabled then hum.JumpPower = jumpVal end

        -- Автоматический поиск белой двери / финиша на высоте
        if autoWinEnabled then
            local targetPart = nil
            local highestY = -math.huge
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local name = obj.Name:lower()
                    if name:find("finish") or name:find("door") or name:find("win") or (obj.Color == Color3.fromRGB(255, 255, 255) and obj.Position.Y > 50) then
                        if obj.Position.Y > highestY then
                            highestY = obj.Position.Y
                            targetPart = obj
                        end
                    end
                end
            end
            if targetPart then
                rootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
            end
        end

        -- Исправленный Touch Fling
        if touchFlingEnabled then
            local bv = rootPart:FindFirstChild("FlingVelocity")
            if not bv then
                bv = Instance.new("BodyAngularVelocity", rootPart)
                bv.Name = "FlingVelocity"
                bv.MaxTorque = Vector3.new(0, math.huge, 0)
                bv.AngularVelocity = Vector3.new(0, 99999, 0)
            end
        else
            local bv = rootPart:FindFirstChild("FlingVelocity")
            if bv then bv:Destroy() end
        end

        -- Полет
        local bg = rootPart:FindFirstChild("TikTokFlyBodyGyro")
        local bvFly = rootPart:FindFirstChild("TikTokFlyBodyVelocity")

        if flyEnabled then
            hum.PlatformStand = true
            if not bg then
                bg = Instance.new("BodyGyro", rootPart)
                bg.Name = "TikTokFlyBodyGyro"
                bg.MaxTorque = Vector3.new(90000, 90000, 90000)
            end
            if not bvFly then
                bvFly = Instance.new("BodyVelocity", rootPart)
                bvFly.Name = "TikTokFlyBodyVelocity"
                bvFly.MaxForce = Vector3.new(90000, 90000, 90000)
            end
            
            bg.CFrame = workspace.CurrentCamera.CFrame
            local camera = workspace.CurrentCamera
            local moveDir = Vector3.new(0,0,0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then moveDir = moveDir + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then moveDir = moveDir - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then moveDir = moveDir + camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then moveDir = moveDir - camera.CFrame.RightVector end
            
            bvFly.Velocity = moveDir * flySpeedVal
        else
            hum.PlatformStand = false
            if bg then bg:Destroy() end
            if bvFly then bvFly:Destroy() end
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
