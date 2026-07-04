local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer

getgenv().ButtonGradients = getgenv().ButtonGradients or {
    Background = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 5, 15)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 3, 8))
    }),
    Stroke = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 20, 45)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 30, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 20, 45))
    })
}

local FloatButtonSizes = {}
local FloatButtonManager = {
    Buttons = {},
    AddButton = function(self, name, frame, isToggle, visible, keybind, buttonRef)
        self.Buttons[name] = {Frame = frame, IsToggle = isToggle, Visible = visible, Keybind = keybind, ButtonRef = buttonRef}
    end,
    SetVisible = function(self, name, state)
        local data = self.Buttons[name]
        if data and data.Frame then
            data.Frame.Visible = state
            data.Visible = state
        end
    end,
    ToggleVisible = function(self, name)
        local data = self.Buttons[name]
        if data and data.Frame then
            data.Frame.Visible = not data.Frame.Visible
            data.Visible = data.Frame.Visible
        end
    end
}

function CreateFloatingButton(buttonName, displayText, isToggle)
    local savedW = (FloatButtonSizes[buttonName] and FloatButtonSizes[buttonName].W) or 200
    local savedH = (FloatButtonSizes[buttonName] and FloatButtonSizes[buttonName].H) or 70

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = buttonName
    screenGui.Parent = LocalPlayer.PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = -2147483648
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = false

    local frame = Instance.new("Frame")
    frame.Name = buttonName
    frame.Size = UDim2.new(0, savedW, 0, savedH)
    frame.Position = UDim2.new(0.5, -savedW / 2, 0.5, -savedH / 2)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BackgroundTransparency = 0.7
    frame.ZIndex = -10
    frame.Visible = false
    frame.Parent = screenGui

    local gradient = Instance.new("UIGradient")
    gradient.Color = getgenv().ButtonGradients.Background
    gradient.Parent = frame
    task.spawn(function()
        while task.wait(0.03) do
            if not frame.Parent then break end
            gradient.Rotation = (gradient.Rotation + 1) % 360
            gradient.Color = getgenv().ButtonGradients.Background
        end
    end)

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Parent = frame
    local gradientstroke = Instance.new("UIGradient")
    gradientstroke.Color = getgenv().ButtonGradients.Stroke
    gradientstroke.Rotation = 0
    gradientstroke.Parent = stroke
    task.spawn(function()
        while frame.Parent do
            gradientstroke.Rotation = (gradientstroke.Rotation + 0.5) % 360
            gradientstroke.Color = getgenv().ButtonGradients.Stroke
            task.wait()
        end
    end)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = isToggle and (displayText .. " | Off") or displayText
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

    local function applyShape(circle)
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
            local entry = FloatButtonSizes[buttonName]
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

    FloatButtonManager:AddButton(buttonName, frame, isToggle, false, nil, button)
    FloatButtonSizes[buttonName] = { W = savedW, H = savedH, frame = frame, button = button, applyShape = applyShape }

    applyShape(false)

    task.spawn(function()
        while task.wait(0.25) do
            if not frame.Parent then break end
            if toggle.Visible and tick() - hideAt >= 10 then
                toggle.Visible = false
            end
        end
    end)

    button.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            holding = true
            holdStart = tick()
        end
    end)

    button.InputEnded:Connect(function(i)
        if holding and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
            holding = false
            if tick() - holdStart >= 0.6 then
                toggle.Visible = true
                hideAt = tick()
            end
        end
    end)

    toggle.MouseButton1Click:Connect(function()
        hideAt = tick()
        applyShape(not frame:GetAttribute("IsCircle"))
    end)

    local function MakeDraggable(topbar, object)
        local Dragging, DragInput, DragStart, StartPosition = false, nil, nil, nil
        local Holding, HoldTime, MoveCancelThreshold, HoldToken = false, 1.0, 6, 0
        object:SetAttribute("Locked", false)

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
        end

        topbar.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            Dragging = not object:GetAttribute("Locked")
            Holding = true
            DragStart = input.Position
            StartPosition = object.Position
            HoldToken = HoldToken + 1
            local token = HoldToken
            task.delay(HoldTime, function()
                if Holding and token == HoldToken then ToggleLock() end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                    Holding = false
                end
            end)
        end)

        topbar.InputChanged:Connect(function(input)
            if not DragStart then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                if (input.Position - DragStart).Magnitude > MoveCancelThreshold then
                    Holding = false
                end
                DragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == DragInput and Dragging then Update(input) end
        end)
    end

    MakeDraggable(button, frame)

    return frame, button
end

function SetFloatingButtonVisible(frame, state)
    if frame then frame.Visible = state end
end

function SetFloatingButtonText(button, text)
    if button then button.Text = text end
end

function SetFloatingButtonActive(button, state, name)
    if not button then return end
    button.Text = name .. " | " .. (state and "On" or "Off")
end

function AddFloatingButtonSizeInputs(section, buttonName, displayText)
    section:AddSpace({Height = 20})
    section:AddInput(buttonName .. "_Size", {
        Title = "Size",
        Placeholder = "200x70",
        Default = "200x70",
        Finished = true,
        Description = "Format: RealSizeXRealSize (e.g. 200x70)",
        Callback = function(v)
            local w, h = tostring(v):match("^(%d+)[xX](%d+)$")
            w = tonumber(w)
            h = tonumber(h)
            if w and h and w > 0 and h > 0 and FloatButtonSizes[buttonName] then
                local entry = FloatButtonSizes[buttonName]
                entry.W = w
                entry.H = h
                local f = entry.frame
                if f and not f:GetAttribute("IsCircle") then
                    f.Size = UDim2.new(0, w, 0, h)
                end
            end
        end
    })
end

function AddFloatingButtonKeybind(section, buttonName, keybindCallback)
    section:AddSpace({Height = 10})
    section:AddKeybind(buttonName .. "Keybind", {
        Title = buttonName .. " Keybind",
        Description = "Toggle " .. buttonName,
        Default = "",
        Callback = keybindCallback
    })
end

return {
    CreateFloatingButton = CreateFloatingButton,
    SetFloatingButtonVisible = SetFloatingButtonVisible,
    SetFloatingButtonText = SetFloatingButtonText,
    SetFloatingButtonActive = SetFloatingButtonActive,
    AddFloatingButtonSizeInputs = AddFloatingButtonSizeInputs,
    AddFloatingButtonKeybind = AddFloatingButtonKeybind,
    FloatButtonManager = FloatButtonManager,
    FloatButtonSizes = FloatButtonSizes
}
