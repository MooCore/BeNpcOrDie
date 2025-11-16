-- Tasks Module
local Tasks = {}

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local autoTaskEnabled = false
local autoNearestTaskEnabled = false
local instanceTaskEnabled = false
local autoInstanceTaskEnabled = false

local taskThreads = {}

local function getCharacterRoot(character)
    if not character then
        return nil
    end
    return character:FindFirstChild("HumanoidRootPart")
end

local function resetVelocity(part)
    pcall(function()
        part.AssemblyLinearVelocity = Vector3.zero
        part.AssemblyAngularVelocity = Vector3.zero
    end)
end

local function findTasks()
    local tasks = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("task") or obj.Name:lower():find("quest")) then
            table.insert(tasks, obj)
        elseif obj:IsA("Part") and (obj.Name:lower():find("task") or obj.Name:lower():find("quest")) then
            table.insert(tasks, obj)
        end
    end
    return tasks
end

local function findNearestTask()
    local character = LocalPlayer.Character
    if not character then return nil end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local tasks = findTasks()
    local nearestTask = nil
    local nearestDistance = math.huge

    for _, task in pairs(tasks) do
        local taskPos = task:GetPivot().Position
        local distance = (root.Position - taskPos).Magnitude
        if distance < nearestDistance then
            nearestDistance = distance
            nearestTask = task
        end
    end

    return nearestTask
end

local function completeTask(task)
    if not task then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local taskPos = task:GetPivot().Position
    local elevated = taskPos + Vector3.new(0, 4, 0)
    
    root.CFrame = CFrame.new(elevated)
    resetVelocity(root)
    
    if task:FindFirstChild("ClickDetector") then
        fireclickdetector(task.ClickDetector)
    end
    
    for _, part in pairs(task:GetDescendants()) do
        if part:IsA("ClickDetector") then
            fireclickdetector(part)
        end
    end
    
    task.wait(1)
end

local function runAutoTask()
    while autoTaskEnabled do
        local tasks = findTasks()
        for _, task in pairs(tasks) do
            if not autoTaskEnabled then break end
            completeTask(task)
            task.wait(0.5)
        end
        task.wait(2)
    end
end

local function runAutoNearestTask()
    while autoNearestTaskEnabled do
        local nearestTask = findNearestTask()
        if nearestTask then
            completeTask(nearestTask)
        end
        task.wait(2)
    end
end

local function findInstances()
    local instances = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("instance") or obj.Name:lower():find("dungeon")) then
            table.insert(instances, obj)
        end
    end
    return instances
end

local function runInstanceTask()
    if not instanceTaskEnabled then return end
    
    local instances = findInstances()
    for _, instance in pairs(instances) do
        if not instanceTaskEnabled then break end
        
        local character = LocalPlayer.Character
        if not character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local instancePos = instance:GetPivot().Position
        local elevated = instancePos + Vector3.new(0, 4, 0)
        
        root.CFrame = CFrame.new(elevated)
        resetVelocity(root)
        task.wait(2)
        
        local tasks = findTasks()
        for _, task in pairs(tasks) do
            if not instanceTaskEnabled then break end
            completeTask(task)
            task.wait(1)
        end
    end
end

local function runAutoInstanceTask()
    while autoInstanceTaskEnabled do
        runInstanceTask()
        task.wait(3)
    end
end

function Tasks.setAutoTask(state)
    autoTaskEnabled = state
    if state then
        taskThreads.autoTask = task.spawn(runAutoTask)
    else
        if taskThreads.autoTask then
            task.cancel(taskThreads.autoTask)
            taskThreads.autoTask = nil
        end
    end
end

function Tasks.setAutoNearestTask(state)
    autoNearestTaskEnabled = state
    if state then
        taskThreads.autoNearestTask = task.spawn(runAutoNearestTask)
    else
        if taskThreads.autoNearestTask then
            task.cancel(taskThreads.autoNearestTask)
            taskThreads.autoNearestTask = nil
        end
    end
end

function Tasks.setInstanceTask(state)
    instanceTaskEnabled = state
    if state then
        taskThreads.instanceTask = task.spawn(runInstanceTask)
    else
        if taskThreads.instanceTask then
            task.cancel(taskThreads.instanceTask)
            taskThreads.instanceTask = nil
        end
    end
end

function Tasks.setAutoInstanceTask(state)
    autoInstanceTaskEnabled = state
    if state then
        taskThreads.autoInstanceTask = task.spawn(runAutoInstanceTask)
    else
        if taskThreads.autoInstanceTask then
            task.cancel(taskThreads.autoInstanceTask)
            taskThreads.autoInstanceTask = nil
        end
    end
end

return Tasks
