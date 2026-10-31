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
mainFrame.Size = UDim2.new(0, 560, 0, 380)
mainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
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
avatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
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

panelBoost.Visible = true -- По умолчанию открыт Boost

-- Переключение вкладок слева
local function createTabButton(name, posY, targetPanel)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 210)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize, btn.Parent = 12, sidebar
    
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

-- Функции построения интерфейса элементов внутри панелей
local function addTitle(panel, text)
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 0, 30)
    t.BackgroundTransparency = 1
    t.Text = text
    t.TextColor3 = Color3.fromRGB(220, 220, 230)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 13
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = panel
end

local function createToggle(panel, name, posY, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 30)
    label.Position = UDim2.new(0, 0, 0, posY)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(190, 190, 200)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = panel

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 20)
    toggleBtn.Position = UDim2.new(0.85, 0, 0, posY + 5)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    toggleBtn.Text = ""
    toggleBtn.Parent = panel

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

local function createSlider(panel, name, defaultVal, minVal, maxVal, posY, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, posY)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. tostring(defaultVal)
    label.TextColor3 = Color3.fromRGB(170, 170, 180)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = panel

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(1, 0, 0, 6)
    sliderBg.Position = UDim2.new(0, 0, 0, posY + 22)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    sliderBg.Text = ""
    sliderBg.AutoButtonColor = false
    sliderBg.Parent = panel

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

-- --- НАПОЛНЕНИЕ ВКЛАДОК ---

-- 1. BOOST
addTitle(panelBoost, "Movement Adjustments")
local speedEnabled, speedVal = false, 48
local jumpEnabled, jumpVal = false, 150
local flyEnabled, flySpeedVal = false, 60
local infJumpEnabled = false

createToggle(panelBoost, "Speed Boost", 35, function(s) speedEnabled = s end)
createSlider(panelBoost, "Speed Value", 48, 16, 200, 70, function(v) speedVal = v end)
createToggle(panelBoost, "Super Jump", 135, function(s) jumpEnabled = s end)
createSlider(panelBoost, "Jump Value", 150, 50, 350, 170, function(v) jumpVal = v end)
createToggle(panelBoost, "Fly", 240, function(s) flyEnabled = s end)
createSlider(panelBoost, "Fly Speed", 60, 10, 150, 275, function(v) flySpeedVal = v end)
createToggle(panelBoost, "Infinite Jump", 345, function(s) infJumpEnabled = s end)

-- 2. AUTOWIN
addTitle(panelAutoWin, "Tower of Hell AutoWin")
local autoWinEnabled = false
createToggle(panelAutoWin, "Auto Go To White Door", 40, function(s) autoWinEnabled = s end)

-- 3. VISUALS
addTitle(panelVisuals, "Visual Customizations")
local smokeEnabled, haloEnabled, trailEnabled = false, false, false

createToggle(panelVisuals, "Blue Smoke Effect", 40, function(s) 
    smokeEnabled = s 
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Torso") then
        local smoke = char.Torso:FindFirstChild("BlueSmokeEffect")
        if smokeEnabled and not smoke then
            local sm = Instance.new("Smoke")
            sm.Name = "BlueSmokeEffect"
            sm.Color = Color3.fromRGB(0, 150, 255)
            sm.Parent = char.Torso
        elseif not smokeEnabled and smoke then
            smoke:Destroy()
        end
    end
end)

createToggle(panelVisuals, "TOH Halo Effect", 100, function(s) 
    haloEnabled = s
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Head") then
        local halo = char.Head:FindFirstChild("TOHHalo")
        if haloEnabled and not halo then
            local h = Instance.new("Part")
            h.Name = "TOHHalo"
            h.Size = Vector3.new(1.2, 0.2, 1.2)
            h.Shape = Enum.PartType.Cylinder
            h.BrickColor = BrickColor.new("Bright yellow")
            h.Anchored = false
            h.Parent = char.Head
            local w = Instance.new("WeldConstraint")
            w.Part0 = char.Head
            w.Part1 = h
            w.Parent = h
            h.CFrame = char.Head.CFrame + Vector3.new(0, 1.2, 0)
        elseif not haloEnabled and halo then
            halo:Destroy()
        end
    end
end)

createToggle(panelVisuals, "Character Trails", 160, function(s) 
    trailEnabled = s
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local tr = char.HumanoidRootPart:FindFirstChild("CustomTrail")
        if trailEnabled and not tr then
            local att0 = Instance.new("Attachment", char.HumanoidRootPart)
            local att1 = Instance.new("Attachment", char.HumanoidRootPart)
            att1.Position = Vector3.new(0, -2, 0)
            local t = Instance.new("Trail", char.HumanoidRootPart)
            t.Name = "CustomTrail"
            t.Attachment0 = att0
            t.Attachment1 = att1
            t.Color = ColorSequence.new(Color3.fromRGB(0, 170, 255))
        elseif not trailEnabled and tr then
            tr:Destroy()
        end
    end
end)

-- 4. TROLL
addTitle(panelTroll, "Troll & Fun Actions")
local touchFlingEnabled = false

createToggle(panelTroll, "Touch Fling (Spread Players)", 40, function(s) 
    touchFlingEnabled = s 
end)

createToggle(panelTroll, "Play Funny Animation", 100, function(s)
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://507771019" -- Пример танцевальной анимации
        local track = char.HumanoidOfClass or char.Humanoid:LoadAnimation(anim)
        if s then track:Play() else track:Stop() end
    end
end)

-- --- ОСНОВНАЯ ЛОГИКА И СКРИПТЫ ---

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

-- Главный цикл работы (RunService)
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local rootPart = char.HumanoidRootPart
        
        if speedEnabled then hum.WalkSpeed = speedVal end
        if jumpEnabled then hum.JumpPower = jumpVal end

        -- AutoWin логика (поиск белой двери / финиша наверх)
        if autoWinEnabled then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.BrickColor == BrickColor.new("White") or obj.Name:lower():find("win") or obj.Name:lower():find("door")) then
                    rootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                    break
                end
            end
        end

        -- Touch Fling (Раскидывание)
        if touchFlingEnabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = p.Character.HumanoidRootPart
                    if (rootPart.Position - targetRoot.Position).Magnitude < 5 then
                        targetRoot.Velocity = Vector3.new(math.random(-300, 300), 500, math.random(-300, 300))
                    end
                end
            end
        end

        -- Полет (Fly)
        local bg = rootPart:FindFirstChild("TikTokFlyBodyGyro")
        local bv = rootPart:FindFirstChild("TikTokFlyBodyVelocity")

        if flyEnabled then
            hum.PlatformStand = true
            if not bg then
                bg = Instance.new("BodyGyro", rootPart)
                bg.Name = "TikTokFlyBodyGyro"
                bg.MaxTorque = Vector3.new(90000, 90000, 90000)
            end
            if not bv then
                bv = Instance.new("BodyVelocity", rootPart)
                bv.Name = "TikTokFlyBodyVelocity"
                bv.MaxForce = Vector3.new(90000, 90000, 90000)
            end
            
            bg.CFrame = workspace.CurrentCamera.CFrame
            local camera = workspace.CurrentCamera
            local moveDir = Vector3.new(0,0,0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then moveDir = moveDir + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then moveDir = moveDir - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then moveDir = moveDir + camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then moveDir = moveDir - camera.CFrame.RightVector end
            
            bv.
c, p) end)
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
