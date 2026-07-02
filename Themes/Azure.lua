-- Reference from Xenovia Quarta (DxD)
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
    Background = "rbxassetid://84872616459551",
    BackgroundTransparency = 0.12,
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