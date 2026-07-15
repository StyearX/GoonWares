local UserInputService = game:GetService("UserInputService")
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

function FloatingButton.new(Fluent, FloatingButtonManager)
    local Self = setmetatable({}, FloatingButton)
    Self.Fluent = Fluent
    Self.FloatingButtonManager = FloatingButtonManager
    Self.FloatButtonSizes = {}
    return Self
end

function FloatingButton:Create(ButtonName, DisplayText, IsToggle, OnClick)
    local Fluent = self.Fluent
    local SavedW = (self.FloatButtonSizes[ButtonName] and self.FloatButtonSizes[ButtonName].W) or 200
    local SavedH = (self.FloatButtonSizes[ButtonName] and self.FloatButtonSizes[ButtonName].H) or 70

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = ButtonName
    ScreenGui.Parent = LocalPlayer.PlayerGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = -2147483648
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = false

    local Frame = Instance.new("Frame")
    Frame.Name = ButtonName
    Frame.Size = UDim2.new(0, SavedW, 0, SavedH)
    Frame.Position = UDim2.new(0.5, -SavedW / 2, 0.5, -SavedH / 2)
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame.BackgroundTransparency = 0.7
    Frame.ZIndex = -10
    Frame.Visible = false
    Frame.Parent = ScreenGui

    local Gradient = Instance.new("UIGradient")
    Gradient.Color = (Fluent:GetButtonGradient() or Fluent.ButtonGradients).Background
    Gradient.Parent = Frame

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 2
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Color = Color3.new(1, 1, 1)
    Stroke.Parent = Frame

    local GradientStroke = Instance.new("UIGradient")
    GradientStroke.Color = (Fluent:GetButtonGradient() or Fluent.ButtonGradients).Stroke
    GradientStroke.Rotation = 0
    GradientStroke.Parent = Stroke

    task.spawn(function()
        while task.wait(0.03) do
            if not Frame.Parent then break end
            local Grad = Fluent:GetButtonGradient() or Fluent.ButtonGradients
            Frame.BackgroundTransparency = Fluent.UseAcrylic and 0.45 or 0.7
            if Fluent.ShineEnabled then
                Gradient.Rotation = (Gradient.Rotation + 1) % 360
                GradientStroke.Rotation = (GradientStroke.Rotation + 0.5) % 360
            end
            Gradient.Color = Grad.Background
            GradientStroke.Color = Grad.Stroke
        end
    end)

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 15)
    Corner.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = IsToggle and (DisplayText .. ": OFF") or DisplayText
    Button.Font = Enum.Font.SourceSansBold
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 24
    Button.TextScaled = false
    Button.ZIndex = -9
    Button.Parent = Frame

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 28, 0, 28)
    Toggle.Position = UDim2.new(1, 6, 0.5, -14)
    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Toggle.Text = "○"
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Visible = false
    Toggle.ZIndex = -8
    Toggle.Parent = Frame
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

    local Holding, HoldStart, HideAt = false, 0, 0

    Frame:SetAttribute("IsCircle", false)

    local function ApplyShape(Circle)
        Frame:SetAttribute("IsCircle", Circle)
        local S = math.min(Frame.AbsoluteSize.X, Frame.AbsoluteSize.Y)
        if Circle then
            Frame.Size = UDim2.new(0, S, 0, S)
            Button.TextWrapped = true
            Button.TextScaled = true
            Button.TextSize = math.floor(S * 0.45)
            Corner.CornerRadius = UDim.new(1, 0)
            Toggle.Text = "▢"
        else
            local Entry = self.FloatButtonSizes[ButtonName]
            local LiveW = Entry and Entry.W or SavedW
            local LiveH = Entry and Entry.H or SavedH
            Frame.Size = UDim2.new(0, LiveW, 0, LiveH)
            Button.TextWrapped = false
            Button.TextScaled = false
            Button.TextSize = 24
            Corner.CornerRadius = UDim.new(0, 15)
            Toggle.Text = "○"
        end
    end

    if self.FloatingButtonManager then
        self.FloatingButtonManager:AddButton(ButtonName, Frame, false)
    end
    self.FloatButtonSizes[ButtonName] = { W = SavedW, H = SavedH, Frame = Frame, Button = Button, ApplyShape = ApplyShape }

    ApplyShape(false)

    task.spawn(function()
        while task.wait(0.25) do
            if not Frame.Parent then break end
            if Toggle.Visible and tick() - HideAt >= 10 then Toggle.Visible = false end
        end
    end)

    Button.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Holding = true
            HoldStart = tick()
        end
    end)
    Button.InputEnded:Connect(function(Input)
        if Holding and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
            Holding = false
            if tick() - HoldStart >= 0.6 then
                Toggle.Visible = true
                HideAt = tick()
            end
        end
    end)
    Toggle.MouseButton1Click:Connect(function()
        HideAt = tick()
        ApplyShape(not Frame:GetAttribute("IsCircle"))
    end)
    Button.Activated:Connect(function()
        if OnClick then OnClick(Button) end
    end)

    MakeDraggable(Button, Frame, false, Fluent)

    return Frame, Button, ApplyShape
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

function FloatingButton.SetVisible(Frame, State)
    if Frame then Frame.Visible = State end
end

function FloatingButton.SetText(Button, Text)
    if Button then Button.Text = Text end
end

function FloatingButton.SetActive(Button, State, Name)
    if not Button then return end
    Button.Text = Name .. ": " .. (State and "ON" or "OFF")
end

return FloatingButton
