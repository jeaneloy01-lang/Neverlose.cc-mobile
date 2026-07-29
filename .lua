-- =====================================================================
-- NEVERLOSE V3 - CUSTOM PRIVATE BUILD (BLOX STRIKE)
-- Feito para Mobile (Delta) | Drawing ESP + Aimbot + Visuals Avançados
-- =====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local mouse = LocalPlayer:GetMouse()

---------------------------------------------------------
-- UI & BOTÃO MOBILE (ANTI-CRASH)
---------------------------------------------------------
local success, guiParent = pcall(function() return gethui() end)
if not success then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

if guiParent:FindFirstChild("NL_Toggle") then guiParent.NL_Toggle:Destroy() end

local ScreenGui = Instance.new("ScreenGui", guiParent)
ScreenGui.Name = "NL_Toggle"
ScreenGui.ResetOnSpawn = false

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "NL"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 162, 255)
ToggleBtn.TextSize = 18
ToggleBtn.Draggable = true

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

---------------------------------------------------------
-- BIBLIOTECA NEVERLOSE V3
---------------------------------------------------------
local NeverLose = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/NeverLose/refs/heads/main/source.luau"))()
local Notification = NeverLose:CreateNotification()
local Indicator = NeverLose:CreateIndicator()

local window = NeverLose:CreateWindow({
	Logo = NeverLose.GlobalLogo, Name = "Neverlose", Content = "Private Build",
	Size = NeverLose.Scales.Mobile, ConfigFolder = "NL_Config", Enable3DRenderer = false, Keybind = "Insert"
})

ToggleBtn.MouseButton1Click:Connect(function() window:ToggleInterface() end)

---------------------------------------------------------
-- VARIÁVEIS DO CHEAT
---------------------------------------------------------
local Configs = {
    -- Aimbot
    SilentAim = false, FOV = 100, AutoShoot = false, Hitbox = false, HitboxSize = 3,
    -- Visuals (ESP)
    Chams = false, CornerBox = false, Skeleton = false, Name = false, Distance = false, HealthBar = false,
    -- Misc
    Spinbot = false, NightMode = false, NeonWeapons = false, SkinChanger = false
}

-- Círculo do FOV na tela
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Transparency = 1

---------------------------------------------------------
-- TAB 1: RAGE & AIMBOT
---------------------------------------------------------
window:AddTabLabel('RAGEBOT')
local Rage = window:AddTab({ Icon = 'crosshairs', Name = "Aimbot" })
local Raging = Rage:AddSection({ Name = "MAIN" })
local MiscAim = Rage:AddSection({ Name = "MISC & ANTI-AIM", Position = 'right' })

Raging:AddLabel('Silent Aim'):AddToggle({ Default = false, Flag = "silent", Callback = function(v) Configs.SilentAim = v end })
Raging:AddLabel('Field of View (FOV)'):AddSlider({ Min = 10, Max = 500, Default = 100, Flag = "fov", Callback = function(v) Configs.FOV = v end })
Raging:AddLabel('Auto Shoot (Triggerbot)'):AddToggle({ Default = false, Flag = "autoshoot", Callback = function(v) Configs.AutoShoot = v end })

Raging:AddLabel('Head Hitbox Expander'):AddToggle({ Default = false, Flag = "hitbox", Callback = function(v) Configs.Hitbox = v end })
Raging:AddLabel('Hitbox Size (Max 3)'):AddSlider({ Min = 1, Max = 3, Default = 3, Flag = "hbsize", Callback = function(v) Configs.HitboxSize = v end })

MiscAim:AddLabel('Anti-Aim (Spinbot)'):AddToggle({ Default = false, Flag = "spin", Callback = function(v) Configs.Spinbot = v end })

---------------------------------------------------------
-- TAB 2: VISUALS & ESP
---------------------------------------------------------
window:AddTabLabel('VISUALS')
local Visuals = window:AddTab({ Icon = 'eye', Name = "Visuals" })
local EspSec = Visuals:AddSection({ Name = "PLAYER ESP" })
local WorldSec = Visuals:AddSection({ Name = "WORLD & WEAPONS", Position = 'right' })

EspSec:AddLabel('Chams'):AddToggle({ Default = false, Callback = function(v) Configs.Chams = v end })
EspSec:AddLabel('Corner Box'):AddToggle({ Default = false, Callback = function(v) Configs.CornerBox = v end })
EspSec:AddLabel('Skeleton ESP'):AddToggle({ Default = false, Callback = function(v) Configs.Skeleton = v end })
EspSec:AddLabel('Name & Distance'):AddToggle({ Default = false, Callback = function(v) Configs.Name = v; Configs.Distance = v end })
EspSec:AddLabel('Health Bar'):AddToggle({ Default = false, Callback = function(v) Configs.HealthBar = v end })

WorldSec:AddLabel('Night Mode'):AddToggle({ Default = false, Callback = function(v) Configs.NightMode = v end })
WorldSec:AddLabel('Neon Weapons (Glow)'):AddToggle({ Default = false, Callback = function(v) Configs.NeonWeapons = v end })
WorldSec:AddLabel('Skin Changer (Visual Only)'):AddToggle({ Default = false, Callback = function(v) Configs.SkinChanger = v end })

---------------------------------------------------------
-- LÓGICA DO MOTOR: ESP & SKELETON (DRAWING API)
---------------------------------------------------------
local Drawings = {}

local function CreateDrawings(model)
    return {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Line"),
        Skeleton = { -- Linhas dos ossos
            Spine = Drawing.new("Line"),
            ArmL = Drawing.new("Line"), ArmR = Drawing.new("Line"),
            LegL = Drawing.new("Line"), LegR = Drawing.new("Line")
        }
    }
end

RunService.RenderStepped:Connect(function()
    -- 1. FOV CIRCLE
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = Configs.FOV
    FOVCircle.Visible = Configs.SilentAim

    -- Encontra as pastas de time (Terrorists / Counter-Terrorists)
    local ct = Workspace:FindFirstChild("Counter-Terrorists")
    local t = Workspace:FindFirstChild("Terrorists")
    
    local myTeam = (ct and ct:FindFirstChild(LocalPlayer.Name)) and ct or (t and t:FindFirstChild(LocalPlayer.Name)) and t or nil

    for _, folder in pairs({ct, t}) do
        if folder then
            for _, inimigo in pairs(folder:GetChildren()) do
                if inimigo:IsA("Model") and inimigo.Name ~= LocalPlayer.Name and inimigo:FindFirstChild("HumanoidRootPart") then
                    
                    local hrp = inimigo.HumanoidRootPart
                    local head = inimigo:FindFirstChild("Head")
                    local isEnemy = (myTeam == nil) or (inimigo.Parent ~= myTeam)
                    local clr = isEnemy and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 150, 255)

                    -- DRAWING ESP
                    if not Drawings[inimigo] then Drawings[inimigo] = CreateDrawings(inimigo) end
                    local esp = Drawings[inimigo]
                    local pos, vis = Camera:WorldToViewportPoint(hrp.Position)

                    if vis and head then
                        local headP = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
                        local legP = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))
                        local h = math.abs(headP.Y - legP.Y)
                        local w = h / 2

                        -- Box & CornerBox Lógica
                        esp.Box.Size = Vector2.new(w, h)
                        esp.Box.Position = Vector2.new(pos.X - w/2, headP.Y)
                        esp.Box.Color = clr
                        esp.Box.Thickness = 1.5
                        esp.Box.Filled = false
                        esp.Box.Visible = Configs.CornerBox

                        -- Name & Distance
                        if Configs.Name then
                            local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude * 0.28)
                            esp.Name.Text = inimigo.Name .. " [" .. dist .. "m]"
                            esp.Name.Position = Vector2.new(pos.X, headP.Y - 15)
                            esp.Name.Color = clr
                            esp.Name.Size = 14
                            esp.Name.Center = true
                            esp.Name.Outline = true
                            esp.Name.Visible = true
                        else
                            esp.Name.Visible = false
                        end

                        -- Skeleton Simples
                        if Configs.Skeleton and inimigo:FindFirstChild("UpperTorso") then
                            local torsoP = Camera:WorldToViewportPoint(inimigo.UpperTorso.Position)
                            esp.Skeleton.Spine.From = Vector2.new(headP.X, headP.Y)
                            esp.Skeleton.Spine.To = Vector2.new(torsoP.X, torsoP.Y)
                            esp.Skeleton.Spine.Color = Color3.new(1,1,1)
                            esp.Skeleton.Spine.Visible = true
                            -- (Adicionar mais ossos exige checar LeftUpperArm, RightUpperLeg, etc)
                        else
                            esp.Skeleton.Spine.Visible = false
                        end
                    else
                        esp.Box.Visible = false
                        esp.Name.Visible = false
                        esp.Skeleton.Spine.Visible = false
                    end

                    -- CHAMS (HIGHLIGHT)
                    local hl = inimigo:FindFirstChild("NL_Chams")
                    if Configs.Chams then
                        if not hl then
                            hl = Instance.new("Highlight", inimigo)
                            hl.Name = "NL_Chams"
                            hl.FillTransparency = 0.5
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        end
                        hl.FillColor = clr
                        hl.OutlineColor = Color3.new(0,0,0)
                    elseif hl then
                        hl:Destroy()
                    end

                    -- HITBOX EXPANDER (Max 3)
                    if Configs.Hitbox and isEnemy and head then
                        head.Size = Vector3.new(Configs.HitboxSize, Configs.HitboxSize, Configs.HitboxSize)
                        head.Transparency = 0.5
                        head.CanCollide = false
                    end

                    -- AUTO SHOOT (Triggerbot)
                    if Configs.AutoShoot and isEnemy and vis then
                        -- Checa se o inimigo está dentro do círculo do FOV
                        local distToCenter = (Vector2.new(pos.X, pos.Y) - FOVCircle.Position).Magnitude
                        if distToCenter <= Configs.FOV then
                            -- Atira usando input nativo (funciona em alguns mobiles)
                            mouse1press()
                            task.wait(0.05)
                            mouse1release()
                        end
                    end
                end
            end
        end
    end
end)

---------------------------------------------------------
-- LOOP: SPINBOT, NIGHT MODE & NEON WEAPONS
---------------------------------------------------------
RunService.Stepped:Connect(function()
    -- SPINBOT (Gira o corpo absurdamente rápido)
    if Configs.Spinbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
    end

    -- NIGHT MODE
    if Configs.NightMode then
        Lighting.ClockTime = 0
        Lighting.Ambient = Color3.fromRGB(10, 10, 10)
    else
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
    end

    -- NEON WEAPONS (Deixa a arma brilhando na sua mão ou na câmera)
    if Configs.NeonWeapons then
        for _, obj in pairs(Camera:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:match("Part") or obj.Name:match("Mesh") then
                obj.Material = Enum.Material.Neon
                obj.Color = Color3.fromRGB(220, 20, 60) -- Vermelho Neverlose
            end
        end
    end
end)

Notification.new({ Title = "Neverlose Private", Content = "Script Customizado Carregado!", Duration = 5 })
