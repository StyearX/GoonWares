-- Reference from Rias Gremory 
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