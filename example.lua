-- ══════════════════════════════════════════════════
--         Demon UI  •  Example Script
--         Made By Jova
-- ══════════════════════════════════════════════════
-- Ganti URL di bawah dengan raw pastebin link kamu
local DemonUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/dqwchwqwuvbqvtwvq/DemonUi/refs/heads/main/source/DemonUI.lua"))()

-- ── Buat Window ──────────────────────────────────
local Window = DemonUI:CreateWindow({
    Title       = "Demon UI",
    SubTitle    = "Made By Jova",
    Size        = UDim2.fromOffset(360, 380),
    MinimizeKey = Enum.KeyCode.RightControl,
})

-- ── Tab: Main ────────────────────────────────────
local Main = Window:AddTab({ Title = "Main" })

Main:AddParagraph({
    Title   = "Selamat datang!",
    Content = "Demon UI aktif. Atur fitur di tab masing-masing."
})

Main:AddSection("Movement")

Main:AddSlider("WalkSpeed", {
    Title    = "Walk Speed",
    Description = "Default: 16",
    Default  = 16, Min = 16, Max = 250, Rounding = 1,
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = v
        end
    end
})

Main:AddSlider("JumpPower", {
    Title    = "Jump Power",
    Description = "Default: 50",
    Default  = 50, Min = 50, Max = 500, Rounding = 10,
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = v
        end
    end
})

Main:AddToggle("InfJump", {
    Title    = "Infinite Jump",
    Default  = false,
    Callback = function(v) _G.InfJump = v end
})

Main:AddToggle("Noclip", {
    Title    = "Noclip",
    Default  = false,
    Callback = function(v) _G.Noclip = v end
})

Main:AddSection("Actions")

Main:AddButton({
    Title      = "Reset Character",
    Description = "Respawn karakter kamu",
    ButtonText = "Reset",
    Callback   = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})

-- ── Tab: Combat ───────────────────────────────────
local Combat = Window:AddTab({ Title = "Combat" })

Combat:AddSection("Aimbot")

Combat:AddToggle("Aimbot", {
    Title    = "Aimbot",
    Default  = false,
    Callback = function(v) _G.Aimbot = v end
})

Combat:AddSlider("AimbotFOV", {
    Title    = "FOV",
    Description = "Radius aimbot",
    Default  = 90, Min = 10, Max = 360, Rounding = 1,
    Callback = function(v) _G.AimbotFOV = v end
})

Combat:AddDropdown("AimbotPart", {
    Title    = "Target Part",
    Values   = { "Head", "HumanoidRootPart", "Torso" },
    Default  = "Head",
    Callback = function(v) _G.AimbotPart = v end
})

-- ── Tab: Visual ───────────────────────────────────
local Visual = Window:AddTab({ Title = "Visual" })

Visual:AddSection("ESP")

Visual:AddToggle("ESP", {
    Title    = "Player ESP",
    Default  = false,
    Callback = function(v) _G.ESP = v end
})

Visual:AddColorPicker("ESPColor", {
    Title    = "ESP Color",
    Default  = Color3.fromRGB(88, 140, 255),
    Callback = function(c) _G.ESPColor = c end
})

Visual:AddSlider("ESPDist", {
    Title    = "Max Distance",
    Description = "Jarak render (studs)",
    Default  = 500, Min = 100, Max = 2000, Rounding = 50,
    Callback = function(v) _G.ESPDist = v end
})

-- ── Tab: Settings ──────────────────────────────────
local Settings = Window:AddTab({ Title = "Settings" })

Settings:AddKeybind("ToggleKey", {
    Title    = "Toggle GUI",
    Description = "Tekan untuk buka/tutup",
    Default  = Enum.KeyCode.RightControl,
    Callback = function(key)
        DemonUI:Notify({ Title = "Keybind", Content = "Key: "..key.Name, Duration = 2 })
    end
})

Settings:AddColorPicker("Accent", {
    Title    = "Accent Color",
    Default  = Color3.fromRGB(88, 140, 255),
    Callback = function(c)
        DemonUI:SetTheme({ Accent = c, TogOn = c, SliderFill = c })
    end
})

Settings:AddInput("PlayerTarget", {
    Title       = "Target Player",
    Description = "Nama player target",
    Placeholder = "Player1",
    Callback    = function(txt) _G.Target = txt end
})

-- ── Logic: Infinite Jump ───────────────────────────
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump then
        local c = game.Players.LocalPlayer.Character
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ── Logic: Noclip ─────────────────────────────────
game:GetService("RunService").Stepped:Connect(function()
    if _G.Noclip then
        local c = game.Players.LocalPlayer.Character
        if c then
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end)

Window:SelectTab(1)
