-- =====================================================================
-- NEVERLOSE V3 - MOBILE EDITION (BLOX STRIKE)
-- Fix do Quadrado Gigante (BoundingBox) + Raycast Silent Aim
-- =====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

---------------------------------------------------------
-- UI & BLINDAGEM DO SISTEMA
---------------------------------------------------------
local success, guiParent = pcall(function() return gethui() end)
if not success then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

if guiParent:FindFirstChild("NL_System") then guiParent.NL_System:Destroy() end

local ScreenGui = Instance.new("ScreenGui", guiParent)
ScreenGui.Name = "NL_System"
ScreenGui.ResetOnSpawn = false

local ESP_Container = Instance.new("Folder", ScreenGui)
ESP_Container.Name = "Safe_ESP"

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

-- FOV CIRCLE (2D GUI)
local FovGui = Instance.new("ScreenGui", ESP_Container)
local FovFrame = Instance.new("Frame", FovGui)
FovFrame.BackgroundTransparency = 1
FovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
local FovCorner = Instance.new("UICorner", FovFrame)
FovCorner.CornerRadius = UDim.new(1, 0)
local FovStroke = Instance.new("UIStroke", FovFrame)
FovStroke.Color = Color3.fromRGB(255, 255, 255)
FovStroke.Thickness = 1.2

---------------------------------------------------------
-- BIBLIOTECA NEVERLOSE
---------------------------------------------------------
local NeverLose = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/NeverLose/refs/heads/main/source.luau"))()
local Notification = NeverLose:CreateNotification()

local window = NeverLose:CreateWindow({
	Logo = NeverLose.GlobalLogo, Name = "Neverlose", Content = "Private Build",
	Size = NeverLose.Scales.Mobile, ConfigFolder = "NL_Configs", Enable3DRenderer = false, Keybind = "Insert"
})

ToggleBtn.MouseButton1Click:Connect(function() window:ToggleInterface() end)

---------------------------------------------------------
-- VARIÁVEIS DO HACK
---------------------------------------------------------
local CFG = {
    -- Rage
    SilentAim = false, FOV = 120, HideFov = false, AutoShoot = false, Hitbox = false, HitboxSize = 3, SpinBot = false,
    -- Visuals
    Chams = false, CornerBox = false, Skeleton = false, NameDist = false, Health = false, Gun = false,
    -- World
    NightMode = false, NeonChams = false
}

local ClosestEnemyAim = nil

---------------------------------------------------------
-- TABS & TOGGLES
---------------------------------------------------------
window:AddTabLabel('RAGEBOT')
local Rage = window:AddTab({ Icon = 'crosshairs', Name = "Aimbot" })
local MainAim = Rage:AddSection({ Name = "MAIN" })
local AntiAim = Rage:AddSection({ Name = "ANTI-AIM", Position = 'right' })

MainAim:AddLabel('Silent Aim (Raycast)'):AddToggle({ Default = false, Callback = function(v) CFG.SilentAim = v end })
MainAim:AddLabel('Hide Silent Aim Fov'):AddToggle({ Default = false, Callback = function(v) CFG.HideFov = v end })
MainAim:AddLabel('Field of View'):AddSlider({ Min = 10, Max = 400, Default = 120, Callback = function(v) CFG.FOV = v end })
MainAim:AddLabel('Auto Shoot'):AddToggle({ Default = false, Callback = function(v) CFG.AutoShoot = v end })
MainAim:AddLabel('Head Hitbox Expander'):AddToggle({ Default = false, Callback = function(v) CFG.Hitbox = v end })
MainAim:AddLabel('Hitbox Size (Max 3)'):AddSlider({ Min = 1, Max = 3, Default = 3, Callback = function(v) CFG.HitboxSize = v end })

AntiAim:AddLabel('Spinbot (Rage)'):AddToggle({ Default = false, Callback = function(v) CFG.SpinBot = v end })

window:AddTabLabel('VISUALS')
local Visuals = window:AddTab({ Icon = 'eye', Name = "Visuals" })
local EspSec = Visuals:AddSection({ Name = "PLAYER ESP" })
local WorldSec = Visuals:AddSection({ Name = "WORLD & WEAPONS", Position = 'right' })

EspSec:AddLabel('Chams'):AddToggle({ Default = false, Callback = function(v) CFG.Chams = v end })
EspSec:AddLabel('Corner Box'):AddToggle({ Default = false, Callback = function(v) CFG.CornerBox = v end })
EspSec:AddLabel('Name & Distance'):AddToggle({ Default = false, Callback = function(v) CFG.NameDist = v end })
EspSec:AddLabel('Health Bar'):AddToggle({ Default = false, Callback = function(v) CFG.Health = v end })
EspSec:AddLabel('Gun ESP'):AddToggle({ Default = false, Callback = function(v) CFG.Gun = v end })

WorldSec:AddLabel('Night Mode'):AddToggle({ Default = false, Callback = function(v) CFG.NightMode = v end })
WorldSec:AddLabel('Neon Weapons (Glow)'):AddToggle({ Default = false, Callback = function(v) CFG.NeonChams = v end })

---------------------------------------------------------
-- HOOK DE SILENT AIM (BYPASS DE FPS)
---------------------------------------------------------
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if CFG.SilentAim and ClosestEnemyAim and (method == "Raycast" or method == "FindPartOnRayWithIgnoreList") then
        if method == "Raycast" then
            args[2] = (ClosestEnemyAim.Position - args[1]).Unit * 1000
        elseif method == "FindPartOnRayWithIgnoreList" then
            args[1] = Ray.new(args[1].Origin, (ClosestEnemyAim.Position - args[1].Origin).Unit * 1000)
        end
        return oldNamecall(self, unpack(args))
    end
    return oldNamecall(self, ...)
end)

---------------------------------------------------------
-- FUNÇÕES DO ESP E LOOP PRINCIPAL
---------------------------------------------------------
local function GetTeams()
    local ct = Workspace:FindFirstChild("Counter-Terrorists")
    local t = Workspace:FindFirstChild("Terrorists")
    local myTeam = "None"
    
    if ct and ct:FindFirstChild(LocalPlayer.Name) then myTeam = "CT"
    elseif t and t:FindFirstChild(LocalPlayer.Name) then myTeam = "T" end
    
    return myTeam, ct, t
end

local ActiveESP = {}

RunService.RenderStepped:Connect(function()
    FovFrame.Size = UDim2.new(0, CFG.FOV * 2, 0, CFG.FOV * 2)
    FovFrame.Visible = (CFG.SilentAim and not CFG.HideFov)

    local myTeam, ctFolder, tFolder = GetTeams()
    local foldersToScan = {}
    if ctFolder then table.insert(foldersToScan, {ctFolder, "CT"}) end
    if tFolder then table.insert(foldersToScan, {tFolder, "T"}) end

    for model, esp in pairs(ActiveESP) do
        if not model.Parent or (model.Parent ~= ctFolder and model.Parent ~= tFolder) then
            esp.Container:Destroy()
            esp.BoxGui:Destroy()
            ActiveESP[model] = nil
        end
    end

    local closestDist = CFG.FOV
    ClosestEnemyAim = nil

    for _, data in ipairs(foldersToScan) do
        local folder, teamName = data[1], data[2]
        
        for _, enemy in pairs(folder:GetChildren()) do
            if enemy:IsA("Model") and enemy.Name ~= LocalPlayer.Name then
                local head = enemy:FindFirstChild("Head")
                local hrp = enemy:FindFirstChild("HumanoidRootPart")
                local hum = enemy:FindFirstChild("Humanoid")

                if head and hrp and hum and hum.Health > 0 then
                    local isEnemy = (myTeam == "None") or (myTeam ~= teamName)
                    local clr = isEnemy and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(40, 160, 255)

                    if not ActiveESP[enemy] then
                        local esp = { Container = Instance.new("Folder", ESP_Container) }
                        
                        esp.HL = Instance.new("Highlight", esp.Container)
                        esp.HL.Adornee = enemy
                        esp.HL.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        esp.HL.OutlineTransparency = 1
                        
                        esp.BB = Instance.new("BillboardGui", esp.Container)
                        esp.BB.Adornee = head
                        esp.BB.Size = UDim2.new(4, 0, 3, 0)
                        esp.BB.StudsOffset = Vector3.new(0, 1.5, 0)
                        esp.BB.AlwaysOnTop = true
                        
                        esp.Text = Instance.new("TextLabel", esp.BB)
                        esp.Text.Size = UDim2.new(1, 0, 0.4, 0)
                        esp.Text.BackgroundTransparency = 1
                        esp.Text.Font = Enum.Font.Code
                        esp.Text.TextSize = 13
                        esp.Text.TextStrokeTransparency = 0
                        esp.Text.TextColor3 = Color3.new(1,1,1)

                        esp.Weapon = Instance.new("TextLabel", esp.BB)
                        esp.Weapon.Size = UDim2.new(1, 0, 0.4, 0)
                        esp.Weapon.Position = UDim2.new(0, 0, 0.4, 0)
                        esp.Weapon.BackgroundTransparency = 1
                        esp.Weapon.Font = Enum.Font.Code
                        esp.Weapon.TextSize = 11
                        esp.Weapon.TextStrokeTransparency = 0
                        esp.Weapon.TextColor3 = Color3.fromRGB(200, 200, 200)

                        esp.BoxGui = Instance.new("ScreenGui", ESP_Container)
                        esp.Box = Instance.new("Frame", esp.BoxGui)
                        esp.Box.BackgroundTransparency = 1
                        local stroke = Instance.new("UIStroke", esp.Box)
                        stroke.Thickness = 2
                        esp.BoxStroke = stroke

                        ActiveESP[enemy] = esp
                    end

                    local esp = ActiveESP[enemy]
                    local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude * 0.28)
                    esp.Text.Text = enemy.Name .. " [" .. dist .. "m]"
                    
                    local tool = enemy:FindFirstChildOfClass("Tool")
                    esp.Weapon.Text = tool and tool.Name or "None"
                    
                    if hum then
                        local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        esp.Text.TextColor3 = Color3.fromRGB(255, hp * 255, 0)
                    end

                    esp.BB.Enabled = (CFG.NameDist or CFG.Gun or CFG.Health)
                    esp.Text.Visible = (CFG.NameDist or CFG.Health)
                    esp.Weapon.Visible = CFG.Gun
                    esp.HL.Enabled = CFG.Chams
                    esp.HL.FillColor = clr

                    if CFG.Hitbox and isEnemy then
                        local size = math.clamp(CFG.HitboxSize, 1, 3)
                        head.Size = Vector3.new(size, size, size)
                        head.Transparency = 0.5
                        head.CanCollide = false
                    end

                    -- AQUI ESTÁ A CORREÇÃO DA CAIXA GIGANTE (MATH DE BOUNDING BOX)
                    local cf, size = enemy:GetBoundingBox()
                    if size.Y < 1 then size = Vector3.new(4, 5, 4) end -- Força um tamanho normal se o jogo bugar
                    
                    local top3D = cf.Position + Vector3.new(0, size.Y / 2, 0)
                    local bottom3D = cf.Position - Vector3.new(0, size.Y / 2, 0)
                    
                    local top2D = Camera:WorldToViewportPoint(top3D)
                    local bottom2D = Camera:WorldToViewportPoint(bottom3D)
                    local center2D, onScreen = Camera:WorldToViewportPoint(cf.Position)

                    if CFG.CornerBox and onScreen and center2D.Z > 0 then
                        local height = math.abs(top2D.Y - bottom2D.Y)
                        local width = height / 1.6
                        
                        -- Trava de segurança: Se a caixa for maior que a tela (bug), esconde.
                        if height > Camera.ViewportSize.Y * 1.5 then
                            esp.BoxGui.Enabled = false
                        else
                            esp.Box.Size = UDim2.new(0, width, 0, height)
                            esp.Box.Position = UDim2.new(0, center2D.X - (width/2), 0, top2D.Y)
                            esp.BoxStroke.Color = clr
                            esp.BoxGui.Enabled = true
                        end
                    else
                        esp.BoxGui.Enabled = false
                    end

                    if isEnemy and onScreen then
                        local distToCrosshair = (Vector2.new(center2D.X, center2D.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        if distToCrosshair <= CFG.FOV and distToCrosshair < closestDist then
                            closestDist = distToCrosshair
                            ClosestEnemyAim = head
                        end
                    end
                else
                    if ActiveESP[enemy] then
                        ActiveESP[enemy].Container:Destroy()
                        ActiveESP[enemy].BoxGui:Destroy()
                        ActiveESP[enemy] = nil
                    end
                end
            end
        end
    end

    -- AUTO SHOOT (Usando fallback compatível com Delta Android)
    if CFG.AutoShoot and ClosestEnemyAim then
        pcall(function()
            if mouse1press then
                mouse1press()
                task.wait(0.05)
                mouse1release()
            else
                VirtualUser:Button1Down(Vector2.new(0, 0))
                task.wait(0.05)
                VirtualUser:Button1Up(Vector2.new(0, 0))
            end
        end)
    end

    -- NEON WEAPONS / CHAMS
    if CFG.NeonChams then
        for _, obj in pairs(Camera:GetDescendants()) do
            if obj:IsA("BasePart") and not obj.Name:lower():match("arm") and not obj.Name:lower():match("hand") then
                obj.Material = Enum.Material.Neon
                obj.Color = Color3.fromRGB(0, 255, 255)
            end
        end
    end

    -- SPINBOT
    if CFG.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
    end

    -- NIGHT MODE
    Lighting.ClockTime = CFG.NightMode and 0 or 14
    Lighting.Ambient = CFG.NightMode and Color3.fromRGB(15, 15, 15) or Color3.fromRGB(128, 128, 128)
end)

Notification.new({ Title = "Neverlose Privado", Content = "ESP Box Anti-Bug Carregado!", Duration = 5 })
