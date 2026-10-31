--!strict
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Удаляем старое меню, если оно уже было открыто
if PlayerGui:FindFirstChild("ChessAssistantGui") then
    PlayerGui.ChessAssistantGui:Destroy()
end

-- Создаем главный GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChessAssistantGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Главное окно (передвигаемое)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 320)
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

-- Шапка окна (за нее можно перетаскивать пальцем в Delta)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "♟️ Chess Assistant (Delta)"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
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

-- Поле вывода лучшего хода
local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(0.9, 0, 0, 60)
resultLabel.Position = UDim2.new(0.05, 0, 0.18, 0)
resultLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
resultLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
resultLabel.TextSize = 15
resultLabel.Font = Enum.Font.GothamBold
resultLabel.Text = "Лучший ход: ожидание..."
resultLabel.TextWrapped = true
resultLabel.Parent = mainFrame

local resCorner = Instance.new("UICorner")
resCorner.CornerRadius = UDim.new(0, 8)
resCorner.Parent = resultLabel

-- Поле ввода FEN позиции
local fenInput = Instance.new("TextBox")
fenInput.Size = UDim2.new(0.9, 0, 0, 45)
fenInput.Position = UDim2.new(0.05, 0, 0.42, 0)
fenInput.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
fenInput.TextColor3 = Color3.fromRGB(255, 255, 255)
fenInput.PlaceholderText = "Введите FEN позиции..."
fenInput.Text = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
fenInput.TextSize = 10
fenInput.Font = Enum.Font.Gotham
fenInput.ClearTextOnFocus = false
fenInput.Parent = mainFrame

local fenCorner = Instance.new("UICorner")
fenCorner.CornerRadius = UDim.new(0, 8)
fenCorner.Parent = fenInput

-- Кнопка запроса анализа
local analyzeBtn = Instance.new("TextButton")
analyzeBtn.Size = UDim2.new(0.9, 0, 0, 45)
analyzeBtn.Position = UDim2.new(0.05, 0, 0.62, 0)
analyzeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
analyzeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
analyzeBtn.Text = "🔍 Найти лучший ход"
analyzeBtn.TextSize = 14
analyzeBtn.Font = Enum.Font.GothamBold
analyzeBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = analyzeBtn

-- Кнопка сброса
local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0.9, 0, 0, 35)
resetBtn.Position = UDim2.new(0.05, 0, 0.81, 0)
resetBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.Text = "Сбросить доску"
resetBtn.TextSize = 12
resetBtn.Font = Enum.Font.GothamBold
resetBtn.Parent = mainFrame

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 6)
resetCorner.Parent = resetBtn

-- Логика нажатия с защитой от ошибок
analyzeBtn.MouseButton1Click:Connect(function()
    local fen = fenInput.Text
    if fen == "" then
        resultLabel.Text = "⚠️ Введите FEN!"
        return
    end
    
    resultLabel.Text = "⏳ Запрос к серверу..."
    
    task.spawn(function()
        local success, err = pcall(function()
            local encodedFen = fen:gsub(" ", "%%20")
            local url = "https://lichess.org/api/cloud-eval?fen=" .. encodedFen
            local res = game:HttpGet(url)
            local data = HttpService:JSONDecode(res)
            
            if data and data.pvs and #data.pvs > 0 then
                local pv = data.pvs[1].moves
                local firstMove = pv:match("^(%S+)")
                resultLabel.Text = "👉 Ход: " .. string.upper(firstMove or pv)
            else
                resultLabel.Text = "⚠️ Позиция не найдена в базе"
            end
        end)
        
        if not success then
            resultLabel.Text = "❌ Ошибка соединения"
        end
    end)
end)

resetBtn.MouseButton1Click:Connect(function()
    fenInput.Text = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    resultLabel.Text = "Лучший ход: сброшено"
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/sodaboss333/scriptdelta/refs/heads/main/scriptdeltasoda.lua"))()
