-- ESP Module
local ESP = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
end)

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

local function getPlayerTeam(player)
    if player.Team then
        return player.Team.Name
    end
    return nil
end

local function isSheriff(player)
    local teamName = getPlayerTeam(player)
    return teamName and (teamName:lower():find("sheriff") or teamName:lower():find("police") or teamName:lower():find("cop"))
end

local function isCriminalPlayer(player)
    local teamName = getPlayerTeam(player)
    return teamName and (teamName:lower():find("criminal") or teamName:lower():find("crim") or teamName:lower():find("bad"))
end

local function captureColorFromValue(value)
    local valueType = typeof(value)
    if valueType == "Color3" then
        return value
    elseif valueType == "BrickColor" then
        return value.Color
    elseif valueType == "ColorSequence" then
        return value.Keypoints[#value.Keypoints].Value
    elseif valueType == "Vector3" then
        return Color3.new(math.clamp(value.X, 0, 1), math.clamp(value.Y, 0, 1), math.clamp(value.Z, 0, 1))
    elseif valueType == "UDim2" then
        return Color3.fromRGB(math.clamp(value.X.Offset, 0, 255), math.clamp(value.Y.Offset, 0, 255), 200)
    elseif valueType == "string" then
        local hex = value:match("#?(%x%x%x%x%x%x)")
        if hex then
            local r = tonumber(hex:sub(1, 2), 16)
            local g = tonumber(hex:sub(3, 4), 16)
            local b = tonumber(hex:sub(5, 6), 16)
            if r and g and b then
                return Color3.fromRGB(r, g, b)
            end
        end
        local rStr, gStr, bStr = value:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
        if rStr and gStr and bStr then
            return Color3.fromRGB(tonumber(rStr), tonumber(gStr), tonumber(bStr))
        end
    elseif valueType == "number" then
        if value >= 0 and value <= 1 then
            return Color3.new(value, value, value)
        end
        local success, brick = pcall(BrickColor.new, value)
        if success and brick then
            return brick.Color
        end
        local r = math.floor(value % 256)
        local g = math.floor((value / 256) % 256)
        local b = math.floor((value / 65536) % 256)
        return Color3.fromRGB(r, g, b)
    elseif valueType == "Instance" then
        if value:IsA("Color3Value") then
            return value.Value
        elseif value:IsA("BrickColorValue") then
            return value.Value.Color
        end
    end
    return nil
end

local function getLeaderboardColor(player)
    if isCriminalPlayer(LocalPlayer) and isSheriff(player) then
        return Color3.fromRGB(0, 100, 255)
    end

    if player.Team and player.TeamColor then
        return player.TeamColor.Color
    end

    local attributes = player:GetAttributes()
    for key, attrValue in pairs(attributes) do
        if key:lower():find("color") then
            local color = captureColorFromValue(attrValue)
            if color then
                return color
            end
        end
    end

    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        for _, child in ipairs(leaderstats:GetChildren()) do
            local color = captureColorFromValue(child)
            if not color and child:IsA("ValueBase") then
                color = captureColorFromValue(child.Value)
            end
            if color then
                return color
            end
        end
    end

    return Color3.fromRGB(255, 170, 127)
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

local characterCache = {}
local modelToPlayer = {}
local alignmentCache = {}

local function isCharacterModel(instance)
    if not (instance and instance:IsA("Model") and instance.Parent) then
        return false
    end
    local model = instance
    local humanoid = getCharacterHumanoid(model)
    local root = getCharacterRoot(model)
    return humanoid ~= nil and root ~= nil
end

local function modelBelongsToPlayer(model, player)
    if model.Name == player.Name then
        return true
    end

    local function checkAttribute(name, value)
        if not name then
            return false
        end
        local lowerName = name:lower()
        if lowerName:find("player") or lowerName:find("owner") or lowerName:find("user") then
            if typeof(value) == "Instance" and value == player then
                return true
            elseif typeof(value) == "number" and value == player.UserId then
                return true
            elseif typeof(value) == "string" and value:lower() == player.Name:lower() then
                return true
            end
        end
        return false
    end

    for attributeName, attributeValue in pairs(model:GetAttributes()) do
        if checkAttribute(attributeName, attributeValue) then
            return true
        end
        if typeof(attributeValue) == "string" and attributeValue:lower() == player.Name:lower() then
            return true
        elseif typeof(attributeValue) == "number" and attributeValue == player.UserId then
            return true
        end
    end

    local potentialTags = {"Owner", "Player", "PlayerOwner", "PlayerName", "Username"}
    for _, tagName in ipairs(potentialTags) do
        local tag = model:FindFirstChild(tagName)
        if tag then
            if tag:IsA("ObjectValue") and tag.Value == player then
                return true
            elseif tag:IsA("StringValue") and tag.Value:lower() == player.Name:lower() then
                return true
            elseif tag:IsA("NumberValue") and tag.Value == player.UserId then
                return true
            end
        end
    end

    return false
end

local function locateCharacterInWorkspace(player)
    local byName = Workspace:FindFirstChild(player.Name, true)
    if byName and byName:IsA("Model") and isCharacterModel(byName) then
        return byName
    end

    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if descendant:IsA("Model") and isCharacterModel(descendant) then
            local model = descendant
            if modelBelongsToPlayer(model, player) then
                return model
            end
        end
    end

    return nil
end

local function getCharacterCache(player)
    local entry = characterCache[player]
    if entry then
        return entry
    end
    entry = {
        model = nil,
        lastSearch = 0
    }
    characterCache[player] = entry
    return entry
end

local function assignCachedCharacter(player, character)
    local entry = getCharacterCache(player)
    if entry.model and modelToPlayer[entry.model] == player then
        modelToPlayer[entry.model] = nil
    end
    entry.model = character
    entry.lastSearch = os.clock()
    if character then
        modelToPlayer[character] = player
    end
end

local function invalidateCachedCharacter(player, target)
    local entry = characterCache[player]
    if not entry then
        return
    end
    if target == nil or entry.model == target then
        if entry.model and modelToPlayer[entry.model] == player then
            modelToPlayer[entry.model] = nil
        end
        entry.model = nil
        entry.lastSearch = 0
    end
end

local function resolveCharacter(player)
    local entry = getCharacterCache(player)

    local currentCharacter = player.Character
    if isCharacterModel(currentCharacter) then
        local model = currentCharacter
        assignCachedCharacter(player, model)
        return model
    end

    if entry.model and isCharacterModel(entry.model) then
        return entry.model
    end

    local now = os.clock()
    if now - entry.lastSearch < 1 then
        return nil
    end

    local located = locateCharacterInWorkspace(player)
    assignCachedCharacter(player, located)
    return located
end

local espEnabled = false
local highlightFolder = Instance.new("Folder")
highlightFolder.Name = "MooCoreHighlights"
highlightFolder.Parent = Workspace

local playerConnections = {}
local highlightMap = {}
local colorUpdaterConnection = nil

local function removeHighlight(player)
    local highlight = highlightMap[player]
    if highlight then
        highlight:Destroy()
        highlightMap[player] = nil
    end
end

local function applyHighlight(player)
    if not espEnabled then
        return
    end
    if not isValidOpponent(player) then
        removeHighlight(player)
        return
    end

    local character = resolveCharacter(player)
    if not character then
        removeHighlight(player)
        return
    end

    local humanoid = getCharacterHumanoid(character)
    if not humanoid or humanoid.Health <= 0 then
        removeHighlight(player)
        return
    end

    local highlight = highlightMap[player]
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = `MooCoreESP_{player.Name}`
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillTransparency = 0.65
        highlight.OutlineTransparency = 0
        highlight.Adornee = character
        highlight.Parent = highlightFolder
        highlightMap[player] = highlight
    else
        highlight.Adornee = character
        highlight.Enabled = true
    end

    local color = getLeaderboardColor(player)
    highlight.FillColor = color
    highlight.OutlineColor = color
end

local function updateAllHighlights()
    for player, highlight in pairs(highlightMap) do
        if highlight then
            local character = resolveCharacter(player)
            if character then
                highlight.Adornee = character
                highlight.Enabled = true
                local color = getLeaderboardColor(player)
                highlight.FillColor = color
                highlight.OutlineColor = color
            else
                highlight.Enabled = false
            end
        end
    end
end

local function disconnectConnection(connection)
    if connection then
        connection:Disconnect()
    end
end

local function detachLeaderstatsConnections(connections)
    if not connections then
        return
    end
    disconnectConnection(connections.LeaderChildAdded)
    connections.LeaderChildAdded = nil
    disconnectConnection(connections.LeaderChildRemoved)
    connections.LeaderChildRemoved = nil
    if connections.LeaderValueSignals then
        for _, signal in ipairs(connections.LeaderValueSignals) do
            disconnectConnection(signal)
        end
        connections.LeaderValueSignals = nil
    end
end

local function attachLeaderstatsConnections(player, leaderstats, connections)
    detachLeaderstatsConnections(connections)
    if not (leaderstats and leaderstats:IsA("Folder")) then
        return
    end

    connections.LeaderValueSignals = {}

    local function bindValue(valueObject)
        table.insert(connections.LeaderValueSignals, valueObject:GetPropertyChangedSignal("Value"):Connect(function()
            local alignmentEntry = alignmentCache[player]
            if alignmentEntry then
                alignmentEntry.lastCheck = 0
            end
            if espEnabled then
                applyHighlight(player)
            end
        end))
    end

    for _, child in ipairs(leaderstats:GetChildren()) do
        if child:IsA("ValueBase") then
            bindValue(child)
        end
    end

    connections.LeaderChildAdded = leaderstats.ChildAdded:Connect(function(child)
        if child:IsA("ValueBase") then
            bindValue(child)
        end
        local alignmentEntry = alignmentCache[player]
        if alignmentEntry then
            alignmentEntry.lastCheck = 0
        end
        if espEnabled then
            task.defer(updateAllHighlights)
        end
    end)

    connections.LeaderChildRemoved = leaderstats.ChildRemoved:Connect(function()
        local alignmentEntry = alignmentCache[player]
        if alignmentEntry then
            alignmentEntry.lastCheck = 0
        end
        if espEnabled then
            task.defer(updateAllHighlights)
        end
        attachLeaderstatsConnections(player, leaderstats, connections)
    end)
end

local function setupPlayerConnections(player)
    if player == LocalPlayer then
        return
    end

    local connections = playerConnections[player]
    if connections then
        return
    end

    connections = {}

    connections.CharacterAdded = player.CharacterAdded:Connect(function(character)
        assignCachedCharacter(player, character)
        if espEnabled then
            task.wait(0.2)
            applyHighlight(player)
        end
    end)

    connections.CharacterRemoving = player.CharacterRemoving:Connect(function(character)
        invalidateCachedCharacter(player, character)
        local highlight = highlightMap[player]
        if highlight then
            highlight.Adornee = nil
        end
    end)

    connections.TeamChanged = player:GetPropertyChangedSignal("Team"):Connect(function()
        local alignmentEntry = alignmentCache[player]
        if alignmentEntry then
            alignmentEntry.lastCheck = 0
        end
        if espEnabled then
            applyHighlight(player)
        else
            removeHighlight(player)
        end
    end)

    connections.AttributeChanged = player.AttributeChanged:Connect(function()
        local alignmentEntry = alignmentCache[player]
        if alignmentEntry then
            alignmentEntry.lastCheck = 0
        end
    end)

    connections.PlayerChildAdded = player.ChildAdded:Connect(function(child)
        if child.Name == "leaderstats" then
            attachLeaderstatsConnections(player, child, connections)
            if espEnabled then
                task.defer(function()
                    applyHighlight(player)
                    updateAllHighlights()
                end)
            end
        end
        if child:IsA("Folder") or child:IsA("ValueBase") then
            local alignmentEntry = alignmentCache[player]
            if alignmentEntry then
                alignmentEntry.lastCheck = 0
            end
        end
    end)

    connections.PlayerChildRemoved = player.ChildRemoved:Connect(function(child)
        if child.Name == "leaderstats" then
            detachLeaderstatsConnections(connections)
        end
        if child:IsA("Folder") or child:IsA("ValueBase") then
            local alignmentEntry = alignmentCache[player]
            if alignmentEntry then
                alignmentEntry.lastCheck = 0
            end
        end
    end)

    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        attachLeaderstatsConnections(player, leaderstats, connections)
    end

    playerConnections[player] = connections

    if espEnabled then
        task.defer(function()
            applyHighlight(player)
        end)
    end
end

local function clearPlayerConnections(player)
    local connections = playerConnections[player]
    if connections then
        detachLeaderstatsConnections(connections)
        for _, connection in pairs(connections) do
            if typeof(connection) == "RBXScriptConnection" then
                connection:Disconnect()
            end
        end
        playerConnections[player] = nil
    end
    invalidateCachedCharacter(player, nil)
    characterCache[player] = nil
    alignmentCache[player] = nil
    removeHighlight(player)
end

function ESP.setESP(state)
    espEnabled = state
    if state then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                applyHighlight(player)
            end
        end
        if not colorUpdaterConnection then
            colorUpdaterConnection = RunService.Heartbeat:Connect(function()
                updateAllHighlights()
            end)
        end
    else
        for player, highlight in pairs(highlightMap) do
            if highlight then
                highlight:Destroy()
            end
            highlightMap[player] = nil
        end
        if colorUpdaterConnection then
            colorUpdaterConnection:Disconnect()
            colorUpdaterConnection = nil
        end
    end
end

function ESP.initialize()
    for _, player in ipairs(Players:GetPlayers()) do
        setupPlayerConnections(player)
    end

    Players.PlayerAdded:Connect(setupPlayerConnections)
    Players.PlayerRemoving:Connect(function(player)
        clearPlayerConnections(player)
    end)

    Workspace.DescendantAdded:Connect(function(instance)
        if not instance:IsA("Model") then
            return
        end
        if not isCharacterModel(instance) then
            return
        end
        local model = instance
        for _, player in ipairs(Players:GetPlayers()) do
            if modelBelongsToPlayer(model, player) then
                assignCachedCharacter(player, model)
                if espEnabled then
                    task.defer(function()
                        applyHighlight(player)
                    end)
                end
                break
            end
        end
    end)

    Workspace.DescendantRemoving:Connect(function(instance)
        if not instance:IsA("Model") then
            return
        end
        local model = instance
        local owner = modelToPlayer[model]
        if owner then
            invalidateCachedCharacter(owner, model)
            modelToPlayer[model] = nil
            local highlight = highlightMap[owner]
            if highlight then
                highlight.Enabled = false
                highlight.Adornee = nil
            end
        end
    end)
end

return ESP
