local FreecamModule = {}

function FreecamModule.Init(Fluent, FloatingButtonManager)

local pi = math.pi
local abs = math.abs
local clamp = math.clamp
local exp = math.exp
local rad = math.rad
local sign = math.sign
local sqrt = math.sqrt
local tan = math.tan
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Settings = UserSettings()
local GameSettings = Settings.GameSettings
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end
local FreecamCamera = Workspace.CurrentCamera
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	local newCamera = Workspace.CurrentCamera
	if newCamera then
		FreecamCamera = newCamera
	end
end)
local freecamGui = Instance.new("ScreenGui")
freecamGui.Name = "GoonWaresFreecam"
freecamGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
freecamGui.ResetOnSpawn = false
freecamGui.Parent = game:GetService("CoreGui")
freecamGui.Enabled = true
local touchGui = nil
local uiMainFrame = nil
local FFlagUserExitFreecamBreaksWithShiftlock = false
local FFlagUserShowGuiHideToggles = false
local FFlagUserFixFreecamDeltaTimeCalculation = false
local FFlagUserFixFreecamGuiChangeVisibility = false
local FFlagUserFreecamControlSpeed = true
local FFlagUserFreecamTiltControl = true
local FFlagUserFreecamSmoothnessControl = true
local FFlagUserFreecamGuiDestabilization = false
local FFlagUserFreecamDepthOfFieldEffect = true
local FFlagUserFreecamCustomGui = true
local FreecamEnabledAttributeName = "FreecamEnabled"
local ToggleInputPriority = Enum.ContextActionPriority.Low.Value
local InputPriority = Enum.ContextActionPriority.High.Value
local NavGain = Vector3.new(1, 1, 1)*64
local PanGain = Vector2.new(0.75, 1)*8
local FovGain = 300
local RollGain = -pi/2
local PitchLimit = rad(90)
local VelStiffness = 1.5
local PanStiffness = 1.0
local FovStiffness = 4.0
local RollStiffness = 1.0
local VelAdjStiffness = 0.75
local PanAdjStiffness = 0.75
local FovAdjStiffness = 0.75
local RollAdjStiffness = 0.75
local VelMinStiffness = 0.01
local PanMinStiffness = 0.01
local FovMinStiffness = 0.01
local RollMinStiffness = 0.01
local VelMaxStiffness = 10.0
local PanMaxStiffness = 10.0
local FovMaxStiffness = 10.0
local RollMaxStiffness = 10.0
local lastPressTime = {}
local lastResetTime = 0
local DoubleTapTimeThreshold = 0.25
local DoubleTapDebounceTime = 0.1
local PostEffects = {}
local PlayerGuiConnection = nil
local CameraConnection = nil
local LightingConnection = nil
local ScreenGuisEnabled = false
local LeaderboardEnabled = false
local MobileMoveVector = Vector3.new(0, 0, 0)
local MobileLookVector = Vector2.new(0, 0)
local MobileFovDelta = 0
local MobileNavSpeed = 1
local FlyUpActive = false
local FlyDownActive = false
local TiltLeftActive = false
local TiltRightActive = false
local CustomTiltLeftKeys = {"Z"}
local CustomTiltRightKeys = {"C"}
local MouseSensitivity = 1
local TouchLookSensitivity = 1
local FovSensitivity = 1
local Spring = {}
Spring.__index = Spring
function Spring.new(freq, pos)
	local self = setmetatable({}, Spring)
	self.f = freq
	self.p = pos
	self.v = pos*0
	return self
end
function Spring:Update(dt, goal)
	local f = self.f*2*pi
	local p0 = self.p
	local v0 = self.v
	local offset = goal - p0
	local decay = exp(-f*dt)
	local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
	local v1 = (f*dt*(offset*f - v0) + v0)*decay
	self.p = p1
	self.v = v1
	return p1
end
function Spring:SetFreq(freq)
	self.f = freq
end
function Spring:Reset(pos)
	self.p = pos
	self.v = pos*0
end
local CameraPos = Vector3.new()
local CameraRot = Vector3.new()
local CameraFov = 0
local VelSpring = Spring.new(VelStiffness, Vector3.new())
local PanSpring = Spring.new(PanStiffness, Vector2.new())
local FovSpring = Spring.new(FovStiffness, 0)
local RollSpring = Spring.new(RollStiffness, 0)
local TiltLeftActiveKB = false
local TiltRightActiveKB = false
function CreateFlyButtons(parent)
	local padding = 9
	local buttonFrame = Instance.new("Frame")
	buttonFrame.Name = "FreeCamFlybtn"
	buttonFrame.BackgroundTransparency = 1
	buttonFrame.Parent = parent
	buttonFrame.ZIndex = 15
	local flyDownBtn = Instance.new("ImageButton")
	flyDownBtn.Name = "FlyDownBtn"
	flyDownBtn.BackgroundTransparency = 1
	flyDownBtn.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
	flyDownBtn.ImageRectOffset = Vector2.new(1, 146)
	flyDownBtn.ImageRectSize = Vector2.new(144, 144)
	flyDownBtn.Rotation = 180
	flyDownBtn.Parent = buttonFrame
	flyDownBtn.ZIndex = 15
	local flyUpBtn = Instance.new("ImageButton")
	flyUpBtn.Name = "FlyUpBtn"
	flyUpBtn.BackgroundTransparency = 1
	flyUpBtn.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
	flyUpBtn.ImageRectOffset = Vector2.new(1, 146)
	flyUpBtn.ImageRectSize = Vector2.new(144, 144)
	flyUpBtn.Rotation = 0
	flyUpBtn.Parent = buttonFrame
	flyUpBtn.ZIndex = 15
	flyDownBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch and input.UserInputState == Enum.UserInputState.Begin then
			flyDownBtn.ImageRectOffset = Vector2.new(146, 146)
			FlyDownActive = true
		end
	end)
	flyDownBtn.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			flyDownBtn.ImageRectOffset = Vector2.new(1, 146)
			FlyDownActive = false
		end
	end)
	flyUpBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch and input.UserInputState == Enum.UserInputState.Begin then
			flyUpBtn.ImageRectOffset = Vector2.new(146, 146)
			FlyUpActive = true
		end
	end)
	flyUpBtn.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			flyUpBtn.ImageRectOffset = Vector2.new(1, 146)
			FlyUpActive = false
		end
	end)
	function updateButtonSize()
		local screenSize = parent.AbsoluteSize
		local isSmallScreen = math.min(screenSize.X, screenSize.Y) <= 500
		local buttonSize = isSmallScreen and 70 or 90
		local totalWidth = (buttonSize * 2) + (padding * 3)
		local totalHeight = buttonSize + (padding * 2)
		buttonFrame.Size = UDim2.new(0, totalWidth, 0, totalHeight)
		buttonFrame.Position = UDim2.new(1, -(totalWidth + padding), 1, -(totalHeight + padding))
		flyDownBtn.Size = UDim2.new(0, buttonSize, 0, buttonSize)
		flyDownBtn.Position = UDim2.new(0, padding, 0, padding)
		flyUpBtn.Size = UDim2.new(0, buttonSize, 0, buttonSize)
		flyUpBtn.Position = UDim2.new(0, padding + buttonSize + padding, 0, padding)
	end
	parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateButtonSize)
	updateButtonSize()
	GuiService.MenuOpened:Connect(function()
		flyDownBtn.ImageRectOffset = Vector2.new(1, 146)
		flyUpBtn.ImageRectOffset = Vector2.new(1, 146)
		FlyDownActive = false
		FlyUpActive = false
	end)
	return buttonFrame, flyDownBtn, flyUpBtn
end
function CreateTiltButtons(parent)
	local padding = 9

	local function MakeTiltButton(iconId)
		local outerFrame = Instance.new("Frame")
		outerFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		outerFrame.BackgroundTransparency = 0.5
		outerFrame.ZIndex = 15
		outerFrame.Parent = parent

		local outerCorner = Instance.new("UICorner")
		outerCorner.CornerRadius = UDim.new(1, 0)
		outerCorner.Parent = outerFrame

		local outerStroke = Instance.new("UIStroke")
		outerStroke.Thickness = 3
		outerStroke.Transparency = 0.8
		outerStroke.Color = Color3.fromRGB(255, 255, 255)
		outerStroke.Parent = outerFrame

		local innerFrame = Instance.new("Frame")
		innerFrame.Size = UDim2.new(1, 6, 1, 6)
		innerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		innerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		innerFrame.BackgroundTransparency = 1
		innerFrame.ZIndex = 15
		innerFrame.Parent = outerFrame

		local innerCorner = Instance.new("UICorner")
		innerCorner.CornerRadius = UDim.new(1, 0)
		innerCorner.Parent = innerFrame

		local innerStroke = Instance.new("UIStroke")
		innerStroke.Thickness = 2
		innerStroke.Transparency = 0.6
		innerStroke.Color = Color3.fromRGB(0, 0, 0)
		innerStroke.Parent = innerFrame

		local icon = Instance.new("ImageLabel")
		icon.Size = UDim2.new(0.55, 0, 0.55, 0)
		icon.Position = UDim2.new(0.5, 0, 0.5, 0)
		icon.AnchorPoint = Vector2.new(0.5, 0.5)
		icon.BackgroundTransparency = 1
		icon.Image = iconId
		icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
		icon.ImageTransparency = 0.3
		icon.ZIndex = 16
		icon.Parent = outerFrame

		local hitbox = Instance.new("TextButton")
		hitbox.Size = UDim2.new(1, 0, 1, 0)
		hitbox.Position = UDim2.new(0, 0, 0, 0)
		hitbox.BackgroundTransparency = 1
		hitbox.Text = ""
		hitbox.ZIndex = 17
		hitbox.Parent = outerFrame

		return outerFrame, hitbox, icon
	end

	local buttonFrame = Instance.new("Frame")
	buttonFrame.Name = "TiltButtons"
	buttonFrame.BackgroundTransparency = 1
	buttonFrame.Parent = parent
	buttonFrame.ZIndex = 15

	local tiltLeftFrame, tiltLeftHit, tiltLeftIcon = MakeTiltButton("rbxassetid://110116685948665")
	tiltLeftFrame.Name = "TiltLeftBtn"
	tiltLeftFrame.Parent = buttonFrame

	local tiltRightFrame, tiltRightHit, tiltRightIcon = MakeTiltButton("rbxassetid://84183336178654")
	tiltRightFrame.Name = "TiltRightBtn"
	tiltRightFrame.Parent = buttonFrame

	local tiltLeftBtn = tiltLeftHit
	local tiltRightBtn = tiltRightHit

	tiltLeftHit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch and input.UserInputState == Enum.UserInputState.Begin then
			tiltLeftFrame.BackgroundTransparency = 0.25
			tiltLeftIcon.ImageTransparency = 0
			TiltLeftActive = true
		end
	end)
	tiltLeftHit.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			tiltLeftFrame.BackgroundTransparency = 0.5
			tiltLeftIcon.ImageTransparency = 0.3
			TiltLeftActive = false
		end
	end)
	tiltRightHit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch and input.UserInputState == Enum.UserInputState.Begin then
			tiltRightFrame.BackgroundTransparency = 0.25
			tiltRightIcon.ImageTransparency = 0
			TiltRightActive = true
		end
	end)
	tiltRightHit.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			tiltRightFrame.BackgroundTransparency = 0.5
			tiltRightIcon.ImageTransparency = 0.3
			TiltRightActive = false
		end
	end)

	function updateButtonSize()
		local screenSize = parent.AbsoluteSize
		local isSmallScreen = math.min(screenSize.X, screenSize.Y) <= 500
		local buttonSize = isSmallScreen and 60 or 75
		local totalWidth = (buttonSize * 2) + (padding * 3)
		buttonFrame.Size = UDim2.new(0, totalWidth, 0, buttonSize + (padding * 2))
		buttonFrame.Position = UDim2.new(0, padding, 1, -(buttonSize + (padding * 2)))
		tiltLeftFrame.Size = UDim2.new(0, buttonSize, 0, buttonSize)
		tiltLeftFrame.Position = UDim2.new(0, padding, 0, padding)
		tiltRightFrame.Size = UDim2.new(0, buttonSize, 0, buttonSize)
		tiltRightFrame.Position = UDim2.new(0, padding + buttonSize + padding, 0, padding)
	end

	parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateButtonSize)
	updateButtonSize()

	GuiService.MenuOpened:Connect(function()
		TiltLeftActive = false
		TiltRightActive = false
		tiltLeftFrame.BackgroundTransparency = 0.5
		tiltLeftIcon.ImageTransparency = 0.3
		tiltRightFrame.BackgroundTransparency = 0.5
		tiltRightIcon.ImageTransparency = 0.3
	end)

	return buttonFrame, tiltLeftBtn, tiltRightBtn
end
function CreateTouchControls()
	local gui = Instance.new("ScreenGui")
	gui.Name = "FreeCamTouchControll"
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.ResetOnSpawn = false
	gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	local thumbstickFrame = Instance.new("Frame")
	thumbstickFrame.Name = "DynamicThumbstickFrame"
	thumbstickFrame.BorderSizePixel = 0
	thumbstickFrame.Visible = true
	thumbstickFrame.BackgroundTransparency = 1
	thumbstickFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	thumbstickFrame.Active = true
	thumbstickFrame.Size = UDim2.new(0.4, 0, 0.6666666666666666, 0)
	thumbstickFrame.Position = UDim2.new(0, 0, 0.3333333333333333, 0)
	thumbstickFrame.Parent = gui
	thumbstickFrame.ZIndex = 10
	local startImage = Instance.new("ImageLabel")
	startImage.Name = "ThumbstickStart"
	startImage.Visible = true
	startImage.BackgroundTransparency = 1
	startImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
	startImage.ImageRectOffset = Vector2.new(1, 1)
	startImage.ImageRectSize = Vector2.new(144, 144)
	startImage.ImageColor3 = Color3.new(0, 0, 0)
	startImage.ImageTransparency = 1
	startImage.AnchorPoint = Vector2.new(0.5, 0.5)
	startImage.ZIndex = 10
	startImage.Parent = thumbstickFrame
	local endImage = Instance.new("ImageLabel")
	endImage.Name = "ThumbstickEnd"
	endImage.Visible = true
	endImage.BackgroundTransparency = 1
	endImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
	endImage.ImageRectOffset = Vector2.new(1, 1)
	endImage.ImageRectSize = Vector2.new(144, 144)
	endImage.ImageColor3 = Color3.new(0, 0, 0)
	endImage.ImageTransparency = 1
	endImage.AnchorPoint = Vector2.new(0.5, 0.5)
	endImage.ZIndex = 10
	endImage.Parent = thumbstickFrame
	local middleImages = {}
	local originalTransparencies = {0.11, 0.30, 0.40, 0.50, 0.60, 0.70, 0.75}
	for i = 1, 7 do
		local middle = Instance.new("ImageLabel")
		middle.Name = "ThumbstickMiddle"
		middle.Visible = false
		middle.BackgroundTransparency = 1
		middle.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
		middle.ImageRectOffset = Vector2.new(1, 1)
		middle.ImageRectSize = Vector2.new(144, 144)
		middle.ImageTransparency = originalTransparencies[i]
		middle.AnchorPoint = Vector2.new(0.5, 0.5)
		middle.ZIndex = 9
		middle.Parent = thumbstickFrame
		middleImages[i] = middle
	end
	local thumbstickSize = 45
	local thumbstickRingSize = 20
	local middleSize = 10
	local middleSpacing = 14
	local radiusDeadZone = 2
	local radiusMaxSpeed = 20
	local moveTouchObject = nil
	local moveTouchStartPosition = nil
	local moveTouchLockedIn = false
	local moveTouchFirstChanged = false
	local isFirstTouch = true
	function updatePositions()
		local baseX = thumbstickRingSize * 3.3
		local baseY = thumbstickRingSize * 2.8
		startImage.Position = UDim2.new(0, baseX, 1, -baseY)
		startImage.Size = UDim2.new(0, thumbstickRingSize * 3.7, 0, thumbstickRingSize * 3.7)
		endImage.Position = startImage.Position
		endImage.Size = UDim2.new(0, thumbstickSize * 0.8, 0, thumbstickSize * 0.8)
	end
	thumbstickFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updatePositions)
	task.wait(0.1)
	updatePositions()
	function layoutMiddleImages(startPos, endPos)
		local centerOffset = thumbstickSize / 2 + middleSize
		local delta = endPos - startPos
		local dist = delta.Magnitude - thumbstickRingSize / 2 - middleSize
		local direction = delta.Unit
		local totalSpacing = middleSpacing * 7
		local stepSize = middleSpacing
		if totalSpacing < dist then
			stepSize = dist / 7
		end
		for i = 1, 7 do
			local img = middleImages[i]
			local startDist = centerOffset + stepSize * (i - 2)
			local endDist = centerOffset + stepSize * (i - 1)
			if startDist < dist then
				local pos = endPos - direction * endDist
				local alpha = 1 - (endDist - dist) / stepSize
				local clampedAlpha = math.clamp(alpha, 0, 1)
				img.Visible = true
				img.Position = UDim2.new(0, pos.X, 0, pos.Y)
				img.Size = UDim2.new(0, middleSize * clampedAlpha, 0, middleSize * clampedAlpha)
			else
				img.Visible = false
			end
		end
	end
	function moveStick(touchPos)
		local startPos = Vector2.new(moveTouchStartPosition.X, moveTouchStartPosition.Y) - thumbstickFrame.AbsolutePosition
		local endPos = Vector2.new(touchPos.X, touchPos.Y) - thumbstickFrame.AbsolutePosition
		endImage.Position = UDim2.new(0, endPos.X, 0, endPos.Y)
		layoutMiddleImages(startPos, endPos)
	end
	function doMove(offset)
		local mag = offset.Magnitude
		if mag < radiusDeadZone then
			MobileMoveVector = Vector3.new(0, 0, 0)
		else
			local unit = offset.Unit
			local speedFactor = (radiusMaxSpeed - mag) / radiusMaxSpeed
			local scaled = unit * (1 - math.max(0, speedFactor))
			MobileMoveVector = Vector3.new(scaled.X, 0, scaled.Y)
		end
	end
	function fadeThumbstick(fadeIn)
		local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
		if fadeIn then
			TweenService:Create(startImage, tweenInfo, {ImageTransparency = 0}):Play()
			TweenService:Create(endImage, tweenInfo, {ImageTransparency = 0.2}):Play()
			for i = 1, 7 do
				TweenService:Create(middleImages[i], tweenInfo, {ImageTransparency = originalTransparencies[i]}):Play()
			end
		else
			TweenService:Create(startImage, tweenInfo, {ImageTransparency = 1}):Play()
			TweenService:Create(endImage, tweenInfo, {ImageTransparency = 1}):Play()
			for i = 1, 7 do
				TweenService:Create(middleImages[i], tweenInfo, {ImageTransparency = 1}):Play()
			end
		end
	end
	function onInputEnded()
		moveTouchObject = nil
		MobileMoveVector = Vector3.new(0, 0, 0)
		fadeThumbstick(false)
	end
	function inputInFrame(touch)
		local absPos = thumbstickFrame.AbsolutePosition
		local absSize = thumbstickFrame.AbsoluteSize
		local touchPos = touch.Position
		return touchPos.X >= absPos.X and touchPos.Y >= absPos.Y and
			touchPos.X <= absPos.X + absSize.X and touchPos.Y <= absPos.Y + absSize.Y
	end
	function onTouchBegin(touch)
		if moveTouchObject then return end
		if not inputInFrame(touch) then return end
		if isFirstTouch then
			isFirstTouch = false
			local growTween = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			TweenService:Create(startImage, growTween, {Size = UDim2.new(0, 0, 0, 0)}):Play()
			TweenService:Create(endImage, growTween, {
				Size = UDim2.new(0, thumbstickSize, 0, thumbstickSize),
				ImageColor3 = Color3.new(0, 0, 0)
			}):Play()
		end
		moveTouchLockedIn = false
		moveTouchObject = touch
		moveTouchStartPosition = touch.Position
		moveTouchFirstChanged = true
	end
	function onTouchMove(touch)
		if touch ~= moveTouchObject then return end
		if moveTouchFirstChanged then
			moveTouchFirstChanged = false
			local startPosRel = Vector2.new(touch.Position.X - thumbstickFrame.AbsolutePosition.X, touch.Position.Y - thumbstickFrame.AbsolutePosition.Y)
			startImage.Visible = true
			startImage.Position = UDim2.new(0, startPosRel.X, 0, startPosRel.Y)
			endImage.Visible = true
			endImage.Position = startImage.Position
			fadeThumbstick(true)
			moveStick(touch.Position)
		end
		moveTouchLockedIn = true
		local offset = Vector2.new(touch.Position.X - moveTouchStartPosition.X, touch.Position.Y - moveTouchStartPosition.Y)
		if math.abs(offset.X) > 0 or math.abs(offset.Y) > 0 then
			doMove(offset)
			moveStick(touch.Position)
		end
	end
	function onTouchEnd(touch)
		if touch == moveTouchObject then
			onInputEnded()
		end
	end
	local beginCon = UserInputService.TouchStarted:Connect(onTouchBegin)
	local moveCon = UserInputService.TouchMoved:Connect(onTouchMove)
	local endCon = UserInputService.TouchEnded:Connect(onTouchEnd)
	GuiService.MenuOpened:Connect(function()
		if moveTouchObject then
			onInputEnded()
		end
	end)
	local rightDragActive = false
	local rightDragStart = nil
	local rightDragTouch = nil
	UserInputService.TouchStarted:Connect(function(touch)
		local screenSize = FreecamCamera.ViewportSize
		if touch.Position.X > screenSize.X / 2 then
			rightDragActive = true
			rightDragStart = touch.Position
			rightDragTouch = touch
		end
	end)
	UserInputService.TouchMoved:Connect(function(touch)
		if rightDragActive and rightDragTouch == touch and rightDragStart then
			local delta = touch.Position - rightDragStart
			MobileLookVector = Vector2.new(-delta.Y * 0.1 * TouchLookSensitivity, -delta.X * 0.1 * TouchLookSensitivity)
			rightDragStart = touch.Position
		end
	end)
	UserInputService.TouchEnded:Connect(function(touch)
		if rightDragTouch == touch then
			rightDragActive = false
			rightDragTouch = nil
			MobileLookVector = Vector2.new(0, 0)
		end
	end)
	local pinchTouch1 = nil
	local pinchTouch2 = nil
	local pinchActive = false
	local lastPinchDistance = 0
	UserInputService.TouchStarted:Connect(function(touch)
		local screenSize = FreecamCamera.ViewportSize
		if touch.Position.X > screenSize.X / 2 then
			if not pinchTouch1 then
				pinchTouch1 = touch
			elseif not pinchTouch2 and touch ~= pinchTouch1 then
				pinchTouch2 = touch
				pinchActive = true
				lastPinchDistance = (pinchTouch1.Position - pinchTouch2.Position).Magnitude
			end
		end
	end)
	UserInputService.TouchMoved:Connect(function(touch)
		if pinchActive and pinchTouch1 and pinchTouch2 then
			if touch == pinchTouch1 then
				pinchTouch1 = touch
			elseif touch == pinchTouch2 then
				pinchTouch2 = touch
			end
			local currentDistance = (pinchTouch1.Position - pinchTouch2.Position).Magnitude
			local delta = currentDistance - lastPinchDistance
			if math.abs(delta) > 0.5 then
				MobileFovDelta = -delta * 0.35 * FovSensitivity
				lastPinchDistance = currentDistance
			end
		end
	end)
	UserInputService.TouchEnded:Connect(function(touch)
		if touch == pinchTouch1 then
			pinchTouch1 = pinchTouch2
			pinchTouch2 = nil
		elseif touch == pinchTouch2 then
			pinchTouch2 = nil
		end
		if not pinchTouch1 or not pinchTouch2 then
			pinchActive = false
			lastPinchDistance = 0
		end
	end)
	local flyButtons = CreateFlyButtons(gui)
	local tiltButtons = CreateTiltButtons(gui)
	return gui
end
local Input = {}
do
	local thumbstickCurve
	do
		local kCurvature = 2.0
		local kDeadzone = 0.15
		function fCurve(x)
			return (exp(kCurvature*x) - 1)/(exp(kCurvature) - 1)
		end
		function fDeadzone(x)
			return fCurve((x - kDeadzone)/(1 - kDeadzone))
		end
		function thumbstickCurve(x)
			return sign(x)*clamp(fDeadzone(abs(x)), 0, 1)
		end
	end
	local gamepad = {
		ButtonX = 0, ButtonY = 0, DPadDown = 0, DPadUp = 0,
		DPadLeft = 0, DPadRight = 0, ButtonL2 = 0, ButtonR2 = 0,
		ButtonL1 = 0, ButtonR1 = 0, Thumbstick1 = Vector2.new(), Thumbstick2 = Vector2.new(),
	}
	local keyboard = {
		W = 0, A = 0, S = 0, D = 0, E = 0, Q = 0, U = 0, H = 0, J = 0, K = 0, I = 0, Y = 0,
		Up = 0, Down = 0, Left = 0, Right = 0, LeftShift = 0, RightShift = 0,
		Z = 0, C = 0, Comma = 0, Period = 0, LeftBracket = 0, RightBracket = 0,
		Semicolon = 0, Quote = 0, V = 0, B = 0, N = 0, M = 0, BackSlash = 0,
		Minus = 0, Equals = 0, Slash = 0, R = 0, T = 0, G = 0, X = 0, L = 0
	}
	local mouse = { Delta = Vector2.new(), MouseWheel = 0 }
	local defaultFps = 60
	local NavGamepadSpeed = Vector3.new(1, 1, 1)
	local NavKeyboardSpeed = Vector3.new(1, 1, 1)
	local PanMouseSpeed = Vector2.new(1, 1)*(pi/64)
	local PanMouseSpeedDt = PanMouseSpeed/defaultFps
	local PanGamepadSpeed = Vector2.new(1, 1)*(pi/8)
	local FovWheelSpeed = 1.0
	local FovWheelSpeedDt = FovWheelSpeed/defaultFps
	local FovGamepadSpeed = 0.25
	local RollGamepadSpeed = 1.0
	local RollKeyboardSpeed = 1.0
	local NavAdjSpeed = 0.75
	local NavMinSpeed = 0.01
	local NavMaxSpeed = 4.0
	local NavShiftMul = 0.25
	local FovAdjSpeed = 0.75
	local FovMinSpeed = 0.01
	local FovMaxSpeed = 4.0
	local RollAdjSpeed = 0.75
	local RollMinSpeed = 0.01
	local RollMaxSpeed = 4.0
	local DoFConstants = {
		FarIntensity = { adj = 0.1, min = 0.0, max = 1.0 },
		NearIntensity = { adj = 0.1, min = 0.0, max = 1.0 },
		FocusDistance = { adj = 20.0, min = 0.0, max = 200.0 },
		FocusRadius = { adj = 5.0, min = 0.0, max = 50.0 },
	}
	local navSpeed = 1
	local rollSpeed = 1
	local fovSpeed = 1
	function Input.Vel(dt)
		if FFlagUserFreecamControlSpeed then
			navSpeed = clamp(navSpeed + dt*(keyboard.Up - keyboard.Down + gamepad.DPadUp - gamepad.DPadDown)*NavAdjSpeed, NavMinSpeed, NavMaxSpeed)
		else
			navSpeed = clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NavAdjSpeed, 0.01, 4)
		end
		local flyVertical = 0
		if FlyUpActive then flyVertical = flyVertical + 1 end
		if FlyDownActive then flyVertical = flyVertical - 1 end
		local mobileMove = Vector3.new(MobileMoveVector.X, flyVertical, MobileMoveVector.Z) * MobileNavSpeed
		local kGamepad = Vector3.new(
			thumbstickCurve(gamepad.Thumbstick1.X),
			thumbstickCurve(gamepad.ButtonR2) - thumbstickCurve(gamepad.ButtonL2),
			thumbstickCurve(-gamepad.Thumbstick1.Y)
		)*NavGamepadSpeed
		local kKeyboard = Vector3.new(
			keyboard.D - keyboard.A + keyboard.K - keyboard.H,
			keyboard.E - keyboard.Q + keyboard.I - keyboard.Y,
			keyboard.S - keyboard.W + keyboard.J - keyboard.U
		)*NavKeyboardSpeed
		local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
		return (kGamepad + kKeyboard + mobileMove)*(navSpeed*(shift and NavShiftMul or 1))
	end
	function Input.Pan(dt)
		local mobilePan = MobileLookVector
		local kGamepad = Vector2.new(
			thumbstickCurve(gamepad.Thumbstick2.Y),
			thumbstickCurve(-gamepad.Thumbstick2.X)
		)*PanGamepadSpeed
		local kMouse = mouse.Delta*PanMouseSpeed * MouseSensitivity
		if FFlagUserFixFreecamDeltaTimeCalculation then
			if dt > 0 then
				kMouse = (mouse.Delta/dt)*PanMouseSpeedDt * MouseSensitivity
			end
		end
		mouse.Delta = Vector2.new()
		return kGamepad + kMouse + mobilePan
	end
	function Input.Fov(dt)
		if FFlagUserFreecamControlSpeed then
			fovSpeed = clamp(fovSpeed + dt*(keyboard.Right - keyboard.Left + gamepad.DPadRight - gamepad.DPadLeft)*FovAdjSpeed, FovMinSpeed, FovMaxSpeed)
		end
		local kGamepad = (gamepad.ButtonX - gamepad.ButtonY)*FovGamepadSpeed
		local kMouse = mouse.MouseWheel*FovWheelSpeed * FovSensitivity
		local kMobile = MobileFovDelta
		MobileFovDelta = 0
		if FFlagUserFixFreecamDeltaTimeCalculation then
			if dt > 0 then
				kMouse = (mouse.MouseWheel/dt)*FovWheelSpeedDt * FovSensitivity
			end
		end
		mouse.MouseWheel = 0
		if FFlagUserFreecamControlSpeed then
			return (kGamepad + kMouse + kMobile)*fovSpeed
		else
			return kGamepad + kMouse + kMobile
		end
	end
	function Input.Roll(dt)
		rollSpeed = clamp(rollSpeed + dt*(keyboard.Period - keyboard.Comma)*RollAdjSpeed, RollMinSpeed, RollMaxSpeed)
		local kGamepad = (gamepad.ButtonR1 - gamepad.ButtonL1)*RollGamepadSpeed
		local kKeyboard = (keyboard.C - keyboard.Z)*RollKeyboardSpeed
		local kTouch = 0
		if TiltLeftActive then kTouch = kTouch + 1 end
		if TiltRightActive then kTouch = kTouch - 1 end
		local kCustomTilt = 0
		if TiltLeftActiveKB then kCustomTilt = kCustomTilt + 1 end
		if TiltRightActiveKB then kCustomTilt = kCustomTilt - 1 end
		return (kGamepad + kKeyboard + kTouch + kCustomTilt)*rollSpeed
	end
	function Input.SpringControl(dt)
		if FFlagUserFreecamDepthOfFieldEffect then
			local shiftIsDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
			local ctrlIsDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
			if shiftIsDown or ctrlIsDown then return end
		end
		VelStiffness = clamp(VelStiffness + dt*(keyboard.RightBracket - keyboard.LeftBracket)*VelAdjStiffness, VelMinStiffness, VelMaxStiffness)
		VelSpring:SetFreq(VelStiffness)
		PanStiffness = clamp(PanStiffness + dt*(keyboard.Quote - keyboard.Semicolon)*PanAdjStiffness, PanMinStiffness, PanMaxStiffness)
		PanSpring:SetFreq(PanStiffness)
		FovStiffness = clamp(FovStiffness + dt*(keyboard.B - keyboard.V)*FovAdjStiffness, FovMinStiffness, FovMaxStiffness)
		FovSpring:SetFreq(FovStiffness)
		RollStiffness = clamp(RollStiffness + dt*(keyboard.M - keyboard.N)*RollAdjStiffness, RollMinStiffness, RollMaxStiffness)
		RollSpring:SetFreq(RollStiffness)
	end
	function Input.DoF(dt)
		local shiftIsDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
		local ctrlIsDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
		if shiftIsDown then
			FreecamDepthOfField.FarIntensity = clamp(
				FreecamDepthOfField.FarIntensity + dt * (keyboard.RightBracket - keyboard.LeftBracket) * DoFConstants.FarIntensity.adj,
				DoFConstants.FarIntensity.min, DoFConstants.FarIntensity.max
			)
			FreecamDepthOfField.InFocusRadius = clamp(
				FreecamDepthOfField.InFocusRadius + dt * (keyboard.Equals - keyboard.Minus) * DoFConstants.FocusRadius.adj,
				DoFConstants.FocusRadius.min, DoFConstants.FocusRadius.max
			)
		elseif ctrlIsDown then
			FreecamDepthOfField.NearIntensity = clamp(
				FreecamDepthOfField.NearIntensity + dt * (keyboard.RightBracket - keyboard.LeftBracket) * DoFConstants.NearIntensity.adj,
				DoFConstants.NearIntensity.min, DoFConstants.NearIntensity.max
			)
		else
			FreecamDepthOfField.FocusDistance = clamp(
				FreecamDepthOfField.FocusDistance + dt * (keyboard.Equals - keyboard.Minus) * DoFConstants.FocusDistance.adj,
				DoFConstants.FocusDistance.min, DoFConstants.FocusDistance.max
			)
		end
	end
	do
		local FreecamTiltResetGp = {
			[Enum.KeyCode.ButtonL1] = true,
			[Enum.KeyCode.ButtonR1] = true,
		}
		local FreecamTiltResetKb = {
			[Enum.KeyCode.Z] = true,
			[Enum.KeyCode.C] = true,
		}
		local FreecamDofToggle = {
			[Enum.KeyCode.BackSlash] = true,
		}
		local FreecamCustomGuiToggle = {
			[Enum.KeyCode.G] = true,
		}
		local FreecamPlayerGuiToggle = {
			[Enum.KeyCode.X] = true,
		}
		local FreecamLeaderboardToggle = {
			[Enum.KeyCode.L] = true,
		}
		function resetKeys(keys, table)
			for keyEnum, _ in pairs(keys) do
				if table[keyEnum.Name] then
					table[keyEnum.Name] = 0
				end
			end
		end
		function handleDoubleTapReset(keyCode)
			local currentTime = os.clock()
			local previousPressTime = lastPressTime[keyCode]
			local timeSinceLastPress = previousPressTime and (currentTime - previousPressTime) or -1
			if previousPressTime and (timeSinceLastPress <= DoubleTapTimeThreshold) then
				if (currentTime - lastResetTime) >= DoubleTapDebounceTime then
					CameraRot = Vector3.new(CameraRot.x, CameraRot.y, 0)
					RollSpring:Reset(0)
					if FFlagUserFreecamDepthOfFieldEffect then
						resetKeys(FreecamTiltResetGp, gamepad)
						resetKeys(FreecamTiltResetKb, keyboard)
					else
						gamepad.ButtonL1 = 0
						gamepad.ButtonR1 = 0
						keyboard.C = 0
						keyboard.Z = 0
					end
					lastResetTime = currentTime
				end
			end
			lastPressTime[keyCode] = currentTime
		end
		function Keypress(action, state, input)
			keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
			if #CustomTiltLeftKeys > 0 then
				for _, keyName in ipairs(CustomTiltLeftKeys) do
					if input.KeyCode.Name == keyName then
						TiltLeftActiveKB = (state == Enum.UserInputState.Begin)
					end
				end
			end
			if #CustomTiltRightKeys > 0 then
				for _, keyName in ipairs(CustomTiltRightKeys) do
					if input.KeyCode.Name == keyName then
						TiltRightActiveKB = (state == Enum.UserInputState.Begin)
					end
				end
			end
			if FFlagUserFreecamTiltControl then
				if FreecamTiltResetKb[input.KeyCode] and input.UserInputState == Enum.UserInputState.Begin then
					handleDoubleTapReset(input.KeyCode)
				end
			end
			if FFlagUserFreecamDepthOfFieldEffect then
				if FreecamDofToggle[input.KeyCode] and input.UserInputState == Enum.UserInputState.Begin then
					if not FreecamDepthOfField.Enabled then
						PostEffects = {}
						for _, effect in ipairs(FreecamCamera:GetChildren()) do
							if effect:IsA("DepthOfFieldEffect") and effect.Enabled then
								PostEffects[#PostEffects + 1] = effect
								effect.Enabled = false
							end
						end
						for _, effect in ipairs(Lighting:GetChildren()) do
							if effect:IsA("DepthOfFieldEffect") and effect.Enabled then
								PostEffects[#PostEffects + 1] = effect
								effect.Enabled = false
							end
						end
						CameraConnection = FreecamCamera.ChildAdded:Connect(function(child)
							if child:IsA("DepthOfFieldEffect") and child.Enabled then
								PostEffects[#PostEffects + 1] = child
								child.Enabled = false
							end
						end)
						LightingConnection = Lighting.ChildAdded:Connect(function(child)
							if child:IsA("DepthOfFieldEffect") and child.Enabled then
								PostEffects[#PostEffects + 1] = child
								child.Enabled = false
							end
						end)
					else
						for _, effect in ipairs(PostEffects) do
							if effect.Parent then
								effect.Enabled = true
							end
						end
						if CameraConnection then
							CameraConnection:Disconnect()
							CameraConnection = nil
						end
						if LightingConnection then
							LightingConnection:Disconnect()
							LightingConnection = nil
						end
						PostEffects = {}
					end
					FreecamDepthOfField.Enabled = not FreecamDepthOfField.Enabled
					resetKeys(FreecamDofToggle, keyboard)
				end
			end
			if FFlagUserFreecamCustomGui then
				if FreecamCustomGuiToggle[input.KeyCode] and input.UserInputState == Enum.UserInputState.Begin then
					if freecamGui and freecamGui.Parent then
						freecamGui.Enabled = not freecamGui.Enabled
					end
					resetKeys(FreecamCustomGuiToggle, keyboard)
				end
				if FreecamPlayerGuiToggle[input.KeyCode] and input.UserInputState == Enum.UserInputState.Begin then
					ScreenGuisEnabled = not ScreenGuisEnabled
					if PlayerState then
						local screenGuis = PlayerState.getScreenGuis()
						for _, gui in pairs(screenGuis) do
							if gui.Parent and gui ~= freecamGui then
								gui.Enabled = ScreenGuisEnabled
							end
						end
					end
					resetKeys(FreecamPlayerGuiToggle, keyboard)
				end
				if FreecamLeaderboardToggle[input.KeyCode] and input.UserInputState == Enum.UserInputState.Begin then
					LeaderboardEnabled = not LeaderboardEnabled
					StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, LeaderboardEnabled)
					resetKeys(FreecamLeaderboardToggle, keyboard)
				end
			end
			return Enum.ContextActionResult.Sink
		end
		function GpButton(action, state, input)
			gamepad[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
			if FFlagUserFreecamTiltControl then
				if FreecamTiltResetGp[input.KeyCode] and input.UserInputState == Enum.UserInputState.Begin then
					handleDoubleTapReset(input.KeyCode)
				end
			end
			return Enum.ContextActionResult.Sink
		end
		function MousePan(action, state, input)
			local delta = input.Delta
			mouse.Delta = Vector2.new(-delta.y, -delta.x)
			return Enum.ContextActionResult.Sink
		end
		function Thumb(action, state, input)
			gamepad[input.KeyCode.Name] = input.Position
			return Enum.ContextActionResult.Sink
		end
		function Trigger(action, state, input)
			gamepad[input.KeyCode.Name] = input.Position.z
			return Enum.ContextActionResult.Sink
		end
		function MouseWheel(action, state, input)
			mouse[input.UserInputType.Name] = -input.Position.z
			return Enum.ContextActionResult.Sink
		end
		function Zero(t)
			for k, v in pairs(t) do
				t[k] = v*0
			end
		end
		function Input.StartCapture()
			if FFlagUserFreecamControlSpeed then
				ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, InputPriority,
					Enum.KeyCode.W, Enum.KeyCode.U, Enum.KeyCode.A, Enum.KeyCode.H,
					Enum.KeyCode.S, Enum.KeyCode.J, Enum.KeyCode.D, Enum.KeyCode.K,
					Enum.KeyCode.E, Enum.KeyCode.I, Enum.KeyCode.Q, Enum.KeyCode.Y
				)
				ContextActionService:BindActionAtPriority("FreecamKeyboardControlSpeed", Keypress, false, InputPriority,
					Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left, Enum.KeyCode.Right
				)
				ContextActionService:BindActionAtPriority("FreecamGamepadControlSpeed", GpButton, false, InputPriority,
					Enum.KeyCode.DPadUp, Enum.KeyCode.DPadDown, Enum.KeyCode.DPadLeft, Enum.KeyCode.DPadRight
				)
			else
				ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, InputPriority,
					Enum.KeyCode.W, Enum.KeyCode.U, Enum.KeyCode.A, Enum.KeyCode.H,
					Enum.KeyCode.S, Enum.KeyCode.J, Enum.KeyCode.D, Enum.KeyCode.K,
					Enum.KeyCode.E, Enum.KeyCode.I, Enum.KeyCode.Q, Enum.KeyCode.Y,
					Enum.KeyCode.Up, Enum.KeyCode.Down
				)
			end
			if FFlagUserFreecamTiltControl then
				ContextActionService:BindActionAtPriority("FreecamKeyboardTiltControl", Keypress, false, InputPriority,
					Enum.KeyCode.Z, Enum.KeyCode.C
				)
				ContextActionService:BindActionAtPriority("FreecamGamepadTiltControl", GpButton, false, InputPriority,
					Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1
				)
				ContextActionService:BindActionAtPriority("FreecamKeyboardTiltControlSpeed", Keypress, false, InputPriority,
					Enum.KeyCode.Comma, Enum.KeyCode.Period
				)
				if FFlagUserFreecamSmoothnessControl then
					ContextActionService:BindActionAtPriority("FreecamKeyboardSmoothnessControl", Keypress, false, InputPriority,
						Enum.KeyCode.LeftBracket, Enum.KeyCode.RightBracket,
						Enum.KeyCode.Semicolon, Enum.KeyCode.Quote,
						Enum.KeyCode.V, Enum.KeyCode.B, Enum.KeyCode.N, Enum.KeyCode.M
					)
				end
			end
			if FFlagUserFreecamDepthOfFieldEffect then
				ContextActionService:BindActionAtPriority("FreecamKeyboardDoFToggle", Keypress, false, InputPriority, Enum.KeyCode.BackSlash)
				ContextActionService:BindActionAtPriority("FreecamKeyboardDoFControls", Keypress, false, InputPriority,
					Enum.KeyCode.Minus, Enum.KeyCode.Equals
				)
			end
			if FFlagUserFreecamCustomGui then
				ContextActionService:BindActionAtPriority("FreecamKeyboardCustomGuiToggle", Keypress, false, InputPriority, Enum.KeyCode.G)
				ContextActionService:BindActionAtPriority("FreecamKeyboardPlayerGuiToggle", Keypress, false, InputPriority, Enum.KeyCode.X)
				ContextActionService:BindActionAtPriority("FreecamKeyboardLeaderboardToggle", Keypress, false, InputPriority, Enum.KeyCode.L)
			end
			ContextActionService:BindActionAtPriority("FreecamMousePan", MousePan, false, InputPriority, Enum.UserInputType.MouseMovement)
			ContextActionService:BindActionAtPriority("FreecamMouseWheel", MouseWheel, false, InputPriority, Enum.UserInputType.MouseWheel)
			ContextActionService:BindActionAtPriority("FreecamGamepadButton", GpButton, false, InputPriority, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
			ContextActionService:BindActionAtPriority("FreecamGamepadTrigger", Trigger, false, InputPriority, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
			ContextActionService:BindActionAtPriority("FreecamGamepadThumbstick", Thumb, false, InputPriority, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
		end
		function Input.StopCapture()
			if not FFlagUserFreecamCustomGui then
				navSpeed = 1
				if FFlagUserFreecamControlSpeed then fovSpeed = 1 end
				if FFlagUserFreecamTiltControl then rollSpeed = 1 end
			end
			TiltLeftActiveKB = false
			TiltRightActiveKB = false
			Zero(gamepad)
			Zero(keyboard)
			Zero(mouse)
			ContextActionService:UnbindAction("FreecamKeyboard")
			if FFlagUserFreecamControlSpeed then
				ContextActionService:UnbindAction("FreecamKeyboardControlSpeed")
				ContextActionService:UnbindAction("FreecamGamepadControlSpeed")
			end
			if FFlagUserFreecamTiltControl then
				ContextActionService:UnbindAction("FreecamKeyboardTiltControl")
				ContextActionService:UnbindAction("FreecamGamepadTiltControl")
				ContextActionService:UnbindAction("FreecamKeyboardTiltControlSpeed")
				if FFlagUserFreecamSmoothnessControl then
					ContextActionService:UnbindAction("FreecamKeyboardSmoothnessControl")
				end
			end
			if FFlagUserFreecamDepthOfFieldEffect then
				ContextActionService:UnbindAction("FreecamKeyboardDoFToggle")
				ContextActionService:UnbindAction("FreecamKeyboardDoFControls")
			end
			if FFlagUserFreecamCustomGui then
				ContextActionService:UnbindAction("FreecamKeyboardCustomGuiToggle")
				ContextActionService:UnbindAction("FreecamKeyboardPlayerGuiToggle")
				ContextActionService:UnbindAction("FreecamKeyboardLeaderboardToggle")
			end
			ContextActionService:UnbindAction("FreecamMousePan")
			ContextActionService:UnbindAction("FreecamMouseWheel")
			ContextActionService:UnbindAction("FreecamGamepadButton")
			ContextActionService:UnbindAction("FreecamGamepadTrigger")
			ContextActionService:UnbindAction("FreecamGamepadThumbstick")
		end
		function Input.getNavSpeed() return navSpeed end
		function Input.getFovSpeed() return fovSpeed end
		function Input.getRollSpeed() return rollSpeed end
	end
end
function StepFreecam(dt)
	if FFlagUserFreecamSmoothnessControl then Input.SpringControl(dt) end
	if FFlagUserFreecamDepthOfFieldEffect then
		if FreecamDepthOfField and FreecamDepthOfField.Parent then Input.DoF(dt) end
	end
	local vel = VelSpring:Update(dt, Input.Vel(dt))
	local pan = PanSpring:Update(dt, Input.Pan(dt))
	local fov = FovSpring:Update(dt, Input.Fov(dt))
	local roll
	if FFlagUserFreecamTiltControl then roll = RollSpring:Update(dt, Input.Roll(dt)) end
	local zoomFactor = sqrt(tan(rad(70/2))/tan(rad(CameraFov/2)))
	CameraFov = clamp(CameraFov + fov*FovGain*(dt/zoomFactor), 1, 120)
	local cameraCFrame
	if FFlagUserFreecamTiltControl then
		local panVector = pan*PanGain*(dt/zoomFactor)
		CameraRot = CameraRot + Vector3.new(panVector.X, panVector.Y, roll*RollGain*(dt/zoomFactor))
		if FFlagUserFreecamSmoothnessControl then
			CameraRot = Vector3.new(CameraRot.x%(2*pi), CameraRot.y%(2*pi), CameraRot.z%(2*pi))
		else
			CameraRot = Vector3.new(clamp(CameraRot.x, -PitchLimit, PitchLimit), CameraRot.y%(2*pi), CameraRot.z)
		end
		cameraCFrame = CFrame.new(CameraPos)*CFrame.fromOrientation(CameraRot.x, CameraRot.y, CameraRot.z)*CFrame.new(vel*NavGain*dt)
	else
		CameraRot = CameraRot + pan*PanGain*(dt/zoomFactor)
		CameraRot = Vector2.new(clamp(CameraRot.x, -PitchLimit, PitchLimit), CameraRot.y%(2*pi))
		cameraCFrame = CFrame.new(CameraPos)*CFrame.fromOrientation(CameraRot.x, CameraRot.y, 0)*CFrame.new(vel*NavGain*dt)
	end
	CameraPos = cameraCFrame.p
	FreecamCamera.CFrame = cameraCFrame
	FreecamCamera.Focus = cameraCFrame
	FreecamCamera.FieldOfView = CameraFov
end
function CheckMouseLockAvailability()
	local devAllowsMouseLock = Players.LocalPlayer.DevEnableMouseLock
	local devMovementModeIsScriptable = Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
	local userHasMouseLockModeEnabled = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
	local userHasClickToMoveEnabled = GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove
	local MouseLockAvailable = devAllowsMouseLock and userHasMouseLockModeEnabled and not userHasClickToMoveEnabled and not devMovementModeIsScriptable
	return MouseLockAvailable
end
PlayerState = {}
do
	local mouseBehavior = nil
	local mouseIconEnabled = nil
	local cameraType = nil
	local cameraFocus = nil
	local cameraCFrame = nil
	local cameraFieldOfView = nil
	local screenGuis = {}
	local coreGuis = { Backpack = true, Chat = true, Health = true, PlayerList = true }
	local setCores = { BadgesNotificationsActive = true, PointsNotificationsActive = true }
	function PlayerState.Push()
		for name in pairs(coreGuis) do
			coreGuis[name] = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType[name])
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[name], false)
		end
		for name in pairs(setCores) do
			setCores[name] = StarterGui:GetCore(name)
			StarterGui:SetCore(name, false)
		end
		local playergui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		if playergui then
			local existingGuis = {}
			for _, gui in pairs(playergui:GetChildren()) do
				if gui:IsA("ScreenGui") and gui.Enabled and gui.Name ~= "FreeCamTouchControll" then
					existingGuis[gui] = true
					table.insert(screenGuis, gui)
					gui.Enabled = false
				end
			end
			if FFlagUserFixFreecamGuiChangeVisibility then
				PlayerGuiConnection = playergui.ChildAdded:Connect(function(child)
					if child:IsA("ScreenGui") and child.Enabled and child.Name ~= "FreeCamTouchControll" and not existingGuis[child] then
						table.insert(screenGuis, child)
						if FFlagUserFreecamCustomGui then
							child.Enabled = ScreenGuisEnabled
						else
							child.Enabled = false
						end
					end
				end)
			end
		end
		cameraFieldOfView = FreecamCamera.FieldOfView
		FreecamCamera.FieldOfView = 70
		cameraType = FreecamCamera.CameraType
		FreecamCamera.CameraType = Enum.CameraType.Custom
		cameraCFrame = FreecamCamera.CFrame
		cameraFocus = FreecamCamera.Focus
		mouseIconEnabled = UserInputService.MouseIconEnabled
		UserInputService.MouseIconEnabled = false
		if FFlagUserExitFreecamBreaksWithShiftlock and CheckMouseLockAvailability() then
			mouseBehavior = Enum.MouseBehavior.Default
		else
			mouseBehavior = UserInputService.MouseBehavior
		end
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
	function PlayerState.Pop()
		for name, isEnabled in pairs(coreGuis) do
			if isEnabled ~= nil then
				pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[name], isEnabled) end)
			end
		end
		for name, isEnabled in pairs(setCores) do
			if isEnabled ~= nil then
				pcall(function() StarterGui:SetCore(name, isEnabled) end)
			end
		end
		for _, gui in pairs(screenGuis) do
			if gui and gui.Parent then
				if FFlagUserFreecamCustomGui then
					if gui ~= freecamGui then
						pcall(function() gui.Enabled = true end)
					end
				else
					pcall(function() gui.Enabled = true end)
				end
			end
		end
		if FFlagUserFixFreecamGuiChangeVisibility then
			if PlayerGuiConnection then
				PlayerGuiConnection:Disconnect()
				PlayerGuiConnection = nil
			end
			screenGuis = {}
		end
		if cameraFieldOfView then
			pcall(function() FreecamCamera.FieldOfView = cameraFieldOfView end)
			cameraFieldOfView = nil
		end
		if cameraType then
			pcall(function() FreecamCamera.CameraType = cameraType end)
			cameraType = nil
		end
		if cameraCFrame then
			pcall(function() FreecamCamera.CFrame = cameraCFrame end)
			cameraCFrame = nil
		end
		if cameraFocus then
			pcall(function() FreecamCamera.Focus = cameraFocus end)
			cameraFocus = nil
		end
		if mouseIconEnabled ~= nil then
			pcall(function() UserInputService.MouseIconEnabled = mouseIconEnabled end)
			mouseIconEnabled = nil
		end
		if mouseBehavior ~= nil then
			pcall(function() UserInputService.MouseBehavior = mouseBehavior end)
			mouseBehavior = nil
		end
	end
	function PlayerState.getScreenGuis() return screenGuis end
end
local customGui = nil
local Draggable = {}
Draggable.__index = Draggable
function Draggable.new(dragFrame, targetFrame, callbacks)
	local self = setmetatable({}, Draggable)
	self.dragFrame = dragFrame
	self.targetFrame = targetFrame
	self.callbacks = callbacks or {}
	self.dragData = { dragging = false, dragStart = nil, startPos = nil, dragDistance = 0, isDraggingStarted = false, currentTouch = nil, originalZIndex = targetFrame.ZIndex, dragThreshold = 5 }
	self.connections = { mouseUp = nil, touchUp = nil, movement = nil, began = nil }
	self:setup()
	return self
end
function Draggable:cleanupConnections()
	if self.connections.mouseUp then self.connections.mouseUp:Disconnect() end
	if self.connections.touchUp then self.connections.touchUp:Disconnect() end
	if self.connections.movement then self.connections.movement:Disconnect() end
	self.connections.mouseUp = nil
	self.connections.touchUp = nil
	self.connections.movement = nil
end
function Draggable:resetState()
	self.dragData.dragging = false
	self.dragData.dragStart = nil
	self.dragData.startPos = nil
	self.dragData.dragDistance = 0
	self.dragData.isDraggingStarted = false
	self.dragData.currentTouch = nil
	self:cleanupConnections()
end
function Draggable:getDistance(pos1, pos2)
	return math.sqrt((pos2.X - pos1.X)^2 + (pos2.Y - pos1.Y)^2)
end
function Draggable:isMouseOverFrame(frame, position)
	local absPos, absSize = frame.AbsolutePosition, frame.AbsoluteSize
	return position.X >= absPos.X and position.X <= absPos.X + absSize.X and position.Y >= absPos.Y and position.Y <= absPos.Y + absSize.Y
end
function Draggable:updatePosition(input)
	if not self.dragData.dragging or not self.dragData.dragStart then return end
	local delta = input.Position - self.dragData.dragStart
	self.dragData.dragDistance = self:getDistance(input.Position, self.dragData.dragStart)
	self.targetFrame.Position = UDim2.new(self.dragData.startPos.X.Scale, self.dragData.startPos.X.Offset + delta.X, self.dragData.startPos.Y.Scale, self.dragData.startPos.Y.Offset + delta.Y)
end
function Draggable:onDragEnd()
	if self.dragData.dragging then
		local wasDragged = self.dragData.dragDistance > self.dragData.dragThreshold
		if not wasDragged and self.callbacks.onClick then self.callbacks.onClick() end
		if self.callbacks.onDragEnd then self.callbacks.onDragEnd(wasDragged) end
		self:resetState()
	end
end
function Draggable:onInputEnded(input)
	if not self.dragData.dragging then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		self:onDragEnd()
	elseif input.UserInputType == Enum.UserInputType.Touch and input == self.dragData.currentTouch then
		self:onDragEnd()
	end
end
function Draggable:onMovement(input)
	if not self.dragData.dragging then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input == self.dragData.currentTouch then
		if not self.dragData.isDraggingStarted and self.dragData.dragDistance > self.dragData.dragThreshold then
			self.dragData.isDraggingStarted = true
			if self.callbacks.onDragStart then self.callbacks.onDragStart() end
		end
		self:updatePosition(input)
	end
end
function Draggable:onInputBegan(input)
	local isClick = input.UserInputState == Enum.UserInputState.Begin and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
	if isClick and not self.dragData.dragging then
		if self:isMouseOverFrame(self.dragFrame, input.Position) then
			self.dragData.dragging = true
			self.dragData.dragStart = input.Position
			self.dragData.startPos = self.targetFrame.Position
			self.dragData.dragDistance = 0
			self.dragData.isDraggingStarted = false
			self.dragData.currentTouch = (input.UserInputType == Enum.UserInputType.Touch) and input or nil
			self:cleanupConnections()
			self.connections.mouseUp = UserInputService.InputEnded:Connect(function(endInput)
				if endInput.UserInputType == Enum.UserInputType.MouseButton1 then self:onInputEnded(endInput) end
			end)
			self.connections.touchUp = UserInputService.InputEnded:Connect(function(endInput)
				if endInput.UserInputType == Enum.UserInputType.Touch then self:onInputEnded(endInput) end
			end)
			self.connections.movement = UserInputService.InputChanged:Connect(function(moveInput)
				if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
					self:onMovement(moveInput)
				end
			end)
		end
	end
end
function Draggable:setup()
	self.connections.began = self.dragFrame.InputBegan:Connect(function(input) self:onInputBegan(input) end)
end
function Draggable:Destroy()
	self:cleanupConnections()
	if self.connections.began then self.connections.began:Disconnect() end
end
local Slider = {}
Slider.__index = Slider
function Slider.new(sliderBar, sliderHandle, onChange)
	local self = setmetatable({}, Slider)
	self.sliderBar = sliderBar
	self.sliderHandle = sliderHandle
	self.onChange = onChange
	self.dragData = { dragging = false, currentTouch = nil, lastValue = nil }
	self.connections = { began = nil, mouseUp = nil, touchUp = nil, movement = nil }
	self:setup()
	return self
end
function Slider:cleanupConnections()
	if self.connections.mouseUp then self.connections.mouseUp:Disconnect() end
	if self.connections.touchUp then self.connections.touchUp:Disconnect() end
	if self.connections.movement then self.connections.movement:Disconnect() end
	self.connections.mouseUp = nil
	self.connections.touchUp = nil
	self.connections.movement = nil
end
function Slider:isMouseOverFrame(frame, position)
	local absPos, absSize = frame.AbsolutePosition, frame.AbsoluteSize
	return position.X >= absPos.X and position.X <= absPos.X + absSize.X and position.Y >= absPos.Y and position.Y <= absPos.Y + absSize.Y
end
function Slider:updatePosition(input)
	if not self.dragData.dragging then return end
	local mousePos = input.Position.X
	local barPos = self.sliderBar.AbsolutePosition.X
	local barWidth = self.sliderBar.AbsoluteSize.X
	if barWidth <= 0 then return end
	local newX = math.clamp(mousePos - barPos - 7, -7, barWidth - 7)
	if not self.dragData.lastValue or math.abs(newX - self.dragData.lastValue) > 0.5 then
		self.sliderHandle.Position = UDim2.new(0, newX, 0, -5)
		local normalizedValue = math.clamp((newX + 7) / barWidth, 0, 1)
		if self.onChange then self.onChange(normalizedValue) end
		self.dragData.lastValue = newX
	end
end
function Slider:onDragEnd() if self.dragData.dragging then self:resetState() end end
function Slider:resetState() self.dragData.dragging = false; self.dragData.currentTouch = nil; self.dragData.lastValue = nil; self:cleanupConnections() end
function Slider:onInputEnded(input)
	if not self.dragData.dragging then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then self:onDragEnd()
	elseif input.UserInputType == Enum.UserInputType.Touch and input == self.dragData.currentTouch then self:onDragEnd() end
end
function Slider:onMovement(input)
	if not self.dragData.dragging then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input == self.dragData.currentTouch then
		self:updatePosition(input)
	end
end
function Slider:onInputBegan(input)
	local isClick = input.UserInputState == Enum.UserInputState.Begin and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
	if isClick and not self.dragData.dragging and self:isMouseOverFrame(self.sliderHandle, input.Position) then
		self.dragData.dragging = true
		self.dragData.currentTouch = (input.UserInputType == Enum.UserInputType.Touch) and input or nil
		self:cleanupConnections()
		self.connections.mouseUp = UserInputService.InputEnded:Connect(function(endInput)
			if endInput.UserInputType == Enum.UserInputType.MouseButton1 then self:onInputEnded(endInput) end
		end)
		self.connections.touchUp = UserInputService.InputEnded:Connect(function(endInput)
			if endInput.UserInputType == Enum.UserInputType.Touch then self:onInputEnded(endInput) end
		end)
		self.connections.movement = UserInputService.InputChanged:Connect(function(moveInput)
			if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
				self:onMovement(moveInput)
			end
		end)
		self:updatePosition(input)
	end
end
function Slider:setup() self.connections.began = self.sliderHandle.InputBegan:Connect(function(input) self:onInputBegan(input) end) end
function Slider:Destroy() self:cleanupConnections(); if self.connections.began then self.connections.began:Disconnect() end end
function Slider:SetValue(normalizedValue) local barWidth = self.sliderBar.AbsoluteSize.X; local newX = math.clamp(normalizedValue * barWidth - 7, -7, barWidth - 7); self.sliderHandle.Position = UDim2.new(0, newX, 0, -5) end
local Toggle = {}
Toggle.__index = Toggle
function Toggle.new(toggleContainer, toggleThumb, onChange, Fluent)
	local self = setmetatable({}, Toggle)
	self.toggleContainer = toggleContainer
	self.toggleThumb = toggleThumb
	self.onChange = onChange
	self.Fluent = Fluent
	self.state = false
	self:setup()
	return self
end
function Toggle:animateOn()
	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local shine = self.Fluent and self.Fluent:GetShine()
	local accent = (shine and shine.Accent) or Color3.fromRGB(100, 200, 255)
	self.toggleContainer.BackgroundColor3 = accent
	TweenService:Create(self.toggleThumb, tweenInfo, {Position = UDim2.new(0, self.toggleContainer.AbsoluteSize.X - 22, 0, 2)}):Play()
end
function Toggle:animateOff()
	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	self.toggleContainer.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	TweenService:Create(self.toggleThumb, tweenInfo, {Position = UDim2.new(0, 2, 0, 2)}):Play()
end
function Toggle:SetState(state)
	self.state = state
	if state then self:animateOn() else self:animateOff() end
	if self.onChange then self.onChange(state) end
end
function Toggle:GetState() return self.state end
function Toggle:Toggle() self:SetState(not self.state) end
function Toggle:setup()
	self.toggleContainer.MouseButton1Click:Connect(function() self:Toggle() end)
end
local DummyUI = {}
DummyUI.__index = DummyUI

function DummyUI.new(title, size, Fluent)
	local self = setmetatable({}, DummyUI)
	self.title = title or "Freecam Control"
	self.size = size or UDim2.new(0, 300, 0, 380)
	self.position = UDim2.new(0.5, -150, 0.5, -200)
	self.Fluent = Fluent
	self.tabs = {}
	self.currentTab = nil
	self.components = {}
	self:createUI()
	self:setupDraggable()
	self:setupThemeReactivity()
	return self
end

function DummyUI:createUI()
	self.minimized = false
	self.expandedSize = self.size

	-- ── Layer 0: background frame (identik FloatingButton Frame) ──
	self.mainFrame = Instance.new("Frame")
	self.mainFrame.Name = "GoonWaresFreecamUI"
	self.mainFrame.Size = self.size
	self.mainFrame.Position = self.position
	self.mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.mainFrame.BackgroundTransparency = 0.85
	self.mainFrame.BorderSizePixel = 0
	self.mainFrame.ZIndex = -10
	self.mainFrame.ClipsDescendants = false
	self.mainFrame.Active = true
	self.mainFrame.Parent = freecamGui
	self.mainFrame.Visible = false
	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 12)
	mainCorner.Parent = self.mainFrame

	-- Gradient identik FloatingButton Gradient (color diupdate di RenderStepped)
	self.mainBgGradient = Instance.new("UIGradient")
	self.mainBgGradient.Rotation = 0
	self.mainBgGradient.Parent = self.mainFrame

	-- Stroke identik FloatingButton Stroke
	self.mainStroke = Instance.new("UIStroke")
	self.mainStroke.Thickness = 1.5
	self.mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	self.mainStroke.Color = Color3.new(1, 1, 1)
	self.mainStroke.Parent = self.mainFrame
	self.strokeGradient = Instance.new("UIGradient")
	self.strokeGradient.Rotation = 0
	self.strokeGradient.Parent = self.mainStroke

	-- Noise identik FloatingButton Noise (ZIndex negatif agar di belakang content)
	self.noiseLayer = Instance.new("ImageLabel")
	self.noiseLayer.Name = "_FCNoise"
	self.noiseLayer.Image = "rbxassetid://9968344227"
	self.noiseLayer.ScaleType = Enum.ScaleType.Tile
	self.noiseLayer.TileSize = UDim2.new(0, 128, 0, 128)
	self.noiseLayer.Size = UDim2.fromScale(1, 1)
	self.noiseLayer.BackgroundTransparency = 1
	self.noiseLayer.ImageTransparency = 0.92
	self.noiseLayer.ZIndex = -8
	self.noiseLayer.Parent = self.mainFrame
	local noiseCorner = Instance.new("UICorner")
	noiseCorner.CornerRadius = UDim.new(0, 12)
	noiseCorner.Parent = self.noiseLayer

	-- GlassLayer identik FloatingButton GlassLayer
	self.glassLayer = Instance.new("Frame")
	self.glassLayer.Name = "_FCGlass"
	self.glassLayer.Size = UDim2.fromScale(1, 1)
	self.glassLayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.glassLayer.BackgroundTransparency = 0.88
	self.glassLayer.BorderSizePixel = 0
	self.glassLayer.ZIndex = -9
	self.glassLayer.Parent = self.mainFrame
	local glassCorner = Instance.new("UICorner")
	glassCorner.CornerRadius = UDim.new(0, 12)
	glassCorner.Parent = self.glassLayer
	local glassGradient = Instance.new("UIGradient")
	glassGradient.Rotation = 90
	glassGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180)),
	})
	glassGradient.Parent = self.glassLayer

	-- ── Layer 1: content frame (clips content saja, transparan) ──
	self.contentFrame = Instance.new("Frame")
	self.contentFrame.Name = "GoonWaresFreecamContent"
	self.contentFrame.Size = self.size
	self.contentFrame.Position = self.position
	self.contentFrame.BackgroundTransparency = 1
	self.contentFrame.BorderSizePixel = 0
	self.contentFrame.ClipsDescendants = true
	self.contentFrame.Active = true
	self.contentFrame.ZIndex = 10
	self.contentFrame.Parent = freecamGui
	self.contentFrame.Visible = false
	local contentCorner = Instance.new("UICorner")
	contentCorner.CornerRadius = UDim.new(0, 12)
	contentCorner.Parent = self.contentFrame

	self.topBar = Instance.new("Frame")
	self.topBar.Name = "TopBar"
	self.topBar.Size = UDim2.new(1, 0, 0, 40)
	self.topBar.Position = UDim2.new(0, 0, 0, 0)
	self.topBar.BackgroundTransparency = 1
	self.topBar.ZIndex = 12
	self.topBar.Parent = self.contentFrame
	self.dragHandle = Instance.new("TextButton")
	self.dragHandle.Size = UDim2.new(1, -46, 1, 0)
	self.dragHandle.BackgroundTransparency = 1
	self.dragHandle.Text = ""
	self.dragHandle.AutoButtonColor = false
	self.dragHandle.ZIndex = 12
	self.dragHandle.Parent = self.topBar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -46, 1, 0)
	titleLabel.Position = UDim2.new(0, 14, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
	titleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
	titleLabel.TextSize = 14
	titleLabel.Text = self.title
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.ZIndex = 13
	titleLabel.Parent = self.topBar
	self.titleLabel = titleLabel

	local function createTitleBarButton(icon, xOffset)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 34, 1, -8)
		btn.AnchorPoint = Vector2.new(1, 0)
		btn.Position = UDim2.new(1, xOffset, 0, 4)
		btn.BackgroundTransparency = 1
		btn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
		btn.Text = ""
		btn.AutoButtonColor = false
		btn.ZIndex = 13
		btn.Parent = self.topBar
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 7)
		corner.Parent = btn
		local iconLabel = Instance.new("ImageLabel")
		iconLabel.Name = "Icon"
		iconLabel.Image = icon
		iconLabel.Size = UDim2.fromOffset(16, 16)
		iconLabel.Position = UDim2.fromScale(0.5, 0.5)
		iconLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		iconLabel.BackgroundTransparency = 1
		iconLabel.ImageColor3 = Color3.fromRGB(240, 240, 240)
		iconLabel.ZIndex = 14
		iconLabel.Parent = btn
		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.94}):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
		end)
		return btn, iconLabel
	end

	self.minButton, self.minIcon = createTitleBarButton("rbxassetid://9886659276", -4)
	self.minButton.MouseButton1Click:Connect(function()
		self:ToggleMinimize()
	end)

	self.bodyContainer = Instance.new("Frame")
	self.bodyContainer.Name = "Body"
	self.bodyContainer.Size = UDim2.new(1, 0, 1, -40)
	self.bodyContainer.Position = UDim2.new(0, 0, 0, 40)
	self.bodyContainer.BackgroundTransparency = 1
	self.bodyContainer.ClipsDescendants = true
	self.bodyContainer.ZIndex = 11
	self.bodyContainer.Parent = self.contentFrame

	self.tabScrollingFrame = Instance.new("ScrollingFrame")
	self.tabScrollingFrame.Size = UDim2.new(1, -20, 0, 34)
	self.tabScrollingFrame.Position = UDim2.new(0, 10, 0, 4)
	self.tabScrollingFrame.BackgroundTransparency = 1
	self.tabScrollingFrame.BorderSizePixel = 0
	self.tabScrollingFrame.ScrollBarThickness = 3
	self.tabScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	self.tabScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
	self.tabScrollingFrame.ZIndex = 12
	self.tabScrollingFrame.Parent = self.bodyContainer
	self.tabLayout = Instance.new("UIListLayout")
	self.tabLayout.FillDirection = Enum.FillDirection.Horizontal
	self.tabLayout.Padding = UDim.new(0, 8)
	self.tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	self.tabLayout.Parent = self.tabScrollingFrame
	self.tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		self.tabScrollingFrame.CanvasSize = UDim2.new(0, self.tabLayout.AbsoluteContentSize.X + 20, 0, 0)
	end)
end

function DummyUI:ToggleMinimize()
	self.minimized = not self.minimized
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	if self.minimized then
		self.expandedSize = self.mainFrame.Size
		self.minIcon.Image = "rbxassetid://9886659001"
		self.bodyContainer.Visible = false
		TweenService:Create(self.mainFrame, tweenInfo, {Size = UDim2.new(self.expandedSize.X.Scale, self.expandedSize.X.Offset, 0, 40)}):Play()
		TweenService:Create(self.contentFrame, tweenInfo, {Size = UDim2.new(self.expandedSize.X.Scale, self.expandedSize.X.Offset, 0, 40)}):Play()
	else
		self.minIcon.Image = "rbxassetid://9886659276"
		self.bodyContainer.Visible = true
		TweenService:Create(self.mainFrame, tweenInfo, {Size = self.expandedSize}):Play()
		TweenService:Create(self.contentFrame, tweenInfo, {Size = self.expandedSize}):Play()
	end
end

function DummyUI:setupThemeReactivity()
	local t = 0
	local conn = nil
	local lastAccent = nil

	conn = RunService.RenderStepped:Connect(function(dt)
		if not self.mainFrame or not self.mainFrame.Parent then
			conn:Disconnect()
			conn = nil
			return
		end
		local Fluent = self.Fluent
		if not Fluent then return end

		-- Sync contentFrame size/position/visible setiap frame
		self.contentFrame.Size = self.mainFrame.Size
		self.contentFrame.Position = self.mainFrame.Position
		self.contentFrame.Visible = self.mainFrame.Visible

		-- Transparansi identik FloatingButton StartFrameLoop
		local Transparent = Fluent.WindowTransparent
		self.mainFrame.BackgroundTransparency = Transparent and 0.27 or 0

		-- Gradient dari ButtonGradients, identik FloatingButton
		local Animated = Fluent.ShineEnabled == true
		local Grad = Fluent:GetButtonGradient() or Fluent.ButtonGradients

		if Animated then
			t += dt
			self.mainBgGradient.Rotation = (t * 30) % 360
			self.strokeGradient.Rotation = (t * 15) % 360
			self.mainBgGradient.Offset = Vector2.new(math.sin(t * 0.4) * 0.15, self.mainBgGradient.Offset.Y)
			local Pulse = (math.sin(t * 0.5 * math.pi) + 1) / 2
			self.mainStroke.Thickness = 1.25 + Pulse * 0.75
		else
			self.mainBgGradient.Rotation = 0
			self.strokeGradient.Rotation = 0
			self.mainBgGradient.Offset = Vector2.new(0, 0)
			self.mainStroke.Thickness = 1.5
			self.mainStroke.Color = Color3.new(1, 1, 1)
		end

		self.mainBgGradient.Color = Grad.Background
		self.strokeGradient.Color = Grad.Stroke

		-- Accent sync untuk tab, toggle, slider
		local shine = Fluent:GetShine()
		local accent = (shine and shine.Accent) or Color3.fromRGB(100, 200, 255)
		if accent ~= lastAccent then
			lastAccent = accent
			self.tabScrollingFrame.ScrollBarImageColor3 = accent
			for name, tab in pairs(self.tabs) do
				if name == self.currentTab then
					tab.button.BackgroundColor3 = accent
				end
			end
			for _, comp in ipairs(self.components) do
				if comp._isToggle and comp.state then
					comp.toggleContainer.BackgroundColor3 = accent
				end
				if comp._isSlider then
					if comp.fillRef and comp.fillRef.Parent then
						comp.fillRef.BackgroundColor3 = accent
					end
					if comp.valueLabelRef and comp.valueLabelRef.Parent then
						comp.valueLabelRef.TextColor3 = accent
					end
				end
			end
		end
	end)
end

function DummyUI:setupDraggable()
	self.draggable = Draggable.new(self.dragHandle, self.mainFrame)
end

function DummyUI:AddTab(tabName)
	local Fluent = self.Fluent
	local tabButton = Instance.new("TextButton")
	tabButton.Name = tabName .. "Tab"
	tabButton.Size = UDim2.new(0, 100, 0, 30)
	tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
	tabButton.TextColor3 = Color3.fromRGB(180, 180, 200)
	tabButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold)
	tabButton.TextSize = 13
	tabButton.Text = tabName
	tabButton.AutoButtonColor = false
	tabButton.BorderSizePixel = 0
	tabButton.ZIndex = 12
	tabButton.Parent = self.tabScrollingFrame
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 15)
	buttonCorner.Parent = tabButton

	local tabContent = Instance.new("ScrollingFrame")
	tabContent.Name = tabName .. "Content"
	tabContent.Size = UDim2.new(1, -20, 1, -50)
	tabContent.Position = UDim2.new(0, 10, 0, 44)
	tabContent.BackgroundTransparency = 1
	tabContent.BorderSizePixel = 0
	tabContent.ScrollBarThickness = 5
	tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabContent.Visible = false
	tabContent.ZIndex = 11
	tabContent.Parent = self.bodyContainer
	local tabLayout = Instance.new("UIListLayout")
	tabLayout.Padding = UDim.new(0, 10)
	tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabLayout.Parent = tabContent
	tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabContent.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 20)
	end)

	self.tabs[tabName] = { button = tabButton, content = tabContent, layout = tabLayout }
	if not self.currentTab then self:SwitchTab(tabName) end
	tabButton.MouseButton1Click:Connect(function() self:SwitchTab(tabName) end)
	return tabContent
end

function DummyUI:SwitchTab(tabName)
	if not self.tabs[tabName] then return end
	self.currentTab = tabName
	local Fluent = self.Fluent
	local shine = Fluent and Fluent:GetShine()
	local activeColor = (shine and shine.Accent) or Color3.fromRGB(100, 200, 255)
	for name, tab in pairs(self.tabs) do
		local isActive = (name == tabName)
		tab.button.BackgroundColor3 = isActive and activeColor or Color3.fromRGB(45, 45, 55)
		tab.button.TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 200)
		tab.content.Visible = isActive
		if isActive then self.activeTabButton = tab.button end
	end
end

function DummyUI:AddToggle(parent, config)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, -8, 0, 56)
	card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	card.BackgroundTransparency = 0.92
	card.BorderSizePixel = 0
	card.ZIndex = 11
	card.Parent = parent
	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 10)
	cardCorner.Parent = card

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -70, 1, 0)
	title.Position = UDim2.new(0, 12, 0, 0)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(230, 230, 230)
	title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold)
	title.TextSize = 13
	title.Text = config.text or "Toggle"
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 12
	title.Parent = card

	local toggleContainer = Instance.new("TextButton")
	toggleContainer.Size = UDim2.new(0, 44, 0, 24)
	toggleContainer.Position = UDim2.new(1, -56, 0.5, -12)
	toggleContainer.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	toggleContainer.BorderSizePixel = 0
	toggleContainer.ClipsDescendants = true
	toggleContainer.Text = ""
	toggleContainer.AutoButtonColor = false
	toggleContainer.ZIndex = 12
	toggleContainer.Parent = card
	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 12)
	toggleCorner.Parent = toggleContainer

	local toggleThumb = Instance.new("Frame")
	toggleThumb.Size = UDim2.new(0, 20, 0, 20)
	toggleThumb.Position = UDim2.new(0, 2, 0, 2)
	toggleThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	toggleThumb.BorderSizePixel = 0
	toggleThumb.ZIndex = 13
	toggleThumb.Parent = toggleContainer
	local thumbCorner = Instance.new("UICorner")
	thumbCorner.CornerRadius = UDim.new(0, 10)
	thumbCorner.Parent = toggleThumb

	local toggle = Toggle.new(toggleContainer, toggleThumb, config.callback, self.Fluent)
	toggle._isToggle = true
	toggle.toggleContainer = toggleContainer
	if config.default then toggle:SetState(config.default) end
	table.insert(self.components, toggle)
	return toggle
end

function DummyUI:AddSlider(parent, config)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, -8, 0, 66)
	card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	card.BackgroundTransparency = 0.92
	card.BorderSizePixel = 0
	card.ZIndex = 11
	card.Parent = parent
	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 10)
	cardCorner.Parent = card

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -70, 0, 22)
	title.Position = UDim2.new(0, 12, 0, 6)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(230, 230, 230)
	title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold)
	title.TextSize = 13
	title.Text = config.text or "Slider"
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 12
	title.Parent = card

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(0, 50, 0, 22)
	valueLabel.Position = UDim2.new(1, -62, 0, 6)
	valueLabel.BackgroundTransparency = 1
	valueLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
	valueLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
	valueLabel.TextSize = 13
	valueLabel.Text = tostring(config.default or 0)
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.ZIndex = 12
	valueLabel.Parent = card

	local sliderBar = Instance.new("Frame")
	sliderBar.Size = UDim2.new(1, -24, 0, 4)
	sliderBar.Position = UDim2.new(0, 12, 0, 42)
	sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	sliderBar.BorderSizePixel = 0
	sliderBar.ZIndex = 12
	sliderBar.Parent = card
	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0, 2)
	barCorner.Parent = sliderBar

	local min = config.min or 0
	local max = config.max or 100
	local defaultPercent = ((config.default or min) - min) / (max - min)

	local sliderFill = Instance.new("Frame")
	sliderFill.Size = UDim2.new(defaultPercent, 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
	sliderFill.BorderSizePixel = 0
	sliderFill.ZIndex = 12
	sliderFill.Parent = sliderBar
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 2)
	fillCorner.Parent = sliderFill

	local sliderHandle = Instance.new("TextButton")
	sliderHandle.Size = UDim2.new(0, 14, 0, 14)
	sliderHandle.Position = UDim2.new(0, -7, 0, -5)
	sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sliderHandle.Text = ""
	sliderHandle.AutoButtonColor = false
	sliderHandle.BorderSizePixel = 0
	sliderHandle.ZIndex = 13
	sliderHandle.Parent = sliderBar
	local handleCorner = Instance.new("UICorner")
	handleCorner.CornerRadius = UDim.new(0, 7)
	handleCorner.Parent = sliderHandle

	local function syncHandlePosition()
		local barWidth = sliderBar.AbsoluteSize.X
		if barWidth > 0 then
			sliderHandle.Position = UDim2.new(0, defaultPercent * barWidth - 7, 0, -5)
		end
	end
	sliderBar:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncHandlePosition)
	task.defer(syncHandlePosition)

	local slider = Slider.new(sliderBar, sliderHandle, function(normalized)
		local value = min + normalized * (max - min)
		valueLabel.Text = tostring(math.floor(value + 0.5))
		sliderFill.Size = UDim2.new(normalized, 0, 1, 0)
		if config.callback then config.callback(value) end
	end)
	slider._isSlider = true
	slider.fillRef = sliderFill
	slider.valueLabelRef = valueLabel
	table.insert(self.components, slider)
	return slider
end

function DummyUI:AddLabel(parent, text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -8, 0, 40)
	label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	label.BackgroundTransparency = 0.92
	label.TextColor3 = Color3.fromRGB(190, 190, 210)
	label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
	label.TextSize = 12
	label.Text = text
	label.TextWrapped = true
	label.ZIndex = 11
	label.Parent = parent
	local labelCorner = Instance.new("UICorner")
	labelCorner.CornerRadius = UDim.new(0, 10)
	labelCorner.Parent = label
	return label
end

function DummyUI:AddKeybind(parent, config)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, -8, 0, 86)
	card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	card.BackgroundTransparency = 0.92
	card.BorderSizePixel = 0
	card.ZIndex = 11
	card.Parent = parent
	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 10)
	cardCorner.Parent = card

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 22)
	title.Position = UDim2.new(0, 12, 0, 6)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(230, 230, 230)
	title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold)
	title.TextSize = 13
	title.Text = config.text or "Keybind"
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 12
	title.Parent = card

	local desc = Instance.new("TextLabel")
	desc.Size = UDim2.new(1, -24, 0, 18)
	desc.Position = UDim2.new(0, 12, 0, 28)
	desc.BackgroundTransparency = 1
	desc.TextColor3 = Color3.fromRGB(150, 150, 170)
	desc.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
	desc.TextSize = 10
	desc.Text = "Click, then press up to 3 keys"
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.ZIndex = 12
	desc.Parent = card

	local keybindButton = Instance.new("TextButton")
	keybindButton.Size = UDim2.new(1, -24, 0, 32)
	keybindButton.Position = UDim2.new(0, 12, 0, 48)
	keybindButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
	keybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	keybindButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
	keybindButton.TextSize = 13
	keybindButton.Text = table.concat(config.default or {"Shift", "P"}, "+")
	keybindButton.AutoButtonColor = false
	keybindButton.BorderSizePixel = 0
	keybindButton.ZIndex = 12
	keybindButton.Parent = card
	local keybindCorner = Instance.new("UICorner")
	keybindCorner.CornerRadius = UDim.new(0, 8)
	keybindCorner.Parent = keybindButton

	local selectedKeys = {}
	local isListening = false
	local activeConnection = nil
	local function getKeyName(keyCode)
		local name = keyCode.Name
		if name == "LeftControl" or name == "RightControl" then return "Ctrl"
		elseif name == "LeftAlt" or name == "RightAlt" then return "Alt"
		elseif name == "LeftShift" or name == "RightShift" then return "Shift"
		else return name end
	end
	local function updateDisplay()
		local names = {}
		for _, k in ipairs(selectedKeys) do table.insert(names, getKeyName(k)) end
		keybindButton.Text = (#names > 0 and table.concat(names, "+")) or "..."
		if config.onChange then config.onChange(selectedKeys) end
	end
	local function stopListening()
		isListening = false
		keybindButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
		updateDisplay()
		if activeConnection then
			activeConnection:Disconnect()
			activeConnection = nil
		end
	end
	local function startListening()
		isListening = true
		selectedKeys = {}
		keybindButton.Text = "Press keys..."
		keybindButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
		if activeConnection then activeConnection:Disconnect() end
		activeConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then return end
			if isListening and input.KeyCode ~= Enum.KeyCode.Unknown then
				if #selectedKeys < 3 and not table.find(selectedKeys, input.KeyCode) then
					table.insert(selectedKeys, input.KeyCode)
					updateDisplay()
				end
				task.delay(0.2, function()
					if isListening then stopListening() end
				end)
			end
		end)
	end
	if config.default then
		for _, keyName in ipairs(config.default) do
			for _, ek in pairs(Enum.KeyCode:GetEnumItems()) do
				if ek.Name == keyName then
					table.insert(selectedKeys, ek)
					break
				end
			end
		end
		updateDisplay()
	end
	keybindButton.MouseButton1Click:Connect(function()
		if isListening then
			stopListening()
		else
			startListening()
		end
	end)
	table.insert(self.components, {Destroy = function() if activeConnection then activeConnection:Disconnect() end end})
	return {GetKeys = function() return selectedKeys end}
end

function DummyUI:Destroy()
	if self.draggable then self.draggable:Destroy() end
	for _, component in ipairs(self.components) do
		if component.Destroy then component:Destroy() end
	end
	if self.mainFrame then self.mainFrame:Destroy() end
end

local ui = DummyUI.new("Freecam Control", UDim2.new(0, 300, 0, 380), Fluent)
uiMainFrame = ui.mainFrame
local uiContentFrame = ui.contentFrame
local homeTab = ui:AddTab("Home")
local freecamToggle = ui:AddToggle(homeTab, { text = "Freecam Enabled", callback = function(state) if state then StartFreecam() else StopFreecam() end end, default = false })
ui:AddSlider(homeTab, { text = "Movement Speed", min = 0.25, max = 4, default = 1, callback = function(val) MobileNavSpeed = val end })
ui:AddSlider(homeTab, { text = "Mouse Sensitivity", min = 0.2, max = 3, default = 1, callback = function(val) MouseSensitivity = val end })
ui:AddSlider(homeTab, { text = "Touch Look Sensitivity", min = 0.2, max = 3, default = 1, callback = function(val) TouchLookSensitivity = val end })
ui:AddSlider(homeTab, { text = "FOV Sensitivity", min = 0.2, max = 3, default = 1, callback = function(val) FovSensitivity = val end })
ui:AddSlider(homeTab, { text = "Movement Smoothing", min = 0.1, max = 5, default = 1.5, callback = function(val) VelStiffness = val; VelSpring:SetFreq(val) end })
ui:AddSlider(homeTab, { text = "Look Smoothing", min = 0.1, max = 5, default = 1, callback = function(val) PanStiffness = val; PanSpring:SetFreq(val) end })
ui:AddSlider(homeTab, { text = "FOV Smoothing", min = 0.1, max = 5, default = 4, callback = function(val) FovStiffness = val; FovSpring:SetFreq(val) end })
ui:AddSlider(homeTab, { text = "Roll Smoothing", min = 0.1, max = 5, default = 1, callback = function(val) RollStiffness = val; RollSpring:SetFreq(val) end })
ui:AddSlider(homeTab, { text = "Tilt Speed", min = 0.2, max = 3, default = 1, callback = function(val) rollSpeed = val end })
ui:AddLabel(homeTab, "Controls:\nWASD / Thumbstick - Move\nMouse/Right Touch - Look\nQ/E - Up/Down\nZ/C - Tilt (Keyboard)\nTilt Buttons (Bottom Left)\nShift - Slow mode")
local keybindTab = ui:AddTab("Keybind")
local customToggleKeys = {"LeftShift", "P"}
local customDoFKeys = {"BackSlash"}
local customHideGuiKeys = {"G"}
local customHidePlayerGuiKeys = {"X"}
local customLeaderboardKeys = {"L"}
local customTiltResetKeys = {"Z", "C"}
local customTiltLeftKeys = {"Z"}
local customTiltRightKeys = {"C"}
local function rebuildToggleFreecamKeybind()
	ContextActionService:UnbindAction("FreecamToggle")
	if #customToggleKeys >= 1 then
		local macroKeys = {}
		for i, keyName in ipairs(customToggleKeys) do
			for _, ek in pairs(Enum.KeyCode:GetEnumItems()) do
				if ek.Name == keyName then macroKeys[i] = ek; break end
			end
		end
		if #macroKeys > 0 then
			local lastKey = macroKeys[#macroKeys]
			ContextActionService:BindActionAtPriority("FreecamToggle", function(action, state, input)
				if state == Enum.UserInputState.Begin and input.KeyCode == lastKey then
					local allDown = true
					for i = 1, #macroKeys - 1 do
						if not UserInputService:IsKeyDown(macroKeys[i]) then allDown = false; break end
					end
					if allDown then ToggleFreecam() end
				end
				return Enum.ContextActionResult.Pass
			end, false, ToggleInputPriority, lastKey)
		end
	end
end
local function rebuildDoFKeybind()
	ContextActionService:UnbindAction("FreecamKeyboardDoFToggle")
	if #customDoFKeys >= 1 then
		local macroKeys = {}
		for i, keyName in ipairs(customDoFKeys) do
			for _, ek in pairs(Enum.KeyCode:GetEnumItems()) do
				if ek.Name == keyName then macroKeys[i] = ek; break end
			end
		end
		if #macroKeys > 0 then
			local lastKey = macroKeys[#macroKeys]
			ContextActionService:BindActionAtPriority("FreecamKeyboardDoFToggle", function(action, state, input)
				if state == Enum.UserInputState.Begin and input.KeyCode == lastKey then
					local allDown = true
					for i = 1, #macroKeys - 1 do
						if not UserInputService:IsKeyDown(macroKeys[i]) then allDown = false; break end
					end
					if allDown and FreecamDepthOfField then
						FreecamDepthOfField.Enabled = not FreecamDepthOfField.Enabled
					end
				end
				return Enum.ContextActionResult.Pass
			end, false, InputPriority, lastKey)
		end
	end
end
local function rebuildHideGuiKeybind()
	ContextActionService:UnbindAction("FreecamKeyboardCustomGuiToggle")
	if #customHideGuiKeys >= 1 then
		local macroKeys = {}
		for i, keyName in ipairs(customHideGuiKeys) do
			for _, ek in pairs(Enum.KeyCode:GetEnumItems()) do
				if ek.Name == keyName then macroKeys[i] = ek; break end
			end
		end
		if #macroKeys > 0 then
			local lastKey = macroKeys[#macroKeys]
			ContextActionService:BindActionAtPriority("FreecamKeyboardCustomGuiToggle", function(action, state, input)
				if state == Enum.UserInputState.Begin and input.KeyCode == lastKey then
					local allDown = true
					for i = 1, #macroKeys - 1 do
						if not UserInputService:IsKeyDown(macroKeys[i]) then allDown = false; break end
					end
					if allDown and freecamGui and freecamGui.Parent then
						freecamGui.Enabled = not freecamGui.Enabled
					end
				end
				return Enum.ContextActionResult.Pass
			end, false, InputPriority, lastKey)
		end
	end
end
local function rebuildHidePlayerGuiKeybind()
	ContextActionService:UnbindAction("FreecamKeyboardPlayerGuiToggle")
	if #customHidePlayerGuiKeys >= 1 then
		local macroKeys = {}
		for i, keyName in ipairs(customHidePlayerGuiKeys) do
			for _, ek in pairs(Enum.KeyCode:GetEnumItems()) do
				if ek.Name == keyName then macroKeys[i] = ek; break end
			end
		end
		if #macroKeys > 0 then
			local lastKey = macroKeys[#macroKeys]
			ContextActionService:BindActionAtPriority("FreecamKeyboardPlayerGuiToggle", function(action, state, input)
				if state == Enum.UserInputState.Begin and input.KeyCode == lastKey then
					local allDown = true
					for i = 1, #macroKeys - 1 do
						if not UserInputService:IsKeyDown(macroKeys[i]) then allDown = false; break end
					end
					if allDown then
						ScreenGuisEnabled = not ScreenGuisEnabled
						local screenGuis = PlayerState.getScreenGuis()
						for _, gui in pairs(screenGuis) do
							if gui.Parent and gui ~= freecamGui then
								gui.Enabled = ScreenGuisEnabled
							end
						end
					end
				end
				return Enum.ContextActionResult.Pass
			end, false, InputPriority, lastKey)
		end
	end
end
local function rebuildLeaderboardKeybind()
	ContextActionService:UnbindAction("FreecamKeyboardLeaderboardToggle")
	if #customLeaderboardKeys >= 1 then
		local macroKeys = {}
		for i, keyName in ipairs(customLeaderboardKeys) do
			for _, ek in pairs(Enum.KeyCode:GetEnumItems()) do
				if ek.Name == keyName then macroKeys[i] = ek; break end
			end
		end
		if #macroKeys > 0 then
			local lastKey = macroKeys[#macroKeys]
			ContextActionService:BindActionAtPriority("FreecamKeyboardLeaderboardToggle", function(action, state, input)
				if state == Enum.UserInputState.Begin and input.KeyCode == lastKey then
					local allDown = true
					for i = 1, #macroKeys - 1 do
						if not UserInputService:IsKeyDown(macroKeys[i]) then allDown = false; break end
					end
					if allDown then
						LeaderboardEnabled = not LeaderboardEnabled
						StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, LeaderboardEnabled)
					end
				end
				return Enum.ContextActionResult.Pass
			end, false, InputPriority, lastKey)
		end
	end
end
local function rebuildTiltResetKeybind()
	ContextActionService:UnbindAction("FreecamKeyboardTiltReset")
	if #customTiltResetKeys >= 1 then
		local macroKeys = {}
		for i, keyName in ipairs(customTiltResetKeys) do
			for _, ek in pairs(Enum.KeyCode:GetEnumItems()) do
				if ek.Name == keyName then macroKeys[i] = ek; break end
			end
		end
		if #macroKeys > 0 then
			local lastKey = macroKeys[#macroKeys]
			ContextActionService:BindActionAtPriority("FreecamKeyboardTiltReset", function(action, state, input)
				if state == Enum.UserInputState.Begin and input.KeyCode == lastKey then
					local allDown = true
					for i = 1, #macroKeys - 1 do
						if not UserInputService:IsKeyDown(macroKeys[i]) then allDown = false; break end
					end
					if allDown then
						CameraRot = Vector3.new(CameraRot.x, CameraRot.y, 0)
						RollSpring:Reset(0)
					end
				end
				return Enum.ContextActionResult.Pass
			end, false, InputPriority, lastKey)
		end
	end
end
ui:AddKeybind(keybindTab, { text = "Toggle Freecam", default = customToggleKeys, onChange = function(keys)
	customToggleKeys = {}; for _, k in ipairs(keys) do table.insert(customToggleKeys, k.Name) end
	if #customToggleKeys == 0 then customToggleKeys = {"LeftShift", "P"} end
	rebuildToggleFreecamKeybind()
end })
ui:AddKeybind(keybindTab, { text = "Tilt Left", default = customTiltLeftKeys, onChange = function(keys)
	customTiltLeftKeys = {}; for _, k in ipairs(keys) do table.insert(customTiltLeftKeys, k.Name) end
	if #customTiltLeftKeys == 0 then customTiltLeftKeys = {"Z"} end
end })
ui:AddKeybind(keybindTab, { text = "Tilt Right", default = customTiltRightKeys, onChange = function(keys)
	customTiltRightKeys = {}; for _, k in ipairs(keys) do table.insert(customTiltRightKeys, k.Name) end
	if #customTiltRightKeys == 0 then customTiltRightKeys = {"C"} end
end })
ui:AddKeybind(keybindTab, { text = "Depth of Field Toggle", default = customDoFKeys, onChange = function(keys)
	customDoFKeys = {}; for _, k in ipairs(keys) do table.insert(customDoFKeys, k.Name) end
	if #customDoFKeys == 0 then customDoFKeys = {"BackSlash"} end
	rebuildDoFKeybind()
end })
ui:AddKeybind(keybindTab, { text = "Hide Freecam UI", default = customHideGuiKeys, onChange = function(keys)
	customHideGuiKeys = {}; for _, k in ipairs(keys) do table.insert(customHideGuiKeys, k.Name) end
	if #customHideGuiKeys == 0 then customHideGuiKeys = {"G"} end
	rebuildHideGuiKeybind()
end })
ui:AddKeybind(keybindTab, { text = "Hide Player GUI", default = customHidePlayerGuiKeys, onChange = function(keys)
	customHidePlayerGuiKeys = {}; for _, k in ipairs(keys) do table.insert(customHidePlayerGuiKeys, k.Name) end
	if #customHidePlayerGuiKeys == 0 then customHidePlayerGuiKeys = {"X"} end
	rebuildHidePlayerGuiKeybind()
end })
ui:AddKeybind(keybindTab, { text = "Toggle Leaderboard", default = customLeaderboardKeys, onChange = function(keys)
	customLeaderboardKeys = {}; for _, k in ipairs(keys) do table.insert(customLeaderboardKeys, k.Name) end
	if #customLeaderboardKeys == 0 then customLeaderboardKeys = {"L"} end
	rebuildLeaderboardKeybind()
end })
ui:AddKeybind(keybindTab, { text = "Tilt Reset", default = customTiltResetKeys, onChange = function(keys)
	customTiltResetKeys = {}; for _, k in ipairs(keys) do table.insert(customTiltResetKeys, k.Name) end
	if #customTiltResetKeys == 0 then customTiltResetKeys = {"Z", "C"} end
	rebuildTiltResetKeybind()
end })
ui:AddLabel(keybindTab, "Click any keybind button to record\na new key combination (max 3 keys)")
rebuildToggleFreecamKeybind()
rebuildDoFKeybind()
rebuildHideGuiKeybind()
rebuildHidePlayerGuiKeybind()
rebuildLeaderboardKeybind()
rebuildTiltResetKeybind()
function StartFreecam()
	if not FFlagUserFreecamGuiDestabilization then
		if FFlagUserShowGuiHideToggles then script:SetAttribute(FreecamEnabledAttributeName, true) end
	end
	local cameraCFrame = FreecamCamera.CFrame
	if FFlagUserFreecamTiltControl then
		CameraRot = Vector3.new(cameraCFrame:toEulerAnglesYXZ())
	else
		CameraRot = Vector2.new(cameraCFrame:toEulerAnglesYXZ())
	end
	CameraPos = cameraCFrame.p
	CameraFov = FreecamCamera.FieldOfView
	VelSpring:Reset(Vector3.new())
	PanSpring:Reset(Vector2.new())
	FovSpring:Reset(0)
	if FFlagUserFreecamTiltControl then RollSpring:Reset(0) end
	if FFlagUserFreecamCustomGui then
		if not touchGui then
			touchGui = CreateTouchControls()
		end
	end
	PlayerState.Push()
	if FFlagUserFreecamDepthOfFieldEffect then
		if not FreecamDepthOfField or not FreecamDepthOfField.Parent then
			FreecamDepthOfField = Instance.new("DepthOfFieldEffect")
			FreecamDepthOfField.Enabled = false
			FreecamDepthOfField.Name = "FreecamDepthOfField"
			FreecamDepthOfField.Parent = FreecamCamera
		end
	end
	RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
	Input.StartCapture()
end
function DestroyAllUI()
	if touchGui then touchGui:Destroy() touchGui = nil end
	if customGui then customGui:Destroy() customGui = nil end
end
function StopFreecam()
	if not FFlagUserFreecamGuiDestabilization then
		if FFlagUserShowGuiHideToggles then script:SetAttribute(FreecamEnabledAttributeName, false) end
	end
	if FFlagUserFreecamDepthOfFieldEffect then
		if FreecamDepthOfField and FreecamDepthOfField.Parent then
			if FreecamDepthOfField.Enabled then
				for _, effect in ipairs(PostEffects) do if effect.Parent then effect.Enabled = true end end
				if CameraConnection then CameraConnection:Disconnect() CameraConnection = nil end
				if LightingConnection then LightingConnection:Disconnect() LightingConnection = nil end
				PostEffects = {}
			end
			FreecamDepthOfField.Enabled = false
		end
	end
	if FFlagUserFreecamCustomGui then
		DestroyAllUI()
		ScreenGuisEnabled = false
		LeaderboardEnabled = false
	end
	Input.StopCapture()
	pcall(function() RunService:UnbindFromRenderStep("Freecam") end)
	PlayerState.Pop()
end
do
	local enabled = false
	function ToggleFreecam()
		if enabled then StopFreecam() else StartFreecam() end
		enabled = not enabled
		if FFlagUserFreecamGuiDestabilization then script:SetAttribute(FreecamEnabledAttributeName, enabled) end
		if freecamToggle and freecamToggle.SetState then
			freecamToggle:SetState(enabled)
		end
	end
	if FFlagUserFreecamGuiDestabilization or FFlagUserShowGuiHideToggles then
		script:SetAttribute(FreecamEnabledAttributeName, enabled)
		script:GetAttributeChangedSignal(FreecamEnabledAttributeName):Connect(function()
			local attributeValue = script:GetAttribute(FreecamEnabledAttributeName)
			if typeof(attributeValue) ~= "boolean" then
				script:SetAttribute(FreecamEnabledAttributeName, enabled)
				return
			end
			if attributeValue ~= enabled then
				if attributeValue then StartFreecam() enabled = true else StopFreecam() enabled = false end
				if freecamToggle and freecamToggle.SetState then
					freecamToggle:SetState(enabled)
				end
			end
		end)
	end
end

	local function SetFreecamGuiVisible(state)
		freecamGui.Enabled = state
		if state and uiMainFrame then
			uiMainFrame.Visible = true
			if uiContentFrame then uiContentFrame.Visible = true end
		end
	end

	return {
		ui = ui,
		freecamGui = freecamGui,
		ToggleFreecam = ToggleFreecam,
		SetFreecamGuiVisible = SetFreecamGuiVisible,
	}
end

return FreecamModule