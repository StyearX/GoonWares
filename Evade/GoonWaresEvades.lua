Workspace = game:GetService("Workspace")
RunService = game:GetService("RunService")
Players = game:GetService("Players")
Lighting = game:GetService('Lighting')
StarterGui = game:GetService("StarterGui")
ReplicatedStorage = game:GetService('ReplicatedStorage')
Camera = Workspace.CurrentCamera
LocalPlayer = Players.LocalPlayer
UserInputService = game:GetService("UserInputService")
TweenService = game:GetService("TweenService")
PathfindingService = game:GetService("PathfindingService")
CAS = game:GetService("ContextActionService")

local Fluent = loadstring(game:HttpGet("https://github.com/StyearX/Fluent-modded/releases/download/1.5.4/FluentPro"))()

if getgenv().GoonWaresExecuted then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "WARNING!",
        Text = "Script Is Already Loaded, rejoin if you want to re-execute.",
        Duration = 8,
    })
    return
end
getgenv().GoonWaresExecuted = true

isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled and not UserInputService.KeyboardEnabled

function Notify(title, content, ntype, icon, duration)
    Fluent:Notify({ Title = title, Content = content, Type = ntype or "Info", Icon = icon, Duration = duration or 3 })
end

task.spawn(function()
    local ExecutorName, ExecutorVersion = "Unknown", ""
    local Success = pcall(function()
        if identifyexecutor then
            ExecutorName, ExecutorVersion = identifyexecutor()
        elseif getexecutorname then
            ExecutorName = getexecutorname()
        end
    end)

    Notify(
        "GoonWares",
        string.format("Player: %s | Executor: %s %s", LocalPlayer.Name, ExecutorName or "Unknown", ExecutorVersion or ""),
        "Info",
        nil,
        6
    )
end)

Fluent:RegisterCustomTheme("Azure", {
    Accent = Color3.fromRGB(50, 150, 255),
    AcrylicMain = Color3.fromRGB(20, 38, 65),
    AcrylicBorder = Color3.fromRGB(90, 160, 240),
    AcrylicGradient = ColorSequence.new(Color3.fromRGB(55, 90, 150), Color3.fromRGB(15, 28, 50)),
    AcrylicNoise = 0.90,
    TitleBarLine = Color3.fromRGB(110, 200, 255),
    Tab = Color3.fromRGB(30, 52, 85),
    Element = Color3.fromRGB(45, 75, 120),
    ElementBorder = Color3.fromRGB(130, 200, 255),
    InElementBorder = Color3.fromRGB(100, 170, 240),
    ElementTransparency = 0.92,
    ToggleSlider = Color3.fromRGB(200, 235, 255),
    ToggleToggled = Color3.fromRGB(50, 150, 255),
    SliderRail = Color3.fromRGB(75, 120, 180),
    DropdownFrame = Color3.fromRGB(25, 45, 75),
    DropdownHolder = Color3.fromRGB(18, 32, 60),
    DropdownBorder = Color3.fromRGB(100, 170, 240),
    DropdownOption = Color3.fromRGB(42, 70, 112),
    Keybind = Color3.fromRGB(25, 45, 75),
    Input = Color3.fromRGB(25, 45, 75),
    InputFocused = Color3.fromRGB(52, 85, 135),
    InputIndicator = Color3.fromRGB(85, 180, 255),
    Dialog = Color3.fromRGB(20, 38, 65),
    DialogHolder = Color3.fromRGB(15, 28, 50),
    DialogHolderLine = Color3.fromRGB(110, 190, 255),
    DialogButton = Color3.fromRGB(45, 75, 120),
    DialogButtonBorder = Color3.fromRGB(110, 190, 255),
    DialogBorder = Color3.fromRGB(100, 170, 240),
    DialogInput = Color3.fromRGB(25, 45, 75),
    DialogInputLine = Color3.fromRGB(85, 180, 255),
    Text = Color3.fromRGB(250, 252, 255),
    SubText = Color3.fromRGB(200, 225, 250),
    Hover = Color3.fromRGB(255, 255, 255),
    HoverChange = 0.08,
    Background = "https://raw.githubusercontent.com/StyearX/Script/main/not%20a%20luau/Shimoneta%20-%20Nishikinomiya%20Anna%20Render%201.png",
    BackgroundTransparency = 0,
    ViewportBackground = Color3.fromRGB(15, 28, 50),
    ViewportBackgroundImages = true,
    DropdownOutsideWindowBackground = Color3.fromRGB(18, 32, 60),
    DropdownOutsideWindowBackgroundImages = true,
    ShineEnabled = true,
    Shine = {
        Speed = 0.35,
        RotationSpeed = 15,
        ColorSequence = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 150, 255)),
            ColorSequenceKeypoint.new(0.2, Color3.fromRGB(100, 200, 255)),
            ColorSequenceKeypoint.new(0.4, Color3.fromRGB(160, 230, 255)),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(220, 250, 255)),
            ColorSequenceKeypoint.new(0.8, Color3.fromRGB(180, 220, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 150, 255))
        })
    },
    StrokeShine = true,
    StrokeDark = Color3.fromRGB(65, 110, 170),
    ButtonGradient = {
        Background = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 160, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 85, 180))
        }),
        Stroke = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 235, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(110, 200, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 170, 240))
        })
    }
})

Fluent:RegisterCustomTheme("Scarlet", {
    Accent = Color3.fromRGB(255, 50, 80),
    AcrylicMain = Color3.fromRGB(45, 18, 28),
    AcrylicBorder = Color3.fromRGB(220, 70, 100),
    AcrylicGradient = ColorSequence.new(Color3.fromRGB(75, 30, 45), Color3.fromRGB(30, 10, 18)),
    AcrylicNoise = 0.90,
    TitleBarLine = Color3.fromRGB(255, 80, 120),
    Tab = Color3.fromRGB(55, 22, 35),
    Element = Color3.fromRGB(60, 28, 42),
    ElementBorder = Color3.fromRGB(255, 90, 130),
    InElementBorder = Color3.fromRGB(200, 80, 115),
    ElementTransparency = 0.92,
    ToggleSlider = Color3.fromRGB(255, 210, 225),
    ToggleToggled = Color3.fromRGB(255, 60, 95),
    SliderRail = Color3.fromRGB(120, 50, 70),
    DropdownFrame = Color3.fromRGB(50, 20, 32),
    DropdownHolder = Color3.fromRGB(38, 14, 24),
    DropdownBorder = Color3.fromRGB(190, 75, 110),
    DropdownOption = Color3.fromRGB(58, 26, 40),
    Keybind = Color3.fromRGB(50, 20, 32),
    Input = Color3.fromRGB(50, 20, 32),
    InputFocused = Color3.fromRGB(72, 35, 52),
    InputIndicator = Color3.fromRGB(255, 75, 110),
    Dialog = Color3.fromRGB(45, 18, 28),
    DialogHolder = Color3.fromRGB(35, 12, 22),
    DialogHolderLine = Color3.fromRGB(210, 80, 120),
    DialogButton = Color3.fromRGB(60, 28, 42),
    DialogButtonBorder = Color3.fromRGB(210, 80, 120),
    DialogBorder = Color3.fromRGB(190, 75, 110),
    DialogInput = Color3.fromRGB(50, 20, 32),
    DialogInputLine = Color3.fromRGB(255, 75, 110),
    Text = Color3.fromRGB(255, 245, 250),
    SubText = Color3.fromRGB(235, 200, 215),
    Hover = Color3.fromRGB(255, 255, 255),
    HoverChange = 0.08,
    Background = "rbxassetid://82815674474603",
    BackgroundTransparency = 0.12,
    ViewportBackground = Color3.fromRGB(30, 10, 18),
    ViewportBackgroundImages = true,
    DropdownOutsideWindowBackground = Color3.fromRGB(35, 12, 22),
    DropdownOutsideWindowBackgroundImages = true,
    ShineEnabled = true,
    Shine = {
        Speed = 0.35,
        RotationSpeed = 15,
        ColorSequence = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 80)),
            ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 120, 100)),
            ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 200, 140)),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 255, 200)),
            ColorSequenceKeypoint.new(0.8, Color3.fromRGB(255, 160, 180)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 80))
        })
    },
    StrokeShine = true,
    StrokeDark = Color3.fromRGB(110, 40, 60),
    ButtonGradient = {
        Background = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 95)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 30, 55))
        }),
        Stroke = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 225)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 110, 150)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 80, 120))
        })
    }
})

local function getPlayerLevel()
    local player = game:GetService("Players").LocalPlayer
    local lv = player:GetAttribute("Level") or player:GetAttribute("level")
        or player:GetAttribute("LVL") or player:GetAttribute("PlayerLevel")
    if lv then return tostring(lv) end
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        local node = ls:FindFirstChild("Level") or ls:FindFirstChild("level")
            or ls:FindFirstChild("LVL") or ls:FindFirstChild("XP")
        if node then return tostring(node.Value) end
    end
    return "?"
end

Window = Fluent:CreateWindow({
    Title = "GoonWares",
    SubTitle = "Made by: StyearX",
    TabWidth = isMobile and 130 or 150,
    Tags = {
        { Text = "Legacy Evade", Color = Color3.fromRGB(211, 15, 40) },
        { Text = "Evade", Color = Color3.fromRGB(180, 10, 20) },
    },
    Version = "Version 1.5",
    Acrylic = true,
    Size = isMobile and UDim2.fromOffset(480, 490) or UDim2.fromOffset(580, 560),
    Theme = "Crimson",
    Search = true,
    SearchInHeader = true,
    Icons = "rbxassetid://139095000385640",
    TitleIcon = "rbxassetid://139379979502671",
    UserInfoTop = true,
    UserInfoTitle   = "level " .. getPlayerLevel(),
    UserInfoSubtitle = LocalPlayer.DisplayName,
    MinimizeKey = Enum.KeyCode.LeftControl,
})

Tabs = { 
    Main = Window:AddTab({ Title = "|  Main", Icon = "rbxassetid://7733960981" }),
    Combat = Window:AddTab({ Title = "|  Combat", Icon = "shield" }),
    Misc = Window:AddTab({ Title = "|  Misc", Icon = "rbxassetid://7734068321" }),
    Visual = Window:AddTab({ Title = "|  Visual", Icon = "rbxassetid://10709819149" }),
    Info = Window:AddTab({ Title = "|  Info", Icon = "rbxassetid://10723415903" }),
    Settings = Window:AddTab({ Title = "|  Settings", Icon = "rbxassetid://7734052335" }),
    Extension = Window:AddTab({ Title = "|  Extension", Icon = "rbxassetid://10734930886" })
}

openshit = Instance.new("ScreenGui")
openshit.Name = "openshit"
openshit.Parent = LocalPlayer:WaitForChild("PlayerGui")
openshit.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
openshit.ResetOnSpawn = false

mainopen = Instance.new("TextButton")
mainopen.Name = "mainopen"
mainopen.Parent = openshit
mainopen.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainopen.BackgroundTransparency = 1
mainopen.Position = UDim2.new(0.101969875, 0, 0.110441767, 0)
mainopen.Size = UDim2.new(0, 64, 0, 42)
mainopen.Text = ""
mainopen.Visible = true

mainopens = Instance.new("UICorner")
mainopens.Parent = mainopen

SizeBackMulti = 0.1
AssetsIcon = "rbxassetid://139095000385640"
AssetsBackground = "rbxassetid://109694296016043"

backgroundImage = Instance.new("ImageLabel")
backgroundImage.Name = "RotatingBackground"
backgroundImage.Parent = mainopen
backgroundImage.Size = UDim2.new(2.3 + SizeBackMulti, 0, 2.3 + SizeBackMulti, 0)
backgroundImage.Position = UDim2.new(0.5, 0, 0.5, 0)
backgroundImage.AnchorPoint = Vector2.new(0.5, 0.5)
backgroundImage.BackgroundTransparency = 1
backgroundImage.Image = AssetsBackground
backgroundImage.SizeConstraint = Enum.SizeConstraint.RelativeXX
backgroundImage.ZIndex = 0

frontImage = Instance.new("ImageLabel")
frontImage.Name = "StaticIcon"
frontImage.Parent = mainopen
frontImage.Size = UDim2.new(0.8, 0, 1.2, 0)
frontImage.Position = UDim2.new(0.5, 0, 0.5, 0)
frontImage.AnchorPoint = Vector2.new(0.5, 0.5)
frontImage.BackgroundTransparency = 1
frontImage.Image = AssetsIcon
frontImage.ZIndex = 1

frontCorner = Instance.new("UICorner")
frontCorner.CornerRadius = UDim.new(1, 0)
frontCorner.Parent = frontImage

local rotation = 0
local speed = 90 
local lastTime = tick()

task.spawn(function()
	while true do
		local now = tick()
		local delta = now - lastTime
		lastTime = now
		
		rotation = (rotation + speed * delta) % 360
		backgroundImage.Rotation = rotation

		task.wait()
	end
end)

local function MakeDraggable(topbarobject, object, locked)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition

    local Holding = false
    local HoldTime = 1.0
    local MoveCancelThreshold = 6
    local HoldToken = 0

    object:SetAttribute("Locked", locked or false)

    local function Update(input)
        if object:GetAttribute("Locked") then return end
        local delta = input.Position - DragStart
        object.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + delta.Y
        )
    end

    local function ToggleLock()
        local newState = not object:GetAttribute("Locked")
        object:SetAttribute("Locked", newState)

        Fluent:Notify({
            Title = newState and "Button Locked" or "Button Unlocked",
            Content = newState and "This button is now locked in place." or "This button can now be moved.",
            Duration = 2
        })
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        Dragging = not object:GetAttribute("Locked")
        Holding = true
        DragStart = input.Position
        StartPosition = object.Position

        HoldToken += 1
        local token = HoldToken

        task.delay(HoldTime, function()
            if Holding and token == HoldToken then
                ToggleLock()
            end
        end)

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
                Holding = false
            end
        end)
    end)

    topbarobject.InputChanged:Connect(function(input)
        if not DragStart then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            if (input.Position - DragStart).Magnitude > MoveCancelThreshold then
                Holding = false
            end
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

MakeDraggable(mainopen, mainopen, false)

local function playSound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

mainopen.MouseButton1Click:Connect(function()
    local sounds = { "7127123605", "137566474343039", "438666542", "257001341", "257000833", "7127123554", "131607746976396", "97325669841459", "109312518223078" }
    playSound(sounds[math.random(#sounds)])
    Window:Minimize()

    local function smoothSpeed(target, duration)
        local start = speed
        local steps = 30
        for i = 1, steps do
            speed = start + (target - start) * (i / steps)
            task.wait(duration / steps)
        end
        speed = target
    end
    
    smoothSpeed(360, 0.4)
    task.wait(0.5)
    smoothSpeed(180, 0.4)
    task.wait(0.3)
    smoothSpeed(90, 0.4)
end)

function UniverseServerTools(Tabs)
    HttpService = game:GetService("HttpService")
    TeleportService = game:GetService("TeleportService")
    Players = game:GetService("Players")
    MarketplaceService = game:GetService("MarketplaceService")
    Stats = game:GetService("Stats")
    RunService = game:GetService("RunService")
    Workspace = game:GetService("Workspace")
    UserInputService = game:GetService("UserInputService")
    jobId = game.JobId
    placeId = game.PlaceId
    LocalPlayer = Players.LocalPlayer
    StartTime = tick()

    ENGINE_TARGET_MB = 3000
    FrameCount = 0
    LastTime = tick()
    CurrentFPS = 0

    RunService.RenderStepped:Connect(function()
        FrameCount = FrameCount + 1
        local CurrentTime = tick()
        if CurrentTime - LastTime >= 1 then
            CurrentFPS = FrameCount
            FrameCount = 0
            LastTime = CurrentTime
        end
    end)

    function format(Int)
        return string.format("%02i", Int)
    end

    function convertToDetailedTime(Seconds, Milliseconds)
        local years = math.floor(Seconds / 31536000)
        Seconds = Seconds % 31536000
        
        local months = math.floor(Seconds / 2592000)
        Seconds = Seconds % 2592000
        
        local weeks = math.floor(Seconds / 604800)
        Seconds = Seconds % 604800
        
        local days = math.floor(Seconds / 86400)
        Seconds = Seconds % 86400
        
        local hours = math.floor(Seconds / 3600)
        Seconds = Seconds % 3600
        
        local minutes = math.floor(Seconds / 60)
        local seconds = Seconds % 60
        
        return {
            Years = years,
            Months = months,
            Weeks = weeks,
            Days = days,
            Hours = hours,
            Minutes = minutes,
            Seconds = seconds,
            Milliseconds = Milliseconds or 0
        }
    end

    function GetServerUptimeString()
        local totalSeconds = time()
        local milliseconds = math.floor((totalSeconds - math.floor(totalSeconds)) * 1000)
        local uptime = convertToDetailedTime(math.floor(totalSeconds), milliseconds)
        return string.format(
            "%dY %dMth %dW %dD %dH %dMin %dSec %dMS",
            uptime.Years, uptime.Months, uptime.Weeks, uptime.Days, 
            uptime.Hours, uptime.Minutes, uptime.Seconds, uptime.Milliseconds
        )
    end

    function GetLastJoinedString()
        local currentTimeSeconds = os.time()
        local joinedTimeSeconds = currentTimeSeconds - math.floor(time())
        local joinedTime = os.date("*t", joinedTimeSeconds)
        
        local hour = joinedTime.hour
        local minute = joinedTime.min
        local second = joinedTime.sec
        
        local ampm = hour >= 12 and "PM" or "AM"
        local hour12 = hour % 12
        if hour12 == 0 then hour12 = 12 end
        
        local millisecond = math.floor((time() - math.floor(time())) * 1000)
        
        local monthNames = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }
        local monthName = monthNames[joinedTime.month]
        
        return string.format("%02d:%02d:%02d.%03d %s - %s %d, %d",
            hour12, minute, second, millisecond, ampm, monthName, joinedTime.day, joinedTime.year)
    end

    function GetScriptRuntime()
        local elapsed = tick() - StartTime
        local milliseconds = math.floor((elapsed - math.floor(elapsed)) * 1000)
        local runtime = convertToDetailedTime(math.floor(elapsed), milliseconds)
        return string.format(
            "%dY %dMth %dW %dD %dH %dMin %dSec %dMS",
            runtime.Years, runtime.Months, runtime.Weeks, runtime.Days, 
            runtime.Hours, runtime.Minutes, runtime.Seconds, runtime.Milliseconds
        )
    end

    function GetExecutedSince()
        local executedTime = os.date("%I:%M:%S %p", StartTime)
        return executedTime
    end

    function GetOSClock()
        local now = os.date("*t")
        local hour = now.hour
        local minute = now.min
        local second = now.sec
        local ampm = hour >= 12 and "PM" or "AM"
        local hour12 = hour % 12
        if hour12 == 0 then hour12 = 12 end
        return string.format("%02d:%02d:%02d %s", hour12, minute, second, ampm)
    end

    function GetCalendarDate()
        local now = os.date("*t")
        local monthNames = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
        local suffix = "th"
        if now.day == 1 or now.day == 21 or now.day == 31 then suffix = "st"
        elseif now.day == 2 or now.day == 22 then suffix = "nd"
        elseif now.day == 3 or now.day == 23 then suffix = "rd" end
        return string.format("%s %d%s, %d", monthNames[now.month], now.day, suffix, now.year)
    end

    function GetGPUInfo()
        local gpuTime = Stats.RenderGPUFrameTime
        local gpuMs = string.format("%.2f", gpuTime * 1000)
        return string.format("%s ms", gpuMs)
    end

    function GetCPUInfo()
        local cpuTime = Stats.RenderCPUFrameTime
        local cpuMs = string.format("%.2f", cpuTime * 1000)
        return string.format("%s ms", cpuMs)
    end

    function GetRAMInfo()
        local currentRAM = Stats:GetTotalMemoryUsageMb()
        local usagePercent = math.floor((currentRAM / ENGINE_TARGET_MB) * 100)
        return string.format("%.2f MB / %d MB (%d%%)", currentRAM, ENGINE_TARGET_MB, usagePercent)
    end

    function GetNetworkSent()
        local sentRate = Stats.DataSendKbps
        return string.format("%.2f KB/s", sentRate)
    end

    function GetNetworkReceived()
        local receivedRate = Stats.DataReceiveKbps
        return string.format("%.2f KB/s", receivedRate)
    end

    function GetPing()
        local ping = math.clamp(Stats.Network.ServerStatsItem["Data Ping"]:GetValue(), 10, 700)
        return string.format("%d ms", math.floor(ping))
    end

    function GetFPS()
        return string.format("%d fps", CurrentFPS)
    end

    function LaunchID()
        return string.format("roblox://placeId=%d&gameInstanceId=%s", placeId, jobId)
    end

    function getServerLink()
        return string.format("darahub.pages.dev/roblox-launch.html?placeId=%d&gameInstanceId=%s", placeId, jobId)
    end

    function rejoinServer()
        local success, err = pcall(function()
            local currentJobId = game.JobId
            local cursor = ""
            local bool = false
            
            repeat
                local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"
                if cursor ~= "" then
                    url = url .. "&cursor=" .. cursor
                end
                
                local success, result = pcall(function()
                    return game:HttpGet(url)
                end)
                
                if not success then
                    return
                end
                
                local data = HttpService:JSONDecode(result)
                
                if data and data.data then
                    for _, server in ipairs(data.data) do
                        if server.id == currentJobId then
                            bool = true
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
                            return
                        end
                    end
                end
                
                cursor = data and data.nextPageCursor or ""
            until cursor == ""
            
            if not bool then
                TeleportService:Teleport(game.PlaceId)
            end
        end)
        
        if not success then
            Fluent:Notify({ Title = "Rejoin Error", Content = "Failed to rejoin: " .. tostring(err), Duration = 3 })
        end
    end

    TotalFriends = 0
    OnlineFriends = 0
    OfflineFriends = 0

    function UpdateFriendData()
        pcall(function()
            local total = 0
            local online = 0
            
            local friendsList = Players:GetFriendsAsync(LocalPlayer.UserId)
            while true do
                for _, data in friendsList:GetCurrentPage() do
                    total = total + 1
                end
                if friendsList.IsFinished then
                    break
                else
                    friendsList:AdvanceToNextPageAsync()
                end
            end
            
            local onlineFriendsData = LocalPlayer:GetFriendsOnline()
            for _ in pairs(onlineFriendsData) do
                online = online + 1
            end
            
            TotalFriends = total
            OnlineFriends = online
            OfflineFriends = total - online
        end)
    end

    task.spawn(UpdateFriendData)

    task.spawn(function()
        while true do
            task.wait(30)
            UpdateFriendData()
        end
    end)

    local SecServerInfo = Tabs.Main:AddSection("Server Information", "solar/widget-2-bold")
    SecServerInfo:AddDivider()

    ServerInfoParagraph = SecServerInfo:AddParagraph({
        Title = "In Server For",
        Content = GetServerUptimeString()
    })

    task.spawn(function()
        while wait() do
            pcall(function()
                ServerInfoParagraph:SetDesc(GetServerUptimeString())
            end)
        end
    end)

    SecServerInfo:AddParagraph({
        Title = "Server Started",
        Content = GetLastJoinedString()
    })

    placeName = "Unknown"
    pcall(function()
        local productInfo = MarketplaceService:GetProductInfo(placeId)
        if productInfo and productInfo.Name then
            placeName = productInfo.Name
        end
    end)

    SecServerInfo:AddParagraph({
        Title = "Game",
        Content = placeName
    })

    numPlayers = #Players:GetPlayers()
    maxPlayers = Players.MaxPlayers
    CurrentPlayersParagraph = SecServerInfo:AddParagraph({
        Title = "Current Players",
        Content = numPlayers .. " / " .. maxPlayers
    })

    task.spawn(function()
        while wait() do
            pcall(function()
                CurrentPlayersParagraph:SetDesc(#Players:GetPlayers() .. " / " .. maxPlayers)
            end)
        end
    end)

    SecServerInfo:AddParagraph({
        Title = "Server ID",
        Content = string.sub(jobId, 1, 30) .. "..."
    })


    Tabs.Main:AddSpace({ Height = 20 })
    local SecClientInfo = Tabs.Main:AddSection("Client Information", "solar/widget-2-bold")
    SecClientInfo:AddDivider()

    ScriptRuntimeParagraph = SecClientInfo:AddParagraph({
        Title = "Script Running For",
        Content = GetScriptRuntime()
    })

    task.spawn(function()
        while wait() do
            pcall(function()
                ScriptRuntimeParagraph:SetDesc(GetScriptRuntime())
            end)
        end
    end)

    SecClientInfo:AddParagraph({
        Title = "Executed Since",
        Content = GetExecutedSince()
    })


    Tabs.Main:AddSpace({ Height = 20 })
    local SecSystemInfo = Tabs.Main:AddSection("System Information", "solar/widget-2-bold")
    SecSystemInfo:AddDivider()

    OSClockParagraph = SecSystemInfo:AddParagraph({
        Title = "OS Clock",
        Content = GetOSClock()
    })

    task.spawn(function()
        while wait() do
            pcall(function()
                OSClockParagraph:SetDesc(GetOSClock())
            end)
        end
    end)

    CalendarParagraph = SecSystemInfo:AddParagraph({
        Title = "Calendar",
        Content = GetCalendarDate()
    })

    task.spawn(function()
        while true do
            task.wait(60)
            pcall(function()
                CalendarParagraph:SetDesc(GetCalendarDate())
            end)
        end
    end)

    GPUParagraph = SecSystemInfo:AddParagraph({
        Title = "GPU",
        Content = GetGPUInfo()
    })

    CPUParagraph = SecSystemInfo:AddParagraph({
        Title = "CPU",
        Content = GetCPUInfo()
    })

    RAMParagraph = SecSystemInfo:AddParagraph({
        Title = "RAM",
        Content = GetRAMInfo()
    })

    SentParagraph = SecSystemInfo:AddParagraph({
        Title = "Sent",
        Content = GetNetworkSent()
    })

    ReceivedParagraph = SecSystemInfo:AddParagraph({
        Title = "Received",
        Content = GetNetworkReceived()
    })

    PingParagraph = SecSystemInfo:AddParagraph({
        Title = "Ping",
        Content = GetPing()
    })

    FPSParagraph = SecSystemInfo:AddParagraph({
        Title = "FPS",
        Content = GetFPS()
    })

    task.spawn(function()
        while true do
            task.wait(0.2)
            pcall(function()
                GPUParagraph:SetDesc(GetGPUInfo())
                CPUParagraph:SetDesc(GetCPUInfo())
                RAMParagraph:SetDesc(GetRAMInfo())
                SentParagraph:SetDesc(GetNetworkSent())
                ReceivedParagraph:SetDesc(GetNetworkReceived())
                PingParagraph:SetDesc(GetPing())
                FPSParagraph:SetDesc(GetFPS())
            end)
        end
    end)


    Tabs.Main:AddSpace({ Height = 20 })
    local SecPlayerInfo = Tabs.Main:AddSection("Player Information", "solar/widget-2-bold")
    SecPlayerInfo:AddDivider()

    SecPlayerInfo:AddParagraph({
        Title = "Username",
        Content = LocalPlayer.Name
    })

    SecPlayerInfo:AddParagraph({
        Title = "Display Name",
        Content = LocalPlayer.DisplayName
    })

    SecPlayerInfo:AddParagraph({
        Title = "User ID",
        Content = tostring(LocalPlayer.UserId)
    })

    accountCreationString = "Unknown"
    pcall(function()
        local accountAge = LocalPlayer.AccountAge
        if accountAge then
            local creationTime = os.time() - (accountAge * 86400)
            accountCreationString = os.date("%B %d, %Y", creationTime)
        end
    end)

    SecPlayerInfo:AddParagraph({
        Title = "Account Created",
        Content = accountCreationString
    })


    Tabs.Main:AddSpace({ Height = 20 })
    local SecFriendsData = Tabs.Main:AddSection("Friends Data", "solar/widget-2-bold")
    SecFriendsData:AddDivider()

    FriendsOnlineParagraph = SecFriendsData:AddParagraph({
        Title = "Online Friends",
        Content = "0"
    })

    FriendsOfflineParagraph = SecFriendsData:AddParagraph({
        Title = "Offline Friends",
        Content = "0"
    })

    FriendsTotalParagraph = SecFriendsData:AddParagraph({
        Title = "Total Friends",
        Content = "0"
    })

    task.spawn(function()
        while true do
            task.wait(30)
            pcall(function()
                UpdateFriendData()
                FriendsOnlineParagraph:SetDesc(tostring(OnlineFriends))
                FriendsOfflineParagraph:SetDesc(tostring(OfflineFriends))
                FriendsTotalParagraph:SetDesc(tostring(TotalFriends))
            end)
        end
    end)

    pcall(function()
        UpdateFriendData()
        FriendsOnlineParagraph:SetDesc(tostring(OnlineFriends))
        FriendsOfflineParagraph:SetDesc(tostring(OfflineFriends))
        FriendsTotalParagraph:SetDesc(tostring(TotalFriends))
    end)


    Tabs.Main:AddSpace({ Height = 20 })
    local SecServerTools = Tabs.Main:AddSection("Server Tools", "solar/widget-2-bold")
    SecServerTools:AddDivider()

    SecServerTools:AddButton({
        Title = "Rejoin",
        Description = "Rejoin the current server",
        Icon = "refresh-cw",
        Callback = function()
            Window:Dialog({
                Title = "Rejoin",
                Content = "Are you sure you want to rejoin the current server?",
                Buttons = {
                    { Title = "Yes", Callback = function() rejoinServer() end },
                    { Title = "No" },
                },
            })
        end
    })

    SecServerTools:AddButton({
        Title = "Copy Server Launch ID",
        Description = "Copy the current server's Launch ID",
        Icon = "link",
        Callback = function()
            pcall(function()
                if setclipboard then setclipboard(LaunchID()) end
            end)
            Fluent:Notify({ Icon = "link", Title = "Copied", Content = "Server Launch ID copied", Duration = 2 })
        end
    })

    SecServerTools:AddButton({
        Title = "Copy Server Link",
        Description = "Copy the current server's join link",
        Icon = "link",
        Callback = function()
            pcall(function()
                if setclipboard then setclipboard(getServerLink()) end
            end)
            Fluent:Notify({ Icon = "link", Title = "Copied", Content = "Server link copied", Duration = 2 })
        end
    })

end
UniverseServerTools(Tabs)


Options = Fluent.Options

function GetAutoDuration()
    local dt = RunService.RenderStepped:Wait()
    local fps = 1 / dt

    local duration = 60 / math.clamp(fps, 5, 60)
    return math.clamp(duration, 1, 6)
end

Duration = GetAutoDuration()

function MakeDraggable(topbarobject, object, locked)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition

    local Holding = false
    local HoldTime = 1.0
    local MoveCancelThreshold = 6
    local HoldToken = 0

    object:SetAttribute("Locked", locked or false)

    local function Update(input)
        if object:GetAttribute("Locked") then return end
        local delta = input.Position - DragStart
        object.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + delta.Y
        )
    end

    local function ToggleLock()
        local newState = not object:GetAttribute("Locked")
        object:SetAttribute("Locked", newState)

        Fluent:Notify({
            Title = newState and "Button Locked" or "Button Unlocked",
            Content = newState and "This button is now locked in place." or "This button can now be moved.",
            Duration = 2
        })
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        Dragging = not object:GetAttribute("Locked")
        Holding = true
        DragStart = input.Position
        StartPosition = object.Position

        HoldToken += 1
        local token = HoldToken

        task.delay(HoldTime, function()
            if Holding and token == HoldToken then
                ToggleLock()
            end
        end)

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
                Holding = false
            end
        end)
    end)

    topbarobject.InputChanged:Connect(function(input)
        if not DragStart then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            if (input.Position - DragStart).Magnitude > MoveCancelThreshold then
                Holding = false
            end
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end



Stats = game:GetService("Stats")
RunService = game:GetService("RunService")

startTime = tick()
FPS_Data = {
    GUI = nil,
    Connection = nil
}

function ToggleFPSCounter(state)
    if not state then
        if FPS_Data.GUI then
            FPS_Data.GUI:Destroy()
            FPS_Data.GUI = nil
        end
        if FPS_Data.Connection then
            FPS_Data.Connection:Disconnect()
            FPS_Data.Connection = nil
        end
        return
    end

    if state and not FPS_Data.GUI then
        local fpsCounter = Instance.new("ScreenGui")
        fpsCounter.Name = "FPSCounter"
        fpsCounter.Parent = game.CoreGui
        fpsCounter.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        fpsCounter.ResetOnSpawn = false
        FPS_Data.GUI = fpsCounter

        local frame = Instance.new("Frame")
        frame.Parent = fpsCounter
        frame.Size = UDim2.new(0, 180, 0, 80)
        frame.Position = UDim2.new(0, 300, 0, 10)
        frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        frame.BackgroundTransparency = 0.7

        local corner = Instance.new("UICorner", frame)
        corner.CornerRadius = UDim.new(0, 15)

        local gradient = Instance.new("UIGradient", frame)
        gradient.Color = (Fluent:GetButtonGradient() or Fluent.ButtonGradients).Background

        local uiStroke = Instance.new("UIStroke", frame)
        uiStroke.Thickness = 2
        uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local gradientstroke = Instance.new("UIGradient", uiStroke)
        gradientstroke.Color = (Fluent:GetButtonGradient() or Fluent.ButtonGradients).Stroke

        
        task.spawn(function()
            while fpsCounter and fpsCounter.Parent do
                gradient.Rotation = (gradient.Rotation + 1) % 360
                gradient.Color = (Fluent:GetButtonGradient() or Fluent.ButtonGradients).Background 
                task.wait(0.03)
            end
        end)

        task.spawn(function()
            while fpsCounter and fpsCounter.Parent do
                gradientstroke.Rotation = (gradientstroke.Rotation + 0.5) % 360
                gradientstroke.Color = (Fluent:GetButtonGradient() or Fluent.ButtonGradients).Stroke
                task.wait()
            end
        end)

        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, -10, 1, -10)
        label.Position = UDim2.new(0, 5, 0, 5)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Text = "Loading..."

        if typeof(MakeDraggable) == "function" then
            MakeDraggable(frame, frame, false)
        end

        local lastUpdateTime = tick()
        local frameCount = 0

        FPS_Data.Connection = RunService.RenderStepped:Connect(function()
            frameCount = frameCount + 1
            local now = tick()
            local dt = now - lastUpdateTime

            if dt >= 1 then
                local fps = math.round(frameCount / dt)
                local elapsed = now - startTime
                local h = math.floor(elapsed / 3600)
                local m = math.floor((elapsed % 3600) / 60)
                local s = math.floor(elapsed % 60)
                
                local ping = 0
                pcall(function()
                    ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                end)

                label.Text = string.format("FPS: %d | Ping: %d ms\nClient Timer: %dh %dm %ds", fps, ping, h, m, s)
                lastUpdateTime = now
                frameCount = 0
            end
        end)
    end
end

ToggleFPSCounter(true)

if not require then
    return LocalPlayer:Kick("UNC RESTRICTION MISSING: require(path) | PLEASE TRY OTHER EXECUTORS")
else
   print("Supported require()")
end

if not firetouchinterest  then
    return LocalPlayer:Kick("UNC RESTRICTION MISSING: firetouchinterest() | PLEASE TRY OTHER EXECUTORS")
else
   print("Supported firetouchinterest()")
end

if not setfpscap or setfpscap(500) then
    return LocalPlayer:Kick("UNC RESTRICTION MISSING: setfpscap() | PLEASE TRY OTHER EXECUTORS")
else
   print("Supported setfpscap()")
end

if game.Players then
   print("Advance Api")
else
   print("Common Api")
end

function CreateBillboardESP(Name, Part, Color, TextSize)
  if not Part or Part:FindFirstChild(Name) then return nil end

  local BillboardGui = Instance.new("BillboardGui")
  local TextLabel = Instance.new("TextLabel")
  local TextStroke = Instance.new("UIStroke")

  BillboardGui.Parent = Part
  BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  BillboardGui.Name = Name
  BillboardGui.AlwaysOnTop = true
  BillboardGui.LightInfluence = 1
  BillboardGui.Size = UDim2.new(0, 200, 0, 50)
  BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
  BillboardGui.MaxDistance = 1000

  TextLabel.Parent = BillboardGui
  TextLabel.BackgroundTransparency = 1
  TextLabel.Size = UDim2.new(1, 0, 1, 0)
  TextLabel.TextScaled = false
  TextLabel.Font = Enum.Font.SourceSans
  TextLabel.TextSize = TextSize or 14
  TextLabel.TextColor3 = Color or Color3.fromRGB(255, 255, 255)

  TextStroke.Parent = TextLabel
  TextStroke.Thickness = 1
  TextStroke.Color = Color3.new(0, 0, 0)

  return BillboardGui
end

function UpdateBillboardESP(Name, Part, NameText, Color, TextSize, PartPosition)
  if not Part then return false end

  local esp = Part:FindFirstChild(Name)
  if esp and esp:FindFirstChildOfClass("TextLabel") then
    local label = esp:FindFirstChildOfClass("TextLabel")
    
    if Color then
      label.TextColor3 = Color
    end
    
    if TextSize then
      label.TextSize = TextSize
    end
    
    if PartPosition then
      local Pos 
      if typeof(PartPosition) == "Instance" and PartPosition:IsA("BasePart") then
        Pos = PartPosition.Position
      elseif typeof(PartPosition) == "Vector3" then
        Pos = PartPosition
      end

      if Pos then
        local distance = math.floor((Pos - Part.Position).Magnitude)
        local name = NameText or Part.Parent and Part.Parent.Name or Part.Name
        label.Text = string.format("%s - [ %d M ]", name, distance)
      end
    else
      local name = NameText or Part.Parent and Part.Parent.Name or Part.Name
      label.Text = name
    end    
    return true
  end
  return false
end

function DestroyBillboardESP(Name, Part)
  if not Part then return false end
  
  local esp = Part:FindFirstChild(Name)
  if esp then
    esp:Destroy()
    return true
  end
  
  return false
end

function CreateTracerESP(tracerTable, part, thickness, color)
  local tracer = Drawing.new("Line")
  tracer.Thickness = thickness or 2
  tracer.Color = color or Color3.fromRGB(255, 255, 255)
  tracer.Transparency = 1
  tracer.Visible = false
  tracerTable[part] = tracer
  return tracer
end

function UpdateTracerESP(tracerTable, part, color)
  local tracer = tracerTable[part]
  if not tracer then return end

  if typeof(part) ~= "Instance" then
    tracerTable[part] = nil
    return
  end
  
  if not part.Parent or not part:IsDescendantOf(workspace) then
    tracer.Visible = false
    DestroyTracerESP(tracerTable, part)
    return
  end

  local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)  
  if onScreen then
    if color then tracer.Color = color end
    tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
    tracer.To = Vector2.new(screenPos.X, screenPos.Y)
    tracer.Visible = true
  else
    tracer.Visible = false
  end
end

function DestroyTracerESP(tracerTable, part)
  if typeof(part) ~= "Instance" then
    tracerTable[part] = nil
    return
  end
  
  local tracer = tracerTable[part]
  if tracer then 
    if tracer.Remove then tracer:Remove() end
    tracerTable[part] = nil
  end 
end

function CreateHighlightESP(Name, Part, HighlightColor, OutlineColor, ShowHighlight)
  if not Part then return false end

  local Highlight = Instance.new("Highlight")
  Highlight.Name = Name
  Highlight.FillColor = HighlightColor or Color3.fromRGB(255, 255, 255)
  Highlight.OutlineColor = OutlineColor or Color3.fromRGB(0, 0, 0)

  if ShowHighlight then
    Highlight.FillTransparency = 0
  else
    Highlight.FillTransparency = 1
  end

  Highlight.OutlineTransparency = 0
  Highlight.Parent = Part

  return true
end

function UpdateHighlightESP(Name, Part, HighlightColor, OutlineColor, ShowHighlight)
  local Highlight = Part and Part:FindFirstChild(Name)

  if not Highlight or not Highlight:IsA("Highlight") then return false end

  if HighlightColor then Highlight.FillColor = HighlightColor end
  if OutlineColor then Highlight.OutlineColor = OutlineColor end

  if ShowHighlight ~= nil then
    Highlight.FillTransparency = ShowHighlight and 0 or 0.5
  end

  return true
end

function DestroyHighlightESP(Name, Part)
  local Highlight = Part and Part:FindFirstChild(Name)

  if Highlight and Highlight:IsA("Highlight") then
    Highlight:Destroy()
    return true
  end

  return false
end

function Create3DBoxESP(Character, Color, Size)
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return nil end

    local FolderName = "ESP_3DBox"
    local Folder = Character:FindFirstChild(FolderName)
    if Folder then
        Folder:Destroy()
    end

    Folder = Instance.new("Folder")
    Folder.Name = FolderName
    Folder.Parent = Character

    Size = Size or Vector3.new(4, 5, 3)
    local OffsetX = Size.X / 2
    local OffsetY = Size.Y / 2
    local OffsetZ = Size.Z / 2

    local Edges = {
        {Vector3.new(0, OffsetY, OffsetZ), Vector3.new(Size.X, 0.1, 0.1), "TopFront"},
        {Vector3.new(0, OffsetY, -OffsetZ), Vector3.new(Size.X, 0.1, 0.1), "TopBack"},
        {Vector3.new(-OffsetX, OffsetY, 0), Vector3.new(0.1, 0.1, Size.Z), "TopLeft"},
        {Vector3.new(OffsetX, OffsetY, 0), Vector3.new(0.1, 0.1, Size.Z), "TopRight"},
        {Vector3.new(0, -OffsetY, OffsetZ), Vector3.new(Size.X, 0.1, 0.1), "BottomFront"},
        {Vector3.new(0, -OffsetY, -OffsetZ), Vector3.new(Size.X, 0.1, 0.1), "BottomBack"},
        {Vector3.new(-OffsetX, -OffsetY, 0), Vector3.new(0.1, 0.1, Size.Z), "BottomLeft"},
        {Vector3.new(OffsetX, -OffsetY, 0), Vector3.new(0.1, 0.1, Size.Z), "BottomRight"},
        {Vector3.new(-OffsetX, 0, OffsetZ), Vector3.new(0.1, Size.Y, 0.1), "FrontLeft"},
        {Vector3.new(OffsetX, 0, OffsetZ), Vector3.new(0.1, Size.Y, 0.1), "FrontRight"},
        {Vector3.new(-OffsetX, 0, -OffsetZ), Vector3.new(0.1, Size.Y, 0.1), "BackLeft"},
        {Vector3.new(OffsetX, 0, -OffsetZ), Vector3.new(0.1, Size.Y, 0.1), "BackRight"},
    }

    for _, Edge in ipairs(Edges) do
        local Position, BoxSize, Name = Edge[1], Edge[2], Edge[3]

        local Adornment = Instance.new("BoxHandleAdornment")
        Adornment.Name = Name
        Adornment.Adornee = RootPart
        Adornment.Size = BoxSize
        Adornment.CFrame = CFrame.new(Position)
        Adornment.Color3 = Color
        Adornment.Transparency = 0.2
        Adornment.ZIndex = 10
        Adornment.AlwaysOnTop = true
        Adornment.Visible = true
        Adornment.Parent = Folder
    end

    return Folder
end

function Update3DBoxESPColor(Character, Color)
    local Folder = Character:FindFirstChild("ESP_3DBox")
    if Folder then
        for _, Adornment in ipairs(Folder:GetChildren()) do
            if Adornment:IsA("BoxHandleAdornment") then
                Adornment.Color3 = Color
            end
        end
    end
end

function Destroy3DBoxESP(Character)
    local Folder = Character:FindFirstChild("ESP_3DBox")
    if Folder then
        Folder:Destroy()
    end
end

DFunctions = {}
DConfiguration = {
    ESP = {
        Players = false,
        Nextbots = false,
        Tickets = false,
        Objective = false,
    },

    Tracers = {
        Players = false,
        Nextbots = false,
        Tickets = false,
        Objective = false,
    },
    
    Highlight = {
        Players = false,
        Nextbots = false,
        Tickets = false,
        Objective = false,
        OutlineOnly = false,
    },

    Boxes = {
        Players = false,
        Nextbots = false,
        Tickets = false,
        Objective = false,
    },

    Removals = {
        CameraShake = false,
        InvisibleWalls = false,
        DamageParts = false,
    },

    Main = {
        AntiAFK = true,
        AutoRespawn = false,
        RespawnType = "Spawnpoint",
        AutoWhistle = false,
        Fly = false,
        FlySpeed = 20,
        Noclip = false,
    },

    Nextbots = {
        AntiNextbot = false,
        AntiNextbotRange = 15,
        AntiNextbotType = "Spawn",
    },

    Misc = {
        PlayerAdjustment = {
            Default = {
                Speed = 1500,
                JumpHeight = 3,
                AirStrafe = 182,
                GroundAcceleration = 1,
            },

            Update = {
                Speed = 1500,
                JumpHeight = 3,
                AirStrafe = 182,
                GroundAcceleration = 1,
            },

            Saved = {
                Speed = 1500,
                JumpHeight = 3,
                AirStrafe = 182,
                GroundAcceleration = 1,
            },

            Tick = {
                Speed = 0,
                JumpHeight = 0,
                AirStrafe = 0,
                GroundAcceleration = 0,
            },

            Debounce = {
                Speed = false,
                JumpHeight = false,
                AirStrafe = false,
                GroundAcceleration = false,
            },
        },

        Humanoids = {
            WalkspeedCF = false,
            OriginalJumpHeight = false,
            CF = 5,
            JP = 20,
        },

        Utilities = {
            GetCurrentSpeed = 0,

            BounceModification = {
                Enabled = false,
                DefaultBounce = 80,
                EmoteBounce = 120,
            },

            LagSwitch = {
                MSDelay = 200,
                Mode = "Normal",
            },
        },
        
        GameAutomation = {
            Macro = {
                SelectedPrimary = 1,
                FloatingButton = false,
                Keybind = false,
            },
        },

        MovementModification = {
            EmoteModification = {           
	            AggressiveEmoteDash = {
	                Enabled = false,
                    Type = "Blatant",
                    Speed = 3000,
                    Acceleration = -2,
	            },
	
                ModifyEmote = {
	                Enabled = true,
	                TurnSpeed = 0.5,
                },
	        },

            Gravity = {
                FloatingButton = false,
                Keybind = false,
                Value = 10,
            },

            BHOP = {
                Enabled = false,
                FloatingButton = false,
                AutoAcceleration = false,
                MaxSpeed = 70,
                JumpButton = false,
                HipHeight1 = 0,
                HipHeight2 = 0,
                Type = "Acceleration",
                JumpType = "Simulated",
                Acceleration = -0.1,
                lastTick = 0.01,
            },
        },

        AntiLags = {
            Low = false,
            Moderate = false,
            High = false,
        },
    },

    Visual = {
        OriginalCosmetics = {
            Cosmetics1 = "",
            Cosmetics2 = "",
            Cosmetics3 = "",
            Cosmetics4 = "",
        },
        
        ModifyCosmetics = {
            Cosmetics1 = "",
            Cosmetics2 = "",
            Cosmetics3 = "",
            Cosmetics4 = "",
        },

        OriginalEmotes = {
            Emote1 = "",
            Emote2 = "",
            Emote3 = "",
            Emote4 = "",
            Emote5 = "",
            Emote6 = "",
        },

        ModifyEmotes = {
            Emote1 = "",
            Emote2 = "",
            Emote3 = "",
            Emote4 = "",
            Emote5 = "",
            Emote6 = "",
        },
    },

    Settings = {},
}

FloatButtonSizes = {}

function CreateFloatingButton(ButtonName, DisplayText, IsToggle, OnClick)
    local savedW = (FloatButtonSizes[ButtonName] and FloatButtonSizes[ButtonName].W) or 200
    local savedH = (FloatButtonSizes[ButtonName] and FloatButtonSizes[ButtonName].H) or 70

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = ButtonName
    screenGui.Parent = LocalPlayer.PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = -2147483648
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = false

    local frame = Instance.new("Frame")
    frame.Name = ButtonName
    frame.Size = UDim2.new(0, savedW, 0, savedH)
    frame.Position = UDim2.new(0.5, -savedW / 2, 0.5, -savedH / 2)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BackgroundTransparency = 0.7
    frame.ZIndex = -10
    frame.Visible = false
    frame.Parent = screenGui

    local gradient = Instance.new("UIGradient")
    gradient.Color = (Fluent:GetButtonGradient() or Fluent.ButtonGradients).Background
    gradient.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Parent = frame
    local gradientstroke = Instance.new("UIGradient")
    gradientstroke.Color = (Fluent:GetButtonGradient() or Fluent.ButtonGradients).Stroke
    gradientstroke.Rotation = 0
    gradientstroke.Parent = stroke

    task.spawn(function()
        while task.wait(0.03) do
            if not frame.Parent then break end
            local grad = Fluent:GetButtonGradient() or Fluent.ButtonGradients
            frame.BackgroundTransparency = Fluent.UseAcrylic and 0.45 or 0.7
            if Fluent.ShineEnabled then
                gradient.Rotation = (gradient.Rotation + 1) % 360
                gradientstroke.Rotation = (gradientstroke.Rotation + 0.5) % 360
            end
            gradient.Color = grad.Background
            gradientstroke.Color = grad.Stroke
        end
    end)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = IsToggle and (DisplayText .. ": OFF") or DisplayText
    button.Font = Enum.Font.SourceSansBold
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 24
    button.TextScaled = false
    button.ZIndex = -9
    button.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 28, 0, 28)
    toggle.Position = UDim2.new(1, 6, 0.5, -14)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggle.Text = "○"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Visible = false
    toggle.ZIndex = -8
    toggle.Parent = frame
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

    local holding, holdStart, hideAt = false, 0, 0

    frame:SetAttribute("IsCircle", false)

    local function ApplyShape(circle)
        frame:SetAttribute("IsCircle", circle)
        local s = math.min(frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
        if circle then
            frame.Size = UDim2.new(0, s, 0, s)
            button.TextWrapped = true
            button.TextScaled = true
            button.TextSize = math.floor(s * 0.45)
            corner.CornerRadius = UDim.new(1, 0)
            toggle.Text = "▢"
        else
            local entry = FloatButtonSizes[ButtonName]
            local liveW = entry and entry.W or savedW
            local liveH = entry and entry.H or savedH
            frame.Size = UDim2.new(0, liveW, 0, liveH)
            button.TextWrapped = false
            button.TextScaled = false
            button.TextSize = 24
            corner.CornerRadius = UDim.new(0, 15)
            toggle.Text = "○"
        end
    end

    FloatingButtonManager:AddButton(ButtonName, frame, false)
    FloatButtonSizes[ButtonName] = { W = savedW, H = savedH, frame = frame, button = button, applyShape = ApplyShape }

    ApplyShape(false)

    task.spawn(function()
        while task.wait(0.25) do
            if not frame.Parent then break end
            if toggle.Visible and tick() - hideAt >= 10 then toggle.Visible = false end
        end
    end)

    button.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            holding = true; holdStart = tick()
        end
    end)
    button.InputEnded:Connect(function(i)
        if holding and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
            holding = false
            if tick() - holdStart >= 0.6 then toggle.Visible = true; hideAt = tick() end
        end
    end)
    toggle.MouseButton1Click:Connect(function()
        hideAt = tick()
        ApplyShape(not frame:GetAttribute("IsCircle"))
    end)
    button.Activated:Connect(function()
        if OnClick then OnClick(button) end
    end)

    MakeDraggable(button, frame, false)

    return frame, button, ApplyShape
end

function AddFloatingButtonSizeInputs(Section, ButtonName, DisplayText)
    Section:AddSpace({ Height = 20 })
    Section:AddInput(ButtonName .. "_Size", {
        Title = "Size",
        Placeholder = "200x70",
        Default = "200x70",
        Finished = true,
        Description = "Format: RealSizeXRealSize (e.g. 200x70)",
        Callback = function(v)
            local w, h = tostring(v):match("^(%d+)[xX](%d+)$")
            w = tonumber(w); h = tonumber(h)
            if w and h and w > 0 and h > 0 and FloatButtonSizes[ButtonName] then
                local entry = FloatButtonSizes[ButtonName]
                entry.W = w
                entry.H = h
                local f = entry.frame
                if f and not f:GetAttribute("IsCircle") then
                    f.Size = UDim2.new(0, w, 0, h)
                end
            end
        end,
    })
end

function AddFloatingButtonKeybind(Section, ButtonName, DisplayText, Callback, DefaultKey)
    Section:AddSpace({ Height = 10 })
    Section:AddKeybind(ButtonName .. "_Keybind", {
        Title = (DisplayText or ButtonName) .. " Keybind",
        Description = "Trigger " .. (DisplayText or ButtonName),
        Default = DefaultKey or "",
        Callback = Callback,
    })
end

function SetFloatingButtonVisible(Frame, State)
    if Frame then Frame.Visible = State end
end

function SetFloatingButtonText(Button, Text)
    if Button then Button.Text = Text end
end

function SetFloatingButtonActive(Button, State, Name)
    if not Button then return end
    Button.Text = Name .. ": " .. (State and "ON" or "OFF")
end


function DFunctions.AutoRespawn()
 	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	 if char and char:GetAttribute("Downed") == true and DConfiguration.Main.RespawnType == "Spawnpoint" then
		 game:GetService("ReplicatedStorage").Events.Respawn:FireServer()
     elseif char and char:GetAttribute("Downed") == true and DConfiguration.Main.RespawnType == "Fake Revive" then
	     local PreviousPosition
	     PreviousPosition = LocalPlayer.Character.HumanoidRootPart.Position
    	 wait(0.2)
	     game:GetService("ReplicatedStorage").Events.Respawn:FireServer()
	     wait(1)
	     LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(PreviousPosition)
	 end
end

function DFunctions.Whistle()
    LocalPlayer.PlayerScripts.Events.KeybindUsed:Fire("Whistle", true)
    game:GetService("ReplicatedStorage").Events.Whistle:FireServer()
end

function DFunctions.RemoveDamagePart()
   local Map = game.Workspace.Game.Map
   
   for i, v in pairs(Map:GetDescendants()) do
     if v:IsA("BasePart") and v.CanTouch == true then
          v.CanTouch = false
       end
   end
end

function DFunctions.DisableTouch(t)
	for i, v in next, t:GetChildren() do
		if v.IsA(v, 'BasePart') then
			v.CanTouch = false
		end
	end
end

function DFunctions.DisableInvisParts(state)
    for i, v in pairs(Workspace.Game.Map.InvisParts:GetChildren()) do
       if v:IsA("BasePart") then
          v.CanCollide = state
       end
    end
end

function DFunctions.Noclip()
   pcall(function()
      for i, v in pairs(LocalPlayer.Character:GetDescendants()) do
          if v:IsA("BasePart") and v:IsA("MeshPart") then
              v.CanCollide = false
          end
      end
   end)
end

function DFunctions.AntiNextbot()
    if game.Workspace:FindFirstChild("Game") and game.Workspace.Game:FindFirstChild("Players") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    
        local playerTeam = game.Workspace.Game.Players[LocalPlayer.Name]:GetAttribute("Team")
        if playerTeam == "Nextbot" then
            return 
        end
    
        for i, v in pairs(game.Workspace.Game.Players:GetDescendants()) do
            if v:IsA("Model") and v:GetAttribute("Team") == "Nextbot" then
                local humanoidRootPart = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("HRP")
                if humanoidRootPart then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                    
                    if distance < DConfiguration.Combat.AntiNextbotRange then
                        if DConfiguration.Combat.AntiNextbotType == "Spawn" then
                            local parts = workspace.Game.Map.ItemSpawns:GetChildren()
                            local randomPart = parts[math.random(1, #parts)]
                            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(randomPart.Position)
                        elseif DConfiguration.Combat.AntiNextbotType == "Players" then
                            local randomPlayer = Players:GetPlayers()[math.random(1, #game.Players:GetPlayers())]
                            if randomPlayer then
                              LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(randomPlayer.Character.Head.Position.X, randomPlayer.Character.Head.Position.Y, randomPlayer.Character.Head.Position.Z)
                            end
                        end
                    end
                end
            end
        end
    end
end

function DFunctions.HookMovement(char)
    local success, module = pcall(function()
        return require(char:WaitForChild("Movement"))
    end)
    if not success then return end

    local oldFriction
    local oldAccel

    if module.ApplyFriction then
        oldFriction = hookfunction(module.ApplyFriction, function(...)
            local args = {...}

            if args[2] and char:GetAttribute("Crouching") == true then
                args[2] = math.max(-0.1, DConfiguration.Misc.PlayerAdjustment.Update.GroundAcceleration - 0.9)
            elseif args[2] then
                args[2] = DConfiguration.Misc.PlayerAdjustment.Update.GroundAcceleration
            end

            return oldFriction(unpack(args))
        end)
    end

    if module.Accelerate then
        oldAccel = hookfunction(module.Accelerate, function(...)
            local args = {...}

            if args[3] == 182 or args[4] == 182 then
                args[3] = DConfiguration.Misc.PlayerAdjustment.Update.AirStrafe
                args[4] = DConfiguration.Misc.PlayerAdjustment.Update.AirStrafe
            end

            return oldAccel(unpack(args))
        end)
    end
end

function DFunctions.GetSpeedometer()
    local currentspeed = LocalPlayer.Character:GetAttribute("CurrentMoveSpeed")
    
    return currentspeed
end

CachedRayParams = RaycastParams.new()
CachedRayParams.FilterType = Enum.RaycastFilterType.Exclude

function DFunctions.StartLag(ms)
	local LagTime = ms * 0.002
	local mode = DConfiguration.Misc.Utilities.LagSwitch.Mode
	local character = LocalPlayer.Character
	if not character then return end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local storedVelocity = hrp.AssemblyLinearVelocity
	if storedVelocity.Magnitude < 1 then return end

	local start = tick()
	while tick() - start < LagTime do end
	
	if mode == "FastFlag" or LagTime < 0.2 then
	   setfflag("MaxMissedWorldStepsRemembered", "9999")
	   return
	end
	
	if mode ~= "Demon" or LagTime < 0.2 then return end
	
	CachedRayParams.FilterDescendantsInstances = {character}

	local multiplier = math.random(2, 4)
	local horizontalVelocity = Vector3.new(storedVelocity.X, 0, storedVelocity.Z)
	local direction = horizontalVelocity.Magnitude > 0 and horizontalVelocity.Unit or hrp.CFrame.LookVector
	local distance = math.min(horizontalVelocity.Magnitude * LagTime * multiplier, 30)
	local forwardPos = hrp.Position + direction * distance
	local targetPos = forwardPos

	local forwardResult = workspace:Raycast(hrp.Position, forwardPos - hrp.Position, CachedRayParams)
	if forwardResult then
		targetPos = forwardResult.Position - direction * 2
	end

	local function detectSlope(dir, dist)
		return workspace:Raycast(hrp.Position + dir * dist, Vector3.new(0, -60, 0), CachedRayParams)
	end

	local longSlopeCheck = detectSlope(direction, 50)
	local shortSlopeCheck = nil

	for i = 2, 20, 2 do
		local result = detectSlope(direction, i)
		if result then
			shortSlopeCheck = result
			break
		end
	end

	local slopeLengthBoost, shortSlopeBoost = 1, 1
	local slopeDirBoost = 1
	local hoverBuffer = 0
	local slopeAngle = 0
	local earlyBounce = false

	if longSlopeCheck then
		local normal = longSlopeCheck.Normal
		slopeAngle = math.deg(math.acos(normal:Dot(Vector3.new(0, 1, 0))))
		if slopeAngle >= 20 and slopeAngle <= 80 then
			slopeLengthBoost = math.clamp(slopeAngle / 25, 1, 2.2)
			slopeDirBoost = math.clamp(slopeAngle / 40, 1, 2)
			hoverBuffer = math.clamp((slopeAngle - 20) * 0.06, 0, 3)
			if slopeAngle < 35 then
				targetPos = targetPos + Vector3.new(0, 3, 0) + direction * (2 * slopeDirBoost)
			else
				targetPos = targetPos + Vector3.new(0, slopeAngle * 0.3 + hoverBuffer, 0)
			end
		end
	end

	if shortSlopeCheck then
		local normal = shortSlopeCheck.Normal
		slopeAngle = math.deg(math.acos(normal:Dot(Vector3.new(0, 1, 0))))
		if slopeAngle >= 20 and slopeAngle <= 80 then
			shortSlopeBoost = math.clamp(slopeAngle / 22, 1, 2.5)
			slopeDirBoost = slopeDirBoost + math.clamp(slopeAngle / 50, 0, 1.6)
			hoverBuffer = hoverBuffer + math.clamp((slopeAngle - 20) * 0.05, 0, 3)
			local verticalDist = hrp.Position.Y - shortSlopeCheck.Position.Y
			local minForward = 4
			local minUp = 4
			if slopeAngle >= 50 and verticalDist < 3 then
				earlyBounce = true
				targetPos = targetPos + direction * minForward + Vector3.new(0, minUp, 0)
			else
				if slopeAngle < 35 then
					targetPos = targetPos + Vector3.new(0, 3, 0) + direction * (2 * slopeDirBoost)
				else
					targetPos = targetPos + Vector3.new(0, slopeAngle * 0.4 + hoverBuffer, 0)
				end
			end
		end
	end

	if slopeAngle >= 35 then
		targetPos = targetPos + direction * (5 * slopeDirBoost)
	end

	local safetyCheck = workspace:Raycast(hrp.Position, targetPos - hrp.Position, CachedRayParams)
	if safetyCheck then
		targetPos = safetyCheck.Position + Vector3.new(0, 2, 0) - direction * 2
	end

	if shortSlopeCheck or longSlopeCheck then
		local hitPos = (shortSlopeCheck or longSlopeCheck).Position
		local verticalDist = hrp.Position.Y - hitPos.Y
		if verticalDist < 2 then
			targetPos = hrp.Position + direction * 2 + Vector3.new(0, 2, 0)
		end
	end

	hrp.CFrame = CFrame.new(targetPos, targetPos + hrp.CFrame.LookVector)

	local delta = targetPos - hrp.Position
	local speed = storedVelocity.Magnitude
	local forwardBoost = math.clamp(speed * 0.4, 4, 20)
	local safeDir = delta.Magnitude > 0 and delta.Unit or direction
	local safeCheck = workspace:Raycast(hrp.Position, safeDir * forwardBoost, CachedRayParams)

	if not safeCheck then
		hrp.AssemblyLinearVelocity += safeDir * forwardBoost
	else
		local safeDist = (safeCheck.Position - hrp.Position).Magnitude
		if safeDist > 3 then
			hrp.AssemblyLinearVelocity += safeDir * (safeDist * 0.6)
		end
	end

	local bounceMultiplier = 1.2
	if slopeAngle >= 45 then
		local angleBoost = math.clamp((slopeAngle - 45) / 20, 0, 1.0)
		bounceMultiplier = 1.2 + angleBoost
	end

	if storedVelocity.Y < -60 then
		bounceMultiplier *= 0.9 * slopeLengthBoost * shortSlopeBoost
	elseif storedVelocity.Y < -30 then
		bounceMultiplier *= 1.0 * slopeLengthBoost * shortSlopeBoost
	end

	if storedVelocity.Y < -10 then
		local angleFactor = math.clamp((slopeAngle - 20) / 40, 0, 1)
		local bounceY = math.abs(storedVelocity.Y) * (1.1 + angleFactor * 0.9)
		bounceY = bounceY + storedVelocity.Magnitude * (0.3 + angleFactor * 0.5)
		bounceY = math.clamp(bounceY * bounceMultiplier * 1.0, 0, 60 + storedVelocity.Magnitude * 0.4)

		hrp.AssemblyLinearVelocity = Vector3.new(
			storedVelocity.X * slopeDirBoost,
			bounceY,
			storedVelocity.Z * slopeDirBoost
		)

		if earlyBounce then
			local forwardBoost = math.clamp(5 + storedVelocity.Magnitude * 0.1, 6, 20)
			local forwardCheck = workspace:Raycast(hrp.Position, direction * forwardBoost, CachedRayParams)
			if not forwardCheck then
				hrp.CFrame = hrp.CFrame + direction * forwardBoost
			else
				local safeDist = (forwardCheck.Position - hrp.Position).Magnitude
				if safeDist > 3 then
					hrp.CFrame = hrp.CFrame + direction * (safeDist * 0.5)
				end
			end
		end
	end
	
	hrp.Size = Vector3.new(3, 20, 3)
	wait(0.1)
	hrp.Size = Vector3.new(2, 4, 2)
end

function DFunctions.BounceFunction()
    local speedometer = DFunctions.GetSpeedometer()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char and char:FindFirstChild("Humanoid")

    if speedometer then
        DConfiguration.Misc.Utilities.GetCurrentSpeed = speedometer
    end

    if not DConfiguration.Misc.Utilities.BounceModification.Enabled and humanoid then
        humanoid.WalkSpeed = 0
        return
    end
     
    if char and humanoid then
        if char:GetAttribute("Downed") == true or not DConfiguration.Misc.Utilities.BounceModification.Enabled then
            humanoid.WalkSpeed = 0
        elseif char:GetAttribute("Emoting") == true and char:GetAttribute("Crouching") == true then
            humanoid.WalkSpeed = DConfiguration.Misc.Utilities.BounceModification.EmoteBounce + DConfiguration.Misc.Utilities.GetCurrentSpeed
        elseif DConfiguration.Misc.Utilities.GetCurrentSpeed < 15 or char:GetAttribute("Emoting") == true or char:GetAttribute("Downed") == true then
            humanoid.WalkSpeed = 0
        else
            humanoid.WalkSpeed = DConfiguration.Misc.Utilities.BounceModification.DefaultBounce + DConfiguration.Misc.Utilities.GetCurrentSpeed
        end
    end
end

function DFunctions.SprintEmoteDash()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	
	if DConfiguration.Misc.MovementModification.EmoteModification.AggressiveEmoteDash.Type == "Legit" and (char and char:GetAttribute("Emoting") == true and char:GetAttribute("Crouching") == true) then
	    DConfiguration.Misc.PlayerAdjustment.Debounce.GroundAcceleration = false
	    DConfiguration.Misc.PlayerAdjustment.Update.GroundAcceleration = DConfiguration.Misc.MovementModification.EmoteModification.AggressiveEmoteDash.Acceleration
    else
        if DConfiguration.Misc.PlayerAdjustment.Debounce.GroundAcceleration then     
			DConfiguration.Misc.PlayerAdjustment.Update.GroundAcceleration = DConfiguration.Misc.PlayerAdjustment.Saved.GroundAcceleration
			wait(0.1)
			DConfiguration.Misc.PlayerAdjustment.Debounce.GroundAcceleration = true
		end
	end
	
	if DConfiguration.Misc.MovementModification.EmoteModification.AggressiveEmoteDash.Type == "Blatant" and (char and char:GetAttribute("Emoting") == true) then
		DConfiguration.Misc.PlayerAdjustment.Update.Speed = DConfiguration.Misc.MovementModification.EmoteModification.AggressiveEmoteDash.Speed
	else
	    DConfiguration.Misc.PlayerAdjustment.Update.Speed = DConfiguration.Misc.PlayerAdjustment.Saved.Speed
	end
end

function DFunctions.BHOPFunction()
    local speedometer = DFunctions.GetSpeedometer()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidrootpart = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local debounce
    
    if not char then return end
    if not humanoidrootpart then return end
    if not humanoid then return end
    
    -- LocalPlayer.Character.Communicator:InvokeServer("JumpDone")
    LocalPlayer.Character.Movement.JumpEnded:Fire()
    
    if DConfiguration.Misc.MovementModification.BHOP.Type == "Acceleration" then
        if speedometer > 60 then
            DConfiguration.Misc.MovementModification.BHOP.HipHeight2 = -1.05
        else
            DConfiguration.Misc.MovementModification.BHOP.HipHeight2 = -1.10
        end
        
        debounce = 0.01
        humanoid.HipHeight = DConfiguration.Misc.MovementModification.BHOP.HipHeight2
    elseif DConfiguration.Misc.MovementModification.BHOP.Type == "Ground Acceleration" then
        DConfiguration.Misc.MovementModification.BHOP.HipHeight2 = -2
        
        humanoid.HipHeight = DConfiguration.Misc.MovementModification.BHOP.HipHeight2
        debounce = 0.01      
    elseif DConfiguration.Misc.MovementModification.BHOP.Type == "No Acceleration" then
        debounce = 0.125
    end
    
    if DConfiguration.Misc.MovementModification.BHOP.AutoAcceleration then
        local Speed = speedometer
        local Threshold = math.clamp(Speed, 25, 50)
        local Devisor = math.clamp(Speed / Threshold, 0, 6) 
        local Decrease = math.clamp(1 - (Devisor * 1.7), 0.01, 0.8)
        
        if Speed < DConfiguration.Misc.MovementModification.BHOP.MaxSpeed then
            DConfiguration.Misc.PlayerAdjustment.Update.GroundAcceleration = DConfiguration.Misc.MovementModification.BHOP.Acceleration
        else 
            DConfiguration.Misc.PlayerAdjustment.Update.GroundAcceleration = Decrease
        end
    else
        DConfiguration.Misc.PlayerAdjustment.Update.GroundAcceleration = DConfiguration.Misc.MovementModification.BHOP.Acceleration
    end
    
    local now = tick()
    local lastGrounded = 0

    if humanoid.FloorMaterial ~= Enum.Material.Air then
        lastGrounded = now
    end

    local grounded = (now - lastGrounded) < 0.06

    if DConfiguration.Misc.MovementModification.BHOP.JumpType == "Simulated" then
        if grounded and (now - DConfiguration.Misc.MovementModification.BHOP.lastTick) > debounce then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            DConfiguration.Misc.MovementModification.BHOP.lastTick = now
        end
    end
end

function DFunctions.ResetBHOP()
   local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
   local humanoid = char:FindFirstChildOfClass("Humanoid")
   
   DConfiguration.Misc.MovementModification.BHOP.HipHeight1 = -1.25
   DConfiguration.Misc.MovementModification.BHOP.HipHeight2 = -1.10
           
   if humanoid then
       humanoid.HipHeight = DConfiguration.Misc.MovementModification.BHOP.HipHeight1
       DConfiguration.Misc.PlayerAdjustment.Update.GroundAcceleration = 1
       wait(0.3)
       DConfiguration.Misc.PlayerAdjustment.Update.GroundAcceleration = 1
    end
end

GamePlayers = workspace:WaitForChild("Game"):WaitForChild("Players")

TracerLinesBots = {}
TracerLines = {}


Tabs.Main:AddDivider()
Tabs.Main:AddSpace({ Height = 20 })

SecGameModification = Tabs.Main:AddSection("Game Modification", "solar/gameboy-bold")
SecGameModification:AddSpace({ Height = 20 })
SecGameModification:AddDivider()


Toggle = SecGameModification:AddToggle("AutoRespawn", {Title = "Auto Respawn", Default = false })

    Toggle:OnChanged(function(value)
       DConfiguration.Main.AutoRespawn = value
        
       while DConfiguration.Main.AutoRespawn and wait(0.1) do
          spawn(DFunctions.AutoRespawn)
	 end
end)

SecGameModification:AddDivider()
SecGameModification:AddSpace({ Height = 10 })
SecGameModification:AddDivider()

Toggle = SecGameModification:AddToggle("RespawnButton", {Title = "Respawn (Button)", Default = false})

RespawnFrame, RespawnButton = CreateFloatingButton("RespawnButton", "Respawn", false)
function DoRespawnClick()
    RespawnButton.Text = "Respawning..."
    spawn(DFunctions.AutoRespawn)
    wait(0.1)
    RespawnButton.Text = "Respawned!"
    wait(0.2)
    RespawnButton.Text = "Respawn"
end
RespawnButton.Activated:Connect(DoRespawnClick)

Toggle:OnChanged(function(State)
    SetFloatingButtonVisible(RespawnFrame, State)
end)

AddFloatingButtonSizeInputs(SecGameModification, "RespawnButton", "Respawn")
AddFloatingButtonKeybind(SecGameModification, "RespawnButton", "Respawn", DoRespawnClick)

SecGameModification:AddDivider()
SecGameModification:AddSpace({ Height = 10 })
SecGameModification:AddDivider()

respawnEvent = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Respawn")

SecGameModification:AddButton({
    Title = "Force Respawn",
    Description = "",
    Callback = function()   
        respawnEvent:FireServer()
    end
})


Dropdown = SecGameModification:AddDropdown("RespawnType", {
        Title = "Respawn Type",
        Values = {"Spawnpoint", "Fake Revive"},
        Multi = false,
        Search = false,
        Default = 1,
    })

    Dropdown:OnChanged(function(value)
        DConfiguration.Main.RespawnType = value
    end)
    
SecGameModification:AddDivider()
SecGameModification:AddSpace({ Height = 20 })

SecGameModification:AddSpace({ Height = 20 })
SecGameModification:AddDivider()

SecWhistle = Tabs.Main:AddSection("Whistle", "solar/bell-bold")
SecWhistle:AddSpace({ Height = 20 })
SecWhistle:AddDivider()
    
Toggle = SecWhistle:AddToggle("AutoWhistle", {Title = "Auto Whistle", Default = false })

    Toggle:OnChanged(function(value)
        DConfiguration.Main.AutoWhistle = value
        
      while task.wait(1) and DConfiguration.Main.AutoWhistle do
	   	DFunctions.Whistle()
		end
    end)
    

SecWhistle:AddDivider()
SecWhistle:AddSpace({ Height = 20 })

SecAlternativeSettings = Tabs.Main:AddSection("Alternative Settings", "solar/settings-bold")
SecAlternativeSettings:AddSpace({ Height = 20 })
SecAlternativeSettings:AddDivider()

    
Toggle = SecAlternativeSettings:AddToggle("AntiAfk", {Title = "Anti-AFK", Default = false })

    Toggle:OnChanged(function()
    local vu = game:GetService("VirtualUser")
    
    repeat wait() until game:IsLoaded() 
	   LocalPlayer.Idled:connect(function()
       game:GetService("VirtualUser"):ClickButton2(Vector2.new())
	  	vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	  	wait(1)
		  vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
     end)
 end)
 
 Options.AntiAfk:SetValue(true)
 
 local Toggle = SecAlternativeSettings:AddToggle("RemoveCameraShake", {Title = "Disable Camera Shake", Default = false })

Toggle:OnChanged(function(value)
    DConfiguration.Removals.CameraShake = value

    while task.wait() and DConfiguration.Removals.CameraShake do
	    LocalPlayer.PlayerScripts.CameraShake.Value = CFrame.new(0,0,0) * CFrame.new(0,0,0)
 	end
end)

Toggle = SecAlternativeSettings:AddToggle("QuickRevive", {Title = "Quick Revive", Default = false })

    Toggle:OnChanged(function(State)
        if State then
            workspace.Game.Settings:SetAttribute("ReviveTime", 1.75)
		else
            workspace.Game.Settings:SetAttribute('ReviveTime', 3)
		end        
    end)
    

SecAlternativeSettings:AddDivider()
SecAlternativeSettings:AddSpace({ Height = 20 })

SecMapModification = Tabs.Main:AddSection("Map Modification", "solar/map-bold")
SecMapModification:AddSpace({ Height = 20 })
SecMapModification:AddDivider()

    
Toggle = SecMapModification:AddToggle("RemoveDamage", {Title = "Remove Damage Objects", Default = false })

    Toggle:OnChanged(function(value)
        DConfiguration.Removals.DamageParts = value
        
      while task.wait(1) and DConfiguration.Removals.DamageParts do
			spawn(DFunctions.RemoveDamagePart)
		end
    end)
    
InvisWallSystem = {}
InvisWallProcessedParts = {}
InvisWallEnabled = false
InvisWallCleanupThread = nil
InvisWallKeybindConnection = nil

InvisWallRepairKeywords = {
    "stair", "step", "ramp", "trimp", "platform", "invisibleplatform",
    "floor", "ground", "pad", "road", "path", "bridge"
}

function InvisWallIsPlayerPart(obj)
    for _, player in pairs(Players:GetPlayers()) do
        local char = player.Character
        if char and obj:IsDescendantOf(char) then
            return true
        end
    end
    return false
end

function InvisWallIsGameplayPart(name)
    name = string.lower(name)
    for _, keyword in pairs(InvisWallRepairKeywords) do
        if string.find(name, keyword, 1, true) then
            return true
        end
    end
    return false
end

function InvisWallShouldRemove(obj)
    if not (obj:IsA("BasePart") or obj:IsA("MeshPart")) then
        return false
    end
    if InvisWallProcessedParts[obj] then
        return false
    end
    if InvisWallIsPlayerPart(obj) then
        return false
    end
    if InvisWallIsGameplayPart(obj.Name) then
        return false
    end
    if obj.CanCollide and obj.Transparency >= 0.8 and obj.Position.Y > 50 then
        return true
    end
    return false
end

function InvisWallRunCleanAndFix()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if InvisWallShouldRemove(obj) then
            pcall(function()
                InvisWallProcessedParts[obj] = true
                obj.CanCollide = false
            end)
        end
    end
end

InvisWallDescendantConnection = nil

function InvisWallSystem.Enable()
    if InvisWallEnabled then return end
    InvisWallEnabled = true
    InvisWallProcessedParts = {}
    InvisWallRunCleanAndFix()
    InvisWallCleanupThread = task.spawn(function()
        while InvisWallEnabled do
            task.wait(3)
            if InvisWallEnabled then
                InvisWallRunCleanAndFix()
            end
        end
    end)
    InvisWallDescendantConnection = Workspace.DescendantAdded:Connect(function(obj)
        if not InvisWallEnabled then return end
        task.defer(function()
            if InvisWallEnabled and InvisWallShouldRemove(obj) then
                pcall(function()
                    InvisWallProcessedParts[obj] = true
                    obj.CanCollide = false
                end)
            end
        end)
    end)
    InvisWallKeybindConnection = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.R then
            InvisWallRunCleanAndFix()
        end
    end)
end

function InvisWallSystem.Disable()
    InvisWallEnabled = false
    if InvisWallCleanupThread then
        task.cancel(InvisWallCleanupThread)
        InvisWallCleanupThread = nil
    end
    if InvisWallDescendantConnection then
        InvisWallDescendantConnection:Disconnect()
        InvisWallDescendantConnection = nil
    end
    if InvisWallKeybindConnection then
        InvisWallKeybindConnection:Disconnect()
        InvisWallKeybindConnection = nil
    end

    for obj, _ in pairs(InvisWallProcessedParts) do
        pcall(function()
            if obj and obj.Parent then
                obj.CanCollide = true
            end
        end)
    end

    InvisWallProcessedParts = {}
end

function InvisWallSystem.Toggle()
    if InvisWallEnabled then
        InvisWallSystem.Disable()
    else
        InvisWallSystem.Enable()
    end
end

Toggle = SecMapModification:AddToggle("RemoveReducingRewards", {Title = "Remove Invisible Walls", Default = false })

    Toggle:OnChanged(function(value)
        DConfiguration.Removals.InvisibleWalls = value

        if value then
            InvisWallSystem.Enable()
        else
            InvisWallSystem.Disable()
        end
    end)
    

SecMapModification:AddDivider()
SecMapModification:AddSpace({ Height = 20 })

SecPlayerModification = Tabs.Main:AddSection("Player Modification", "solar/user-bold")
SecPlayerModification:AddSpace({ Height = 20 })
SecPlayerModification:AddDivider()

    
Toggle = SecPlayerModification:AddToggle("Noclip", {Title = "Noclip", Default = false })

Toggle:OnChanged(function(value)
        DConfiguration.Main.Noclip = value
        
        while DConfiguration.Main.Noclip and wait(0.1) do
           DFunctions.Noclip()
         end
    end)

Options.Noclip:SetValue(false)

FLYING = false
velocityHandlerName = "VelocityHandler"
gyroHandlerName = "GyroHandler"

function getRoot(character)
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
end

function unmobilefly(player)
    pcall(function()
        FLYING = false
        local character = player.Character
        if character then
            local root = getRoot(character)
            if root then
                local velocityHandler = root:FindFirstChild(velocityHandlerName)
                local gyroHandler = root:FindFirstChild(gyroHandlerName)

                if velocityHandler then
                    velocityHandler:Destroy()
                end

                if gyroHandler then
                    gyroHandler:Destroy()
                end

                local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end

        if mfly1 then
            mfly1:Disconnect()
        end

        if mfly2 then
            mfly2:Disconnect()
        end
    end)
end

function mobilefly(player, vfly)
    unmobilefly(player)
    FLYING = true

    local character = player.Character
    local root = getRoot(character)

    if character and root then
        local camera = workspace.CurrentCamera
        local v3none = Vector3.new()
        local v3zero = Vector3.new(0, 0, 0)
        local v3inf = Vector3.new(9e9, 9e9, 9e9)

        local controlModule = require(player.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
        local bv = Instance.new("BodyVelocity")
        bv.Name = velocityHandlerName
        bv.Parent = root
        bv.MaxForce = v3zero
        bv.Velocity = v3zero

        local bg = Instance.new("BodyGyro")
        bg.Name = gyroHandlerName
        bg.Parent = root
        bg.MaxTorque = v3inf
        bg.P = 1000
        bg.D = 2

        mfly1 = player.CharacterAdded:Connect(function()
            unmobilefly(player)
            currentCharacter = player.Character
            mobilefly(player, vfly)
        end)

        mfly2 = RunService.RenderStepped:Connect(function()
            root = getRoot(player.Character)
            camera = workspace.CurrentCamera
            if player.Character:FindFirstChildWhichIsA("Humanoid") and root and root:FindFirstChild(velocityHandlerName) and root:FindFirstChild(gyroHandlerName) then
                local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
                local VelocityHandler = root:FindFirstChild(velocityHandlerName)
                local GyroHandler = root:FindFirstChild(gyroHandlerName)

                if VelocityHandler and GyroHandler then
                    VelocityHandler.MaxForce = v3inf
                    GyroHandler.MaxTorque = v3inf

                    if not vfly and humanoid then
                        humanoid.PlatformStand = false
                    end

                    GyroHandler.CFrame = camera.CoordinateFrame
                    VelocityHandler.Velocity = v3none

                    local direction = controlModule:GetMoveVector()
                    if direction.X ~= 0 or direction.Z ~= 0 then
                        local moveVector = Vector3.new(direction.X, 0, direction.Z).unit
                        local rightVector = camera.CFrame.RightVector
                        local forwardVector = camera.CFrame.LookVector

                        local flyDirection = (rightVector * moveVector.X - forwardVector * moveVector.Z).unit

                        VelocityHandler.Velocity = flyDirection * (_G.flySpeed * 20)
                        RunService.RenderStepped:Wait()
                    end
                end
            end
        end)
    end
end

function toggleFly(player, toggleValue)
    if toggleValue then
        mobilefly(player, true)
    else
        unmobilefly(player)
    end
end

_G.Fly = false

function flyLoop()
    while wait(10) do
        if _G.Fly then
            local player = LocalPlayer
            if player and player.Character then
                mobilefly(player, true)
            end
        end
    end
end

FlyButtonToggle = SecPlayerModification:AddToggle("FlyButtonToggle", {Title = "Fly (Button)", Default = false})

FlyFrame, FlyButton = CreateFloatingButton("FlyButton", "Fly", true)
function DoFlyToggle()
    _G.Fly = not _G.Fly
    toggleFly(LocalPlayer, _G.Fly)
    SetFloatingButtonActive(FlyButton, _G.Fly, "Fly")
end
FlyButton.Activated:Connect(DoFlyToggle)

FlyButtonToggle:OnChanged(function(State)
    SetFloatingButtonVisible(FlyFrame, State)
    if not State then
        _G.Fly = false
        toggleFly(LocalPlayer, false)
    end
end)

AddFloatingButtonSizeInputs(SecPlayerModification, "FlyButton", "Fly")
AddFloatingButtonKeybind(SecPlayerModification, "FlyButton", "Fly", DoFlyToggle)

_G.flySpeed = 20 

FlySpeedInput = SecPlayerModification:AddInput("FlySpeedInput", {
    Title = "Fly Speed",
    Default = tostring(_G.flySpeed),
    Placeholder = "Enter fly speed",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        _G.flySpeed = tonumber(Value) or 20
    end
})

spawn(flyLoop)

    
wait(Duration)

_G.TAS_Data = _G.TAS_Data or {
    Run = false,
    Playing = false,
    Mode = "Single",
    Frames = {},
    Start = 0,
    LP = game:GetService("Players").LocalPlayer
}

_G.TAS_Lib = {}

_G.TAS_Lib.GetChar = function()
    return _G.TAS_Data.LP.Character or _G.TAS_Data.LP.CharacterAdded:Wait()
end

_G.TAS_Lib.StartRec = function()
    _G.TAS_Data.Playing = false
    _G.TAS_Data.Frames = {}
    _G.TAS_Data.Run = true
    _G.TAS_Data.Start = tick()
    task.spawn(function()
        while _G.TAS_Data.Run do
            local c = _G.TAS_Lib.GetChar()
            if c and c:FindFirstChild("HumanoidRootPart") then
                table.insert(_G.TAS_Data.Frames, {
                    c.HumanoidRootPart.CFrame,
                    c.Humanoid:GetState().Value,
                    tick() - _G.TAS_Data.Start
                })
            end
            game:GetService("RunService").Heartbeat:Wait()
        end
    end)
end

_G.TAS_Lib.Play = function()
    local c = _G.TAS_Lib.GetChar()
    local f = _G.TAS_Data.Frames
    if #f == 0 then return end
    
    _G.TAS_Data.Run = false
    _G.TAS_Data.Playing = true
    
    task.spawn(function()
        while _G.TAS_Data.Playing do
            local tp = tick()
            local old = 1
            local finished = false
            
            local conn
            conn = game:GetService("RunService").Heartbeat:Connect(function()
                if not _G.TAS_Data.Playing then 
                    conn:Disconnect() 
                    return 
                end
                
                local cur = tick() - tp
                if cur >= f[#f][3] then 
                    finished = true
                    conn:Disconnect() 
                    return 
                end
                
                for i = old, math.min(old + 60, #f) do
                    if f[i] and f[i][3] <= cur then
                        old = i
                        c.HumanoidRootPart.CFrame = f[i][1]
                        c.Humanoid:ChangeState(f[i][2])
                    end
                end
            end)
            
            repeat task.wait() until finished or not _G.TAS_Data.Playing
            
            if _G.TAS_Data.Mode == "Single" then
                _G.TAS_Data.Playing = false
            end
        end
    end)
end


SecPlayerModification:AddDivider()
SecPlayerModification:AddSpace({ Height = 20 })

TasSec = Tabs.Main:AddSection("TAS", "solar/videocamera-record-bold")
TasSec:AddSpace({ Height = 20 })
TasSec:AddDivider()


TasSec:AddDropdown("TASMode", {
    Title = "Play Mode",
    Values = {"Single", "Loop"},
    Search = false,
    Default = "Single",
    Callback = function(Value)
        _G.TAS_Data.Mode = Value
    end
})

RecToggle = TasSec:AddToggle("RecButtonToggle", {Title = "Show Rec Button", Default = false})

RecFrame, RecButton = CreateFloatingButton("TAS_Rec", "Rec", true)
function DoRecClick()
    if not _G.TAS_Data.Run then
        _G.TAS_Lib.StartRec()
        RecButton.Text = "Rec | On"
        RecButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    else
        _G.TAS_Data.Run = false
        RecButton.Text = "Rec | Off"
        RecButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end
RecButton.Activated:Connect(DoRecClick)

RecToggle:OnChanged(function(State)
    SetFloatingButtonVisible(RecFrame, State)
end)

AddFloatingButtonSizeInputs(TasSec, "TAS_Rec", "Rec")
AddFloatingButtonKeybind(TasSec, "TAS_Rec", "Rec", DoRecClick)

ClearToggle = TasSec:AddToggle("ClearButtonToggle", {Title = "Show Clear Button", Default = false})

ClearFrame, ClearButton = CreateFloatingButton("TAS_Clear", "Clear", false)
function DoClearClick()
    _G.TAS_Data.Run = false
    _G.TAS_Data.Playing = false
    _G.TAS_Data.Frames = {}

    ClearButton.Text = "Cleared!"
    ClearButton.TextColor3 = Color3.fromRGB(255, 200, 0)

    RecButton.Text = "Rec | Off"
    RecButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayButton.Text = "Play | Off"
    PlayButton.TextColor3 = Color3.fromRGB(255, 255, 255)

    task.wait(1)
    ClearButton.Text = "Clear"
    ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end
ClearButton.Activated:Connect(DoClearClick)

ClearToggle:OnChanged(function(State)
    SetFloatingButtonVisible(ClearFrame, State)
end)

AddFloatingButtonSizeInputs(TasSec, "TAS_Clear", "Clear")
AddFloatingButtonKeybind(TasSec, "TAS_Clear", "Clear", DoClearClick)

PlayToggle = TasSec:AddToggle("PlayButtonToggle", {Title = "Show Play Button", Default = false})

PlayFrame, PlayButton = CreateFloatingButton("TAS_Play", "Play", true)
function DoPlayClick()
    if _G.TAS_Data.Playing then
        _G.TAS_Data.Playing = false
        PlayButton.Text = "Play | Off"
        PlayButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        PlayButton.Text = "Play | On"
        PlayButton.TextColor3 = Color3.fromRGB(100, 255, 100)
        _G.TAS_Lib.Play()
        task.spawn(function()
            while _G.TAS_Data.Playing do task.wait(0.1) end
            PlayButton.Text = "Play | Off"
            PlayButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
    end
end
PlayButton.Activated:Connect(DoPlayClick)

PlayToggle:OnChanged(function(State)
    SetFloatingButtonVisible(PlayFrame, State)
end)

AddFloatingButtonSizeInputs(TasSec, "TAS_Play", "Play")
AddFloatingButtonKeybind(TasSec, "TAS_Play", "Play", DoPlayClick)

TasSec:AddDivider()
TasSec:AddSpace({ Height = 20 })

SecNextbotESP = Tabs.Combat:AddCollapsibleSection('<font color="#FF0000">Nextbot ESP</font>', "solar/danger-triangle-bold", false)

SecNextbotESP:AddToggle("BillboardNextbots", {Title = "Billboard Nextbots", Default = false }):OnChanged(function(value)
    DConfiguration.ESP.Nextbots = value
   
    while DConfiguration.ESP.Nextbots and wait(0.1) do
        for _, v in pairs(GamePlayers:GetChildren()) do
            if not Players:FindFirstChild(v.Name) and v:FindFirstChild("HumanoidRootPart") then
                local ESPName = "NextbotESP"
                local hrp
                
                if v:FindFirstChild("Hitbox") then
                   hrp = v.Hitbox
                elseif v:FindFirstChild("Base") then
                   hrp = v.Base
                elseif v:FindFirstChild("Head") then
                   hrp = v.Head
                else
                   hrp = v:FindFirstChildWhichIsA("Part")
                end
                
                if hrp and not hrp:FindFirstChild(ESPName) then
                   CreateBillboardESP(ESPName, hrp, Color3.fromRGB(255, 0, 0), 18)
                end
                
                if hrp then
	                UpdateBillboardESP(ESPName, hrp, v.Name, Color3.fromRGB(255, 0, 0), 18, Camera.CFrame.Position)
                end
            end
        end
    end
    
    if not DConfiguration.ESP.Nextbots then
	    for _, v in pairs(GamePlayers:GetDescendants()) do
            if not Players:FindFirstChild(v.Name) and v:FindFirstChild("HumanoidRootPart") then
                local hrp 
                
                if v:FindFirstChild("Hitbox") then
                   hrp = v.Hitbox
                elseif v:FindFirstChild("Base") then
                   hrp = v.Base
                elseif v:FindFirstChild("Head") then
                   hrp = v.Head
                else
                   hrp = v:FindFirstChildWhichIsA("Part")
                end
                
                if not hrp then return end
                
                DestroyBillboardESP("NextbotESP", hrp)
            end
        end
    end
end)

SecNextbotESP:AddToggle("TracersBots", {
    Title = "Tracer Nextbots",
    Default = false
}):OnChanged(function(State)
    DConfiguration.Tracers.Nextbots = State

    if not DConfiguration.Tracers.Nextbots then
        for part, _ in pairs(TracerLinesBots) do
            if typeof(part) == "Instance" then
                DestroyTracerESP(TracerLinesBots, part)
            else
                TracerLinesBots[part] = nil
            end
        end
        TracerLinesBots = {}
        return
    end

    task.spawn(function()
        while DConfiguration.Tracers.Nextbots and task.wait() do
            if not DConfiguration.Tracers.Nextbots then break end
            pcall(function()
                local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not localHRP then return end

                local gamePlayers = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
                if not gamePlayers then return end

                for _, bot in pairs(gamePlayers:GetChildren()) do
                    local hrp = bot:FindFirstChild("HumanoidRootPart")
                    if hrp and not Players:FindFirstChild(bot.Name) then
                        if not TracerLinesBots[hrp] then
                            CreateTracerESP(TracerLinesBots, hrp, 5, Color3.fromRGB(255, 0, 0))
                        end
                        UpdateTracerESP(TracerLinesBots, hrp, Color3.fromRGB(255, 0, 0))
                    end
                end

                for part, tracer in pairs(TracerLinesBots) do
                    if typeof(part) ~= "Instance" or not part.Parent then
                        DestroyTracerESP(TracerLinesBots, part)
                    elseif tracer and tracer.Visible and not part:IsDescendantOf(workspace) then
                        tracer.Visible = false
                        DestroyTracerESP(TracerLinesBots, part)
                    end
                end
            end)
        end
    end)
end)

DConfiguration.Box = DConfiguration.Box or { NextbotsModel = "2D", PlayersModel = "2D" }

SecNextbotESP:AddToggle("BoxNextbots", {Title = "Box ESP", Default = false }):OnChanged(function(value)
    DConfiguration.Box.Nextbots = value

    while DConfiguration.Box.Nextbots and wait(0.1) do
        for _, v in pairs(GamePlayers:GetChildren()) do
            if not Players:FindFirstChild(v.Name) and v:FindFirstChild("HumanoidRootPart") then
                local hrp = v:FindFirstChild("HumanoidRootPart")

                if DConfiguration.Box.NextbotsModel == "3D" then
                    DestroyHighlightESP("NextbotHighlight", v)
                    if hrp then hrp.Transparency = 1 end

                    if not v:FindFirstChild("ESP_3DBox") then
                        Create3DBoxESP(v, Color3.fromRGB(255, 0, 0), Vector3.new(4, 5, 3))
                    else
                        Update3DBoxESPColor(v, Color3.fromRGB(255, 0, 0))
                    end
                else
                    Destroy3DBoxESP(v)

                    if not v:FindFirstChild("NextbotHighlight") then
                        CreateHighlightESP("NextbotHighlight", v, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), DConfiguration.Highlight.OutlineOnly)
                    end
                    UpdateHighlightESP("NextbotHighlight", v, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), DConfiguration.Highlight.OutlineOnly)
                    if hrp then hrp.Transparency = 0.1 end
                end
            end
        end
    end

    if not DConfiguration.Box.Nextbots then
        for _, v in pairs(GamePlayers:GetDescendants()) do
            if not Players:FindFirstChild(v.Name) and v:FindFirstChild("HumanoidRootPart") then
                local hrp = v:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Transparency = 1 end
                DestroyHighlightESP("NextbotHighlight", v)
                Destroy3DBoxESP(v)
            end
        end
    end
end)

SecNextbotESP:AddDropdown("NextbotBoxModel", {
    Search = false,
    Title = "Box Model",
    Values = {"2D", "3D"},
    Default = "2D",
    Callback = function(value)
        DConfiguration.Box.NextbotsModel = value
    end,
})

Tabs.Combat:AddDivider()
Tabs.Combat:AddSpace({ Height = 15 })
Tabs.Combat:AddDivider()

SecSurvivorESP = Tabs.Combat:AddCollapsibleSection('<font color="#00AAFF">Survivor ESP</font>', "solar/user-bold", false)

SecSurvivorESP:AddToggle("BillboardPlayers", {Title = "Billboard Survivors", Default = false }):OnChanged(function(value)
    DConfiguration.ESP.Players = value
   
    while DConfiguration.ESP.Players and wait(0.1) do
	    for _, v in pairs(Players:GetPlayers()) do
			if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			    local ESPName = "PlayerESP"
				local PlayerChar = v.Character
				
                if PlayerChar then
					if not PlayerChar.HumanoidRootPart:FindFirstChild(ESPName) then
					   CreateBillboardESP(ESPName, PlayerChar.HumanoidRootPart, Color3.fromRGB(0, 170, 255), 14)
					end
				
					local PlayerStats = GamePlayers:FindFirstChild(v.Name)
					if PlayerStats and PlayerStats:GetAttribute("Downed") == true then
						UpdateBillboardESP(ESPName, PlayerChar.HumanoidRootPart, v.Name, Color3.fromRGB(0, 255, 0), 14, Camera.CFrame.Position)
					else
						UpdateBillboardESP(ESPName, PlayerChar.HumanoidRootPart, v.Name, Color3.fromRGB(0, 170, 255), 14, Camera.CFrame.Position)
					end
				end
			end
		end
    end

   if not DConfiguration.ESP.Players then
	   for _, v in pairs(Players:GetPlayers()) do
			if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
				DestroyBillboardESP("PlayerESP", v.Character.HumanoidRootPart)
		 	end
		 end
     end
end)

SecSurvivorESP:AddToggle("TracersPlayers", {
    Title = "Tracer Survivors",
    Default = false
}):OnChanged(function(State)
    DConfiguration.Tracers.Players = State

    if not DConfiguration.Tracers.Players then
        for part, _ in pairs(TracerLines) do
            if typeof(part) == "Instance" then
                DestroyTracerESP(TracerLines, part)
            else
                TracerLines[part] = nil
            end
        end
        TracerLines = {}
        return
    end

    task.spawn(function()
        while DConfiguration.Tracers.Players and task.wait() do
            if not DConfiguration.Tracers.Players then break end
            pcall(function()
                local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not localHRP then return end

                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            if not TracerLines[hrp] then
                                CreateTracerESP(TracerLines, hrp, 2, Color3.fromRGB(0, 170, 255))
                            end

                            local color = Color3.fromRGB(0, 170, 255)
                            local gamePlayer = workspace:FindFirstChild("Game") and workspace.Game.Players:FindFirstChild(player.Name)
                            if gamePlayer and gamePlayer:GetAttribute("Downed") then
                                color = Color3.fromRGB(0, 255, 0)
                            end

                            UpdateTracerESP(TracerLines, hrp, color)
                        end
                    end
                end

                for part, tracer in pairs(TracerLines) do
                    if typeof(part) ~= "Instance" or not part.Parent then
                        DestroyTracerESP(TracerLines, part)
                    elseif tracer and tracer.Visible and not part:IsDescendantOf(workspace) then
                        tracer.Visible = false
                        DestroyTracerESP(TracerLines, part)
                    end
                end
            end)
        end
    end)
end)

SecSurvivorESP:AddToggle("BoxPlayers", {Title = "Box ESP", Default = false }):OnChanged(function(value)
    DConfiguration.Box.Players = value

    while DConfiguration.Box.Players and wait(0.1) do
	    for _, v in pairs(Players:GetPlayers()) do
			if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
				local PlayerChar = v.Character
				local PlayerStats = GamePlayers:FindFirstChild(v.Name)
				local BoxColor = Color3.fromRGB(0, 170, 255)
				if PlayerStats and PlayerStats:GetAttribute("Downed") == true then
					BoxColor = Color3.fromRGB(0, 255, 0)
				end

				if DConfiguration.Box.PlayersModel == "3D" then
					DestroyHighlightESP("PlayerHighlight_D", PlayerChar)

					if not PlayerChar:FindFirstChild("ESP_3DBox") then
						Create3DBoxESP(PlayerChar, BoxColor, Vector3.new(3, 5, 2))
					else
						Update3DBoxESPColor(PlayerChar, BoxColor)
					end
				else
					Destroy3DBoxESP(PlayerChar)

					if not PlayerChar:FindFirstChild("PlayerHighlight_D") then
						CreateHighlightESP("PlayerHighlight_D", PlayerChar, BoxColor, BoxColor, DConfiguration.Highlight.OutlineOnly)
					end
					UpdateHighlightESP("PlayerHighlight_D", PlayerChar, BoxColor, BoxColor, DConfiguration.Highlight.OutlineOnly)
				end
			end
		end
    end

   if not DConfiguration.Box.Players then
	   for _, v in pairs(Players:GetPlayers()) do
			if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
				DestroyHighlightESP("PlayerHighlight_D", v.Character)
				Destroy3DBoxESP(v.Character)
		 	end
		 end
     end
end)

SecSurvivorESP:AddDropdown("PlayerBoxModel", {
    Search = false,
    Title = "Box Model",
    Values = {"2D", "3D"},
    Default = "2D",
    Callback = function(value)
        DConfiguration.Box.PlayersModel = value
    end,
})

Tabs.Combat:AddDivider()
Tabs.Combat:AddSpace({ Height = 15 })
Tabs.Combat:AddDivider()

SecDownedESP = Tabs.Combat:AddCollapsibleSection('<font color="#00FF00">Downed Player ESP</font>', "solar/heart-broken-bold", false)

SecDownedESP:AddToggle("DownedESP", {Title = "Downed Billboard", Default = false }):OnChanged(function(value)
    DConfiguration.DownedESP = value

    while DConfiguration.DownedESP and wait(0.1) do
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local ESPName = "DownedBillboard"
                local PlayerStats = GamePlayers:FindFirstChild(v.Name)
                local IsDowned = PlayerStats and PlayerStats:GetAttribute("Downed") == true

                if IsDowned then
                    if not v.Character.HumanoidRootPart:FindFirstChild(ESPName) then
                        CreateBillboardESP(ESPName, v.Character.HumanoidRootPart, Color3.fromRGB(0, 255, 0), 20)
                    end
                    UpdateBillboardESP(ESPName, v.Character.HumanoidRootPart, "DOWNED", Color3.fromRGB(0, 255, 0), 20, Camera.CFrame.Position)
                else
                    DestroyBillboardESP(ESPName, v.Character.HumanoidRootPart)
                end
            end
        end
    end

    if not DConfiguration.DownedESP then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                DestroyBillboardESP("DownedBillboard", v.Character.HumanoidRootPart)
            end
        end
    end
end)

SecDownedESP:AddToggle("BoxDowned", {Title = "Box ESP", Default = false }):OnChanged(function(value)
    DConfiguration.Box.Downed = value

    while DConfiguration.Box.Downed and wait(0.1) do
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local PlayerChar = v.Character
                local PlayerStats = GamePlayers:FindFirstChild(v.Name)
                local IsDowned = PlayerStats and PlayerStats:GetAttribute("Downed") == true

                if IsDowned then
                    if DConfiguration.Box.DownedModel == "3D" then
                        DestroyHighlightESP("DownedHighlight", PlayerChar)
                        if not PlayerChar:FindFirstChild("ESP_3DBox") then
                            Create3DBoxESP(PlayerChar, Color3.fromRGB(0, 255, 0), Vector3.new(3, 5, 2))
                        else
                            Update3DBoxESPColor(PlayerChar, Color3.fromRGB(0, 255, 0))
                        end
                    else
                        Destroy3DBoxESP(PlayerChar)
                        if not PlayerChar:FindFirstChild("DownedHighlight") then
                            CreateHighlightESP("DownedHighlight", PlayerChar, Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 0), DConfiguration.Highlight.OutlineOnly)
                        end
                        UpdateHighlightESP("DownedHighlight", PlayerChar, Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 0), DConfiguration.Highlight.OutlineOnly)
                    end
                else
                    DestroyHighlightESP("DownedHighlight", PlayerChar)
                    Destroy3DBoxESP(PlayerChar)
                end
            end
        end
    end

    if not DConfiguration.Box.Downed then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                DestroyHighlightESP("DownedHighlight", v.Character)
                Destroy3DBoxESP(v.Character)
            end
        end
    end
end)

SecDownedESP:AddDropdown("DownedBoxModel", {
    Search = false,
    Title = "Box Model",
    Values = {"2D", "3D"},
    Default = "2D",
    Callback = function(value)
        DConfiguration.Box.DownedModel = value
    end,
})


SecNextbotModification = Tabs.Combat:AddSection("Nextbot Modification", "solar/danger-triangle-bold")
SecNextbotModification:AddSpace({ Height = 20 })
SecNextbotModification:AddDivider()


Toggle = SecNextbotModification:AddToggle("AntiNextbotToggle", {Title = "Anti Nextbot Toggle", Default = false })

    Toggle:OnChanged(function(value)
    DConfiguration.Nextbots.AntiNextbot = value
        
    while DConfiguration.Nextbots.AntiNextbot and wait(0.1) do
          spawn(DFunctions.AntiNextbot)
       end
    end)

Dropdown = SecNextbotModification:AddDropdown("AntiBotTeleport", {
        Title = "Anti Nextbot Teleport Type",
        Values = {"Spawn", "Players"},
        Multi = false,
        Search = false,
        Default = 1,
    })

    Dropdown:OnChanged(function(Value)
        DConfiguration.Nextbots.AntiNextbotType = Value
    end)
    
  SecNextbotModification:AddInput("NextbotDistance", {
    Title = "Anti Nextbot Distance",
    Default = 15,
    Placeholder = "Number",
    Numeric = false, 
    Finished = false, 
    Callback = function(Value)
        DConfiguration.Nextbots.AntiNextbotRange = tonumber(Value) or 15 
    end
})

wait(Duration)

SecNextbotModification:AddDivider()
SecNextbotModification:AddSpace({ Height = 20 })

SecAutoCarry = Tabs.Combat:AddSection("Auto Carry", "solar/wheelchair-bold")
SecAutoCarry:AddSpace({ Height = 20 })
SecAutoCarry:AddDivider()

AutoCarryEnabled = false
AutoCarryConnection = nil
AutoCarryTarget = "Nearest"
AutoCarryDistance = 20

function StartAutoCarry()
    local LastCarryTime = 0
    AutoCarryConnection = RunService.Heartbeat:Connect(function()
        if not AutoCarryEnabled then return end
        if os.clock() - LastCarryTime < 0.3 then return end

        local Character = LocalPlayer.Character
        if not Character then return end
        if Character:GetAttribute("Carrying") == true then return end

        local HRP = Character:FindFirstChild("HumanoidRootPart")
        if not HRP then return end

        local BestTarget = nil
        local BestDistance = AutoCarryDistance

        for _, Other in ipairs(Players:GetPlayers()) do
            if Other ~= LocalPlayer and Other.Character then
                local OtherHRP = Other.Character:FindFirstChild("HumanoidRootPart")
                local OtherHumanoid = Other.Character:FindFirstChild("Humanoid")

                if OtherHRP and OtherHumanoid then
                    local IsDowned = Other.Character:GetAttribute("Downed") == true

                    if IsDowned then
                        local IsValidTarget = true
                        if AutoCarryTarget == "Friend" then
                            IsValidTarget = pcall(function() return LocalPlayer:IsFriendsWith(Other.UserId) end) and LocalPlayer:IsFriendsWith(Other.UserId)
                        end

                        if IsValidTarget then
                            local Distance = (HRP.Position - OtherHRP.Position).Magnitude
                            if Distance <= BestDistance then
                                BestDistance = Distance
                                BestTarget = Other
                            end
                        end
                    end
                end
            end
        end

        if BestTarget then
            LastCarryTime = os.clock()
            pcall(function()
                ReplicatedStorage:WaitForChild("Events"):WaitForChild("Revive"):WaitForChild("CarryPlayer"):FireServer(BestTarget.Name)
            end)
        end
    end)
end

function StopAutoCarry()
    if AutoCarryConnection then
        AutoCarryConnection:Disconnect()
        AutoCarryConnection = nil
    end
end

SecAutoCarry:AddToggle("AutoCarryToggle", {Title = "Auto Carry", Default = false}):OnChanged(function(State)
    AutoCarryEnabled = State
    if State then
        StartAutoCarry()
    else
        StopAutoCarry()
    end
end)

SecAutoCarry:AddDivider()
SecAutoCarry:AddSpace({ Height = 10 })
SecAutoCarry:AddDivider()

AutoCarryFrame, AutoCarryButton = CreateFloatingButton("AutoCarryGui", "Auto Carry", true)
function DoAutoCarryToggle()
    AutoCarryEnabled = not AutoCarryEnabled
    SetFloatingButtonActive(AutoCarryButton, AutoCarryEnabled, "Auto Carry")
    if AutoCarryEnabled then
        StartAutoCarry()
    else
        StopAutoCarry()
    end
end
AutoCarryButton.Activated:Connect(DoAutoCarryToggle)

SecAutoCarry:AddToggle("AutoCarryShowButton", {Title = "Show Auto Carry Button", Default = false}):OnChanged(function(State)
    SetFloatingButtonVisible(AutoCarryFrame, State)
end)

AddFloatingButtonSizeInputs(SecAutoCarry, "AutoCarryGui", "Auto Carry")
AddFloatingButtonKeybind(SecAutoCarry, "AutoCarryGui", "Auto Carry", DoAutoCarryToggle)

SecAutoCarry:AddDivider()
SecAutoCarry:AddSpace({ Height = 10 })
SecAutoCarry:AddDivider()

SecAutoCarry:AddDropdown("AutoCarryTargetDropdown", {
    Search = false,
    Title = "Target Carry",
    Values = {"Nearest", "Friend"},
    Default = "Nearest",
    Callback = function(Value)
        AutoCarryTarget = Value
    end,
})

SecAutoCarry:AddInput("AutoCarryDistanceInput", {
    Title = "Carry Distance",
    Default = tostring(AutoCarryDistance),
    Placeholder = "20",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local Num = tonumber(Value)
        if Num and Num > 0 then
            AutoCarryDistance = Num
        end
    end,
})

SecPlayerAdjustments = Tabs.Misc:AddSection("Player Adjustments", "solar/user-hand-up-bold")
SecPlayerAdjustments:AddSpace({ Height = 20 })
SecPlayerAdjustments:AddDivider()

SecPlayerAdjustments:AddInput("PlayerSpeed", {
        Title = "Player Speed",
        Description = "",
        Default = "1500",
        Placeholder = "Speed Number",
        Numeric = false, 
        Finished = false, 
        Callback = function(Value)
            DConfiguration.Misc.PlayerAdjustment.Update.Speed = tonumber(Value) or 1500
            DConfiguration.Misc.PlayerAdjustment.Saved.Speed = tonumber(Value) or 1500
        end
    })
    
 SecPlayerAdjustments:AddInput("PlayerJump", {
        Title = "Player Jump",
        Description = "",
        Default = "3",
        Placeholder = "Jump Number",
        Numeric = false, 
        Finished = false, 
        Callback = function(Value)
            DConfiguration.Misc.PlayerAdjustment.Update.JumpHeight = tonumber(Value) or 3
            DConfiguration.Misc.PlayerAdjustment.Saved.JumpHeight = tonumber(Value) or 3
        end
    })
    
 SecPlayerAdjustments:AddInput("PlayerStrafeAcceleration", {
        Title = "Player Strafe Acceleration",
        Description = "",
        Default = "182",
        Placeholder = "Number",
        Numeric = false, 
        Finished = false, 
        Callback = function(Value)
            DConfiguration.Misc.PlayerAdjustment.Update.AirStrafe = tonumber(Value) or 182
            DConfiguration.Misc.PlayerAdjustment.Saved.AirStrafe = tonumber(Value) or 182
        end
    })
    
SecPlayerAdjustments:AddDivider()
SecPlayerAdjustments:AddSpace({ Height = 20 })

SecPlayerAdjustments:AddSpace({ Height = 20 })
SecPlayerAdjustments:AddDivider()
    

SecWalkspeed = Tabs.Misc:AddSection("Walkspeed", "solar/run-bold")
SecWalkspeed:AddSpace({ Height = 20 })
SecWalkspeed:AddDivider()

Toggle = SecWalkspeed:AddToggle("PlayerWalkspeed", {Title = "Walkspeed Toggle", Default = false })

    Toggle:OnChanged(function(State)
        DConfiguration.Misc.Humanoids.WalkspeedCF = State
 
        while DConfiguration.Misc.Humanoids.WalkspeedCF and wait(0.01) do
            local hb = RunService.Heartbeat
            local speaker = game.Players.LocalPlayer
            local chr = speaker.Character
            local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
            local delta = hb:Wait()

            if chr and hum.MoveDirection.Magnitude > 0 then
               chr:TranslateBy(hum.MoveDirection * DConfiguration.Misc.Humanoids.CF * delta * 10)
           end
        end
    end)

 SecWalkspeed:AddInput("PlayerWalkCf", {
        Title = "Player Walkspeed",
        Default = "5",
        Placeholder = "Walk Number",
        Numeric = false, 
        Finished = false, 
        Callback = function(Value)
            DConfiguration.Misc.Humanoids.CF = tonumber(Value) or 5
        end
    })
    

SecWalkspeed:AddDivider()
SecWalkspeed:AddSpace({ Height = 20 })

SecUtilities = Tabs.Misc:AddSection("Utilities", "solar/widget-bold")
SecUtilities:AddSpace({ Height = 20 })
SecUtilities:AddDivider()


Toggle = SecUtilities:AddToggle("LagSwitch", {Title = "Lag Switch (Button)", Default = false})

LagSwitchFrame, LagSwitchButton = CreateFloatingButton("LagSwitchButton", "Start Lag", false)
function DoLagSwitchClick()
    task.spawn(function()
        DFunctions.StartLag(DConfiguration.Misc.Utilities.LagSwitch.MSDelay)
    end)
    LagSwitchButton.Text = "..."
    wait(0.1)
    LagSwitchButton.Text = "Start Lag"
end
LagSwitchButton.Activated:Connect(DoLagSwitchClick)

Toggle:OnChanged(function(State)
    SetFloatingButtonVisible(LagSwitchFrame, State)
end)

AddFloatingButtonSizeInputs(SecUtilities, "LagSwitchButton", "Start Lag")
AddFloatingButtonKeybind(SecUtilities, "LagSwitchButton", "Start Lag", DoLagSwitchClick, "F12")
    
 SecUtilities:AddInput("DelayMS", {
        Title = "Delay MS",
        Default = "200",
        Placeholder = "Value",
        Numeric = false,
        Finished = false, 
        Callback = function(Value)
            DConfiguration.Misc.Utilities.LagSwitch.MSDelay = tonumber(Value) or 200
        end
    })
    
Dropdown = SecUtilities:AddDropdown("LagMode", {
        Title = "Lag Mode",
        Values = {"Normal", "Demon", "FastFlag"},
        Multi = false,
        Search = false,
        Default = 1,
    })

    Dropdown:OnChanged(function(Value)
        DConfiguration.Misc.Utilities.LagSwitch.Mode = Value
    end)

SecUtilities:AddDivider()
SecUtilities:AddSpace({ Height = 20 })

SecUtilities:AddSpace({ Height = 20 })
SecUtilities:AddDivider()
    
SecBounceModification = Tabs.Misc:AddSection("Bounce Modification", "solar/arrow-up-bold")
SecBounceModification:AddSpace({ Height = 20 })
SecBounceModification:AddDivider()

Toggle = SecBounceModification:AddToggle("AdjustBounce", {Title = "Modify Bounce", Default = false })

Toggle:OnChanged(function(State)
    DConfiguration.Misc.Utilities.BounceModification.Enabled = State
     
    while DConfiguration.Misc.Utilities.BounceModification.Enabled and wait(0.1) do
        spawn(DFunctions.BounceFunction)
    end
end)

 SecBounceModification:AddInput("PlayerBounce", {
        Title = "Player Bounce",
        Default = "80",
        Placeholder = "Bounce Number",
        Numeric = false,
        Finished = false, 
        Callback = function(Value)
            DConfiguration.Misc.Utilities.BounceModification.DefaultBounce = tonumber(Value) or 80
        end
    })
    
 SecBounceModification:AddInput("EmoteBounce", {
        Title = "Emote Bounce",
        Default = "120",
        Placeholder = "Bounce Number",
        Numeric = false, 
        Finished = false, 
        Callback = function(Value)
            DConfiguration.Misc.Utilities.BounceModification.EmoteBounce = tonumber(Value) or 120
        end
    })
    
SecBounceModification:AddDivider()
SecBounceModification:AddSpace({ Height = 20 })

SecBounceModification:AddSpace({ Height = 20 })
SecBounceModification:AddDivider()
    
SecEasyBounce = Tabs.Misc:AddSection("Easy Bounce", "solar/rocket-bold")
SecEasyBounce:AddSpace({ Height = 20 })
SecEasyBounce:AddDivider()

LP = game.Players.LocalPlayer
RS = game:GetService("RunService")
Cam = workspace.CurrentCamera

getgenv().EasyBounce = getgenv().EasyBounce or {
    Enabled = false,
    Mode = "Forward",
    BaseSpeed = 50,
    ExtraSpeed = 100
}

EB = getgenv().EasyBounce

state = {
    speed = EB.BaseSpeed,
    last = tick(),
    airTick = 0,
    airSum = 0,
    airborne = false,
    bv = nil
}

function getMeter()
    local ok, v = pcall(function()
        return LP.PlayerGui.Shared.HUD.Overlay.Default.CharacterInfo.Item.Speedometer.Players
    end)
    return ok and v or nil
end

function cut(n) return math.floor(n * 10) / 10 end

function resetPhysics(hrp, hum)
    if state.bv then 
        state.bv:Destroy() 
        state.bv = nil 
    end
    if hrp then
        for _, child in ipairs(hrp:GetChildren()) do
            if (child:IsA("BodyVelocity") and child.Name == "BodyVelocity") or child:IsA("BodyForce") then
                child:Destroy()
            end
        end
    end
    state.speed = EB.BaseSpeed
    state.airTick, state.airSum, state.airborne = 0, 0, false
end

RS.RenderStepped:Connect(function()
    local ch = LP.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local hum = ch and ch:FindFirstChild("Humanoid")
    
    if _G.Fly or not EB.Enabled then
        resetPhysics(hrp, hum)
        return 
    end

    if not hrp or not hum then return end

    local dt = tick() - state.last
    state.last = tick()

    local inAir = hum.FloorMaterial == Enum.Material.Air
    local spdUI = getMeter()

    if state.airborne and not inAir then
        state.speed = math.max(EB.BaseSpeed, state.speed - 10)
        if spdUI then spdUI.Text = cut(state.speed) end
        state.airSum = 0
    end
    state.airborne = inAir

    local shouldPush = true

    if shouldPush then
        if inAir then
            state.airSum = state.airSum + dt
            state.airTick = state.airTick + dt
            while state.airTick >= 0.04 do
                state.airTick = state.airTick - 0.04
                state.speed = math.min(EB.BaseSpeed + EB.ExtraSpeed, state.speed + 0.1)
            end
        else
            state.airTick, state.airSum = 0, 0
            state.speed = math.max(EB.BaseSpeed, state.speed - (2.5 * dt))
        end

        if not state.bv or state.bv.Parent ~= hrp then
            if state.bv then state.bv:Destroy() end
            state.bv = Instance.new("BodyVelocity")
            state.bv.Parent = hrp
        end
        
        local camDir = Cam.CFrame.LookVector
        local moveDir = Vector3.new(camDir.X, 0, camDir.Z).Unit
        
        if EB.Mode == "Back" then
            moveDir = -moveDir
        end

        state.bv.Velocity = moveDir * state.speed
        state.bv.MaxForce = Vector3.new(4e5, 0, 4e5) 

        if spdUI then spdUI.Text = cut(state.speed) end
    else
        if state.bv then
            state.bv.MaxForce = Vector3.new(0, 0, 0) 
            state.bv.Velocity = Vector3.new(0, 0, 0)
        end
        state.speed = EB.BaseSpeed
    end
end)

SecEasyBounce:AddDropdown("EB_ModeDropdown", {
    Title = "Easy Bounce Mode",
    Values = {"Forward", "Back"},
    Search = false,
    Default = EB.Mode,
    Callback = function(v)
        EB.Mode = v
    end
})

SecEasyBounce:AddInput("EB_Base", {
    Title = "Base Speed", 
    Default = tostring(EB.BaseSpeed), 
    Numeric = true, 
    Finished = true, 
    Callback = function(v) 
        EB.BaseSpeed = tonumber(v) or 50 
        if getgenv().UpdateBounceSpeed then
            getgenv().UpdateBounceSpeed(EB.BaseSpeed)
        end
    end
})

SecEasyBounce:AddInput("EB_Extra", {
    Title = "Extra Speed (Boost)", 
    Default = tostring(EB.ExtraSpeed), 
    Numeric = true, 
    Finished = true, 
    Callback = function(v) 
        EB.ExtraSpeed = tonumber(v) or 100 
    end
})

EBFrame, EBButton = CreateFloatingButton("EB_Btn", "Bounce", true)
function DoEBToggle()
    EB.Enabled = not EB.Enabled
    SetFloatingButtonActive(EBButton, EB.Enabled, "Bounce")
end
EBButton.Activated:Connect(DoEBToggle)

SecEasyBounce:AddToggle("EB_BtnShow", {
    Title = "Easy Bounce (Button)", 
    Default = false
}):OnChanged(function(s)
    SetFloatingButtonVisible(EBFrame, s)
    if not s then
        EB.Enabled = false
    end
end)

AddFloatingButtonSizeInputs(SecEasyBounce, "EB_Btn", "Bounce")
AddFloatingButtonKeybind(SecEasyBounce, "EB_Btn", "Bounce", DoEBToggle)

SecEasyBounce:AddDivider()
SecEasyBounce:AddSpace({ Height = 20 })

SecEasyBounce:AddSpace({ Height = 20 })
SecEasyBounce:AddDivider()
    
SecPlatformSpawner = Tabs.Misc:AddSection("Platform Spawner", "solar/layers-bold")
SecPlatformSpawner:AddSpace({ Height = 20 })
SecPlatformSpawner:AddDivider()

    do
    local PlatData = {
        Enabled = false,
        Size = 10,
        Transparency = 0.1,
        List = {}
    }

    local function ClearPlates()
        for _, p in pairs(PlatData.List) do
            if p and p.Parent then p:Destroy() end
        end
        PlatData.List = {}
    end

    local function GetFolder()
        local g = workspace:FindFirstChild("Game")
        local m = g and g:FindFirstChild("Map")
        local p = m and m:FindFirstChild("Parts")
        return p and p:FindFirstChild("ImmovableProps")
    end

    local function CreatePlates()
        ClearPlates()
        if not PlatData.Enabled then return end
        local folder = GetFolder()
        if not folder then return end
        
        for _, obj in pairs(folder:GetChildren()) do
            if obj.Name == "Cactus1" or obj.Name == "Cactus2" then
                local pos, size
                if obj:IsA("Model") then
                    local cf, s = obj:GetBoundingBox()
                    pos, size = cf.Position, s
                elseif obj:IsA("BasePart") then
                    pos, size = obj.Position, obj.Size
                end

                if pos and size then
                    local p = Instance.new("Part")
                    p.Name = "GoonWares"
                    p.Size = Vector3.new(PlatData.Size, 1, PlatData.Size)
                    p.Anchored, p.CanCollide = true, true
                    p.Material = Enum.Material.Neon
                    p.Transparency = PlatData.Transparency
                    p.Color = Color3.fromRGB(0, 255, 150)
                    p.Position = pos + Vector3.new(0, (size.Y / 2) + 0.5, 0)
                    p.Parent = workspace
                    table.insert(PlatData.List, p)
                end
            end
        end
    end

    SecPlatformSpawner:AddToggle("CactusToggle", {
        Title = "Cactus Platform",
        Default = false,
        Callback = function(Value)
            PlatData.Enabled = Value
            CreatePlates()
        end
    })

    SecPlatformSpawner:AddInput("CactusTransInput", {
        Title = "Platform Transparency (0-1)",
        Description = "make platforms invisible 3-5",
        Default = "0.5",
        Numeric = true,
        Finished = true,
        Callback = function(Value)
            local num = tonumber(Value) or 0.5
            PlatData.Transparency = math.clamp(num, 0, 1)
            for _, p in pairs(PlatData.List) do
                if p and p.Parent then p.Transparency = PlatData.Transparency end
            end
        end
    })

    SecPlatformSpawner:AddInput("CactusSizeInput", {
        Title = "Platform Size",
        Default = "12",
        Numeric = true,
        Finished = true,
        Callback = function(Value)
            PlatData.Size = tonumber(Value) or 12
            if PlatData.Enabled then CreatePlates() end
        end
    })

    task.spawn(function()
        while task.wait(3) do
            if PlatData.Enabled and #PlatData.List == 0 then
                CreatePlates()
            end
        end
    end)
end
    

SecPlatformSpawner:AddDivider()
SecPlatformSpawner:AddSpace({ Height = 20 })

SecCameraAdjustment = Tabs.Misc:AddSection("Camera Adjustment", "solar/camera-bold")
SecCameraAdjustment:AddSpace({ Height = 20 })
SecCameraAdjustment:AddDivider()


if not _G.Phantom then
    _G.Phantom = {}
end
_G.Phantom.ResolutionValue = 1
a = workspace.CurrentCamera
if _G.PhantomCameraLoop == nil then
    _G.PhantomCameraLoop =
        game:GetService("RunService").RenderStepped:Connect(
        function()
            local b = _G.Phantom.ResolutionValue
            if b and b ~= 1 then
                a.CFrame = a.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, b, 0, 0, 0, 1)
            end
        end
    )
end

SecCameraAdjustment:AddInput("PhantomFOV", {
        Title = "Stretch",
        Description = "write 0.8 or 0.1",
        Default = "1",
        Placeholder = "",
        Numeric = false,
        Finished = false,
        Callback = function(c)
            local d = tonumber(c)
            if d and d > 0 then
                _G.Phantom.ResolutionValue = d
            else
                _G.Phantom.ResolutionValue = 1
            end
        end
    }
)

_G.FinalStrictFOV = 100

if _G.StrictFovLoop then
    _G.StrictFovLoop:Disconnect()
    _G.StrictFovLoop = nil
end

if _G.FovChangedConnection then
    _G.FovChangedConnection:Disconnect()
    _G.FovChangedConnection = nil
end

camera = workspace.CurrentCamera

function enforceFov()
    if camera and camera.FieldOfView ~= _G.FinalStrictFOV then
        camera.FieldOfView = _G.FinalStrictFOV
    end
end

if camera then
    camera.FieldOfView = _G.FinalStrictFOV
    _G.FovChangedConnection = camera:GetPropertyChangedSignal("FieldOfView"):Connect(enforceFov)
end

SecCameraAdjustment:AddInput("PlayerFOV", {
    Title = "Player FOV",
    Description = "Minimum 30 │ Max 120",
    Default = "100",
    Placeholder = "FOV Number",
    Numeric = true,
    Finished = false,
    Callback = function(text)
        local number = tonumber(text)
        if number and number >= 30 and number <= 120 then
            _G.FinalStrictFOV = number
            if workspace.CurrentCamera then
                workspace.CurrentCamera.FieldOfView = number
            end
        end
    end
})



SecCameraAdjustment:AddDivider()
SecCameraAdjustment:AddSpace({ Height = 20 })

SecGameAutomations = Tabs.Misc:AddSection("Game Automations", "solar/programming-bold")
SecGameAutomations:AddSpace({ Height = 20 })
SecGameAutomations:AddDivider()


Toggle = SecGameAutomations:AddToggle("MacroMode", {Title = "Macro Button Toggle", Default = false})

MacroButton1Frame, MacroButton1Button = CreateFloatingButton("MacroButton1", "Emote or Crouch", false)
function DoMacro1Click()
    game:GetService("ReplicatedStorage").Events.Emote:FireServer(DConfiguration.Misc.GameAutomation.SelectedPrimary)
    LocalPlayer.Character.Communicator:InvokeServer("Crouching", true)
end
MacroButton1Button.Activated:Connect(DoMacro1Click)

MacroButton2Frame, MacroButton2Button = CreateFloatingButton("MacroButton2", "Crouch", false)
MacroCrouchState = false
function DoMacro2Click()
    MacroCrouchState = not MacroCrouchState
    LocalPlayer.Character.Communicator:InvokeServer("Crouching", MacroCrouchState)
    MacroButton2Button.Text = MacroCrouchState and "Uncrouch" or "Crouch"
end
MacroButton2Button.Activated:Connect(DoMacro2Click)

Toggle:OnChanged(function(State)
    SetFloatingButtonVisible(MacroButton1Frame, State)
    SetFloatingButtonVisible(MacroButton2Frame, State)
end)

AddFloatingButtonSizeInputs(SecGameAutomations, "MacroButton1", "Emote or Crouch")
AddFloatingButtonSizeInputs(SecGameAutomations, "MacroButton2", "Uncrouch")
AddFloatingButtonKeybind(SecGameAutomations, "MacroButton1", "Emote or Crouch", DoMacro1Click)
AddFloatingButtonKeybind(SecGameAutomations, "MacroButton2", "Crouch/Uncrouch", DoMacro2Click, "LeftControl")
    
 local Dropdown = SecGameAutomations:AddDropdown("SelectionEmoteSlot", {
        Title = "Select Emote Slots",
        Values = {"1", "2", "3", "4", "5", "6"},
        Multi = false,
        DropdownOutsideWindow = true,
        Search = true,
        Default = 1,
    })

    Dropdown:OnChanged(function(Value)
        DConfiguration.Misc.GameAutomation.SelectedPrimary = Value
    end)
    

SecGameAutomations:AddDivider()
SecGameAutomations:AddSpace({ Height = 20 })

SecMovementModification = Tabs.Misc:AddSection("Movement Modification", "solar/running-round-bold")
SecMovementModification:AddSpace({ Height = 20 })
SecMovementModification:AddDivider()


Toggle = SecMovementModification:AddToggle("SprintEmoteDash", {Title = "Aggressive Emote Dash", Default = false })

Toggle:OnChanged(function(State)
	DConfiguration.Misc.MovementModification.EmoteModification.AggressiveEmoteDash.Enabled = State
	
	if not DConfiguration.Misc.MovementModification.EmoteModification.AggressiveEmoteDash.Enabled then
	    DConfiguration.Misc.PlayerAdjustment.Debounce.GroundAcceleration = false
	    DConfiguration.Misc.PlayerAdjustment.Update.Speed = DConfiguration.Misc.PlayerAdjustment.Saved.Speed
	end
end)

Dropdown = SecMovementModification:AddDropdown("SprintEmoteType", {
        Title = "Aggressive Emote Type",
        Values = {"Legit", "Blatant"},
        Multi = false,
        Search = false,
        Default = 2,
    })

    Dropdown:OnChanged(function(Value)
        DConfiguration.Misc.MovementModification.EmoteModification.AggressiveEmoteDash.Type = Value
    end)
    
 SecMovementModification:AddInput("EmoteSpeed", {
        Title = "Aggressive Emote Speed",
        Default = "2000",
        Placeholder = "Emote Speed Number",
        Numeric = false, 
        Finished = false, 
        Callback = function(Value)
            DConfiguration.Misc.MovementModification.EmoteModification.AggressiveEmoteDash.Speed = tonumber(Value) or 2000
        end
    })
    
    
    
SecMovementModification:AddInput("CrouchSpeed", {
        Title = "Aggressive Emote Acceleration (Negative Only)",
        Default = "-2",
        Placeholder = "Acceleration Number",
        Numeric = false, 
        Finished = false, 
        Callback = function(Value)
            DConfiguration.Misc.MovementModification.EmoteModification.AggressiveEmoteDash.Acceleration = tonumber(Value) or 0.2
        end
    })
    

SecMovementModification:AddDivider()
SecMovementModification:AddSpace({ Height = 20 })

SecMovementModification:AddSpace({ Height = 20 })
SecMovementModification:AddDivider()
    
SecEmoteMovement = Tabs.Misc:AddSection("Emote Movement", "solar/star-bold")
SecEmoteMovement:AddSpace({ Height = 20 })
SecEmoteMovement:AddDivider()

Toggle = SecEmoteMovement:AddToggle("ModifyEmote", {
    Title = "Modify Emote Movement",
    Default = false
})

Toggle:OnChanged(function(State)
    DConfiguration.Misc.MovementModification.EmoteModification.ModifyEmote.Enabled = State  

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if not State then return end

    connection = RunService.RenderStepped:Connect(function(dt)
        if not DConfiguration.Misc.MovementModification.EmoteModification.ModifyEmote.Enabled then
            connection:Disconnect()
            connection = nil
            return
        end

        local char = LocalPlayer.Character
        if not char then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        local moveDir = hum.MoveDirection
        if moveDir.Magnitude <= 0 then return end

        local emoting = char:GetAttribute("Emoting")
        local downed = char:GetAttribute("Downed")
        if not (emoting or downed) then return end

        local targetCF = CFrame.lookAt(
            hrp.Position,
            hrp.Position + moveDir
        )

        local turnSpeed = DConfiguration.Misc.MovementModification.EmoteModification.ModifyEmote.TurnSpeed
        local alpha = math.clamp(turnSpeed * dt * 16, 0, 1)

        hrp.CFrame = hrp.CFrame:Lerp(targetCF, alpha)
    end)
end)

SecEmoteMovement:AddInput("EmoteRotation", {
        Title = "Emote Rotation Speed",
        Default = "0.5",
        Placeholder = "Rotation Number",
        Numeric = false, 
        Finished = false, 
        Callback = function(Value)
            DConfiguration.Misc.MovementModification.EmoteModification.ModifyEmote.TurnSpeed = tonumber(Value) or 0.5
        end
    })
    
SecEmoteMovement:AddDivider()
SecEmoteMovement:AddSpace({ Height = 20 })

SecEmoteMovement:AddSpace({ Height = 20 })
SecEmoteMovement:AddDivider()


SecEmoteMovement:AddDivider()
SecEmoteMovement:AddSpace({ Height = 20 })

SecGravity = Tabs.Misc:AddSection("Gravity", "solar/planet-bold")
SecGravity:AddSpace({ Height = 20 })
SecGravity:AddDivider()


NormalGravity = game.Workspace.Gravity

Toggle = SecGravity:AddToggle("GravityToggle", {Title = "Gravity Button", Default = false })

GravityFrame, GravityButton = CreateFloatingButton("GravityGui", "Gravity", true)
function DoGravityToggle()
    DConfiguration.Misc.MovementModification.Gravity.FloatingButton = not DConfiguration.Misc.MovementModification.Gravity.FloatingButton
    SetFloatingButtonActive(GravityButton, DConfiguration.Misc.MovementModification.Gravity.FloatingButton, "Gravity")
end
GravityButton.Activated:Connect(DoGravityToggle)

Toggle:OnChanged(function(State)
    SetFloatingButtonVisible(GravityFrame, State)
end)

AddFloatingButtonSizeInputs(SecGravity, "GravityGui", "Gravity")
AddFloatingButtonKeybind(SecGravity, "GravityGui", "Gravity", DoGravityToggle)

    
 SecGravity:AddInput("GravityAdjust", {
        Title = "Gravity Adjustment",
        Default = "10",
        Placeholder = " Number",
        Numeric = false, 
        Finished = false, 
        Callback = function(Value)
            DConfiguration.Misc.MovementModification.Gravity.Value = tonumber(Value) or  10
        end
    })
    
SecGravity:AddDivider()
SecGravity:AddSpace({ Height = 20 })

SecGravity:AddSpace({ Height = 20 })
SecGravity:AddDivider()


SecGravity:AddDivider()
SecGravity:AddSpace({ Height = 20 })

SecBhopAutoJump = Tabs.Misc:AddSection("BHOP / Auto Jump", "solar/double-alt-arrow-up-bold")
SecBhopAutoJump:AddSpace({ Height = 20 })
SecBhopAutoJump:AddDivider()

LegitJumpConnection = nil

SecBhopAutoJump:AddToggle("LegitJumpToggle", {Title = "Legit Jump", Default = false}):OnChanged(function(State)
    if LegitJumpConnection then
        LegitJumpConnection:Disconnect()
        LegitJumpConnection = nil
    end

    if not State then return end

    LegitJumpConnection = RunService.Heartbeat:Connect(function()
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local JumpButton = LocalPlayer:FindFirstChild("PlayerGui")
            and LocalPlayer.PlayerGui:FindFirstChild("TouchGui")
            and LocalPlayer.PlayerGui.TouchGui:FindFirstChild("TouchControlFrame")
            and LocalPlayer.PlayerGui.TouchGui.TouchControlFrame:FindFirstChild("JumpButton")

        if not (Humanoid and JumpButton) then return end

        local StateType = Humanoid:GetState()
        local IsJumping = StateType == Enum.HumanoidStateType.Jumping or StateType == Enum.HumanoidStateType.Freefall

        JumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
        JumpButton.ImageRectSize = Vector2.new(144, 144)

        if IsJumping then
            JumpButton.ImageRectOffset = Vector2.new(146, 146)
        else
            JumpButton.ImageRectOffset = Vector2.new(1, 146)
        end
    end)
end)

SecBhopAutoJump:AddDivider()
SecBhopAutoJump:AddSpace({ Height = 20 })

Toggle = SecBhopAutoJump:AddToggle("BHOPToggle", {Title = "BHOP (Button)", Default = false })

BHOPFrame, BHOPButton = CreateFloatingButton("BHOPGui", "Auto Jump", true)
function DoBhopToggle()
    DConfiguration.Misc.MovementModification.BHOP.FloatingButton = not DConfiguration.Misc.MovementModification.BHOP.FloatingButton
    SetFloatingButtonActive(BHOPButton, DConfiguration.Misc.MovementModification.BHOP.FloatingButton, "Auto Jump")

    task.spawn(function()
        while DConfiguration.Misc.MovementModification.BHOP.FloatingButton and wait(0.1) do
            DConfiguration.Misc.MovementModification.BHOP.Enabled = DConfiguration.Misc.MovementModification.BHOP.FloatingButton
        end

        if not DConfiguration.Misc.MovementModification.BHOP.FloatingButton then
            spawn(DFunctions.ResetBHOP)
            wait(0.1)
            spawn(DFunctions.ResetBHOP)
            DConfiguration.Misc.MovementModification.BHOP.Enabled = false
        end
    end)
end
BHOPButton.Activated:Connect(DoBhopToggle)

Toggle:OnChanged(function(State)
    SetFloatingButtonVisible(BHOPFrame, State)
end)

Toggle = SecBhopAutoJump:AddToggle("BHOPJumpButton", {Title = "BHOP (Jump Button)", Default = false })

 Toggle:OnChanged(function(State)
      DConfiguration.Misc.MovementModification.BHOP.JumpButton = State
end)

if UserInputService.TouchEnabled then
    local JumpButton = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("TouchGui"):WaitForChild("TouchControlFrame"):FindFirstChild("JumpButton")
    
    if JumpButton then
        local isJumping = false

        JumpButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and DConfiguration.Misc.MovementModification.BHOP.JumpButton then
                if not isJumping then
                    isJumping = true
                    DConfiguration.Misc.MovementModification.BHOP.Enabled = true
                end
            end
        end)

        JumpButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and DConfiguration.Misc.MovementModification.BHOP.JumpButton and not DConfiguration.Misc.MovementModification.BHOP.FloatingButton then
                if isJumping then
                    isJumping = false
                    DConfiguration.Misc.MovementModification.BHOP.Enabled = false
                    spawn(DFunctions.ResetBHOP)
                end
            end
        end)
    end
end
    
AddFloatingButtonSizeInputs(SecBhopAutoJump, "BHOPGui", "Auto Jump")
AddFloatingButtonKeybind(SecBhopAutoJump, "BHOPGui", "Auto Jump", DoBhopToggle)

Dropdown = SecBhopAutoJump:AddDropdown("BHOPVersion", {
        Title = "Select BHOP Version",
        Values = {"Acceleration", "Ground Acceleration", "No Acceleration"},
        Multi = false,
        Search = false,
        Default = 1,
    })

    Dropdown:OnChanged(function(Value)
        DConfiguration.Misc.MovementModification.BHOP.Type = Value
    end)
    
Dropdown = SecBhopAutoJump:AddDropdown("JumpType", {
        Title = "Select Jump Type",
        Values = {"Simulated", "?"},
        Multi = false,
        Search = false,
        Default = 1,
    })

    Dropdown:OnChanged(function(Value)
        DConfiguration.Misc.MovementModification.BHOP.JumpType = Value
    end)
    
SecBhopAutoJump:AddInput("BHOPAcceleration", {
        Title = "BHOP Acceleration",
        Description = "Negative Only",
        Default = "-0.1",
        Placeholder = "-1",
        Numeric = false,
        Finished = false,
        Callback = function(Value)
            DConfiguration.Misc.MovementModification.BHOP.Acceleration = tonumber(Value) or -0.1
        end
    })
    
    
    
SecBhopAutoJump:AddDivider()
SecBhopAutoJump:AddSpace({ Height = 20 })

SecAutoCrouch = Tabs.Misc:AddSection("Auto Crouch", "solar/minimize-square-bold")
SecAutoCrouch:AddSpace({ Height = 20 })
SecAutoCrouch:AddDivider()

AutoCrouchFrame, AutoCrouchButton = CreateFloatingButton("AutoCrouchGui", "Auto Crouch", true)
AutoCrouchConnection = nil
AutoCrouchMode = "Rapid"
AutoCrouchDelay = 0.05
AutoCrouchRespawnGrace = false

LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
    AutoCrouchRespawnGrace = true
    NewCharacter:WaitForChild("HumanoidRootPart", 10)
    task.wait(2)
    AutoCrouchRespawnGrace = false
end)

function DoAutoCrouchToggle()
    DConfiguration.Misc.MovementModification.AutoCrouch = not DConfiguration.Misc.MovementModification.AutoCrouch
    SetFloatingButtonActive(AutoCrouchButton, DConfiguration.Misc.MovementModification.AutoCrouch, "Auto Crouch")

    if DConfiguration.Misc.MovementModification.AutoCrouch then
        AutoCrouchConnection = task.spawn(function()
            while DConfiguration.Misc.MovementModification.AutoCrouch do
                local Character = LocalPlayer.Character
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

                local ShouldCrouch = true
                if Humanoid then
                    local StateType = Humanoid:GetState()
                    local IsAirborne = StateType == Enum.HumanoidStateType.Freefall or StateType == Enum.HumanoidStateType.Jumping

                    if AutoCrouchMode == "Ground" then
                        ShouldCrouch = not IsAirborne
                    elseif AutoCrouchMode == "Air" then
                        ShouldCrouch = IsAirborne
                    end
                end

                if Character and HRP and Humanoid and ShouldCrouch and not AutoCrouchRespawnGrace then
                    pcall(function()
                        Character.Communicator:InvokeServer("Crouching", true)
                        task.wait(AutoCrouchDelay)
                        Character.Communicator:InvokeServer("Crouching", false)
                    end)
                end

                task.wait(AutoCrouchDelay)
            end
        end)
    end
end
AutoCrouchButton.Activated:Connect(DoAutoCrouchToggle)

Toggle = SecAutoCrouch:AddToggle("AutoCrouchToggle", {Title = "Auto Crouch (Button)", Default = false })
Toggle:OnChanged(function(State)
    SetFloatingButtonVisible(AutoCrouchFrame, State)
    if not State then
        DConfiguration.Misc.MovementModification.AutoCrouch = false
    end
end)

SecAutoCrouch:AddDropdown("AutoCrouchModeDropdown", {
    Search = false,
    Title = "Auto Crouch Mode",
    Values = {"Rapid", "Ground", "Air"},
    Default = "Rapid",
    Callback = function(Value)
        AutoCrouchMode = Value
    end,
})

SecAutoCrouch:AddInput("AutoCrouchDelayInput", {
    Title = "Auto Crouch Delay",
    Default = "0.05",
    Placeholder = "0.05",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local Num = tonumber(Value)
        if Num and Num >= 0 then
            AutoCrouchDelay = Num
        end
    end,
})

AddFloatingButtonSizeInputs(SecAutoCrouch, "AutoCrouchGui", "Auto Crouch")
AddFloatingButtonKeybind(SecAutoCrouch, "AutoCrouchGui", "Auto Crouch", DoAutoCrouchToggle)

SecAutoCrouch:AddDivider()
SecAutoCrouch:AddSpace({ Height = 20 })

SecAutoAcceleration = Tabs.Misc:AddSection("Auto Acceleration", "solar/speedometer-max-bold")
SecAutoAcceleration:AddSpace({ Height = 20 })
SecAutoAcceleration:AddDivider()

Toggle = SecAutoAcceleration:AddToggle("BHOPAutoAccelerate", {Title = "Auto Acceleration (Legit)", Default = false })

 Toggle:OnChanged(function(State)
      DConfiguration.Misc.MovementModification.BHOP.AutoAcceleration = State
end)

SecAutoAcceleration:AddInput("BHOPMaxSpeedAcceleration", {
        Title = "Max Speed Acceleration",
        Default = "70",
        Placeholder = "70",
        Numeric = false, 
        Finished = false,
        Callback = function(Value)
            DConfiguration.Misc.MovementModification.BHOP.MaxSpeed = tonumber(Value) or 70
        end
    })

RunService.Heartbeat:Connect(function()
    local stop = false

    if DConfiguration.Misc.MovementModification.BHOP.Enabled or DConfiguration.Misc.MovementModification.BHOP.Keybind then
        task.spawn(DFunctions.BHOPFunction)
        stop = true
    end

    if DConfiguration.Misc.MovementModification.Gravity.FloatingButton or DConfiguration.Misc.MovementModification.Gravity.Keybind then
        game.Workspace.Gravity = DConfiguration.Misc.MovementModification.Gravity.Value
    else
        game.Workspace.Gravity = NormalGravity
    end
    
    if not stop then
        if DConfiguration.Misc.MovementModification.EmoteModification.AggressiveEmoteDash.Enabled then
            task.spawn(DFunctions.SprintEmoteDash)
        end
    end
    
    RunService.RenderStepped:Wait()
end)

ItemsFolder = ReplicatedStorage.Items

Folder = Instance.new("Folder", ItemsFolder)
Folder.Name = "D-Folder"

ChangeEmote1 = ""
ChangeEmote2 = "" 
ChangeCosmetics1 = "HeartSkaters" 
ChangeCosmetics2 = "ToxicInferno"

function Normalize(input)
	return input:lower():gsub("%s+", "") 
end

function FindRealName(folder, userInput)
	local normalizedInput = Normalize(userInput)
	for _, item in ipairs(folder:GetChildren()) do
		if Normalize(item.Name) == normalizedInput then
			return item.Name
		end
	end
	return nil
end

function ChangeCosmetics(Name1, Name2)
	local Cosmetics = ReplicatedStorage.Items.Cosmetics
	local RealName1 = FindRealName(Cosmetics, Name1)
	local RealName2 = FindRealName(Cosmetics, Name2)

	if RealName1 and RealName2 then
		local I = Cosmetics:FindFirstChild(RealName1)
		local V = Cosmetics:FindFirstChild(RealName2)
		if I and V then
			I.Name = RealName2
			task.wait()
			V.Name = RealName1
		end
	end
end

function ChangeEmotes(Name1, Name2)
	local Emotes = ReplicatedStorage.Items.Emotes
	local RealName1 = FindRealName(Emotes, Name1)
	local RealName2 = FindRealName(Emotes, Name2)

	if RealName1 and RealName2 then
		local I = Emotes:FindFirstChild(RealName1)
		local V = Emotes:FindFirstChild(RealName2)
		if I and V then
			I.Name = RealName2
			task.wait()
			V.Name = RealName1
		end
	end
end

SecAutoAcceleration:AddDivider()
SecAutoAcceleration:AddSpace({ Height = 20 })

SecEdgeTrimp = Tabs.Misc:AddSection("Edge Trimp", "solar/ruler-bold")
SecEdgeTrimp:AddSpace({ Height = 20 })
SecEdgeTrimp:AddDivider()

EdgeTrimpEnabled = false
EdgeBounceMultiplier = 5
EdgeFallSpeedThreshold = 69
EdgeSimulatedMultiplier = 3
EdgeMode = "Realistic"
EdgeLastFloorMaterial = Enum.Material.Air
EdgeLastPosition = Vector3.new()
EdgeDetected = false
edgeTrimpConnection = nil
edgeCharAddedConnection = nil

function handleEdgeTrimpCharacter(NewCharacter)
    EdgeCharacter = NewCharacter
    EdgeHumanoid = EdgeCharacter:WaitForChild("Humanoid")
    EdgeHumanoidRootPart = EdgeCharacter:WaitForChild("HumanoidRootPart")
    EdgeLastPosition = EdgeHumanoidRootPart.Position
    EdgeDetected = false
end

SecEdgeTrimp:AddToggle("EdgeTrimpToggle", {Title = "Edge Trimp", Default = false}):OnChanged(function(State)
    EdgeTrimpEnabled = State

    if State then
        if LocalPlayer.Character then
            handleEdgeTrimpCharacter(LocalPlayer.Character)
        end
        edgeCharAddedConnection = LocalPlayer.CharacterAdded:Connect(handleEdgeTrimpCharacter)

        edgeTrimpConnection = RunService.Heartbeat:Connect(function()
            if not (EdgeCharacter and EdgeHumanoid and EdgeHumanoidRootPart) then return end

            local CurrentPosition = EdgeHumanoidRootPart.Position
            local Velocity = (CurrentPosition - EdgeLastPosition) / RunService.Heartbeat:Wait()
            EdgeLastPosition = CurrentPosition
            local CurrentFloorMaterial = EdgeHumanoid.FloorMaterial
            local IsFalling = EdgeHumanoid:GetState() == Enum.HumanoidStateType.Freefall or EdgeHumanoid:GetState() == Enum.HumanoidStateType.Jumping

            if CurrentFloorMaterial ~= EdgeLastFloorMaterial and CurrentFloorMaterial == Enum.Material.Air and not IsFalling then
                EdgeDetected = true
            else
                EdgeDetected = false
            end

            if EdgeDetected and EdgeHumanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                if EdgeMode == "Realistic" then
                    local FallVelocity = Velocity.Y
                    if FallVelocity < -EdgeFallSpeedThreshold then
                        local BounceVelocity = math.abs(FallVelocity) * EdgeBounceMultiplier
                        EdgeHumanoidRootPart.Velocity = Vector3.new(EdgeHumanoidRootPart.Velocity.X, BounceVelocity, EdgeHumanoidRootPart.Velocity.Z)
                    end
                else
                    local HorizontalSpeed = Vector2.new(Velocity.X, Velocity.Z).Magnitude
                    if HorizontalSpeed > 1 then
                        local SimulatedHeight = HorizontalSpeed * EdgeSimulatedMultiplier
                        EdgeHumanoidRootPart.Velocity = Vector3.new(EdgeHumanoidRootPart.Velocity.X, SimulatedHeight, EdgeHumanoidRootPart.Velocity.Z)
                    end
                end
            end

            EdgeLastFloorMaterial = CurrentFloorMaterial
        end)
    else
        if edgeTrimpConnection then
            edgeTrimpConnection:Disconnect()
            edgeTrimpConnection = nil
        end
        if edgeCharAddedConnection then
            edgeCharAddedConnection:Disconnect()
            edgeCharAddedConnection = nil
        end
    end
end)

SecEdgeTrimp:AddDropdown("EdgeModeDropdown", {
    Search = false,
    Title = "Edge Mode",
    Values = {"Realistic", "Simulated"},
    Default = "Realistic",
    Callback = function(Value)
        EdgeMode = Value
    end,
})

SecEdgeTrimp:AddInput("EdgeHeightMultiplier", {
    Title = "Bounce Height Multiplier",
    Default = tostring(EdgeBounceMultiplier),
    Placeholder = "5",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local Num = tonumber(Value)
        if Num and Num > 0 then
            EdgeBounceMultiplier = Num
        end
    end,
})

SecEdgeTrimp:AddInput("EdgeFallThreshold", {
    Title = "Falling Threshold",
    Default = tostring(EdgeFallSpeedThreshold),
    Placeholder = "69",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local Num = tonumber(Value)
        if Num and Num > 0 then
            EdgeFallSpeedThreshold = Num
        end
    end,
})

SecEdgeTrimp:AddInput("EdgeSimulatedMultiplierInput", {
    Title = "Simulated Height Multiplier",
    Default = tostring(EdgeSimulatedMultiplier),
    Placeholder = "3",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local Num = tonumber(Value)
        if Num and Num > 0 then
            EdgeSimulatedMultiplier = Num
        end
    end,
})

SecEdgeTrimp:AddDivider()
SecEdgeTrimp:AddSpace({ Height = 20 })

SecLightingModification = Tabs.Visual:AddSection("Lighting Modification", "solar/sun-2-bold")
SecLightingModification:AddSpace({ Height = 20 })
SecLightingModification:AddDivider()

SecLightingModification:AddToggle("CustomTimeToggle", {Title = "Custom Time", Default = false}):OnChanged(function(State)
    DConfiguration.Visual = DConfiguration.Visual or {}
    DConfiguration.Visual.CustomTimeEnabled = State
    if not State then
        Lighting.ClockTime = 14
    end
end)

SecLightingModification:AddSlider("CustomTimeSlider", {
    Title = "Time of Day",
    Description = "0 = Midnight, 12 = Noon, 24 = Midnight",
    Default = 14,
    Min = 0,
    Max = 24,
    Rounding = 1,
    Callback = function(Value)
        if DConfiguration.Visual and DConfiguration.Visual.CustomTimeEnabled then
            Lighting.ClockTime = Value
        end
    end,
})

SecLightingModification:AddDivider()
SecLightingModification:AddSpace({ Height = 20 })

SecTimerDisplay = Tabs.Visual:AddSection("Timer Display", "solar/clock-circle-bold")
SecTimerDisplay:AddSpace({ Height = 20 })
SecTimerDisplay:AddDivider()

function GetThemeAccentColor()
    local Gradients = Fluent:GetButtonGradient() or Fluent.ButtonGradients
    if Gradients and Gradients.Stroke and Gradients.Stroke.Keypoints and Gradients.Stroke.Keypoints[2] then
        return Gradients.Stroke.Keypoints[2].Value
    end
    return Color3.fromRGB(0, 170, 255)
end

TimerAccentColor = GetThemeAccentColor()
TimerDangerColor = Color3.fromRGB(215, 100, 100)
IsTimerInDanger = false
TimerConnections = {}
IsTimerEnabled = false

function FormatTimerSeconds(Seconds)
    if not Seconds then return "0:00" end
    Seconds = math.floor(tonumber(Seconds) or 0)
    local Minutes = math.floor(Seconds / 60)
    local RemainingSeconds = Seconds % 60
    return string.format("%d:%02d", Minutes, RemainingSeconds)
end

function BuildTimerDisplay()
    local PlayerGuiRef = LocalPlayer:WaitForChild("PlayerGui")
    local MainInterface = PlayerGuiRef:FindFirstChild("GoonWaresTimerHud")
    if MainInterface then
        TimerContainer = MainInterface:FindFirstChild("Center")
        TimerLabel = TimerContainer and TimerContainer.RoundTimer.RoundTimer.Timer
        StatusLabel = TimerContainer and TimerContainer.RoundTimer.RoundTimer.About
        return
    end

    MainInterface = Instance.new("ScreenGui")
    MainInterface.Name = "GoonWaresTimerHud"
    MainInterface.Parent = PlayerGuiRef
    MainInterface.ResetOnSpawn = false
    MainInterface.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainInterface.DisplayOrder = 2

    TimerContainer = Instance.new("Frame")
    TimerContainer.Name = "Center"
    TimerContainer.Parent = MainInterface
    TimerContainer.AnchorPoint = Vector2.new(0.5, 1)
    TimerContainer.BackgroundTransparency = 1
    TimerContainer.Position = UDim2.new(0.5, 0, 1, 0)
    TimerContainer.Size = UDim2.new(1, 0, 1, 0)

    Instance.new("UIAspectRatioConstraint").Parent = TimerContainer

    local RoundTimerFrame = Instance.new("Frame")
    RoundTimerFrame.Name = "RoundTimer"
    RoundTimerFrame.Parent = TimerContainer
    RoundTimerFrame.AnchorPoint = Vector2.new(0.5, 0)
    RoundTimerFrame.BackgroundTransparency = 1
    RoundTimerFrame.Position = UDim2.new(0.5, 0, 0.02, 0)
    RoundTimerFrame.Size = UDim2.new(0.2, 0, 0.08, 0)
    RoundTimerFrame.ZIndex = 26

    local InnerFrame = Instance.new("Frame")
    InnerFrame.Name = "RoundTimer"
    InnerFrame.Parent = RoundTimerFrame
    InnerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    InnerFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    InnerFrame.BackgroundTransparency = 0.6
    InnerFrame.BorderSizePixel = 0
    InnerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    InnerFrame.Size = UDim2.new(1, 0, 1, 0)
    Instance.new("UICorner", InnerFrame).CornerRadius = UDim.new(0, 8)

    TimerLabel = Instance.new("TextLabel")
    TimerLabel.Name = "Timer"
    TimerLabel.Parent = InnerFrame
    TimerLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.Position = UDim2.new(0.5, 0, 0.65, 0)
    TimerLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
    TimerLabel.ZIndex = 3
    TimerLabel.Font = Enum.Font.GothamBold
    TimerLabel.Text = "0:00"
    TimerLabel.TextColor3 = TimerAccentColor
    TimerLabel.TextScaled = true
    TimerLabel.TextStrokeTransparency = 0.95
    TimerLabel.TextWrapped = true

    StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "About"
    StatusLabel.Parent = InnerFrame
    StatusLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0.5, 0, 0.25, 0)
    StatusLabel.Size = UDim2.new(0.8, 0, 0.25, 0)
    StatusLabel.ZIndex = 3
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.Text = "INTERMISSION"
    StatusLabel.TextColor3 = TimerAccentColor
    StatusLabel.TextScaled = true
    StatusLabel.TextWrapped = true

    local TimerStroke = Instance.new("UIStroke")
    TimerStroke.Thickness = 2
    TimerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    TimerStroke.Transparency = 0.2
    TimerStroke.Parent = InnerFrame

    local TimerGradientStroke = Instance.new("UIGradient")
    TimerGradientStroke.Color = (Fluent:GetButtonGradient() or Fluent.ButtonGradients).Stroke
    TimerGradientStroke.Rotation = 0
    TimerGradientStroke.Parent = TimerStroke

    task.spawn(function()
        while InnerFrame.Parent do
            TimerGradientStroke.Rotation = (TimerGradientStroke.Rotation + 0.5) % 360
            TimerGradientStroke.Color = (Fluent:GetButtonGradient() or Fluent.ButtonGradients).Stroke

            if not IsTimerInDanger then
                local LiveAccent = GetThemeAccentColor()
                TimerLabel.TextColor3 = LiveAccent
                StatusLabel.TextColor3 = LiveAccent
            end

            task.wait()
        end
    end)
end

function UpdateTimerDisplay()
    if not (TimerContainer and TimerLabel and StatusLabel) then return end

    local GameFolder = Workspace:FindFirstChild("Game")
    if not GameFolder then
        TimerContainer.Visible = false
        return
    end

    local StatsFolder = GameFolder:FindFirstChild("Stats")
    if not StatsFolder then
        TimerContainer.Visible = false
        return
    end

    TimerContainer.Visible = true

    local TimeRemaining = StatsFolder:GetAttribute("TimeRemaining") or StatsFolder:GetAttribute("Timer")
    local RoundStarted = StatsFolder:GetAttribute("RoundStarted")
    local Ready = StatsFolder:GetAttribute("Ready")

    if TimeRemaining then
        TimerLabel.Text = FormatTimerSeconds(TimeRemaining)
        if TimeRemaining <= 5 then
            IsTimerInDanger = true
            TimerLabel.TextColor3 = TimerDangerColor
            StatusLabel.TextColor3 = TimerDangerColor
        else
            IsTimerInDanger = false
        end
    end

    if RoundStarted == true then
        StatusLabel.Text = "ROUND ACTIVE"
    elseif Ready == true then
        StatusLabel.Text = "INTERMISSION"
    else
        StatusLabel.Text = "ROUND INACTIVE"
    end
end

function SetupTimerConnection()
    for _, Connection in pairs(TimerConnections) do
        Connection:Disconnect()
    end
    TimerConnections = {}

    local GameFolder = Workspace:FindFirstChild("Game")
    if not GameFolder then return end

    local StatsFolder = GameFolder:FindFirstChild("Stats")
    if not StatsFolder then return end

    table.insert(TimerConnections, StatsFolder:GetAttributeChangedSignal("TimeRemaining"):Connect(UpdateTimerDisplay))
    table.insert(TimerConnections, StatsFolder:GetAttributeChangedSignal("Timer"):Connect(UpdateTimerDisplay))
    table.insert(TimerConnections, StatsFolder:GetAttributeChangedSignal("RoundStarted"):Connect(UpdateTimerDisplay))
    table.insert(TimerConnections, StatsFolder:GetAttributeChangedSignal("Ready"):Connect(UpdateTimerDisplay))

    UpdateTimerDisplay()
end

SecTimerDisplay:AddToggle("TimerDisplayToggle", {Title = "Timer Display", Default = false}):OnChanged(function(State)
    IsTimerEnabled = State

    if State then
        BuildTimerDisplay()
        if Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Stats") then
            SetupTimerConnection()
        end
        UpdateTimerDisplay()

        Workspace.DescendantAdded:Connect(function(Descendant)
            if IsTimerEnabled and Descendant.Name == "Stats" and Descendant.Parent and Descendant.Parent.Name == "Game" then
                SetupTimerConnection()
            end
        end)
    else
        if TimerContainer then
            TimerContainer.Visible = false
        end
        for _, Connection in pairs(TimerConnections) do
            Connection:Disconnect()
        end
        TimerConnections = {}
    end
end)

SecTimerDisplay:AddDivider()
SecTimerDisplay:AddSpace({ Height = 20 })

SecSkinCosmeticsChanger = Tabs.Visual:AddSection("Skin/Cosmetics Changer", "solar/palette-round-bold")
SecSkinCosmeticsChanger:AddSpace({ Height = 20 })
SecSkinCosmeticsChanger:AddDivider()

    
Input = SecSkinCosmeticsChanger:AddInput("CosmeticsChange1", {
        Title = "Current Cosmetics",
        Default = "HeartSkaters",
        Placeholder = "",
        Numeric = false, 
        Finished = false, 
        Callback = function(Value)
            ChangeCosmetics1 = Value
        end
    })
    
Input = SecSkinCosmeticsChanger:AddInput("CosmeticsChange2", {
        Title = "Select Cosmetics",
        Default = "ToxicInferno",
        Placeholder = "",
        Numeric = false,
        Finished = false, 
        Callback = function(Value)
            ChangeCosmetics2 = Value
        end
    })
    
    
SecSkinCosmeticsChanger:AddButton({
        Title = "Change Cosmetics",
        Description = "" ,
        Callback = function()
          spawn(function()
             ChangeCosmetics(ChangeCosmetics1, ChangeCosmetics2)
           end)
        end
    })


SecSkinCosmeticsChanger:AddDivider()
SecSkinCosmeticsChanger:AddSpace({ Height = 20 })

SecEmoteChanger = Tabs.Visual:AddSection("Emote Changer", "solar/mask-hapiness-bold")
SecEmoteChanger:AddSpace({ Height = 20 })
SecEmoteChanger:AddDivider()


CurrentEmote1 = ""
CurrentEmote2 = ""
CurrentEmote3 = ""
CurrentEmote4 = ""
CurrentEmote5 = ""
CurrentEmote6 = ""

SelectEmote1 = ""
SelectEmote2 = ""
SelectEmote3 = ""
SelectEmote4 = ""
SelectEmote5 = ""
SelectEmote6 = ""

ReplicatedStorage = game:GetService("ReplicatedStorage")

function Normalize(input)
    return input:lower():gsub("%s+", "") 
end

function FindRealName(folder, userInput)
    if not folder then return nil end
    local normalizedInput = Normalize(userInput)
    for _, item in ipairs(folder:GetChildren()) do
        if Normalize(item.Name) == normalizedInput then
            return item.Name
        end
    end
    return nil
end

function DirectNameSwapEmote(Name1, Name2)
    pcall(function()
        local EmotesFolder = ReplicatedStorage:FindFirstChild("Items") and ReplicatedStorage.Items:FindFirstChild("Emotes")
        if not EmotesFolder then return end
        
        local RealName1 = FindRealName(EmotesFolder, Name1)
        local RealName2 = FindRealName(EmotesFolder, Name2)
        
        if RealName1 and RealName2 and RealName1 ~= RealName2 then
            local I = EmotesFolder:FindFirstChild(RealName1)
            local V = EmotesFolder:FindFirstChild(RealName2)
            if I and V then
                I.Name = RealName2
                task.wait(0.01)
                V.Name = RealName1
            end
        end
    end)
end

SecEmoteChanger:AddInput("EmoteCurrent1", {
    Title = "1 Current Emote",
    Default = CurrentEmote1,
    Placeholder = "",
    Numeric = false, Finished = false,
    Callback = function(Value) CurrentEmote1 = Value end
})

SecEmoteChanger:AddInput("EmoteCurrent2", {
    Title = "2 Current Emote",
    Default = CurrentEmote2,
    Placeholder = "",
    Numeric = false, Finished = false,
    Callback = function(Value) CurrentEmote2 = Value end
})

SecEmoteChanger:AddInput("EmoteCurrent3", {
    Title = "3 Current Emote",
    Default = CurrentEmote3,
    Placeholder = "",
    Numeric = false, Finished = false,
    Callback = function(Value) CurrentEmote3 = Value end
})

SecEmoteChanger:AddInput("EmoteCurrent4", {
    Title = "4 Current Emote",
    Default = CurrentEmote4,
    Placeholder = "",
    Numeric = false, Finished = false,
    Callback = function(Value) CurrentEmote4 = Value end
})

SecEmoteChanger:AddInput("EmoteCurrent5", {
    Title = "5 Current Emote",
    Default = CurrentEmote5,
    Placeholder = "",
    Numeric = false, Finished = false,
    Callback = function(Value) CurrentEmote5 = Value end
})

SecEmoteChanger:AddInput("EmoteCurrent6", {
    Title = "6 Current Emote",
    Default = CurrentEmote6,
    Placeholder = "",
    Numeric = false, Finished = false,
    Callback = function(Value) CurrentEmote6 = Value end
})

SecEmoteChanger:AddDivider()
SecEmoteChanger:AddSpace({ Height = 20 })

SecEmoteChanger:AddSpace({ Height = 20 })
SecEmoteChanger:AddDivider()

SecEmoteChanger:AddInput("EmoteSelect1", {
    Title = "1 Select Emote",
    Default = SelectEmote1,
    Placeholder = "",
    Numeric = false, Finished = false,
    Callback = function(Value) SelectEmote1 = Value end
})

SecEmoteChanger:AddInput("EmoteSelect2", {
    Title = "2 Select Emote",
    Default = SelectEmote2,
    Placeholder = "",
    Numeric = false, Finished = false,
    Callback = function(Value) SelectEmote2 = Value end
})

SecEmoteChanger:AddInput("EmoteSelect3", {
    Title = "3 Select Emote",
    Default = SelectEmote3,
    Placeholder = "",
    Numeric = false, Finished = false,
    Callback = function(Value) SelectEmote3 = Value end
})

SecEmoteChanger:AddInput("EmoteSelect4", {
    Title = "4 Select Emote",
    Default = SelectEmote4,
    Placeholder = "",
    Numeric = false, Finished = false,
    Callback = function(Value) SelectEmote4 = Value end
})

SecEmoteChanger:AddInput("EmoteSelect5", {
    Title = "5 Select Emote",
    Default = SelectEmote5,
    Placeholder = "",
    Numeric = false, Finished = false,
    Callback = function(Value) SelectEmote5 = Value end
})

SecEmoteChanger:AddInput("EmoteSelect6", {
    Title = "6 Select Emote",
    Default = SelectEmote6,
    Placeholder = "",
    Numeric = false, Finished = false,
    Callback = function(Value) SelectEmote6 = Value end
})

SecEmoteChanger:AddParagraph({ Title = "Don't use Stride with Rockin' Stride", Content = "It is advisable not to use Stride at all" })

SecEmoteChanger:AddButton({
    Title = "Change Emotes",
    Description = "",
    Callback = function()
        task.spawn(function()
            local emotePairs = {
                {current = CurrentEmote1, select = SelectEmote1},
                {current = CurrentEmote2, select = SelectEmote2},
                {current = CurrentEmote3, select = SelectEmote3},
                {current = CurrentEmote4, select = SelectEmote4},
                {current = CurrentEmote5, select = SelectEmote5},
                {current = CurrentEmote6, select = SelectEmote6}
            }
            
            local usedEmotes = {}
            
            for i, pair in ipairs(emotePairs) do
                if pair.current and pair.select and pair.current ~= "" and pair.select ~= "" and pair.current ~= pair.select then
                    if not usedEmotes[pair.current] and not usedEmotes[pair.select] then
                        DirectNameSwapEmote(pair.current, pair.select)
                        
                        usedEmotes[pair.current] = true
                        usedEmotes[pair.select] = true
                        
                        task.wait(0.02)
                    end
                end
            end
        end)
    end
})
    

BuiltInSkyboxes = {
    ["Waguri"] = {
        Folder = "GoonWares/Skyboxes/Waguri",
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_ft.png", File = "waguri_ft.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_bk.png", File = "waguri_bk.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_rt.png", File = "waguri_rt.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_lf.png", File = "waguri_lf.png" },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_up.png", File = "waguri_up.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_dn.png", File = "waguri_dn.png" },
        },
    },
    ["ItsukiNakano"] = {
        Folder = "GoonWares/Skyboxes/ItsukiNakano",
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Bk.png", File = "ItsukiNakano_Bk.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Ft.png", File = "ItsukiNakano_Ft.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Lf.png", File = "ItsukiNakano_Lf.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Rt.png", File = "ItsukiNakano_Rt.png" },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Up.png", File = "ItsukiNakano_Up.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Dn.png", File = "ItsukiNakano_Dn.png" },
        },
    },
    ["ItsukiNakano2"] = {
        Folder = "GoonWares/Skyboxes/ItsukiNakano2",
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Bk.png", File = "ItsukiNakano2_Bk.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Ft.png", File = "ItsukiNakano2_Ft.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Lf.png", File = "ItsukiNakano2_Lf.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Rt.png", File = "ItsukiNakano2_Rt.png" },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Up.png", File = "ItsukiNakano2_Up.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Dn.png", File = "ItsukiNakano2_Dn.png" },
        },
    },
    ["MaiSakurajima"] = {
        Folder = "GoonWares/Skyboxes/MaiSakurajima",
        Faces = {
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/top.png", File = "top.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/down.png", File = "down.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/left.png", File = "left.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/right.png", File = "right.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/front.png", File = "front.png" },
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/back.png", File = "back.png" },
        },
    },
    ["MikuNakano"] = {
        Folder = "GoonWares/Skyboxes/MikuNakano",
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Bk.png", File = "MikuNakano_Bk.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Ft.png", File = "MikuNakano_Ft.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Lf.png", File = "MikuNakano_Lf.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Rt.png", File = "MikuNakano_Rt.png" },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Up.png", File = "MikuNakano_Up.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Dn.png", File = "MikuNakano_Dn.png" },
        },
    },
    ["TohkaYatogami"] = {
        Folder = "GoonWares/Skyboxes/TohkaYatogami",
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_BK.png", File = "TohkaYatogami_BK.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_FT.png", File = "TohkaYatogami_FT.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_LF.png", File = "TohkaYatogami_LF.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_RT.png", File = "TohkaYatogami_RT.png" },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_UP.png", File = "TohkaYatogami_UP.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_DN.png", File = "TohkaYatogami_DN.png" },
        },
    },
    ["TohkaYatogami2"] = {
        Folder = "GoonWares/Skyboxes/TohkaYatogami",
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_BK.png", File = "TohkaYatogami2_BK.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_FT.png", File = "TohkaYatogami2_FT.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_LF.png", File = "TohkaYatogami2_LF.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_RT.png", File = "TohkaYatogami2_RT.png" },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_UP.png", File = "TohkaYatogami2_UP.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_DN.png", File = "TohkaYatogami2_DN.png" },
        },
    },
    ["LilithAsami"] = {
        Folder = "GoonWares/Skyboxes/LilithAsami",
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_BK.png", File = "LilithAsami_BK.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_FT.png", File = "LilithAsami_FT.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_LF.png", File = "LilithAsami_LF.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_RT.png", File = "LilithAsami_RT.png" },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_UP.png", File = "LilithAsami_UP.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_DN.png", File = "LilithAsami_DN.png" },
        },
    },
    ["Evernight"] = {
        Folder = "GoonWares/Skyboxes/Evernight",
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_RT.png", File = "SkyRt.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_LF.png", File = "SkyIf.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_BK.png", File = "SkyBk.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_FT.png", File = "SkyFt.png" },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_UP.png", File = "SkyUp.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_DN.png", File = "SkyDn.png" },
        },
    },
    ["Xenovia Quarta"] = {
        Folder = "GoonWares/Skyboxes/Xenovia Quarta",
        Faces = {
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NjM0ODhf/if.png", File = "if.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NjM0ODlf/ft.png", File = "ft.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NjM0OTBf/dn.png", File = "dn.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NjM0OTFf/bk.png", File = "bk.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NjM0ODZf/up.png", File = "up.png" },
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NjM0ODdf/rt.png", File = "rt.png" },
        },
    },
    ["Nino Nakano"] = {
        Folder = "GoonWares/Skyboxes/Nino Nakano",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NjQyODNf/right1.png", File = "right1.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NjQyNzhf/back.png", File = "back.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NjQyODBf/front.png", File = "front.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NjQyODJf/left1.png", File = "left1.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NjQyNzlf/down.png", File = "down.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NjQyODFf/up.png", File = "up.png" },
        },
    },
    ["Nino Nakano 2"] = {
        Folder = "GoonWares/Skyboxes/Nino Nakano 2",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NjQyNTJf/rt.png", File = "rt.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NjQyNTBf/up.png", File = "up.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NjQyNTVf/dn.png", File = "dn.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NjQyNTNf/if.png", File = "if.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NjQyNTZf/bk.png", File = "bk.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NjQyNTRf/ft.png", File = "ft.png" },
        },
    },
    ["Saki Saki"] = {
        Folder = "GoonWares/Skyboxes/Saki Saki",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NjQyNzNf/right.png", File = "right.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NjQyNzBf/left.png", File = "left.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NjQyNjhf/front1.png", File = "front1.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NjQyNjZf/back1.png", File = "back1.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NjQyNjdf/down1.png", File = "down1.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NjQyNjlf/Up1.png", File = "Up1.png" },
        },
    },
    ["Rias Gremory"] = {
        Folder = "GoonWares/Skyboxes/Rias Gremory",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NzkyOTFf/RightRias.png", File = "RightRias.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NzkyOTNf/leftRias.png", File = "leftRias.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NzkyOTVf/front%20Rias.png", File = "frontRias.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NzkyOTRf/BackRias.png", File = "BackRias.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NzkyOThf/downRias.png", File = "downRias.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NzkyOTJf/UpRias.png", File = "UpRias.png" },
        },
    },
    ["Yotsuba Nakano"] = {
        Folder = "GoonWares/Skyboxes/Yotsuba Nakano",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NzkzMzdf/YotsubaRt.png", File = "YotsubaRt.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NzkzMzhf/YotsubaUp.png", File = "YotsubaUp.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NzkzMzNf/YotsubaDn.png", File = "YotsubaDn.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NzkzMzRf/YotsubaFt.png", File = "YotsubaFt.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NzkzMzFf/YotsubaBk.png", File = "YotsubaBk.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NzkzMzZf/YotsubaLeft.png", File = "YotsubaLeft.png" },
        },
    },
    ["Hakari Hananozo"] = {
        Folder = "GoonWares/Skyboxes/hk",
        Faces = {
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NjEzMTVf/SkyBk.tex", File = "SkyBk.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/s/NjNfOTg0NjEzMTdf/SkyFt.tex", File = "SkyFt.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/s/NjNfOTg0NjEzMThf/SkyIf.tex", File = "SkyIf.png" },
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NjEzMTlf/SkyRt.tex", File = "SkyRt.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NjEzMjBf/SkyUp.tex", File = "SkyUp.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NjEzMTZf/Skydn.tex", File = "Skydn.png" },
        },
    },
    ["Alya"] = {
        Folder = "GoonWares/Skyboxes/Alya",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NzkzMTZf/Rt.png", File = "Rt.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NzkzMTVf/Up.png", File = "Up.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NzkzMTJf/dn.png", File = "dn.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NzkzMTNf/ft.png", File = "ft.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NzkzMTFf/bk.png", File = "bk.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NzkzMTRf/if.png", File = "if.png" },
        },
    },
    ["Alya 2"] = {
        Folder = "GoonWares/Skyboxes/Alya 2",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NzkzMjRf/AlyaRt.png", File = "AlyaRt.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NzkzMjVf/AlyaUp.png", File = "AlyaUp.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NzkzMjFf/alyaDn.png", File = "alyaDn.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NzkzMjJf/AlyaFt.png", File = "AlyaFt.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NzkzMjBf/AlyaBk.png", File = "AlyaBk.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NzkzMjNf/AlyaLf.png", File = "AlyaLf.png" },
        },
    },
    ["Iteration 3.2.0"] = {
        RbxAssetIds = {
            SkyboxLf = "rbxassetid://111969418190645",
            SkyboxFt = "rbxassetid://86300370158690",
            SkyboxRt = "rbxassetid://90660761614046",
            SkyboxBk = "rbxassetid://94155581950702",
            SkyboxDn = "rbxassetid://74377450776557",
            SkyboxUp = "rbxassetid://110123630908028",
        },
        StarCount = 3000,
        SunAngularSize = 0,
        MoonAngularSize = 0,
    },
    ["IterationT Remake"] = {
        RbxAssetIds = {
            SkyboxLf = "rbxassetid://131895067742893",
            SkyboxFt = "rbxassetid://139394863985793",
            SkyboxRt = "rbxassetid://93313124175539",
            SkyboxBk = "rbxassetid://93271230842735",
            SkyboxDn = "rbxassetid://72142305760362",
            SkyboxUp = "rbxassetid://86656757951125",
        },
        StarCount = 3000,
        SunAngularSize = 0,
        MoonAngularSize = 0,
    },
}

function ApplyBuiltInSkybox(data)
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end

    if data.ResetHaze then
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("Atmosphere") then v.Haze = 0 end
        end
    end

    local SkyInstance = Instance.new("Sky")
    SkyInstance.Name = "Sky"
    SkyInstance.CelestialBodiesShown = false
    SkyInstance.StarCount = data.StarCount or 0
    if data.SunAngularSize then SkyInstance.SunAngularSize = data.SunAngularSize end
    if data.MoonAngularSize then SkyInstance.MoonAngularSize = data.MoonAngularSize end

    if data.RbxAssetIds then
        for prop, id in pairs(data.RbxAssetIds) do
            SkyInstance[prop] = id
        end
    elseif data.Faces then
        pcall(function() makefolder("GoonWares/Skyboxes") end)
        pcall(function() makefolder(data.Folder) end)
        for _, face in ipairs(data.Faces) do
            local path = data.Folder .. "/" .. face.File
            if not isfile(path) then
                writefile(path, game:HttpGet(face.Url, true))
            end
            SkyInstance[face.Prop] = getcustomasset(path)
        end
    end

    SkyInstance.Parent = Lighting
end

SecEmoteChanger:AddSpace({ Height = 20 })

SecEmoteChanger:AddDivider()
SecEmoteChanger:AddSpace({ Height = 20 })

SecNextbotDecalChanger = Tabs.Visual:AddSection("Nextbot Decal Changer", "solar/gallery-bold")
SecNextbotDecalChanger:AddSpace({ Height = 20 })
SecNextbotDecalChanger:AddDivider()

NextbotDecalNames = {"All"}
NextbotDecalSelected = {}
NextbotDecalImage = "rbxassetid://139095000385640"

do
    local NPCStorage = ReplicatedStorage:FindFirstChild("NPCStorage")
    if NPCStorage then
        local FoundNames = {}
        for _, v in ipairs(NPCStorage:GetChildren()) do
            table.insert(FoundNames, v.Name)
        end
        table.sort(FoundNames)
        for _, Name in ipairs(FoundNames) do
            table.insert(NextbotDecalNames, Name)
        end
    end
end

SecNextbotDecalChanger:AddDropdown("NextbotDecalDropdown", {
    Title = "Select Nextbots",
    Values = NextbotDecalNames,
    Multi = true,
    Search = true,
    DropdownOutsideWindow = true,
    Default = {},
    Callback = function(Value)
        NextbotDecalSelected = Value
    end,
})

SecNextbotDecalChanger:AddInput("NextbotDecalImageInput", {
    Title = "Decal Image ID or URL",
    Placeholder = "rbxassetid://139095000385640",
    Default = "rbxassetid://139095000385640",
    Numeric = false,
    Finished = true,
    Callback = function(Value)
        NextbotDecalImage = Value
    end,
})

SecNextbotDecalChanger:AddButton({
    Title = "Apply Decal",
    Description = "Applies to selected nextbots (permanent template + current round if spawned)",
    Callback = function()
        if NextbotDecalImage == "" then return end

        local NPCStorage = ReplicatedStorage:FindFirstChild("NPCStorage")
        local GamePlayers = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")

        local ApplyAll = NextbotDecalSelected["All"] == true

        for _, NextbotName in ipairs(NextbotDecalNames) do
            if NextbotName ~= "All" and (ApplyAll or NextbotDecalSelected[NextbotName]) then
                pcall(function()
                    local Template = NPCStorage[NextbotName].Variants.Default.HumanoidRootPart.HeadPos.BillboardGui.ImageLabel
                    Template.Image = NextbotDecalImage
                end)

                pcall(function()
                    local LiveNextbot = GamePlayers[NextbotName]
                    LiveNextbot.HRP.HeadPos.BillboardGui.ImageLabel.Image = NextbotDecalImage
                end)
            end
        end

        Notify("Nextbot Decal Changer", "Decal applied to selected nextbots", "Success", nil, 3)
    end,
})

SecNextbotDecalChanger:AddDivider()
SecNextbotDecalChanger:AddSpace({ Height = 20 })


SecSkyboxChanger = Tabs.Visual:AddSection("Skybox Changer", "solar/sun-bold")
SecSkyboxChanger:AddSpace({ Height = 20 })
SecSkyboxChanger:AddDivider()


BuiltInSkyboxNames = {}
for skyboxName in pairs(BuiltInSkyboxes) do
    table.insert(BuiltInSkyboxNames, skyboxName)
end
table.sort(BuiltInSkyboxNames)

SelectedBuiltInSkybox = BuiltInSkyboxNames[1]
SecSkyboxChanger:AddDropdown("BuiltInSkyboxDropdown", {
    DropdownOutsideWindow = true,
    Search = true,
    Title = "Built-in Skybox",
    Values = BuiltInSkyboxNames,
    Default = SelectedBuiltInSkybox,
    Callback = function(value)
        SelectedBuiltInSkybox = value
    end
})

SecSkyboxChanger:AddButton({
    Title = "Apply Skybox",
    Callback = function()
        local data = BuiltInSkyboxes[SelectedBuiltInSkybox]
        if data then
            local ok = pcall(ApplyBuiltInSkybox, data)
            if ok then
                Fluent:Notify({ Title = "Skybox", Content = SelectedBuiltInSkybox .. " applied.", Duration = 3 })
            else
                Fluent:Notify({ Title = "Skybox", Content = "Failed to apply skybox.", Duration = 3 })
            end
        end
    end
})

SkyboxForceEnabled = false
SkyboxForceConnection = nil
SkyboxApplyingNow = false

function ApplySelectedSkyboxSafely()
    local data = BuiltInSkyboxes[SelectedBuiltInSkybox]
    if not data then return end

    SkyboxApplyingNow = true
    pcall(ApplyBuiltInSkybox, data)
    task.wait(0.2)
    SkyboxApplyingNow = false
end

SecSkyboxChanger:AddToggle("SkyboxForceToggle", {Title = "Force Skybox Every Round", Default = false}):OnChanged(function(State)
    SkyboxForceEnabled = State

    if SkyboxForceConnection then
        SkyboxForceConnection:Disconnect()
        SkyboxForceConnection = nil
    end

    if State then
        ApplySelectedSkyboxSafely()

        SkyboxForceConnection = Lighting.ChildAdded:Connect(function(child)
            if not SkyboxForceEnabled then return end
            if SkyboxApplyingNow then return end
            if child:IsA("Sky") then
                task.wait(0.1)
                ApplySelectedSkyboxSafely()
            end
        end)
    end
end)

SecSkyboxChanger:AddParagraph({
    Title = "Built-in Skybox Info",
    Content = "Your executors must have a write file/read file system, and for some skyboxes you will have to wait about 20 seconds to fully load the skybox. Enable 'Force Skybox Every Round' to keep your chosen skybox applied permanently across map/round changes; disable it to let the game's own skybox show normally."
})

SecSkyboxChanger:AddSpace({ Height = 20 })

SecSkyboxChanger:AddDivider()
SecSkyboxChanger:AddSpace({ Height = 20 })

SecCustomSkybox = Tabs.Visual:AddSection("Custom Skybox", "solar/gallery-bold")
SecCustomSkybox:AddSpace({ Height = 20 })
SecCustomSkybox:AddDivider()


CustomSkyboxInputs = { Lf = "", Rt = "", Up = "", Dn = "", Ft = "", Bk = "" }

function ResolveSkyboxInput(value, faceName)
    value = tostring(value or ""):gsub("^%s*(.-)%s*$", "%1")
    if value == "" then return nil end
    if value:match("^rbxassetid://") then
        return value
    elseif value:match("^%d+$") then
        return "rbxassetid://" .. value
    elseif value:match("^https?://") then
        local ok = pcall(function() makefolder("GoonWares/Skyboxes/Custom") end)
        local path = "GoonWares/Skyboxes/custom/" .. faceName .. ".png"
        local downloadOk = pcall(function()
            writefile(path, game:HttpGet(value, true))
        end)
        if downloadOk then
            return getcustomasset(path)
        end
    end
    return nil
end

function ApplyCustomSkybox()
    local propMap = { Lf = "SkyboxLf", Rt = "SkyboxRt", Up = "SkyboxUp", Dn = "SkyboxDn", Ft = "SkyboxFt", Bk = "SkyboxBk" }

    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end

    local SkyInstance = Instance.new("Sky")
    SkyInstance.Name = "Sky"
    SkyInstance.CelestialBodiesShown = false
    SkyInstance.StarCount = 0

    local appliedAny = false
    for face, prop in pairs(propMap) do
        local resolved = ResolveSkyboxInput(CustomSkyboxInputs[face], face)
        if resolved then
            SkyInstance[prop] = resolved
            appliedAny = true
        end
    end

    if appliedAny then
        SkyInstance.Parent = Lighting
        Fluent:Notify({ Title = "Skybox", Content = "Custom skybox applied.", Duration = 3 })
    else
        SkyInstance:Destroy()
        Fluent:Notify({ Title = "Skybox", Content = "No valid inputs provided.", Duration = 3 })
    end
end

SecCustomSkybox:AddInput("CustomSkyboxLf", { Title = "Left (Lf)", Placeholder = "rbxassetid or URL", Callback = function(v) CustomSkyboxInputs.Lf = v end })
SecCustomSkybox:AddInput("CustomSkyboxRt", { Title = "Right (Rt)", Placeholder = "rbxassetid or URL", Callback = function(v) CustomSkyboxInputs.Rt = v end })
SecCustomSkybox:AddInput("CustomSkyboxUp", { Title = "Up", Placeholder = "rbxassetid or URL", Callback = function(v) CustomSkyboxInputs.Up = v end })
SecCustomSkybox:AddInput("CustomSkyboxDn", { Title = "Down (Dn)", Placeholder = "rbxassetid or URL", Callback = function(v) CustomSkyboxInputs.Dn = v end })
SecCustomSkybox:AddInput("CustomSkyboxFt", { Title = "Front (Ft)", Placeholder = "rbxassetid or URL", Callback = function(v) CustomSkyboxInputs.Ft = v end })
SecCustomSkybox:AddInput("CustomSkyboxBk", { Title = "Back (Bk)", Placeholder = "rbxassetid or URL", Callback = function(v) CustomSkyboxInputs.Bk = v end })

SecCustomSkybox:AddButton({
    Title = "Apply Custom Skybox",
    Callback = ApplyCustomSkybox
})

SecCustomSkybox:AddParagraph({
    Title = "Custom Skybox Info",
    Content = "You can upload 6 cube skyboxes to Roblox create or create 6 cubemaps as direct download links then enter the url or rbxassetid into the 6 inputs must be in the direction of the cube"
})

SecDiscord = Tabs.Info:AddSection("Discord", "solar/chat-round-bold")

SecDiscord:AddDiscord({
    InviteCode = "QBhcVu6c",
})

SecDiscord:AddDivider()

SecDiscord:AddSpace({ Height = 20 })
SecTikTok = Tabs.Info:AddSection("TikTok", "solar/music-note-bold")

SecTikTok:AddImage({
    Image = "https://unavatar.io/tiktok/styearx",
    AspectRatio = "16:9",
    Radius = 10,
})

SecTikTok:AddParagraph({
    Title = "Follow my main account Pls",
    Content = "@styearx",
})

SecTikTok:AddCode({
    Title = "",
    Code = "https://www.tiktok.com/@styearx",
    OnCopy = function() Notify("Link", "Copied", "Info", nil, 2) end,
})

SecTikTok:AddDivider()

SecTikTok:AddSpace({ Height = 20 })
SecYouTube = Tabs.Info:AddSection("YouTube", "solar/videocamera-record-bold")

SecYouTube:AddImage({
    Image = "https://unavatar.io/youtube/StyearX",
    AspectRatio = "16:9",
    Radius = 10,
})

SecYouTube:AddParagraph({
    Title = "Subscribe to my main account :)",
    Content = "@StyearX",
})

SecYouTube:AddCode({
    Title = "",
    Code = "https://m.youtube.com/@styearx",
    OnCopy = function() Notify("Link", "Copied", "Info", nil, 2) end,
})

SecYouTube:AddDivider()

SecYouTube:AddSpace({ Height = 20 })
SecGithub = Tabs.Info:AddSection("GitHub", "solar/code-square-bold")
SecGithub:AddImage({
    Image = "https://unavatar.io/github/StyearX",
    AspectRatio = "16:9",
    Radius = 10,
})

SecGithub:AddParagraph({
    Title = "Check out my GitHub",
    Content = "@StyearX",
})

SecGithub:AddCode({
    Title = "",
    Code = "https://github.com/StyearX",
    OnCopy = function() Notify("Link", "Copied", "Info", nil, 2) end,
})

SecGithub:AddDivider()

SecGithub:AddSpace({ Height = 20 })
SecUILibrary = Tabs.Info:AddSection("UI Library", "solar/widget-bold")

SecUILibrary:AddParagraph({
    Title = "Fluent Modded",
    Content = "The UI Library used in this script.",
})

SecUILibrary:AddCode({
    Title = "",
    Code = "https://github.com/StyearX/Fluent-modded",
    OnCopy = function() Notify("Link", "Copied", "Info", nil, 2) end,
})

SecCharacterExtension = Tabs.Extension:AddSection("Character Extension", "solar/user-id-bold")
SecCharacterExtension:AddSpace({ Height = 20 })
SecCharacterExtension:AddDivider()


_G.KorbloxR_Enabled = false
_G.KorbloxL_Enabled = false
_G.Headless_Enabled = false

Players = game:GetService("Players")
player = Players.LocalPlayer

function revertChanges()
    local char = player.Character
    if not char then return end
    
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 0
        local mesh = head:FindFirstChild("HeadlessMesh")
        if mesh then mesh:Destroy() end
    end
    
    for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Right Leg", "Left Leg"}) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.Transparency = 0
            local m = part:FindFirstChild("KorbloxMesh")
            if m then m:Destroy() end
        end
    end
end

function applyKorblox(side)
    local char = player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local isR15 = humanoid and humanoid.RigType == Enum.HumanoidRigType.R15
    
    if isR15 then
        local parts = (side == "Right") and {"RightUpperLeg", "RightLowerLeg", "RightFoot"} or {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"}
        for _, partName in ipairs(parts) do
            local part = char:FindFirstChild(partName)
            if part then
                part.Transparency = 1
            end
        end
    else
        local legName = (side == "Right") and "Right Leg" or "Left Leg"
        local leg = char:FindFirstChild(legName)
        local meshId = (side == "Right") and "rbxassetid://101851696" or "rbxassetid://101851582"
        
        if leg then
            for _, child in ipairs(leg:GetChildren()) do
                if child:IsA("SpecialMesh") then child:Destroy() end
            end
            leg.Color = Color3.fromRGB(50, 50, 50)
            local mesh = Instance.new("SpecialMesh")
            mesh.Name = "KorbloxMesh"
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = meshId
            mesh.Parent = leg
        end
    end
end

function applyHeadless()
    local char = player.Character
    local head = char and char:FindFirstChild("Head")
    if head then
        head.Transparency = 1
        if head:FindFirstChild("face") then head.face:Destroy() end
        
        if not head:FindFirstChild("HeadlessMesh") then
            local mesh = Instance.new("SpecialMesh")
            mesh.Name = "HeadlessMesh"
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = "rbxassetid://1095708"
            mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
            mesh.Parent = head
        end
    end
end

function checkAndApplyAll()
    revertChanges()
    if _G.KorbloxR_Enabled then applyKorblox("Right") end
    if _G.KorbloxL_Enabled then applyKorblox("Left") end
    if _G.Headless_Enabled then applyHeadless() end
end

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    task.wait(0.5)
    checkAndApplyAll()
end)

if player.Character then
    checkAndApplyAll()
end

SecCharacterExtension:AddToggle("KorbloxRToggle", {
    Title = "Korblox (Right)",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.KorbloxR_Enabled = Value
        checkAndApplyAll()
    end
})

SecCharacterExtension:AddToggle("KorbloxLToggle", {
    Title = "Korblox (Left)",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.KorbloxL_Enabled = Value
        checkAndApplyAll()
    end
})

SecCharacterExtension:AddToggle("HeadlessToggle", {
    Title = "Headless",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.Headless_Enabled = Value
        checkAndApplyAll()
    end
})

SecCharacterExtension:AddDivider()
SecCharacterExtension:AddSpace({ Height = 20 })

SecCharacterExtension:AddSpace({ Height = 20 })
SecCharacterExtension:AddDivider()

SecAccessoryEffects = Tabs.Extension:AddSection("Accessory Effects", "solar/magic-stick-3-bold")
SecAccessoryEffects:AddSpace({ Height = 20 })
SecAccessoryEffects:AddDivider()

_G.Players = game:GetService("Players")
_G.LPlayer = _G.Players.LocalPlayer

_G.ExtStates = {
    Wings = false,
    Poison = false,
    Frozen = false,
    Fire = false,
    Doomsekkar = false,
}

_G.ApplySingleExt = function(id, name, state)
    if not state then
        if _G.LPlayer.Character and _G.LPlayer.Character:FindFirstChild(name) then
            _G.LPlayer.Character[name]:Destroy()
        end
        return
    end
    
    local char = _G.LPlayer.Character
    if not char or char:FindFirstChild(name) then return end
    
    local s, obj = pcall(function() return game:GetObjects("rbxassetid://" .. id)[1] end)
    if s and obj then
        obj.Name = name
        obj.Parent = char
        
        local h = obj:FindFirstChild("Handle")
        if h and h:IsA("BasePart") then
            h.CanCollide = false
            
            local w = Instance.new("Weld")
            w.Part0 = h
            
            if name == "Wings_Acc" then
                local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                if torso then
                    w.Part1 = torso
                    w.C0 = obj.AttachmentPoint
                    w.C1 = CFrame.new(0, 1.7, 0.3) 
                else
                    w.Part1 = char:FindFirstChild("Head")
                    w.C0 = obj.AttachmentPoint
                    w.C1 = CFrame.new(0, 0.5, 0)
                end
            else
                w.Part1 = char:FindFirstChild("Head")
                w.C0 = obj.AttachmentPoint
                w.C1 = CFrame.new(0, 0.5, 0) 
            end
            
            w.Parent = h
        end
    end
end

_G.RefreshExts = function()
    if _G.ExtStates.Wings then _G.ApplySingleExt(192557913, "Wings_Acc", true) end
    if _G.ExtStates.Poison then _G.ApplySingleExt(1744060292, "Poison_Acc", true) end
    if _G.ExtStates.Frozen then _G.ApplySingleExt(74891470, "Frozen_Acc", true) end
    if _G.ExtStates.Fire then _G.ApplySingleExt(215718515, "Fire_Acc", true) end
    if _G.ExtStates.Doomsekkar then _G.ApplySingleExt(132809431, "Doomsekkar_Acc", true) end
    if _G.ExtStates.Frostsekkar then _G.ApplySingleExt(182672520, "Frostsekkar_Acc", true) end
    if _G.ExtStates.Infernosekkar then _G.ApplySingleExt(319643443, "Infernosekkar_Acc", true) end
    if _G.ExtStates.PoisonDusekkar then _G.ApplySingleExt(174405374, "PoisonDusekkar_Acc", true) end
end

_G.LPlayer.CharacterAdded:Connect(function()
    task.wait(1.5) 
    _G.RefreshExts()
end)

_G.Players = game:GetService("Players")
_G.LPlayer = _G.Players.LocalPlayer

_G.ExtStates = {
    Wings = false,
    Poison = false,
    Frozen = false,
    Fire = false,
    Doomsekkar = false,
}

_G.ApplySingleExt = function(id, name, state)
    if not state then
        if _G.LPlayer.Character and _G.LPlayer.Character:FindFirstChild(name) then
            _G.LPlayer.Character[name]:Destroy()
        end
        return
    end
    
    local char = _G.LPlayer.Character
    if not char or char:FindFirstChild(name) then return end
    
    local s, obj = pcall(function() return game:GetObjects("rbxassetid://" .. id)[1] end)
    if s and obj then
        obj.Name = name
        obj.Parent = char
        
        local h = obj:FindFirstChild("Handle")
        if h and h:IsA("BasePart") then
            h.CanCollide = false
            
            local w = Instance.new("Weld")
            w.Part0 = h
            
            if name == "Wings_Acc" then
                local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                if torso then
                    w.Part1 = torso
                    w.C0 = obj.AttachmentPoint
                    w.C1 = CFrame.new(0, 1.7, 0.3) 
                else
                    w.Part1 = char:FindFirstChild("Head")
                    w.C0 = obj.AttachmentPoint
                    w.C1 = CFrame.new(0, 0.5, 0)
                end
            else
                w.Part1 = char:FindFirstChild("Head")
                w.C0 = obj.AttachmentPoint
                w.C1 = CFrame.new(0, 0.5, 0) 
            end
            
            w.Parent = h
        end
    end
end

_G.RefreshExts = function()
    if _G.ExtStates.Wings then _G.ApplySingleExt(192557913, "Wings_Acc", true) end
    if _G.ExtStates.Poison then _G.ApplySingleExt(1744060292, "Poison_Acc", true) end
    if _G.ExtStates.Frozen then _G.ApplySingleExt(74891470, "Frozen_Acc", true) end
    if _G.ExtStates.Fire then _G.ApplySingleExt(215718515, "Fire_Acc", true) end
    if _G.ExtStates.Doomsekkar then _G.ApplySingleExt(132809431, "Doomsekkar_Acc", true) end
    if _G.ExtStates.Frostsekkar then _G.ApplySingleExt(182672520, "Frostsekkar_Acc", true) end
    if _G.ExtStates.Infernosekkar then _G.ApplySingleExt(319643443, "Infernosekkar_Acc", true) end
    if _G.ExtStates.PoisonDusekkar then _G.ApplySingleExt(174405374, "PoisonDusekkar_Acc", true) end
end

_G.LPlayer.CharacterAdded:Connect(function()
    task.wait(1.5) 
    _G.RefreshExts()
end)

SecAccessoryEffects:AddToggle("TogWings", {
    Title = "Angelic Wings",
    Default = false,
    Callback = function(state) 
        _G.ExtStates.Wings = state 
        _G.ApplySingleExt(192557913, "Wings_Acc", state) 
    end
})

SecAccessoryEffects:AddToggle("TogPoison", {
    Title = "Poisonous Horns",
    Default = false,
    Callback = function(state) 
        _G.ExtStates.Poison = state 
        _G.ApplySingleExt(1744060292, "Poison_Acc", state) 
    end
})

SecAccessoryEffects:AddToggle("TogFrozen", {
    Title = "Frozen Horn",
    Default = false,
    Callback = function(state) 
        _G.ExtStates.Frozen = state 
        _G.ApplySingleExt(74891470, "Frozen_Acc", state) 
    end
})

SecAccessoryEffects:AddToggle("TogFire", {
    Title = "Fire Horn",
    Default = false,
    Callback = function(state) 
        _G.ExtStates.Fire = state 
        _G.ApplySingleExt(215718515, "Fire_Acc", state) 
    end
})

SecAccessoryEffects:AddToggle("TogDoomsekkar", {
    Title = "Doomsekkar",
    Default = false,
    Callback = function(state) 
        _G.ExtStates.Doomsekkar = state 
        _G.ApplySingleExt(132809431, "Doomsekkar_Acc", state) 
    end
})

SecAccessoryEffects:AddDivider()
SecAccessoryEffects:AddSpace({ Height = 20 })

SecAccessoryEffects:AddSpace({ Height = 20 })
SecAccessoryEffects:AddDivider()

SecDeleteHats = Tabs.Extension:AddSection("Delete Hats", "solar/trash-bin-trash-bold")
SecDeleteHats:AddSpace({ Height = 20 })
SecDeleteHats:AddDivider()

Players = game:GetService("Players")
player = Players.LocalPlayer

_G.DeleteHatsEnabled = false

function deleteHats()
    if _G.DeleteHatsEnabled then
        local char = player.Character
        if char then
            for _, v in ipairs(char:GetChildren()) do 
                if v:IsA("Accessory") then
                    v:Destroy() 
                end
            end
        end
    end
end

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    task.wait(1)
    deleteHats()
end)

if player.Character then
    deleteHats()
end


SecDeleteHats:AddToggle("DeleteHats", {
    Title = "Remove Accessories",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.DeleteHatsEnabled = Value
    end
})


SecDeleteHats:AddButton({
    Title = "AvatarChanger",
    Description = "By byteed",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-client-avatar-changer-92130"))()
    end
})


SecDeleteHats:AddDivider()
SecDeleteHats:AddSpace({ Height = 20 })

SecCustomSky = Tabs.Extension:AddSection("Ambient Effects", "solar/sun-bold")
SecCustomSky:AddSpace({ Height = 20 })
SecCustomSky:AddDivider()


task.spawn(function()
    local L = game:GetService("Lighting")

    DFunctions.rbConn = nil

    SecCustomSky:AddToggle("RainbowAmbient", {
        Title = "Rainbow Ambient",
        Default = false,
        Callback = function(Value)
            if DFunctions.rbConn then DFunctions.rbConn:Disconnect() end
            if Value then
                DFunctions.rbConn = game:GetService("RunService").RenderStepped:Connect(function()
                    local c = Color3.fromHSV((tick() * 0.2) % 1, 0.8, 1)
                    L.Ambient = c
                    L.OutdoorAmbient = c
                end)
            else
                L.Ambient = Color3.fromRGB(127, 127, 127)
                L.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            end
        end
    })
end)

        

SecCustomSky:AddDivider()
SecCustomSky:AddSpace({ Height = 20 })

SecLightningExtension = Tabs.Extension:AddSection("Lightning Extension", "solar/bolt-bold")
SecLightningExtension:AddSpace({ Height = 20 })
SecLightningExtension:AddDivider()


Lighting = game:GetService("Lighting")

fbConnection = nil
fogConnection = nil

OriginalFogEnd = Lighting.FogEnd

getgenv().FbBrightnessValue = 2

Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
if Atmosphere then
    OriginalDensity = Atmosphere.Density
    OriginalGlare = Atmosphere.Glare
    OriginalHaze = Atmosphere.Haze
end

function applyFullBright()
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
    Lighting.ColorShift_Top = Color3.new(1, 1, 1)
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.ClockTime = 14
    Lighting.Brightness = getgenv().FbBrightnessValue
end

function applyNoFog()
    Lighting.FogEnd = 100000
    local A = Lighting:FindFirstChildOfClass("Atmosphere")
    if A then
        A.Density = 0
        A.Glare = 0
        A.Haze = 0
    end
end

Toggle = SecLightningExtension:AddToggle("FullBright", {
    Title = "Full Bright", 
    Default = false
})

BrightnessInput = SecLightningExtension:AddInput("FbBrightnessInput", {
    Title = "Full Bright Brightness",
    Default = "2",
    Placeholder = "Enter brightness level...",
    Numeric = true,
    Finished = false
})

Toggle:OnChanged(function(state)
    if fbConnection then
        fbConnection:Disconnect()
        fbConnection = nil
    end

    if state then
        applyFullBright()
        fbConnection = Lighting.Changed:Connect(function(property)
            if property == "Ambient" or property == "Brightness" or property == "FogEnd" or property == "GlobalShadows" then
                applyFullBright()
            end
        end)
    else
        Lighting.GlobalShadows = true
        local A = Lighting:FindFirstChildOfClass("Atmosphere")
        if A then
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.Brightness = 1
        else
            Lighting.Ambient = Color3.fromRGB(128, 128, 128)
            Lighting.Brightness = 1
        end
        Lighting.FogEnd = 1000
    end
end)

BrightnessInput:OnChanged(function()
    local value = tonumber(BrightnessInput.Value)
    if value then
        getgenv().FbBrightnessValue = value
    else
        getgenv().FbBrightnessValue = 2
    end
    
    if Options.FullBright.Value then
        applyFullBright()
    end
end)

Options.FullBright:SetValue(false)

NoFogToggle = SecLightningExtension:AddToggle("NoFogToggle", {
    Title = "Disable Fog",
    Default = false
})

NoFogToggle:OnChanged(function(Value)
    if fogConnection then 
        fogConnection:Disconnect() 
        fogConnection = nil
    end
    
    if Value then
        OriginalFogEnd = Lighting.FogEnd
        local Atm = Lighting:FindFirstChildOfClass("Atmosphere")
        if Atm then
            OriginalDensity = Atm.Density
            OriginalGlare = Atm.Glare
            OriginalHaze = Atm.Haze
        end

        applyNoFog()
        fogConnection = Lighting:GetPropertyChangedSignal("FogEnd"):Connect(applyNoFog)
        
        local A = Lighting:FindFirstChildOfClass("Atmosphere")
        if A then
            fogConnection = A.Changed:Connect(applyNoFog)
        end
    else
        Lighting.FogEnd = OriginalFogEnd or 1000
        local A = Lighting:FindFirstChildOfClass("Atmosphere")
        if A then
            A.Density = OriginalDensity or 0.3
            A.Glare = OriginalGlare or 0
            A.Haze = OriginalHaze or 0
        end
    end
end)



SecLightningExtension:AddDivider()
SecLightningExtension:AddSpace({ Height = 20 })

SecAntiLagsExtension = Tabs.Extension:AddSection("Anti Lags Extension", "solar/cpu-bolt-bold")
SecAntiLagsExtension:AddSpace({ Height = 20 })
SecAntiLagsExtension:AddDivider()


Lag1 = false

Toggle = SecAntiLagsExtension:AddToggle("Anti_Lag1", {Title = "Anti Lag 1", Default = false})

Toggle:OnChanged(
    function(Value1)
        Lag1 = Value1
        if Lag1 then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                    v.Material = Enum.Material.SmoothPlastic
                    if v:IsA("Texture") then
                        v:Destroy()
                    end
                end
            end
        end
    end
)

Options.Anti_Lag1:SetValue(false)

Toggle = SecAntiLagsExtension:AddToggle("Anti_Lag2", {Title = "Anti Lag 2", Default = false})

Toggle:OnChanged(
    function(Value3)
        if Value3 then
            local decalsyeeted = true -- Leaving this on makes games look shitty but the fps goes up by at least 20.
            local g = game
            local w = g.Workspace
            local l = g.Lighting
            local t = w.Terrain
            t.WaterWaveSize = 0
            t.WaterWaveSpeed = 0
            t.WaterReflectance = 0
            t.WaterTransparency = 0
            l.GlobalShadows = false
            l.FogEnd = 9e9
            l.Brightness = 0
            settings().Rendering.QualityLevel = "Level01"
            wait(1)
            for i, v in pairs(g:GetDescendants()) do
                if v:IsA("Part") or v:IsA("Union") or v:IsA("MeshPart") then
                    v.Material = "Plastic"
                    v.Reflectance = 0
                elseif v:IsA("Decal") and decalsyeeted then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Lifetime = NumberRange.new(0)
                end
            end
        end
    end
)

Options.Anti_Lag2:SetValue(false)

Toggle = SecAntiLagsExtension:AddToggle("Anti_Lag3", {Title = "Anti Lag 3", Default = false})

Toggle:OnChanged(
    function(Value4)
        if Value4 then
            local decalsyeeted = true
            local g = game
            local w = g.Workspace
            local l = g.Lighting
            local t = w.Terrain
            sethiddenproperty(l, "Technology", 2)
            sethiddenproperty(t, "Decoration", false)
            t.WaterWaveSize = 0
            t.WaterWaveSpeed = 0
            t.WaterReflectance = 0
            t.WaterTransparency = 0
            l.GlobalShadows = 0
            l.FogEnd = 9e9
            l.Brightness = 0
            settings().Rendering.QualityLevel = "Level01"
            for i, v in pairs(w:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsA("MeshPart") then
                    v.Material = "Plastic"
                    v.Reflectance = 0
                elseif (v:IsA("Decal") or v:IsA("Texture")) and decalsyeeted then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Lifetime = NumberRange.new(0)
                elseif v:IsA("Explosion") then
                    v.BlastPressure = 1
                    v.BlastRadius = 1
                elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
                    v.Enabled = false
                elseif v:IsA("MeshPart") and decalsyeeted then
                    v.Material = "Plastic"
                    v.Reflectance = 0
                    v.TextureID = 10385902758728957
                elseif v:IsA("SpecialMesh") and decalsyeeted then
                    v.TextureId = 0
                elseif v:IsA("ShirtGraphic") and decalsyeeted then
                    v.Graphic = 0
                elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
                    v[v.ClassName .. "Template"] = 0
                end
            end
            for i = 1, #l:GetChildren() do
                e = l:GetChildren()[i]
                if
                    e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or
                        e:IsA("BloomEffect") or
                        e:IsA("DepthOfFieldEffect")
                 then
                    e.Enabled = false
                end
            end
            w.DescendantAdded:Connect(
                function(v)
                    wait(1)
                    if v:IsA("BasePart") and not v:IsA("MeshPart") then
                        v.Material = "Plastic"
                        v.Reflectance = 0
                    elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
                        v.Transparency = 1
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                        v.Lifetime = NumberRange.new(0)
                    elseif v:IsA("Explosion") then
                        v.BlastPressure = 1
                        v.BlastRadius = 1
                    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
                        v.Enabled = false
                    elseif v:IsA("MeshPart") and decalsyeeted then
                        v.Material = "Plastic"
                        v.Reflectance = 0
                        v.TextureID = 10385902758728957
                    elseif v:IsA("SpecialMesh") and decalsyeeted then
                        v.TextureId = 0
                    elseif v:IsA("ShirtGraphic") and decalsyeeted then
                        v.ShirtGraphic = 0
                    elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
                        v[v.ClassName .. "Template"] = 0
                    end
                end
            )
        end
    end
)

Options.Anti_Lag3:SetValue(false)

SecAntiLagsExtension:AddButton({
    Title = "No Render",
    Description = "",
    Callback = function()
        local Lighting = game:GetService("Lighting")
        local Terrain = workspace:FindFirstChildOfClass("Terrain")
        local Players = game:GetService("Players")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.Brightness = 1
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
        end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
            elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj:Destroy()
            elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj:Destroy()
            end
        end
        for _, player in ipairs(Players:GetPlayers()) do
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("Accessory") or part:IsA("Clothing") then
                        part:Destroy()
                    end
                end
            end
        end
    end
})

SecAntiLagsExtension:AddDivider()
SecAntiLagsExtension:AddSpace({ Height = 20 })

SecAntiLagsExtension:AddSpace({ Height = 20 })
SecAntiLagsExtension:AddDivider()

SecShadowsTechnology = Tabs.Extension:AddSection("Shadows / Technology", "solar/moon-bold")
SecShadowsTechnology:AddSpace({ Height = 20 })
SecShadowsTechnology:AddDivider()

defaultGlobalShadows = Lighting.GlobalShadows
defaultTechnology = Lighting.Technology

ShadowsToggle = SecShadowsTechnology:AddToggle("ShadowsToggle", {
    Title = "Remove All Shadows",
    Description = "",
    Default = false
})

ShadowsToggle:OnChanged(function(state)
    pcall(function()
        Lighting.GlobalShadows = not state
        Lighting.Technology = state and Enum.Technology.Compatibility or defaultTechnology
        
        task.spawn(function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.CastShadow = not state
                end
            end
        end)
    end)
end)

DarknessToggle = SecShadowsTechnology:AddToggle("DarknessToggle", {
    Title = "Disable Light",
    Description = "",
    Default = false
})

DarknessToggle:OnChanged(function(state)
    task.spawn(function()
        for _, light in ipairs(workspace:GetDescendants()) do
            if light:IsA("Light") then
                pcall(function()
                    light.Enabled = not state
                end)
            end
        end
    end)
end)

getgenv().FpsConfig = {
    Enabled = false
}

function updateFps()
    pcall(function()
        local target = getgenv().FpsConfig.Enabled and 9999 or 60
        if setfflag then
            setfflag("TaskSchedulerTargetFps", tostring(target))
            setfflag("DFIntTaskSchedulerTargetFps", tostring(target))
        end
        if setfpscap then
            setfpscap(target)
        end
    end)
end

networkPausedConn = nil
AntiGPTPause = SecShadowsTechnology:AddToggle("AntiNetworkPause", {
    Title = "Anti Gameplay Paused", 
    Default = false, 
    Description = ""
})

AntiGPTPause:OnChanged(function(Value)
    if Value then
        pcall(function()
            local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
            local currentPause = RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
            
            if currentPause then 
                currentPause:Destroy() 
            end
            
            networkPausedConn = RobloxGui.ChildAdded:Connect(function(obj)
                if obj.Name == "CoreScripts/NetworkPause" then
                    task.wait() 
                    obj:Destroy()
                end
            end)
        end)
    else
        if networkPausedConn then
            networkPausedConn:Disconnect()
            networkPausedConn = nil
        end
    end
end)

FpsUnlockToggle = SecShadowsTechnology:AddToggle("FpsUnlockToggle", {
    Title = "Unlock FPS",
    Description = "",
    Default = false
})

FpsUnlockToggle:OnChanged(function(Value)
    getgenv().FpsConfig.Enabled = Value
    updateFps()
end)

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(character)
    pcall(function()
        character:WaitForChild("Humanoid", 5)
        task.wait(1)
        if getgenv().FpsConfig.Enabled then
            updateFps()
        end
    end)
end)

if game:GetService("Players").LocalPlayer.Character and getgenv().FpsConfig.Enabled then
    updateFps()
end


Options.Anti_Lag3:SetValue(false)


SecShadowsTechnology:AddDivider()
SecShadowsTechnology:AddSpace({ Height = 20 })

SecFastFlagExtension = Tabs.Extension:AddSection("Fast Flag Extension", "solar/flag-bold")
SecFastFlagExtension:AddSpace({ Height = 20 })
SecFastFlagExtension:AddDivider()


if setfflag then
    SecFastFlagExtension:AddButton(
        {
            Title = "Blox Strap Script",
            Description = "",
            Callback = function()
                loadstring(game:HttpGet('https://raw.githubusercontent.com/qwertyui-is-back/Bloxstrap/main/Initiate.lua'), 'lol')()
            end
        }
    )
    
    SecFastFlagExtension:AddButton(
        {
            Title = "Accurate Low Quality",
            Description = "(FastFlag)",
            Callback = function()

                setfpscap(900)

                setfflag("TaskSchedulerTargetFps", "900") -- for setfpscap unc missing or unsupported for executors

                local function removeWater()
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("Terrain") then
                            obj.WaterTransparency = 1
                            obj.WaterWaveSize = 0
                            obj.WaterWaveSpeed = 0
                            obj.WaterReflectance = 0
                        end
                    end
                end

                local function removeReflections()
                    local lighting = game:GetService("Lighting")
                    lighting.EnvironmentSpecularScale = 0
                    lighting.EnvironmentDiffuseScale = 0
                end

                local function removeEffects()
                    for _, effect in pairs(workspace:GetDescendants()) do
                        if
                            effect:IsA("ParticleEmitter") or effect:IsA("Smoke") or effect:IsA("Fire") or
                                effect:IsA("Sparkles")
                         then
                            effect.Enabled = false
                        end
                    end
                end

                local function removeGrass()
                    setfflag("FRMMinGrassDistance", "0")
                    setfflag("FRMMaxGrassDistance", "0")
                    setfflag("RenderGrassDetailStrands", "0")
                end

                local function removeExplosions()
                    for _, explosion in pairs(workspace:GetDescendants()) do
                        if explosion:IsA("Explosion") then
                            explosion:Destroy()
                        end
                    end
                end

                local function setLowShadows()
                    game.Lighting.Technology = Enum.Technology.Voxel
                    game.Lighting.GlobalShadows = false
                end

                local function setLowQuality()
                    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                end

                local function setFlagsGraphics()
                    setfflag("DebugGraphicsPreferVulkan", "true")
                    setfflag("DebugTextureManagerSkipMips", "2")
                    setfflag("TaskSchedulerLimitTargetFpsTo2402", "false")
                    setfflag("TaskSchedulerTargetFps", "900")
                end

                local function reduceLag()
                    removeWater()
                    removeReflections()
                    --    removeEffects()
                    --    removeExplosions()
                    setLowShadows()
                    setLowQuality()
                    setFlagsGraphics()
                    removeGrass()
                end

                reduceLag()

                workspace.DescendantAdded:Connect(
                    function(descendant)
                        if descendant:IsA("Terrain") then
                            wait(0.5)
                            reduceLag()
                        end
                    end
                )
            end
        }
    )
end

SecPerformance = Tabs.Settings:AddSection("Performance", "solar/gauge-bold")
SecPerformance:AddSpace({ Height = 20 })
SecPerformance:AddDivider()

SecPerformance:AddToggle("FPSCounterToggle", {
    Title = "FPS & Ping Counter",
    Default = true,
    Callback = function(Value)
        ToggleFPSCounter(Value)
    end
})

LP = game:GetService("Players").LocalPlayer
GetMethod = getnamecallmethod
Select = select

old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = GetMethod()

    
    if method == "InvokeServer" and self.Name == "Communicator" then
        
        if self.Parent == LP.Character then
            
            if Select(1, ...) == "update" then
                local cfg = DConfiguration.Misc.PlayerAdjustment.Update
                return cfg.Speed, cfg.JumpHeight
            end
        end
    end

    return old(self, ...)
end))


function initialize(character)
    if character then
        task.delay(5, function()
            if DFunctions and DFunctions.HookMovement then
                DFunctions.HookMovement(character)
            end
        end)
    end
end

LP.CharacterAdded:Connect(initialize)
if LP.Character then
    initialize(LP.Character)
end

MediaManager:SetFolder("GoonWares/Evade/MediaCache")

InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("GoonWares")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
InterfaceManager:LoadSettings()

SaveManager:SetLibrary(Fluent)
SaveManager:SetFolder("GoonWares/Evade/Legacy/Config")
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

FloatingButtonManager:SetLibrary(Fluent)
FloatingButtonManager:SetFolder("GoonWares/Evade/Legacy/Floating")
FloatingButtonManager:BuildConfigSection(Tabs.Settings)
FloatingButtonManager:LoadAutoloadConfig()

Notify("GoonWares", "All tabs loaded successfully", "Success", nil, 4)

task.delay(0.5, function()
    Window:SelectTab(1)
end)
