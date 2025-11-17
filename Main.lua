local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MooCoreGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50) -- Smaller
ToggleButton.Position = UDim2.new(0, 25, 0.5, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "M"
ToggleButton.TextSize = 20 -- Smaller
ToggleButton.Font = Enum.Font.GothamBlack
ToggleButton.BorderSizePixel = 0
ToggleButton.ZIndex = 100
ToggleButton.AutoButtonColor = false

local UICorner1 = Instance.new("UICorner")
UICorner1.CornerRadius = UDim.new(0, 12)
UICorner1.Parent = ToggleButton

local ButtonGradient = Instance.new("UIGradient")
ButtonGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 80, 220)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 120, 240)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 80, 220))
})
ButtonGradient.Rotation = 45
ButtonGradient.Parent = ToggleButton

local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Color = Color3.fromRGB(180, 140, 255)
ButtonStroke.Thickness = 2
ButtonStroke.Parent = ToggleButton

ToggleButton.Parent = ScreenGui

-- Set GUI size to 400x250
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 50) -- Smaller closed height
MainFrame.Position = UDim2.new(0, 85, 0, 25)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 12)
UICorner2.Parent = MainFrame

local FrameGradient = Instance.new("UIGradient")
FrameGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 25, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 15, 45))
})
FrameGradient.Parent = MainFrame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(100, 80, 180)
FrameStroke.Thickness = 2
FrameStroke.Parent = MainFrame

MainFrame.Parent = ScreenGui

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50) -- Smaller
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
TitleBar.BorderSizePixel = 0

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 12)
UICorner3.Parent = TitleBar

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 60, 140)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 40, 120))
})
TitleGradient.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "MooCore NpcOrDie"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16 -- Smaller
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

TitleBar.Parent = MainFrame

local TabButtons = Instance.new("Frame")
TabButtons.Name = "TabButtons"
TabButtons.Size = UDim2.new(1, 0, 0, 35) -- Smaller
TabButtons.Position = UDim2.new(0, 0, 0, 50)
TabButtons.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
TabButtons.BorderSizePixel = 0
TabButtons.Parent = MainFrame

-- Scrolling content frame
local ContentScrollingFrame = Instance.new("ScrollingFrame")
ContentScrollingFrame.Name = "ContentScrollingFrame"
ContentScrollingFrame.Size = UDim2.new(1, 0, 1, -85) -- Adjusted for smaller title/tabs
ContentScrollingFrame.Position = UDim2.new(0, 0, 0, 85)
ContentScrollingFrame.BackgroundTransparency = 1
ContentScrollingFrame.ScrollBarThickness = 4
ContentScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 80, 180)
ContentScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
ContentScrollingFrame.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, 0)
ContentFrame.Position = UDim2.new(0, 0, 0, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = ContentScrollingFrame

local NotificationFrame = Instance.new("Frame")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Size = UDim2.new(0, 350, 0, 120) -- Smaller
NotificationFrame.Position = UDim2.new(1, -360, 1, -130)
NotificationFrame.BackgroundTransparency = 1
NotificationFrame.Parent = ScreenGui

local function getCharacter()
    local char = player.Character or player.CharacterAdded:Wait()
    local humPart = char:WaitForChild("HumanoidRootPart", 5)
    return char, humPart
end

local char, humPart = getCharacter()

player.CharacterAdded:Connect(function()
    char, humPart = getCharacter()
    if char:FindFirstChild("Humanoid") then
        char.Humanoid.UseJumpPower = true
    end
end)

if queueteleport then
    local TeleportCheck = false
    player.OnTeleport:Connect(function(State)
        if queueteleport and (not TeleportCheck) then
            TeleportCheck = true
            queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/Bac0nHck/Scripts/refs/heads/main/BeNpcOrDie'))()")
        end
    end)
end

local featureStates = {
    ToggleESP = false,
    SpeedBoost = false,
    Noclip = false,
    Aimlock = false,
    FarmToggle = false,
    AutoObby = false,
    AutoTask2 = false,
    AutoTask = false,
    InstanceTask = false,
    InfStamina = false,
    ToggleSpeed = false,
    ToggleJump = false,
    FullToggle = false,
    SheriffToggle = false,
    ServerHopToggle = false
}

local connections = {
    noclip = nil,
    aimlock = nil,
    esp = {},
    farm = nil,
    autotask = nil,
    autotask2 = nil,
    autoobby = nil,
    instancetask = nil,
    instamina = nil,
    togglespeed = nil,
    togglejump = nil,
    full = nil,
    sheriff = nil,
    serverhop = nil
}

local function showNotification(title, message, color)
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(1, 0, 0, 60) -- Smaller
    Notification.Position = UDim2.new(0, 0, 1, 0)
    Notification.BackgroundColor3 = Color3.fromRGB(25, 20, 45)
    Notification.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Notification
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = color
    UIStroke.Thickness = 2
    UIStroke.Parent = Notification
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 20) -- Smaller
    Title.Position = UDim2.new(0, 15, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = color
    Title.TextSize = 14 -- Smaller
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Notification
    
    local Message = Instance.new("TextLabel")
    Message.Size = UDim2.new(1, -20, 0, 30) -- Smaller
    Message.Position = UDim2.new(0, 15, 0, 28)
    Message.BackgroundTransparency = 1
    Message.Text = message
    Message.TextColor3 = Color3.fromRGB(220, 220, 255)
    Message.TextSize = 12 -- Smaller
    Message.Font = Enum.Font.Gotham
    Message.TextXAlignment = Enum.TextXAlignment.Left
    Message.TextYAlignment = Enum.TextYAlignment.Top
    Message.Parent = Notification
    
    Notification.Parent = NotificationFrame
    
    local slideIn = TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
    local slideOut = TweenService:Create(Notification, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0, 0, 1, 0)})
    
    slideIn:Play()
    wait(3.5)
    slideOut:Play()
    wait(0.4)
    Notification:Destroy()
end

local function createTabButton(name, position)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Size = UDim2.new(0.25, 0, 1, 0) -- Adjusted for 4 tabs
    TabButton.Position = position
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 255)
    TabButton.Text = name
    TabButton.TextSize = 10 -- Smaller
    TabButton.Font = Enum.Font.GothamBold
    TabButton.BorderSizePixel = 0
    TabButton.AutoButtonColor = false
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    TabButton.Parent = TabButtons
    return TabButton
end

local toggleStates = {}

local function createToggle(name, parent, position)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Toggle"
    ToggleFrame.Size = UDim2.new(1, -15, 0, 28) -- Smaller
    ToggleFrame.Position = position
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "Button"
    ToggleButton.Size = UDim2.new(0, 50, 0, 22) -- Smaller
    ToggleButton.Position = UDim2.new(1, -55, 0.5, -11)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 40, 70)
    ToggleButton.Text = ""
    ToggleButton.BorderSizePixel = 0
    ToggleButton.AutoButtonColor = false
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = ToggleButton
    
    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Name = "Indicator"
    ToggleIndicator.Size = UDim2.new(0, 18, 0, 18) -- Smaller
    ToggleIndicator.Position = UDim2.new(0, 2, 0.5, -9)
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
    ToggleIndicator.BorderSizePixel = 0
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(1, 0)
    UICorner2.Parent = ToggleIndicator
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 12 -- Smaller
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local toggleTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    ToggleIndicator.Parent = ToggleButton
    ToggleButton.Parent = ToggleFrame
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggleStates[name] = not toggleStates[name]
        
        local targetPosition = toggleStates[name] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        local targetColor = toggleStates[name] and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(220, 80, 80)
        local buttonColor = toggleStates[name] and Color3.fromRGB(65, 120, 85) or Color3.fromRGB(75, 70, 95)
        
        local tween1 = TweenService:Create(ToggleIndicator, toggleTweenInfo, {Position = targetPosition, BackgroundColor3 = targetColor})
        local tween2 = TweenService:Create(ToggleButton, toggleTweenInfo, {BackgroundColor3 = buttonColor})
        
        tween1:Play()
        tween2:Play()
        
        -- Update feature states based on toggle name
        if name == "ESP" then
            featureStates.ToggleESP = toggleStates[name]
            if toggleStates[name] then
                showNotification("ESP Enabled", "Now highlighting players", Color3.fromRGB(80, 220, 120))
            else
                showNotification("ESP Disabled", "No longer highlighting players", Color3.fromRGB(220, 80, 80))
            end
        elseif name == "Speed Boost" then
            featureStates.SpeedBoost = toggleStates[name]
            updateSpeed()
        elseif name == "Noclip" then
            featureStates.Noclip = toggleStates[name]
            updateNoclip()
        elseif name == "Aimlock" then
            featureStates.Aimlock = toggleStates[name]
            showNotification("Aimlock", featureStates.Aimlock and "Press E to lock on target" or "Aimlock disabled", featureStates.Aimlock and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(220, 80, 80))
        elseif name == "Cash Farm" then
            featureStates.FarmToggle = toggleStates[name]
        elseif name == "Auto Obby" then
            featureStates.AutoObby = toggleStates[name]
        elseif name == "Auto Task" then
            featureStates.AutoTask = toggleStates[name]
        elseif name == "Auto Task 2" then
            featureStates.AutoTask2 = toggleStates[name]
        elseif name == "Instance Task" then
            featureStates.InstanceTask = toggleStates[name]
        elseif name == "Inf Stamina" then
            featureStates.InfStamina = toggleStates[name]
        elseif name == "Toggle Speed" then
            featureStates.ToggleSpeed = toggleStates[name]
            updateSpeed()
        elseif name == "Toggle Jump" then
            featureStates.ToggleJump = toggleStates[name]
            updateJump()
        elseif name == "Reset if Full" then
            featureStates.FullToggle = toggleStates[name]
        elseif name == "Reset if Sheriff" then
            featureStates.SheriffToggle = toggleStates[name]
        elseif name == "Auto Server Hop" then
            featureStates.ServerHopToggle = toggleStates[name]
        end
        
        if name ~= "ESP" and name ~= "Aimlock" then
            showNotification(name, toggleStates[name] and "Enabled" or "Disabled", toggleStates[name] and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(220, 80, 80))
        end
    end)
    
    return ToggleFrame, ToggleButton
end

-- Create tabs (only 4 now: Main, Farm, Tasks, Player)
local MainTab = Instance.new("Frame")
MainTab.Name = "MainTab"
MainTab.Size = UDim2.new(1, 0, 0, 400)
MainTab.Position = UDim2.new(0, 0, 0, 0)
MainTab.BackgroundTransparency = 1
MainTab.Visible = false
MainTab.Parent = ContentFrame

local FarmTab = Instance.new("Frame")
FarmTab.Name = "FarmTab"
FarmTab.Size = UDim2.new(1, 0, 0, 400)
FarmTab.Position = UDim2.new(0, 0, 0, 0)
FarmTab.BackgroundTransparency = 1
FarmTab.Visible = false
FarmTab.Parent = ContentFrame

local TasksTab = Instance.new("Frame")
TasksTab.Name = "TasksTab"
TasksTab.Size = UDim2.new(1, 0, 0, 400)
TasksTab.Position = UDim2.new(0, 0, 0, 0)
TasksTab.BackgroundTransparency = 1
TasksTab.Visible = false
TasksTab.Parent = ContentFrame

local PlayerTab = Instance.new("Frame")
PlayerTab.Name = "PlayerTab"
PlayerTab.Size = UDim2.new(1, 0, 0, 400)
PlayerTab.Position = UDim2.new(0, 0, 0, 0)
PlayerTab.BackgroundTransparency = 1
PlayerTab.Visible = false
PlayerTab.Parent = ContentFrame

-- Create toggles with proper spacing (smaller)
local MainESP, MainESPToggle = createToggle("ESP", MainTab, UDim2.new(0, 0, 0, 15))
local MainAimlock, MainAimlockToggle = createToggle("Aimlock", MainTab, UDim2.new(0, 0, 0, 53))
local MainKillNPC = Instance.new("TextButton")
MainKillNPC.Size = UDim2.new(0, 120, 0, 28) -- Smaller
MainKillNPC.Position = UDim2.new(0, 15, 0, 91)
MainKillNPC.BackgroundColor3 = Color3.fromRGB(80, 60, 150)
MainKillNPC.TextColor3 = Color3.fromRGB(255, 255, 255)
MainKillNPC.Text = "Kill Nearest NPCs"
MainKillNPC.TextSize = 11 -- Smaller
MainKillNPC.Font = Enum.Font.Gotham
MainKillNPC.BorderSizePixel = 0
MainKillNPC.Parent = MainTab
local ButtonCorner3 = Instance.new("UICorner")
ButtonCorner3.CornerRadius = UDim.new(0, 6)
ButtonCorner3.Parent = MainKillNPC

-- Farm Tab (includes Auto Obby)
local FarmCash, FarmCashToggle = createToggle("Cash Farm", FarmTab, UDim2.new(0, 0, 0, 15))
local FarmAutoObby, FarmAutoObbyToggle = createToggle("Auto Obby", FarmTab, UDim2.new(0, 0, 0, 53))
local FarmFull, FarmFullToggle = createToggle("Reset if Full", FarmTab, UDim2.new(0, 0, 0, 91))
local FarmSheriff, FarmSheriffToggle = createToggle("Reset if Sheriff", FarmTab, UDim2.new(0, 0, 0, 129))
local FarmServerHop, FarmServerHopToggle = createToggle("Auto Server Hop", FarmTab, UDim2.new(0, 0, 0, 167))
local FarmServerHopButton = Instance.new("TextButton")
FarmServerHopButton.Size = UDim2.new(0, 120, 0, 28) -- Smaller
FarmServerHopButton.Position = UDim2.new(0, 15, 0, 205)
FarmServerHopButton.BackgroundColor3 = Color3.fromRGB(80, 60, 150)
FarmServerHopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmServerHopButton.Text = "Server Hop"
FarmServerHopButton.TextSize = 11 -- Smaller
FarmServerHopButton.Font = Enum.Font.Gotham
FarmServerHopButton.BorderSizePixel = 0
FarmServerHopButton.Parent = FarmTab
local ButtonCorner2 = Instance.new("UICorner")
ButtonCorner2.CornerRadius = UDim.new(0, 6)
ButtonCorner2.Parent = FarmServerHopButton

-- Tasks Tab
local TasksAutoTask, TasksAutoTaskToggle = createToggle("Auto Task", TasksTab, UDim2.new(0, 0, 0, 15))
local TasksAutoTask2, TasksAutoTask2Toggle = createToggle("Auto Task 2", TasksTab, UDim2.new(0, 0, 0, 53))
local TasksInstanceTask, TasksInstanceTaskToggle = createToggle("Instance Task", TasksTab, UDim2.new(0, 0, 0, 91))
local TasksInstanceButton = Instance.new("TextButton")
TasksInstanceButton.Size = UDim2.new(0, 120, 0, 28) -- Smaller
TasksInstanceButton.Position = UDim2.new(0, 15, 0, 129)
TasksInstanceButton.BackgroundColor3 = Color3.fromRGB(80, 60, 150)
TasksInstanceButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TasksInstanceButton.Text = "Instance Tasks"
TasksInstanceButton.TextSize = 11 -- Smaller
TasksInstanceButton.Font = Enum.Font.Gotham
TasksInstanceButton.BorderSizePixel = 0
TasksInstanceButton.Parent = TasksTab
local ButtonCorner4 = Instance.new("UICorner")
ButtonCorner4.CornerRadius = UDim.new(0, 6)
ButtonCorner4.Parent = TasksInstanceButton

-- Player Tab
local PlayerInfStamina, PlayerInfStaminaToggle = createToggle("Inf Stamina", PlayerTab, UDim2.new(0, 0, 0, 15))
local PlayerToggleSpeed, PlayerToggleSpeedToggle = createToggle("Toggle Speed", PlayerTab, UDim2.new(0, 0, 0, 53))
local PlayerToggleJump, PlayerToggleJumpToggle = createToggle("Toggle Jump", PlayerTab, UDim2.new(0, 0, 0, 91))
local PlayerNoclip, PlayerNoclipToggle = createToggle("Noclip", PlayerTab, UDim2.new(0, 0, 0, 129))
local PlayerSpeedBoost, PlayerSpeedBoostToggle = createToggle("Speed Boost", PlayerTab, UDim2.new(0, 0, 0, 167))
local PlayerFullBright = Instance.new("TextButton")
PlayerFullBright.Size = UDim2.new(0, 120, 0, 28) -- Smaller
PlayerFullBright.Position = UDim2.new(0, 15, 0, 205)
PlayerFullBright.BackgroundColor3 = Color3.fromRGB(80, 60, 150)
PlayerFullBright.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerFullBright.Text = "FullBright"
PlayerFullBright.TextSize = 11 -- Smaller
PlayerFullBright.Font = Enum.Font.Gotham
PlayerFullBright.BorderSizePixel = 0
PlayerFullBright.Parent = PlayerTab
local ButtonCorner5 = Instance.new("UICorner")
ButtonCorner5.CornerRadius = UDim.new(0, 6)
ButtonCorner5.Parent = PlayerFullBright

-- Create tab buttons (only 4 tabs)
local MainTabButton = createTabButton("Main", UDim2.new(0, 0, 0, 0))
local FarmTabButton = createTabButton("Farm", UDim2.new(0.25, 0, 0, 0))
local TasksTabButton = createTabButton("Tasks", UDim2.new(0.5, 0, 0, 0))
local PlayerTabButton = createTabButton("Player", UDim2.new(0.75, 0, 0, 0))

local currentTab = nil

local function switchTab(tab)
    if currentTab then
        currentTab.Visible = false
    end
    
    MainTabButton.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
    FarmTabButton.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
    TasksTabButton.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
    PlayerTabButton.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
    
    tab.Visible = true
    currentTab = tab
end

MainTabButton.MouseButton1Click:Connect(function()
    switchTab(MainTab)
    MainTabButton.BackgroundColor3 = Color3.fromRGB(70, 50, 120)
end)

FarmTabButton.MouseButton1Click:Connect(function()
    switchTab(FarmTab)
    FarmTabButton.BackgroundColor3 = Color3.fromRGB(70, 50, 120)
end)

TasksTabButton.MouseButton1Click:Connect(function()
    switchTab(TasksTab)
    TasksTabButton.BackgroundColor3 = Color3.fromRGB(70, 50, 120)
end)

PlayerTabButton.MouseButton1Click:Connect(function()
    switchTab(PlayerTab)
    PlayerTabButton.BackgroundColor3 = Color3.fromRGB(70, 50, 120)
end)

switchTab(MainTab)
MainTabButton.BackgroundColor3 = Color3.fromRGB(70, 50, 120)

local isOpen = false
local frameTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

ToggleButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    
    if not MainFrame.Visible then
        MainFrame.Visible = true
    end
    
    local targetSize = isOpen and UDim2.new(0, 400, 0, 250) or UDim2.new(0, 400, 0, 50)
    local tween = TweenService:Create(MainFrame, frameTweenInfo, {Size = targetSize})
    tween:Play()
    
    local textTween = TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Text = isOpen and "X" or "M"})
    textTween:Play()
    
    local rotateTween = TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = isOpen and 180 or 0})
    rotateTween:Play()
end)

-- ESP System from provided code
local function updateESP()
    if featureStates.ToggleESP then
        while featureStates.ToggleESP do
            pcall(function()
                for _, playerObj in pairs(Workspace:GetDescendants()) do
                    if playerObj:IsA("Model") and playerObj:FindFirstChild("HumanoidRootPart") then
                        if playerObj:FindFirstChild("HumanoidRootPart").CollisionGroup == "Player" and playerObj ~= char then
                            local playerObject = Players:GetPlayerFromCharacter(playerObj)

                            if playerObject and playerObject.Team and playerObject.Team.Name == "Sheriffs" then
                                if playerObj:FindFirstChild("ESP") then
                                    playerObj:FindFirstChild("ESP").Color3 = Color3.new(0, 0, 1)
                                else
                                    local box = Instance.new("BoxHandleAdornment", playerObj)
                                    box.Name = "ESP"
                                    box.Adornee = playerObj
                                    box.AlwaysOnTop = true
                                    box.Size = Vector3.new(4, 5, 1)
                                    box.ZIndex = 0
                                    box.Transparency = 0.3
                                    box.Color3 = Color3.new(0, 0, 1)
                                end
                            else
                                if not playerObj:FindFirstChild("ESP") then
                                    local box = Instance.new("BoxHandleAdornment", playerObj)
                                    box.Name = "ESP"
                                    box.Adornee = playerObj
                                    box.AlwaysOnTop = true
                                    box.Size = Vector3.new(4, 5, 1)
                                    box.ZIndex = 0
                                    box.Transparency = 0.3
                                    box.Color3 = Color3.new(0, 1, 0)
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(1)
        end
    else
        for _, e in pairs(Workspace:GetDescendants()) do
            if e.Name == "ESP" then
                e:Destroy()
            end
        end
    end
end

-- Speed System
local speedValue = 22
local function updateSpeed()
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        if featureStates.SpeedBoost then
            humanoid.WalkSpeed = 29
        elseif featureStates.ToggleSpeed then
            humanoid.WalkSpeed = tonumber(speedValue) or 22
        else
            if player.Team and player.Team.Name == "Lobby" then
                humanoid.WalkSpeed = 22
            elseif player.Team and player.Team.Name == "Sheriffs" then
                humanoid.WalkSpeed = 10
            elseif player.Team and player.Team.Name == "Criminals" then
                humanoid.WalkSpeed = 6.5
            end
        end
    end
end

-- Jump System
local jumpValue = 50
local function updateJump()
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        humanoid.UseJumpPower = true
        if featureStates.ToggleJump then
            humanoid.JumpPower = tonumber(jumpValue) or 50
        else
            humanoid.JumpPower = 50
        end
    end
end

-- Noclip System
local function updateNoclip()
    if connections.noclip then
        connections.noclip:Disconnect()
        connections.noclip = nil
    end
    
    if featureStates.Noclip then
        connections.noclip = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

-- Aimlock System
local aimlockTarget = nil
local currentAimlockKey = Enum.KeyCode.E

local function findAimlockTarget()
    local closestPlayer = nil
    local closestDistance = math.huge
    local localChar = player.Character
    
    if localChar and localChar:FindFirstChild("HumanoidRootPart") then
        local localPos = localChar.HumanoidRootPart.Position
        
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer ~= player and targetPlayer.Team and targetPlayer.Team.Name == "Criminals" then
                local targetChar = targetPlayer.Character
                if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("Humanoid") and targetChar.Humanoid.Health > 0 then
                    local distance = (localPos - targetChar.HumanoidRootPart.Position).Magnitude
                    
                    if distance < closestDistance and distance <= 50 then
                        closestDistance = distance
                        closestPlayer = targetPlayer
                    end
                end
            end
        end
    end
    return closestPlayer
end

local function toggleAimlock()
    if not featureStates.Aimlock then 
        showNotification("Aimlock Disabled", "Enable aimlock first", Color3.fromRGB(220, 80, 80))
        return 
    end
    
    local closestPlayer = findAimlockTarget()
    
    if closestPlayer then
        if aimlockTarget == closestPlayer then
            aimlockTarget = nil
            if connections.aimlock then
                connections.aimlock:Disconnect()
                connections.aimlock = nil
            end
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            showNotification("Aimlock Unlocked", "Target released", Color3.fromRGB(220, 80, 80))
        else
            aimlockTarget = closestPlayer
            
            if connections.aimlock then
                connections.aimlock:Disconnect()
            end
            
            connections.aimlock = RunService.Heartbeat:Connect(function()
                if aimlockTarget and aimlockTarget.Character and aimlockTarget.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = aimlockTarget.Character.HumanoidRootPart.Position
                    local camera = workspace.CurrentCamera
                    camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
                else
                    aimlockTarget = nil
                    if connections.aimlock then
                        connections.aimlock:Disconnect()
                        connections.aimlock = nil
                    end
                end
            end)
            showNotification("Aimlock Locked", "Target: " .. closestPlayer.Name, Color3.fromRGB(80, 220, 120))
        end
    else
        showNotification("Aimlock Failed", "No valid targets in radius", Color3.fromRGB(220, 80, 80))
    end
end

-- Server Hop Function
local function serverHop()
    local servers = {}
    local req = request({
        Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true",
        Method = "GET"
    })

    if req.StatusCode == 200 then
        local body = HttpService:JSONDecode(req.Body)
        if body and body.data then
            for _, server in ipairs(body.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server.id)
                end
            end
        end
    else
        warn("Failed to fetch server list: " .. req.StatusMessage)
    end

    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], player)
    else
        warn("No suitable servers found")
    end
end

-- Task System
local function instask()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.ClassName == "ProximityPrompt" and v.HoldDuration ~= 0 then
            v.HoldDuration = 0
        end
    end
end

-- Auto Farm System (Fixed - Teleport then move 2 studs)
connections.farm = RunService.Heartbeat:Connect(function()
    if featureStates.FarmToggle then
        pcall(function()
            local collect = workspace:FindFirstChild("CollectableItems")
            if collect then
                for _, p in ipairs(collect:GetChildren()) do
                    if not featureStates.FarmToggle then break end
                    if not p:GetAttribute("CannotSee") then
                        -- Teleport to collectable
                        humPart.CFrame = p.CFrame
                        task.wait(0.2)
                        
                        -- Move 2 studs forward from current position
                        local forwardDirection = humPart.CFrame.LookVector
                        local newPosition = humPart.Position + (forwardDirection * 2)
                        humPart.CFrame = CFrame.new(newPosition, newPosition + forwardDirection)
                        task.wait(0.3)
                        
                        -- Jump to collect
                        local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                        if humanoid then 
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end
                    task.wait(1)
                end
            end
        end)
    end
end)

-- Other feature connections
connections.full = RunService.Heartbeat:Connect(function()
    if featureStates.FullToggle then
        local bag = player.PlayerGui:WaitForChild("Timer"):WaitForChild("Frame"):WaitForChild("Bags"):WaitForChild("CashBag"):WaitForChild("Bag"):WaitForChild("AmountCollected")
        if bag and featureStates.FarmToggle then
            if bag.Text == "FULL!" and player.Team and player.Team.Name == "Criminals" then
                local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                if humanoid then humanoid.Health = 0 end
            end
        end
    end
end)

connections.sheriff = RunService.Heartbeat:Connect(function()
    if featureStates.SheriffToggle then
        if player.Team and player.Team.Name == "Sheriffs" and featureStates.FarmToggle then
            local humanoid = char:FindFirstChildWhichIsA("Humanoid")
            if humanoid then humanoid.Health = 0 end
        end
    end
end)

connections.serverhop = RunService.Heartbeat:Connect(function()
    if featureStates.ServerHopToggle then
        if #Players:GetPlayers() <= 3 then
            serverHop()
        end
    end
end)

connections.autotask2 = RunService.Heartbeat:Connect(function()
    if featureStates.AutoTask2 then
        pcall(function()
            local taskName = char:GetAttribute("TaskName")
            if taskName and taskName ~= "" then
                local yourTask
                local parentTask
                for _, task in pairs(workspace:GetDescendants()) do
                    if task:IsA("ProximityPrompt") and task.Parent and task.Parent.Name == taskName then
                        yourTask = task
                        parentTask = task.Parent
                        break
                    end
                end

                if yourTask then
                    yourTask.Parent = char
                    yourTask.HoldDuration = 0

                    while featureStates.AutoTask2 and char:GetAttribute("TaskName") == taskName do
                        yourTask:InputHoldBegin()
                        yourTask:InputHoldEnd()
                        task.wait(0.1)
                    end

                    if yourTask.Parent == char then
                        yourTask.Parent = parentTask
                    end
                end
            end
        end)
    end
end)

connections.autoobby = RunService.Heartbeat:Connect(function()
    if featureStates.AutoObby then
        pcall(function()
            if player and player.Team and player.Team.Name == "Lobby" then
                firetouchinterest(
                    player.Character.HumanoidRootPart,
                    workspace:FindFirstChild("Lobby"):FindFirstChild("Obby"):FindFirstChild("ObbyEndPart"),
                    0
                )
                firetouchinterest(
                    player.Character.HumanoidRootPart,
                    workspace:FindFirstChild("Lobby"):FindFirstChild("Obby"):FindFirstChild("ObbyEndPart"),
                    1
                )
            end
        end)
    end
end)

connections.autotask = RunService.Heartbeat:Connect(function()
    if featureStates.AutoTask then
        local taskName = char:GetAttribute("TaskName")
        for _, task in pairs(Workspace:GetDescendants()) do
            if task:IsA("Model") and task.Name == taskName and task.Parent.Name == "Tasks" then
                local hitbox = task:WaitForChild("Hitbox")
                local distance = (humPart.Position - hitbox.Position).Magnitude
                if distance <= task.ProximityPrompt.MaxActivationDistance then
                    local prompt = task.ProximityPrompt
                    prompt.HoldDuration = 0
                    prompt:InputHoldBegin()
                    task.wait(prompt.HoldDuration)
                    prompt:InputHoldEnd()
                end
            end
        end
    end
end)

connections.instancetask = RunService.Heartbeat:Connect(function()
    if featureStates.InstanceTask then
        instask()
    end
end)

connections.instamina = RunService.Heartbeat:Connect(function()
    if featureStates.InfStamina then
        pcall(function()
            if player:WaitForChild("PlayerGui"):FindFirstChild("Modules"):FindFirstChild("Gameplay"):WaitForChild("Sprint") then
                player:WaitForChild("PlayerGui"):FindFirstChild("Modules"):FindFirstChild("Gameplay"):WaitForChild("Sprint"):FindFirstChild("Stamina").Value = 9e9
            end
        end)
    end
end)

-- ESP connection
connections.esp = RunService.Heartbeat:Connect(function()
    updateESP()
end)

-- Input handling for aimlock
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == currentAimlockKey then
        toggleAimlock()
    end
end)

-- Anti AFK
local bb = game:GetService("VirtualUser")
player.Idled:connect(function()
    bb:CaptureController()
    bb:ClickButton2(Vector2.new())
end)

-- Button click handlers
FarmServerHopButton.MouseButton1Click:Connect(function()
    serverHop()
end)

MainKillNPC.MouseButton1Click:Connect(function()
    for i, v in ipairs(Players:GetPlayers()) do
        if v == player then
            Instance.new("Folder", v.Character).Name = "testt"
        end
    end
    task.wait(.5)
    for i, v in ipairs(workspace:GetChildren()) do
        if v:FindFirstChild("testt") == nil and v:FindFirstChild("Died") == nil and v:FindFirstChild("Humanoid") then
            local Magnitude = (player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if Magnitude <= 50 then
                v.Humanoid.RigType = "R6"
                v.Humanoid.Health = 0
                Instance.new("Folder", v).Name = "Died"
            end
        end
    end
end)

TasksInstanceButton.MouseButton1Click:Connect(function()
    instask()
end)

PlayerFullBright.MouseButton1Click:Connect(function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end)

-- Speed and Jump Inputs (smaller)
local SpeedInput = Instance.new("TextBox")
SpeedInput.Size = UDim2.new(0, 100, 0, 24) -- Smaller
SpeedInput.Position = UDim2.new(0, 15, 0, 243)
SpeedInput.BackgroundColor3 = Color3.fromRGB(50, 45, 75)
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.Text = "22"
SpeedInput.PlaceholderText = "Speed Value"
SpeedInput.TextSize = 11 -- Smaller
SpeedInput.Font = Enum.Font.Gotham
SpeedInput.BorderSizePixel = 0
SpeedInput.Parent = PlayerTab
local InputCorner1 = Instance.new("UICorner")
InputCorner1.CornerRadius = UDim.new(0, 5)
InputCorner1.Parent = SpeedInput

SpeedInput.FocusLost:Connect(function()
    speedValue = tonumber(SpeedInput.Text) or 22
    updateSpeed()
end)

local JumpInput = Instance.new("TextBox")
JumpInput.Size = UDim2.new(0, 100, 0, 24) -- Smaller
JumpInput.Position = UDim2.new(0, 15, 0, 281)
JumpInput.BackgroundColor3 = Color3.fromRGB(50, 45, 75)
JumpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpInput.Text = "50"
JumpInput.PlaceholderText = "Jump Value"
JumpInput.TextSize = 11 -- Smaller
JumpInput.Font = Enum.Font.Gotham
JumpInput.BorderSizePixel = 0
JumpInput.Parent = PlayerTab
local InputCorner2 = Instance.new("UICorner")
InputCorner2.CornerRadius = UDim.new(0, 5)
InputCorner2.Parent = JumpInput

JumpInput.FocusLost:Connect(function()
    jumpValue = tonumber(JumpInput.Text) or 50
    updateJump()
end)

-- Dragging functionality
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    ToggleButton.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Clean up ESP when players leave
Players.PlayerRemoving:Connect(function(leftPlayer)
    if leftPlayer.Character then
        for _, e in pairs(leftPlayer.Character:GetDescendants()) do
            if e.Name == "ESP" then
                e:Destroy()
            end
        end
    end
end)

-- Initialize features
player.CharacterAdded:Connect(function()
    wait(1)
    char, humPart = getCharacter()
    updateSpeed()
    updateJump()
    updateNoclip()
end)

showNotification("MooCore Loaded", "GUI Size: 400x250\nAll features integrated!", Color3.fromRGB(140, 80, 220))
