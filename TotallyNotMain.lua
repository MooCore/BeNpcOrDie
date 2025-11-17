local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local BASE_DOMAIN = "http://carminestoat.onpella.app"
local GENERATE_URL = BASE_DOMAIN .. "/generate?user="
local VALIDATE_URL = BASE_DOMAIN .. "/api/validate"
local CHECK_USER_URL = BASE_DOMAIN .. "/api/check_user"
local KEY_STATUS_URL = BASE_DOMAIN .. "/api/key_status"
local REMOTE_SCRIPT_URL = "https://raw.githubusercontent.com/MooCore/BeNpcOrDie/refs/heads/main/Main.lua"

local GUI_W = 400
local GUI_H = 320

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MooVerifyKeyGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainContainer = Instance.new("Frame")
mainContainer.Size = UDim2.new(0, GUI_W, 0, GUI_H)
mainContainer.Position = UDim2.new(0.5, -GUI_W/2, 0.5, -GUI_H/2)
mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
mainContainer.BackgroundColor3 = Color3.fromRGB(26, 34, 56)
mainContainer.BorderSizePixel = 0
mainContainer.Parent = screenGui

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 16)
containerCorner.Parent = mainContainer

local containerStroke = Instance.new("UIStroke")
containerStroke.Color = Color3.fromRGB(51, 65, 85)
containerStroke.Thickness = 2
containerStroke.Parent = mainContainer

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 60)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(26, 34, 56)
header.BorderSizePixel = 0
header.Parent = mainContainer

local headerAccent = Instance.new("Frame")
headerAccent.Size = UDim2.new(1, 0, 0, 4)
headerAccent.Position = UDim2.new(0, 0, 0, 0)
headerAccent.BackgroundColor3 = Color3.fromRGB(255, 122, 77)
headerAccent.BorderSizePixel = 0
headerAccent.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 20, 0, 4)
title.BackgroundTransparency = 1
title.Text = "MooVerify — Authentication"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(241, 245, 249)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.AnchorPoint = Vector2.new(0.5, 0.5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.fromRGB(148, 163, 184)
closeBtn.Parent = header

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -40, 1, -80)
content.Position = UDim2.new(0, 20, 0, 70)
content.BackgroundTransparency = 1
content.Parent = mainContainer

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 40)
statusLabel.Position = UDim2.new(0, 0, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Checking user status..."
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.TextColor3 = Color3.fromRGB(203, 213, 225)
statusLabel.TextWrapped = true
statusLabel.Parent = content

local usernameLabel = Instance.new("TextLabel")
usernameLabel.Size = UDim2.new(1, 0, 0, 25)
usernameLabel.Position = UDim2.new(0, 0, 0, 45)
usernameLabel.BackgroundTransparency = 1
usernameLabel.Text = "User: " .. player.Name
usernameLabel.Font = Enum.Font.GothamSemibold
usernameLabel.TextSize = 16
usernameLabel.TextColor3 = Color3.fromRGB(241, 245, 249)
usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
usernameLabel.Parent = content

local keyInputSection = Instance.new("Frame")
keyInputSection.Size = UDim2.new(1, 0, 0, 120)
keyInputSection.Position = UDim2.new(0, 0, 0, 80)
keyInputSection.BackgroundTransparency = 1
keyInputSection.Parent = content

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, 0, 0, 20)
keyLabel.Position = UDim2.new(0, 0, 0, 0)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "Enter your key:"
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextSize = 14
keyLabel.TextColor3 = Color3.fromRGB(203, 213, 225)
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = keyInputSection

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, 0, 0, 40)
keyBox.Position = UDim2.new(0, 0, 0, 25)
keyBox.PlaceholderText = "Paste your key from MooVerify website"
keyBox.ClearTextOnFocus = false
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 14
keyBox.TextColor3 = Color3.fromRGB(241, 245, 249)
keyBox.PlaceholderColor3 = Color3.fromRGB(100, 116, 139)
keyBox.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
keyBox.Parent = keyInputSection

local keyBoxCorner = Instance.new("UICorner")
keyBoxCorner.CornerRadius = UDim.new(0, 8)
keyBoxCorner.Parent = keyBox

local keyBoxStroke = Instance.new("UIStroke")
keyBoxStroke.Color = Color3.fromRGB(51, 65, 85)
keyBoxStroke.Thickness = 1
keyBoxStroke.Parent = keyBox

local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, 0, 0, 40)
buttonsFrame.Position = UDim2.new(0, 0, 0, 210)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = content

local validateBtn = Instance.new("TextButton")
validateBtn.Size = UDim2.new(0.6, 0, 1, 0)
validateBtn.Position = UDim2.new(0.2, 0, 0, 0)
validateBtn.AnchorPoint = Vector2.new(0.5, 0)
validateBtn.Text = "Validate & Load Script"
validateBtn.Font = Enum.Font.GothamBold
validateBtn.TextSize = 14
validateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
validateBtn.BackgroundColor3 = Color3.fromRGB(255, 122, 77)
validateBtn.Parent = buttonsFrame

local validateCorner = Instance.new("UICorner")
validateCorner.CornerRadius = UDim.new(0, 8)
validateCorner.Parent = validateBtn

local userGenerateUrl = GENERATE_URL .. player.Name
local copyUrlBtn = Instance.new("TextButton")
copyUrlBtn.Size = UDim2.new(0.8, 0, 0, 30)
copyUrlBtn.Position = UDim2.new(0.5, 0, 0, 260)
copyUrlBtn.AnchorPoint = Vector2.new(0.5, 0)
copyUrlBtn.Text = "Copy Website URL"
copyUrlBtn.Font = Enum.Font.Gotham
copyUrlBtn.TextSize = 12
copyUrlBtn.TextColor3 = Color3.fromRGB(203, 213, 225)
copyUrlBtn.BackgroundColor3 = Color3.fromRGB(51, 65, 85)
copyUrlBtn.Parent = content

local copyUrlCorner = Instance.new("UICorner")
copyUrlCorner.CornerRadius = UDim.new(0, 6)
copyUrlCorner.Parent = copyUrlBtn

local dragging = false
local dragInput
local dragStart
local startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	mainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainContainer.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateDrag(input)
	end
end)

local function animateButton(button)
	local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(button, tweenInfo, {Size = UDim2.new(0.58, 0, 0.95, 0)})
	tween:Play()
	
	task.wait(0.1)
	
	local tween2 = TweenService:Create(button, tweenInfo, {Size = UDim2.new(0.6, 0, 1, 0)})
	tween2:Play()
end

local function setStatus(text, color)
	statusLabel.Text = text
	if color then
		statusLabel.TextColor3 = color
	else
		statusLabel.TextColor3 = Color3.fromRGB(203, 213, 225)
	end
end

local function shorten(text, length)
	if not text then return "" end
	if #text > length then
		return text:sub(1, length - 3) .. "..."
	end
	return text
end

local function trySetClipboard(text)
	local success, error = pcall(function()
		setclipboard(text)
	end)
	return success, error
end

local function safeLoadAndRun(code)
	local success, result = pcall(function()
		if type(loadstring) == "function" then
			return loadstring(code)
		else
			return load(code)
		end
	end)
	
	if not success or type(result) ~= "function" then
		return false, tostring(result)
	end
	
	local success2, error = pcall(result)
	if not success2 then
		return false, tostring(error)
	end
	
	return true
end

local function destroyGui()
	if screenGui then
		screenGui:Destroy()
	end
end

local function checkUserVerified()
	if not HttpService.HttpEnabled then
		setStatus("HttpService disabled. Enable it in Game Settings.", Color3.fromRGB(239, 68, 68))
		return false
	end
	
	setStatus("Checking if user is verified...", Color3.fromRGB(96, 165, 250))
	
	local success, response = pcall(function()
		return HttpService:GetAsync(CHECK_USER_URL .. "?username=" .. player.Name)
	end)
	
	if not success then
		setStatus("Network error checking user status", Color3.fromRGB(239, 68, 68))
		return false
	end
	
	local decoded
	local decodeSuccess, result = pcall(function()
		return HttpService:JSONDecode(response)
	end)
	
	if decodeSuccess then
		decoded = result
	end
	
	if decoded and decoded.verified then
		setStatus("User already verified! Loading script...", Color3.fromRGB(16, 185, 129))
		
		local success2, scriptContent = pcall(function()
			return HttpService:GetAsync(REMOTE_SCRIPT_URL)
		end)
		
		if success2 then
			local loadSuccess, loadError = safeLoadAndRun(scriptContent)
			if loadSuccess then
				setStatus("Script loaded successfully! ✅", Color3.fromRGB(16, 185, 129))
				task.wait(1)
				destroyGui()
				return true
			else
				setStatus("Load error: " .. shorten(tostring(loadError), 60), Color3.fromRGB(239, 68, 68))
			end
		else
			setStatus("Failed to download script", Color3.fromRGB(239, 68, 68))
		end
	else
		setStatus("Enter your key to verify and load script", Color3.fromRGB(203, 213, 225))
	end
	
	return false
end

task.spawn(function()
	checkUserVerified()
end)

closeBtn.MouseButton1Click:Connect(function()
	screenGui.Enabled = false
end)

copyUrlBtn.MouseButton1Click:Connect(function()
	animateButton(copyUrlBtn)
	
	local success, error = trySetClipboard(userGenerateUrl)
	if success then
		setStatus("Website URL copied to clipboard! ✅", Color3.fromRGB(16, 185, 129))
	else
		keyBox.Text = userGenerateUrl
		pcall(function()
			keyBox:CaptureFocus()
			keyBox.SelectionStart = 1
			keyBox.CursorPosition = #userGenerateUrl + 1
		end)
		setStatus("URL filled in box - copy manually", Color3.fromRGB(245, 158, 11))
	end
end)

validateBtn.MouseButton1Click:Connect(function()
	animateButton(validateBtn)
	
	local key = keyBox.Text:gsub("^%s*(.-)%s*$", "%1")
	if key == "" then
		setStatus("Please enter a key first", Color3.fromRGB(239, 68, 68))
		return
	end
	
	task.spawn(function()
		if not HttpService.HttpEnabled then
			setStatus("HttpService disabled in Game Settings", Color3.fromRGB(239, 68, 68))
			return
		end
		
		setStatus("Validating key...", Color3.fromRGB(96, 165, 250))
		
		local success, response = pcall(function()
			return HttpService:PostAsync(VALIDATE_URL, HttpService:JSONEncode({
				key = key,
				username = player.Name
			}), Enum.HttpContentType.ApplicationJson)
		end)
		
		if not success then
			setStatus("Network error: " .. shorten(tostring(response), 60), Color3.fromRGB(239, 68, 68))
			return
		end
		
		local decoded
		local decodeSuccess, result = pcall(function()
			return HttpService:JSONDecode(response)
		end)
		if decodeSuccess then
			decoded = result
		end
		
		if not decoded or not decoded.valid then
			local reason = (decoded and decoded.reason) and tostring(decoded.reason) or "Invalid key"
			setStatus("Key invalid: " .. reason, Color3.fromRGB(239, 68, 68))
			return
		end
		
		setStatus("Key valid! Downloading script...", Color3.fromRGB(16, 185, 129))
		
		local success2, scriptContent = pcall(function()
			return HttpService:GetAsync(REMOTE_SCRIPT_URL)
		end)
		
		if not success2 then
			setStatus("Failed to download script: " .. shorten(tostring(scriptContent), 60), Color3.fromRGB(239, 68, 68))
			return
		end
		
		local loadSuccess, loadError = safeLoadAndRun(scriptContent)
		if loadSuccess then
			setStatus("Script loaded successfully! ✅", Color3.fromRGB(16, 185, 129))
			task.wait(1)
			destroyGui()
		else
			setStatus("Load error: " .. shorten(tostring(loadError), 60), Color3.fromRGB(239, 68, 68))
		end
	end)
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	
	if input.KeyCode == Enum.KeyCode.F9 then
		screenGui.Enabled = not screenGui.Enabled
		
		if screenGui.Enabled then
			task.spawn(checkUserVerified)
		end
	end
end)

setStatus("Press F9 to toggle this GUI. Get keys from website.", Color3.fromRGB(203, 213, 225))

print("MooVerify GUI loaded! Press F9 to open/close.")
