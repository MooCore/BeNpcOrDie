-- Combat Module
local Combat = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
end)

local aimEnabled = false
local aimConnection = nil
local killAllCriminalsRunning = false
local killAllCriminalsCancelled = false

local criminalKeywords = {"criminal", "crim", "outlaw", "thief", "villain"}

local function isLobbyPlayer(player)
    local team = player.Team
    return team ~= nil and team.Name == "Lobby"
end

local function isValidOpponent(player)
    if player == LocalPlayer then
        return false
    end
    if isLobbyPlayer(player) then
        return false
    end
    return true
end

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

local characterCache = {}
local alignmentCache = {}

local function resolveCharacter(player)
    if player.Character and getCharacterRoot(player.Character) and getCharacterHumanoid(player.Character) then
        return player.Character
    end
    return nil
end

local function considerAlignmentValue(name, value)
    if typeof(value) ~= "string" then
        return nil
    end
    local lowerName = name:lower()
    if lowerName:find("team") or lowerName:find("role") or lowerName:find("class") or lowerName:find("status") or lowerName:find("alignment") or lowerName:find("faction") then
        return value
    end
    return nil
end

local function captureAlignment(player)
    local team = player.Team
    if team then
        return team.Name
    end

    for key, value in pairs(player:GetAttributes()) do
        local considered = considerAlignmentValue(key, value)
        if considered then
            return considered
        end
    end

    local folders = {"leaderstats", "Stats", "Data"}
    for _, folderName in ipairs(folders) do
        local container = player:FindFirstChild(folderName)
        if container then
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("StringValue") then
                    local considered = considerAlignmentValue(child.Name, child.Value)
                    if considered then
                        return considered
                    end
                elseif child:IsA("ValueBase") then
                    local value = child.Value
                    if typeof(value) == "string" then
                        local considered = considerAlignmentValue(child.Name, value)
                        if considered then
                            return considered
                        end
                    end
                end
            end
        end
    end

    return nil
end

local function getAlignmentCacheEntry(player)
    local entry = alignmentCache[player]
    if entry then
        return entry
    end
    entry = {
        value = nil,
        lastCheck = 0
    }
    alignmentCache[player] = entry
    return entry
end

local function fetchAlignment(player)
    local entry = getAlignmentCacheEntry(player)
    local now = os.clock()
    if now - entry.lastCheck > 1 then
        entry.value = captureAlignment(player)
        entry.lastCheck = now
    end
    return entry.value
end

local function alignmentMatchesCriminal(alignment)
    if not alignment then
        return false
    end
    local lower = alignment:lower()
    for _, keyword in ipairs(criminalKeywords) do
        if lower:find(keyword) then
            return true
        end
    end
    return false
end

local function isCriminal(player)
    if not isValidOpponent(player) then
        return false
    end

    local team = player.Team
    if team and alignmentMatchesCriminal(team.Name) then
        return true
    end

    local alignment = fetchAlignment(player)
    if alignmentMatchesCriminal(alignment) then
        return true
    end

    return false
end

local function getBestCriminalTarget(crosshairOffset)
    local camera = Camera
    if not camera then
        return nil
    end

    local crosshairPosition = Vector2.new(camera.ViewportSize.X / 2 + crosshairOffset.X, camera.ViewportSize.Y / 2 + crosshairOffset.Y)
    local closestDistance = math.huge
    local closestHead = nil

    for _, player in ipairs(Players:GetPlayers()) do
        if isCriminal(player) then
            local character = resolveCharacter(player)
            local humanoid = getCharacterHumanoid(character)
            local root = getCharacterRoot(character)
            if character and humanoid and humanoid.Health > 0 and root then
                local head = character:FindFirstChild("Head")
                local aimPart = root
                if head and head:IsA("BasePart") then
                    aimPart = head
                end
                local screenPosition, onScreen = camera:WorldToViewportPoint(aimPart.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - crosshairPosition).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestHead = aimPart
                    end
                end
            end
        end
    end

    return closestHead
end

local function updateAim(currentTarget, crosshairOffset)
    if currentTarget and currentTarget.Parent then
        local camera = Camera
        if not camera then
            return
        end
        local currentCFrame = camera.CFrame
        local desiredCFrame = CFrame.lookAt(currentCFrame.Position, currentTarget.Position)
        camera.CFrame = currentCFrame:Lerp(desiredCFrame, 0.18)
        return
    end

    local head = getBestCriminalTarget(crosshairOffset)
    if not head then
        return
    end

    local camera = Camera
    if not camera then
        return
    end

    local currentCFrame = camera.CFrame
    local desiredCFrame = CFrame.lookAt(currentCFrame.Position, head.Position)
    camera.CFrame = currentCFrame:Lerp(desiredCFrame, 0.18)
end

local function aimCameraAtPart(part)
    if not part then
        return
    end
    local camera = Camera
    if not camera then
        return
    end
    local currentCFrame = camera.CFrame
    local desiredCFrame = CFrame.lookAt(currentCFrame.Position, part.Position)
    camera.CFrame = currentCFrame:Lerp(desiredCFrame, 0.4)
end

local function triggerPrimaryFire()
    local camera = Camera
    if not camera then
        return
    end
    local viewportSize = camera.ViewportSize
    local x = viewportSize.X / 2
    local y = viewportSize.Y / 2
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.03)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

function Combat.setAim(state, crosshairModule)
    aimEnabled = state
    if state then
        if aimConnection then
            aimConnection:Disconnect()
        end
        if crosshairModule then
            crosshairModule.setCrosshair(true)
        end
        aimConnection = RunService.RenderStepped:Connect(function()
            local currentTarget = crosshairModule and crosshairModule.getCurrentTarget()
            local crosshairOffset = crosshairModule and crosshairModule.getCrosshairOffset() or Vector2.new(0, 0)
            updateAim(currentTarget, crosshairOffset)
        end)
    elseif aimConnection then
        aimConnection:Disconnect()
        aimConnection = nil
        if crosshairModule then
            crosshairModule.setCrosshair(false)
            crosshairModule.setCurrentTarget(nil)
        end
    end
end

local function gatherCriminalTargets(originPosition)
    local targets = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if isCriminal(player) then
            local character = resolveCharacter(player)
            local humanoid = getCharacterHumanoid(character)
            local root = getCharacterRoot(character)
            if character and humanoid and humanoid.Health > 0 and root then
                table.insert(targets, {
                    player = player,
                    position = root.Position
                })
            end
        end
    end

    if originPosition then
        table.sort(targets, function(a, b)
            return (a.position - originPosition).Magnitude < (b.position - originPosition).Magnitude
        end)
    end

    return targets
end

function Combat.killAllCriminals()
    if killAllCriminalsRunning then
        killAllCriminalsCancelled = true
        killAllCriminalsRunning = false
        return
    end

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
    if not character or not root or not humanoid then
        return
    end

    local targets = gatherCriminalTargets(root.Position)
    if #targets == 0 then
        return
    end

    killAllCriminalsCancelled = false
    killAllCriminalsRunning = true

    local eliminatedAny = false
    local originalCFrame = root.CFrame
    local cycles = 0

    local success, err = pcall(function()
        while killAllCriminalsRunning do
            cycles += 1
            if cycles > 15 then
                break
            end

            if #targets == 0 then
                targets = gatherCriminalTargets(root.Position)
                if #targets == 0 then
                    break
                end
            end

            for _, info in ipairs(targets) do
                if not killAllCriminalsRunning then
                    break
                end

                local targetPlayer = info.player
                local targetCharacter = resolveCharacter(targetPlayer)
                local targetHumanoid = getCharacterHumanoid(targetCharacter)
                local targetRoot = getCharacterRoot(targetCharacter)
                if targetCharacter and targetHumanoid and targetHumanoid.Health > 0 and targetRoot then
                    eliminatedAny = true

                    local offset = Vector3.new(0, 5.5, -7)
                    local attackCFrame = CFrame.new(targetRoot.Position + offset, targetRoot.Position)
                    root.CFrame = attackCFrame
                    resetVelocity(root)
                    humanoid.Sit = false
                    humanoid.PlatformStand = false
                    task.wait(0.1)

                    local focusPart = targetRoot
                    local head = targetCharacter:FindFirstChild("Head")
                    if head and head:IsA("BasePart") then
                        focusPart = head
                    end

                    for shot = 1, 6 do
                        if not killAllCriminalsRunning then
                            break
                        end
                        aimCameraAtPart(focusPart)
                        triggerPrimaryFire()
                        task.wait(0.12)

                        local refreshedCharacter = resolveCharacter(targetPlayer)
                        local refreshedHumanoid = getCharacterHumanoid(refreshedCharacter)
                        if not refreshedHumanoid or refreshedHumanoid.Health <= 0 then
                            break
                        end
                        local refreshedRoot = getCharacterRoot(refreshedCharacter)
                        if refreshedRoot then
                            local refreshedHead = refreshedCharacter:FindFirstChild("Head")
                            if refreshedHead and refreshedHead:IsA("BasePart") then
                                focusPart = refreshedHead
                            else
                                focusPart = refreshedRoot
                            end
                        end
                    end

                    task.wait(0.2)
                end
            end

            targets = gatherCriminalTargets(root.Position)
            task.wait(0.45)
        end
    end)

    killAllCriminalsRunning = false
    root.CFrame = originalCFrame
    resetVelocity(root)
    humanoid.Sit = false
    humanoid.PlatformStand = false

    if not success then
        warn(`[KillAllCriminals] {err}`)
        return
    end
end

function Combat.getBestCriminalTarget(crosshairOffset)
    return getBestCriminalTarget(crosshairOffset or Vector2.new(0, 0))
end

return Combat
