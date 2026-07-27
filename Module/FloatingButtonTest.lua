local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local FloatingButton = {}
FloatingButton.__index = FloatingButton

local function GetThemeProperty(Fluent, Key, Fallback)
    local Ok, Value = pcall(function()
        return Fluent:GetThemeProperty(Key)
    end)
    if Ok and Value ~= nil then
        return Value
    end
    return Fallback
end

local function ResolveFont(Fluent)
    local IM = Fluent.InterfaceManager
    if IM and IM.Settings and IM.Settings.Font and IM.FontPaths and IM.FontPaths[IM.Settings.Font] then
        local Ok, F = pcall(function()
            return Font.new(IM.FontPaths[IM.Settings.Font], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        end)
        if Ok and F then
            return F
        end
    end
    return Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
end

local function ResolveTextColor(Fluent)
    return GetThemeProperty(Fluent, "Text", Color3.fromRGB(255, 255, 255))
end

local function ResolveIconColor(Fluent)
    return GetThemeProperty(Fluent, "IconColor", ResolveTextColor(Fluent))
end

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
    Frame.BackgroundColor3 = GetThemeProperty(Fluent, "AcrylicMain", Color3.fromRGB(30, 30, 30))
    Frame.BackgroundTransparency = GetThemeProperty(Fluent, "ElementTransparency", 0.1)
    Frame.BorderSizePixel = 0
    Frame.ZIndex = -10
    Frame.Visible = false
    Frame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 15)
    Corner.Parent = Frame

    local TintOverlay = Instance.new("Frame")
    TintOverlay.Name = "Tint"
    TintOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TintOverlay.BackgroundTransparency = 0.4
    TintOverlay.Size = UDim2.fromScale(1, 1)
    TintOverlay.ZIndex = -10
    TintOverlay.Parent = Frame
    Instance.new("UICorner", TintOverlay).CornerRadius = UDim.new(0, 15)

    local TintGradient = Instance.new("UIGradient")
    TintGradient.Rotation = 90
    TintGradient.Color = GetThemeProperty(Fluent, "AcrylicGradient", ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)))
    TintGradient.Parent = TintOverlay

    local NoiseLayer = Instance.new("ImageLabel")
    NoiseLayer.Name = "Noise"
    NoiseLayer.BackgroundTransparency = 1
    NoiseLayer.Image = "rbxassetid://9968344227"
    NoiseLayer.ImageTransparency = GetThemeProperty(Fluent, "AcrylicNoise", 0.9)
    NoiseLayer.ScaleType = Enum.ScaleType.Tile
    NoiseLayer.TileSize = UDim2.new(0, 128, 0, 128)
    NoiseLayer.Size = UDim2.new(1, 0, 1, 0)
    NoiseLayer.ZIndex = -9
    NoiseLayer.Parent = Frame
    Instance.new("UICorner", NoiseLayer).CornerRadius = UDim.new(0, 15)

    local ShineGradient = Instance.new("UIGradient")
    ShineGradient.Parent = Frame

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Color = GetThemeProperty(Fluent, "AcrylicBorder", Color3.new(1, 1, 1))
    Stroke.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = IsToggle and (DisplayText .. ": OFF") or DisplayText
    Button.FontFace = ResolveFont(Fluent)
    Button.TextColor3 = ResolveTextColor(Fluent)
    Button.TextSize = 24
    Button.TextScaled = false
    Button.ZIndex = -9
    Button.Parent = Frame

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 28, 0, 28)
    Toggle.Position = UDim2.new(1, 6, 0.5, -14)
    Toggle.BackgroundColor3 = GetThemeProperty(Fluent, "Element", Color3.fromRGB(40, 40, 40))
    Toggle.Text = "O"
    Toggle.FontFace = ResolveFont(Fluent)
    Toggle.TextColor3 = ResolveIconColor(Fluent)
    Toggle.Visible = false
    Toggle.ZIndex = -8
    Toggle.Parent = Frame
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Thickness = 1
    ToggleStroke.Color = GetThemeProperty(Fluent, "AcrylicBorder", Color3.new(1, 1, 1))
    ToggleStroke.Parent = Toggle

    local function ResolveTransparent()
        return Fluent.WindowTransparent and true or false
    end

    local function GetShine(Fluent)
        local Ok, Result = pcall(function()
            return Fluent:GetShine()
        end)
        if Ok and Result then
            return Result
        end
        return nil
    end

    local ShineTime = 0

    task.spawn(function()
        while task.wait(0.03) do
            if not Frame.Parent then break end

            local Transparent = ResolveTransparent()
            local BaseTransparency = GetThemeProperty(Fluent, "ElementTransparency", 0.1)
            local ShineInfo = GetShine(Fluent)
            local BorderColor = GetThemeProperty(Fluent, "AcrylicBorder", Stroke.Color)
            local WindowAnimated = Fluent.ShineEnabled and true or false
            local Active = WindowAnimated and ShineInfo and ShineInfo.Enabled and ShineInfo.Shine

            Frame.BackgroundColor3 = GetThemeProperty(Fluent, "AcrylicMain", Frame.BackgroundColor3)
            Frame.BackgroundTransparency = Transparent and math.clamp(BaseTransparency + 0.55, 0, 0.95) or BaseTransparency
            TintGradient.Color = GetThemeProperty(Fluent, "AcrylicGradient", TintGradient.Color)
            NoiseLayer.ImageTransparency = GetThemeProperty(Fluent, "AcrylicNoise", 0.9)

            if Active then
                local Speed = ShineInfo.Shine.Speed or 0.5
                local RotationSpeed = ShineInfo.Shine.RotationSpeed or 25
                ShineTime += 0.03 * Speed
                ShineGradient.Rotation = (ShineTime * RotationSpeed) % 360
                ShineGradient.Offset = Vector2.new(math.sin(ShineTime * 0.6) * 0.18, ShineGradient.Offset.Y)
                if ShineInfo.Shine.ColorSequence then
                    ShineGradient.Color = ShineInfo.Shine.ColorSequence
                end
                ShineGradient.Transparency = NumberSequence.new(0)

                if ShineInfo.StrokeShine and ShineInfo.StrokeDark and ShineInfo.Accent then
                    local Pulse = (math.sin(ShineTime) + 1) / 2
                    Stroke.Thickness = 1.25 + Pulse * 1.25
                    Stroke.Color = ShineInfo.StrokeDark:Lerp(ShineInfo.Accent, Pulse)
                else
                    Stroke.Thickness = 1
                    Stroke.Color = BorderColor
                end
            else
                ShineTime = 0
                ShineGradient.Transparency = NumberSequence.new(1)
                Stroke.Thickness = 1
                Stroke.Color = BorderColor
            end

            ToggleStroke.Thickness = Stroke.Thickness
            ToggleStroke.Color = Stroke.Color

            local NewFont = ResolveFont(Fluent)
            if Button.FontFace ~= NewFont then
                Button.FontFace = NewFont
                Toggle.FontFace = NewFont
            end
            Button.TextColor3 = ResolveTextColor(Fluent)
            Toggle.TextColor3 = ResolveIconColor(Fluent)
        end
    end)

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
            Toggle.Text = "#"
        else
            local Entry = self.FloatButtonSizes[ButtonName]
            local LiveW = Entry and Entry.W or SavedW
            local LiveH = Entry and Entry.H or SavedH
            Frame.Size = UDim2.new(0, LiveW, 0, LiveH)
            Button.TextWrapped = false
            Button.TextScaled = false
            Button.TextSize = 24
            Corner.CornerRadius = UDim.new(0, 15)
            Toggle.Text = "O"
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
