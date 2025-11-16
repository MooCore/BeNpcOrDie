-- AutoObby Module
local AutoObby = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local function getCharacterRoot(character)
    if not character then
        return nil
    end
    return character:FindFirstChild("HumanoidRootPart")
end

local function getCharacterHumanoid(character)
    if not character then
        return nil
    end
    return character:FindFirstChildOfClass("Humanoid")
end

local function resetVelocity(part)
    pcall(function()
        part.AssemblyLinearVelocity = Vector3.zero
        part.AssemblyAngularVelocity = Vector3.zero
    end)
end

local function tweenRoot(root, targetCFrame, duration)
    resetVelocity(root)
    local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        CFrame = targetCFrame
    })
    tween:Play()
    local success = pcall(function()
        tween.Completed:Wait()
    end)
    if not success then
        tween:Cancel()
    end
end

function AutoObby.autoCompleteObby()
    local function ensureCharacter()
        local character = LocalPlayer.Character
        if character and character.Parent then
            return character
        end
        character = LocalPlayer.CharacterAdded:Wait()
        return character
    end

    local character = ensureCharacter()
    if not character then
        return
    end

    local root = getCharacterRoot(character)
    local humanoid = getCharacterHumanoid(character)
    if not root or not humanoid then
        return
    end

    humanoid.Sit = false
    humanoid.PlatformStand = false

    local firstAnchor = CFrame.new(111, 4, 532)
    local finalAnchor = CFrame.new(174, 9, 473)
    
    root.CFrame = firstAnchor
    resetVelocity(root)
    task.wait(0.15)
    
    tweenRoot(root, finalAnchor, 3.75)
end

return AutoObby
