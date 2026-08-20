local UIPositionManager = {}
UIPositionManager.__index = UIPositionManager

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local TargetParent = PlayerGui
pcall(function()
    if gethui and gethui() then TargetParent = gethui()
    elseif CoreGui then TargetParent = CoreGui end
end)

UIPositionManager.Folder = "FluentSettings"
UIPositionManager.Library = nil
UIPositionManager.Options = nil
UIPositionManager._Connections = {}
UIPositionManager._EnforcerBound = false
UIPositionManager._EditActive = false
UIPositionManager._SelUpdater = false

local RuleMap = {}
local KnownTrackedObjects = {}
local OriginalPositions = {}
local OriginalSizes = {}
local SelectedElement = nil
local SelectedCluster = {}
local isDraggingElement = false
local activeDragInput = nil
local dragStartInputPos = nil
local initialClusterPositions = {}
local _ListenerEnabled = false

local _TapShield = nil
local _ShieldGui = nil
local _SelectionFrame = nil
local _SelectionSG = nil
local _OverlayGui = nil
local _overlayFrame = nil
local _szSetter = nil
local _opSetter = nil
local _selLabel = nil

local function GetKey(obj)
    local keyStr = obj.Name
    local trait = ""
    if obj.Name == "ContextActionButton" then
        local t = obj:FindFirstChild("ActionTitle")
        if t and t:IsA("TextLabel") and t.Text ~= "" then
            keyStr = "CAB_" .. t.Text
        else
            local ic = obj:FindFirstChild("ActionIcon")
            if ic and ic:IsA("ImageLabel") and ic.Image ~= "" then
                local imgId = ic.Image:match("%d+")
                keyStr = "CAB_IMG_" .. (imgId or "ICO")
            end
        end
    else
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            if obj.Text ~= "" then trait = trait .. "_" .. obj.Text:sub(1, 10) end
        elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
            local id = obj.Image:match("%d+")
            if id then trait = trait .. "_IMG" .. id end
        end
    end
    local sibIdx = 1
    if obj.Parent then
        keyStr = obj.Parent.Name .. "_" .. keyStr
        for _, ch in ipairs(obj.Parent:GetChildren()) do
            if ch == obj then break end
            if ch.Name == obj.Name and ch.ClassName == obj.ClassName then
                sibIdx = sibIdx + 1
            end
        end
        if sibIdx > 1 then trait = trait .. "_IDX" .. sibIdx end
    end
    return keyStr .. trait
end

local function SafeVisualPos(gui)
    local p = gui.Parent
    if p and p:IsA("GuiObject") then
        local pX, pY = p.AbsolutePosition.X, p.AbsolutePosition.Y
        if p:IsA("ScrollingFrame") then
            pX = pX - p.CanvasPosition.X
            pY = pY - p.CanvasPosition.Y
        end
        local aX, aY = gui.AnchorPoint.X, gui.AnchorPoint.Y
        local w, h = gui.AbsoluteSize.X, gui.AbsoluteSize.Y
        local dX, dY = gui.AbsolutePosition.X, gui.AbsolutePosition.Y
        return UDim2.new(0, (dX - pX) + (aX * w), 0, (dY - pY) + (aY * h))
    end
    return gui.Position
end

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = (radius == "100%" or radius == 1) and UDim.new(1, 0) or UDim.new(0, radius or 10)
    c.Parent = parent
    return c
end

local function Stroke(parent, color, thick, transp)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(80, 80, 100)
    s.Thickness = thick or 1
    s.Transparency = transp or 0.6
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function Tween(inst, props, dur, style, dir)
    local ti = TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    TweenService:Create(inst, ti, props):Play()
end

local function MakeDraggable(frame)
    local dragging, di, ds, sp = false, nil, nil, nil
    frame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            di = inp
            ds = inp.Position
            sp = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if inp == di and dragging then
            local d = inp.Position - ds
            frame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp == di then dragging = false
        di = nil end
    end)
end

local function ReadTheme(lib)
    local C = {
        Accent = Color3.fromRGB(210, 50, 50),
        Bg = Color3.fromRGB(15, 15, 20),
        Surface = Color3.fromRGB(22, 22, 30),
        Element = Color3.fromRGB(30, 30, 42),
        Text = Color3.fromRGB(235, 235, 245),
        SubText = Color3.fromRGB(150, 150, 165),
        Border = Color3.fromRGB(55, 55, 75),
        ElemTrns = 0.82,
        Acrylic = true,
        Transp = true,
    }
    if lib and lib.GetThemeProperty then
        pcall(function()
            C.Accent = lib.GetThemeProperty("Accent") or C.Accent
            C.Bg = lib.GetThemeProperty("Background") or C.Bg
            C.Surface = lib.GetThemeProperty("Surface") or C.Surface
            C.Element = lib.GetThemeProperty("Element") or C.Element
            C.Text = lib.GetThemeProperty("Text") or C.Text
            C.SubText = lib.GetThemeProperty("SubText") or C.SubText
            C.Border = lib.GetThemeProperty("AcrylicBorder") or C.Border
            C.ElemTrns = lib.GetThemeProperty("ElementTransparency") or C.ElemTrns
        end)
        pcall(function()
            if lib.InterfaceManager then
                local s = lib.InterfaceManager.Settings
                C.Acrylic = s.Acrylic ~= false
                C.Transp = s.Transparency ~= false
            end
        end)
    end
    return C
end

local function BuildSliderRow(body, C, label, icon, minV, maxV, defaultV, layoutOrder, onChange)
    local row = Instance.new("Frame")
    row.Name = "SliderRow_" .. label
    row.Size = UDim2.new(1, 0, 0, 48)
    row.BackgroundColor3 = C.Element
    row.BackgroundTransparency = C.ElemTrns
    row.LayoutOrder = layoutOrder
    row.Parent = body
    Corner(row, 8)
    Stroke(row, C.Border, 1, 0.5)

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 20)
    top.Position = UDim2.new(0, 0, 0, 5)
    top.BackgroundTransparency = 1
    top.Parent = row

    local icoLbl = Instance.new("TextLabel")
    icoLbl.Size = UDim2.new(0, 22, 1, 0)
    icoLbl.Position = UDim2.new(0, 10, 0, 0)
    icoLbl.BackgroundTransparency = 1
    icoLbl.Text = icon
    icoLbl.TextColor3 = C.Accent
    icoLbl.Font = Enum.Font.GothamBold
    icoLbl.TextSize = 13
    icoLbl.Parent = top

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -70, 1, 0)
    titleLbl.Position = UDim2.new(0, 34, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = label
    titleLbl.TextColor3 = C.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = top

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 46, 1, 0)
    valLbl.Position = UDim2.new(1, -50, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(defaultV)
    valLbl.TextColor3 = C.Accent
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 11
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = top

    local trackWrap = Instance.new("Frame")
    trackWrap.Size = UDim2.new(1, -20, 0, 16)
    trackWrap.Position = UDim2.new(0, 10, 0, 27)
    trackWrap.BackgroundTransparency = 1
    trackWrap.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 4)
    track.Position = UDim2.new(0, 0, 0.5, -2)
    track.BackgroundColor3 = C.Surface
    track.BorderSizePixel = 0
    track.Parent = trackWrap
    Corner(track, 2)

    local initPct = math.clamp((defaultV - minV) / (maxV - minV), 0, 1)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(initPct, 0, 1, 0)
    fill.BackgroundColor3 = C.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    Corner(fill, 2)

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(initPct, -7, 0.5, -7)
    knob.BackgroundColor3 = C.Text
    knob.Text = ""
    knob.ZIndex = 5
    knob.Parent = track
    Corner(knob, "100%")
    Stroke(knob, C.Accent, 2, 0.2)

    local currentValue = defaultV
    local dragging = false

    local function SetValue(v)
        v = math.clamp(math.round(v), minV, maxV)
        currentValue = v
        local pct = (v - minV) / (maxV - minV)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -7, 0.5, -7)
        valLbl.Text = tostring(v)
        if onChange then onChange(v) end
    end

    local function HandleInput(inp)
        local pct = math.clamp((inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        SetValue(minV + pct * (maxV - minV))
    end

    knob.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            HandleInput(inp)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            HandleInput(inp)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return row, SetValue
end

local function BuildFluentOverlay(lib)
    if _OverlayGui then
        pcall(function() _OverlayGui:Destroy() end)
        _OverlayGui = nil
        _overlayFrame = nil
    end

    local C = ReadTheme(lib)
    local transparent = C.Transp

    local sg = Instance.new("ScreenGui")
    sg.Name = "UIPosManager_Overlay"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 99995
    sg.IgnoreGuiInset = true
    sg.Parent = TargetParent
    _OverlayGui = sg

    local panelW, panelH = 368, 196
    local panel = Instance.new("Frame")
    panel.Name = "UIPosPanel"
    panel.Size = UDim2.new(0, panelW, 0, panelH)
    panel.Position = UDim2.new(0.5, -panelW / 2, 0, 12)
    panel.BackgroundColor3 = C.Bg
    panel.BackgroundTransparency = 1
    panel.Active = true
    panel.ClipsDescendants = true
    panel.Parent = sg
    Corner(panel, 14)
    Stroke(panel, C.Border, 1.2, 0.35)
    MakeDraggable(panel)
    _overlayFrame = panel

    local sheen = Instance.new("UIGradient")
    sheen.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255):Lerp(C.Bg, 0.9)),
        ColorSequenceKeypoint.new(0.5, C.Bg),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0):Lerp(C.Bg, 0.85)),
    }
    sheen.Rotation = 135
    sheen.Parent = panel

    local animBorder = Stroke(panel, C.Accent, 1.5, 0.6)
    local _animT = 0
    local animConn = RunService.RenderStepped:Connect(function(dt)
        if not panel.Parent then return end
        _animT = (_animT + dt * 0.7) % (math.pi * 2)
        local pulse = (math.sin(_animT) + 1) / 2
        animBorder.Transparency = 0.4 + pulse * 0.45
        animBorder.Thickness = 1.2 + pulse * 0.8
        animBorder.Color = C.Accent:Lerp(C.Border, 0.3 + pulse * 0.4)
    end)

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = C.Accent
    titleBar.BackgroundTransparency = 0.22
    titleBar.BorderSizePixel = 0
    titleBar.Parent = panel
    Corner(titleBar, 14)

    local tbFill = Instance.new("Frame")
    tbFill.Size = UDim2.new(1, 0, 0, 14)
    tbFill.Position = UDim2.new(0, 0, 1, -14)
    tbFill.BackgroundColor3 = C.Accent
    tbFill.BackgroundTransparency = 0.22
    tbFill.BorderSizePixel = 0
    tbFill.Parent = titleBar

    local tbGradient = Instance.new("UIGradient")
    tbGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
    }
    tbGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(0.5, 0.55),
        NumberSequenceKeypoint.new(1, 0.85),
    }
    tbGradient.Rotation = 90
    tbGradient.Parent = titleBar

    local titleIco = Instance.new("TextLabel")
    titleIco.Size = UDim2.new(0, 28, 1, 0)
    titleIco.Position = UDim2.new(0, 12, 0, 0)
    titleIco.BackgroundTransparency = 1
    titleIco.Text = "✏"
    titleIco.TextColor3 = C.Text
    titleIco.Font = Enum.Font.GothamBold
    titleIco.TextSize = 15
    titleIco.Parent = titleBar

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -46, 1, 0)
    titleLbl.Position = UDim2.new(0, 38, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "UI Position Editor"
    titleLbl.TextColor3 = C.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = titleBar

    local dragHint = Instance.new("TextLabel")
    dragHint.Size = UDim2.new(0, 60, 1, 0)
    dragHint.Position = UDim2.new(1, -64, 0, 0)
    dragHint.BackgroundTransparency = 1
    dragHint.Text = "⣿ drag"
    dragHint.TextColor3 = C.Text
    dragHint.Font = Enum.Font.Gotham
    dragHint.TextSize = 10
    dragHint.TextTransparency = 0.5
    dragHint.TextXAlignment = Enum.TextXAlignment.Right
    dragHint.Parent = titleBar

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, -20, 0, panelH - 40 - 10)
    body.Position = UDim2.new(0, 10, 0, 46)
    body.BackgroundTransparency = 1
    body.Parent = panel

    local bodyLayout = Instance.new("UIListLayout")
    bodyLayout.Padding = UDim.new(0, 6)
    bodyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    bodyLayout.Parent = body

    local selRow = Instance.new("Frame")
    selRow.Name = "SelectionRow"
    selRow.Size = UDim2.new(1, 0, 0, 24)
    selRow.BackgroundColor3 = C.Element
    selRow.BackgroundTransparency = C.ElemTrns
    selRow.LayoutOrder = 1
    selRow.Parent = body
    Corner(selRow, 6)
    Stroke(selRow, C.Border, 1, 0.5)

    local selIco = Instance.new("TextLabel")
    selIco.Size = UDim2.new(0, 26, 1, 0)
    selIco.Position = UDim2.new(0, 6, 0, 0)
    selIco.BackgroundTransparency = 1
    selIco.Text = "⊙"
    selIco.TextColor3 = C.Accent
    selIco.Font = Enum.Font.GothamBold
    selIco.TextSize = 13
    selIco.Parent = selRow

    local selLbl = Instance.new("TextLabel")
    selLbl.Name = "SelectionLabel"
    selLbl.Size = UDim2.new(1, -32, 1, 0)
    selLbl.Position = UDim2.new(0, 28, 0, 0)
    selLbl.BackgroundTransparency = 1
    selLbl.Text = "No element selected — tap any UI element"
    selLbl.TextColor3 = C.SubText
    selLbl.Font = Enum.Font.Gotham
    selLbl.TextSize = 11
    selLbl.TextXAlignment = Enum.TextXAlignment.Left
    selLbl.TextTruncate = Enum.TextTruncate.AtEnd
    selLbl.Parent = selRow
    _selLabel = selLbl

    local _, szSet = BuildSliderRow(body, C, "Size Adjust (px)", "⊞", -150, 150, 0, 2, function(v)
        if not (SelectedElement and #SelectedCluster > 0) then return end
        for _, el in ipairs(SelectedCluster) do
            local key = GetKey(el)
            if RuleMap[key] then
                local base = OriginalSizes[key] or el.Size
                local newSize = UDim2.new(base.X.Scale, base.X.Offset + v, base.Y.Scale, base.Y.Offset + v)
                RuleMap[key].Size = newSize
                RuleMap[key].SizeModified = true
                el.Size = newSize
            end
        end
    end)
    _szSetter = szSet

    local _, opSet = BuildSliderRow(body, C, "BG Opacity (Transparency %)", "◑", 0, 100, 0, 3, function(v)
        if not (SelectedElement and #SelectedCluster > 0) then return end
        for _, el in ipairs(SelectedCluster) do
            local key = GetKey(el)
            if RuleMap[key] then
                RuleMap[key].Opacity = v / 100
                pcall(function() el.BackgroundTransparency = v / 100 end)
            end
        end
    end)
    _opSetter = opSet

    local btnRow = Instance.new("Frame")
    btnRow.Size = UDim2.new(1, 0, 0, 32)
    btnRow.BackgroundTransparency = 1
    btnRow.LayoutOrder = 4
    btnRow.Parent = body

    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    btnLayout.Padding = UDim.new(0, 8)
    btnLayout.Parent = btnRow

    local function MakeOverlayBtn(text, bgColor, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 160, 1, 0)
        btn.BackgroundColor3 = bgColor
        btn.BackgroundTransparency = 0.18
        btn.Text = text
        btn.TextColor3 = C.Text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.Parent = btnRow
        Corner(btn, 8)
        Stroke(btn, bgColor, 1, 0.45)

        btn.MouseEnter:Connect(function()
            Tween(btn, { BackgroundTransparency = 0 }, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, { BackgroundTransparency = 0.18 }, 0.15)
        end)
        btn.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
        return btn
    end

    MakeOverlayBtn("✓  Save & Exit", C.Accent, function()
        UIPositionManager:_ExitEditMode(true)
    end)
    MakeOverlayBtn("✗  Exit Without Save", Color3.fromRGB(65, 65, 85), function()
        UIPositionManager:_ExitEditMode(false)
    end)

    panel.Visible = true
    Tween(panel, { BackgroundTransparency = transparent and 0.18 or 0.04 }, 0.3)

    table.insert(UIPositionManager._Connections, animConn)
end

local function EnsureTapShield()
    if _TapShield and _TapShield.Parent then return end
    local sg = Instance.new("ScreenGui")
    sg.Name = "UIPosManager_Shield"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 99993
    sg.IgnoreGuiInset = true
    sg.Parent = TargetParent
    _ShieldGui = sg

    local shield = Instance.new("TextButton")
    shield.Size = UDim2.new(1, 0, 1, 0)
    shield.BackgroundTransparency = 1
    shield.Text = ""
    shield.Active = false
    shield.Visible = false
    shield.Parent = sg
    _TapShield = shield
end

local function EnsureSelectionFrame()
    if _SelectionFrame and _SelectionFrame.Parent then return end
    local sg = Instance.new("ScreenGui")
    sg.Name = "UIPosManager_Selection"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 99994
    sg.IgnoreGuiInset = true
    sg.Parent = TargetParent
    _SelectionSG = sg

    local frame = Instance.new("Frame")
    frame.Name = "SelectionHighlight"
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.ZIndex = 999999
    frame.Active = false
    pcall(function() frame.Interactable = false end)
    frame.Parent = sg

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 220, 255)
    stroke.Thickness = 2.2
    stroke.Transparency = 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame

    local function CornerMark(anchorX, anchorY, posX, posY)
        local m = Instance.new("Frame")
        m.Size = UDim2.new(0, 8, 0, 8)
        m.Position = UDim2.new(posX, posX == 0 and 0 or -8, posY, posY == 0 and 0 or -8)
        m.AnchorPoint = Vector2.new(anchorX, anchorY)
        m.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
        m.BorderSizePixel = 0
        m.ZIndex = 999999
        m.Parent = frame
    end
    CornerMark(0, 0, 0, 0)
    CornerMark(1, 0, 1, 0)
    CornerMark(0, 1, 0, 1)
    CornerMark(1, 1, 1, 1)

    _SelectionFrame = frame
end

local function IsJoystick(gui)
    local curr = gui
    while curr and curr:IsA("GuiObject") do
        local n = curr.Name:lower()
        if n:find("thumbstick") or n:find("joystick") then return true end
        curr = curr.Parent
    end
    return false
end

local function IsProtected(obj, lib)
    if not obj then return false end
    if _OverlayGui and obj:IsDescendantOf(_OverlayGui) then return true end
    if _ShieldGui and obj:IsDescendantOf(_ShieldGui) then return true end
    if _SelectionSG and obj:IsDescendantOf(_SelectionSG) then return true end
    if lib then
        if lib.GUI and obj:IsDescendantOf(lib.GUI) then return true end
        if lib.ScrollGUI and obj:IsDescendantOf(lib.ScrollGUI) then return true end
        if lib.PopupGUI and obj:IsDescendantOf(lib.PopupGUI) then return true end
    end
    return false
end

local function GetPerfectTarget(elementsAtTap, viewport, lib)
    local maxW = viewport.X * 0.8
    local maxH = viewport.Y * 0.8
    local topEl = nil

    for _, gui in ipairs(elementsAtTap) do
        if IsProtected(gui, lib) then continue end
        if gui.AbsoluteSize.X >= maxW then continue end
        if gui.AbsoluteSize.Y >= maxH then continue end
        if IsJoystick(gui) then continue end
        if gui:IsA("GuiButton") or gui:FindFirstChildWhichIsA("TouchTransmitter") then
            topEl = gui
            break
        end
    end

    if not topEl then
        for _, gui in ipairs(elementsAtTap) do
            if IsProtected(gui, lib) then continue end
            if gui.AbsoluteSize.X >= maxW then continue end
            if gui.AbsoluteSize.Y >= maxH then continue end
            if IsJoystick(gui) then continue end
            if gui.Visible and (gui.BackgroundTransparency < 1 or gui:IsA("ImageLabel") or gui:IsA("TextLabel") or gui:IsA("Frame")) then
                topEl = gui
                break
            end
        end
    end
    if not topEl then return nil end

    local curr = topEl.Parent
    local highestValid = topEl
    while curr and curr:IsA("GuiObject") do
        if IsProtected(curr, lib) then break end
        if curr.AbsoluteSize.X >= maxW or curr.AbsoluteSize.Y >= maxH then break end
        if IsJoystick(curr) then break end
        local hasOther = false
        for _, ch in ipairs(curr:GetChildren()) do
            if ch ~= highestValid and ch:IsA("GuiObject") and ch.Visible then
                if ch:IsA("GuiButton") or ch:FindFirstChildWhichIsA("TouchTransmitter") or ch:FindFirstChildWhichIsA("GuiButton", true) or ch:FindFirstChildWhichIsA("TouchTransmitter", true) then
                    hasOther = true
                    break
                end
            end
        end
        if hasOther then break end
        local n = curr.Name:lower()
        local isBtn = curr:IsA("GuiButton") or curr:FindFirstChildWhichIsA("TouchTransmitter")
        local nameBtn = n:find("button") or n:find("btn") or n:find("shutter") or n:find("action")
        if isBtn or nameBtn then
            highestValid = curr
        elseif curr.AbsoluteSize.X <= highestValid.AbsoluteSize.X + 30 and curr.AbsoluteSize.Y <= highestValid.AbsoluteSize.Y + 30 then
            highestValid = curr
        else
            break
        end
        curr = curr.Parent
    end
    return highestValid
end

local function GetCluster(target)
    local cluster = { target }
    local added = { [target] = true }

    if target.Parent then
        for _, ch in ipairs(target.Parent:GetChildren()) do
            if ch:IsA("GuiObject") and not added[ch] then
                local cx1 = ch.AbsolutePosition.X + ch.AbsoluteSize.X / 2
                local cy1 = ch.AbsolutePosition.Y + ch.AbsoluteSize.Y / 2
                local cx2 = target.AbsolutePosition.X + target.AbsoluteSize.X / 2
                local cy2 = target.AbsolutePosition.Y + target.AbsoluteSize.Y / 2
                local dist = math.sqrt((cx1 - cx2) ^ 2 + (cy1 - cy2) ^ 2)
                if dist <= 10 and ch.AbsoluteSize.X < 350 and ch.AbsoluteSize.Y < 350 then
                    table.insert(cluster, ch)
                    added[ch] = true
                end
            end
        end
    end

    local p = target.Parent
    if p and p:IsA("GuiObject") and not added[p] then
        local px = p.AbsolutePosition.X + p.AbsoluteSize.X / 2
        local py = p.AbsolutePosition.Y + p.AbsoluteSize.Y / 2
        local tx = target.AbsolutePosition.X + target.AbsoluteSize.X / 2
        local ty = target.AbsolutePosition.Y + target.AbsoluteSize.Y / 2
        local dist = math.sqrt((px - tx) ^ 2 + (py - ty) ^ 2)
        if dist <= 10 and p.AbsoluteSize.X <= target.AbsoluteSize.X * 1.5 and p.AbsoluteSize.Y <= target.AbsoluteSize.Y * 1.5 then
            table.insert(cluster, p)
            added[p] = true
        end
    end

    local pure = {}
    for _, el in ipairs(cluster) do
        local isChild = false
        for _, ot in ipairs(cluster) do
            if el ~= ot and el:IsDescendantOf(ot) then isChild = true
            break end
        end
        if not isChild then table.insert(pure, el) end
    end
    return pure
end

function UIPositionManager:_ScanSingleObject(obj)
    if not obj:IsA("GuiObject") then return end
    if IsProtected(obj, self.Library) then return end
    local key = GetKey(obj)
    if RuleMap[key] then KnownTrackedObjects[obj] = key end
end

function UIPositionManager:_ForceScanUI()
    pcall(function()
        for _, obj in ipairs(PlayerGui:GetDescendants()) do
            self:_ScanSingleObject(obj)
        end
    end)
end

function UIPositionManager:_StartEnforcer()
    if self._EnforcerBound then return end
    self._EnforcerBound = true

    RunService:BindToRenderStep("UIPosManager_Enforce", 2000, function()
        if not next(RuleMap) then return end
        for obj, key in pairs(KnownTrackedObjects) do
            if not obj.Parent then
                KnownTrackedObjects[obj] = nil
                continue
            end
            local rule = RuleMap[key]
            if not rule then
                KnownTrackedObjects[obj] = nil
                continue
            end
            if rule.IsDeleted then
                if obj.Visible then obj.Visible = false end
            else
                local beingDragged = false
                if isDraggingElement then
                    for _, el in ipairs(SelectedCluster) do
                        if el == obj then beingDragged = true
                        break end
                    end
                end
                if not beingDragged then
                    if obj.Position ~= rule.Position then obj.Position = rule.Position end
                    if rule.SizeModified and obj.Size ~= rule.Size then obj.Size = rule.Size end
                    if rule.Opacity ~= nil then
                        pcall(function() obj.BackgroundTransparency = rule.Opacity end)
                    end
                end
            end
        end
    end)

    local scanConn = PlayerGui.DescendantAdded:Connect(function(obj)
        if not next(RuleMap) then return end
        task.defer(function() self:_ScanSingleObject(obj) end)
    end)
    table.insert(self._Connections, scanConn)
end

function UIPositionManager:_StopEnforcer()
    if self._EnforcerBound then
        pcall(function() RunService:UnbindFromRenderStep("UIPosManager_Enforce") end)
        self._EnforcerBound = false
    end
end

function UIPositionManager:_StartEditMode()
    if self._EditActive then return end
    self._EditActive = true

    if self.Library and self.Library.Window then
        pcall(function() self.Library.Window:Hide() end)
    end

    EnsureTapShield()
    EnsureSelectionFrame()
    BuildFluentOverlay(self.Library)

    if _TapShield then
        _TapShield.Visible = true
        _TapShield.Active = true
    end

    self:_StartEnforcer()

    if not self._SelUpdater then
        self._SelUpdater = true
        RunService:BindToRenderStep("UIPosManager_SelUpdate", 1999, function()
            if not self._EditActive or not _SelectionFrame then return end
            if SelectedElement and SelectedElement.Parent and SelectedElement.Visible then
                _SelectionFrame.Visible = true
                _SelectionFrame.Size = UDim2.new(0, SelectedElement.AbsoluteSize.X, 0, SelectedElement.AbsoluteSize.Y)
                _SelectionFrame.Position = UDim2.new(0, SelectedElement.AbsolutePosition.X, 0, SelectedElement.AbsolutePosition.Y)
            else
                _SelectionFrame.Visible = false
            end
        end)
    end

    if _ListenerEnabled then return end
    _ListenerEnabled = true

    local lib = self.Library

    local ib = UserInputService.InputBegan:Connect(function(input)
        if not self._EditActive then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end

        if _overlayFrame and _overlayFrame.Visible then
            local p = _overlayFrame.AbsolutePosition
            local s = _overlayFrame.AbsoluteSize
            local ip = input.Position
            if ip.X >= p.X and ip.X <= p.X + s.X and ip.Y >= p.Y and ip.Y <= p.Y + s.Y then return end
        end

        isDraggingElement = false
        activeDragInput = nil

        if _TapShield then _TapShield.Visible = false end
        if _SelectionFrame then _SelectionFrame.Visible = false end

        local ok, els = pcall(function()
            return PlayerGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
        end)
        local target = nil
        if ok and els then
            local vp = workspace.CurrentCamera.ViewportSize
            target = GetPerfectTarget(els, vp, lib)
        end

        if _TapShield then _TapShield.Visible = true end

        if target then
            SelectedElement = target
            SelectedCluster = GetCluster(target)
            isDraggingElement = true
            activeDragInput = input
            dragStartInputPos = input.Position
            initialClusterPositions = {}

            if _selLabel then
                local C = ReadTheme(lib)
                _selLabel.Text = "Selected: " .. target.Name .. " (" .. target.ClassName .. ")"
                _selLabel.TextColor3 = C.Text
            end

            for _, el in ipairs(SelectedCluster) do
                local key = GetKey(el)
                local vp = SafeVisualPos(el)
                local vs = el.Size
                if vs == UDim2.new(0, 0, 0, 0) then
                    vs = UDim2.new(0, el.AbsoluteSize.X, 0, el.AbsoluteSize.Y)
                end
                if not OriginalPositions[key] then
                    OriginalPositions[key] = vp
                    OriginalSizes[key] = vs
                end
                if not RuleMap[key] then
                    RuleMap[key] = {
                        Name = el.Name,
                        IsDeleted = false,
                        Position = vp,
                        Size = vs,
                        SizeModified = false,
                    }
                end
                initialClusterPositions[el] = RuleMap[key].Position
                KnownTrackedObjects[el] = key
                el.Position = RuleMap[key].Position
            end

            if _szSetter then _szSetter(0) end
            if _opSetter then
                local key = GetKey(target)
                local op = RuleMap[key] and RuleMap[key].Opacity
                _opSetter(op and math.round(op * 100) or 0)
            end
        else
            SelectedElement = nil
            SelectedCluster = {}
            if _selLabel then
                local C = ReadTheme(lib)
                _selLabel.Text = "No element selected — tap any UI element"
                _selLabel.TextColor3 = C.SubText
            end
        end
    end)
    table.insert(self._Connections, ib)

    local ic = UserInputService.InputChanged:Connect(function(input)
        if not self._EditActive then return end
        if not isDraggingElement then return end
        if not SelectedElement then return end
        if input ~= activeDragInput then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end

        pcall(function()
            local delta = input.Position - dragStartInputPos
            for _, el in ipairs(SelectedCluster) do
                local key = GetKey(el)
                local start = initialClusterPositions[el]
                if not start then continue end
                local newP = UDim2.new(start.X.Scale, start.X.Offset + delta.X, start.Y.Scale, start.Y.Offset + delta.Y)
                RuleMap[key].Position = newP
                el.Position = newP
            end
        end)
    end)
    table.insert(self._Connections, ic)

    local ie = UserInputService.InputEnded:Connect(function(input)
        if input == activeDragInput then
            isDraggingElement = false
            activeDragInput = nil
        end
    end)
    table.insert(self._Connections, ie)
end

function UIPositionManager:_ExitEditMode(saveChanges)
    if not self._EditActive then return end
    self._EditActive = false
    isDraggingElement = false
    activeDragInput = nil
    SelectedElement = nil
    SelectedCluster = {}
    _ListenerEnabled = false

    local lib = self.Library

    for _, conn in ipairs(self._Connections) do
        if conn and conn.Connected then pcall(function() conn:Disconnect() end) end
    end
    self._Connections = {}

    if saveChanges then
        local name = "LastSession"
        if lib and lib.Options then
            local nameOpt = lib.Options["UIPosManager_PresetName"]
            if nameOpt and nameOpt.Value and nameOpt.Value:gsub(" ", "") ~= "" then
                name = nameOpt.Value
            end
        end
        local ok, err = self:Save(name)
        if lib and lib.Notify then
            if ok then
                lib:Notify({ Title = "UI Position Manager", Content = "Saved as: " .. name, Duration = 4 })
            else
                lib:Notify({ Title = "UI Position Manager", Content = "Save failed: " .. (err or "?"), Duration = 5 })
            end
        end
        if lib and lib.Options and lib.Options["UIPosManager_PresetList"] then
            lib.Options["UIPosManager_PresetList"]:SetValues(self:RefreshPresetList())
        end
    else
        for obj, key in pairs(KnownTrackedObjects) do
            if obj and obj.Parent then
                if OriginalPositions[key] then obj.Position = OriginalPositions[key] end
                if OriginalSizes[key] then obj.Size = OriginalSizes[key] end
                pcall(function() obj.BackgroundTransparency = 0 end)
            end
        end
        RuleMap = {}
        KnownTrackedObjects = {}
    end

    pcall(function() RunService:UnbindFromRenderStep("UIPosManager_SelUpdate") end)
    self._SelUpdater = false
    if _SelectionFrame then _SelectionFrame.Visible = false end

    if _TapShield then _TapShield.Visible = false
    _TapShield.Active = false end

    if _overlayFrame then
        Tween(_overlayFrame, { BackgroundTransparency = 1 }, 0.25)
        task.delay(0.3, function()
            if _OverlayGui then
                pcall(function() _OverlayGui:Destroy() end)
                _OverlayGui = nil
                _overlayFrame = nil
            end
        end)
    end

    if lib and lib.Window then
        task.delay(0.1, function()
            pcall(function() lib.Window:Show() end)
        end)
    end
end

function UIPositionManager:SetLibrary(lib)
    self.Library = lib
    self.Options = lib.Options
end

function UIPositionManager:SetFolder(folder)
    self.Folder = folder
    self:BuildFolderTree()
end

function UIPositionManager:BuildFolderTree()
    local paths = {
        self.Folder,
        self.Folder .. "/UIPositions",
    }
    for _, p in ipairs(paths) do
        if not (isfolder and isfolder(p)) then
            pcall(function() if makefolder then makefolder(p) end end)
        end
    end
end

function UIPositionManager:SetIgnoreIndexes(_list)
end

function UIPositionManager:Save(name)
    if not name or name:gsub(" ", "") == "" then return false, "no name provided" end
    if not writefile then return false, "no writefile" end
    local data = {}
    for key, rule in pairs(RuleMap) do
        data[key] = {
            Name = rule.Name,
            IsDeleted = rule.IsDeleted,
            Position = { rule.Position.X.Scale, rule.Position.X.Offset, rule.Position.Y.Scale, rule.Position.Y.Offset },
            Size = { rule.Size.X.Scale, rule.Size.X.Offset, rule.Size.Y.Scale, rule.Size.Y.Offset },
            SizeModified = rule.SizeModified or false,
            Opacity = rule.Opacity,
        }
    end
    local ok, enc = pcall(HttpService.JSONEncode, HttpService, data)
    if not ok then return false, "encode failed" end
    local path = self.Folder .. "/UIPositions/" .. name .. ".json"
    pcall(function() writefile(path, enc) end)
    return true
end

function UIPositionManager:Load(name)
    if not name or name == "" then return false, "no preset selected" end
    if not (isfile and readfile) then return false, "no isfile/readfile" end
    local path = self.Folder .. "/UIPositions/" .. name .. ".json"
    if not isfile(path) then return false, "file not found" end
    local ok, dec = pcall(HttpService.JSONDecode, HttpService, readfile(path))
    if not ok then return false, "decode error" end
    RuleMap = {}
    KnownTrackedObjects = {}
    for key, s in pairs(dec) do
        RuleMap[key] = {
            Name = s.Name,
            IsDeleted = s.IsDeleted,
            Position = UDim2.new(unpack(s.Position)),
            Size = UDim2.new(unpack(s.Size)),
            SizeModified = s.SizeModified or false,
            Opacity = s.Opacity,
        }
    end
    self:_ForceScanUI()
    if not self._EnforcerBound then self:_StartEnforcer() end
    return true
end

function UIPositionManager:Delete(name)
    if not name or name == "" then return false, "no preset selected" end
    if not (isfile and delfile) then return false, "no isfile/delfile" end
    local path = self.Folder .. "/UIPositions/" .. name .. ".json"
    if not isfile(path) then return false, "file not found" end
    pcall(function() delfile(path) end)
    return true
end

function UIPositionManager:RefreshPresetList()
    if not (listfiles and isfolder) then return {} end
    local path = self.Folder .. "/UIPositions"
    if not isfolder(path) then return {} end
    local ok, files = pcall(listfiles, path)
    if not ok then return {} end
    local out = {}
    for _, file in ipairs(files) do
        if file:sub(-5) == ".json" then
            local nm = file:match("([^/\\]+)%.json$")
            if nm then table.insert(out, nm) end
        end
    end
    return out
end

function UIPositionManager:LoadAutoloadConfig()
    local autoPath = self.Folder .. "/UIPositions/autoload.txt"
    if not (isfile and isfile(autoPath)) then return end
    local name = readfile(autoPath)
    local ok, err = self:Load(name)
    if self.Library and self.Library.Notify then
        if ok then
            self.Library:Notify({ Title = "UI Position Manager", Content = "Auto-applied: " .. name, Duration = 5 })
        else
            self.Library:Notify({ Title = "UI Position Manager", Content = "Auto-load failed: " .. (err or "?"), Duration = 6 })
        end
    end
end

function UIPositionManager:BuildUIPositionSection(tab)
    assert(self.Library, "[UIPositionManager] Must call SetLibrary() before BuildUIPositionSection()")
    self:BuildFolderTree()

    local lib = self.Library
    local section = tab:AddSection("UI Position Manager", "solar/window-frame-bold")

    section:AddParagraph({
        Title = "How to use",
        Content = "① Enter a preset name  ② Click Start Modify  ③ Drag any UI element  ④ Use size/opacity sliders  ⑤ Click Save & Exit"
    })

    section:AddInput("UIPosManager_PresetName", {
        Title = "Preset Name",
        Description = "Name for saving the current UI layout",
        Icon = "solar/pen-new-round-bold",
        Placeholder = "e.g. MyHUD",
    })

    section:AddDropdown("UIPosManager_PresetList", {
        Title = "Saved Presets",
        Description = "Select a saved preset",
        Icon = "solar/list-bold",
        Values = self:RefreshPresetList(),
        AllowNull = true,
        NoSearch = true,
        DropdownOutsideWindow = true,
        IsManagerDropdown = true,
    })

    section:AddButton({
        Title = "Start Modify UI",
        Description = "Closes this menu and enters position-edit mode",
        Icon = "solar/cursor-bold",
        Callback = function()
            self:_StartEditMode()
        end,
    })

    section:AddButton({
        Title = "Apply Preset",
        Description = "Loads the selected preset and enforces its positions",
        Icon = "solar/upload-minimalistic-bold",
        Callback = function()
            local sel = lib.Options["UIPosManager_PresetList"]
            local name = sel and sel.Value
            if not name then
                return lib:Notify({ Title = "UI Position Manager", Content = "No preset selected", Duration = 4 })
            end
            local ok, err = self:Load(name)
            if ok then
                lib:Notify({ Title = "UI Position Manager", Content = "Applied: " .. name, Duration = 4 })
            else
                lib:Notify({ Title = "UI Position Manager", Content = "Failed: " .. (err or "?"), Duration = 5 })
            end
        end,
    })

    section:AddButton({
        Title = "Overwrite Preset",
        Description = "Overwrites selected preset with the current UI layout",
        Icon = "solar/refresh-bold",
        Callback = function()
            local sel = lib.Options["UIPosManager_PresetList"]
            local name = sel and sel.Value
            if not name then
                return lib:Notify({ Title = "UI Position Manager", Content = "No preset selected", Duration = 4 })
            end
            local win = lib.Window
            local function doOverwrite()
                local ok, err = self:Save(name)
                if ok then
                    lib:Notify({ Title = "UI Position Manager", Content = "Overwritten: " .. name, Duration = 4 })
                else
                    lib:Notify({ Title = "UI Position Manager", Content = "Failed: " .. (err or "?"), Duration = 5 })
                end
            end
            if win then
                win:Dialog({
                    Title = "Overwrite Preset?",
                    Content = ("Overwrite %q with the current UI layout?"):format(name),
                    Buttons = {
                        { Title = "Overwrite", Callback = doOverwrite },
                        { Title = "Cancel" },
                    },
                })
            else
                doOverwrite()
            end
        end,
    })

    section:AddButton({
        Title = "Delete Preset",
        Description = "Permanently deletes the selected preset file",
        Icon = "solar/trash-bin-trash-bold",
        Callback = function()
            local sel = lib.Options["UIPosManager_PresetList"]
            local name = sel and sel.Value
            if not name then
                return lib:Notify({ Title = "UI Position Manager", Content = "No preset selected", Duration = 4 })
            end
            local win = lib.Window
            local function doDelete()
                local ok, err = self:Delete(name)
                if ok then
                    lib:Notify({ Title = "UI Position Manager", Content = "Deleted: " .. name, Duration = 4 })
                    lib.Options["UIPosManager_PresetList"]:SetValues(self:RefreshPresetList())
                    lib.Options["UIPosManager_PresetList"]:SetValue(nil)
                else
                    lib:Notify({ Title = "UI Position Manager", Content = "Failed: " .. (err or "?"), Duration = 5 })
                end
            end
            if win then
                win:Dialog({
                    Title = "Delete Preset?",
                    Content = ("Permanently delete %q?"):format(name),
                    Buttons = {
                        { Title = "Delete", Callback = doDelete },
                        { Title = "Cancel" },
                    },
                })
            else
                doDelete()
            end
        end,
    })

    section:AddButton({
        Title = "Refresh List",
        Icon = "solar/restart-bold",
        Callback = function()
            lib.Options["UIPosManager_PresetList"]:SetValues(self:RefreshPresetList())
            lib.Options["UIPosManager_PresetList"]:SetValue(nil)
        end,
    })

    section:AddButton({
        Title = "Reset All Positions",
        Description = "Restores all UI elements to their original positions",
        Icon = "solar/close-circle-bold",
        Callback = function()
            local win = lib.Window
            local function doReset()
                for obj, key in pairs(KnownTrackedObjects) do
                    if obj and obj.Parent then
                        if OriginalPositions[key] then obj.Position = OriginalPositions[key] end
                        if OriginalSizes[key] then obj.Size = OriginalSizes[key] end
                        pcall(function() obj.BackgroundTransparency = 0 end)
                        obj.Visible = true
                    end
                end
                RuleMap = {}
                KnownTrackedObjects = {}
                self:_StopEnforcer()
                lib:Notify({ Title = "UI Position Manager", Content = "All positions reset to default", Duration = 4 })
            end
            if win then
                win:Dialog({
                    Title = "Reset Positions?",
                    Content = "Restore all UI elements to their original positions? This cannot be undone.",
                    Buttons = {
                        { Title = "Reset", Callback = doReset },
                        { Title = "Cancel" },
                    },
                })
            else
                doReset()
            end
        end,
    })

    self:SetIgnoreIndexes({ "UIPosManager_PresetList", "UIPosManager_PresetName" })
end

UIPositionManager:BuildFolderTree()

if getgenv then
    pcall(function() getgenv().UIPositionManager = UIPositionManager end)
end

return UIPositionManager