-- Player Module
local Player = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local noClipEnabled = false
local noClipConnection = nil
local godModeEnabled = false
local originalHealth = nil

function Player.setNoClip(state)
    noClipEnabled = state
    if state then
        if noClipConnection then
            noClipConnection:Disconnect()
        end
        noClipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    elseif noClipConnection then
        noClipConnection:Disconnect()
        noClipConnection = nil
    end
end

function Player.resetCharacter()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end

function Player.toggleGodMode()
    godModeEnabled = not godModeEnabled
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if godModeEnabled then
                originalHealth = humanoid.MaxHealth
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
            else
                humanoid.MaxHealth = originalHealth or 100
                humanoid.Health = originalHealth or 100
            end
        end
    end
end

return Player
