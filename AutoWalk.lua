local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

if CoreGui:FindFirstChild("AutoWalkGui") then
    CoreGui.AutoWalkGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoWalkGui"
screenGui.Parent = CoreGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 160, 0, 50)
button.Position = UDim2.new(0.1, 0, 0.1, 0)
button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
button.Text = "Macro by Kuchigara"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 16
button.Font = Enum.Font.SourceSansBold
button.BorderSizePixel = 0
button.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = button

local dragging, dragInput, dragStart, startPos
button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = button.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local isWalking = false
local walkConnection = nil

local function startWalking()
    walkConnection = RunService.RenderStepped:Connect(function()
        if player and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart then
                player:Move(Vector3.new(0, 0, -1), true)
            end
        end
    end)
end

local function stopWalking()
    if walkConnection then
        walkConnection:Disconnect()
        walkConnection = nil
    end
end

button.MouseButton1Click:Connect(function()
    isWalking = not isWalking
    if isWalking then
        button.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
        startWalking()
    else
        button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        stopWalking()
    end
end)
