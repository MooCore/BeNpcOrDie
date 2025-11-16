-- AutoFarm Module
local AutoFarm = {}

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local autoFarmEnabled = false
local autoFarmThread = nil

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

local function extractCollectablePosition(instance)
    if instance:IsA("BasePart") then
        return instance.Position
    elseif instance:IsA("Model") then
        local primary = instance.PrimaryPart
        if primary then
            return primary.Position
        end
        local part = instance:FindFirstChildWhichIsA("BasePart")
        if part then
            return part.Position
        end
    elseif instance:IsA("Attachment") then
        local parent = instance.Parent
        if parent and parent:IsA("BasePart") then
            return parent.Position
        end
    end
    return nil
end

local function collectableWaypoints(referencePosition)
    local folder = Workspace:FindFirstChild("CollectableItems")
    if not folder then
        return {}
    end

    local rootPosition = referencePosition or Vector3.zero

    local waypoints = {}
    for _, item in ipairs(folder:GetChildren()) do
        local position = extractCollectablePosition(item)
        if position then
            table.insert(waypoints, position)
        end
    end

    table.sort(waypoints, function(a, b)
        return (a - rootPosition).Magnitude < (b - rootPosition).Magnitude
    end)

    return waypoints
end

local function executeAutoFarm()
    local function ensureCharacter()
        local character = LocalPlayer.Character
        if character and character.Parent then
            return character
        end
        character = LocalPlayer.CharacterAdded:Wait()
        return character
    end

    local character = ensureCharacter()
    local root = getCharacterRoot(character)
    local humanoid = getCharacterHumanoid(character)
    if not root or not humanoid then
        return
    end

    local waypoints = collectableWaypoints(root.Position)
    if #waypoints == 0 then
        return
    end

    humanoid.Sit = false
    humanoid.PlatformStand = false

    for _, position in ipairs(waypoints) do
        if not autoFarmEnabled then
            break
        end
        local elevated = position + Vector3.new(0, 4.25, 0)
        root.CFrame = CFrame.new(elevated)
        resetVelocity(root)
        task.wait(1.8)
    end
end

local function startAutoFarm()
    if autoFarmThread then
        task.cancel(autoFarmThread)
    end

    autoFarmThread = task.spawn(function()
        while autoFarmEnabled do
            executeAutoFarm()
            if not autoFarmEnabled then
                break
            end
            task.wait(1.5)
        end
    end)
end

function AutoFarm.setAutoFarm(state)
    autoFarmEnabled = state
    if state then
        startAutoFarm()
    else
        if autoFarmThread then
            task.cancel(autoFarmThread)
            autoFarmThread = nil
        end
    end
end

return AutoFarm
