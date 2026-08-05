local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local FloatingButton = {}
FloatingButton.__index = FloatingButton

local function MakeDraggable(TopbarObject, Object, Locked, Fluent)
    local Dragging, DragInput, DragStart, StartPosition = false, nil, nil, nil
    local Holding, HoldTime, MoveCancelThreshold, HoldToken = false, 1.0, 6, 0
    Object:SetAttribute("Locked", Locked or false)

    local function Update(Input)
        if Object:GetAttribute("Locked") then return end
        local Delta = Input.Position - DragStart
        Object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
    end

    local function ToggleLock()
        local NewState = not Object:GetAttribute("Locked")
        Object:SetAttribute("Locked", NewState)
        if Fluent and Fluent.Notify then
            Fluent:Notify({
                Title = NewState and "Button Locked" or "Button Unlocked",
                Content = NewState and "Locked in place." or "Can now be moved.",
                Duration = 2,
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

    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then Update(Input) end
    end)
end

local function GetOrCreateFloatingButtonFolder(ButtonName)
    local CoreGui = game:GetService("CoreGui")
    local GoonWaresRoot = CoreGui:FindFirstChild("GoonWares")
    if not GoonWaresRoot then
        GoonWaresRoot = Instance.new("Folder")
        GoonWaresRoot.Name = "GoonWares"
        GoonWaresRoot.Parent = CoreGui
    end
    local FloatingRoot = GoonWaresRoot:FindFirstChild("FloatingButton")
    if not FloatingRoot then
        FloatingRoot = Instance.new("Folder")
        FloatingRoot.Name = "FloatingButton"
        FloatingRoot.Parent = GoonWaresRoot
    end
    local ButtonFolder = FloatingRoot:FindFirstChild(ButtonName)
    if not ButtonFolder then
        ButtonFolder = Instance.new("Folder")
        ButtonFolder.Name = ButtonName
        ButtonFolder.Parent = FloatingRoot
    end
    return ButtonFolder, FloatingRoot
end

local function BuildFrame(ButtonName, SavedW, SavedH, Fluent)
    local ButtonFolder, FloatingRoot = GetOrCreateFloatingButtonFolder(ButtonName)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = ButtonName
    ScreenGui.Parent = ButtonFolder
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 0
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = false

    local Frame = Instance.new("Frame")
    Frame.Name = ButtonName
    Frame.Size = UDim2.new(0, SavedW, 0, SavedH)
    Frame.Position = UDim2.new(0.5, -SavedW / 2, 0.5, -SavedH / 2)
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame.BackgroundTransparency = 0.85
    Frame.ZIndex = -10
    Frame.Visible = false
    Frame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 15)
    Corner.Parent = Frame

    local Gradient = Instance.new("UIGradient")
    Gradient.Color = (Fluent:GetButtonGradient() or Fluent.ButtonGradients).Background
    Gradient.Rotation = 0
    Gradient.Parent = Frame

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1.5
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Color = Color3.new(1, 1, 1)
    Stroke.Parent = Frame

    local GradientStroke = Instance.new("UIGradient")
    GradientStroke.Color = (Fluent:GetButtonGradient() or Fluent.ButtonGradients).Stroke
    GradientStroke.Rotation = 0
    GradientStroke.Parent = Stroke

    local Noise = Instance.new("ImageLabel")
    Noise.Name = "_FBNoise"
    Noise.Image = "rbxassetid://9968344227"
    Noise.ScaleType = Enum.ScaleType.Tile
    Noise.TileSize = UDim2.new(0, 128, 0, 128)
    Noise.Size = UDim2.fromScale(1, 1)
    Noise.BackgroundTransparency = 1
    Noise.ImageTransparency = 0.92
    Noise.ZIndex = -8
    Noise.Parent = Frame
    local NoiseCorner = Instance.new("UICorner")
    NoiseCorner.CornerRadius = UDim.new(0, 15)
    NoiseCorner.Parent = Noise

    local GlassLayer = Instance.new("Frame")
    GlassLayer.Name = "_FBGlass"
    GlassLayer.Size = UDim2.fromScale(1, 1)
    GlassLayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GlassLayer.BackgroundTransparency = 0.88
    GlassLayer.BorderSizePixel = 0
    GlassLayer.ZIndex = -9
    GlassLayer.Parent = Frame
    local GlassCorner = Instance.new("UICorner")
    GlassCorner.CornerRadius = UDim.new(0, 15)
    GlassCorner.Parent = GlassLayer
    local GlassGradient = Instance.new("UIGradient")
    GlassGradient.Rotation = 90
    GlassGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180)),
    })
    GlassGradient.Parent = GlassLayer

    return ScreenGui, Frame, Corner, Gradient, Stroke, GradientStroke, Noise, NoiseCorner, GlassLayer, GlassCorner, GlassGradient
end

local function BuildInputFrame(ButtonName, SavedW, SavedH)
    local ButtonFolder = GetOrCreateFloatingButtonFolder(ButtonName)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = ButtonName .. "_Input"
    ScreenGui.Parent = ButtonFolder
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 0
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = false

    local Frame = Instance.new("Frame")
    Frame.Name = ButtonName
    Frame.Size = UDim2.new(0, SavedW, 0, SavedH)
    Frame.Position = UDim2.new(0.5, -SavedW / 2, 0.5, -SavedH / 2)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0.5
    Frame.ZIndex = -10
    Frame.Visible = false
    Frame.Parent = ScreenGui

    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 15)
    FrameCorner.Parent = Frame

    local OuterStroke = Instance.new("UIStroke")
    OuterStroke.Thickness = 3
    OuterStroke.Transparency = 0.8
    OuterStroke.Color = Color3.fromRGB(255, 255, 255)
    OuterStroke.Parent = Frame

    local InnerFrame = Instance.new("Frame")
    InnerFrame.Size = UDim2.new(1, 6, 1, 6)
    InnerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    InnerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    InnerFrame.BackgroundTransparency = 1
    InnerFrame.ZIndex = -9
    InnerFrame.Parent = Frame

    local InnerFrameCorner = Instance.new("UICorner")
    InnerFrameCorner.CornerRadius = UDim.new(0, 15)
    InnerFrameCorner.Parent = InnerFrame

    local InnerStroke = Instance.new("UIStroke")
    InnerStroke.Thickness = 2
    InnerStroke.Transparency = 0.6
    InnerStroke.Color = Color3.fromRGB(0, 0, 0)
    InnerStroke.Parent = InnerFrame

    return ScreenGui, Frame, FrameCorner, InnerFrameCorner
end

local function StartFrameLoop(Frame, Gradient, GradientStroke, Stroke, Noise, NoiseCorner, Corner, GlassLayer, GlassCorner, Fluent)
    local Conn = nil
    local t = 0

    Conn = RunService.RenderStepped:Connect(function(dt)
        if not Frame or not Frame.Parent then
            Conn:Disconnect()
            Conn = nil
            return
        end

        local Transparent = Fluent.WindowTransparent
        Frame.BackgroundTransparency = Transparent and 0.27 or 0

        local Animated = Fluent.ShineEnabled == true
        local Grad = Fluent:GetButtonGradient() or Fluent.ButtonGradients

        if Animated then
            t += dt
            Gradient.Rotation = (t * 30) % 360
            GradientStroke.Rotation = (t * 15) % 360
            Gradient.Offset = Vector2.new(math.sin(t * 0.4) * 0.15, Gradient.Offset.Y)
            local Pulse = (math.sin(t * 0.5 * math.pi) + 1) / 2
            Stroke.Thickness = 1.25 + Pulse * 0.75
        else
            Gradient.Rotation = 0
            GradientStroke.Rotation = 0
            Gradient.Offset = Vector2.new(0, 0)
            Stroke.Thickness = 1.5
            Stroke.Color = Color3.new(1, 1, 1)
        end

        Gradient.Color = Grad.Background
        GradientStroke.Color = Grad.Stroke

        local IsCircle = Frame:GetAttribute("IsCircle")
        local R = IsCircle and UDim.new(1, 0) or UDim.new(0, 15)
        if Corner.CornerRadius ~= R then
            Corner.CornerRadius = R
            NoiseCorner.CornerRadius = R
            GlassCorner.CornerRadius = R
        end
    end)

    return function()
        if Conn then Conn:Disconnect(); Conn = nil end
    end
end

function FloatingButton.new(Fluent, FloatingButtonManager)
    local Self = setmetatable({}, FloatingButton)
    Self.Fluent = Fluent
    Self.FloatingButtonManager = FloatingButtonManager
    Self.FloatButtonSizes = {}
    Self.ButtonModes = {}
    return Self
end

function FloatingButton:Create(ButtonName, DisplayText, IsToggle, OnClick)
    local Fluent = self.Fluent
    local SavedW = (self.FloatButtonSizes[ButtonName] and self.FloatButtonSizes[ButtonName].W) or 200
    local SavedH = (self.FloatButtonSizes[ButtonName] and self.FloatButtonSizes[ButtonName].H) or 70

    local ClickedText = nil
    local ClickCallback = nil
    if not IsToggle then
        if type(OnClick) == "string" then
            ClickedText = OnClick
            OnClick = nil
        elseif type(OnClick) == "table" then
            ClickedText = OnClick.Text
            ClickCallback = OnClick.Callback
            OnClick = nil
        end
    end

    local ScreenGui, Frame, Corner, Gradient, Stroke, GradientStroke, Noise, NoiseCorner, GlassLayer, GlassCorner, GlassGradient =
        BuildFrame(ButtonName, SavedW, SavedH, Fluent)

    local InputScreenGui, InputFrame, InputFrameCorner, InputInnerFrameCorner =
        BuildInputFrame(ButtonName, SavedW, SavedH)

    local StopLoop = StartFrameLoop(Frame, Gradient, GradientStroke, Stroke, Noise, NoiseCorner, Corner, GlassLayer, GlassCorner, Fluent)
    Frame:SetAttribute("CurrentMode", "Fluent")
    local InputFrameRef = Instance.new("ObjectValue")
    InputFrameRef.Name = "_InputFrame"
    InputFrameRef.Value = InputFrame
    InputFrameRef.Parent = Frame

    Frame.AncestryChanged:Connect(function()
        if not Frame.Parent then
            StopLoop()
            local ButtonFolder, FloatingRoot = GetOrCreateFloatingButtonFolder(ButtonName)
            if ButtonFolder and #ButtonFolder:GetChildren() == 0 then
                ButtonFolder:Destroy()
            end
        end
    end)

    local CurrentMode = "Fluent"
    self.ButtonModes[ButtonName] = "Fluent"

    local function GetActiveFrame()
        return CurrentMode == "Input" and InputFrame or Frame
    end

    local function SyncPosition()
        local Active = GetActiveFrame()
        local Other = CurrentMode == "Input" and Frame or InputFrame
        Other.Position = Active.Position
    end

    local function SetMode(Mode)
        SyncPosition()
        CurrentMode = Mode
        self.ButtonModes[ButtonName] = Mode
        Frame:SetAttribute("CurrentMode", Mode)
        local IsVisible = Frame.Visible or InputFrame.Visible
        Frame.Visible = Mode == "Fluent" and IsVisible
        InputFrame.Visible = Mode == "Input" and IsVisible
    end

    local Holding, HoldStart, HideAt = false, 0, 0
    local OriginalDisplayText = DisplayText
    local IsClicked = false

    Frame:SetAttribute("IsCircle", false)
    InputFrame:SetAttribute("IsCircle", false)

    local FluBtn = Instance.new("TextButton")
    FluBtn.Size = UDim2.new(1, 0, 1, 0)
    FluBtn.BackgroundTransparency = 1
    FluBtn.Text = IsToggle and (DisplayText .. ": OFF") or DisplayText
    FluBtn.Font = Enum.Font.SourceSansBold
    FluBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    FluBtn.TextSize = 24
    FluBtn.TextScaled = false
    FluBtn.ZIndex = -7
    FluBtn.Parent = Frame

    local FluToggle = Instance.new("TextButton")
    FluToggle.Size = UDim2.new(0, 28, 0, 28)
    FluToggle.Position = UDim2.new(1, 6, 0.5, -14)
    FluToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    FluToggle.Text = "○"
    FluToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    FluToggle.Visible = false
    FluToggle.ZIndex = -6
    FluToggle.Parent = Frame
    Instance.new("UICorner", FluToggle).CornerRadius = UDim.new(1, 0)

    local InBtn = Instance.new("TextButton")
    InBtn.Size = UDim2.new(1, 0, 1, 0)
    InBtn.BackgroundTransparency = 1
    InBtn.Text = IsToggle and (DisplayText .. ": OFF") or DisplayText
    InBtn.Font = Enum.Font.GothamBold
    InBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    InBtn.TextTransparency = 0.7
    InBtn.TextSize = 24
    InBtn.TextScaled = false
    InBtn.ZIndex = -7
    InBtn.Parent = InputFrame

    local InToggle = Instance.new("TextButton")
    InToggle.Size = UDim2.new(0, 28, 0, 28)
    InToggle.Position = UDim2.new(1, 6, 0.5, -14)
    InToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    InToggle.Text = "○"
    InToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    InToggle.Visible = false
    InToggle.ZIndex = -6
    InToggle.Parent = InputFrame
    Instance.new("UICorner", InToggle).CornerRadius = UDim.new(1, 0)

    local function ApplyInputShape(Circle, S)
        InputFrame:SetAttribute("IsCircle", Circle)
        if Circle then
            InputFrame.Size = UDim2.new(0, S, 0, S)
            InputFrameCorner.CornerRadius = UDim.new(1, 0)
            InputInnerFrameCorner.CornerRadius = UDim.new(1, 0)
        else
            local Entry = self.FloatButtonSizes[ButtonName]
            local LiveW = Entry and Entry.W or SavedW
            local LiveH = Entry and Entry.H or SavedH
            InputFrame.Size = UDim2.new(0, LiveW, 0, LiveH)
            InputFrameCorner.CornerRadius = UDim.new(0, 15)
            InputInnerFrameCorner.CornerRadius = UDim.new(0, 15)
        end
    end

    local function ApplyShape(Circle)
        Frame:SetAttribute("IsCircle", Circle)
        local S = math.min(Frame.AbsoluteSize.X, Frame.AbsoluteSize.Y)

        if Circle then
            Frame.Size = UDim2.new(0, S, 0, S)
            local R = UDim.new(1, 0)
            Corner.CornerRadius = R
            NoiseCorner.CornerRadius = R
            GlassCorner.CornerRadius = R
            FluBtn.TextWrapped = true
            FluBtn.TextScaled = true
            FluBtn.TextSize = math.floor(S * 0.45)
            FluToggle.Text = "▢"
        else
            local Entry = self.FloatButtonSizes[ButtonName]
            local LiveW = Entry and Entry.W or SavedW
            local LiveH = Entry and Entry.H or SavedH
            Frame.Size = UDim2.new(0, LiveW, 0, LiveH)
            local R = UDim.new(0, 15)
            Corner.CornerRadius = R
            NoiseCorner.CornerRadius = R
            GlassCorner.CornerRadius = R
            FluBtn.TextWrapped = false
            FluBtn.TextScaled = false
            FluBtn.TextSize = 24
            FluToggle.Text = "○"
        end

        local InputS = math.min(InputFrame.AbsoluteSize.X, InputFrame.AbsoluteSize.Y)
        ApplyInputShape(Circle, InputS)
        InBtn.TextWrapped = Circle
        InBtn.TextScaled = Circle
        if not Circle then InBtn.TextSize = 24 end
        InToggle.Text = Circle and "▢" or "○"
    end

    if self.FloatingButtonManager then
        self.FloatingButtonManager:AddButton(ButtonName, Frame, false)
    end
    self.FloatButtonSizes[ButtonName] = { W = SavedW, H = SavedH, Frame = Frame, InputFrame = InputFrame, Button = FluBtn, InButton = InBtn, ApplyShape = ApplyShape }

    ApplyShape(false)

    task.spawn(function()
        while task.wait(0.25) do
            if not Frame.Parent then break end
            if FluToggle.Visible and tick() - HideAt >= 10 then FluToggle.Visible = false end
            if InToggle.Visible and tick() - HideAt >= 10 then InToggle.Visible = false end
        end
    end)

    FluBtn.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Holding = true
            HoldStart = tick()
        end
    end)
    FluBtn.InputEnded:Connect(function(Input)
        if Holding and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
            Holding = false
            if tick() - HoldStart >= 0.6 then
                FluToggle.Visible = true
                HideAt = tick()
            end
        end
    end)

    InBtn.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Holding = true
            HoldStart = tick()
            InputFrame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
            InputFrame.BackgroundTransparency = 0.2
            InBtn.TextColor3 = Color3.fromRGB(26, 26, 26)
            InBtn.TextTransparency = 0.6
        end
    end)
    InBtn.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            InputFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            InputFrame.BackgroundTransparency = 0.5
            InBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            InBtn.TextTransparency = 0.7
            if Holding then
                Holding = false
                if tick() - HoldStart >= 0.6 then
                    InToggle.Visible = true
                    HideAt = tick()
                end
            end
        end
    end)

    FluToggle.MouseButton1Click:Connect(function()
        HideAt = tick()
        ApplyShape(not Frame:GetAttribute("IsCircle"))
    end)
    InToggle.MouseButton1Click:Connect(function()
        HideAt = tick()
        ApplyShape(not InputFrame:GetAttribute("IsCircle"))
    end)

    local function HandleActivated(Button)
        if not IsToggle and ClickedText then
            if IsClicked then return end
            IsClicked = true
            Button.Text = ClickedText
            FluBtn.Text = ClickedText
            InBtn.Text = ClickedText
            task.delay(1.2, function()
                if Button and Button.Parent then
                    FluBtn.Text = OriginalDisplayText
                    InBtn.Text = OriginalDisplayText
                    IsClicked = false
                end
            end)
            if ClickCallback then task.spawn(ClickCallback, Button) end
        else
            if OnClick then OnClick(Button) end
        end
    end

    FluBtn.Activated:Connect(function() HandleActivated(FluBtn) end)
    InBtn.Activated:Connect(function() HandleActivated(InBtn) end)

    MakeDraggable(FluBtn, Frame, false, Fluent)
    MakeDraggable(InBtn, InputFrame, false, Fluent)

    return Frame, FluBtn, ApplyShape, SetMode, InputFrame, InBtn
end

function FloatingButton:AddSizeInputs(Section, ButtonName, DisplayText)
    Section:AddInput(ButtonName .. "_Size", {
        Title = "Size",
        Placeholder = "200x70",
        Default = "200x70",
        Finished = true,
        Description = "Format: ValueXValue (e.g. 200x70)",
        Callback = function(Value)
            local W, H = tostring(Value):match("^(%d+)[xX](%d+)$")
            W = tonumber(W)
            H = tonumber(H)
            if W and H and W > 0 and H > 0 and self.FloatButtonSizes[ButtonName] then
                local Entry = self.FloatButtonSizes[ButtonName]
                Entry.W = W
                Entry.H = H
                local F = Entry.Frame
                if F and not F:GetAttribute("IsCircle") then
                    F.Size = UDim2.new(0, W, 0, H)
                end
                local IF = Entry.InputFrame
                if IF and not IF:GetAttribute("IsCircle") then
                    IF.Size = UDim2.new(0, W, 0, H)
                end
            end
        end,
    })
end

function FloatingButton:AddKeybind(Section, ButtonName, DisplayText, Callback, DefaultKey)
    Section:AddKeybind(ButtonName .. "_Keybind", {
        Title = (DisplayText or ButtonName) .. " Keybind",
        Description = "Trigger " .. (DisplayText or ButtonName),
        Default = DefaultKey or "",
        Callback = Callback,
    })
end

function FloatingButton:AddModeDropdown(Section, ButtonName, SetMode)
    Section:AddDropdown(ButtonName .. "_Mode", {
        Title = "Floating Button Style",
        Description = "Choose the visual style for this floating button",
        Values = { "Fluent", "Input" },
        Default = "Fluent",
        Search = false,
        ThemedDropdown = true,
        Callback = function(Value)
            if SetMode then SetMode(Value) end
        end,
    })
end

function FloatingButton.SetVisible(Frame, State)
    if not Frame then return end
    local Mode = Frame:GetAttribute("CurrentMode") or "Fluent"
    local InputRef = Frame:FindFirstChild("_InputFrame")
    local InputFrame = InputRef and InputRef.Value
    if Mode == "Input" then
        Frame.Visible = false
        if InputFrame then InputFrame.Visible = State end
    else
        Frame.Visible = State
        if InputFrame then InputFrame.Visible = false end
    end
end

function FloatingButton.SetText(Button, Text)
    if Button then Button.Text = Text end
end

function FloatingButton.SetActive(Button, State, Name)
    if not Button then return end
    Button.Text = Name .. ": " .. (State and "ON" or "OFF")
end

return FloatingButton
