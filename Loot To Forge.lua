-- dolp // kickvortex suite v7
-- executor. RIGHT SHIFT = menu, X or END = full unload.
-- no require(): executor context is CoreGui, game modules are blocked there.
-- actions go through the game's own bindables/remotes, so real kill/stage/train logic runs.
-- only CalculateUtils (damage numbers) and EncodingUtils (train list decode) come from gc.

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local CONFIG_FILE = "dolp_kickvortex.json"
local newcc = newcclosure or function(f) return f end

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
local function fmtNum(v)
	if type(v) ~= "number" then return tostring(v) end
	if v == math.floor(v) and math.abs(v) < 1e7 then return tostring(math.floor(v)) end
	return string.format("%.3g", v)
end
local function mul(on, m)
	if on then return m end
	return 1
end

-- settings (live, saved to json)
local S = {
	dmgOn = false, dmgMult = 1e6,
	crit = false,
	defOn = false, defMult = 50,
	auraOn = false, auraRange = 60, auraDmg = 1e12, auraRate = 0.1,
	atkOn = false, atkRate = 0.1,
	freezeOn = false, freezeRange = 60,
	trainAuto = false, trainArea = 0, trainTp = true, trainAtk = true,
	trainClickOn = false, trainBurst = 200, trainFetch = 4, trainDelay = 0,
	trainDisp = false, trainDispMult = 1e6,
	espOn = false,
	flyOn = false, flySpeed = 120,
	speedOn = false, speed = 100,
	jumpOn = false, jump = 120,
	logRemotes = false,
}
local DEFAULT = {}
for k, v in pairs(S) do DEFAULT[k] = v end

local alive = true
local conns = {}
local function track(c)
	table.insert(conns, c)
	return c
end

-- module discovery (gc only, bounded)
local mods = { CU = nil, ENC = nil }
local O = {}
local hooked = false
local scanTries = 0
local lastErr = nil

local getgcFn = typeof(getgc) == "function" and getgc or nil
local getupFn = (typeof(getupvalues) == "function" and getupvalues)
	or (debug and typeof(debug.getupvalues) == "function" and debug.getupvalues)
	or nil

local function scanFor(key, gc)
	for _, v in ipairs(gc) do
		if type(v) == "table" and rawget(v, key) ~= nil then return v end
	end
	if getupFn then
		for _, f in ipairs(gc) do
			if type(f) == "function" then
				local ok, ups = pcall(getupFn, f)
				if ok and type(ups) == "table" then
					for _, u in pairs(ups) do
						if type(u) == "table" and rawget(u, key) ~= nil then return u end
					end
				end
			end
		end
	end
	return nil
end

-- hooks on CalculateUtils. DamageManager / TrainCTRL index the table at call time, so swaps stick
local function hookCU(cu)
	O.plrDmg, O.onceDmg, O.defence = cu.CCPlrDamage, cu.CCPlrOnceDamage, cu.CCPlrDefence
	O.crit, O.trainPow = cu.CCCrit, cu.CCTrainOncePower
	cu.CCPlrDamage = function(plr, data) return O.plrDmg(plr, data) * mul(S.dmgOn, S.dmgMult) end
	cu.CCPlrOnceDamage = function(plr) return O.onceDmg(plr) * mul(S.dmgOn, S.dmgMult) end
	cu.CCPlrDefence = function(plr) return O.defence(plr) * mul(S.defOn, S.defMult) end
	cu.CCCrit = function(plr)
		if S.crit then return 1 end
		return O.crit(plr)
	end
	cu.CCTrainOncePower = function(plr) return O.trainPow(plr) * mul(S.trainDisp, S.trainDispMult) end
	mods.CU = cu
	hooked = true
end

local function restoreCU()
	local cu = mods.CU
	if not (cu and hooked) then return end
	cu.CCPlrDamage = O.plrDmg
	cu.CCPlrOnceDamage = O.onceDmg
	cu.CCPlrDefence = O.defence
	cu.CCCrit = O.crit
	cu.CCTrainOncePower = O.trainPow
	hooked = false
end

local function discover()
	if not getgcFn then
		lastErr = "executor has no getgc"
		return
	end
	local gc = getgcFn(true)
	if not mods.CU then
		local t = scanFor("CCPlrDamage", gc)
		if t then hookCU(t) end
	end
	if not mods.ENC then
		mods.ENC = scanFor("DecodeTable", gc)
	end
end

task.spawn(function()
	while alive and scanTries < 25 do
		if mods.CU and mods.ENC then break end
		scanTries += 1
		local ok, err = pcall(discover)
		if not ok then lastErr = tostring(err) end
		task.wait(4)
	end
end)

-- remotes and bindables: ReplicatedStorage.Remote.<Domain>[_Server].<Name>
local function remoteOf(domain, name, server)
	local f = RS:FindFirstChild("Remote")
	f = f and f:FindFirstChild(domain .. (server and "_Server" or ""))
	return f and f:FindFirstChild(name)
end

-- train pool: server-issued UUIDs, decoded with EncodingUtils. refilled by parallel requests
local trainPool = {}
local fetching = 0
local clicks = 0
local POOL_CAP = 20000

local function refillPool()
	if fetching > 0 or not mods.ENC or #trainPool >= POOL_CAP then return end
	local rf = remoteOf("Train", "InvokTrainDataListRF", true)
	if not (rf and rf:IsA("RemoteFunction")) then return end
	for _ = 1, math.floor(S.trainFetch) do
		fetching += 1
		task.spawn(function()
			local ok, raw = pcall(function() return rf:InvokeServer() end)
			if ok and raw then
				local okD, list = pcall(mods.ENC.DecodeTable, raw)
				if okD and list then
					for _, e in (list) do table.insert(trainPool, e) end
				end
			end
			fetching -= 1
		end)
	end
end

-- one burst: pops UUIDs from the pool and fires TrainOnceRE, no client throttle
local function fireBurst()
	local ev = remoteOf("Train", "TrainOnceRE", true)
	if not (ev and ev:IsA("RemoteEvent")) then return 0 end
	local n = math.floor(S.trainBurst)
	local sent = 0
	while sent < n do
		local e = table.remove(trainPool)
		if not e then break end
		pcall(function() ev:FireServer(e.UUID) end)
		sent += 1
	end
	if sent == 0 then refillPool() end
	clicks += sent
	return sent
end

-- train areas: workspace.CanAttackFolder.TrainArea.Train_<id>, highest id first
local function trainAreas()
	local ca = workspace:FindFirstChild("CanAttackFolder")
	local ta = ca and ca:FindFirstChild("TrainArea")
	local list = {}
	if ta then
		for _, c in ipairs(ta:GetChildren()) do
			local id = tonumber(c.Name:match("^Train_(%d+)$"))
			if id then table.insert(list, { id = id, inst = c }) end
		end
	end
	table.sort(list, function(a, b) return a.id > b.id end)
	return list
end

-- areas the server refused recently: id -> os.clock() when it may be tried again
local blockedUntil = {}
local inTrain, trainId, enterAt = false, nil, 0

local function serverArea()
	return LP:GetAttribute("AutoTrainAreaID")
end

local function fireExit(id)
	local ev = remoteOf("Train", "ExitAutoTrainRE", true)
	if ev and ev:IsA("RemoteEvent") and id then
		pcall(function() ev:FireServer(id) end)
	end
end

local function teleportTo(inst)
	local char = LP.Character
	if not (char and inst) then return end
	local target = inst:FindFirstChild("DUMMY", true) or inst
	pcall(function() char:PivotTo(target:GetPivot() * CFrame.new(0, 3, 8)) end)
end

-- walks candidate areas best-first. the server decides which one sticks (AutoTrainAreaID gets set)
-- a refused area is blocked for 60s and the next one is tried
local function enterTrain()
	enterAt = os.clock()
	local ev = remoteOf("Train", "IntoAutoTrainRE", true)
	if not (ev and ev:IsA("RemoteEvent")) then
		lastErr = "no IntoAutoTrainRE"
		return false
	end

	local areas = trainAreas()
	if #areas == 0 then
		lastErr = "no TrainArea found"
		return false
	end

	local candidates = {}
	if S.trainArea > 0 then
		for _, a in ipairs(areas) do
			if a.id == S.trainArea then table.insert(candidates, a) end
		end
	else
		for _, a in ipairs(areas) do
			if (blockedUntil[a.id] or 0) <= os.clock() then table.insert(candidates, a) end
		end
	end
	if #candidates == 0 then
		lastErr = "every area is blocked, wait 60s or pick an id"
		return false
	end

	if serverArea() ~= nil and trainId then
		fireExit(trainId)
		local t0 = os.clock()
		repeat task.wait(0.1) until serverArea() == nil or os.clock() - t0 > 1.5
	end

	for _, a in ipairs(candidates) do
		ev:FireServer(a.id)
		local t0 = os.clock()
		repeat task.wait(0.1) until serverArea() ~= nil or os.clock() - t0 > 1.5
		if serverArea() ~= nil then
			inTrain, trainId = true, a.id
			lastErr = nil
			if S.trainTp then teleportTo(a.inst) end
			return true
		end
		blockedUntil[a.id] = os.clock() + 60
	end

	lastErr = "server refused every candidate area"
	return false
end

local function exitTrain()
	if not inTrain then return end
	fireExit(trainId)
	inTrain, trainId = false, nil
end

-- train loop: area management + uncapped click bursts + optional attack
task.spawn(function()
	local lastAtk = 0
	while alive do
		if S.trainAuto then
			local lost = serverArea() == nil
			if os.clock() - enterAt > 3 and (not inTrain or lost) then
				pcall(enterTrain)
			end
		elseif inTrain then
			pcall(exitTrain)
		end

		if S.trainClickOn or S.trainAuto then
			if #trainPool < S.trainBurst * 2 then refillPool() end
			fireBurst()
		end

		if S.trainAuto and S.trainAtk and os.clock() - lastAtk >= 0.2 then
			lastAtk = os.clock()
			local b = remoteOf("Attack", "ATKOnceBE", false)
			if b and b:IsA("BindableEvent") then pcall(function() b:Fire() end) end
		end

		if S.trainDelay > 0 then
			task.wait(S.trainDelay)
		else
			RunService.Heartbeat:Wait()
		end
	end
end)

-- hit aura: fires EnemyHitBE exactly like DamageManager does on a real hit
local function auraTick()
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local folder = workspace:FindFirstChild("EnemyFolder")
	local hit = remoteOf("Attack", "EnemyHitBE", false)
	if not (root and folder and hit and hit:IsA("BindableEvent")) then return end
	local base = 1
	if mods.CU and mods.CU.CCPlrOnceDamage then
		local ok, v = pcall(mods.CU.CCPlrOnceDamage, LP)
		if ok and type(v) == "number" then base = v end
	end
	local dmg = S.auraDmg * base
	local pos = root.Position
	for _, m in ipairs(folder:GetChildren()) do
		if m:IsA("Model") and not m:GetAttribute("Dead") then
			if (m:GetPivot().Position - pos).Magnitude <= S.auraRange then
				pcall(function() hit:Fire(m.Name, dmg, { IsCrit = true, Damage = dmg }) end)
			end
		end
	end
end

task.spawn(function()
	while alive do
		if S.auraOn then pcall(auraTick) end
		task.wait(S.auraRate)
	end
end)

-- auto attack: fires ATKOnceBE, same bindable the LMB handler fires (client hitboxes run)
task.spawn(function()
	while alive do
		if S.atkOn then
			local b = remoteOf("Attack", "ATKOnceBE", false)
			if b and b:IsA("BindableEvent") then pcall(function() b:Fire() end) end
		end
		task.wait(S.atkRate)
	end
end)

-- freeze: anchors enemies in range locally and stops their walk speed
local frozen = {}
local function releaseFreeze(st)
	if st.part and st.part.Parent then pcall(function() st.part.Anchored = st.anchored end) end
	if st.hum and st.hum.Parent then pcall(function() st.hum.WalkSpeed = st.ws end) end
end

local function freezeTick()
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local folder = workspace:FindFirstChild("EnemyFolder")
	if S.freezeOn and folder and root then
		for _, m in ipairs(folder:GetChildren()) do
			if m:IsA("Model") and not frozen[m] and not m:GetAttribute("Dead") then
				if (m:GetPivot().Position - root.Position).Magnitude <= S.freezeRange then
					local part = m.PrimaryPart or m:FindFirstChild("HumanoidRootPart")
					local hum = m:FindFirstChildOfClass("Humanoid")
					if part then
						frozen[m] = { part = part, anchored = part.Anchored, hum = hum, ws = hum and hum.WalkSpeed }
						part.Anchored = true
						if hum then hum.WalkSpeed = 0 end
					end
				end
			end
		end
	end
	for m, st in pairs(frozen) do
		local dist = (m.Parent and root) and (m:GetPivot().Position - root.Position).Magnitude or math.huge
		if not S.freezeOn or not m.Parent or m:GetAttribute("Dead") or dist > S.freezeRange then
			releaseFreeze(st)
			frozen[m] = nil
		end
	end
end

task.spawn(function()
	while alive do
		pcall(freezeTick)
		task.wait(0.1)
	end
end)

-- fly: velocity on the root, WASD relative to camera, Space up, Shift down
local keys = {}
track(UIS.InputBegan:Connect(function(i, gp)
	if not gp then keys[i.KeyCode] = true end
end))
track(UIS.InputEnded:Connect(function(i) keys[i.KeyCode] = nil end))

local flyApplied = false
task.spawn(function()
	while alive do
		RunService.Heartbeat:Wait()
		if S.flyOn then
			local char = LP.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local cam = workspace.CurrentCamera
			if root and hum and cam then
				local dir = Vector3.zero
				local cf = cam.CFrame
				if keys[Enum.KeyCode.W] then dir += cf.LookVector end
				if keys[Enum.KeyCode.S] then dir -= cf.LookVector end
				if keys[Enum.KeyCode.D] then dir += cf.RightVector end
				if keys[Enum.KeyCode.A] then dir -= cf.RightVector end
				if keys[Enum.KeyCode.Space] then dir += Vector3.yAxis end
				if keys[Enum.KeyCode.LeftShift] then dir -= Vector3.yAxis end
				if dir.Magnitude > 0 then dir = dir.Unit end
				hum.PlatformStand = true
				root.AssemblyLinearVelocity = dir * S.flySpeed
				flyApplied = true
			end
		elseif flyApplied then
			local char = LP.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then hum.PlatformStand = false end
			flyApplied = false
		end
	end
end)

-- movement (walk speed / jump, skipped while flying)
local speedApplied, jumpApplied = false, false
task.spawn(function()
	while alive do
		local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		if hum and not S.flyOn then
			if S.speedOn then
				hum.WalkSpeed = S.speed
				speedApplied = true
			elseif speedApplied then
				hum.WalkSpeed = 16
				speedApplied = false
			end
			if S.jumpOn then
				hum.UseJumpPower = true
				hum.JumpPower = S.jump
				jumpApplied = true
			elseif jumpApplied then
				hum.JumpPower = 50
				jumpApplied = false
			end
		end
		task.wait(0.1)
	end
end)

-- enemy esp (local highlights)
local espMap = {}
local function espTick()
	local folder = workspace:FindFirstChild("EnemyFolder")
	for m, h in pairs(espMap) do
		if not S.espOn or not m.Parent or m.Parent ~= folder then
			pcall(function() h:Destroy() end)
			espMap[m] = nil
		end
	end
	if not (S.espOn and folder) then return end
	for _, m in ipairs(folder:GetChildren()) do
		if m:IsA("Model") and not espMap[m] then
			espMap[m] = new("Highlight", {
				Adornee = m,
				FillColor = Color3.fromRGB(255, 60, 60),
				OutlineColor = Color3.new(1, 1, 1),
				FillTransparency = 0.6,
				DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
			}, m)
		end
	end
end
task.spawn(function()
	while alive do
		pcall(espTick)
		task.wait(0.5)
	end
end)

-- remote logger: prints what goes to the server. after unload it passes calls straight through.
local oldNamecall
pcall(function()
	oldNamecall = hookmetamethod(game, "__namecall", newcc(function(self, ...)
		local m = getnamecallmethod()
		if alive and S.logRemotes and not checkcaller() and typeof(self) == "Instance"
			and (m == "FireServer" or m == "InvokeServer") then
			local args = { ... }
			local parts = {}
			for i = 1, math.min(#args, 4) do
				parts[i] = typeof(args[i]) == "table" and "{table}" or tostring(args[i])
			end
			print(string.format("[dolp.remote] %s:%s(%s)", self.Name, m, table.concat(parts, ", ")))
		end
		return oldNamecall(self, ...)
	end))
end)

-- rates for the status line: clicks/s and Eco.power/s
local rates = { clicksS = 0, powS = 0 }
task.spawn(function()
	local lastC, lastP, lastT = clicks, nil, os.clock()
	while alive do
		task.wait(0.5)
		local now = os.clock()
		local dt = math.max(now - lastT, 1e-3)
		rates.clicksS = (clicks - lastC) / dt
		lastC = clicks
		local eco = LP:FindFirstChild("Eco")
		local p = eco and eco:FindFirstChild("power")
		if p and type(p.Value) == "number" then
			if lastP then rates.powS = (p.Value - lastP) / dt end
			lastP = p.Value
		end
		lastT = now
	end
end)

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

local gui = Instance.new("ScreenGui")
gui.Name = "dolp_" .. HttpService:GenerateGUID(false):sub(1, 8)
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.IgnoreGuiInset = true
local okHui, hui = pcall(function() return gethui() end)
gui.Parent = (okHui and typeof(hui) == "Instance") and hui or CoreGui

local win = new("Frame", {
	Size = UDim2.fromOffset(470, 540),
	Position = UDim2.new(0, 60, 0.5, -270),
	BackgroundColor3 = C.bg,
	BorderSizePixel = 0,
	Active = true,
}, gui)
round(win, 10)
new("UIStroke", { Color = C.acc, Thickness = 1 }, win)

local bar = new("TextLabel", {
	Size = UDim2.new(1, 0, 0, 36),
	BackgroundColor3 = C.panel,
	BorderSizePixel = 0,
	Text = "  dolp // kickvortex   [RSHIFT]",
	TextColor3 = C.text,
	Font = Enum.Font.GothamBold,
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left,
}, win)
round(bar, 10)

local dragNodes = {}
track(UIS.InputChanged:Connect(function(i)
	for _, d in ipairs(dragNodes) do d.move(i) end
end))
track(UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		for _, d in ipairs(dragNodes) do d.stop() end
	end
end))

do
	local dragging, startMouse, startPos
	track(bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startMouse = UIS:GetMouseLocation()
			startPos = win.Position
		end
	end))
	table.insert(dragNodes, {
		move = function(i)
			if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
				local d = UIS:GetMouseLocation() - startMouse
				win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end,
		stop = function() dragging = false end,
	})
end

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
		Size = UDim2.new(0.2, -4, 1, 0),
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
		Size = UDim2.new(1, -16, 1, -88),
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
	b.MouseButton1Click:Connect(function() showTab(name) end)
	return p
end

local refreshers = {}

local function row(page, h)
	return new("Frame", {
		Size = UDim2.new(1, -6, 0, h),
		BackgroundColor3 = C.row,
		BorderSizePixel = 0,
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
	b.MouseButton1Click:Connect(function()
		S[key] = not S[key]
		paint()
	end)
	table.insert(refreshers, paint)
	paint()
end

local function number(page, text, key, lo, hi, isLog)
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
	local sbar = new("Frame", {
		Size = UDim2.new(1, -20, 0, 6),
		Position = UDim2.new(0, 10, 1, -16),
		BackgroundColor3 = C.off,
		BorderSizePixel = 0,
	}, r)
	round(sbar, 3)
	local fill = new("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = C.acc,
		BorderSizePixel = 0,
	}, sbar)
	round(fill, 3)

	local lh = isLog and math.log10(lo) or lo
	local hh = isLog and math.log10(hi) or hi
	local function toT(v)
		local x = isLog and math.log10(math.max(v, lo)) or v
		return math.clamp((x - lh) / (hh - lh), 0, 1)
	end
	local function fromT(t)
		local x = lh + t * (hh - lh)
		if isLog then return 10 ^ x end
		return x
	end
	local function paint()
		local v = S[key]
		tb.Text = fmtNum(v)
		fill.Size = UDim2.new(toT(v), 0, 1, 0)
	end
	local function set(v)
		S[key] = math.clamp(v, lo, hi)
		paint()
	end
	tb.FocusLost:Connect(function()
		local n = tonumber(tb.Text)
		if n then set(n) else paint() end
	end)

	local dragging = false
	local function fromMouse(x)
		set(fromT(math.clamp((x - sbar.AbsolutePosition.X) / sbar.AbsoluteSize.X, 0, 1)))
	end
	track(sbar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			fromMouse(i.Position.X)
		end
	end))
	table.insert(dragNodes, {
		move = function(i)
			if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
				fromMouse(i.Position.X)
			end
		end,
		stop = function() dragging = false end,
	})

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
	b.MouseButton1Click:Connect(cb)
	return b
end

local function refreshAll()
	for _, f in ipairs(refreshers) do f() end
end

-- preset row: several buttons in one line
local function presetRow(page, items)
	local r = row(page, 32)
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 4),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	}, r)
	for _, it in ipairs(items) do
		local b = new("TextButton", {
			Size = UDim2.new(1 / #items, -4, 0, 24),
			BackgroundColor3 = C.off,
			BorderSizePixel = 0,
			Text = it.name,
			TextColor3 = C.text,
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			AutoButtonColor = false,
		}, r)
		round(b, 5)
		b.MouseButton1Click:Connect(function()
			it.cb()
			refreshAll()
		end)
	end
end

-- tabs
local pDamage = addTab("DAMAGE")
section(pDamage, "multiplier")
toggle(pDamage, "damage multiplier", "dmgOn")
number(pDamage, "multiplier (x)", "dmgMult", 1, 1e30, true)
presetRow(pDamage, {
	{ name = "x100", cb = function() S.dmgOn, S.dmgMult = true, 1e2 end },
	{ name = "x1e3", cb = function() S.dmgOn, S.dmgMult = true, 1e3 end },
	{ name = "x1e6", cb = function() S.dmgOn, S.dmgMult = true, 1e6 end },
	{ name = "x1e9", cb = function() S.dmgOn, S.dmgMult = true, 1e9 end },
	{ name = "x1e12", cb = function() S.dmgOn, S.dmgMult = true, 1e12 end },
})
section(pDamage, "crit / defence")
toggle(pDamage, "always crit (x1.5 is game-side)", "crit")
toggle(pDamage, "defence override", "defOn")
number(pDamage, "defence (x)", "defMult", 1, 1e9, true)

local pCombat = addTab("COMBAT")
section(pCombat, "auto attack (real LMB path)")
toggle(pCombat, "auto attack", "atkOn")
number(pCombat, "rate (s)", "atkRate", 0.05, 2, true)
section(pCombat, "hit aura (real EnemyHitBE path)")
toggle(pCombat, "aura on", "auraOn")
number(pCombat, "range (studs)", "auraRange", 5, 500, false)
number(pCombat, "hit (x base)", "auraDmg", 1, 1e30, true)
number(pCombat, "tick (s)", "auraRate", 0.02, 1, true)
section(pCombat, "freeze enemies (local)")
toggle(pCombat, "freeze", "freezeOn")
number(pCombat, "freeze range", "freezeRange", 5, 500, false)
section(pCombat, "visuals")
toggle(pCombat, "enemy esp", "espOn")

local pTrain = addTab("TRAIN")
section(pTrain, "auto train (best accepted area)")
toggle(pTrain, "auto train", "trainAuto")
number(pTrain, "area id (0 = auto)", "trainArea", 0, 999, false)
toggle(pTrain, "teleport to area", "trainTp")
toggle(pTrain, "attack while training", "trainAtk")
section(pTrain, "clicks (no client limit)")
toggle(pTrain, "fast clicks", "trainClickOn")
number(pTrain, "burst per tick", "trainBurst", 1, 5000, true)
number(pTrain, "pool fetch threads", "trainFetch", 1, 16, false)
number(pTrain, "delay (s, 0 = per frame)", "trainDelay", 0, 1, false)
section(pTrain, "display")
toggle(pTrain, "train display x", "trainDisp")
number(pTrain, "display mult", "trainDispMult", 1, 1e30, true)
presetRow(pTrain, {
	{ name = "x100", cb = function() S.trainDisp, S.trainDispMult = true, 1e2 end },
	{ name = "x1e6", cb = function() S.trainDisp, S.trainDispMult = true, 1e6 end },
	{ name = "x1e12", cb = function() S.trainDisp, S.trainDispMult = true, 1e12 end },
})

local pMove = addTab("MOVE")
section(pMove, "fly")
toggle(pMove, "fly (WASD/Space/Shift)", "flyOn")
number(pMove, "fly speed", "flySpeed", 10, 500, false)
section(pMove, "walk / jump")
toggle(pMove, "walk speed", "speedOn")
number(pMove, "speed", "speed", 16, 500, false)
toggle(pMove, "jump power", "jumpOn")
number(pMove, "jump", "jump", 50, 500, false)

local pConfig = addTab("CONFIG")
section(pConfig, "status")
local statRow = row(pConfig, 170)
local statsLabel = new("TextLabel", {
	Size = UDim2.new(1, -16, 1, -8),
	Position = UDim2.fromOffset(8, 4),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = C.text,
	Font = Enum.Font.Code,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
}, statRow)
section(pConfig, "presets")
local status = new("TextLabel", {
	Size = UDim2.new(1, -6, 0, 18),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = C.dim,
	Font = Enum.Font.Gotham,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
}, pConfig)
local function setStatus(t) status.Text = t end

button(pConfig, "IMBA preset (everything on)", function()
	S.dmgOn, S.dmgMult, S.crit = true, 1e12, true
	S.defOn, S.defMult = true, 1e6
	S.auraOn, S.auraDmg, S.auraRange = true, 1e15, 150
	S.atkOn = true
	S.freezeOn, S.freezeRange = true, 150
	S.trainAuto, S.trainAtk, S.trainTp = true, true, true
	S.trainClickOn, S.trainBurst, S.trainDelay = true, 2000, 0
	S.trainDisp, S.trainDispMult = true, 1e12
	blockedUntil = {}
	refreshAll()
	setStatus("imba on. fly / speed stay off")
end)

section(pConfig, "config")
local function loadCfg()
	if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then
		return setStatus("no readfile in this executor")
	end
	if not isfile(CONFIG_FILE) then return setStatus("no saved config") end
	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
	if not ok or type(data) ~= "table" then return setStatus("config broken") end
	for k, v in pairs(DEFAULT) do
		if data[k] ~= nil and type(data[k]) == type(v) then S[k] = data[k] end
	end
	refreshAll()
	setStatus("loaded " .. CONFIG_FILE)
end

button(pConfig, "save config", function()
	if typeof(writefile) ~= "function" then return setStatus("no writefile in this executor") end
	local ok = pcall(writefile, CONFIG_FILE, HttpService:JSONEncode(S))
	setStatus(ok and ("saved " .. CONFIG_FILE) or "save failed")
end)
button(pConfig, "load config", loadCfg)
button(pConfig, "reset to defaults", function()
	for k, v in pairs(DEFAULT) do S[k] = v end
	refreshAll()
	setStatus("defaults restored")
end)
button(pConfig, "rescan modules", function()
	scanTries = 0
	local ok, err = pcall(discover)
	lastErr = ok and nil or tostring(err)
	setStatus(lastErr and ("rescan: " .. lastErr) or "rescan started")
end)
button(pConfig, "clear blocked areas + pool", function()
	blockedUntil = {}
	trainPool = {}
	setStatus("cleared")
end)

local function unload()
	if not alive then return end
	alive = false
	pcall(exitTrain)
	pcall(restoreCU)
	for m, st in pairs(frozen) do
		releaseFreeze(st)
		frozen[m] = nil
	end
	for m, h in pairs(espMap) do
		pcall(function() h:Destroy() end)
		espMap[m] = nil
	end
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		if speedApplied then pcall(function() hum.WalkSpeed = 16 end) end
		if jumpApplied then pcall(function() hum.JumpPower = 50 end) end
		if flyApplied then pcall(function() hum.PlatformStand = false end) end
	end
	for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
	pcall(function() gui:Destroy() end)
end

button(pConfig, "unload (X / END)", unload)

-- red X in the title bar
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
xBtn.MouseButton1Click:Connect(unload)

showTab("DAMAGE")

local function blockedList()
	local ids = {}
	for id, t in pairs(blockedUntil) do
		if t > os.clock() then table.insert(ids, tostring(id)) end
	end
	table.sort(ids)
	if #ids == 0 then return "none" end
	return table.concat(ids, ",")
end

local function statLine()
	local eco = LP:FindFirstChild("Eco")
	local pw, lv = "?", "?"
	if eco then
		local p, l = eco:FindFirstChild("power"), eco:FindFirstChild("level")
		if p then pw = fmtNum(p.Value) end
		if l then lv = fmtNum(l.Value) end
	end
	local function yn(x) if x then return "ok" end return ".." end
	local wt = LP:GetAttribute("WeaponType") or "none"
	local nFrozen = 0
	for _ in pairs(frozen) do nFrozen += 1 end
	return string.format(
		"power %s   level %s   weapon %s\nclicks/s %s   power/s %s   total clicks %d\npool %d   fetch threads busy %d   burst %s   delay %ss\ntrain auto %s   in area %s   server attr %s\nblocked areas: %s\ndmg x%s   defence x%s   crit %s   aura %s   atk %s   freeze %s (%d)   fly %s\nmods CU %s  ENC %s  hook %s  scans %d/25\nbind ATKOnceBE %s  EnemyHitBE %s  TrainOnceRE %s\nerr %s",
		pw, lv, tostring(wt),
		fmtNum(math.floor(rates.clicksS)), fmtNum(math.floor(rates.powS)), clicks,
		#trainPool, fetching, fmtNum(S.trainBurst), tostring(S.trainDelay),
		S.trainAuto and "on" or "off", tostring(trainId or "-"), tostring(serverArea() or "-"),
		blockedList(),
		fmtNum(mul(S.dmgOn, S.dmgMult)), fmtNum(mul(S.defOn, S.defMult)), S.crit and "on" or "off",
		S.auraOn and "on" or "off", S.atkOn and "on" or "off", S.freezeOn and "on" or "off", nFrozen,
		S.flyOn and "on" or "off",
		yn(mods.CU), yn(mods.ENC), hooked and "on" or "off", scanTries,
		yn(remoteOf("Attack", "ATKOnceBE", false)), yn(remoteOf("Attack", "EnemyHitBE", false)),
		yn(remoteOf("Train", "TrainOnceRE", true)),
		lastErr and tostring(lastErr):sub(1, 70) or "none"
	)
end

task.spawn(function()
	while alive do
		if statsLabel.Parent then statsLabel.Text = statLine() end
		task.wait(0.5)
	end
end)

-- RIGHT SHIFT toggles the menu, END unloads
track(UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.RightShift then
		win.Visible = not win.Visible
	elseif i.KeyCode == Enum.KeyCode.End then
		unload()
	end
end))

refreshAll()
print("dolp: loaded. RIGHT SHIFT = menu, X / END = unload. CONFIG tab shows what's connected")
