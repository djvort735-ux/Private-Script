local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local CONFIG_FILE = "Vortex.json"
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
local function clone(v)
	if type(v) ~= "table" then return v end
	local t = {}
	for k, x in pairs(v) do t[k] = x end
	return t
end

-- every ore from ReplicatedStorage.Config.Ore.Show (Ore_N = model name in workspace.OreCache)
local ORES = {
	{ "Ore_1", "Stone", 8 }, { "Ore_2", "Copper", 14 }, { "Ore_3", "Jade", 21 }, { "Ore_4", "Silver", 35 },
	{ "Ore_5", "Quartz", 40 }, { "Ore_6", "Ruby", 55 }, { "Ore_7", "Amethyst", 60 }, { "Ore_8", "Nova Ore", 82 },
	{ "Ore_9", "Fire Crystal", 125 }, { "Ore_10", "Sapphire", 150 }, { "Ore_11", "Obsidian", 175 }, { "Ore_12", "Gold", 200 },
	{ "Ore_13", "Mystic Crystal", 225 }, { "Ore_14", "Topaz", 777 }, { "Ore_15", "Sunfire Ore", 932 }, { "Ore_16", "Crimson", 1120 },
	{ "Ore_17", "Emerald", 1340 }, { "Ore_18", "Diamond", 1610 }, { "Ore_19", "Frostbite", 1930 }, { "Ore_20", "Arcane", 2320 },
	{ "Ore_21", "Bone Ore", 2780 }, { "Ore_22", "Amber", 3531 }, { "Ore_23", "Plasma Core", 4823 }, { "Ore_24", "Void Shard", 5524 },
	{ "Ore_25", "Demon Eye", 6120 }, { "Ore_26", "Magma Cluster", 6950 }, { "Ore_27", "Abyssal Blue", 7230 }, { "Ore_28", "Acid Crystal", 7990 },
	{ "Ore_29", "Toxic Shard", 8250 }, { "Ore_30", "Solar Flare", 9100 }, { "Ore_31", "Omni", 11200 }, { "Ore_32", "Dark Matter", 12528 },
	{ "Ore_33", "Void Core", 13420 }, { "Ore_34", "Cryo-Stasis", 14555 }, { "Ore_35", "Ignis Totem", 16230 }, { "Ore_36", "Sunstone", 18800 },
	{ "Ore_37", "Toxic", 21000 }, { "Ore_38", "Glitch", 23250 }, { "Ore_39", "Prism", 25539 }, { "Ore_40", "Colanite", 27980 },
	{ "Ore_41", "Yeti-Claw", 30000 }, { "Ore_42", "Glac-Box", 32420 }, { "Ore_43", "Toxium", 36732 }, { "Ore_44", "Rust-Sludge", 42000 },
	{ "Ore_45", "Magmacore", 47000 }, { "Ore_46", "Bussin-Ice", 53200 }, { "Ore_47", "Panic-Core", 60000 }, { "Ore_48", "The Apex", 80000 },
}

-- sell price per ore: Config.Ore.Config[id].Price (what AnyHelper.GetSellPrice returns, what the billboard shows)
local ORE_PRICE = {}
for _, o in ipairs(ORES) do ORE_PRICE[o[1]] = o[3] end
local function fmtPrice(v)
	if v >= 1e6 then return string.format("%.2fM", v / 1e6) end
	if v >= 1e3 then return string.format("%.2fK", v / 1e3) end
	return tostring(math.floor(v))
end
local TAB_COUNT = 6

-- settings (live, saved to json)
local S = {
	dmgOn = false, dmgMult = 1e6,
	crit = false,
	defOn = false, defMult = 50,
	auraOn = false, auraRange = 60, auraDmg = 1e12, auraRate = 0.1,
	atkOn = false, atkRate = 0.1,
	freezeOn = false, freezeRange = 60,
	trainAuto = false, trainArea = 9, trainTp = true, trainAtk = true, -- 9 = Train_9 (throne)
	trainClickOn = false, trainBurst = 200, trainFetch = 4, trainDelay = 0,
	trainDisp = false, trainDispMult = 1e6,
	espOn = false,
	flyOn = false, flySpeed = 120,
	speedOn = false, speed = 100,
	jumpOn = false, jump = 120,
	noclipOn = false,
	oreTpOn = false, oreSel = {}, oreFarmBatch = 8, oreFarmRate = 0.1, oreForce = true, oreDirect = false,
	auraServer = true, auraDummies = true, auraSkill = "K_Skill_1001",
	logRemotes = false,
}
local DEFAULT = {}
for k, v in pairs(S) do DEFAULT[k] = clone(v) end

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
-- trainArea > 0 pins it to that one id (Train_9 = throne), no fallback
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
		lastErr = "area " .. tostring(S.trainArea) .. " not in workspace or every area is blocked"
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

	lastErr = "server refused area " .. tostring(candidates[1].id)
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

-- hit aura. targets come from CollectionService tags, not from one folder, so bosses and anything
-- outside EnemyFolder are included. the game's DamageUtils uses the same tags:
--   Enemy        client EnemyFolder: EnemyHitBE per target (same path as DamageManager)
--   EnemyServer  EnemyFolder_Server + bosses: one AttackEnemyServiceRE call, server does the damage
--   Dummy        train dummies: AttackDummyBE (client side, same as DamageUtils)
-- template copies in ReplicatedStorage carry the same tags, so only workspace instances count
local CollectionService = game:GetService("CollectionService")
local auraCount = { client = 0, server = 0, dummy = 0 }

local function auraTargets(pos)
	local out, seen = {}, {}
	local function add(tag, kind)
		for _, part in ipairs(CollectionService:GetTagged(tag)) do
			local m = part.Parent
			if part:IsDescendantOf(workspace) and m and m:IsA("Model")
				and not seen[m] and not m:GetAttribute("Dead") then
				seen[m] = true
				if (m:GetPivot().Position - pos).Magnitude <= S.auraRange then
					table.insert(out, { kind = kind, model = m })
				end
			end
		end
	end
	add("Enemy", "client")
	if S.auraServer then add("EnemyServer", "server") end
	if S.auraDummies then add("Dummy", "dummy") end
	return out
end

local function auraTick()
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local base = 1
	if mods.CU and mods.CU.CCPlrOnceDamage then
		local ok, v = pcall(mods.CU.CCPlrOnceDamage, LP)
		if ok and type(v) == "number" then base = v end
	end
	local dmg = S.auraDmg * base
	local targets = auraTargets(root.Position)
	auraCount.client, auraCount.server, auraCount.dummy = 0, 0, 0

	local hit = remoteOf("Attack", "EnemyHitBE", false)
	local serverU, dummies = {}, {}
	for _, t in ipairs(targets) do
		auraCount[t.kind] += 1
		if t.kind == "client" then
			if hit and hit:IsA("BindableEvent") then
				pcall(function() hit:Fire(t.model.Name, dmg, { IsCrit = true, Damage = dmg }) end)
			end
		elseif t.kind == "server" then
			table.insert(serverU, t.model.Name)
		else
			table.insert(dummies, t.model)
		end
	end

	-- SkillID is read as a string by the damage handlers, so it always has to be set
	local skill = (S.auraSkill ~= "" and S.auraSkill) or "K_Skill_1001"
	local data = { Phase = 1, SkillID = skill, Attacker = LP }

	if #serverU > 0 then
		local rf = remoteOf("Attack", "AttackEnemyServiceRE", true)
		if rf and rf:IsA("RemoteEvent") then
			pcall(function() rf:FireServer(serverU, data, workspace:GetServerTimeNow()) end)
		end
	end
	if #dummies > 0 then
		local b = remoteOf("Attack", "AttackDummyBE", false)
		if b and b:IsA("BindableEvent") then
			pcall(function() b:Fire(dummies, data) end)
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

-- noclip: CanCollide off on every part of the character. original values are kept and put back when it's off
local noclipOrig = setmetatable({}, { __mode = "k" })
local function noclipRestore()
	for p, v in pairs(noclipOrig) do
		pcall(function() p.CanCollide = v end)
		noclipOrig[p] = nil
	end
end

local function noclipTick()
	if not S.noclipOn then
		if next(noclipOrig) ~= nil then noclipRestore() end
		return
	end
	local char = LP.Character
	if not char then return end
	for _, p in ipairs(char:GetDescendants()) do
		if p:IsA("BasePart") then
			if noclipOrig[p] == nil then noclipOrig[p] = p.CanCollide end
			p.CanCollide = false
		end
	end
end

task.spawn(function()
	while alive do
		pcall(noclipTick)
		RunService.Heartbeat:Wait()
	end
end)

-- ore auto-farm. selected Ore_N models in workspace.OreCache get pulled onto you, then picked up.
-- A) registry found (OreUtils local table via getupvalues): entry.PPButtonCallback(LP, S.oreForce), the same
--    call the game makes on pickup (pack UI, sound, FlyToPlayer, PickupOreBE, GetOreRF).
--    S.oreDirect = true: our own GetOreRF + PickupOreBE, no fly animation.
-- B) no registry: the game's own auto-collect loop, switched on through the AutoCollect attribute.
--    needs no executor api, but it also grabs unselected ore inside 60 studs.
-- C) neither: getconnections on the prompt's Triggered, else fireproximityprompt.
-- oreLast = last GetOreRF reply (namecall hook below). oreErr = last error from a callback call.
local AUTOCOLLECT_RARITY = "Common"
local oreReg, oreRegAt, oreRegCount = nil, 0, 0
local oreNow, oreMatched, oreCalls = 0, 0, 0
local oreTier = { A = 0, B = 0, C = 0 }
local oreLast, oreErr = "-", "-"
local getconnFn = typeof(getconnections) == "function" and getconnections or nil
local fireprompt = typeof(fireproximityprompt) == "function" and fireproximityprompt or nil
local tierBDone = setmetatable({}, { __mode = "k" })
local oreRetry = setmetatable({}, { __mode = "k" })
local attrOn, attrSaved, attrChar = false, nil, nil

-- game's auto-collect listener captures the character when it opens, so it is re-opened after every respawn
local function setAttrCollect(on)
	if on then
		local char = LP.Character
		if attrOn and attrChar == char then return end
		if not attrOn then attrSaved = LP:GetAttribute("AutoCollect") end
		attrOn, attrChar = true, char
		LP:SetAttribute("AutoCollect", nil)
		LP:SetAttribute("AutoCollect", AUTOCOLLECT_RARITY)
	elseif attrOn then
		attrOn = false
		LP:SetAttribute("AutoCollect", attrSaved)
	end
end

local function selHas()
	return next(S.oreSel) ~= nil
end

local function isOreEntry(v)
	return type(v) == "table" and rawget(v, "PPButtonCallback") ~= nil and rawget(v, "OreID") ~= nil
end

local function findOreRegistry(gc)
	if not getupFn then return nil end
	for _, f in ipairs(gc) do
		if type(f) == "function" then
			local ok, ups = pcall(getupFn, f)
			if ok and type(ups) == "table" then
				for _, u in pairs(ups) do
					if type(u) == "table" and not isOreEntry(u) then
						for _, e in pairs(u) do
							if isOreEntry(e) then return u end
						end
					end
				end
			end
		end
	end
	return nil
end

-- throttled: at most one getgc scan every 1.5s
local function refreshOreReg()
	if os.clock() - oreRegAt < 1.5 then return end
	oreRegAt = os.clock()
	if not getgcFn then return end
	local ok, gc = pcall(getgcFn, true)
	if ok and gc then oreReg = findOreRegistry(gc) or oreReg end
end

local function callEntry(e)
	oreCalls += 1
	local ok, err = pcall(e.PPButtonCallback, LP, S.oreForce)
	oreErr = ok and "-" or tostring(err)
end

local function collectOre(uuid, e, m)
	e.Collected = true
	oreTier.A += 1
	if S.oreDirect then
		task.spawn(function()
			local rf = remoteOf("Stage", "GetOreRF", true)
			local ok, res = false, "no GetOreRF"
			if rf and rf:IsA("RemoteFunction") then
				ok, res = pcall(function() return rf:InvokeServer(uuid, S.oreForce) end)
			end
			if ok and res ~= false then
				local pick = remoteOf("Stage", "PickupOreBE", false)
				if pick and pick:IsA("BindableEvent") then pcall(function() pick:Fire() end) end
				pcall(function() m:Destroy() end)
			else
				e.Collected = false
				oreRetry[m] = os.clock() + 1.5
			end
		end)
	else
		task.spawn(function() callEntry(e) end)
		-- the game removes the ore itself after the fly. still here after 4s = pickup didn't happen, retry later
		task.delay(4, function()
			if m.Parent then
				e.Collected = false
				oreRetry[m] = os.clock() + 1
			end
		end)
	end
end

local function collectViaCallback(pp, m)
	tierBDone[m] = true
	if not getconnFn then return false end
	local okc, conns = pcall(getconnFn, pp.Triggered)
	if not okc or type(conns) ~= "table" then return false end
	local called = false
	for _, c in ipairs(conns) do
		if type(c.Function) == "function" then
			called = true
			local fn = c.Function
			task.spawn(function()
				oreCalls += 1
				local ok, err = pcall(fn, LP, S.oreForce)
				oreErr = ok and "-" or tostring(err)
			end)
		end
	end
	if called then
		oreTier.B += 1
		oreLast = "callback"
	end
	return called
end

local function collectViaPrompt(pp)
	if not fireprompt then return false end
	oreTier.C += 1
	oreLast = "prompt"
	local ok, err = pcall(fireprompt, pp)
	oreErr = ok and "-" or tostring(err)
	return true
end

local packText, packAt = "?", 0
local function readPack()
	if os.clock() - packAt < 2 then return packText end
	packAt = os.clock()
	local pg = LP:FindFirstChildOfClass("PlayerGui")
	if pg then
		for _, d in ipairs(pg:GetDescendants()) do
			if d:IsA("TextLabel") and d.Name == "Title" and d.Parent and d.Parent.Name == "OrePack" then
				packText = d.Text
				return packText
			end
		end
	end
	packText = "not found (GUI name differs)"
	return packText
end

local function oreDiagText()
	local cache = workspace:FindFirstChild("OreCache")
	local inCache, sel, value = 0, 0, 0
	if cache then
		for _, m in ipairs(cache:GetChildren()) do
			if m:IsA("Model") then
				inCache += 1
				if S.oreSel[m.Name] then
					sel += 1
					value += ORE_PRICE[m.Name] or 0
				end
			end
		end
	end
	local head = selHas() and "" or "!! SELECT AT LEAST ONE ORE TO START\n"
	return head .. string.format(
		"registry %s (%d entries)   attr %s   getconn %s   prompt %s\n" ..
		"cache %d   selected %d (value %s)   pulled %d   matched %d\n" ..
		"callbacks %d   tiers A %d  B %d  C %d\n" ..
		"last GetOreRF: %s\n" ..
		"last error: %s\n" ..
		"pack: %s",
		oreReg and "ok" or "none", oreRegCount, attrOn and "on" or "off",
		getconnFn and "ok" or "no", fireprompt and "ok" or "no",
		inCache, sel, fmtPrice(value), oreNow, oreMatched,
		oreCalls, oreTier.A, oreTier.B, oreTier.C,
		oreLast:sub(1, 80), oreErr:sub(1, 120),
		readPack()
	)
end

local function oreTick()
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local cache = workspace:FindFirstChild("OreCache")
	oreNow, oreMatched = 0, 0
	if not (S.oreTpOn and selHas()) then
		setAttrCollect(false)
		return
	end
	if not (root and cache) then return end
	if not oreReg then refreshOreReg() end
	local attrMode = oreReg == nil and oreRegAt > 0
	setAttrCollect(attrMode)

	local byModel, entries = {}, 0
	if oreReg then
		for uuid, e in pairs(oreReg) do
			if isOreEntry(e) and e.Model then
				entries += 1
				byModel[e.Model] = { uuid = uuid, e = e }
			end
		end
		oreRegCount = entries
	end

	local base = root.Position + Vector3.new(0, 3, 0)
	local unmatched, done = false, 0
	for _, m in ipairs(cache:GetChildren()) do
		if m:IsA("Model") and S.oreSel[m.Name] and m.PrimaryPart then
			oreNow += 1
			local a = oreNow * 2.4
			local r = 1.5 + (oreNow % 4) * 1.2
			m:PivotTo(CFrame.new(base + Vector3.new(math.cos(a) * r, 0, math.sin(a) * r)))
			m.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
			m.PrimaryPart.AssemblyAngularVelocity = Vector3.zero

			if not attrMode and done < S.oreFarmBatch and (oreRetry[m] or 0) <= os.clock() then
				local hit = byModel[m]
				if hit then
					oreMatched += 1
					if not hit.e.Collected then
						done += 1
						collectOre(hit.uuid, hit.e, m)
					end
				else
					if oreReg then unmatched = true end
					if not tierBDone[m] then
						local pp = m:FindFirstChildWhichIsA("ProximityPrompt", true)
						if pp then
							done += 1
							if not collectViaCallback(pp, m) then collectViaPrompt(pp) end
						end
					end
				end
			end
		end
	end
	if unmatched then refreshOreReg() end
end

task.spawn(function()
	while alive do
		pcall(oreTick)
		task.wait(S.oreFarmRate)
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
			print(string.format("[vortex.remote] %s:%s(%s)", self.Name, m, table.concat(parts, ", ")))
		end
		if typeof(self) == "Instance" and self.Name == "GetOreRF" and m == "InvokeServer" then
			local res = table.pack(oldNamecall(self, ...))
			oreLast = "GetOreRF -> " .. tostring(res[1])
			return table.unpack(res, 1, res.n)
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
gui.Name = "Vortex_" .. HttpService:GenerateGUID(false):sub(1, 8)
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
	Text = "  Vortex   [RSHIFT]",
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
		Size = UDim2.new(1 / TAB_COUNT, -4, 1, 0),
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

-- on/off button bound to any getter/setter (S[key], or an entry of a table like S.oreSel)
local function flagToggle(page, text, get, set)
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
		local on = get() and true or false
		b.Text = on and "ON" or "OFF"
		b.BackgroundColor3 = on and C.acc or C.off
	end
	b.MouseButton1Click:Connect(function()
		set(not get())
		paint()
	end)
	table.insert(refreshers, paint)
	paint()
end

local function toggle(page, text, key)
	flagToggle(page, text, function() return S[key] end, function(v) S[key] = v end)
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

-- text input bound to S[key] (used for the skill id)
local function textRow(page, text, key)
	local r = row(page, 32)
	label(r, text, nil, UDim2.new(1, -150, 1, 0))
	local tb = new("TextBox", {
		Size = UDim2.fromOffset(136, 22),
		Position = UDim2.new(1, -144, 0.5, -11),
		BackgroundColor3 = C.off,
		BorderSizePixel = 0,
		TextColor3 = C.text,
		Font = Enum.Font.Code,
		TextSize = 12,
		ClearTextOnFocus = false,
		Text = "",
	}, r)
	round(tb, 5)
	local function paint() tb.Text = tostring(S[key] or "") end
	tb.FocusLost:Connect(function()
		if tb.Text ~= "" then S[key] = tb.Text end
		paint()
	end)
	table.insert(refreshers, paint)
	paint()
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
section(pCombat, "hit aura (all creatures: enemies, server mobs, bosses)")
toggle(pCombat, "aura on", "auraOn")
toggle(pCombat, "server mobs + bosses", "auraServer")
toggle(pCombat, "train dummies", "auraDummies")
textRow(pCombat, "skill id (server hits)", "auraSkill")
number(pCombat, "range (studs)", "auraRange", 5, 500, false)
presetRow(pCombat, {
	{ name = "60", cb = function() S.auraRange = 60 end },
	{ name = "150", cb = function() S.auraRange = 150 end },
	{ name = "500", cb = function() S.auraRange = 500 end },
})
number(pCombat, "hit (x base)", "auraDmg", 1, 1e30, true)
number(pCombat, "tick (s)", "auraRate", 0.02, 1, true)
section(pCombat, "freeze enemies (local)")
toggle(pCombat, "freeze", "freezeOn")
number(pCombat, "freeze range", "freezeRange", 5, 500, false)
section(pCombat, "visuals")
toggle(pCombat, "enemy esp", "espOn")

local pTrain = addTab("TRAIN")
section(pTrain, "auto train (Train_9 = throne by default)")
toggle(pTrain, "auto train", "trainAuto")
number(pTrain, "area id (9 = throne, 0 = auto)", "trainArea", 0, 999, false)
presetRow(pTrain, {
	{ name = "throne (9)", cb = function() S.trainArea = 9 end },
	{ name = "auto (0)", cb = function() S.trainArea = 0 end },
})
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
section(pMove, "noclip")
toggle(pMove, "noclip", "noclipOn")
section(pMove, "fly")
toggle(pMove, "fly (WASD/Space/Shift)", "flyOn")
number(pMove, "fly speed", "flySpeed", 10, 500, false)
section(pMove, "walk / jump")
toggle(pMove, "walk speed", "speedOn")
number(pMove, "speed", "speed", 16, 500, false)
toggle(pMove, "jump power", "jumpOn")
number(pMove, "jump", "jump", 50, 500, false)

local pOre = addTab("ORE")
section(pOre, "auto-farm: pull selected ore to you, pick it up")
flagToggle(pOre, "ore auto-farm",
	function() return S.oreTpOn end,
	function(v)
		if v and not selHas() then return end
		S.oreTpOn = v
	end)
toggle(pOre, "force pickup (ignore pack)", "oreForce")
toggle(pOre, "direct pickup (no fly anim)", "oreDirect")
number(pOre, "collect per tick", "oreFarmBatch", 1, 50, false)
number(pOre, "tick (s)", "oreFarmRate", 0.05, 1, true)
local diagRow = row(pOre, 146)
local oreDiag = new("TextLabel", {
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
}, diagRow)
task.spawn(function()
	while alive do
		if oreDiag.Parent then oreDiag.Text = oreDiagText() end
		task.wait(0.5)
	end
end)
presetRow(pOre, {
	{ name = "select all", cb = function() for _, o in ipairs(ORES) do S.oreSel[o[1]] = true end end },
	{ name = "clear", cb = function() S.oreSel = {}; S.oreTpOn = false end },
})
section(pOre, "ore list (" .. #ORES .. ")")
for _, o in ipairs(ORES) do
	local id = o[1]
	flagToggle(pOre, o[2] .. "   " .. fmtPrice(o[3]) .. "   (" .. id .. ")",
		function() return S.oreSel[id] == true end,
		function(v) S.oreSel[id] = v or nil end)
end

local pConfig = addTab("CONFIG")
section(pConfig, "status")
local statRow = row(pConfig, 226)
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
	S.trainArea = 9
	S.trainClickOn, S.trainBurst, S.trainDelay = true, 2000, 0
	S.trainDisp, S.trainDispMult = true, 1e12
	S.oreTpOn = selHas()
	blockedUntil = {}
	refreshAll()
	setStatus("imba on. fly / speed / noclip stay off")
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
		if data[k] ~= nil and type(data[k]) == type(v) then S[k] = clone(data[k]) end
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
	for k, v in pairs(DEFAULT) do S[k] = clone(v) end
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
	pcall(noclipRestore)
	pcall(setAttrCollect, false)
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
	local selN = 0
	for _ in pairs(S.oreSel) do selN += 1 end
	local cache = workspace:FindFirstChild("OreCache")
	local cacheN = cache and #cache:GetChildren() or 0
	return string.format(
		"power %s   level %s   weapon %s\n" ..
		"clicks/s %s   power/s %s   total clicks %d\n" ..
		"pool %d   fetch threads busy %d   burst %s   delay %ss\n" ..
		"train auto %s   in area %s   server attr %s\n" ..
		"blocked areas: %s\n" ..
		"ore farm %s   selected %d   in cache %d   pulled %d   registry %s   getconn %s\n" ..
		"tiers A %d  B %d  C %d   last %s\n" ..
		"noclip %s   aura targets: client %d  server %d  dummy %d\n" ..
		"dmg x%s   defence x%s   crit %s   aura %s   atk %s   freeze %s (%d)   fly %s\n" ..
		"mods CU %s  ENC %s  hook %s  scans %d/25\n" ..
		"bind ATKOnceBE %s  EnemyHitBE %s  TrainOnceRE %s\n" ..
		"err %s",
		pw, lv, tostring(wt),
		fmtNum(math.floor(rates.clicksS)), fmtNum(math.floor(rates.powS)), clicks,
		#trainPool, fetching, fmtNum(S.trainBurst), tostring(S.trainDelay),
		S.trainAuto and "on" or "off", tostring(trainId or "-"), tostring(serverArea() or "-"),
		blockedList(),
		S.oreTpOn and "on" or "off", selN, cacheN, oreNow, oreReg and "ok" or "none", getconnFn and "ok" or "no",
		oreTier.A, oreTier.B, oreTier.C, oreLast:sub(1, 50),
		S.noclipOn and "on" or "off", auraCount.client, auraCount.server, auraCount.dummy,
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
print("Vortex: loaded. RIGHT SHIFT = menu, X / END = unload. CONFIG tab shows what's connected")
