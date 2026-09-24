local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")

local Locale = getgenv and getgenv().VortexLocale or _G.VortexLocale
if not Locale then
	error("Vortex: locale module not loaded, run vortex_locale.lua first")
end

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera

while not Camera do
	task.wait()
	Camera = Workspace.CurrentCamera
end

for _, name in ipairs({"VortexAuth", "VortexOverlay", "VortexMenu"}) do
	local old = PlayerGui:FindFirstChild(name)
	if old then
		old:Destroy()
	end
end

local KeyConfig = {
	DefaultKey = "vortex",
	AllowedUsers = {},
	MaxAttempts = 5,
	LockSeconds = 30,
}

local ThemeKeys = {"Background", "Secondary", "Row", "Border", "Text", "SubText", "Muted", "Accent"}

local Themes = {
	Obsidian = {
		Background = Color3.fromRGB(9, 9, 12),
		Secondary = Color3.fromRGB(14, 14, 18),
		Row = Color3.fromRGB(22, 22, 28),
		Border = Color3.fromRGB(42, 42, 52),
		Text = Color3.fromRGB(238, 238, 244),
		SubText = Color3.fromRGB(150, 150, 164),
		Muted = Color3.fromRGB(92, 92, 106),
		Accent = Color3.fromRGB(150, 110, 255),
	},
	Crimson = {
		Background = Color3.fromRGB(11, 8, 9),
		Secondary = Color3.fromRGB(17, 12, 13),
		Row = Color3.fromRGB(26, 19, 21),
		Border = Color3.fromRGB(52, 38, 41),
		Text = Color3.fromRGB(244, 238, 239),
		SubText = Color3.fromRGB(164, 150, 152),
		Muted = Color3.fromRGB(106, 92, 94),
		Accent = Color3.fromRGB(255, 82, 96),
	},
	Ocean = {
		Background = Color3.fromRGB(7, 11, 15),
		Secondary = Color3.fromRGB(11, 17, 23),
		Row = Color3.fromRGB(17, 25, 33),
		Border = Color3.fromRGB(34, 48, 62),
		Text = Color3.fromRGB(232, 240, 246),
		SubText = Color3.fromRGB(140, 156, 170),
		Muted = Color3.fromRGB(84, 100, 114),
		Accent = Color3.fromRGB(70, 190, 255),
	},
	Mono = {
		Background = Color3.fromRGB(10, 10, 10),
		Secondary = Color3.fromRGB(16, 16, 16),
		Row = Color3.fromRGB(24, 24, 24),
		Border = Color3.fromRGB(46, 46, 46),
		Text = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(154, 154, 154),
		Muted = Color3.fromRGB(96, 96, 96),
		Accent = Color3.fromRGB(230, 230, 230),
	},
	Custom = {
		Background = Color3.fromRGB(9, 9, 12),
		Secondary = Color3.fromRGB(14, 14, 18),
		Row = Color3.fromRGB(22, 22, 28),
		Border = Color3.fromRGB(42, 42, 52),
		Text = Color3.fromRGB(238, 238, 244),
		SubText = Color3.fromRGB(150, 150, 164),
		Muted = Color3.fromRGB(92, 92, 106),
		Accent = Color3.fromRGB(150, 110, 255),
	},
}

local ThemeNames = {"Obsidian", "Crimson", "Ocean", "Mono", "Custom"}
local AccentNames = {"Theme", "Violet", "Cyan", "Rose", "Emerald", "Amber", "White"}
local AccentColors = {
	Violet = Color3.fromRGB(150, 110, 255),
	Cyan = Color3.fromRGB(70, 210, 255),
	Rose = Color3.fromRGB(255, 96, 150),
	Emerald = Color3.fromRGB(70, 225, 140),
	Amber = Color3.fromRGB(255, 190, 70),
	White = Color3.fromRGB(240, 240, 240),
}

local Prefs = {Theme = "Obsidian", Accent = "Theme"}
local Theme = {}
local Bound = {}
local Refreshers = {}

local function Tween(object, properties, duration, style, direction)
	local tween = TweenService:Create(
		object,
		TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out),
		properties
	)
	tween:Play()
	return tween
end

local function ApplyTheme()
	for key, value in pairs(Themes[Prefs.Theme]) do
		Theme[key] = value
	end
	local override = AccentColors[Prefs.Accent]
	if override then
		Theme.Accent = override
	end
	for index = #Bound, 1, -1 do
		local entry = Bound[index]
		if entry[1].Parent == nil then
			table.remove(Bound, index)
		else
			Tween(entry[1], {[entry[2]] = Theme[entry[3]]}, 0.3)
		end
	end
	for _, refresh in ipairs(Refreshers) do
		refresh()
	end
end

ApplyTheme()

local function New(className, parent, properties)
	local object = Instance.new(className)
	for property, value in pairs(properties or {}) do
		if type(value) == "string" and string.find(property, "Color") and string.sub(value, 1, 1) == "@" then
			local key = string.sub(value, 2)
			table.insert(Bound, {object, property, key})
			object[property] = Theme[key]
		else
			object[property] = value
		end
	end
	object.Parent = parent
	return object
end

local function Round(object, radius)
	local full = radius >= 100
	return New("UICorner", object, {CornerRadius = UDim.new(full and 1 or 0, full and 0 or radius)})
end

local function GlowStroke(parent)
	local stroke = New("UIStroke", parent, {
		Thickness = 1.5,
		Color = Color3.new(1, 1, 1),
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
	local gradient = New("UIGradient", stroke, {})
	local function Paint()
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Theme.Accent),
			ColorSequenceKeypoint.new(0.5, Theme.Border),
			ColorSequenceKeypoint.new(1, Theme.Accent),
		})
	end
	Paint()
	table.insert(Refreshers, Paint)
	local spin = TweenService:Create(
		gradient,
		TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
		{Rotation = 360}
	)
	spin:Play()
	return spin
end

local function ResolveAccess(name)
	local hasEntries = false
	local lowered = string.lower(name)
	for key, value in pairs(KeyConfig.AllowedUsers) do
		hasEntries = true
		if type(key) == "number" then
			if string.lower(tostring(value)) == lowered then
				return true, nil
			end
		elseif string.lower(key) == lowered then
			if type(value) == "string" and value ~= "" then
				return true, value
			end
			return true, nil
		end
	end
	return not hasEntries, nil
end

local function Authorize(input)
	local allowed, personal = ResolveAccess(LocalPlayer.Name)
	if not allowed then
		return false, "This account is not authorized"
	end
	if input == (personal or KeyConfig.DefaultKey) then
		return true
	end
	return false, "Invalid key"
end

local CONFIG_FOLDER = "VortexCheats"

local function EnsureFolder()
	local ok = pcall(function()
		if not isfolder(CONFIG_FOLDER) then
			makefolder(CONFIG_FOLDER)
		end
	end)
	return ok
end

local function SanitizeFileName(name)
	name = string.gsub(name, "[^%w%-%_ ]", "")
	name = string.match(name, "^%s*(.-)%s*$")
	if name == "" then
		return nil
	end
	return name
end

local function ListConfigs()
	local names = {}
	pcall(function()
		if isfolder(CONFIG_FOLDER) then
			for _, path in ipairs(listfiles(CONFIG_FOLDER)) do
				local fileName = string.match(path, "([^\\/]+)%.cfg$")
				if fileName then
					table.insert(names, fileName)
				end
			end
		end
	end)
	table.sort(names)
	return names
end

local function LaunchHub()
	local S = {
		AimbotEnabled = false,
		AimHold = true,
		AimTeamCheck = true,
		VisibleCheck = true,
		AimPart = "Head",
		AimSpeed = 14,
		FOVRadius = 150,
		MaxAimDistance = 1500,
		PredictionEnabled = false,
		PredictionTime = 0.12,
		ShowFOV = true,
		ShowTargetLine = false,

		TriggerEnabled = false,
		TriggerTeamCheck = true,
		TriggerWallCheck = true,
		TriggerFOV = 5,
		TriggerHitbox = true,
		TriggerPart = "Any",
		TriggerMaxDistance = 1000,
		TriggerDelay = 0.05,
		TriggerInterval = 0.1,
		TriggerHumanize = true,
		TriggerOnlyAim = false,
		ShowTriggerFOV = true,
		TriggerClickMode = "Auto",

		ESPEnabled = false,
		ESPTeamCheck = true,
		ShowBoxes = true,
		ShowNames = true,
		ShowDistance = true,
		ShowHealth = true,
		ShowSkeleton = true,
		ShowHeadDot = false,
		ShowWeapon = false,
		ShowOffscreen = false,
		ChamsEnabled = false,
		ESPColor = "Red",
		ESPMaxDistance = 3000,
		ShowTracers = false,
		TracerOrigin = "Bottom",
		CornerBoxEnabled = false,

		SpeedEnabled = false,
		SpeedValue = 32,
		JumpEnabled = false,
		JumpValue = 80,
		FlyEnabled = false,
		FlySpeed = 70,
		NoclipEnabled = false,
		InfJumpEnabled = false,

		FullBrightEnabled = false,
		NoShadowsEnabled = false,
		CustomFOVEnabled = false,
		CameraFOV = 90,
		ZoomEnabled = false,
		ZoomFOV = 25,
		FreecamEnabled = false,
		FreecamSpeed = 60,
		ZoomLimitEnabled = false,
		ZoomLimit = 120,
		HUDEnabled = false,
		ExposureEnabled = false,
		Exposure = 0,
		HideCloudsEnabled = false,
		GravityEnabled = false,
		GravityValue = 196,

		SnowEnabled = false,
		SnowIntensity = 40,
		RainEnabled = false,
		RainIntensity = 40,
		WindStrength = 4,
		FogEnabled = false,
		FogDensity = 200,
		FogColorName = "Theme",
		LightningEnabled = false,
		LightningInterval = 8,

		AtmosphereEnabled = false,
		AtmoDensity = 0.35,
		AtmoHaze = 2,
		AtmoColorName = "Theme",
		SunRaysEnabled = false,
		SunRaysIntensity = 0.25,
		SunRaysSpread = 0.6,
		RainbowEnabled = false,
		RainbowSpeed = 0.2,

		TimeOfDayEnabled = false,
		TimeOfDay = 14,
		TimeFlowEnabled = false,
		TimeFlowSpeed = 0.3,

		GlowEnabled = false,
		GlowIntensity = 0.4,
		ColorGradeEnabled = false,
		ColorSaturation = 0,
		ColorTintName = "None",
		VisionMode = "Off",
		DOFEnabled = false,
		DOFFocus = 60,
		DOFFar = 0.4,
		DOFRadius = 40,
		BlurEnabled = false,
		BlurSize = 8,
		VignetteEnabled = false,
		VignetteIntensity = 0.5,

		CrosshairEnabled = false,
		CrosshairSize = 8,
		CrosshairGap = 4,
		CrosshairThickness = 2,
		CrosshairDot = true,
		CrosshairColorName = "Theme",
		CrosshairSpin = false,
		CrosshairDynamic = true,
		CrosshairReactive = true,

		HitMarkerEnabled = false,
		HitSoundEnabled = false,

		WorldPreset = "None",

		UIScale = 1,
		UIOpacity = 0,
	}

	local Defaults = {}
	for key, value in pairs(S) do
		Defaults[key] = value
	end

	local K = {
		Menu = Enum.KeyCode.RightShift,
		AimbotEnabled = Enum.KeyCode.Q,
		TriggerEnabled = Enum.KeyCode.T,
		ESPEnabled = Enum.KeyCode.F2,
		FlyEnabled = Enum.KeyCode.F,
		SpeedEnabled = Enum.KeyCode.V,
		NoclipEnabled = Enum.KeyCode.Unknown,
		FreecamEnabled = Enum.KeyCode.P,
		HUDEnabled = Enum.KeyCode.H,
		Zoom = Enum.KeyCode.C,
	}

	local BindNameKeys = {
		AimbotEnabled = "OPT_AIMBOT",
		TriggerEnabled = "OPT_TRIGGERBOT",
		ESPEnabled = "OPT_ESP",
		FlyEnabled = "OPT_FLY",
		SpeedEnabled = "OPT_SPEED",
		NoclipEnabled = "OPT_NOCLIP",
		FreecamEnabled = "OPT_FREECAM",
		HUDEnabled = "OPT_HUD",
	}

	local BindOrder = {
		"AimbotEnabled",
		"TriggerEnabled",
		"ESPEnabled",
		"FlyEnabled",
		"SpeedEnabled",
		"NoclipEnabled",
		"FreecamEnabled",
		"HUDEnabled",
	}

	local ESPColors = {
		Red = Color3.fromRGB(255, 70, 80),
		Cyan = Color3.fromRGB(70, 220, 255),
		Green = Color3.fromRGB(90, 235, 130),
		Yellow = Color3.fromRGB(255, 220, 80),
		Pink = Color3.fromRGB(255, 110, 200),
		White = Color3.fromRGB(245, 245, 245),
	}
	local ESPColorNames = {"Red", "Cyan", "Green", "Yellow", "Pink", "White"}
	local CrosshairColorNames = {"Theme", "Red", "Cyan", "Green", "Yellow", "Pink", "White"}
	local TracerOriginNames = {"Bottom", "Top", "Center"}
	local WorldTintColors = {
		None = Color3.fromRGB(255, 255, 255),
		Blue = Color3.fromRGB(120, 170, 255),
		Orange = Color3.fromRGB(255, 170, 110),
		Green = Color3.fromRGB(140, 255, 170),
		Purple = Color3.fromRGB(190, 140, 255),
		Sepia = Color3.fromRGB(255, 210, 150),
	}
	local WorldTintNames = {"None", "Blue", "Orange", "Green", "Purple", "Sepia"}
	local FogColorNames = {"Theme", "Blue", "Orange", "Green", "Purple", "Sepia"}
	local LanguageCodes = {"EN", "RU", "UA"}

	local VisionPresets = {
		["Night Vision"] = {Saturation = -0.3, Contrast = 0.15, Brightness = 0.12, Tint = Color3.fromRGB(130, 255, 150)},
		Noir = {Saturation = -1, Contrast = 0.25, Brightness = 0, Tint = Color3.fromRGB(255, 255, 255)},
		Vintage = {Saturation = -0.35, Contrast = 0.1, Brightness = 0.02, Tint = Color3.fromRGB(255, 225, 180)},
		Neon = {Saturation = 0.9, Contrast = 0.25, Brightness = 0, Tint = Color3.fromRGB(255, 210, 255)},
	}
	local VisionNames = {"Off", "Night Vision", "Noir", "Vintage", "Neon"}

	local WorldKeys = {
		"SnowEnabled", "SnowIntensity", "RainEnabled", "RainIntensity", "WindStrength",
		"FogEnabled", "FogDensity", "FogColorName", "LightningEnabled", "LightningInterval",
		"AtmosphereEnabled", "AtmoDensity", "AtmoHaze", "AtmoColorName",
		"SunRaysEnabled", "SunRaysIntensity", "SunRaysSpread", "RainbowEnabled", "RainbowSpeed",
		"TimeOfDayEnabled", "TimeOfDay", "TimeFlowEnabled", "TimeFlowSpeed",
		"GlowEnabled", "GlowIntensity", "ColorGradeEnabled", "ColorSaturation", "ColorTintName",
		"VisionMode", "DOFEnabled", "DOFFocus", "DOFFar", "DOFRadius", "BlurEnabled", "BlurSize",
		"VignetteEnabled", "VignetteIntensity", "ExposureEnabled", "Exposure", "HideCloudsEnabled",
	}

	local Presets = {
		Thunderstorm = {
			RainEnabled = true, RainIntensity = 150, WindStrength = 10,
			FogEnabled = true, FogDensity = 350, FogColorName = "Blue",
			LightningEnabled = true, LightningInterval = 7,
			TimeOfDayEnabled = true, TimeOfDay = 20,
			VignetteEnabled = true, VignetteIntensity = 0.6,
			ColorGradeEnabled = true, ColorSaturation = -0.25, ColorTintName = "Blue",
			HideCloudsEnabled = false,
		},
		Blizzard = {
			SnowEnabled = true, SnowIntensity = 140, WindStrength = 18,
			FogEnabled = true, FogDensity = 180, FogColorName = "Blue",
			ColorGradeEnabled = true, ColorSaturation = -0.35, ColorTintName = "Blue",
			VignetteEnabled = true, VignetteIntensity = 0.4,
		},
		["Golden Hour"] = {
			TimeOfDayEnabled = true, TimeOfDay = 17.4,
			SunRaysEnabled = true, SunRaysIntensity = 0.35,
			GlowEnabled = true, GlowIntensity = 0.5,
			ColorGradeEnabled = true, ColorSaturation = 0.2, ColorTintName = "Orange",
			AtmosphereEnabled = true, AtmoDensity = 0.3, AtmoHaze = 1.5, AtmoColorName = "Orange",
		},
		["Cyber Night"] = {
			TimeOfDayEnabled = true, TimeOfDay = 0.5,
			GlowEnabled = true, GlowIntensity = 0.8,
			VisionMode = "Neon",
			RainbowEnabled = true, RainbowSpeed = 0.15,
			VignetteEnabled = true, VignetteIntensity = 0.5,
			AtmosphereEnabled = true, AtmoDensity = 0.4, AtmoHaze = 3, AtmoColorName = "Purple",
		},
		["Foggy Dawn"] = {
			TimeOfDayEnabled = true, TimeOfDay = 6.2,
			FogEnabled = true, FogDensity = 260, FogColorName = "Sepia",
			AtmosphereEnabled = true, AtmoDensity = 0.5, AtmoHaze = 4, AtmoColorName = "Sepia",
			SunRaysEnabled = true, SunRaysIntensity = 0.3,
			DOFEnabled = true, DOFFar = 0.25,
		},
	}
	local PresetNames = {"None", "Clear", "Thunderstorm", "Blizzard", "Golden Hour", "Cyber Night", "Foggy Dawn"}

	local R15Bones = {
		{"Head", "UpperTorso"},
		{"UpperTorso", "LowerTorso"},
		{"UpperTorso", "LeftUpperArm"},
		{"LeftUpperArm", "LeftLowerArm"},
		{"LeftLowerArm", "LeftHand"},
		{"UpperTorso", "RightUpperArm"},
		{"RightUpperArm", "RightLowerArm"},
		{"RightLowerArm", "RightHand"},
		{"LowerTorso", "LeftUpperLeg"},
		{"LeftUpperLeg", "LeftLowerLeg"},
		{"LeftLowerLeg", "LeftFoot"},
		{"LowerTorso", "RightUpperLeg"},
		{"RightUpperLeg", "RightLowerLeg"},
		{"RightLowerLeg", "RightFoot"},
	}

	local R6Bones = {
		{"Head", "Torso"},
		{"Torso", "Left Arm"},
		{"Torso", "Right Arm"},
		{"Torso", "Left Leg"},
		{"Torso", "Right Leg"},
	}

	local R15Names = {
		"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftLowerArm",
		"RightLowerArm", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg",
	}
	local R6Names = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

	local Conns = {}
	local Unloaded = false
	local Sync = {}
	local Hooks = {}
	local Listening = nil
	local Entries = {}
	local MenuState = {Open = true, Dragging = false}
	local SessionStart = os.clock()

	local function Connect(signal, callback)
		local connection = signal:Connect(callback)
		table.insert(Conns, connection)
		return connection
	end

	local function SetValue(key, value)
		S[key] = value
		if Sync[key] then
			Sync[key](value)
		end
		if Hooks[key] then
			Hooks[key](value)
		end
	end

	local function KeyName(code)
		if code == Enum.KeyCode.Unknown then
			return "NONE"
		end
		return code.Name
	end

	local function TintColor(name)
		if name == "Theme" then
			return Theme.Accent
		end
		return WorldTintColors[name] or Color3.fromRGB(255, 255, 255)
	end

	local Overlay = New("ScreenGui", PlayerGui, {
		Name = "VortexOverlay",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 5,
	})

	local MenuGui = New("ScreenGui", PlayerGui, {
		Name = "VortexMenu",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 10,
	})

	local Toasts = New("Frame", Overlay, {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -16, 1, -16),
		Size = UDim2.fromOffset(240, 300),
		BackgroundTransparency = 1,
	})

	New("UIListLayout", Toasts, {
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
	})

	local function Notify(text)
		local toast = New("CanvasGroup", Toasts, {
			Size = UDim2.fromOffset(230, 34),
			BackgroundColor3 = "@Secondary",
			BorderSizePixel = 0,
			GroupTransparency = 1,
		})
		Round(toast, 8)
		New("UIStroke", toast, {Color = "@Border", Thickness = 1})
		New("Frame", toast, {
			Size = UDim2.fromOffset(3, 18),
			Position = UDim2.fromOffset(8, 8),
			BackgroundColor3 = "@Accent",
			BorderSizePixel = 0,
		})
		New("TextLabel", toast, {
			Position = UDim2.fromOffset(20, 0),
			Size = UDim2.new(1, -28, 1, 0),
			BackgroundTransparency = 1,
			Text = text,
			TextColor3 = "@Text",
			Font = Enum.Font.GothamMedium,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		Tween(toast, {GroupTransparency = 0}, 0.25)
		task.delay(2.2, function()
			if toast.Parent then
				Tween(toast, {GroupTransparency = 1}, 0.3)
				task.delay(0.35, function()
					toast:Destroy()
				end)
			end
		end)
	end

	local Combat = {LastFire = 0}
	local Aim = {}
	local Trigger = {Last = 0, Interval = 0.1}
	local Fly = {Active = false}
	local Noclip = {Parts = {}, Character = nil, BaseParts = {}, Next = 0}
	local Applied = {Speed = false, Jump = false}
	local World = {NextFlash = 0}
	local Hud = {Accum = 0, Frames = 0}
	local Freecam = {Active = false, Yaw = 0, Pitch = 0, Position = Vector3.zero}

	local AimParams = RaycastParams.new()
	AimParams.FilterType = Enum.RaycastFilterType.Exclude
	AimParams.IgnoreWater = true
	AimParams.RespectCanCollide = true

	local TriggerParams = RaycastParams.new()
	TriggerParams.FilterType = Enum.RaycastFilterType.Exclude
	TriggerParams.IgnoreWater = true
	TriggerParams.RespectCanCollide = true

	function Freecam.Start()
		Freecam.Active = true
		local cframe = Camera.CFrame
		local pitch, yaw = cframe:ToOrientation()
		Freecam.Pitch = pitch
		Freecam.Yaw = yaw
		Freecam.Position = cframe.Position
		Freecam.PreviousType = Camera.CameraType
		Freecam.PreviousMouse = UserInputService.MouseBehavior
		Camera.CameraType = Enum.CameraType.Scriptable
		ContextActionService:BindActionAtPriority("VortexFreecamSink", function()
			return Enum.ContextActionResult.Sink
		end, false, Enum.ContextActionPriority.High.Value,
			Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
			Enum.KeyCode.Space, Enum.KeyCode.LeftControl, Enum.KeyCode.LeftShift)
	end

	function Freecam.Stop()
		if not Freecam.Active then
			return
		end
		Freecam.Active = false
		ContextActionService:UnbindAction("VortexFreecamSink")
		UserInputService.MouseBehavior = Freecam.PreviousMouse or Enum.MouseBehavior.Default
		Camera.CameraType = Freecam.PreviousType or Enum.CameraType.Custom
	end

	function Freecam.Update(dt)
		if not S.FreecamEnabled then
			if Freecam.Active then
				Freecam.Stop()
			end
			return
		end
		if not Freecam.Active then
			Freecam.Start()
		end
		if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
			UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
			local delta = UserInputService:GetMouseDelta()
			Freecam.Yaw -= delta.X * 0.0035
			Freecam.Pitch = math.clamp(Freecam.Pitch - delta.Y * 0.0035, -1.55, 1.55)
		else
			UserInputService.MouseBehavior = Freecam.PreviousMouse or Enum.MouseBehavior.Default
		end
		local rotation = CFrame.fromOrientation(Freecam.Pitch, Freecam.Yaw, 0)
		local direction = Vector3.zero
		if not UserInputService:GetFocusedTextBox() then
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				direction += rotation.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				direction -= rotation.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				direction += rotation.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				direction -= rotation.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				direction += Vector3.yAxis
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
				direction -= Vector3.yAxis
			end
		end
		local speed = S.FreecamSpeed
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
			speed *= 3
		end
		if direction.Magnitude > 0 then
			direction = direction.Unit
		end
		Freecam.Position += direction * speed * dt
		Camera.CFrame = CFrame.new(Freecam.Position) * rotation
	end

	local function IsEnemy(player, teamCheck)
		if player == LocalPlayer then
			return false
		end
		if teamCheck and player.Team ~= nil and player.Team == LocalPlayer.Team then
			return false
		end
		return true
	end

	local function PartOf(entry, name)
		local part = entry.Parts[name]
		if part and part.Parent == entry.Character then
			return part
		end
		part = entry.Character and entry.Character:FindFirstChild(name) or nil
		entry.Parts[name] = part
		return part
	end

	local function IsVisible(part, character, params)
		local origin = Camera.CFrame.Position
		local result = Workspace:Raycast(origin, part.Position - origin, params)
		return result == nil or result.Instance:IsDescendantOf(character)
	end

	local function GetAimPart(entry)
		if S.AimPart == "Head" then
			return PartOf(entry, "Head") or entry.Root
		elseif S.AimPart == "Chest" then
			return PartOf(entry, "UpperTorso") or PartOf(entry, "Torso") or entry.Root
		end
		return entry.Root
	end

	local function Predict(part)
		if S.PredictionEnabled then
			return part.Position + part.AssemblyLinearVelocity * S.PredictionTime
		end
		return part.Position
	end

	local function FindTarget()
		local bestPart, bestPosition, bestPlayer
		local bestDistance = math.huge
		local viewport = Camera.ViewportSize
		local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
		local cameraPosition = Camera.CFrame.Position
		local localCharacter = LocalPlayer.Character
		AimParams.FilterDescendantsInstances = localCharacter and {localCharacter} or {}
		for _, player in ipairs(Players:GetPlayers()) do
			if IsEnemy(player, S.AimTeamCheck) then
				local entry = Entries[player]
				if entry and entry.Refresh() then
					local part = GetAimPart(entry)
					local position = Predict(part)
					if (position - cameraPosition).Magnitude <= S.MaxAimDistance then
						local screen, onScreen = Camera:WorldToViewportPoint(position)
						if onScreen then
							local distance = (Vector2.new(screen.X, screen.Y) - center).Magnitude
							if distance <= S.FOVRadius and distance < bestDistance then
								if not S.VisibleCheck or IsVisible(part, entry.Character, AimParams) then
									bestDistance = distance
									bestPart = part
									bestPosition = position
									bestPlayer = player
								end
							end
						end
					end
				end
			end
		end
		return bestPart, bestPosition, bestPlayer
	end

	function Aim.Update(dt)
		Aim.Part = nil
		Aim.Position = nil
		Aim.Player = nil
		if not S.AimbotEnabled or Freecam.Active then
			return
		end
		local part, position, player = FindTarget()
		Aim.Part = part
		Aim.Position = position
		Aim.Player = player
		if not part then
			return
		end
		if S.AimHold and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
			return
		end
		local current = Camera.CFrame
		if (position - current.Position).Magnitude < 0.01 then
			return
		end
		local goal = CFrame.lookAt(current.Position, position)
		Camera.CFrame = current:Lerp(goal, 1 - math.exp(-S.AimSpeed * dt))
	end

	local TriggerScratch = {}

	local function CollectTriggerParts(entry)
		table.clear(TriggerScratch)
		local isR15 = entry.Humanoid.RigType == Enum.HumanoidRigType.R15
		if S.TriggerPart == "Head" then
			local head = PartOf(entry, "Head")
			if head then
				table.insert(TriggerScratch, head)
			end
		elseif S.TriggerPart == "Body" then
			local torso = PartOf(entry, isR15 and "UpperTorso" or "Torso")
			if torso then
				table.insert(TriggerScratch, torso)
			end
			if entry.Root ~= torso then
				table.insert(TriggerScratch, entry.Root)
			end
		else
			for _, name in ipairs(isR15 and R15Names or R6Names) do
				local part = PartOf(entry, name)
				if part then
					table.insert(TriggerScratch, part)
				end
			end
		end
		return TriggerScratch
	end

	local function FireTrigger()
		if S.TriggerClickMode ~= "Tool" and not Trigger.NoMouse and not MenuState.Open then
			local ok = pcall(function()
				local manager = game:GetService("VirtualInputManager")
				local mouse = UserInputService:GetMouseLocation()
				manager:SendMouseButtonEvent(mouse.X, mouse.Y, 0, true, game, 0)
				manager:SendMouseButtonEvent(mouse.X, mouse.Y, 0, false, game, 0)
			end)
			if ok then
				return true
			end
			Trigger.NoMouse = true
			Notify("Mouse API unavailable, using Tool click")
		end
		local character = LocalPlayer.Character
		local tool = character and character:FindFirstChildOfClass("Tool")
		if tool and tool.Enabled then
			tool:Activate()
			return true
		end
		return false
	end

	function Trigger.Update()
		Trigger.Player = nil
		if not S.TriggerEnabled or Freecam.Active then
			Trigger.EnterTime = nil
			return
		end
		if S.TriggerOnlyAim and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
			Trigger.EnterTime = nil
			return
		end
		local viewport = Camera.ViewportSize
		local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
		local pixelsPerStud = viewport.Y / (2 * math.tan(math.rad(Camera.FieldOfView) / 2))
		local localCharacter = LocalPlayer.Character
		TriggerParams.FilterDescendantsInstances = localCharacter and {localCharacter} or {}
		local bestPlayer
		local bestDistance = math.huge
		for _, player in ipairs(Players:GetPlayers()) do
			if IsEnemy(player, S.TriggerTeamCheck) then
				local entry = Entries[player]
				if entry and entry.Refresh() then
					for _, part in ipairs(CollectTriggerParts(entry)) do
						local screen = Camera:WorldToViewportPoint(part.Position)
						if screen.Z > 0 and screen.Z <= S.TriggerMaxDistance then
							local reach = S.TriggerFOV
							if S.TriggerHitbox then
								reach += math.max(part.Size.X, part.Size.Y) * 0.5 * pixelsPerStud / screen.Z
							end
							local distance = (Vector2.new(screen.X, screen.Y) - center).Magnitude
							if distance <= reach and distance < bestDistance then
								if not S.TriggerWallCheck or IsVisible(part, entry.Character, TriggerParams) then
									bestDistance = distance
									bestPlayer = player
								end
							end
						end
					end
				end
			end
		end
		if not bestPlayer then
			Trigger.EnterTime = nil
			return
		end
		Trigger.Player = bestPlayer
		local now = os.clock()
		if not Trigger.EnterTime then
			Trigger.EnterTime = now
		end
		if now - Trigger.EnterTime < S.TriggerDelay then
			return
		end
		if now - Trigger.Last < Trigger.Interval then
			return
		end
		if FireTrigger() then
			Trigger.Last = now
			Combat.LastFire = now
			Trigger.Interval = S.TriggerInterval * (S.TriggerHumanize and (1 + math.random() * 0.4) or 1)
		end
	end

	local function DrawLine(frame, a, b, color, thickness)
		local delta = b - a
		frame.Position = UDim2.fromOffset((a.X + b.X) / 2, (a.Y + b.Y) / 2)
		frame.Size = UDim2.fromOffset(delta.Magnitude, thickness or 1.5)
		frame.Rotation = math.deg(math.atan2(delta.Y, delta.X))
		frame.BackgroundColor3 = color
		frame.Visible = true
	end

	local function NewEntry(player)
		local folder = New("Folder", Overlay, {Name = "ESP_" .. player.UserId})
		local entry = {
			Folder = folder,
			Shown = false,
			Bones = {},
			Parts = {},
			Character = nil,
			Humanoid = nil,
			Root = nil,
			Tool = nil,
			ChamColor = nil,
			LastHealth = nil,
		}
		entry.Box = New("Frame", folder, {BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false, ZIndex = 2})
		entry.BoxStroke = New("UIStroke", entry.Box, {Thickness = 1.5, Color = Color3.new(1, 1, 1)})
		entry.NameLabel = New("TextLabel", folder, {
			AnchorPoint = Vector2.new(0.5, 1),
			Size = UDim2.fromOffset(200, 14),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextColor3 = Color3.new(1, 1, 1),
			TextStrokeTransparency = 0.35,
			Visible = false,
			ZIndex = 3,
		})
		entry.Info = New("TextLabel", folder, {
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.fromOffset(200, 28),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamMedium,
			TextSize = 11,
			TextColor3 = Color3.fromRGB(220, 220, 228),
			TextStrokeTransparency = 0.45,
			TextYAlignment = Enum.TextYAlignment.Top,
			Visible = false,
			ZIndex = 3,
		})
		entry.HealthBack = New("Frame", folder, {
			BackgroundColor3 = Color3.fromRGB(10, 10, 10),
			BackgroundTransparency = 0.3,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 2,
		})
		entry.HealthFill = New("Frame", entry.HealthBack, {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.fromScale(1, 1),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(90, 235, 130),
			ZIndex = 3,
		})
		entry.Dot = New("Frame", folder, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(6, 6),
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 4,
		})
		Round(entry.Dot, 100)
		entry.Arrow = New("Frame", folder, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(12, 12),
			Rotation = 45,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 4,
		})
		entry.Tracer = New("Frame", folder, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 1,
		})
		for _ = 1, 14 do
			table.insert(entry.Bones, New("Frame", folder, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BorderSizePixel = 0,
				Visible = false,
				ZIndex = 2,
			}))
		end
		function entry.Refresh()
			local character = player.Character
			local humanoid = entry.Humanoid
			local root = entry.Root
			if entry.Character ~= character or not humanoid or not root or humanoid.Parent ~= character or root.Parent ~= character then
				table.clear(entry.Parts)
				entry.Character = character
				entry.Humanoid = nil
				entry.Root = nil
				entry.Tool = nil
				entry.ChamColor = nil
				if not character then
					return false
				end
				humanoid = character:FindFirstChildOfClass("Humanoid")
				root = humanoid and (humanoid.RootPart or character:FindFirstChild("HumanoidRootPart"))
				if not humanoid or not root then
					return false
				end
				entry.Humanoid = humanoid
				entry.Root = root
			end
			return humanoid.Health > 0
		end
		Entries[player] = entry
	end

	local function RemoveEntry(player)
		local entry = Entries[player]
		if not entry then
			return
		end
		if entry.Cham then
			entry.Cham:Destroy()
		end
		entry.Folder:Destroy()
		Entries[player] = nil
	end

	local function HideEntry(entry)
		if not entry.Shown then
			return
		end
		entry.Shown = false
		entry.Box.Visible = false
		entry.NameLabel.Visible = false
		entry.Info.Visible = false
		entry.HealthBack.Visible = false
		entry.Dot.Visible = false
		entry.Arrow.Visible = false
		entry.Tracer.Visible = false
		for _, bone in ipairs(entry.Bones) do
			bone.Visible = false
		end
	end

	local function UpdateEntry(player, entry)
		if not S.ESPEnabled or not IsEnemy(player, S.ESPTeamCheck) then
			HideEntry(entry)
			return
		end
		if not entry.Refresh() then
			HideEntry(entry)
			return
		end
		local character, humanoid, root = entry.Character, entry.Humanoid, entry.Root
		local distance = (root.Position - Camera.CFrame.Position).Magnitude
		if distance > S.ESPMaxDistance then
			HideEntry(entry)
			return
		end
		local color = ESPColors[S.ESPColor] or ESPColors.Red
		if Aim.Player == player then
			color = Theme.Accent
		end
		local rootScreen, onScreen = Camera:WorldToViewportPoint(root.Position)
		if not onScreen then
			HideEntry(entry)
			if S.ShowOffscreen then
				local viewport = Camera.ViewportSize
				local relative = Camera.CFrame:PointToObjectSpace(root.Position)
				local direction = Vector2.new(relative.X, -relative.Y)
				if direction.Magnitude < 0.0001 then
					direction = Vector2.new(0, -1)
				else
					direction = direction.Unit
				end
				local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
				local point = center + direction * (math.min(viewport.X, viewport.Y) / 2 * 0.85)
				entry.Arrow.Position = UDim2.fromOffset(point.X, point.Y)
				entry.Arrow.BackgroundColor3 = color
				entry.Arrow.Visible = true
				entry.Shown = true
			end
			return
		end
		entry.Shown = true
		local head = PartOf(entry, "Head")
		local feet = 3
		if humanoid.RigType == Enum.HumanoidRigType.R15 then
			feet = humanoid.HipHeight + root.Size.Y / 2
		end
		local topWorld = (head and head.Position or root.Position) + Vector3.new(0, 0.75, 0)
		local top = Camera:WorldToViewportPoint(topWorld)
		local bottom = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, feet, 0))
		local topY = math.min(top.Y, bottom.Y)
		local height = math.max(math.abs(bottom.Y - top.Y), 10)
		local width = height * 0.55
		local x = rootScreen.X

		if S.ShowBoxes then
			entry.Box.Position = UDim2.fromOffset(x - width / 2, topY)
			entry.Box.Size = UDim2.fromOffset(width, height)
			entry.BoxStroke.Color = color
			entry.BoxStroke.Thickness = S.CornerBoxEnabled and 0 or 1.5
			entry.Box.Visible = true
			if S.CornerBoxEnabled then
				if not entry.Corners then
					entry.Corners = {}
					for _ = 1, 8 do
						table.insert(entry.Corners, New("Frame", entry.Box, {
							BorderSizePixel = 0,
							ZIndex = 2,
						}))
					end
				end
				local length = math.clamp(height * 0.18, 6, 18)
				local thick = 2
				local w, h = width, height
				local segments = {
					{0, 0, length, thick},
					{0, 0, thick, length},
					{w - length, 0, length, thick},
					{w - thick, 0, thick, length},
					{0, h - thick, length, thick},
					{0, h - length, thick, length},
					{w - length, h - thick, length, thick},
					{w - thick, h - length, thick, length},
				}
				for index, seg in ipairs(segments) do
					local frame = entry.Corners[index]
					frame.Position = UDim2.fromOffset(seg[1], seg[2])
					frame.Size = UDim2.fromOffset(seg[3], seg[4])
					frame.BackgroundColor3 = color
					frame.Visible = true
				end
			elseif entry.Corners then
				for _, frame in ipairs(entry.Corners) do
					frame.Visible = false
				end
			end
		else
			entry.Box.Visible = false
		end

		if S.ShowTracers then
			local viewport = Camera.ViewportSize
			local originPoint
			if S.TracerOrigin == "Top" then
				originPoint = Vector2.new(viewport.X / 2, 0)
			elseif S.TracerOrigin == "Center" then
				originPoint = Vector2.new(viewport.X / 2, viewport.Y / 2)
			else
				originPoint = Vector2.new(viewport.X / 2, viewport.Y)
			end
			DrawLine(entry.Tracer, originPoint, Vector2.new(x, topY + height), color, 1)
		else
			entry.Tracer.Visible = false
		end

		if S.ShowNames then
			entry.NameLabel.Position = UDim2.fromOffset(x, topY - 3)
			entry.NameLabel.Text = player.Name
			entry.NameLabel.Visible = true
		else
			entry.NameLabel.Visible = false
		end

		local lines = {}
		if S.ShowDistance then
			table.insert(lines, math.floor(distance) .. " m")
		end
		if S.ShowWeapon then
			local tool = entry.Tool
			if tool == nil or tool.Parent ~= character then
				tool = character:FindFirstChildOfClass("Tool")
				entry.Tool = tool
			end
			table.insert(lines, tool and tool.Name or "None")
		end
		if #lines > 0 then
			entry.Info.Position = UDim2.fromOffset(x, topY + height + 2)
			entry.Info.Text = table.concat(lines, "\n")
			entry.Info.Visible = true
		else
			entry.Info.Visible = false
		end

		if S.ShowHealth then
			local maxHealth = humanoid.MaxHealth > 0 and humanoid.MaxHealth or 100
			local percent = math.clamp(humanoid.Health / maxHealth, 0, 1)
			entry.HealthBack.Position = UDim2.fromOffset(x - width / 2 - 6, topY)
			entry.HealthBack.Size = UDim2.fromOffset(3, height)
			entry.HealthFill.Size = UDim2.fromScale(1, percent)
			entry.HealthFill.BackgroundColor3 = Color3.fromHSV(percent * 0.33, 0.85, 1)
			entry.HealthBack.Visible = true
		else
			entry.HealthBack.Visible = false
		end

		if S.ShowHeadDot and head then
			local headScreen, headOn = Camera:WorldToViewportPoint(head.Position)
			if headOn then
				entry.Dot.Position = UDim2.fromOffset(headScreen.X, headScreen.Y)
				entry.Dot.BackgroundColor3 = color
				entry.Dot.Visible = true
			else
				entry.Dot.Visible = false
			end
		else
			entry.Dot.Visible = false
		end

		if S.ShowSkeleton then
			local bones = humanoid.RigType == Enum.HumanoidRigType.R15 and R15Bones or R6Bones
			for index, line in ipairs(entry.Bones) do
				local visible = false
				local pair = bones[index]
				if pair then
					local a = PartOf(entry, pair[1])
					local b = PartOf(entry, pair[2])
					if a and b then
						local pa = Camera:WorldToViewportPoint(a.Position)
						local pb = Camera:WorldToViewportPoint(b.Position)
						if pa.Z > 0 and pb.Z > 0 then
							DrawLine(line, Vector2.new(pa.X, pa.Y), Vector2.new(pb.X, pb.Y), color, 1.5)
							visible = true
						end
					end
				end
				line.Visible = visible
			end
		else
			for _, line in ipairs(entry.Bones) do
				line.Visible = false
			end
		end

		entry.Arrow.Visible = false
	end

	local function UpdateCham(player, entry)
		local character = player.Character
		local wanted = S.ChamsEnabled and character ~= nil and IsEnemy(player, S.ESPTeamCheck)
		if wanted then
			if not entry.Cham or entry.Cham.Parent ~= character then
				if entry.Cham then
					entry.Cham:Destroy()
				end
				entry.Cham = New("Highlight", character, {
					Name = "VortexCham",
					DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
					FillTransparency = 0.6,
					OutlineTransparency = 0,
				})
				entry.ChamColor = nil
			end
			local color = ESPColors[S.ESPColor] or ESPColors.Red
			if Aim.Player == player then
				color = Theme.Accent
			end
			if entry.ChamColor ~= color then
				entry.Cham.FillColor = color
				entry.Cham.OutlineColor = color
				entry.ChamColor = color
			end
		elseif entry.Cham then
			entry.Cham:Destroy()
			entry.Cham = nil
			entry.ChamColor = nil
		end
	end

	local CachedCharacter, CachedHumanoid
	local function GetHumanoid()
		local character = LocalPlayer.Character
		if not character then
			CachedCharacter = nil
			CachedHumanoid = nil
			return nil
		end
		if character ~= CachedCharacter or not CachedHumanoid or CachedHumanoid.Parent ~= character then
			CachedCharacter = character
			CachedHumanoid = character:FindFirstChildOfClass("Humanoid")
		end
		return CachedHumanoid
	end

	local function UpdateMovement()
		local humanoid = GetHumanoid()
		if not humanoid then
			Applied.Humanoid = nil
			Applied.Speed = false
			Applied.Jump = false
			return
		end
		if Applied.Humanoid ~= humanoid then
			Applied.Humanoid = humanoid
			Applied.Speed = false
			Applied.Jump = false
		end
		if S.SpeedEnabled then
			if not Applied.Speed then
				Applied.Speed = true
				Applied.WalkSpeed = humanoid.WalkSpeed
			end
			humanoid.WalkSpeed = S.SpeedValue
		elseif Applied.Speed then
			Applied.Speed = false
			humanoid.WalkSpeed = Applied.WalkSpeed
		end
		if S.JumpEnabled then
			if not Applied.Jump then
				Applied.Jump = true
				Applied.UseJumpPower = humanoid.UseJumpPower
				Applied.JumpPower = humanoid.JumpPower
			end
			humanoid.UseJumpPower = true
			humanoid.JumpPower = S.JumpValue
		elseif Applied.Jump then
			Applied.Jump = false
			humanoid.UseJumpPower = Applied.UseJumpPower
			humanoid.JumpPower = Applied.JumpPower
		end
	end

	function Fly.Stop()
		if Fly.Velocity then
			Fly.Velocity:Destroy()
			Fly.Velocity = nil
		end
		if Fly.Align then
			Fly.Align:Destroy()
			Fly.Align = nil
		end
		if Fly.Attach then
			Fly.Attach:Destroy()
			Fly.Attach = nil
		end
		if Fly.Active then
			Fly.Active = false
			local humanoid = GetHumanoid()
			if humanoid then
				humanoid.PlatformStand = false
			end
		end
	end

	function Fly.Update()
		if not S.FlyEnabled then
			if Fly.Active then
				Fly.Stop()
			end
			return
		end
		local humanoid = GetHumanoid()
		local root = humanoid and humanoid.RootPart
		if not root or humanoid.Health <= 0 then
			return
		end
		if not Fly.Attach or Fly.Attach.Parent ~= root then
			Fly.Stop()
			Fly.Attach = New("Attachment", root, {Name = "VortexFlyAttachment"})
			Fly.Velocity = New("LinearVelocity", root, {
				Attachment0 = Fly.Attach,
				MaxForce = 1e9,
				RelativeTo = Enum.ActuatorRelativeTo.World,
				VelocityConstraintMode = Enum.VelocityConstraintMode.Vector,
				VectorVelocity = Vector3.zero,
			})
			Fly.Align = New("AlignOrientation", root, {
				Attachment0 = Fly.Attach,
				Mode = Enum.OrientationAlignmentMode.OneAttachment,
				MaxTorque = 1e9,
				Responsiveness = 50,
			})
			Fly.Active = true
		end
		humanoid.PlatformStand = true
		local look = Camera.CFrame
		local direction = Vector3.zero
		if not UserInputService:GetFocusedTextBox() and not Freecam.Active then
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				direction += look.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				direction -= look.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				direction += look.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				direction -= look.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				direction += Vector3.yAxis
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
				direction -= Vector3.yAxis
			end
		end
		if direction.Magnitude > 0 then
			direction = direction.Unit
		end
		Fly.Velocity.VectorVelocity = direction * S.FlySpeed
		local flat = Vector3.new(look.LookVector.X, 0, look.LookVector.Z)
		if flat.Magnitude > 0.01 then
			Fly.Align.CFrame = CFrame.lookAt(root.Position, root.Position + flat)
		end
	end

	for _, child in ipairs(Lighting:GetChildren()) do
		if string.sub(child.Name, 1, 6) == "Vortex" then
			child:Destroy()
		end
	end

	local oldAnchor = Workspace:FindFirstChild("VortexWeatherAnchor")
	if oldAnchor then
		oldAnchor:Destroy()
	end

	local FX = {}
	FX.Grade = New("ColorCorrectionEffect", Lighting, {Name = "VortexGrade", Enabled = false})
	FX.Vision = New("ColorCorrectionEffect", Lighting, {Name = "VortexVision", Enabled = false})
	FX.Flash = New("ColorCorrectionEffect", Lighting, {Name = "VortexFlash", Enabled = false})
	FX.Bloom = New("BloomEffect", Lighting, {Name = "VortexBloom", Intensity = 0, Size = 24, Threshold = 0.8, Enabled = false})
	FX.Rays = New("SunRaysEffect", Lighting, {Name = "VortexRays", Intensity = 0, Spread = 0.5, Enabled = false})
	FX.Depth = New("DepthOfFieldEffect", Lighting, {
		Name = "VortexDepth",
		Enabled = false,
		FarIntensity = 0,
		NearIntensity = 0,
		FocusDistance = 50,
		InFocusRadius = 30,
	})
	FX.Blur = New("BlurEffect", Lighting, {Name = "VortexBlur", Size = 0, Enabled = false})

	local AtmosphereObject = Lighting:FindFirstChildOfClass("Atmosphere")
	local AtmosphereOwned = false
	if not AtmosphereObject then
		AtmosphereObject = New("Atmosphere", Lighting, {Name = "VortexAtmosphere", Density = 0, Offset = 0, Haze = 0, Glare = 0})
		AtmosphereOwned = true
	end
	World.AtmoOriginal = {
		Density = AtmosphereObject.Density,
		Offset = AtmosphereObject.Offset,
		Color = AtmosphereObject.Color,
		Decay = AtmosphereObject.Decay,
		Glare = AtmosphereObject.Glare,
		Haze = AtmosphereObject.Haze,
	}

	local Clouds = Workspace.Terrain:FindFirstChildOfClass("Clouds")

	local WeatherPart = New("Part", Workspace, {
		Name = "VortexWeatherAnchor",
		Size = Vector3.new(80, 1, 80),
		Transparency = 1,
		CanCollide = false,
		CanQuery = false,
		CanTouch = false,
		Anchored = true,
		Locked = true,
	})

	local SnowEmitter = New("ParticleEmitter", WeatherPart, {
		Name = "VortexSnow",
		Texture = "rbxasset://textures/particles/sparkles_main.dds",
		Color = ColorSequence.new(Color3.fromRGB(255, 255, 255)),
		Size = NumberSequence.new(0.35),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.1),
			NumberSequenceKeypoint.new(1, 0.5),
		}),
		Lifetime = NumberRange.new(5, 8),
		Speed = NumberRange.new(3, 6),
		EmissionDirection = Enum.NormalId.Bottom,
		SpreadAngle = Vector2.new(20, 20),
		Rotation = NumberRange.new(0, 360),
		RotSpeed = NumberRange.new(-40, 40),
		Acceleration = Vector3.new(4, -2, 0),
		LightEmission = 0.4,
		Rate = 0,
		Enabled = true,
	})

	local RainEmitter = New("ParticleEmitter", WeatherPart, {
		Name = "VortexRain",
		Color = ColorSequence.new(Color3.fromRGB(170, 200, 230)),
		Size = NumberSequence.new(0.35),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.3),
			NumberSequenceKeypoint.new(1, 0.5),
		}),
		Lifetime = NumberRange.new(0.6, 0.8),
		Speed = NumberRange.new(60, 80),
		EmissionDirection = Enum.NormalId.Bottom,
		SpreadAngle = Vector2.new(2, 2),
		Orientation = Enum.ParticleOrientation.VelocityParallel,
		Acceleration = Vector3.new(0, -30, 0),
		Rate = 0,
		Enabled = true,
	})

	local Vignette = {}
	for _, definition in ipairs({
		{UDim2.fromScale(0, 0), UDim2.new(1, 0, 0.3, 0), 90},
		{UDim2.fromScale(0, 0.7), UDim2.new(1, 0, 0.3, 0), -90},
		{UDim2.fromScale(0, 0), UDim2.new(0.25, 0, 1, 0), 0},
		{UDim2.fromScale(0.75, 0), UDim2.new(0.25, 0, 1, 0), 180},
	}) do
		local frame = New("Frame", Overlay, {
			Position = definition[1],
			Size = definition[2],
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 0,
		})
		New("UIGradient", frame, {
			Rotation = definition[3],
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(1, 1),
			}),
		})
		table.insert(Vignette, frame)
	end

	local function FlashLightning()
		task.spawn(function()
			for _, strength in ipairs({0.5, 0.25, 0.75}) do
				if Unloaded or not FX.Flash.Parent then
					return
				end
				FX.Flash.Brightness = strength
				Tween(FX.Flash, {Brightness = 0}, 0.18, Enum.EasingStyle.Quad)
				task.wait(0.1 + math.random() * 0.12)
			end
		end)
	end

	function World.Update(dt)
		if WeatherPart.Parent then
			WeatherPart.CFrame = CFrame.new(Camera.CFrame.Position + Vector3.new(0, 35, 0))
		end
		SnowEmitter.Rate = S.SnowEnabled and S.SnowIntensity * 3 or 0
		RainEmitter.Rate = S.RainEnabled and S.RainIntensity * 6 or 0
		SnowEmitter.Acceleration = Vector3.new(S.WindStrength, -2, S.WindStrength * 0.4)
		RainEmitter.Acceleration = Vector3.new(S.WindStrength * 2, -30, S.WindStrength * 0.6)

		if S.FogEnabled then
			if not World.FogSaved then
				World.FogSaved = true
				World.FogStart = Lighting.FogStart
				World.FogEnd = Lighting.FogEnd
				World.FogColor = Lighting.FogColor
			end
			Lighting.FogStart = 0
			Lighting.FogEnd = S.FogDensity
			Lighting.FogColor = TintColor(S.FogColorName)
		elseif World.FogSaved then
			World.FogSaved = false
			Lighting.FogStart = World.FogStart
			Lighting.FogEnd = World.FogEnd
			Lighting.FogColor = World.FogColor
		end

		FX.Flash.Enabled = S.LightningEnabled
		if S.LightningEnabled and os.clock() >= World.NextFlash then
			World.NextFlash = os.clock() + S.LightningInterval * (0.5 + math.random())
			FlashLightning()
		end

		FX.Bloom.Enabled = S.GlowEnabled
		FX.Bloom.Intensity = S.GlowIntensity * 3

		FX.Grade.Enabled = S.ColorGradeEnabled
		if S.ColorGradeEnabled then
			FX.Grade.Saturation = S.ColorSaturation
			FX.Grade.TintColor = WorldTintColors[S.ColorTintName] or Color3.fromRGB(255, 255, 255)
		end

		local vision = VisionPresets[S.VisionMode]
		FX.Vision.Enabled = vision ~= nil
		if vision then
			FX.Vision.Saturation = vision.Saturation
			FX.Vision.Contrast = vision.Contrast
			FX.Vision.Brightness = vision.Brightness
			FX.Vision.TintColor = vision.Tint
		end

		FX.Rays.Enabled = S.SunRaysEnabled
		FX.Rays.Intensity = S.SunRaysIntensity
		FX.Rays.Spread = S.SunRaysSpread

		FX.Depth.Enabled = S.DOFEnabled
		FX.Depth.FocusDistance = S.DOFFocus
		FX.Depth.FarIntensity = S.DOFFar
		FX.Depth.InFocusRadius = S.DOFRadius

		FX.Blur.Enabled = S.BlurEnabled
		FX.Blur.Size = S.BlurSize

		for _, frame in ipairs(Vignette) do
			frame.Visible = S.VignetteEnabled
			frame.BackgroundTransparency = 1 - S.VignetteIntensity
		end

		if S.AtmosphereEnabled then
			World.AtmoApplied = true
			local color = TintColor(S.AtmoColorName)
			AtmosphereObject.Density = S.AtmoDensity
			AtmosphereObject.Haze = S.AtmoHaze
			AtmosphereObject.Color = color
			AtmosphereObject.Decay = color
			AtmosphereObject.Glare = 0.3
			AtmosphereObject.Offset = 0.25
		elseif World.AtmoApplied then
			World.AtmoApplied = false
			for property, value in pairs(World.AtmoOriginal) do
				AtmosphereObject[property] = value
			end
		end

		if not S.FullBrightEnabled and (S.TimeOfDayEnabled or S.TimeFlowEnabled) then
			if not World.ClockSaved then
				World.ClockSaved = true
				World.SavedClock = Lighting.ClockTime
			end
			if S.TimeFlowEnabled then
				World.Flow = ((World.Flow or (S.TimeOfDayEnabled and S.TimeOfDay or Lighting.ClockTime)) + S.TimeFlowSpeed * dt) % 24
				Lighting.ClockTime = World.Flow
			else
				World.Flow = nil
				Lighting.ClockTime = S.TimeOfDay
			end
		elseif World.ClockSaved and not S.FullBrightEnabled then
			World.ClockSaved = false
			World.Flow = nil
			Lighting.ClockTime = World.SavedClock
		end

		local shadowsOff = S.NoShadowsEnabled or S.FullBrightEnabled
		if shadowsOff then
			if not World.ShadowsSaved then
				World.ShadowsSaved = true
				World.Shadows = Lighting.GlobalShadows
			end
			Lighting.GlobalShadows = false
		elseif World.ShadowsSaved then
			World.ShadowsSaved = false
			Lighting.GlobalShadows = World.Shadows
		end

		if S.FullBrightEnabled then
			if not World.BrightSaved then
				World.BrightSaved = true
				World.Brightness = Lighting.Brightness
				World.ClockTime = Lighting.ClockTime
				World.BrightFogEnd = Lighting.FogEnd
				World.Ambient = Lighting.Ambient
				World.OutdoorAmbient = Lighting.OutdoorAmbient
			end
			Lighting.Brightness = 2
			Lighting.ClockTime = 14
			if not S.FogEnabled then
				Lighting.FogEnd = 1e6
			end
			Lighting.Ambient = Color3.fromRGB(178, 178, 178)
			Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
		elseif World.BrightSaved then
			World.BrightSaved = false
			Lighting.Brightness = World.Brightness
			Lighting.ClockTime = World.ClockTime
			if not S.FogEnabled then
				Lighting.FogEnd = World.BrightFogEnd
			end
			Lighting.Ambient = World.Ambient
			Lighting.OutdoorAmbient = World.OutdoorAmbient
		end

		if S.RainbowEnabled then
			if not World.RainbowSaved then
				World.RainbowSaved = {
					Ambient = Lighting.Ambient,
					Outdoor = Lighting.OutdoorAmbient,
					Top = Lighting.ColorShift_Top,
					Bottom = Lighting.ColorShift_Bottom,
				}
			end
			local hue = (os.clock() * S.RainbowSpeed) % 1
			Lighting.ColorShift_Top = Color3.fromHSV(hue, 0.7, 1)
			Lighting.ColorShift_Bottom = Color3.fromHSV((hue + 0.5) % 1, 0.7, 1)
			if not S.FullBrightEnabled then
				Lighting.Ambient = Color3.fromHSV(hue, 0.45, 0.7)
				Lighting.OutdoorAmbient = Color3.fromHSV(hue, 0.45, 0.7)
			end
		elseif World.RainbowSaved then
			local saved = World.RainbowSaved
			World.RainbowSaved = nil
			Lighting.ColorShift_Top = saved.Top
			Lighting.ColorShift_Bottom = saved.Bottom
			if World.BrightSaved then
				World.Ambient = saved.Ambient
				World.OutdoorAmbient = saved.Outdoor
			else
				Lighting.Ambient = saved.Ambient
				Lighting.OutdoorAmbient = saved.Outdoor
			end
		end

		if S.ExposureEnabled then
			if not World.ExposureSaved then
				World.ExposureSaved = true
				World.ExposureValue = Lighting.ExposureCompensation
			end
			Lighting.ExposureCompensation = S.Exposure
		elseif World.ExposureSaved then
			World.ExposureSaved = false
			Lighting.ExposureCompensation = World.ExposureValue
		end

		if Clouds then
			if S.HideCloudsEnabled then
				if not World.CloudsSaved then
					World.CloudsSaved = true
					World.CloudsEnabled = Clouds.Enabled
				end
				Clouds.Enabled = false
			elseif World.CloudsSaved then
				World.CloudsSaved = false
				Clouds.Enabled = World.CloudsEnabled
			end
		end

		if S.GravityEnabled then
			if not World.GravitySaved then
				World.GravitySaved = true
				World.Gravity = Workspace.Gravity
			end
			Workspace.Gravity = S.GravityValue
		elseif World.GravitySaved then
			World.GravitySaved = false
			Workspace.Gravity = World.Gravity
		end

		if S.ZoomLimitEnabled then
			if not World.ZoomLimitSaved then
				World.ZoomLimitSaved = true
				World.ZoomLimitValue = LocalPlayer.CameraMaxZoomDistance
			end
			LocalPlayer.CameraMaxZoomDistance = S.ZoomLimit
		elseif World.ZoomLimitSaved then
			World.ZoomLimitSaved = false
			LocalPlayer.CameraMaxZoomDistance = World.ZoomLimitValue
		end

		local zoomHeld = S.ZoomEnabled
			and K.Zoom ~= Enum.KeyCode.Unknown
			and not UserInputService:GetFocusedTextBox()
			and UserInputService:IsKeyDown(K.Zoom)

		if S.CustomFOVEnabled and not Freecam.Active then
			if not World.FOVSaved then
				World.FOVSaved = true
				World.FOVBase = Camera.FieldOfView
			end
			local target = zoomHeld and S.ZoomFOV or S.CameraFOV
			Camera.FieldOfView += (target - Camera.FieldOfView) * (1 - math.exp(-16 * dt))
		else
			if World.FOVSaved then
				World.FOVSaved = false
				Camera.FieldOfView = World.FOVBase
			end
			if S.ZoomEnabled then
				if zoomHeld then
					if not World.Zooming then
						World.Zooming = true
						World.FOV = Camera.FieldOfView
					end
					Camera.FieldOfView += (S.ZoomFOV - Camera.FieldOfView) * (1 - math.exp(-16 * dt))
				elseif World.Zooming then
					Camera.FieldOfView += (World.FOV - Camera.FieldOfView) * (1 - math.exp(-16 * dt))
					if math.abs(Camera.FieldOfView - World.FOV) < 0.1 then
						Camera.FieldOfView = World.FOV
						World.Zooming = false
					end
				end
			elseif World.Zooming then
				World.Zooming = false
				Camera.FieldOfView = World.FOV
			end
		end
	end

	function World.Restore()
		if World.ShadowsSaved then
			Lighting.GlobalShadows = World.Shadows
			World.ShadowsSaved = false
		end
		if World.BrightSaved then
			Lighting.Brightness = World.Brightness
			Lighting.ClockTime = World.ClockTime
			Lighting.Ambient = World.Ambient
			Lighting.OutdoorAmbient = World.OutdoorAmbient
			if not World.FogSaved then
				Lighting.FogEnd = World.BrightFogEnd
			end
			World.BrightSaved = false
		end
		if World.RainbowSaved then
			local saved = World.RainbowSaved
			Lighting.ColorShift_Top = saved.Top
			Lighting.ColorShift_Bottom = saved.Bottom
			Lighting.Ambient = saved.Ambient
			Lighting.OutdoorAmbient = saved.Outdoor
			World.RainbowSaved = nil
		end
		if World.FOVSaved then
			Camera.FieldOfView = World.FOVBase
			World.FOVSaved = false
		elseif World.Zooming then
			Camera.FieldOfView = World.FOV
			World.Zooming = false
		end
		if World.FogSaved then
			Lighting.FogStart = World.FogStart
			Lighting.FogEnd = World.FogEnd
			Lighting.FogColor = World.FogColor
			World.FogSaved = false
		end
		if World.ClockSaved then
			Lighting.ClockTime = World.SavedClock
			World.ClockSaved = false
		end
		if World.ExposureSaved then
			Lighting.ExposureCompensation = World.ExposureValue
			World.ExposureSaved = false
		end
		if World.CloudsSaved and Clouds then
			Clouds.Enabled = World.CloudsEnabled
			World.CloudsSaved = false
		end
		if World.GravitySaved then
			Workspace.Gravity = World.Gravity
			World.GravitySaved = false
		end
		if World.ZoomLimitSaved then
			LocalPlayer.CameraMaxZoomDistance = World.ZoomLimitValue
			World.ZoomLimitSaved = false
		end
		if World.AtmoApplied then
			for property, value in pairs(World.AtmoOriginal) do
				AtmosphereObject[property] = value
			end
			World.AtmoApplied = false
		end
		if AtmosphereOwned then
			AtmosphereObject:Destroy()
		end
		SnowEmitter.Rate = 0
		RainEmitter.Rate = 0
		for _, effect in pairs(FX) do
			effect:Destroy()
		end
		WeatherPart:Destroy()
	end

	local FovFrame = New("Frame", Overlay, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(300, 300),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Visible = false,
	})
	Round(FovFrame, 100)
	New("UIStroke", FovFrame, {Color = "@Accent", Thickness = 1.5, Transparency = 0.35})

	local TriggerFovFrame = New("Frame", Overlay, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(10, 10),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Visible = false,
	})
	Round(TriggerFovFrame, 100)
	local TriggerFovStroke = New("UIStroke", TriggerFovFrame, {Color = Theme.Accent, Thickness = 1.5, Transparency = 0.1})

	local TargetLine = New("Frame", Overlay, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		BackgroundColor3 = "@Accent",
		BackgroundTransparency = 0.2,
		Visible = false,
	})

	local HudFrame = New("Frame", Overlay, {
		Position = UDim2.fromOffset(16, 16),
		Size = UDim2.fromOffset(150, 58),
		BackgroundColor3 = "@Background",
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0,
		Visible = false,
	})
	Round(HudFrame, 8)
	New("UIStroke", HudFrame, {Color = "@Border", Thickness = 1})
	New("Frame", HudFrame, {
		Size = UDim2.fromOffset(3, 34),
		Position = UDim2.fromOffset(8, 12),
		BackgroundColor3 = "@Accent",
		BorderSizePixel = 0,
	})
	local HudText = New("TextLabel", HudFrame, {
		Position = UDim2.fromOffset(20, 6),
		Size = UDim2.new(1, -28, 1, -12),
		BackgroundTransparency = 1,
		Text = "FPS 0",
		TextColor3 = "@Text",
		Font = Enum.Font.GothamMedium,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local Cross = {Lines = {}, Extra = 0}
	Cross.Holder = New("Frame", Overlay, {
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(0, 0),
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = 7,
	})
	for index = 1, 5 do
		local line = New("Frame", Cross.Holder, {BorderSizePixel = 0, ZIndex = 7})
		New("UIStroke", line, {Color = Color3.new(0, 0, 0), Thickness = 1, Transparency = 0.3})
		Cross.Lines[index] = line
	end

	local function UpdateCrosshair(dt)
		Cross.Holder.Visible = S.CrosshairEnabled
		if not S.CrosshairEnabled then
			return
		end
		local humanoid = GetHumanoid()
		local moving = humanoid ~= nil and humanoid.MoveDirection.Magnitude > 0.1
		local goal = (S.CrosshairDynamic and moving) and 6 or 0
		Cross.Extra += (goal - Cross.Extra) * (1 - math.exp(-12 * dt))
		local gap = S.CrosshairGap + Cross.Extra
		local length = S.CrosshairSize
		local thick = S.CrosshairThickness
		local color
		if S.CrosshairReactive and (Trigger.Player or Aim.Player) then
			color = ESPColors.Red
		elseif S.CrosshairColorName == "Theme" then
			color = Theme.Accent
		else
			color = ESPColors[S.CrosshairColorName] or ESPColors.White
		end
		local lines = Cross.Lines
		lines[1].Position = UDim2.fromOffset(-thick / 2, -(gap + length))
		lines[1].Size = UDim2.fromOffset(thick, length)
		lines[2].Position = UDim2.fromOffset(-thick / 2, gap)
		lines[2].Size = UDim2.fromOffset(thick, length)
		lines[3].Position = UDim2.fromOffset(-(gap + length), -thick / 2)
		lines[3].Size = UDim2.fromOffset(length, thick)
		lines[4].Position = UDim2.fromOffset(gap, -thick / 2)
		lines[4].Size = UDim2.fromOffset(length, thick)
		local dot = thick + 1
		lines[5].Position = UDim2.fromOffset(-dot / 2, -dot / 2)
		lines[5].Size = UDim2.fromOffset(dot, dot)
		lines[5].Visible = S.CrosshairDot
		for _, line in ipairs(lines) do
			line.BackgroundColor3 = color
		end
		if S.CrosshairSpin then
			Cross.Holder.Rotation = (Cross.Holder.Rotation + 120 * dt) % 360
		else
			Cross.Holder.Rotation = 0
		end
	end

	local Hit = {Lines = {}}
	Hit.Holder = New("Frame", Overlay, {
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(0, 0),
		BackgroundTransparency = 1,
		ZIndex = 8,
	})
	Hit.Scale = New("UIScale", Hit.Holder, {Scale = 1})
	for _, definition in ipairs({{-9, -9, 45}, {9, -9, -45}, {-9, 9, -45}, {9, 9, 45}}) do
		table.insert(Hit.Lines, New("Frame", Hit.Holder, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset(definition[1], definition[2]),
			Size = UDim2.fromOffset(9, 2),
			Rotation = definition[3],
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			ZIndex = 8,
		}))
	end
	Hit.Sound = New("Sound", Overlay, {SoundId = "rbxasset://sounds/electronicpingshort.wav", Volume = 0.5})

	function Hit.Show(kill)
		local color = kill and Color3.fromRGB(255, 70, 80) or Color3.new(1, 1, 1)
		Hit.Scale.Scale = 1.5
		Tween(Hit.Scale, {Scale = 1}, 0.2)
		for _, line in ipairs(Hit.Lines) do
			line.BackgroundColor3 = color
			line.BackgroundTransparency = 0
			Tween(line, {BackgroundTransparency = 1}, 0.45, Enum.EasingStyle.Quad)
		end
		if S.HitSoundEnabled then
			pcall(function()
				Hit.Sound.PlaybackSpeed = kill and 1.5 or 1.1
				Hit.Sound:Play()
			end)
		end
	end

	local function TrackHits(player, entry, firing)
		if not IsEnemy(player, true) then
			entry.LastHealth = nil
			return
		end
		local alive = entry.Refresh()
		local humanoid = entry.Humanoid
		if not humanoid then
			entry.LastHealth = nil
			return
		end
		local health = humanoid.Health
		if entry.LastHealth and health < entry.LastHealth - 0.01 and firing then
			Hit.Show(health <= 0)
		end
		entry.LastHealth = alive and health or nil
	end

	local function UpdateOverlay(dt)
		local viewport = Camera.ViewportSize
		FovFrame.Size = UDim2.fromOffset(S.FOVRadius * 2, S.FOVRadius * 2)
		FovFrame.Visible = S.ShowFOV and S.AimbotEnabled

		local triggerVisible = S.ShowTriggerFOV and S.TriggerEnabled
		TriggerFovFrame.Visible = triggerVisible
		if triggerVisible then
			local size = math.max(S.TriggerFOV * 2, 4)
			TriggerFovFrame.Size = UDim2.fromOffset(size, size)
			TriggerFovStroke.Color = Trigger.Player and ESPColors.Red or Theme.Accent
		end

		if S.ShowTargetLine and S.AimbotEnabled and Aim.Position then
			local screen, onScreen = Camera:WorldToViewportPoint(Aim.Position)
			if onScreen then
				DrawLine(
					TargetLine,
					Vector2.new(viewport.X / 2, viewport.Y / 2),
					Vector2.new(screen.X, screen.Y),
					Theme.Accent,
					1.5
				)
			else
				TargetLine.Visible = false
			end
		else
			TargetLine.Visible = false
		end

		local firing = os.clock() - Combat.LastFire < 0.35 or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
		for player, entry in pairs(Entries) do
			UpdateEntry(player, entry)
			if S.ChamsEnabled or entry.Cham then
				UpdateCham(player, entry)
			end
			if S.HitMarkerEnabled then
				TrackHits(player, entry, firing)
			else
				entry.LastHealth = nil
			end
		end

		UpdateCrosshair(dt)

		HudFrame.Visible = S.HUDEnabled
		if S.HUDEnabled then
			Hud.Accum += dt
			Hud.Frames += 1
			if Hud.Accum >= 0.25 then
				local fps = math.floor(Hud.Frames / Hud.Accum + 0.5)
				Hud.Accum = 0
				Hud.Frames = 0
				HudText.Text = string.format("%s %d", Locale.T("LBL_FPS"), fps)
			end
		end
	end

	local Root = New("CanvasGroup", MenuGui, {
		Name = "Main",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(760, 480),
		BackgroundColor3 = "@Background",
		BorderSizePixel = 0,
		GroupTransparency = 1,
	})
	local RootScale = New("UIScale", Root, {Scale = 0.9})
	Round(Root, 12)
	local GlowTween = GlowStroke(Root)

	local TopBar = New("Frame", Root, {
		Size = UDim2.new(1, 0, 0, 48),
		BackgroundColor3 = "@Secondary",
		BorderSizePixel = 0,
		ZIndex = 3,
	})
	New("Frame", TopBar, {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, -1),
		BackgroundColor3 = "@Border",
		BorderSizePixel = 0,
		ZIndex = 3,
	})
	local AppNameLabel = New("TextLabel", TopBar, {
		Position = UDim2.fromOffset(18, 6),
		Size = UDim2.fromOffset(240, 22),
		BackgroundTransparency = 1,
		Text = "VORTEX",
		TextColor3 = "@Text",
		Font = Enum.Font.GothamBold,
		TextSize = 17,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 4,
	})
	Locale.Bind(AppNameLabel, "APP_NAME")
	local AppSubLabel = New("TextLabel", TopBar, {
		Position = UDim2.fromOffset(18, 27),
		Size = UDim2.fromOffset(340, 14),
		BackgroundTransparency = 1,
		Text = "COMBAT HUB",
		TextColor3 = "@Muted",
		Font = Enum.Font.GothamMedium,
		TextSize = 9,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 4,
	})
	local function PaintAppSub()
		AppSubLabel.Text = Locale.T("APP_SUB") .. "  •  " .. string.upper(LocalPlayer.Name)
	end
	PaintAppSub()
	Locale.OnChange(PaintAppSub)

	local HideButton = New("TextButton", TopBar, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(28, 28),
		BackgroundColor3 = "@Row",
		Text = "-",
		TextColor3 = "@Text",
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		ZIndex = 4,
	})
	Round(HideButton, 7)

	local Sidebar = New("Frame", Root, {
		Position = UDim2.fromOffset(0, 48),
		Size = UDim2.fromOffset(160, 432),
		BackgroundColor3 = "@Secondary",
		BorderSizePixel = 0,
		ZIndex = 2,
	})
	New("Frame", Sidebar, {
		Size = UDim2.new(0, 1, 1, 0),
		Position = UDim2.new(1, -1, 0, 0),
		BackgroundColor3 = "@Border",
		BorderSizePixel = 0,
		ZIndex = 2,
	})

	local SidebarScroll = New("ScrollingFrame", Sidebar, {
		Position = UDim2.fromOffset(0, 8),
		Size = UDim2.new(1, 0, 1, -30),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = "@Accent",
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
	})

	local HighlightBar = New("Frame", SidebarScroll, {
		Position = UDim2.fromOffset(8, 4),
		Size = UDim2.fromOffset(144, 36),
		BackgroundColor3 = "@Row",
		BorderSizePixel = 0,
		ZIndex = 3,
	})
	Round(HighlightBar, 8)

	local Indicator = New("Frame", SidebarScroll, {
		Position = UDim2.fromOffset(0, 12),
		Size = UDim2.fromOffset(3, 20),
		BackgroundColor3 = "@Accent",
		BorderSizePixel = 0,
		ZIndex = 4,
	})
	Round(Indicator, 2)

	local Hint = New("TextLabel", Sidebar, {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 14, 1, -10),
		Size = UDim2.new(1, -28, 0, 14),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = "@Muted",
		Font = Enum.Font.GothamMedium,
		TextSize = 9,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 4,
	})

	local Content = New("Frame", Root, {
		Position = UDim2.fromOffset(160, 48),
		Size = UDim2.new(1, -160, 1, -48),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
	})

	local TabDefs = {
		{Key = "AIMBOT", Locale = "TAB_AIMBOT"},
		{Key = "VISUALS", Locale = "TAB_VISUALS"},
		{Key = "MOVEMENT", Locale = "TAB_MOVEMENT"},
		{Key = "WORLD", Locale = "TAB_WORLD"},
		{Key = "PROFILE", Locale = "TAB_PROFILE"},
		{Key = "BINDS", Locale = "TAB_BINDS"},
		{Key = "SETTINGS", Locale = "TAB_SETTINGS"},
	}
	local Pages = {}
	local Tabs = {}
	local ActiveTab = nil

	for index, def in ipairs(TabDefs) do
		local name = def.Key
		local group = New("CanvasGroup", Content, {
			Name = name,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			GroupTransparency = 1,
			Visible = false,
		})
		local scroll = New("ScrollingFrame", group, {
			Position = UDim2.fromOffset(10, 10),
			Size = UDim2.new(1, -20, 1, -20),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = "@Accent",
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.Y,
		})
		New("UIListLayout", scroll, {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})
		New("UIPadding", scroll, {PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 10)})
		Pages[name] = {Group = group, Scroll = scroll, Order = 0}

		local button = New("TextButton", SidebarScroll, {
			Position = UDim2.fromOffset(8, 4 + (index - 1) * 40),
			Size = UDim2.fromOffset(144, 36),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 5,
		})
		local label = New("TextLabel", button, {
			Position = UDim2.fromOffset(16, 0),
			Size = UDim2.new(1, -16, 1, 0),
			BackgroundTransparency = 1,
			Text = name,
			TextColor3 = Theme.SubText,
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 5,
		})
		Locale.Bind(label, def.Locale)
		Tabs[name] = {Button = button, Label = label, Index = index}
	end

	SidebarScroll.CanvasSize = UDim2.new()

	local function SelectTab(name)
		if ActiveTab == name then
			return
		end
		local previous = ActiveTab
		ActiveTab = name
		local tab = Tabs[name]
		Tween(HighlightBar, {Position = UDim2.fromOffset(8, 4 + (tab.Index - 1) * 40)}, 0.28)
		Tween(Indicator, {Position = UDim2.fromOffset(0, 12 + (tab.Index - 1) * 40)}, 0.28)
		for tabName, data in pairs(Tabs) do
			Tween(data.Label, {TextColor3 = tabName == name and Theme.Text or Theme.SubText}, 0.2)
		end
		if previous then
			local old = Pages[previous].Group
			Tween(old, {GroupTransparency = 1}, 0.15)
			task.delay(0.16, function()
				if ActiveTab ~= previous then
					old.Visible = false
				end
			end)
		end
		local group = Pages[name].Group
		group.Position = UDim2.fromOffset(0, 14)
		group.GroupTransparency = 1
		group.Visible = true
		Tween(group, {Position = UDim2.fromOffset(0, 0), GroupTransparency = 0}, 0.3)
	end

	for name, tab in pairs(Tabs) do
		Connect(tab.Button.MouseButton1Click, function()
			SelectTab(name)
		end)
		Connect(tab.Button.MouseEnter, function()
			if ActiveTab ~= name then
				Tween(tab.Label, {TextColor3 = Theme.Text}, 0.12)
			end
		end)
		Connect(tab.Button.MouseLeave, function()
			if ActiveTab ~= name then
				Tween(tab.Label, {TextColor3 = Theme.SubText}, 0.12)
			end
		end)
	end

	table.insert(Refreshers, function()
		for tabName, data in pairs(Tabs) do
			Tween(data.Label, {TextColor3 = tabName == ActiveTab and Theme.Text or Theme.SubText}, 0.3)
		end
	end)

	local function Row(page, height)
		page.Order += 1
		local row = New("Frame", page.Scroll, {
			Size = UDim2.new(1, 0, 0, height),
			BackgroundColor3 = "@Row",
			BorderSizePixel = 0,
			LayoutOrder = page.Order,
		})
		Round(row, 8)
		local stroke = New("UIStroke", row, {Color = "@Border", Thickness = 1, Transparency = 0.3})
		Connect(row.MouseEnter, function()
			Tween(stroke, {Color = Theme.Accent, Transparency = 0.5}, 0.15)
		end)
		Connect(row.MouseLeave, function()
			Tween(stroke, {Color = Theme.Border, Transparency = 0.3}, 0.15)
		end)
		return row
	end

	local function RowLabel(row, localeKey)
		local label = New("TextLabel", row, {
			Position = UDim2.fromOffset(14, 0),
			Size = UDim2.new(1, -170, 1, 0),
			BackgroundTransparency = 1,
			Text = localeKey,
			TextColor3 = "@Text",
			Font = Enum.Font.GothamMedium,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		Locale.Bind(label, localeKey)
		return label
	end

	local function Section(page, localeKey)
		page.Order += 1
		local holder = New("Frame", page.Scroll, {
			Size = UDim2.new(1, 0, 0, 22),
			BackgroundTransparency = 1,
			LayoutOrder = page.Order,
		})
		local bar = New("Frame", holder, {
			Size = UDim2.fromOffset(3, 12),
			Position = UDim2.fromOffset(2, 5),
			BackgroundColor3 = "@Accent",
			BorderSizePixel = 0,
		})
		Round(bar, 2)
		local label = New("TextLabel", holder, {
			Position = UDim2.fromOffset(12, 0),
			Size = UDim2.new(1, -12, 1, 0),
			BackgroundTransparency = 1,
			Text = localeKey,
			TextColor3 = "@SubText",
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		Locale.Bind(label, localeKey)
	end

	local function Toggle(page, localeKey, key)
		local row = Row(page, 40)
		RowLabel(row, localeKey)
		local track = New("TextButton", row, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -14, 0.5, 0),
			Size = UDim2.fromOffset(40, 20),
			BackgroundColor3 = Theme.Background,
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
		})
		Round(track, 100)
		local trackStroke = New("UIStroke", track, {Color = Theme.Border, Thickness = 1})
		local knob = New("Frame", track, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 3, 0.5, 0),
			Size = UDim2.fromOffset(14, 14),
			BackgroundColor3 = Theme.Muted,
			BorderSizePixel = 0,
		})
		Round(knob, 100)
		local function Paint()
			local on = S[key]
			Tween(track, {BackgroundColor3 = on and Theme.Accent or Theme.Background}, 0.2)
			Tween(trackStroke, {Color = on and Theme.Accent or Theme.Border}, 0.2)
			Tween(knob, {
				Position = on and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
				BackgroundColor3 = on and Theme.Background or Theme.Muted,
			}, 0.22, Enum.EasingStyle.Back)
		end
		Paint()
		Sync[key] = Paint
		table.insert(Refreshers, Paint)
		Connect(track.MouseButton1Click, function()
			SetValue(key, not S[key])
		end)
		Connect(row.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				local x = input.Position.X
				local origin = track.AbsolutePosition.X
				if x < origin or x > origin + track.AbsoluteSize.X then
					SetValue(key, not S[key])
				end
			end
		end)
	end

	local Drag = {}

	local function Slider(page, localeKey, key, minimum, maximum, decimals)
		local row = Row(page, 54)
		local titleLabel = New("TextLabel", row, {
			Position = UDim2.fromOffset(14, 8),
			Size = UDim2.new(1, -110, 0, 16),
			BackgroundTransparency = 1,
			Text = localeKey,
			TextColor3 = "@Text",
			Font = Enum.Font.GothamMedium,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		Locale.Bind(titleLabel, localeKey)
		local valueLabel = New("TextLabel", row, {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -14, 0, 8),
			Size = UDim2.fromOffset(90, 16),
			BackgroundTransparency = 1,
			TextColor3 = "@SubText",
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Right,
		})
		local track = New("Frame", row, {
			Position = UDim2.fromOffset(14, 38),
			Size = UDim2.new(1, -28, 0, 4),
			BackgroundColor3 = "@Background",
			BorderSizePixel = 0,
		})
		Round(track, 100)
		local fill = New("Frame", track, {
			Size = UDim2.fromScale(0, 1),
			BackgroundColor3 = "@Accent",
			BorderSizePixel = 0,
		})
		Round(fill, 100)
		local knob = New("Frame", track, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromOffset(12, 12),
			BackgroundColor3 = "@Text",
			BorderSizePixel = 0,
			ZIndex = 3,
		})
		Round(knob, 100)

		local function Show(value)
			local alpha = math.clamp((value - minimum) / (maximum - minimum), 0, 1)
			Tween(fill, {Size = UDim2.fromScale(alpha, 1)}, 0.08)
			Tween(knob, {Position = UDim2.fromScale(alpha, 0.5)}, 0.08)
			if decimals == 0 then
				valueLabel.Text = tostring(math.floor(value + 0.5))
			else
				valueLabel.Text = string.format("%." .. decimals .. "f", value)
			end
		end

		Show(S[key])
		Sync[key] = Show

		local function FromX(x)
			local alpha = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
			local value = minimum + (maximum - minimum) * alpha
			local multiplier = 10 ^ decimals
			value = math.floor(value * multiplier + 0.5) / multiplier
			SetValue(key, value)
		end

		Connect(row.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				Drag.Update = FromX
				FromX(input.Position.X)
				Tween(knob, {Size = UDim2.fromOffset(15, 15)}, 0.1)
			end
		end)
		Connect(row.InputEnded, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				Tween(knob, {Size = UDim2.fromOffset(12, 12)}, 0.1)
			end
		end)
	end

	local function Choice(page, localeKey, options, get, set)
		local row = Row(page, 40)
		RowLabel(row, localeKey)
		local button = New("TextButton", row, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -14, 0.5, 0),
			Size = UDim2.fromOffset(130, 26),
			BackgroundColor3 = "@Background",
			Text = tostring(get()),
			TextColor3 = "@Text",
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			AutoButtonColor = false,
			BorderSizePixel = 0,
		})
		Round(button, 6)
		New("UIStroke", button, {Color = "@Border", Thickness = 1})
		local function Step(direction)
			local index = table.find(options, get()) or 1
			index = (index - 1 + direction) % #options + 1
			set(options[index])
			button.Text = tostring(options[index])
		end
		Connect(button.MouseButton1Click, function()
			Step(1)
		end)
		Connect(button.MouseButton2Click, function()
			Step(-1)
		end)
	end

	local function Bind(page, localeKey, key)
		local row = Row(page, 40)
		RowLabel(row, localeKey)
		local button = New("TextButton", row, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -14, 0.5, 0),
			Size = UDim2.fromOffset(130, 26),
			BackgroundColor3 = "@Background",
			Text = KeyName(K[key]),
			TextColor3 = "@Text",
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			AutoButtonColor = false,
			BorderSizePixel = 0,
		})
		Round(button, 6)
		New("UIStroke", button, {Color = "@Border", Thickness = 1})
		Connect(button.MouseButton1Click, function()
			if Listening then
				Listening.Button.Text = KeyName(K[Listening.Key])
			end
			Listening = {Key = key, Button = button}
			button.Text = "..."
		end)
	end

	local function Action(page, localeKey, callback)
		local row = Row(page, 40)
		local button = New("TextButton", row, {
			Position = UDim2.fromOffset(12, 6),
			Size = UDim2.new(1, -24, 0, 28),
			BackgroundColor3 = "@Accent",
			Text = localeKey,
			TextColor3 = "@Background",
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			AutoButtonColor = false,
			BorderSizePixel = 0,
		})
		Locale.Bind(button, localeKey)
		Round(button, 6)
		Connect(button.MouseEnter, function()
			Tween(button, {BackgroundTransparency = 0.2}, 0.12)
		end)
		Connect(button.MouseLeave, function()
			Tween(button, {BackgroundTransparency = 0}, 0.12)
		end)
		Connect(button.MouseButton1Click, callback)
		return row, button
	end

	local function TextField(page, phKey, height)
		local row = Row(page, height)
		local box = New("TextBox", row, {
			Position = UDim2.fromOffset(14, 8),
			Size = UDim2.new(1, -28, 1, -16),
			BackgroundColor3 = "@Background",
			BorderSizePixel = 0,
			Text = "",
			PlaceholderText = phKey,
			PlaceholderColor3 = "@Muted",
			TextColor3 = "@Text",
			Font = Enum.Font.Code,
			TextSize = 11,
			ClearTextOnFocus = false,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		Locale.Bind(box, phKey, "PlaceholderText")
		Round(box, 6)
		New("UIStroke", box, {Color = "@Border", Thickness = 1})
		New("UIPadding", box, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
		return box
	end

	local function ApplyPreset(name)
		if name == "None" then
			return
		end
		for _, key in ipairs(WorldKeys) do
			SetValue(key, Defaults[key])
		end
		local preset = Presets[name]
		if preset then
			for key, value in pairs(preset) do
				SetValue(key, value)
			end
		end
		Notify(string.format(Locale.T("TOAST_PRESET"), name))
	end

	local Aimbot = Pages.AIMBOT
	Section(Aimbot, "SEC_AIMBOT")
	Toggle(Aimbot, "OPT_AIMBOT", "AimbotEnabled")
	Toggle(Aimbot, "OPT_HOLD_RMB", "AimHold")
	Toggle(Aimbot, "OPT_TEAMCHECK", "AimTeamCheck")
	Toggle(Aimbot, "OPT_VISIBLECHECK", "VisibleCheck")
	Choice(Aimbot, "OPT_AIMPART", {"Head", "Chest", "Root"}, function()
		return S.AimPart
	end, function(value)
		S.AimPart = value
	end)
	Slider(Aimbot, "OPT_AIMSPEED", "AimSpeed", 1, 60, 0)
	Slider(Aimbot, "OPT_FOVRADIUS", "FOVRadius", 20, 500, 0)
	Slider(Aimbot, "OPT_MAXDIST", "MaxAimDistance", 100, 5000, 0)
	Toggle(Aimbot, "OPT_PREDICTION", "PredictionEnabled")
	Slider(Aimbot, "OPT_PREDICTIONTIME", "PredictionTime", 0.02, 0.4, 2)
	Toggle(Aimbot, "OPT_SHOWFOV", "ShowFOV")
	Toggle(Aimbot, "OPT_TARGETLINE", "ShowTargetLine")

	Section(Aimbot, "SEC_TRIGGER")
	Toggle(Aimbot, "OPT_TRIGGERBOT", "TriggerEnabled")
	Slider(Aimbot, "OPT_TRIGGERFOV", "TriggerFOV", 1, 100, 0)
	Toggle(Aimbot, "OPT_SHOWTRIGGERFOV", "ShowTriggerFOV")
	Toggle(Aimbot, "OPT_HITBOX", "TriggerHitbox")
	Choice(Aimbot, "OPT_TRIGGERPART", {"Head", "Body", "Any"}, function()
		return S.TriggerPart
	end, function(value)
		S.TriggerPart = value
	end)
	Toggle(Aimbot, "OPT_TEAMCHECK", "TriggerTeamCheck")
	Toggle(Aimbot, "OPT_WALLCHECK", "TriggerWallCheck")
	Toggle(Aimbot, "OPT_ONLYAIM", "TriggerOnlyAim")
	Slider(Aimbot, "OPT_MAXDIST", "TriggerMaxDistance", 50, 3000, 0)
	Slider(Aimbot, "OPT_REACTDELAY", "TriggerDelay", 0, 0.5, 2)
	Slider(Aimbot, "OPT_FIREINTERVAL", "TriggerInterval", 0.02, 0.6, 2)
	Toggle(Aimbot, "OPT_HUMANIZE", "TriggerHumanize")
	Choice(Aimbot, "OPT_CLICKMODE", {"Auto", "Tool"}, function()
		return S.TriggerClickMode
	end, function(value)
		S.TriggerClickMode = value
	end)

	local Visuals = Pages.VISUALS
	Section(Visuals, "SEC_ESP")
	Toggle(Visuals, "OPT_ESP", "ESPEnabled")
	Toggle(Visuals, "OPT_HIDETEAM", "ESPTeamCheck")
	Toggle(Visuals, "OPT_BOXES", "ShowBoxes")
	Toggle(Visuals, "OPT_CORNERBOXES", "CornerBoxEnabled")
	Toggle(Visuals, "OPT_NAMES", "ShowNames")
	Toggle(Visuals, "OPT_DISTANCE", "ShowDistance")
	Toggle(Visuals, "OPT_HEALTHBAR", "ShowHealth")
	Toggle(Visuals, "OPT_SKELETON", "ShowSkeleton")
	Toggle(Visuals, "OPT_HEADDOT", "ShowHeadDot")
	Toggle(Visuals, "OPT_WEAPON", "ShowWeapon")
	Toggle(Visuals, "OPT_OFFSCREEN", "ShowOffscreen")
	Toggle(Visuals, "OPT_CHAMS", "ChamsEnabled")
	Toggle(Visuals, "OPT_TRACERS", "ShowTracers")
	Choice(Visuals, "OPT_TRACERORIGIN", TracerOriginNames, function()
		return S.TracerOrigin
	end, function(value)
		S.TracerOrigin = value
	end)
	Choice(Visuals, "OPT_ESPCOLOR", ESPColorNames, function()
		return S.ESPColor
	end, function(value)
		S.ESPColor = value
	end)
	Slider(Visuals, "OPT_ESPDIST", "ESPMaxDistance", 100, 5000, 0)

	local Movement = Pages.MOVEMENT
	Section(Movement, "SEC_MOVEMENT")
	Toggle(Movement, "OPT_SPEED", "SpeedEnabled")
	Slider(Movement, "OPT_WALKSPEED", "SpeedValue", 16, 250, 0)
	Toggle(Movement, "OPT_JUMPPOWER", "JumpEnabled")
	Slider(Movement, "OPT_JUMPVALUE", "JumpValue", 50, 300, 0)
	Toggle(Movement, "OPT_FLY", "FlyEnabled")
	Slider(Movement, "OPT_FLYSPEED", "FlySpeed", 20, 300, 0)
	Toggle(Movement, "OPT_NOCLIP", "NoclipEnabled")
	Toggle(Movement, "OPT_INFJUMP", "InfJumpEnabled")

	local WorldPage = Pages.WORLD
	Section(WorldPage, "SEC_PRESETS")
	Choice(WorldPage, "OPT_SCENEPRESET", PresetNames, function()
		return S.WorldPreset
	end, function(value)
		S.WorldPreset = value
		ApplyPreset(value)
	end)

	Section(WorldPage, "SEC_RENDERING")
	Toggle(WorldPage, "OPT_FULLBRIGHT", "FullBrightEnabled")
	Toggle(WorldPage, "OPT_NOSHADOWS", "NoShadowsEnabled")
	Toggle(WorldPage, "OPT_EXPOSURE", "ExposureEnabled")
	Slider(WorldPage, "OPT_EXPOSUREVAL", "Exposure", -3, 3, 1)
	Toggle(WorldPage, "OPT_HIDECLOUDS", "HideCloudsEnabled")
	Toggle(WorldPage, "OPT_GRAVITY", "GravityEnabled")
	Slider(WorldPage, "OPT_GRAVITYVAL", "GravityValue", 10, 400, 0)
	Toggle(WorldPage, "OPT_HUD", "HUDEnabled")

	Section(WorldPage, "SEC_CAMERA")
	Toggle(WorldPage, "OPT_CUSTOMFOV", "CustomFOVEnabled")
	Slider(WorldPage, "OPT_CAMERAFOV", "CameraFOV", 30, 120, 0)
	Toggle(WorldPage, "OPT_HOLDZOOM", "ZoomEnabled")
	Slider(WorldPage, "OPT_ZOOMFOV", "ZoomFOV", 5, 60, 0)
	Toggle(WorldPage, "OPT_FREECAM", "FreecamEnabled")
	Slider(WorldPage, "OPT_FREECAMSPEED", "FreecamSpeed", 10, 300, 0)
	Toggle(WorldPage, "OPT_ZOOMLIMIT", "ZoomLimitEnabled")
	Slider(WorldPage, "OPT_MAXZOOM", "ZoomLimit", 10, 500, 0)

	Section(WorldPage, "SEC_WEATHER")
	Toggle(WorldPage, "OPT_SNOW", "SnowEnabled")
	Slider(WorldPage, "OPT_SNOWDENSITY", "SnowIntensity", 5, 150, 0)
	Toggle(WorldPage, "OPT_RAIN", "RainEnabled")
	Slider(WorldPage, "OPT_RAINDENSITY", "RainIntensity", 5, 200, 0)
	Slider(WorldPage, "OPT_WIND", "WindStrength", 0, 30, 0)
	Toggle(WorldPage, "OPT_FOG", "FogEnabled")
	Slider(WorldPage, "OPT_FOGDIST", "FogDensity", 30, 800, 0)
	Choice(WorldPage, "OPT_FOGCOLOR", FogColorNames, function()
		return S.FogColorName
	end, function(value)
		S.FogColorName = value
	end)
	Toggle(WorldPage, "OPT_LIGHTNING", "LightningEnabled")
	Slider(WorldPage, "OPT_LIGHTNINGINT", "LightningInterval", 2, 30, 0)

	Section(WorldPage, "SEC_ATMOSPHERE")
	Toggle(WorldPage, "OPT_ATMOSPHERE", "AtmosphereEnabled")
	Slider(WorldPage, "OPT_ATMODENSITY", "AtmoDensity", 0, 1, 2)
	Slider(WorldPage, "OPT_ATMOHAZE", "AtmoHaze", 0, 10, 1)
	Choice(WorldPage, "OPT_ATMOCOLOR", FogColorNames, function()
		return S.AtmoColorName
	end, function(value)
		S.AtmoColorName = value
	end)
	Toggle(WorldPage, "OPT_SUNRAYS", "SunRaysEnabled")
	Slider(WorldPage, "OPT_RAYSINT", "SunRaysIntensity", 0, 1, 2)
	Slider(WorldPage, "OPT_RAYSSPREAD", "SunRaysSpread", 0, 1, 2)
	Toggle(WorldPage, "OPT_RAINBOW", "RainbowEnabled")
	Slider(WorldPage, "OPT_RAINBOWSPEED", "RainbowSpeed", 0.02, 1, 2)

	Section(WorldPage, "SEC_TIME")
	Toggle(WorldPage, "OPT_FORCETIME", "TimeOfDayEnabled")
	Slider(WorldPage, "OPT_TIMEOFDAY", "TimeOfDay", 0, 24, 1)
	Toggle(WorldPage, "OPT_TIMEFLOW", "TimeFlowEnabled")
	Slider(WorldPage, "OPT_FLOWSPEED", "TimeFlowSpeed", 0.02, 3, 2)

	Section(WorldPage, "SEC_POSTFX")
	Toggle(WorldPage, "OPT_GLOW", "GlowEnabled")
	Slider(WorldPage, "OPT_GLOWINT", "GlowIntensity", 0, 1, 2)
	Toggle(WorldPage, "OPT_COLORGRADE", "ColorGradeEnabled")
	Slider(WorldPage, "OPT_SATURATION", "ColorSaturation", -1, 1, 2)
	Choice(WorldPage, "OPT_TINT", WorldTintNames, function()
		return S.ColorTintName
	end, function(value)
		S.ColorTintName = value
	end)
	Choice(WorldPage, "OPT_VISIONMODE", VisionNames, function()
		return S.VisionMode
	end, function(value)
		S.VisionMode = value
	end)
	Toggle(WorldPage, "OPT_DOF", "DOFEnabled")
	Slider(WorldPage, "OPT_FOCUSDIST", "DOFFocus", 5, 500, 0)
	Slider(WorldPage, "OPT_BLURAMOUNT", "DOFFar", 0, 1, 2)
	Slider(WorldPage, "OPT_FOCUSRADIUS", "DOFRadius", 5, 200, 0)
	Toggle(WorldPage, "OPT_SCREENBLUR", "BlurEnabled")
	Slider(WorldPage, "OPT_BLURSIZE", "BlurSize", 0, 40, 0)
	Toggle(WorldPage, "OPT_VIGNETTE", "VignetteEnabled")
	Slider(WorldPage, "OPT_VIGNETTEINT", "VignetteIntensity", 0, 1, 2)

	Section(WorldPage, "SEC_CROSSHAIR")
	Toggle(WorldPage, "OPT_CUSTOMCROSS", "CrosshairEnabled")
	Slider(WorldPage, "OPT_CROSSSIZE", "CrosshairSize", 2, 30, 0)
	Slider(WorldPage, "OPT_CROSSGAP", "CrosshairGap", 0, 20, 0)
	Slider(WorldPage, "OPT_CROSSTHICK", "CrosshairThickness", 1, 6, 0)
	Toggle(WorldPage, "OPT_CENTERDOT", "CrosshairDot")
	Choice(WorldPage, "OPT_CROSSCOLOR", CrosshairColorNames, function()
		return S.CrosshairColorName
	end, function(value)
		S.CrosshairColorName = value
	end)
	Toggle(WorldPage, "OPT_SPIN", "CrosshairSpin")
	Toggle(WorldPage, "OPT_DYNAMICGAP", "CrosshairDynamic")
	Toggle(WorldPage, "OPT_REDONTARGET", "CrosshairReactive")

	Section(WorldPage, "SEC_HITFX")
	Toggle(WorldPage, "OPT_HITMARKER", "HitMarkerEnabled")
	Toggle(WorldPage, "OPT_HITSOUND", "HitSoundEnabled")

	local ProfilePage = Pages.PROFILE
	Section(ProfilePage, "SEC_ACCOUNT")

	local AccountRow = Row(ProfilePage, 96)
	local AvatarImage = New("ImageLabel", AccountRow, {
		Position = UDim2.fromOffset(12, 12),
		Size = UDim2.fromOffset(72, 72),
		BackgroundColor3 = "@Background",
		BorderSizePixel = 0,
		Image = "",
		ScaleType = Enum.ScaleType.Crop,
	})
	Round(AvatarImage, 10)
	pcall(function()
		local content, ready = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
		if ready then
			AvatarImage.Image = content
		end
	end)

	New("TextLabel", AccountRow, {
		Position = UDim2.fromOffset(94, 12),
		Size = UDim2.new(1, -110, 0, 20),
		BackgroundTransparency = 1,
		Text = LocalPlayer.Name,
		TextColor3 = "@Text",
		Font = Enum.Font.GothamBold,
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	New("TextLabel", AccountRow, {
		Position = UDim2.fromOffset(94, 34),
		Size = UDim2.new(1, -110, 0, 14),
		BackgroundTransparency = 1,
		Text = "@" .. LocalPlayer.DisplayName,
		TextColor3 = "@SubText",
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	local IdLabelP = New("TextLabel", AccountRow, {
		Position = UDim2.fromOffset(94, 52),
		Size = UDim2.new(1, -110, 0, 14),
		BackgroundTransparency = 1,
		TextColor3 = "@Muted",
		Font = Enum.Font.GothamMedium,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	local function PaintId()
		IdLabelP.Text = Locale.T("LBL_USERID") .. ": " .. tostring(LocalPlayer.UserId)
	end
	PaintId()
	Locale.OnChange(PaintId)

	local AgeLabelP = New("TextLabel", AccountRow, {
		Position = UDim2.fromOffset(94, 70),
		Size = UDim2.new(1, -110, 0, 14),
		BackgroundTransparency = 1,
		TextColor3 = "@Muted",
		Font = Enum.Font.GothamMedium,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	local function PaintAge()
		AgeLabelP.Text = Locale.T("LBL_ACCOUNTAGE") .. ": " .. tostring(LocalPlayer.AccountAge) .. " " .. Locale.T("LBL_DAYS")
	end
	PaintAge()
	Locale.OnChange(PaintAge)

	Section(ProfilePage, "SEC_SESSION")

	local SessionRow = Row(ProfilePage, 40)
	RowLabel(SessionRow, "LBL_SESSIONTIME")
	local SessionValue = New("TextLabel", SessionRow, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(140, 20),
		BackgroundTransparency = 1,
		Text = "00:00:00",
		TextColor3 = "@Accent",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
	})

	local TeamRow = Row(ProfilePage, 40)
	RowLabel(TeamRow, "LBL_TEAM")
	local TeamValue = New("TextLabel", TeamRow, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(140, 20),
		BackgroundTransparency = 1,
		Text = "-",
		TextColor3 = "@SubText",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
	})

	local HealthRow = Row(ProfilePage, 40)
	RowLabel(HealthRow, "LBL_HEALTH")
	local HealthValue = New("TextLabel", HealthRow, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(140, 20),
		BackgroundTransparency = 1,
		Text = "-",
		TextColor3 = "@SubText",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
	})

	local StateRow = Row(ProfilePage, 40)
	RowLabel(StateRow, "LBL_CHARSTATE")
	local StateValue = New("TextLabel", StateRow, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(140, 20),
		BackgroundTransparency = 1,
		Text = "-",
		TextColor3 = "@SubText",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
	})

	Section(ProfilePage, "SEC_SERVER")

	local PlaceIdRow = Row(ProfilePage, 40)
	RowLabel(PlaceIdRow, "LBL_PLACEID")
	New("TextLabel", PlaceIdRow, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(220, 20),
		BackgroundTransparency = 1,
		Text = tostring(game.PlaceId),
		TextColor3 = "@SubText",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})

	local JobIdRow = Row(ProfilePage, 40)
	RowLabel(JobIdRow, "LBL_JOBID")
	New("TextLabel", JobIdRow, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(280, 20),
		BackgroundTransparency = 1,
		Text = game.JobId ~= "" and game.JobId or "Studio",
		TextColor3 = "@SubText",
		Font = Enum.Font.GothamMedium,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})

	local PlayerCountRow = Row(ProfilePage, 40)
	RowLabel(PlayerCountRow, "LBL_PLAYERCOUNT")
	local PlayerCountValue = New("TextLabel", PlayerCountRow, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(140, 20),
		BackgroundTransparency = 1,
		Text = "-",
		TextColor3 = "@SubText",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
	})

	local PingRow = Row(ProfilePage, 40)
	RowLabel(PingRow, "LBL_PING")
	local PingValue = New("TextLabel", PingRow, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(140, 20),
		BackgroundTransparency = 1,
		Text = "-",
		TextColor3 = "@SubText",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
	})

	local function FormatDuration(seconds)
		local total = math.floor(seconds)
		local hours = math.floor(total / 3600)
		local minutes = math.floor((total % 3600) / 60)
		local secs = total % 60
		return string.format("%02d:%02d:%02d", hours, minutes, secs)
	end

	local ProfileAccum = 0
	local function UpdateProfile(dt)
		if ActiveTab ~= "PROFILE" then
			return
		end
		ProfileAccum += dt
		if ProfileAccum < 0.5 then
			return
		end
		ProfileAccum = 0
		SessionValue.Text = FormatDuration(os.clock() - SessionStart)
		local team = LocalPlayer.Team
		TeamValue.Text = team and team.Name or Locale.T("LBL_NOTEAM")
		local humanoid = GetHumanoid()
		if humanoid then
			HealthValue.Text = string.format("%d / %d", math.max(math.floor(humanoid.Health), 0), math.floor(humanoid.MaxHealth))
			StateValue.Text = humanoid.Health > 0 and Locale.T("LBL_ALIVE") or Locale.T("LBL_DEAD")
		else
			HealthValue.Text = "-"
			StateValue.Text = Locale.T("LBL_NOCHAR")
		end
		PlayerCountValue.Text = tostring(#Players:GetPlayers())
		local ping = 0
		pcall(function()
			ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		end)
		PingValue.Text = ping .. " ms"
	end
	Locale.OnChange(function()
		ProfileAccum = 1
	end)

	local Binds = Pages.BINDS
	Section(Binds, "SEC_SCRIPT")
	Bind(Binds, "MENU_KEY", "Menu")
	for _, key in ipairs(BindOrder) do
		Bind(Binds, BindNameKeys[key], key)
	end
	Bind(Binds, "BIND_ZOOM", "Zoom")

	local SettingsPage = Pages.SETTINGS
	Section(SettingsPage, "SEC_INTERFACE")
	Choice(SettingsPage, "OPT_THEME", ThemeNames, function()
		return Prefs.Theme
	end, function(value)
		Prefs.Theme = value
		ApplyTheme()
	end)
	Choice(SettingsPage, "OPT_ACCENT", AccentNames, function()
		return Prefs.Accent
	end, function(value)
		Prefs.Accent = value
		ApplyTheme()
	end)
	Slider(SettingsPage, "OPT_MENUSCALE", "UIScale", 0.7, 1.3, 2)
	Slider(SettingsPage, "OPT_MENUTRANSP", "UIOpacity", 0, 0.5, 2)

	Section(SettingsPage, "SEC_LANGUAGE")
	Choice(SettingsPage, "OPT_LANGUAGE", LanguageCodes, function()
		return Locale.Current
	end, function(value)
		Locale.SetLanguage(value, Notify)
	end)

	Section(SettingsPage, "SEC_THEME")

	local function ColorChannelSlider(page, label, colorKey, channel)
		local row = Row(page, 40)
		New("TextLabel", row, {
			Position = UDim2.fromOffset(14, 0),
			Size = UDim2.fromOffset(80, 40),
			BackgroundTransparency = 1,
			Text = label,
			TextColor3 = "@SubText",
			Font = Enum.Font.GothamMedium,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		local track = New("Frame", row, {
			Position = UDim2.fromOffset(100, 17),
			Size = UDim2.new(1, -220, 0, 6),
			BackgroundColor3 = "@Background",
			BorderSizePixel = 0,
		})
		Round(track, 100)
		local fill = New("Frame", track, {
			Size = UDim2.fromScale(0, 1),
			BackgroundColor3 = "@Accent",
			BorderSizePixel = 0,
		})
		Round(fill, 100)
		local valueLabel = New("TextLabel", row, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -14, 0.5, 0),
			Size = UDim2.fromOffset(50, 20),
			BackgroundTransparency = 1,
			TextColor3 = "@Text",
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Right,
		})
		local function CurrentByte()
			local color = Themes.Custom[colorKey]
			if channel == "R" then
				return math.floor(color.R * 255 + 0.5)
			elseif channel == "G" then
				return math.floor(color.G * 255 + 0.5)
			end
			return math.floor(color.B * 255 + 0.5)
		end
		local function Paint()
			local byte = CurrentByte()
			fill.Size = UDim2.fromScale(byte / 255, 1)
			valueLabel.Text = tostring(byte)
		end
		Paint()
		local function ApplyByte(byte)
			local color = Themes.Custom[colorKey]
			local r, g, b = color.R * 255, color.G * 255, color.B * 255
			if channel == "R" then
				r = byte
			elseif channel == "G" then
				g = byte
			else
				b = byte
			end
			Themes.Custom[colorKey] = Color3.fromRGB(math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255))
			if Prefs.Theme == "Custom" then
				ApplyTheme()
			end
			Paint()
		end
		local function FromX(x)
			local alpha = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
			ApplyByte(math.floor(alpha * 255 + 0.5))
		end
		Connect(row.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				Drag.Update = FromX
				FromX(input.Position.X)
			end
		end)
		table.insert(Refreshers, Paint)
	end

	for _, key in ipairs(ThemeKeys) do
		ColorChannelSlider(SettingsPage, key .. " R", key, "R")
		ColorChannelSlider(SettingsPage, key .. " G", key, "G")
		ColorChannelSlider(SettingsPage, key .. " B", key, "B")
	end

	Action(SettingsPage, "BTN_RESETCOLORS", function()
		for key, value in pairs(Themes.Obsidian) do
			Themes.Custom[key] = value
		end
		if Prefs.Theme == "Custom" then
			ApplyTheme()
		end
		for _, refresh in ipairs(Refreshers) do
			refresh()
		end
	end)

	Section(SettingsPage, "SEC_CONFIG")

	local ConfigNameRow = Row(SettingsPage, 40)
	RowLabel(ConfigNameRow, "LBL_CONFIGNAME")
	local ConfigNameBox = New("TextBox", ConfigNameRow, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(180, 26),
		BackgroundColor3 = "@Background",
		BorderSizePixel = 0,
		Text = "",
		PlaceholderText = "PH_CONFIGNAME",
		PlaceholderColor3 = "@Muted",
		TextColor3 = "@Text",
		Font = Enum.Font.Code,
		TextSize = 11,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	Locale.Bind(ConfigNameBox, "PH_CONFIGNAME", "PlaceholderText")
	Round(ConfigNameBox, 6)
	New("UIStroke", ConfigNameBox, {Color = "@Border", Thickness = 1})
	New("UIPadding", ConfigNameBox, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})

	local ConfigStringLabel = Row(SettingsPage, 20)
	ConfigStringLabel.BackgroundTransparency = 1
	local ConfigStringLabelText = New("TextLabel", ConfigStringLabel, {
		Position = UDim2.fromOffset(2, 0),
		Size = UDim2.new(1, -4, 1, 0),
		BackgroundTransparency = 1,
		Text = "LBL_CONFIGSTRING",
		TextColor3 = "@SubText",
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	Locale.Bind(ConfigStringLabelText, "LBL_CONFIGSTRING")

	local ConfigBox = TextField(SettingsPage, "PH_CONFIGSTRING", 60)

	local function SerializeConfig()
		local parts = {}
		for key, value in pairs(S) do
			local kind = type(value)
			if kind == "boolean" then
				table.insert(parts, key .. "=" .. (value and "1" or "0"))
			elseif kind == "number" or kind == "string" then
				table.insert(parts, key .. "=" .. tostring(value))
			end
		end
		table.sort(parts)
		local body = table.concat(parts, ";")
		local themeParts = {}
		for _, key in ipairs(ThemeKeys) do
			local color = Themes.Custom[key]
			table.insert(themeParts, key .. ":" .. math.floor(color.R * 255) .. "," .. math.floor(color.G * 255) .. "," .. math.floor(color.B * 255))
		end
		return body .. "||" .. table.concat(themeParts, ";")
	end

	local function DeserializeConfig(text)
		local applied = 0
		local body, themePart = string.match(text, "^(.-)||(.*)$")
		body = body or text
		for pair in string.gmatch(body, "[^;]+") do
			local key, raw = string.match(pair, "^(.-)=(.*)$")
			if key and raw and S[key] ~= nil and key ~= "WorldPreset" then
				local current = S[key]
				local newValue = raw
				if type(current) == "boolean" then
					newValue = raw == "1"
				elseif type(current) == "number" then
					newValue = tonumber(raw)
				end
				if newValue ~= nil then
					SetValue(key, newValue)
					applied += 1
				end
			end
		end
		if themePart then
			for entry in string.gmatch(themePart, "[^;]+") do
				local key, r, g, b = string.match(entry, "^(.-):(%d+),(%d+),(%d+)$")
				if key and Themes.Custom[key] then
					Themes.Custom[key] = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
					applied += 1
				end
			end
			if Prefs.Theme == "Custom" then
				ApplyTheme()
			end
			for _, refresh in ipairs(Refreshers) do
				refresh()
			end
		end
		return applied
	end

	Action(SettingsPage, "BTN_EXPORT", function()
		ConfigBox.Text = SerializeConfig()
		Notify(Locale.T("TOAST_EXPORTED"))
	end)

	Action(SettingsPage, "BTN_IMPORT", function()
		local ok, applied = pcall(DeserializeConfig, ConfigBox.Text)
		if ok and applied and applied > 0 then
			Notify(string.format(Locale.T("TOAST_IMPORTED"), applied))
		else
			Notify(Locale.T("TOAST_IMPORTFAIL"))
		end
	end)

	Action(SettingsPage, "BTN_SAVE", function()
		local name = SanitizeFileName(ConfigNameBox.Text)
		if not name then
			Notify(Locale.T("TOAST_SAVEFAIL"))
			return
		end
		if not EnsureFolder() then
			Notify(Locale.T("TOAST_SAVEFAIL"))
			return
		end
		local ok = pcall(function()
			writefile(CONFIG_FOLDER .. "/" .. name .. ".cfg", SerializeConfig())
		end)
		if ok then
			Notify(string.format(Locale.T("TOAST_SAVED"), name))
		else
			Notify(Locale.T("TOAST_SAVEFAIL"))
		end
	end)

	Action(SettingsPage, "BTN_LOAD", function()
		local name = SanitizeFileName(ConfigNameBox.Text)
		if not name then
			Notify(Locale.T("TOAST_LOADFAIL"))
			return
		end
		local path = CONFIG_FOLDER .. "/" .. name .. ".cfg"
		local ok, content = pcall(function()
			if not isfile(path) then
				error("missing")
			end
			return readfile(path)
		end)
		if not ok then
			Notify(Locale.T("TOAST_LOADFAIL"))
			return
		end
		local applyOk, applied = pcall(DeserializeConfig, content)
		if applyOk and applied and applied > 0 then
			Notify(string.format(Locale.T("TOAST_LOADED_FILE"), name, applied))
		else
			Notify(Locale.T("TOAST_IMPORTFAIL"))
		end
	end)

	local SavedListLabelRow = Row(SettingsPage, 20)
	SavedListLabelRow.BackgroundTransparency = 1
	local SavedListLabel = New("TextLabel", SavedListLabelRow, {
		Position = UDim2.fromOffset(2, 0),
		Size = UDim2.new(1, -4, 1, 0),
		BackgroundTransparency = 1,
		Text = "LBL_SAVEDCONFIGS",
		TextColor3 = "@SubText",
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	Locale.Bind(SavedListLabel, "LBL_SAVEDCONFIGS")

	local SavedListRow = Row(SettingsPage, 70)
	local SavedListText = New("TextLabel", SavedListRow, {
		Position = UDim2.fromOffset(14, 8),
		Size = UDim2.new(1, -28, 1, -16),
		BackgroundTransparency = 1,
		Text = "-",
		TextColor3 = "@SubText",
		Font = Enum.Font.Code,
		TextSize = 11,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	})

	local function RefreshConfigList()
		local names = ListConfigs()
		if #names == 0 then
			SavedListText.Text = Locale.T("TOAST_NOFOLDER")
		else
			SavedListText.Text = table.concat(names, ", ")
		end
	end

	Action(SettingsPage, "BTN_REFRESH", RefreshConfigList)
	RefreshConfigList()

	Action(SettingsPage, "BTN_RESET", function()
		for key, value in pairs(Defaults) do
			SetValue(key, value)
		end
		Notify(Locale.T("TOAST_DEFAULTS"))
	end)

	Section(SettingsPage, "SEC_SCRIPT")

	local function SetMenu(state)
		if MenuState.Open == state then
			return
		end
		MenuState.Open = state
		if state then
			Root.Visible = true
			Tween(RootScale, {Scale = S.UIScale}, 0.32, Enum.EasingStyle.Back)
			Tween(Root, {GroupTransparency = S.UIOpacity}, 0.22)
		else
			Tween(RootScale, {Scale = S.UIScale * 0.94}, 0.2)
			Tween(Root, {GroupTransparency = 1}, 0.2)
			task.delay(0.22, function()
				if not MenuState.Open then
					Root.Visible = false
				end
			end)
		end
	end

	Hooks.UIScale = function(value)
		if MenuState.Open then
			Tween(RootScale, {Scale = value}, 0.1)
		end
	end

	Hooks.UIOpacity = function(value)
		if MenuState.Open then
			Tween(Root, {GroupTransparency = value}, 0.1)
		end
	end

	local function Unload()
		if Unloaded then
			return
		end
		Unloaded = true
		pcall(function()
			RunService:UnbindFromRenderStep("VortexAim")
		end)
		for _, connection in ipairs(Conns) do
			connection:Disconnect()
		end
		table.clear(Conns)
		Freecam.Stop()
		Fly.Stop()
		for part in pairs(Noclip.Parts) do
			if part.Parent then
				part.CanCollide = true
			end
		end
		table.clear(Noclip.Parts)
		table.clear(Noclip.BaseParts)
		local humanoid = GetHumanoid()
		if humanoid then
			if Applied.Speed then
				humanoid.WalkSpeed = Applied.WalkSpeed
			end
			if Applied.Jump then
				humanoid.UseJumpPower = Applied.UseJumpPower
				humanoid.JumpPower = Applied.JumpPower
			end
		end
		World.Restore()
		for player in pairs(Entries) do
			RemoveEntry(player)
		end
		GlowTween:Cancel()
		table.clear(Refreshers)
		table.clear(Locale.Registry)
		table.clear(Locale.Listeners)
		Overlay:Destroy()
		MenuGui:Destroy()
	end

	Action(SettingsPage, "BTN_UNLOAD", Unload)

	Connect(HideButton.MouseButton1Click, function()
		SetMenu(false)
	end)
	Connect(HideButton.MouseEnter, function()
		Tween(HideButton, {BackgroundColor3 = Theme.Border}, 0.12)
	end)
	Connect(HideButton.MouseLeave, function()
		Tween(HideButton, {BackgroundColor3 = Theme.Row}, 0.12)
	end)

	Connect(TopBar.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			MenuState.Dragging = true
			MenuState.DragStart = Vector2.new(input.Position.X, input.Position.Y)
			MenuState.Origin = Root.Position
		end
	end)

	Connect(UserInputService.InputChanged, function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end
		if MenuState.Dragging then
			local delta = Vector2.new(input.Position.X, input.Position.Y) - MenuState.DragStart
			local origin = MenuState.Origin
			Root.Position = UDim2.new(
				origin.X.Scale,
				origin.X.Offset + delta.X,
				origin.Y.Scale,
				origin.Y.Offset + delta.Y
			)
		end
		if Drag.Update then
			Drag.Update(input.Position.X)
		end
	end)

	Connect(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			MenuState.Dragging = false
			Drag.Update = nil
		end
	end)

	Connect(UserInputService.InputBegan, function(input, processed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Combat.LastFire = os.clock()
		end
		if Listening then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				local code = input.KeyCode
				if code == Enum.KeyCode.Escape then
					code = Enum.KeyCode.Unknown
				end
				if not (Listening.Key == "Menu" and code == Enum.KeyCode.Unknown) then
					K[Listening.Key] = code
				end
				Listening.Button.Text = KeyName(K[Listening.Key])
				if Listening.Key == "Menu" then
					Hint.Text = Locale.T("MENU_KEY") .. "  " .. KeyName(K.Menu)
				end
				Listening = nil
			end
			return
		end
		if processed or input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end
		if input.KeyCode == Enum.KeyCode.Unknown then
			return
		end
		if input.KeyCode == K.Menu then
			SetMenu(not MenuState.Open)
			return
		end
		for _, key in ipairs(BindOrder) do
			if K[key] == input.KeyCode then
				SetValue(key, not S[key])
				Notify(Locale.T(BindNameKeys[key]) .. ": " .. (S[key] and "ON" or "OFF"))
			end
		end
	end)

	Connect(UserInputService.JumpRequest, function()
		if S.InfJumpEnabled then
			local humanoid = GetHumanoid()
			if humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end)

	Connect(RunService.Stepped, function()
		local character = LocalPlayer.Character
		if S.NoclipEnabled and character then
			local now = os.clock()
			if Noclip.Character ~= character or now >= Noclip.Next then
				Noclip.Character = character
				Noclip.Next = now + 0.5
				table.clear(Noclip.BaseParts)
				for _, part in ipairs(character:GetDescendants()) do
					if part:IsA("BasePart") then
						table.insert(Noclip.BaseParts, part)
					end
				end
			end
			for _, part in ipairs(Noclip.BaseParts) do
				if part.Parent and part.CanCollide then
					Noclip.Parts[part] = true
					part.CanCollide = false
				end
			end
		elseif not S.NoclipEnabled and next(Noclip.Parts) then
			for part in pairs(Noclip.Parts) do
				if part.Parent then
					part.CanCollide = true
				end
			end
			table.clear(Noclip.Parts)
			table.clear(Noclip.BaseParts)
			Noclip.Character = nil
		end
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			NewEntry(player)
		end
	end

	Connect(Players.PlayerAdded, function(player)
		if player ~= LocalPlayer then
			NewEntry(player)
		end
	end)

	Connect(Players.PlayerRemoving, function(player)
		RemoveEntry(player)
	end)

	RunService:BindToRenderStep("VortexAim", Enum.RenderPriority.Camera.Value + 1, function(dt)
		if Unloaded then
			return
		end
		Camera = Workspace.CurrentCamera or Camera
		Aim.Update(dt)
		Trigger.Update()
	end)

	Connect(RunService.RenderStepped, function(dt)
		if Unloaded then
			return
		end
		Camera = Workspace.CurrentCamera or Camera
		Freecam.Update(dt)
		World.Update(dt)
		Fly.Update()
		UpdateMovement()
		UpdateOverlay(dt)
		UpdateProfile(dt)
	end)

	Hint.Text = Locale.T("MENU_KEY") .. "  " .. KeyName(K.Menu)
	Locale.OnChange(function()
		Hint.Text = Locale.T("MENU_KEY") .. "  " .. KeyName(K.Menu)
	end)

	SelectTab("AIMBOT")
	Tween(RootScale, {Scale = S.UIScale}, 0.4, Enum.EasingStyle.Back)
	Tween(Root, {GroupTransparency = S.UIOpacity}, 0.3)
	Notify(Locale.T("TOAST_LOADED"))
end

local function RunKeySystem(onSuccess)
	local gui = New("ScreenGui", PlayerGui, {
		Name = "VortexAuth",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 100,
	})

	local dim = New("Frame", gui, {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = true,
	})

	local card = New("CanvasGroup", gui, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(380, 310),
		BackgroundColor3 = "@Background",
		BorderSizePixel = 0,
		GroupTransparency = 1,
	})
	local scale = New("UIScale", card, {Scale = 0.9})
	Round(card, 14)
	local glow = GlowStroke(card)

	New("TextLabel", card, {
		Position = UDim2.fromOffset(0, 28),
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		Text = "VORTEX",
		TextColor3 = "@Text",
		Font = Enum.Font.GothamBold,
		TextSize = 26,
	})
	New("TextLabel", card, {
		Position = UDim2.fromOffset(0, 60),
		Size = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		Text = "SECURE ACCESS",
		TextColor3 = "@Accent",
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
	})

	local account = New("Frame", card, {
		Position = UDim2.fromOffset(30, 100),
		Size = UDim2.new(1, -60, 0, 40),
		BackgroundColor3 = "@Row",
		BorderSizePixel = 0,
	})
	Round(account, 8)
	New("TextLabel", account, {
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(0.4, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "ACCOUNT",
		TextColor3 = "@Muted",
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	New("TextLabel", account, {
		Position = UDim2.new(0.4, 0, 0, 0),
		Size = UDim2.new(0.6, -14, 1, 0),
		BackgroundTransparency = 1,
		Text = LocalPlayer.Name,
		TextColor3 = "@Text",
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})

	local inputRow = New("Frame", card, {
		Position = UDim2.fromOffset(30, 150),
		Size = UDim2.new(1, -60, 0, 40),
		BackgroundColor3 = "@Row",
		BorderSizePixel = 0,
	})
	Round(inputRow, 8)
	local inputStroke = New("UIStroke", inputRow, {Color = "@Border", Thickness = 1})
	local box = New("TextBox", inputRow, {
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(1, -28, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		PlaceholderText = "Enter access key",
		PlaceholderColor3 = "@Muted",
		TextColor3 = "@Text",
		Font = Enum.Font.GothamMedium,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
	})

	local button = New("TextButton", card, {
		Position = UDim2.fromOffset(30, 204),
		Size = UDim2.new(1, -60, 0, 40),
		BackgroundColor3 = "@Accent",
		Text = "AUTHORIZE",
		TextColor3 = "@Background",
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		AutoButtonColor = false,
		BorderSizePixel = 0,
	})
	Round(button, 8)

	local status = New("TextLabel", card, {
		Position = UDim2.fromOffset(30, 256),
		Size = UDim2.new(1, -60, 0, 30),
		BackgroundTransparency = 1,
		Text = "Enter your personal key",
		TextColor3 = "@SubText",
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextWrapped = true,
	})

	local success = Color3.fromRGB(90, 220, 140)
	local danger = Color3.fromRGB(255, 90, 100)
	local attempts = 0
	local locked = false
	local busy = false

	local function SetStatus(text, color)
		status.Text = text
		Tween(status, {TextColor3 = color}, 0.2)
	end

	local function Shake()
		for _, offset in ipairs({-10, 10, -6, 6, 0}) do
			card.Position = UDim2.new(0.5, offset, 0.5, 0)
			task.wait(0.045)
		end
	end

	local function Lock()
		locked = true
		task.spawn(function()
			for remaining = KeyConfig.LockSeconds, 1, -1 do
				if not gui.Parent then
					return
				end
				SetStatus("Too many attempts. Retry in " .. remaining .. "s", danger)
				task.wait(1)
			end
			if not gui.Parent then
				return
			end
			attempts = 0
			locked = false
			SetStatus("Enter your personal key", Theme.SubText)
		end)
	end

	local function Submit()
		if locked or busy then
			return
		end
		local input = string.match(box.Text, "^%s*(.-)%s*$")
		local ok, reason = Authorize(input)
		if ok then
			busy = true
			SetStatus("Access granted", success)
			Tween(button, {BackgroundColor3 = success}, 0.2)
			task.delay(0.6, function()
				Tween(card, {GroupTransparency = 1}, 0.3)
				Tween(scale, {Scale = 1.06}, 0.3)
				Tween(dim, {BackgroundTransparency = 1}, 0.3)
				task.delay(0.35, function()
					glow:Cancel()
					gui:Destroy()
					table.clear(Refreshers)
					onSuccess()
				end)
			end)
		else
			attempts += 1
			SetStatus(reason, danger)
			task.spawn(Shake)
			if attempts >= KeyConfig.MaxAttempts then
				Lock()
			end
		end
	end

	box.Focused:Connect(function()
		Tween(inputStroke, {Color = Theme.Accent}, 0.15)
	end)

	box.FocusLost:Connect(function(enterPressed)
		Tween(inputStroke, {Color = Theme.Border}, 0.15)
		if enterPressed then
			Submit()
		end
	end)

	button.MouseEnter:Connect(function()
		Tween(button, {BackgroundTransparency = 0.2}, 0.12)
	end)

	button.MouseLeave:Connect(function()
		Tween(button, {BackgroundTransparency = 0}, 0.12)
	end)

	button.MouseButton1Click:Connect(Submit)

	Tween(dim, {BackgroundTransparency = 0.45}, 0.4)
	Tween(card, {GroupTransparency = 0}, 0.35)
	Tween(scale, {Scale = 1}, 0.45, Enum.EasingStyle.Back)
end

RunKeySystem(LaunchHub)