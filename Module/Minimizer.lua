local Assets = {
    ["Dark"]          = "rbxassetid://86279155951835",
    ["Charcoal"]      = "rbxassetid://82226122951505",
    ["Pearl White"]   = "rbxassetid://91320093440746",
    ["Blood Red"]     = "rbxassetid://82205615960902",
    ["Neon Purple"]   = "rbxassetid://110957923613210",
    ["Deep Ocean"]    = "rbxassetid://127827606564812",
    ["Midnight Blue"] = "rbxassetid://97112981435539",
    ["Royal Blue"]    = "rbxassetid://102100010369948",
    ["Deep Violet"]   = "rbxassetid://91200743213281",
    ["Rose"]          = "rbxassetid://104779263408939",
    ["Neon Cyber"]    = "rbxassetid://82623467807182",
    ["Arctic Frost"]  = "rbxassetid://78696054799457",
    ["Cotton Candy"]  = "rbxassetid://109732346913006",
    ["Cyanic"]        = "rbxassetid://78285794098636",
    ["Amber Glow"]    = "rbxassetid://133651474640621",
    ["Bloomings"]     = "rbxassetid://84181815152601",
    ["Crimson"]       = "rbxassetid://117347774984857",
    ["Gold"]          = "rbxassetid://120702857407079",
    ["Lavender Pink"] = "rbxassetid://126095928220634",
}

local OpenShit = Instance.new("ScreenGui")
OpenShit.Name = "OpenShit"
OpenShit.Parent = game.CoreGui
OpenShit.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
OpenShit.ResetOnSpawn = false

local MainOpen = Instance.new("TextButton")
MainOpen.Name = "MainOpen"
MainOpen.Parent = OpenShit
MainOpen.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainOpen.BackgroundTransparency = 1
MainOpen.Position = UDim2.new(0.101969875, 0, 0.110441767, 0)
MainOpen.Size = UDim2.new(0, 64, 0, 42)
MainOpen.Text = ""
MainOpen.Visible = true

local MainOpenCorner = Instance.new("UICorner")
MainOpenCorner.Parent = MainOpen

local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "RotatingBackground"
BackgroundImage.Parent = MainOpen
BackgroundImage.Size = UDim2.new(2.4, 0, 2.4, 0)
BackgroundImage.Position = UDim2.new(0.5, 0, 0.5, 0)
BackgroundImage.AnchorPoint = Vector2.new(0.5, 0.5)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = ""
BackgroundImage.SizeConstraint = Enum.SizeConstraint.RelativeXX
BackgroundImage.ZIndex = 0

local FrontImage = Instance.new("ImageLabel")
FrontImage.Name = "StaticIcon"
FrontImage.Parent = MainOpen
FrontImage.Size = UDim2.new(0.8, 0, 1, 0)
FrontImage.Position = UDim2.new(0.5, 0, 0.5, 0)
FrontImage.AnchorPoint = Vector2.new(0.5, 0.5)
FrontImage.BackgroundTransparency = 1
FrontImage.Image = "rbxassetid://109639117875913"
FrontImage.ZIndex = 1

local FrontCorner = Instance.new("UICorner")
FrontCorner.CornerRadius = UDim.new(1, 0)
FrontCorner.Parent = FrontImage

local Rotation = 0
local Speed = 90
local LastTime = tick()

task.spawn(function()
    while true do
        local Now = tick()
        local Delta = Now - LastTime
        LastTime = Now
        Rotation = (Rotation + Speed * Delta) % 360
        BackgroundImage.Rotation = Rotation
        task.wait()
    end
end)

local function UpdateTheme(ThemeName)
    BackgroundImage.Image = Assets[ThemeName] or ""
end

local LastTheme = nil
task.spawn(function()
    while true do
        task.wait(0.1)
        if not (Fluent and Fluent.Theme) then continue end
        local CurrentTheme = Fluent.Theme
        if CurrentTheme ~= LastTheme then
            LastTheme = CurrentTheme
            UpdateTheme(CurrentTheme)
        end
    end
end)

local function MakeDraggable(TopbarObject, Object, Locked)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition
    local Holding = false
    local HoldTime = 1.0
    local MoveCancelThreshold = 6
    local HoldToken = 0

    Object:SetAttribute("Locked", Locked or false)

    local function Update(Input)
        if Object:GetAttribute("Locked") then return end
        local Delta = Input.Position - DragStart
        Object.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end

    local function ToggleLock()
        local NewState = not Object:GetAttribute("Locked")
        Object:SetAttribute("Locked", NewState)
        if Fluent then
            Fluent:Notify({
                Title = NewState and "Button Locked" or "Button Unlocked",
                Content = NewState and "This button is now locked in place." or "This button can now be moved.",
                Duration = 2
            })
        end
    end

    TopbarObject.InputBegan:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then return end
        Dragging = not Object:GetAttribute("Locked")
        Holding = true
        DragStart = Input.Position
        StartPosition = Object.Position
        HoldToken += 1
        local Token = HoldToken
        task.delay(HoldTime, function()
            if Holding and Token == HoldToken then ToggleLock() end
        end)
        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
                Holding = false
            end
        end)
    end)

    TopbarObject.InputChanged:Connect(function(Input)
        if not DragStart then return end
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            if (Input.Position - DragStart).Magnitude > MoveCancelThreshold then Holding = false end
            DragInput = Input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then Update(Input) end
    end)
end

MakeDraggable(MainOpen, MainOpen, false)

local function PlaySound(SoundId)
    local Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://" .. SoundId
    Sound.Parent = game:GetService("SoundService")
    Sound:Play()
    Sound.Ended:Connect(function() Sound:Destroy() end)
end

MainOpen.MouseButton1Click:Connect(function()
    local Sounds = { "7127123605", "137566474343039", "438666542", "257001341", "257000833", "7127123554", "131607746976396", "97325669841459", "109312518223078" }
    PlaySound(Sounds[math.random(#Sounds)])
    if Window then Window:Minimize() end
    local function SmoothSpeed(Target, Duration)
        local Start = Speed
        local Steps = 30
        for I = 1, Steps do
            Speed = Start + (Target - Start) * (I / Steps)
            task.wait(Duration / Steps)
        end
        Speed = Target
    end
    SmoothSpeed(360, 0.4)
    task.wait(0.5)
    SmoothSpeed(180, 0.4)
    task.wait(0.3)
    SmoothSpeed(90, 0.4)
end)
