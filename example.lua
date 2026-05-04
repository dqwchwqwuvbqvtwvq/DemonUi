local DemonUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/dqwchwqwuvbqvtwvq/DemonUi/refs/heads/main/source/DemonUIv1.lua"))()

local Window = DemonUI:CreateWindow({
    Title       = "Demon UI",
    SubTitle    = "Made By Jova",
    Size        = {Width = 400, Height = 465},  -- ubah Width/Height sesuka kamu
    MinimizeKey = Enum.KeyCode.RightControl,
})

local Main = Window:AddTab({ Title = "Main" })

Main:AddParagraph({
    Title   = "Selamat datang!",
    Content = "Demon UI aktif. Atur fitur di bawah ini."
})

Main:AddSection("Movement")

Main:AddSlider("WalkSpeed", {
    Title       = "Walk Speed",
    Description = "Default: 16",
    Default = 16, Min = 16, Max = 250, Rounding = 1,
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = v
        end
    end
})

Main:AddSlider("JumpPower", {
    Title       = "Jump Power",
    Description = "Default: 50",
    Default = 50, Min = 50, Max = 500, Rounding = 10,
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
    ButtonText = "Reset",
    Callback   = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})

local Combat = Window:AddTab({ Title = "Combat" })

Combat:AddSection("Aimbot")

Combat:AddToggle("Aimbot", {
    Title    = "Aimbot",
    Default  = false,
    Callback = function(v) _G.Aimbot = v end
})

Combat:AddSlider("FOV", {
    Title   = "FOV",
    Default = 90, Min = 10, Max = 360, Rounding = 1,
    Callback = function(v) _G.AimbotFOV = v end
})

Combat:AddDropdown("TargetPart", {
    Title   = "Target Part",
    Values  = {"Head", "HumanoidRootPart", "Torso"},
    Default = "Head",
    Callback = function(v) _G.AimbotPart = v end
})

local Visual = Window:AddTab({ Title = "Visual" })

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

local Settings = Window:AddTab({ Title = "Settings" })

Settings:AddKeybind("ToggleKey", {
    Title   = "Toggle GUI",
    Default = Enum.KeyCode.RightControl,
    Callback = function(key)
        DemonUI:Notify({ Title = "Keybind", Content = "Key: "..key.Name, Duration = 2 })
    end
})

Settings:AddColorPicker("AccentColor", {
    Title    = "Accent Color",
    Default  = Color3.fromRGB(88, 140, 255),
    Callback = function(c)
        DemonUI:SetTheme({ Accent = c, TogOn = c, SliderFill = c })
    end
})

-- Logic
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump then
        local c = game.Players.LocalPlayer.Character
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

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
