-- Crosshair Module
local Crosshair = {}

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera
end)

local crosshairEnabled = false
local crosshairFrame = nil
local crosshairOffset = Vector2.new(0, 0)
local currentTarget = nil
local lastL2Press = 0
local r2PressCount = 0
local lastR2Press = 0

function Crosshair.createCrosshair()
    if crosshairFrame then
        crosshairFrame:Destroy()
    end
    
    crosshairFrame = Instance.new("Frame")
    crosshairFrame.Name = "Crosshair"
    crosshairFrame.Size = UDim2.new(0, 20, 0, 20)
    crosshairFrame.Position = UDim2.new(0.5, -10, 0.5, -10)
    crosshairFrame.BackgroundTransparency = 1
    crosshairFrame.ZIndex = 100
    
    local horizontal = Instance.new("Frame")
    horizontal.Size = UDim2.new(1, 0, 0, 2)
    horizontal.Position = UDim2.new(0, 0, 0.5, -1)
    horizontal.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    horizontal.BorderSizePixel = 0
    
    local vertical = Instance.new("Frame")
    vertical.Size = UDim2.new(0, 2, 1, 0)
    vertical.Position = UDim2.new(0.5, -1, 0, 0)
    vertical.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    vertical.BorderSizePixel = 0
    
    horizontal.Parent = crosshairFrame
    vertical.Parent = crosshairFrame
    
    return crosshairFrame
end

function Crosshair.setCrosshair(state)
    crosshairEnabled = state
    if crosshairFrame then
        crosshairFrame.Visible = state
        if state then
            crosshairFrame.Position = UDim2.new(0.5, -10 + crosshairOffset.X, 0.5, -10 + crosshairOffset.Y)
        end
    end
end

function Crosshair.getCrosshairOffset()
    return crosshairOffset
end

function Crosshair.setCurrentTarget(target)
    currentTarget = target
end

function Crosshair.getCurrentTarget()
    return currentTarget
end

function Crosshair.setupControllerInputs()
    local controllerConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.ButtonL2 then
            local now = tick()
            if now - lastL2Press < 0.5 then
                if currentTarget then
                    currentTarget = nil
                else
                    return true
                end
            end
            lastL2Press = now
        elseif input.KeyCode == Enum.KeyCode.ButtonR2 then
            local now = tick()
            if now - lastR2Press < 1.0 then
                r2PressCount = r2PressCount + 1
            else
                r2PressCount = 1
            end
            lastR2Press = now
            
            if r2PressCount >= 4 then
                local viewportSize = Camera.ViewportSize
                crosshairOffset = Vector2.new(
                    math.random(-viewportSize.X/4, viewportSize.X/4),
                    math.random(-viewportSize.Y/4, viewportSize.Y/4)
                )
                
                if crosshairFrame then
                    crosshairFrame.Position = UDim2.new(0.5, -10 + crosshairOffset.X, 0.5, -10 + crosshairOffset.Y)
                end
                r2PressCount = 0
            end
        end
    end)
    
    return controllerConnection
end

return Crosshair
