-- movement: fly / walk speed / jump / inf jump / noclip / gravity / ctrl+click tp
-- roblox server checks catch speed, fly and noclip. kick or ban risk on the main, test on an alt
-- RSHIFT = menu, F = fly, END = unload

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local CONFIG_FILE = "Movement.json"

local DEFAULT = {
	flyOn = false, flySpeed = 120,
	speedOn = false, speed = 100,
	jumpOn = false, jump = 120,
	infJump = false,
	noclipOn = false,
	gravOn = false, grav = 50,
	ctpOn = false,
}
local S = {}
for k, v in pairs(DEFAULT) do S[k] = v end

local alive = true
local conns = {}
local function track(c)
	table.insert(conns, c)
	return c
end

local origGravity = workspace.Gravity
local hums = setmetatable({}, { __mode = "k" })   -- humanoid -> values before we touched them
local parts = setmetatable({}, { __mode = "k" })  -- part -> CanCollide before noclip
local flyActive, speedActive, jumpActive, gravActive = false, false, false, false
local lastErr = "-"

local function restoreParts()
	for p, v in pairs(parts) do
		pcall(function() p.CanCollide = v end)
		parts[p] = nil
	end
end

local function tick()
	local char = LP.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")

	-- gravity is global, not per character
	if S.gravOn then
		workspace.Gravity = S.grav
		gravActive = true
	elseif gravActive then
		gravActive = false
		workspace.Gravity = origGravity
	end

	-- noclip: CanCollide off on every part of the character
	if S.noclipOn and char then
		for _, p in ipairs(char:GetDescendants()) do
			if p:IsA("BasePart") then
				if parts[p] == nil then parts[p] = p.CanCollide end
				p.CanCollide = false
			end
		end
	elseif next(parts) ~= nil then
		restoreParts()
	end

	if not (hum and root) then return end

	local o = hums[hum]
	if not o then
		o = { walk = hum.WalkSpeed, jp = hum.JumpPower, useJP = hum.UseJumpPower }
		hums[hum] = o
	end

	-- fly: velocity on the root, camera-relative WASD, Space up, Shift down
	if S.flyOn then
		local cf = workspace.CurrentCamera.CFrame
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.yAxis end
		if dir.Magnitude > 0 then dir = dir.Unit end
		hum.PlatformStand = true
		root.AssemblyLinearVelocity = dir * S.flySpeed
		flyActive = true
	elseif flyActive then
		flyActive = false
		hum.PlatformStand = false
	end

	-- walk speed: re-applied every tick so the game can't reset it
	if S.speedOn and not S.flyOn then
		if hum.WalkSpeed ~= S.speed then hum.WalkSpeed = S.speed end
		speedActive = true
	elseif speedActive then
		speedActive = false
		hum.WalkSpeed = o.walk
	end

	if S.jumpOn then
		if not hum.UseJumpPower then hum.UseJumpPower = true end
		if hum.JumpPower ~= S.jump then hum.JumpPower = S.jump end
		jumpActive = true
	elseif jumpActive then
		jumpActive = false
		hum.UseJumpPower = o.useJP
		hum.JumpPower = o.jp
	end
end

track(RunService.Heartbeat:Connect(function()
	if not alive then return end
	local ok, err = pcall(tick)
	if not ok then lastErr = tostring(err) end
end))

-- infinite jump: kick the root's Y velocity on every jump request
track(UIS.JumpRequest:Connect(function()
	if not S.infJump or S.flyOn then return end
	local char = LP.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not (hum and root) or hum.Health <= 0 then return end
	hum:ChangeState(Enum.HumanoidStateType.Jumping)
	local v = root.AssemblyLinearVelocity
	root.AssemblyLinearVelocity = Vector3.new(v.X, S.jumpOn and S.jump or 50, v.Z)
end))

-- ctrl + click: raycast from the camera through the mouse, teleport above the hit point
track(UIS.InputBegan:Connect(function(i, gp)
	if gp or not S.ctpOn then return end
	if i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	if not UIS:IsKeyDown(Enum.KeyCode.LeftControl) then return end
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local cam = workspace.CurrentCamera
	if not (root and cam) then return end
	local m = UIS:GetMouseLocation()
	local ray = cam:ScreenPointToRay(m.X, m.Y)
	local rp = RaycastParams.new()
	rp.FilterType = Enum.RaycastFilterType.Exclude
	rp.FilterDescendantsInstances = { char }
	local hit = workspace:Raycast(ray.Origin, ray.Direction * 5000, rp)
	if hit then
		root.AssemblyLinearVelocity = Vector3.zero
		char:PivotTo(CFrame.new(hit.Position + Vector3.new(0, 3, 0)))
	end
end))

local function tpBy(offset)
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
		root.AssemblyLinearVelocity = Vector3.zero
		char:PivotTo(root.CFrame * offset)
	end
end

-- ui
local C = {
	bg = Color3.fromRGB(14, 14, 18),
	panel = Color3.fromRGB(24, 24, 31),
	row = Color3.fromRGB(32, 32, 42),
	acc = Color3.fromRGB(120, 92, 255),
	off = Color3.fromRGB(58, 58, 72),
	red = Color3.fromRGB(190, 50, 60),
	text = Color3.fromRGB(235, 235, 245),
	dim = Color3.fromRGB(150, 150, 165),
}

local function new(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props or {}) do o[k] = v end
	if parent then o.Parent = parent end
	return o
end
local function round(o, r)
	new("UICorner", { CornerRadius = UDim.new(0, r or 6) }, o)
	return o
end
local function fmt(v)
	if type(v) ~= "number" then return tostring(v) end
	if v == math.floor(v) then return tostring(math.floor(v)) end
	return string.format("%.1f", v)
end

local gui = new("ScreenGui", {
	Name = "Move_" .. HttpService:GenerateGUID(false):sub(1, 6),
	ResetOnSpawn = false,
	DisplayOrder = 999,
	IgnoreGuiInset = true,
	Enabled = true,
})
local okHui, hui = pcall(function() return gethui() end)
gui.Parent = (okHui and typeof(hui) == "Instance") and hui or CoreGui

local win = new("Frame", {
	Size = UDim2.fromOffset(470, 500),
	Position = UDim2.fromOffset(60, 120),
	BackgroundColor3 = C.bg,
	BorderSizePixel = 0,
	Active = true,
	Visible = true,
}, gui)
round(win, 10)
new("UIStroke", { Color = C.acc, Thickness = 1 }, win)

local bar = new("TextLabel", {
	Size = UDim2.new(1, 0, 0, 36),
	BackgroundColor3 = C.panel,
	BorderSizePixel = 0,
	Text = "  Movement   [RSHIFT]",
	TextColor3 = C.text,
	Font = Enum.Font.GothamBold,
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left,
}, win)
round(bar, 10)

-- drag: window and slider share one InputChanged / InputEnded pair
local dragStartMouse, dragStartPos = nil, nil
local sliderDrag = nil
track(UIS.InputChanged:Connect(function(i)
	if i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
	if dragStartMouse then
		local d = UIS:GetMouseLocation() - dragStartMouse
		win.Position = UDim2.fromOffset(dragStartPos.X + d.X, dragStartPos.Y + d.Y)
	end
	if sliderDrag then sliderDrag(i.Position.X) end
end))
track(UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragStartMouse = nil
		sliderDrag = nil
	end
end))
track(bar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragStartMouse = UIS:GetMouseLocation()
		dragStartPos = Vector2.new(win.AbsolutePosition.X, win.AbsolutePosition.Y)
	end
end))

local TABS = { "MOVE", "TELEPORT", "CONFIG" }
local tabRow = new("Frame", {
	Size = UDim2.new(1, -16, 0, 30),
	Position = UDim2.fromOffset(8, 42),
	BackgroundTransparency = 1,
}, win)
new("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	Padding = UDim.new(0, 4),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, tabRow)

local pages, tabBtns = {}, {}
local function showTab(name)
	for n, p in pairs(pages) do p.Visible = (n == name) end
	for n, b in pairs(tabBtns) do b.BackgroundColor3 = (n == name) and C.acc or C.row end
end
local function addTab(name)
	local b = new("TextButton", {
		Size = UDim2.new(1 / #TABS, -4, 1, 0),
		BackgroundColor3 = C.row,
		BorderSizePixel = 0,
		Text = name,
		TextColor3 = C.text,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		AutoButtonColor = false,
	}, tabRow)
	round(b, 6)
	local p = new("ScrollingFrame", {
		Size = UDim2.new(1, -16, 1, -84),
		Position = UDim2.fromOffset(8, 80),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false,
	}, win)
	new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, p)
	pages[name], tabBtns[name] = p, b
	track(b.MouseButton1Click:Connect(function() showTab(name) end))
	return p
end

local refreshers = {}
local function refreshAll()
	for _, f in ipairs(refreshers) do f() end
end

local function row(page, h)
	return new("Frame", {
		Size = UDim2.new(1, -6, 0, h),
		BackgroundColor3 = C.row,
		BorderSizePixel = 0,
	}, page)
end

local function section(page, text)
	new("TextLabel", {
		Size = UDim2.new(1, -6, 0, 20),
		BackgroundTransparency = 1,
		Text = text:upper(),
		TextColor3 = C.dim,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, page)
end

local function label(parent, text, pos, size)
	return new("TextLabel", {
		Position = pos or UDim2.fromOffset(10, 0),
		Size = size or UDim2.new(1, -110, 0, 30),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = C.text,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, parent)
end

local function toggle(page, text, key)
	local r = row(page, 32)
	label(r, text, nil, UDim2.new(1, -90, 1, 0))
	local b = new("TextButton", {
		Size = UDim2.fromOffset(60, 22),
		Position = UDim2.new(1, -70, 0.5, -11),
		BackgroundColor3 = C.off,
		BorderSizePixel = 0,
		Text = "OFF",
		TextColor3 = C.text,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		AutoButtonColor = false,
	}, r)
	round(b, 11)
	local function paint()
		b.Text = S[key] and "ON" or "OFF"
		b.BackgroundColor3 = S[key] and C.acc or C.off
	end
	track(b.MouseButton1Click:Connect(function()
		S[key] = not S[key]
		paint()
	end))
	table.insert(refreshers, paint)
	paint()
end

local function slider(page, text, key, lo, hi)
	local r = row(page, 52)
	label(r, text, UDim2.fromOffset(10, 4), UDim2.new(1, -110, 0, 20))
	local tb = new("TextBox", {
		Size = UDim2.fromOffset(84, 22),
		Position = UDim2.new(1, -94, 0, 4),
		BackgroundColor3 = C.off,
		BorderSizePixel = 0,
		TextColor3 = C.text,
		Font = Enum.Font.Code,
		TextSize = 12,
		ClearTextOnFocus = false,
		Text = "",
	}, r)
	round(tb, 5)
	local track2 = new("Frame", {
		Size = UDim2.new(1, -20, 0, 6),
		Position = UDim2.new(0, 10, 1, -16),
		BackgroundColor3 = C.off,
		BorderSizePixel = 0,
	}, r)
	round(track2, 3)
	local fill = new("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = C.acc,
		BorderSizePixel = 0,
	}, track2)
	round(fill, 3)

	local function paint()
		local v = S[key]
		tb.Text = fmt(v)
		fill.Size = UDim2.new(math.clamp((v - lo) / (hi - lo), 0, 1), 0, 1, 0)
	end
	local function set(v)
		S[key] = math.clamp(v, lo, hi)
		paint()
	end
	track(tb.FocusLost:Connect(function()
		local n = tonumber(tb.Text)
		if n then set(n) else paint() end
	end))
	track(track2.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			local function pick(x)
				set(lo + (hi - lo) * math.clamp((x - track2.AbsolutePosition.X) / track2.AbsoluteSize.X, 0, 1))
			end
			pick(i.Position.X)
			sliderDrag = pick
		end
	end))
	table.insert(refreshers, paint)
	paint()
end

local function button(page, text, cb)
	local b = new("TextButton", {
		Size = UDim2.new(1, -6, 0, 30),
		BackgroundColor3 = C.row,
		BorderSizePixel = 0,
		Text = text,
		TextColor3 = C.text,
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		AutoButtonColor = false,
	}, page)
	round(b, 6)
	track(b.MouseButton1Click:Connect(cb))
	return b
end

local function unload()
	if not alive then return end
	alive = false
	for k, v in pairs(S) do
		if type(v) == "boolean" then S[k] = false end
	end
	pcall(tick)
	restoreParts()
	workspace.Gravity = origGravity
	for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
	pcall(function() gui:Destroy() end)
end

-- config
local setStatus = function() end
local function saveCfg()
	if typeof(writefile) ~= "function" then return setStatus("no writefile in this executor") end
	local ok = pcall(writefile, CONFIG_FILE, HttpService:JSONEncode(S))
	setStatus(ok and ("saved " .. CONFIG_FILE) or "save failed")
end
local function loadCfg()
	if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then
		return setStatus("no readfile in this executor")
	end
	if not isfile(CONFIG_FILE) then return setStatus("no saved config") end
	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
	if not ok or type(data) ~= "table" then return setStatus("config broken") end
	for k, v in pairs(DEFAULT) do
		if type(data[k]) == type(v) then S[k] = data[k] end
	end
	refreshAll()
	setStatus("loaded " .. CONFIG_FILE)
end

-- tabs
local pMove = addTab("MOVE")
section(pMove, "fly  [F]")
toggle(pMove, "fly", "flyOn")
slider(pMove, "fly speed", "flySpeed", 10, 500)
section(pMove, "walk speed")
toggle(pMove, "walk speed", "speedOn")
slider(pMove, "walk speed", "speed", 16, 500)
section(pMove, "jump")
toggle(pMove, "jump power", "jumpOn")
slider(pMove, "jump power", "jump", 50, 500)
toggle(pMove, "infinite jump", "infJump")
section(pMove, "collision / world")
toggle(pMove, "noclip", "noclipOn")
toggle(pMove, "gravity", "gravOn")
slider(pMove, "gravity", "grav", 0, 196.2)

local pTp = addTab("TELEPORT")
section(pTp, "click teleport")
toggle(pTp, "ctrl + click to teleport", "ctpOn")
section(pTp, "relative")
button(pTp, "forward 30 studs", function() tpBy(CFrame.new(0, 0, -30)) end)
button(pTp, "up 100 studs", function() tpBy(CFrame.new(0, 100, 0)) end)

local pCfg = addTab("CONFIG")
section(pCfg, "status")
local statRow = row(pCfg, 96)
local statLbl = new("TextLabel", {
	Size = UDim2.new(1, -16, 1, -8),
	Position = UDim2.fromOffset(8, 4),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = C.text,
	Font = Enum.Font.Code,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
	TextWrapped = true,
}, statRow)
section(pCfg, "config")
local statusLbl = new("TextLabel", {
	Size = UDim2.new(1, -6, 0, 18),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = C.dim,
	Font = Enum.Font.Gotham,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
}, pCfg)
setStatus = function(t) statusLbl.Text = t end

button(pCfg, "save config", saveCfg)
button(pCfg, "load config", loadCfg)
button(pCfg, "reset to defaults", function()
	for k, v in pairs(DEFAULT) do S[k] = v end
	refreshAll()
	setStatus("defaults restored")
end)
button(pCfg, "unload (X / END)", unload)

local xBtn = new("TextButton", {
	Size = UDim2.fromOffset(36, 36),
	Position = UDim2.new(1, -36, 0, 0),
	BackgroundColor3 = C.red,
	BorderSizePixel = 0,
	Text = "X",
	TextColor3 = C.text,
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	AutoButtonColor = false,
}, bar)
round(xBtn, 10)
track(xBtn.MouseButton1Click:Connect(unload))

-- keys: RSHIFT menu (ignores gameProcessed, skipped only while typing in a box), F fly, END unload
local function toggleMenu()
	gui.Enabled = true
	win.Visible = not win.Visible
end

track(UIS.InputBegan:Connect(function(i, gp)
	if i.KeyCode == Enum.KeyCode.RightShift then
		if not UIS:GetFocusedTextBox() then toggleMenu() end
	elseif gp then
		return
	elseif i.KeyCode == Enum.KeyCode.End then
		unload()
	elseif i.KeyCode == Enum.KeyCode.F then
		S.flyOn = not S.flyOn
		refreshAll()
	end
end))

local function stat()
	local char = LP.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local nParts = 0
	for _ in pairs(parts) do nParts += 1 end
	return string.format(
		"walk %s   jump %s   gravity %s\n" ..
		"fly %s   walk %s   jump %s   inf jump %s\n" ..
		"noclip %s (%d parts)   ctrl tp %s\n" ..
		"character %s\n" ..
		"last error: %s",
		hum and fmt(hum.WalkSpeed) or "-", hum and fmt(hum.JumpPower) or "-", fmt(workspace.Gravity),
		S.flyOn and "on" or "off", S.speedOn and "on" or "off", S.jumpOn and "on" or "off", S.infJump and "on" or "off",
		S.noclipOn and "on" or "off", nParts, S.ctpOn and "on" or "off",
		char and "ok" or "none",
		lastErr:sub(1, 80)
	)
end

task.spawn(function()
	while alive do
		if statLbl.Parent then statLbl.Text = stat() end
		task.wait(0.5)
	end
end)

refreshAll()
showTab("MOVE")
print("Movement: loaded. RSHIFT = menu, F = fly, END / X = unload")
