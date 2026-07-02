Fluent:RegisterCustomTheme("Bloomings", {
    Accent = Color3.fromRGB(255, 80, 150),
    AcrylicMain = Color3.fromRGB(40, 15, 30),
    AcrylicBorder = Color3.fromRGB(200, 60, 120),
    AcrylicGradient = ColorSequence.new(Color3.fromRGB(60, 20, 45), Color3.fromRGB(25, 8, 18)),
    AcrylicNoise = 0.90,
    TitleBarLine = Color3.fromRGB(255, 100, 180),
    Tab = Color3.fromRGB(50, 18, 38),
    Element = Color3.fromRGB(55, 22, 42),
    ElementBorder = Color3.fromRGB(255, 70, 160),
    InElementBorder = Color3.fromRGB(200, 80, 150),
    ElementTransparency = 0.92,
    ToggleSlider = Color3.fromRGB(255, 210, 230),
    ToggleToggled = Color3.fromRGB(255, 50, 140),
    SliderRail = Color3.fromRGB(100, 40, 75),
    DropdownFrame = Color3.fromRGB(45, 18, 35),
    DropdownHolder = Color3.fromRGB(35, 12, 25),
    DropdownBorder = Color3.fromRGB(180, 60, 130),
    DropdownOption = Color3.fromRGB(55, 22, 42),
    Keybind = Color3.fromRGB(45, 18, 35),
    Input = Color3.fromRGB(45, 18, 35),
    InputFocused = Color3.fromRGB(60, 25, 48),
    InputIndicator = Color3.fromRGB(255, 80, 160),
    Dialog = Color3.fromRGB(40, 15, 30),
    DialogHolder = Color3.fromRGB(30, 10, 22),
    DialogHolderLine = Color3.fromRGB(200, 70, 150),
    DialogButton = Color3.fromRGB(55, 22, 42),
    DialogButtonBorder = Color3.fromRGB(200, 70, 160),
    DialogBorder = Color3.fromRGB(180, 60, 130),
    DialogInput = Color3.fromRGB(45, 18, 35),
    DialogInputLine = Color3.fromRGB(255, 80, 160),
    Text = Color3.fromRGB(255, 240, 248),
    SubText = Color3.fromRGB(230, 190, 215),
    Hover = Color3.fromRGB(255, 255, 255),
    HoverChange = 0.08,
    Background = "rbxassetid://133541508207801",
    BackgroundTransparency = 0.12,
    ViewportBackground = Color3.fromRGB(30, 10, 22),
    ViewportBackgroundImages = true,
    DropdownOutsideWindowBackground = Color3.fromRGB(35, 12, 25),
    DropdownOutsideWindowBackgroundImages = true,
    ShineEnabled = true,
    Shine = {
        Speed = 0.35,
        RotationSpeed = 15,
        ColorSequence = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 150)),
            ColorSequenceKeypoint.new(0.25, Color3.fromRGB(80, 255, 150)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 50, 130)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 70, 150))
        })
    },
    StrokeShine = true,
    StrokeDark = Color3.fromRGB(80, 30, 60),
    ButtonGradient = {
        Background = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 60, 130)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 25, 60))
        }),
        Stroke = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 180, 220)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 180)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 70, 150))
        })
    }
})