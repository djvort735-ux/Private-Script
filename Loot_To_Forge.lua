-- Vortex Loader | Script library
-- Remote scripts run with the executor's privileges. Only use scripts you trust and have reviewed.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

local CONFIG = {
    title = "Vortex Loader",
    subtitle = "SCRIPT LIBRARY",
    scripts = {
        {
            name = "Vortex Hub",
            cmd = "loadstring(game:HttpGet('https://raw.githubusercontent.com/djvort735-ux/Private-Script/main/old.lua'))()",
            desc = "free srcipt",
        },
        {
            name = "Loot To Forge",
            cmd = "loadstring(game:HttpGet('https://raw.githubusercontent.com/djvort735-ux/Private-Script/main/Loot_To_Forge.lua'))()",
            desc = "free script",
        },
        {
            name = "Coming soon",
            desc = "A new script is on the way",
            available = false,
        },
    },
}

local THEME = {
    bg = Color3.fromRGB(13, 15, 21),
    panel = Color3.fromRGB(19, 22, 30),
    panelRaised = Color3.fromRGB(23, 27, 37),
    panelHover = Color3.fromRGB(29, 34, 46),
    stroke = Color3.fromRGB(43, 49, 65),
    text = Color3.fromRGB(240, 242, 250),
    subtext = Color3.fromRGB(143, 151, 172),
    muted = Color3.fromRGB(98, 107, 128),
    accentA = Color3.fromRGB(104, 125, 245),
    accentB = Color3.fromRGB(132, 101, 224),
    ok = Color3.fromRGB(100, 207, 158),
    err = Color3.fromRGB(239, 112, 124),
}

local function make(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties) do
        object[key] = value
    end
    if parent then
        object.Parent = parent
    end
    return object
end

local function corner(parent, radius)
    return make("UICorner", {
        CornerRadius = UDim.new(0, radius),
    }, parent)
end

local function stroke(parent, color, thickness, transparency)
    return make("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
end

local function gradient(parent, firstColor, secondColor, rotation)
    return make("UIGradient", {
        Color = ColorSequence.new(firstColor, secondColor),
        Rotation = rotation or 0,
    }, parent)
end

local function tween(object, properties, duration)
    TweenService:Create(
        object,
        TweenInfo.new(duration or 0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    ):Play()
end

local function extractUrl(value)
    return value:match("https?://[^'\"%)%s]+")
end

local function runScript(entry, setStatus)
    if entry.available == false then
        setStatus("This script is coming soon", "idle")
        return false
    end

    local url = extractUrl(entry.cmd or entry.url or "")
    if not url then
        setStatus("No valid URL for " .. entry.name, "err")
        return false
    end

    setStatus("Fetching " .. entry.name .. "...", "idle")
    local fetchOk, source = pcall(game.HttpGet, game, url)
    if not fetchOk or type(source) ~= "string" or #source == 0 then
        setStatus("Couldn't fetch " .. entry.name, "err")
        return false
    end

    local compileOk, callback, compileError = pcall(loadstring, source)
    if not compileOk or type(callback) ~= "function" then
        setStatus("Compile error: " .. tostring(compileError or callback), "err")
        return false
    end

    local runOk, runtimeError = pcall(callback)
    if runOk then
        setStatus("Launched " .. entry.name, "ok")
        return true
    end

    setStatus("Runtime error: " .. tostring(runtimeError), "err")
    return false
end

local player = Players.LocalPlayer
if not player then
    return
end

-- Choose a supported UI parent without allowing a failed gethui call to stop the loader.
local guiParent
if typeof(gethui) == "function" then
    local getHuiOk, result = pcall(gethui)
    if getHuiOk and result then
        guiParent = result
    end
end
if not guiParent then
    guiParent = game:GetService("CoreGui")
end

local existing = guiParent:FindFirstChild("VortexLoaderGui")
if existing then
    existing:Destroy()
end

local screen = make("ScreenGui", {
    Name = "VortexLoaderGui",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 20,
}, nil)

if not pcall(function()
    screen.Parent = guiParent
end) then
    screen.Parent = player:WaitForChild("PlayerGui")
end

-- Main window
local main = make("Frame", {
    Name = "MainWindow",
    Size = UDim2.fromOffset(720, 430),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    BackgroundColor3 = THEME.bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, screen)
corner(main, 15)
stroke(main, THEME.stroke, 1, 0.08)

-- Header
local header = make("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 66),
    BackgroundColor3 = THEME.panel,
    BorderSizePixel = 0,
}, main)
corner(header, 15)
make("Frame", {
    Size = UDim2.new(1, 0, 0, 15),
    Position = UDim2.fromOffset(0, 51),
    BackgroundColor3 = THEME.panel,
    BorderSizePixel = 0,
}, header)

local logo = make("Frame", {
    Size = UDim2.fromOffset(38, 38),
    Position = UDim2.fromOffset(18, 14),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
}, header)
corner(logo, 11)
gradient(logo, THEME.accentA, THEME.accentB, 35)
make("TextLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "V",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 22,
}, logo)

make("TextLabel", {
    Size = UDim2.new(0, 300, 0, 24),
    Position = UDim2.fromOffset(68, 11),
    BackgroundTransparency = 1,
    Text = CONFIG.title,
    TextColor3 = THEME.text,
    Font = Enum.Font.GothamBold,
    TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left,
}, header)
make("TextLabel", {
    Size = UDim2.new(0, 300, 0, 15),
    Position = UDim2.fromOffset(69, 35),
    BackgroundTransparency = 1,
    Text = CONFIG.subtitle,
    TextColor3 = THEME.subtext,
    Font = Enum.Font.GothamMedium,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
}, header)

local sessionLabel = make("TextLabel", {
    Size = UDim2.new(0, 125, 0, 24),
    Position = UDim2.new(1, -169, 0, 21),
    BackgroundTransparency = 1,
    Text = "CLIENT SESSION",
    TextColor3 = THEME.muted,
    Font = Enum.Font.GothamMedium,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Right,
}, header)

local closeButton = make("TextButton", {
    Size = UDim2.fromOffset(28, 28),
    Position = UDim2.new(1, -42, 0, 19),
    BackgroundColor3 = THEME.panelRaised,
    Text = "×",
    TextColor3 = THEME.subtext,
    Font = Enum.Font.Gotham,
    TextSize = 20,
    AutoButtonColor = false,
    BorderSizePixel = 0,
}, header)
corner(closeButton, 8)
stroke(closeButton, THEME.stroke, 1, 0.2)
closeButton.MouseEnter:Connect(function()
    tween(closeButton, { BackgroundColor3 = THEME.err, TextColor3 = Color3.new(1, 1, 1) })
end)
closeButton.MouseLeave:Connect(function()
    tween(closeButton, { BackgroundColor3 = THEME.panelRaised, TextColor3 = THEME.subtext })
end)
closeButton.MouseButton1Click:Connect(function()
    screen:Destroy()
end)

local accentLine = make("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 1, -1),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
}, header)
gradient(accentLine, THEME.accentA, THEME.accentB, 0)

-- Drag support
local dragging = false
local dragStart
local startPosition
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

-- Profile sidebar
local sidebar = make("Frame", {
    Name = "ProfileSidebar",
    Size = UDim2.new(0, 196, 1, -66),
    Position = UDim2.fromOffset(0, 66),
    BackgroundColor3 = THEME.panel,
    BorderSizePixel = 0,
}, main)
corner(sidebar, 15)
make("Frame", {
    Size = UDim2.new(1, 0, 0, 16),
    BackgroundColor3 = THEME.panel,
    BorderSizePixel = 0,
}, sidebar)
make("Frame", {
    Size = UDim2.new(0, 1, 1, -24),
    Position = UDim2.new(1, -1, 0, 12),
    BackgroundColor3 = THEME.stroke,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
}, sidebar)

local avatar = make("ImageLabel", {
    Size = UDim2.fromOffset(68, 68),
    Position = UDim2.new(0.5, -34, 0, 20),
    BackgroundColor3 = THEME.panelRaised,
    BorderSizePixel = 0,
    ScaleType = Enum.ScaleType.Crop,
    Image = string.format("rbxthumb://type=AvatarBust&id=%d&w=420&h=420", player.UserId),
}, sidebar)
corner(avatar, 13)
stroke(avatar, THEME.stroke, 1, 0.05)

make("TextLabel", {
    Size = UDim2.new(1, -20, 0, 22),
    Position = UDim2.fromOffset(10, 96),
    BackgroundTransparency = 1,
    Text = player.DisplayName,
    TextColor3 = THEME.text,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextTruncate = Enum.TextTruncate.AtEnd,
    TextXAlignment = Enum.TextXAlignment.Center,
}, sidebar)
make("TextLabel", {
    Size = UDim2.new(1, -20, 0, 17),
    Position = UDim2.fromOffset(10, 118),
    BackgroundTransparency = 1,
    Text = "@" .. player.Name,
    TextColor3 = THEME.subtext,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextTruncate = Enum.TextTruncate.AtEnd,
    TextXAlignment = Enum.TextXAlignment.Center,
}, sidebar)

local function infoRow(index, label, value)
    local row = make("Frame", {
        Size = UDim2.new(1, -24, 0, 25),
        Position = UDim2.fromOffset(12, 151 + (index - 1) * 29),
        BackgroundColor3 = THEME.bg,
        BorderSizePixel = 0,
    }, sidebar)
    corner(row, 7)
    make("TextLabel", {
        Size = UDim2.new(0.46, -3, 1, 0),
        Position = UDim2.fromOffset(8, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = THEME.muted,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    return make("TextLabel", {
        Size = UDim2.new(0.54, -11, 1, 0),
        Position = UDim2.new(0.46, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = value,
        TextColor3 = THEME.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, row)
end

local createdAt = os.date("%d.%m.%Y", os.time() - player.AccountAge * 86400)
infoRow(1, "Joined", createdAt)
infoRow(2, "Account age", string.format("%d days", player.AccountAge))
infoRow(3, "User ID", tostring(player.UserId))
infoRow(4, "Membership", player.MembershipType.Name)
infoRow(5, "Locale", (player.LocaleId ~= "" and player.LocaleId) or "N/A")
local gameValue = infoRow(6, "Experience", "Loading...")

task.spawn(function()
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    gameValue.Text = (success and info and info.Name) or "Unknown"
end)

-- Script library heading
make("TextLabel", {
    Size = UDim2.new(1, -240, 0, 25),
    Position = UDim2.fromOffset(216, 81),
    BackgroundTransparency = 1,
    Text = "Available scripts",
    TextColor3 = THEME.text,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
}, main)
make("TextLabel", {
    Size = UDim2.new(1, -240, 0, 17),
    Position = UDim2.fromOffset(216, 106),
    BackgroundTransparency = 1,
    Text = "Select a module to start",
    TextColor3 = THEME.subtext,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
}, main)

-- Status line
local statusDot = make("Frame", {
    Size = UDim2.fromOffset(7, 7),
    Position = UDim2.fromOffset(216, 397),
    BackgroundColor3 = THEME.muted,
    BorderSizePixel = 0,
}, main)
corner(statusDot, 4)
local status = make("TextLabel", {
    Size = UDim2.new(1, -245, 0, 19),
    Position = UDim2.fromOffset(230, 391),
    BackgroundTransparency = 1,
    Text = "Ready",
    TextColor3 = THEME.subtext,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
}, main)

local function setStatus(message, kind)
    status.Text = message
    if kind == "ok" then
        status.TextColor3 = THEME.ok
        statusDot.BackgroundColor3 = THEME.ok
    elseif kind == "err" then
        status.TextColor3 = THEME.err
        statusDot.BackgroundColor3 = THEME.err
    else
        status.TextColor3 = THEME.subtext
        statusDot.BackgroundColor3 = THEME.muted
    end
end

-- Script cards
local scriptList = make("ScrollingFrame", {
    Name = "ScriptList",
    Size = UDim2.new(1, -232, 1, -167),
    Position = UDim2.fromOffset(212, 133),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = THEME.stroke,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(0, 0, 0, 0),
}, main)
make("UIPadding", {
    PaddingTop = UDim.new(0, 3),
    PaddingRight = UDim.new(0, 5),
    PaddingBottom = UDim.new(0, 4),
}, scriptList)
make("UIListLayout", {
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, scriptList)

if #CONFIG.scripts == 0 then
    make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundTransparency = 1,
        Text = "No scripts available",
        TextColor3 = THEME.subtext,
        Font = Enum.Font.Gotham,
        TextSize = 12,
    }, scriptList)
end

for index, entry in ipairs(CONFIG.scripts) do
    local isAvailable = entry.available ~= false
    local card = make("Frame", {
        Name = "ScriptCard" .. index,
        Size = UDim2.new(1, -5, 0, 62),
        BackgroundColor3 = THEME.panelRaised,
        BorderSizePixel = 0,
        LayoutOrder = index,
    }, scriptList)
    corner(card, 11)
    local cardStroke = stroke(card, THEME.stroke, 1, 0.05)

    local accent = make("Frame", {
        Size = UDim2.fromOffset(3, 30),
        Position = UDim2.fromOffset(0, 16),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
    }, card)
    corner(accent, 2)
    if isAvailable then
        gradient(accent, THEME.accentA, THEME.accentB, 90)
    else
        accent.BackgroundColor3 = THEME.stroke
    end

    make("TextLabel", {
        Size = UDim2.new(1, -145, 0, 20),
        Position = UDim2.fromOffset(16, 10),
        BackgroundTransparency = 1,
        Text = entry.name,
        TextColor3 = isAvailable and THEME.text or THEME.subtext,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, card)
    make("TextLabel", {
        Size = UDim2.new(1, -145, 0, 16),
        Position = UDim2.fromOffset(16, 32),
        BackgroundTransparency = 1,
        Text = entry.desc or "",
        TextColor3 = THEME.subtext,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, card)

    local runButton = make("TextButton", {
        Size = UDim2.fromOffset(82, 30),
        Position = UDim2.new(1, -97, 0.5, -15),
        BackgroundColor3 = isAvailable and Color3.new(1, 1, 1) or THEME.panel,
        Text = isAvailable and "Launch" or "Soon",
        TextColor3 = isAvailable and Color3.new(1, 1, 1) or THEME.muted,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Active = isAvailable,
        Selectable = isAvailable,
    }, card)
    corner(runButton, 8)

    local buttonStroke
    if isAvailable then
        gradient(runButton, THEME.accentA, THEME.accentB, 0)
        buttonStroke = stroke(runButton, THEME.accentB, 1, 0.62)
    else
        stroke(runButton, THEME.stroke, 1, 0.35)
    end

    card.MouseEnter:Connect(function()
        tween(card, { BackgroundColor3 = THEME.panelHover })
        tween(cardStroke, { Color = isAvailable and THEME.accentA or THEME.stroke, Transparency = 0.1 })
    end)
    card.MouseLeave:Connect(function()
        tween(card, { BackgroundColor3 = THEME.panelRaised })
        tween(cardStroke, { Color = THEME.stroke, Transparency = 0.05 })
    end)

    if isAvailable then
        runButton.MouseEnter:Connect(function()
            tween(buttonStroke, { Transparency = 0.15 })
        end)
        runButton.MouseLeave:Connect(function()
            tween(buttonStroke, { Transparency = 0.62 })
        end)

        local busy = false
        runButton.MouseButton1Click:Connect(function()
            if busy then
                return
            end
            busy = true
            runButton.Text = "Loading..."
            task.spawn(function()
                local success = runScript(entry, setStatus)
                if success then
                    runButton.Text = "Launched"
                    task.wait(0.7)
                    if screen.Parent then
                        screen:Destroy()
                    end
                    return
                end
                runButton.Text = "Launch"
                busy = false
            end)
        end)
    end
end
