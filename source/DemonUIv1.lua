-- ╔══════════════════════════════════════════════════════════════╗
-- ║              Demon UI Library  •  Made By Jova               ║
-- ║          Roblox Instance Based  •  loadstring ready          ║
-- ╚══════════════════════════════════════════════════════════════╝

local DemonUI = {}
DemonUI.__index = DemonUI

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP           = Players.LocalPlayer

local T = {
    BG          = Color3.fromRGB(15, 17, 28),
    Sidebar     = Color3.fromRGB(11, 13, 22),
    TopBar      = Color3.fromRGB(9,  11, 20),
    Section     = Color3.fromRGB(20, 23, 38),
    Item        = Color3.fromRGB(24, 28, 46),
    ItemHover   = Color3.fromRGB(32, 37, 60),
    Accent      = Color3.fromRGB(88, 140, 255),
    AccentDark  = Color3.fromRGB(45, 85, 175),
    TextPri     = Color3.fromRGB(230, 238, 255),
    TextSec     = Color3.fromRGB(120, 138, 180),
    TextDim     = Color3.fromRGB(65,  78, 115),
    Border      = Color3.fromRGB(38,  45,  72),
    TogOff      = Color3.fromRGB(44,  50,  78),
    TogOn       = Color3.fromRGB(88, 140, 255),
    SliderTrack = Color3.fromRGB(32,  37,  60),
    SliderFill  = Color3.fromRGB(88, 140, 255),
    Danger      = Color3.fromRGB(220, 70,  80),
    Success     = Color3.fromRGB(55, 195, 115),
    Warning     = Color3.fromRGB(215, 165, 45),
    Font        = Enum.Font.GothamMedium,
    FontBold    = Enum.Font.GothamBold,
    FontMono    = Enum.Font.Code,
}

-- ════════════════════════════════════════════════════════════════
-- HELPERS
-- ════════════════════════════════════════════════════════════════

local function New(class, props, children)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    for _, c in ipairs(children or {}) do c.Parent = o end
    return o
end

local function Corner(r)
    return New("UICorner", {CornerRadius = r or UDim.new(0, 7)})
end

local function Stroke(c, t)
    return New("UIStroke", {
        Color = c or T.Border,
        Thickness = t or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
end

local function Pad(t, r, b, l)
    return New("UIPadding", {
        PaddingTop    = UDim.new(0, t or 6),
        PaddingRight  = UDim.new(0, r or 8),
        PaddingBottom = UDim.new(0, b or 6),
        PaddingLeft   = UDim.new(0, l or 8),
    })
end

local function List(dir, gap)
    return New("UIListLayout", {
        FillDirection = dir or Enum.FillDirection.Vertical,
        SortOrder     = Enum.SortOrder.LayoutOrder,
        Padding       = UDim.new(0, gap or 4),
    })
end

local function Tw(inst, props, t, sty, dir)
    local tw = TweenService:Create(
        inst,
        TweenInfo.new(t or 0.22, sty or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props
    )
    tw:Play()
    return tw
end

-- support Mouse & Touch sekaligus
local function isTap(inp)
    return inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch
end
local function isMove(inp)
    return inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch
end

local function MakeDraggable(frame, handle)
    local drag, ds, sp = false, nil, nil
    handle.InputBegan:Connect(function(inp)
        if isTap(inp) then
            drag = true
            ds   = inp.Position
            sp   = frame.Position
        end
    end)
    handle.InputEnded:Connect(function(inp)
        if isTap(inp) then drag = false end
    end)
    UIS.InputChanged:Connect(function(inp)
        if drag and isMove(inp) then
            local d = inp.Position - ds
            frame.Position = UDim2.new(
                sp.X.Scale, sp.X.Offset + d.X,
                sp.Y.Scale, sp.Y.Offset + d.Y
            )
        end
    end)
end

-- ════════════════════════════════════════════════════════════════
-- NOTIFICATION
-- ════════════════════════════════════════════════════════════════

local NotifHolder
local function EnsureNotif()
    if NotifHolder then return end
    local sg = New("ScreenGui", {
        Name = "DemonNotifs",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = LP.PlayerGui
    })
    NotifHolder = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 300, 1, 0),
        Position = UDim2.new(1, -308, 0, 0),
        Parent = sg
    }, {List(Enum.FillDirection.Vertical, 6)})
    NotifHolder.UIListLayout.VerticalAlignment   = Enum.VerticalAlignment.Bottom
    NotifHolder.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
end

function DemonUI:Notify(opts)
    EnsureNotif()
    opts = opts or {}
    local accent = ({
        info    = T.Accent,
        success = T.Success,
        warning = T.Warning,
        danger  = T.Danger,
    })[opts.Type or "info"] or T.Accent

    local card = New("Frame", {
        BackgroundColor3    = T.Item,
        Size                = UDim2.new(1, -8, 0, 66),
        BackgroundTransparency = 1,
        Parent              = NotifHolder,
    }, {Corner(UDim.new(0, 8)), Stroke(accent, 1)})

    New("Frame", {BackgroundColor3 = accent, Size = UDim2.new(0, 3, 0.7, 0), Position = UDim2.new(0, 0, 0.15, 0), Parent = card}, {Corner(UDim.new(0, 2))})
    New("TextLabel", {Text = opts.Title or "Notif", Font = T.FontBold, TextSize = 13, TextColor3 = T.TextPri, BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 18), Position = UDim2.new(0, 12, 0, 10), TextXAlignment = Enum.TextXAlignment.Left, Parent = card})
    New("TextLabel", {Text = opts.Content or "", Font = T.Font, TextSize = 11, TextColor3 = T.TextSec, BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 26), Position = UDim2.new(0, 12, 0, 30), TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = card})

    card.Position = UDim2.new(1, 10, 0, 0)
    Tw(card, {BackgroundTransparency = 0}, 0.2)
    Tw(card, {Position = UDim2.new(0, 0, 0, 0)}, 0.28, Enum.EasingStyle.Back)

    task.delay(opts.Duration or 3, function()
        Tw(card, {BackgroundTransparency = 1, Position = UDim2.new(1, 10, 0, 0)}, 0.25)
        task.wait(0.3)
        card:Destroy()
    end)
end

-- ════════════════════════════════════════════════════════════════
-- WELCOME SCREEN  (seukuran window, posisi sama, bisa di-drag)
-- ════════════════════════════════════════════════════════════════

local function ShowWelcome(parent, ww, wh, posX, posY, onDone)
    -- Container seukuran window persis
    local overlay = New("Frame", {
        BackgroundColor3 = Color3.fromRGB(8, 9, 18),
        Size     = UDim2.fromOffset(ww, wh),
        Position = UDim2.fromOffset(posX, posY),
        ZIndex   = 50,
        ClipsDescendants = true,
        Parent   = parent,
    }, {Corner(UDim.new(0, 10)), Stroke(T.Border)})

    -- drag welcome screen juga
    MakeDraggable(overlay, overlay)

    -- ── orb glow (posisi relatif terhadap ukuran window) ──
    local function Orb(rx, ry, size, color)
        local f = New("Frame", {
            BackgroundColor3    = color,
            BackgroundTransparency = 0.5,
            Size     = UDim2.fromOffset(size, size),
            Position = UDim2.new(rx, -size/2, ry, -size/2),
            ZIndex   = 51,
            Parent   = overlay,
        }, {New("UICorner", {CornerRadius = UDim.new(0.5, 0)})})
        for i = 1, 3 do
            New("Frame", {
                BackgroundColor3       = color,
                BackgroundTransparency = 0.72 + i * 0.08,
                Size     = UDim2.fromOffset(size + i*20, size + i*20),
                Position = UDim2.fromOffset(-i*10, -i*10),
                ZIndex   = 50,
                Parent   = f,
            }, {New("UICorner", {CornerRadius = UDim.new(0.5, 0)})})
        end
        return f
    end

    local orb1 = Orb(0.15, 0.2,  math.floor(ww * 0.28), Color3.fromRGB(88,  140, 255))
    local orb2 = Orb(0.82, 0.75, math.floor(ww * 0.22), Color3.fromRGB(120, 60,  255))
    local orb3 = Orb(0.5,  0.85, math.floor(ww * 0.16), Color3.fromRGB(50,  180, 255))

    -- ── teks tengah ──
    local centerY = wh * 0.36

    local title = New("TextLabel", {
        Text = "", Font = Enum.Font.GothamBold,
        TextSize = math.clamp(math.floor(ww / 18), 22, 36),
        TextColor3 = T.TextPri,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 44),
        Position = UDim2.fromOffset(0, centerY),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextTransparency = 1, ZIndex = 52, Parent = overlay,
    })
    local sub = New("TextLabel", {
        Text = "Made By Jova", Font = Enum.Font.GothamMedium,
        TextSize = math.clamp(math.floor(ww / 40), 11, 15),
        TextColor3 = T.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.fromOffset(0, centerY + 48),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextTransparency = 1, ZIndex = 52, Parent = overlay,
    })

    -- ── loading bar ──
    local barW   = math.floor(ww * 0.55)
    local barTrack = New("Frame", {
        BackgroundColor3 = Color3.fromRGB(22, 26, 44),
        Size     = UDim2.fromOffset(barW, 4),
        Position = UDim2.fromOffset(math.floor((ww - barW) / 2), centerY + 78),
        BackgroundTransparency = 1, ZIndex = 52, Parent = overlay,
    }, {Corner(UDim.new(0, 2))})
    local barFill = New("Frame", {
        BackgroundColor3 = T.Accent,
        Size = UDim2.new(0, 0, 1, 0),
        ZIndex = 53, Parent = barTrack,
    }, {Corner(UDim.new(0, 2))})
    local loadTxt = New("TextLabel", {
        Text = "Initializing...", Font = Enum.Font.GothamMedium, TextSize = 11,
        TextColor3 = T.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.fromOffset(0, centerY + 90),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextTransparency = 1, ZIndex = 52, Parent = overlay,
    })

    -- ── versi kecil di pojok bawah kanan ──
    New("TextLabel", {
        Text = "Demon UI  v1.0", Font = Enum.Font.GothamMedium, TextSize = 10,
        TextColor3 = T.TextDim,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -14, 0, 16),
        Position = UDim2.fromOffset(0, wh - 24),
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 52, Parent = overlay,
    })

    -- ── orb float ──
    local ox1, oy1 = ww * 0.15, wh * 0.2
    local ox2, oy2 = ww * 0.82, wh * 0.75
    local ox3, oy3 = ww * 0.5,  wh * 0.85
    task.spawn(function()
        local t = 0
        while overlay.Parent do
            t = t + task.wait(0.03)
            orb1.Position = UDim2.new(0, ox1 + math.sin(t*0.55)*14, 0, oy1 + math.cos(t*0.48)*11)
            orb2.Position = UDim2.new(0, ox2 + math.cos(t*0.42)*18, 0, oy2 + math.sin(t*0.52)*13)
            orb3.Position = UDim2.new(0, ox3 + math.sin(t*0.65)*10, 0, oy3 + math.cos(t*0.58)*9)
        end
    end)

    -- ── animasi sequence ──
    task.spawn(function()
        task.wait(0.12)

        -- fade in sub dulu (lebih dramatis)
        Tw(sub, {TextTransparency = 0}, 0.35)
        task.wait(0.15)

        -- typewriter title
        Tw(title, {TextTransparency = 0}, 0.25)
        local full = "Demon UI"
        for i = 1, #full do
            title.Text = string.sub(full, 1, i)
            task.wait(0.06)
        end
        task.wait(0.12)

        -- loading bar muncul
        Tw(barTrack, {BackgroundTransparency = 0}, 0.25)
        Tw(loadTxt,  {TextTransparency = 0}, 0.25)
        task.wait(0.3)

        local steps = {
            {0.18, "Loading modules..."},
            {0.42, "Building UI..."},
            {0.68, "Applying theme..."},
            {0.87, "Almost ready..."},
            {1.00, "Welcome!"},
        }
        for _, s in ipairs(steps) do
            Tw(barFill, {Size = UDim2.new(s[1], 0, 1, 0)}, 0.32, Enum.EasingStyle.Quart)
            loadTxt.Text = s[2]
            task.wait(0.35)
        end
        task.wait(0.18)

        -- fade out semua sekaligus
        Tw(overlay,  {BackgroundTransparency = 1}, 0.45)
        Tw(title,    {TextTransparency = 1}, 0.3)
        Tw(sub,      {TextTransparency = 1}, 0.3)
        Tw(loadTxt,  {TextTransparency = 1}, 0.25)
        Tw(barFill,  {BackgroundTransparency = 1}, 0.25)
        Tw(barTrack, {BackgroundTransparency = 1}, 0.25)
        task.wait(0.48)
        overlay:Destroy()
        if onDone then onDone() end
    end)
end

-- ════════════════════════════════════════════════════════════════
-- CREATE WINDOW
-- ════════════════════════════════════════════════════════════════

function DemonUI:CreateWindow(opts)
    opts = opts or {}
    -- Size bisa diisi {Width=590, Height=465} atau langsung angka
    local sizeOpt = opts.Size or {}
    local WW = (type(sizeOpt) == "table" and sizeOpt.Width)  or sizeOpt.X and sizeOpt.X.Offset or 590
    local WH = (type(sizeOpt) == "table" and sizeOpt.Height) or sizeOpt.Y and sizeOpt.Y.Offset or 465
    local W  = UDim2.fromOffset(WW, WH)   -- UDim2 untuk frame
    local TITLE = opts.Title       or "Demon UI"
    local SUB   = opts.SubTitle    or "Made By Jova"
    local MKEY  = opts.MinimizeKey or Enum.KeyCode.RightControl

    for k, v in pairs(opts.Theme or {}) do
        if T[k] ~= nil then T[k] = v end
    end

    local old = LP.PlayerGui:FindFirstChild("DemonUI_Main")
    if old then old:Destroy() end

    local SG = New("ScreenGui", {
        Name = "DemonUI_Main",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = LP.PlayerGui,
    })

    -- Main frame (mulai invisible, muncul setelah welcome)
    local MF = New("Frame", {
        BackgroundColor3    = T.BG,
        Size                = W,
        Position            = UDim2.new(0.5, -WW / 2, 0.5, -WH / 2),
        BackgroundTransparency = 1,
        Parent              = SG,
    }, {Corner(UDim.new(0, 10)), Stroke(T.Border)})

    -- TopBar
    local TB = New("Frame", {
        BackgroundColor3 = T.TopBar,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = MF,
    }, {Corner(UDim.new(0, 10)), Stroke(T.Border)})
    New("Frame", {BackgroundColor3 = T.TopBar, Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BorderSizePixel = 0, Parent = TB})
    New("TextLabel", {Text = TITLE .. "  ·  " .. SUB, Font = T.FontBold, TextSize = 13, TextColor3 = T.TextPri, BackgroundTransparency = 1, Size = UDim2.new(1, -90, 1, 0), Position = UDim2.new(0, 14, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = TB})

    local function WinBtn(pos, bg, tc, txt)
        local b = New("TextButton", {
            Text = txt, Font = T.Font, TextSize = 12, TextColor3 = tc,
            BackgroundColor3 = bg,
            Size = UDim2.new(0, 26, 0, 26), Position = pos,
            AutoButtonColor = false, Parent = TB,
        }, {Corner(UDim.new(0, 5))})
        b.MouseEnter:Connect(function() Tw(b, {BackgroundTransparency = 0.3}, 0.12) end)
        b.MouseLeave:Connect(function() Tw(b, {BackgroundTransparency = 0},   0.12) end)
        return b
    end
    local CloseBtn = WinBtn(UDim2.new(1, -32,  0.5, -13), Color3.fromRGB(55, 20, 22), Color3.fromRGB(255, 90, 90),  "✕")
    local MinBtn   = WinBtn(UDim2.new(1, -62,  0.5, -13), Color3.fromRGB(50, 45, 18), Color3.fromRGB(230, 190, 50), "—")

    -- Drag handle (area kiri topbar saja)
    local DragHandle = New("TextButton", {
        Text = "", BackgroundTransparency = 1,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        ZIndex = 5, AutoButtonColor = false, Parent = TB,
    })
    MakeDraggable(MF, DragHandle)

    -- Body
    local Body = New("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, -40), Position = UDim2.new(0, 0, 0, 40), Parent = MF})

    -- Sidebar
    local SB = New("Frame", {BackgroundColor3 = T.Sidebar, Size = UDim2.new(0, 152, 1, 0), Parent = Body}, {Stroke(T.Border)})
    New("Frame", {BackgroundColor3 = T.Sidebar, Size = UDim2.new(0, 8, 1, 0), Position = UDim2.new(1, -8, 0, 0), BorderSizePixel = 0, Parent = SB})
    local SBList = New("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = SB}, {List(Enum.FillDirection.Vertical, 3)})
    New("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7), Parent = SBList})

    -- Tab container
    local TC = New("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, -154, 1, 0), Position = UDim2.new(0, 154, 0, 0), ClipsDescendants = true, Parent = Body})

    -- Minimize / Close
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        Body.Visible = not minimized
        Tw(MF, {Size = minimized and UDim2.new(0, WW, 0, 40) or W}, 0.28, Enum.EasingStyle.Quart)
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        Tw(MF, {Size = UDim2.new(0, WW, 0, 0), BackgroundTransparency = 1}, 0.22)
        task.wait(0.25)
        SG:Destroy()
    end)
    UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == MKEY then
            minimized = not minimized
            Body.Visible = not minimized
            Tw(MF, {Size = minimized and UDim2.new(0, WW, 0, 40) or W}, 0.28, Enum.EasingStyle.Quart)
        end
    end)

    -- ════════════════════════════════════════════════════════
    -- WINDOW OBJECT
    -- ════════════════════════════════════════════════════════

    local Win = {_tabs = {}, _active = nil}

    function Win:AddTab(o2)
        o2 = o2 or {}
        local name = o2.Title or "Tab"

        local Nav = New("TextButton", {Text = "", BackgroundColor3 = T.Sidebar, Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, AutoButtonColor = false, Parent = SBList}, {Corner(UDim.new(0, 6))})
        local Bar = New("Frame", {BackgroundColor3 = T.Accent, Size = UDim2.new(0, 3, 0.65, 0), Position = UDim2.new(0, 0, 0.175, 0), Visible = false, Parent = Nav}, {Corner(UDim.new(0, 2))})
        local Lbl = New("TextLabel", {Text = name, Font = T.Font, TextSize = 13, TextColor3 = T.TextSec, BackgroundTransparency = 1, Size = UDim2.new(1, -14, 1, 0), Position = UDim2.new(0, 12, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = Nav})

        local Page = New("ScrollingFrame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 3, ScrollBarImageColor3 = T.Accent, Visible = false, Parent = TC})
        local PList = List(Enum.FillDirection.Vertical, 5)
        PList.Parent = Page
        New("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 12), Parent = Page})
        PList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PList.AbsoluteContentSize.Y + 20)
        end)

        New("TextLabel", {Text = name, Font = T.FontBold, TextSize = 20, TextColor3 = T.TextPri, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), TextXAlignment = Enum.TextXAlignment.Left, Parent = Page})
        New("Frame", {BackgroundColor3 = T.Border, Size = UDim2.new(1, 0, 0, 1), Parent = Page})

        local Tab = {_page = Page, _nav = Nav, _bar = Bar, _lbl = Lbl}

        local function Select()
            for _, t in ipairs(Win._tabs) do
                t._page.Visible = false
                Tw(t._nav, {BackgroundTransparency = 1}, 0.15)
                t._bar.Visible = false
                t._lbl.TextColor3 = T.TextSec
                t._lbl.Font = T.Font
            end
            Page.Visible = true
            Tw(Nav, {BackgroundTransparency = 0}, 0.15)
            Nav.BackgroundColor3 = T.ItemHover
            Bar.Visible = true
            Lbl.TextColor3 = T.TextPri
            Lbl.Font = T.FontBold
            Win._active = Tab
            Page.Position = UDim2.new(0.06, 0, 0, 0)
            Tw(Page, {Position = UDim2.new(0, 0, 0, 0)}, 0.22, Enum.EasingStyle.Quart)
        end
        Tab._select = Select

        Nav.MouseButton1Click:Connect(Select)
        Nav.MouseEnter:Connect(function() if Win._active ~= Tab then Tw(Nav, {BackgroundTransparency = 0.75}, 0.12) end end)
        Nav.MouseLeave:Connect(function() if Win._active ~= Tab then Tw(Nav, {BackgroundTransparency = 1},    0.12) end end)
        table.insert(Win._tabs, Tab)
        if #Win._tabs == 1 then Select() end

        -- ── ROW HELPER ──
        local function Row(label, desc, rw)
            rw = rw or 0
            local h = (desc and desc ~= "") and 52 or 38
            local f = New("Frame", {BackgroundColor3 = T.Item, Size = UDim2.new(1, 0, 0, h), Parent = Page}, {Corner(), Stroke(T.Border)})
            New("TextLabel", {Text = label, Font = T.FontBold, TextSize = 13, TextColor3 = T.TextPri, BackgroundTransparency = 1, Size = UDim2.new(1, -(rw + 18), 0, 18), Position = UDim2.new(0, 10, 0, (desc and desc ~= "") and 9 or 10), TextXAlignment = Enum.TextXAlignment.Left, Parent = f})
            if desc and desc ~= "" then
                New("TextLabel", {Text = desc, Font = T.Font, TextSize = 11, TextColor3 = T.TextSec, BackgroundTransparency = 1, Size = UDim2.new(1, -(rw + 18), 0, 14), Position = UDim2.new(0, 10, 0, 28), TextXAlignment = Enum.TextXAlignment.Left, Parent = f})
            end
            f.MouseEnter:Connect(function() Tw(f, {BackgroundColor3 = T.ItemHover}, 0.14) end)
            f.MouseLeave:Connect(function() Tw(f, {BackgroundColor3 = T.Item},      0.14) end)
            return f
        end

        -- ── SECTION ──
        function Tab:AddSection(n)
            New("TextLabel", {Text = string.upper(n), Font = T.FontBold, TextSize = 10, TextColor3 = T.TextDim, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22), TextXAlignment = Enum.TextXAlignment.Left, Parent = Page}, {Pad(10, 0, 0, 4)})
        end

        -- ── PARAGRAPH ──
        function Tab:AddParagraph(o)
            o = o or {}
            local f  = New("Frame", {BackgroundColor3 = T.Section, Size = UDim2.new(1, 0, 0, 0), Parent = Page}, {Corner(), Stroke(T.Border)})
            local ll = List(Enum.FillDirection.Vertical, 4); ll.Parent = f
            Pad(10, 12, 10, 12).Parent = f
            if o.Title then
                New("TextLabel", {Text = o.Title, Font = T.FontBold, TextSize = 13, TextColor3 = T.TextPri, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), TextXAlignment = Enum.TextXAlignment.Left, Parent = f})
            end
            if o.Content then
                local lbl = New("TextLabel", {Text = o.Content, Font = T.Font, TextSize = 12, TextColor3 = T.TextSec, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = f})
                lbl:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() lbl.Size = UDim2.new(1, 0, 0, lbl.TextBounds.Y) end)
            end
            local function upd() f.Size = UDim2.new(1, 0, 0, ll.AbsoluteContentSize.Y + 20) end
            ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(upd); upd()
        end

        -- ── BUTTON ──
        function Tab:AddButton(o)
            o = o or {}
            local row = Row(o.Title or "Button", o.Description, 90)
            local btn = New("TextButton", {Text = o.ButtonText or "Execute", Font = T.Font, TextSize = 12, TextColor3 = T.TextPri, BackgroundColor3 = T.AccentDark, Size = UDim2.new(0, 80, 0, 27), Position = UDim2.new(1, -88, 0.5, -13.5), AutoButtonColor = false, Parent = row}, {Corner(UDim.new(0, 6)), Stroke(T.Accent)})
            -- hover hanya untuk PC (Mouse), skip untuk touch agar tidak flicker
            btn.MouseEnter:Connect(function() Tw(btn, {BackgroundColor3 = T.Accent},     0.14) end)
            btn.MouseLeave:Connect(function() Tw(btn, {BackgroundColor3 = T.AccentDark}, 0.14) end)
            btn.InputBegan:Connect(function(inp)
                if not isTap(inp) then return end
                Tw(btn, {BackgroundColor3 = T.Accent, Size = UDim2.new(0, 74, 0, 25)}, 0.08)
            end)
            btn.InputEnded:Connect(function(inp)
                if not isTap(inp) then return end
                Tw(btn, {BackgroundColor3 = T.AccentDark, Size = UDim2.new(0, 80, 0, 27)}, 0.14, Enum.EasingStyle.Back)
                if o.Callback then o.Callback() end
            end)
        end

        -- ── TOGGLE ──
        function Tab:AddToggle(id, o)
            o = o or {}
            local val = o.Default or false
            local row   = Row(o.Title or "Toggle", o.Description, 56)
            local track = New("TextButton", {Text = "", BackgroundColor3 = val and T.TogOn or T.TogOff, Size = UDim2.new(0, 40, 0, 21), Position = UDim2.new(1, -48, 0.5, -10.5), AutoButtonColor = false, Parent = row}, {Corner(UDim.new(0, 11))})
            local knob  = New("Frame", {BackgroundColor3 = Color3.new(1, 1, 1), Size = UDim2.new(0, 15, 0, 15), Position = val and UDim2.new(0, 22, 0.5, -7.5) or UDim2.new(0, 3, 0.5, -7.5), Parent = track}, {Corner(UDim.new(0, 8))})
            local obj = {Value = val}
            local function Set(v, cb)
                val = v; obj.Value = v
                Tw(track, {BackgroundColor3 = v and T.TogOn or T.TogOff}, 0.22)
                Tw(knob,  {Position = v and UDim2.new(0, 22, 0.5, -7.5) or UDim2.new(0, 3, 0.5, -7.5)}, 0.22, Enum.EasingStyle.Back)
                if cb and o.Callback then o.Callback(v) end
            end
            track.MouseButton1Click:Connect(function() Set(not val, true) end)
            track.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.Touch then Set(not val, true) end end)
            function obj:Set(v) Set(v, true) end
            _G["DemonToggle_" .. (id or "")] = obj
            return obj
        end

        -- ── SLIDER ──
        function Tab:AddSlider(id, o)
            o = o or {}
            local min = o.Min or 0
            local max = o.Max or 100
            local val = math.clamp(o.Default or min, min, max)
            local rnd = o.Rounding or 1
            local row = Row(o.Title or "Slider", o.Description, 0)
            row.Size  = UDim2.new(1, 0, 0, (o.Description and o.Description ~= "") and 64 or 50)

            local valLbl = New("TextLabel", {Text = tostring(val), Font = T.FontMono, TextSize = 11, TextColor3 = T.Accent, BackgroundTransparency = 1, Size = UDim2.new(0, 36, 0, 16), Position = UDim2.new(1, -42, 0, 6), TextXAlignment = Enum.TextXAlignment.Right, Parent = row})
            local track  = New("Frame",       {BackgroundColor3 = T.SliderTrack, Size = UDim2.new(1, -20, 0, 5), Position = UDim2.new(0, 10, 1, -15), Parent = row}, {Corner(UDim.new(0, 3))})
            local hit    = New("TextButton",  {Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24), Position = UDim2.new(0, 0, 0.5, -12), ZIndex = 5, AutoButtonColor = false, Parent = track})
            local fill   = New("Frame",       {BackgroundColor3 = T.SliderFill, Size = UDim2.new((val - min) / (max - min), 0, 1, 0), Parent = track}, {Corner(UDim.new(0, 3))})
            local thumb  = New("Frame",       {BackgroundColor3 = Color3.new(1, 1, 1), Size = UDim2.new(0, 13, 0, 13), Position = UDim2.new((val - min) / (max - min), -6.5, 0.5, -6.5), ZIndex = 4, Parent = track}, {Corner(UDim.new(0, 7)), Stroke(T.Accent)})

            local obj        = {Value = val}
            local isDragging = false
            local moveConn   = nil

            local function Calc(absX)
                local pct     = math.clamp((absX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                val           = math.round((min + (max - min) * pct) / rnd) * rnd
                obj.Value     = val
                valLbl.Text   = tostring(val)
                local fp      = (val - min) / (max - min)
                fill.Size     = UDim2.new(fp, 0, 1, 0)
                thumb.Position = UDim2.new(fp, -6.5, 0.5, -6.5)
                if o.Callback then o.Callback(val) end
            end

            hit.InputBegan:Connect(function(inp)
                if not isTap(inp) then return end
                isDragging = true
                Tw(thumb, {Size = UDim2.new(0, 15, 0, 15)}, 0.1, Enum.EasingStyle.Back)
                Calc(inp.Position.X)
                moveConn = UIS.InputChanged:Connect(function(i2)
                    if isMove(i2) then Calc(i2.Position.X) end
                end)
            end)

            UIS.InputEnded:Connect(function(inp)
                if isTap(inp) and isDragging then
                    isDragging = false
                    Tw(thumb, {Size = UDim2.new(0, 13, 0, 13)}, 0.1)
                    if moveConn then moveConn:Disconnect(); moveConn = nil end
                end
            end)

            function obj:Set(v)
                v = math.clamp(v, min, max); val = v; obj.Value = v
                local fp = (v - min) / (max - min)
                fill.Size      = UDim2.new(fp, 0, 1, 0)
                thumb.Position = UDim2.new(fp, -6.5, 0.5, -6.5)
                valLbl.Text    = tostring(v)
                if o.Callback then o.Callback(v) end
            end
            _G["DemonSlider_" .. (id or "")] = obj
            return obj
        end

        -- ── DROPDOWN ──
        function Tab:AddDropdown(id, o)
            o = o or {}
            local vals = o.Values or {}
            local multi = o.Multi or false
            local cur = o.Default or (vals[1] or "")
            local sel = {}
            local open = false
            local row  = Row(o.Title or "Dropdown", o.Description, 125)

            local dBtn = New("TextButton", {Text = cur, Font = T.Font, TextSize = 12, TextColor3 = T.TextPri, BackgroundColor3 = T.SliderTrack, Size = UDim2.new(0, 116, 0, 27), Position = UDim2.new(1, -124, 0.5, -13.5), AutoButtonColor = false, ClipsDescendants = true, Parent = row}, {Corner(UDim.new(0, 6)), Stroke(T.Border)})
            New("TextLabel", {Text = "▾", Font = T.Font, TextSize = 11, TextColor3 = T.TextSec, BackgroundTransparency = 1, Size = UDim2.new(0, 16, 1, 0), Position = UDim2.new(1, -18, 0, 0), Parent = dBtn})

            local LF = New("Frame",         {BackgroundColor3 = T.Section, Size = UDim2.new(0, 116, 0, 0), Visible = false, ZIndex = 15, Parent = SG},  {Corner(UDim.new(0, 6)), Stroke(T.Border)})
            local LS = New("ScrollingFrame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 2, ScrollBarImageColor3 = T.Accent, ZIndex = 15, Parent = LF})
            local IL = List(Enum.FillDirection.Vertical, 2); IL.Parent = LS
            Pad(4, 4, 4, 4).Parent = LS

            local obj = {Value = cur, Values = vals}

            local function Close()
                open = false
                Tw(LF, {Size = UDim2.new(0, 116, 0, 0)}, 0.18, Enum.EasingStyle.Quart)
                task.wait(0.2); LF.Visible = false
            end

            local function Build()
                for _, c in ipairs(LS:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                for _, v in ipairs(vals) do
                    local isSel = multi and table.find(sel, v) or (v == cur)
                    local itm = New("TextButton", {Text = (isSel and "✓  " or "   ") .. v, Font = isSel and T.FontBold or T.Font, TextSize = 12, TextColor3 = isSel and T.Accent or T.TextPri, BackgroundColor3 = isSel and Color3.fromRGB(26, 36, 64) or T.Item, Size = UDim2.new(1, 0, 0, 27), TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, ZIndex = 16, Parent = LS}, {Corner(UDim.new(0, 5)), Pad(0, 0, 0, 8)})
                    itm.MouseEnter:Connect(function() Tw(itm, {BackgroundColor3 = T.ItemHover}, 0.1) end)
                    itm.MouseLeave:Connect(function() Tw(itm, {BackgroundColor3 = isSel and Color3.fromRGB(26, 36, 64) or T.Item}, 0.1) end)
                    itm.MouseButton1Click:Connect(function()
                        if multi then
                            local idx = table.find(sel, v)
                            if idx then table.remove(sel, idx) else table.insert(sel, v) end
                            obj.Value = sel; dBtn.Text = #sel > 0 and table.concat(sel, ", ") or "None"
                        else
                            cur = v; obj.Value = v; dBtn.Text = v; Close()
                        end
                        if o.Callback then o.Callback(obj.Value) end; Build()
                    end)
                end
                LS.CanvasSize = UDim2.new(0, 0, 0, IL.AbsoluteContentSize.Y + 8)
                Tw(LF, {Size = UDim2.new(0, 116, 0, math.min(#vals * 31 + 8, 160))}, 0.2, Enum.EasingStyle.Back)
            end

            dBtn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    local ap = dBtn.AbsolutePosition; local as = dBtn.AbsoluteSize
                    LF.Position = UDim2.new(0, ap.X, 0, ap.Y + as.Y + 4)
                    LF.Size = UDim2.new(0, 116, 0, 0); LF.Visible = true; Build()
                else Close() end
            end)
            UIS.InputBegan:Connect(function(inp)
                if open and isTap(inp) then
                    local mp = UIS:GetMouseLocation(); local lp = LF.AbsolutePosition; local ls = LF.AbsoluteSize
                    if not (mp.X >= lp.X and mp.X <= lp.X + ls.X and mp.Y >= lp.Y and mp.Y <= lp.Y + ls.Y) then Close() end
                end
            end)
            function obj:Set(v) cur = v; obj.Value = v; dBtn.Text = v; if o.Callback then o.Callback(v) end end
            function obj:Refresh(nv) vals = nv; obj.Values = nv; if open then Build() end end
            _G["DemonDropdown_" .. (id or "")] = obj
            return obj
        end

        -- ── INPUT ──
        function Tab:AddInput(id, o)
            o = o or {}
            local row = Row(o.Title or "Input", o.Description, 175)
            local box = New("TextBox", {Text = o.Default or "", PlaceholderText = o.Placeholder or "Type here...", Font = T.Font, TextSize = 12, TextColor3 = T.TextPri, PlaceholderColor3 = T.TextDim, BackgroundColor3 = T.SliderTrack, Size = UDim2.new(0, 166, 0, 27), Position = UDim2.new(1, -174, 0.5, -13.5), ClearTextOnFocus = false, Parent = row}, {Corner(UDim.new(0, 6)), Stroke(T.Border), Pad(0, 8, 0, 8)})
            box.Focused:Connect(function()   Tw(box, {BackgroundColor3 = Color3.fromRGB(26, 36, 62)}, 0.14) end)
            box.FocusLost:Connect(function(enter) Tw(box, {BackgroundColor3 = T.SliderTrack}, 0.14); if o.Callback then o.Callback(box.Text, enter) end end)
            local obj = {Value = box.Text}
            box:GetPropertyChangedSignal("Text"):Connect(function() obj.Value = box.Text; if o.Changed then o.Changed(box.Text) end end)
            function obj:Set(v) box.Text = v; obj.Value = v end
            _G["DemonInput_" .. (id or "")] = obj
            return obj
        end

        -- ── KEYBIND ──
        function Tab:AddKeybind(id, o)
            o = o or {}
            local cur = o.Default or Enum.KeyCode.Unknown
            local listening = false
            local row  = Row(o.Title or "Keybind", o.Description, 94)
            local kBtn = New("TextButton", {Text = cur.Name, Font = T.FontMono, TextSize = 11, TextColor3 = T.TextPri, BackgroundColor3 = T.SliderTrack, Size = UDim2.new(0, 86, 0, 27), Position = UDim2.new(1, -93, 0.5, -13.5), AutoButtonColor = false, Parent = row}, {Corner(UDim.new(0, 6)), Stroke(T.Border)})
            local obj = {Value = cur}
            kBtn.MouseButton1Click:Connect(function()
                listening = true; kBtn.Text = "..."; Tw(kBtn, {BackgroundColor3 = Color3.fromRGB(26, 36, 62)}, 0.12)
            end)
            UIS.InputBegan:Connect(function(inp, gpe)
                if listening and inp.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false; cur = inp.KeyCode; obj.Value = cur; kBtn.Text = cur.Name
                    Tw(kBtn, {BackgroundColor3 = T.SliderTrack}, 0.14)
                    if o.Callback then o.Callback(cur) end
                end
                if not gpe and not listening and inp.KeyCode == cur then
                    if o.OnPress then o.OnPress() end
                end
            end)
            function obj:Set(k) cur = k; obj.Value = k; kBtn.Text = k.Name end
            _G["DemonKeybind_" .. (id or "")] = obj
            return obj
        end

        -- ── LABEL ──
        function Tab:AddLabel(txt)
            New("TextLabel", {Text = txt, Font = T.Font, TextSize = 12, TextColor3 = T.TextSec, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), TextXAlignment = Enum.TextXAlignment.Left, Parent = Page}, {Pad(0, 0, 0, 4)})
        end

        return Tab
    end

    function Win:SelectTab(i)
        if self._tabs[i] then self._tabs[i]._select() end
    end

    -- Welcome screen seukuran & seposisi window
    MF.Visible = false
    task.defer(function()
        local vp   = workspace.CurrentCamera.ViewportSize
        local posX = math.floor((vp.X - WW) / 2)
        local posY = math.floor((vp.Y - WH) / 2)
        ShowWelcome(SG, WW, WH, posX, posY, function()
            MF.Visible = true
            MF.Size = UDim2.fromOffset(WW, 0)
            Tw(MF, {BackgroundTransparency = 0}, 0.08)
            Tw(MF, {Size = W}, 0.35, Enum.EasingStyle.Back)
        end)
    end)

    return Win
end

-- ════════════════════════════════════════════════════════════════
-- SET THEME
-- ════════════════════════════════════════════════════════════════

function DemonUI:SetTheme(opts)
    for k, v in pairs(opts or {}) do
        if T[k] ~= nil then T[k] = v end
    end
end

return DemonUI
