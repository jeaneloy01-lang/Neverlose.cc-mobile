-- =====================================================================
-- PROJECT: NEVERLOSE CUSTOM PRIVATE (BLOX STRIKE MOBILE)
-- Lógica Dinâmica de Times + Motor Híbrido 3D/2D
-- =====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

---------------------------------------------------------
-- UI & BLINDAGEM DO ESP
---------------------------------------------------------
local success, guiParent = pcall(function() return gethui() end)
if not success then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

if guiParent:FindFirstChild("NL_System") then guiParent.NL_System:Destroy() end

local ScreenGui = Instance.new("ScreenGui", guiParent)
ScreenGui.Name = "NL_System"
ScreenGui.ResetOnSpawn = false

-- Pasta invisível que o jogo não consegue detectar nem deletar
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
local Watermark = window:Watermark()
local ping = Watermark:AddBlock("chart-four-vertical-bars", "0MS")
task.spawn(function() while task.wait(1) do ping:SetText(tostring(LocalPlayer:GetNetworkPing())..'MS') end end)

---------------------------------------------------------
-- VARIÁVEIS DE CONFIGURAÇÃO
---------------------------------------------------------
local CFG = {
    -- Aimbot / Rage
    AutoShoot = false, SilentAim = false, FOV = 120, Hitbox = false, HitboxSize = 3, SpinBot = false,
    -- Visuals
    Chams = false, CornerBox = false, Skeleton = false, NameDist = false, Health = false, Gun = false,
    -- World
    NightMode = false, NeonChams = false, SkinChanger = false, SkinMode = "Gold"
}

-- FOV Ring Nativo
local FOVRing = Instance.new("Frame", ScreenGui)
FOVRing.BackgroundTransparency = 1
FOVRing.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVRing.AnchorPoint = Vector2.new(0.5, 0.5)
local FOVStroke = Instance.new("UIStroke", FOVRing)
FOVStroke.Color = Color3.fromRGB(255, 255, 255)
FOVStroke.Thickness = 1.5

---------------------------------------------------------
-- TAB 1: RAGEBOT & AIMBOT
---------------------------------------------------------
window:AddTabLabel('RAGEBOT')
local Rage = window:AddTab({ Icon = 'crosshairs', Name = "Aimbot" })
local MainAim = Rage:AddSection({ Name = "MAIN" })
local AntiAim = Rage:AddSection({ Name = "ANTI-AIM", Position = 'right' })

MainAim:AddLabel('Silent Aim (CamLock)'):AddToggle({ Default = false, Callback = function(v) CFG.SilentAim = v end })
MainAim:AddLabel('Field of View (FOV)'):AddSlider({ Min = 10, Max = 400, Default = 120, Callback = function(v) CFG.FOV = v end })
MainAim:AddLabel('Auto Shoot (Trigger)'):AddToggle({ Default = false, Callback = function(v) CFG.AutoShoot = v end })
MainAim:AddLabel('Head Hitbox Expander'):AddToggle({ Default = false, Callback = function(v) CFG.Hitbox = v end })
MainAim:AddLabel('Hitbox Size (Max 3)'):AddSlider({ Min = 1, Max = 3, Default = 3, Callback = function(v) CFG.HitboxSize = v end })

AntiAim:AddLabel('Spinbot (Rage)'):AddToggle({ Default = false, Callback = function(v) CFG.SpinBot = v end })

---------------------------------------------------------
-- TAB 2: VISUALS
---------------------------------------------------------
window:AddTabLabel('VISUALS')
local Visuals = window:AddTab({ Icon = 'eye', Name = "Visuals" })
local EspSec = Visuals:AddSection({ Name = "PLAYER ESP" })
local WorldSec = Visuals:AddSection({ Name = "WORLD & WEAPONS", Position = 'right' })

EspSec:AddLabel('Neon Chams'):AddToggle({ Default = false, Callback = function(v) CFG.Chams = v end })
EspSec:AddLabel('Corner Box'):AddToggle({ Default = false, Callback = function(v) CFG.CornerBox = v end })
EspSec:AddLabel('Skeleton ESP'):AddToggle({ Default = false, Callback = function(v) CFG.Skeleton = v end })
EspSec:AddLabel('Name & Distance'):AddToggle({ Default = false, Callback = function(v) CFG.NameDist = v end })
EspSec:AddLabel('Health Bar'):AddToggle({ Default = false, Callback = function(v) CFG.Health = v end })
EspSec:AddLabel('Gun ESP'):AddToggle({ Default = false, Callback = function(v) CFG.Gun = v end })

WorldSec:AddLabel('Night Mode'):AddToggle({ Default = false, Callback = function(v) CFG.NightMode = v end })
WorldSec:AddLabel('Weapon Skin Changer'):AddToggle({ Default = false, Callback = function(v) CFG.SkinChanger = v end })
WorldSec:AddLabel('Skin Material'):AddDropdown({ Default = 'Gold', Values = {'Gold', 'ForceField', 'Neon', 'Diamond'}, Callback = function(v) CFG.SkinMode = v end })

---------------------------------------------------------
-- MOTOR LÓGICO: A IDENTIFICAÇÃO DINÂMICA
---------------------------------------------------------
-- Essa função resolve o bug do lobby. Ela descobre seu time toda hora.
local function GetTeams()
    local ct = Workspace:FindFirstChild("Counter-Terrorists")
    local t = Workspace:FindFirstChild("Terrorists")
    local myTeam = "None"
    
    if ct and ct:FindFirstChild(LocalPlayer.Name) then myTeam = "CT"
    elseif t and t:FindFirstChild(LocalPlayer.Name) then myTeam = "T" end
    
    return myTeam, ct, t
end

-- Estrutura para os ossos do Skeleton (baseado na sua print R15)
local BonesMap = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
}

local ActiveESP = {}

RunService.RenderStepped:Connect(function()
    -- 1. Atualiza FOV
    FOVRing.Size = UDim2.new(0, CFG.FOV * 2, 0, CFG.FOV * 2)
    FOVRing.Visible = (CFG.SilentAim or CFG.AutoShoot)

    -- 2. Sistema de Times Dinâmico
    local myTeam, ctFolder, tFolder = GetTeams()
    local foldersToScan = {}
    if ctFolder then table.insert(foldersToScan, {ctFolder, "CT"}) end
    if tFolder then table.insert(foldersToScan, {tFolder, "T"}) end

    -- Limpa ESP de mortos/desconectados
    for model, esp in pairs(ActiveESP) do
        if not model.Parent or (model.Parent ~= ctFolder and model.Parent ~= tFolder) then
            esp.Container:Destroy()
            ActiveESP[model] = nil
        end
    end

    local closestEnemy = nil
    local closestDist = CFG.FOV

    -- 3. Varredura Total
    for _, data in ipairs(foldersToScan) do
        local folder, teamName = data[1], data[2]
        
        for _, enemy in pairs(folder:GetChildren()) do
            if enemy:IsA("Model") and enemy.Name ~= LocalPlayer.Name then
                local head = enemy:FindFirstChild("Head")
                local hrp = enemy:FindFirstChild("HumanoidRootPart")
                local hum = enemy:FindFirstChild("Humanoid")

                if head and hrp then
                    -- Lógica Inimigo/Lobby (Se no lobby, todos são inimigos)
                    local isEnemy = (myTeam == "None") or (myTeam ~= teamName)
                    local clr = isEnemy and Color3.fromRGB(255, 40, 40) or Color3.fromRGB(40, 160, 255)

                    -- CRIA O ESP BLINDADO NA TELA SE NÃO EXISTIR
                    if not ActiveESP[enemy] then
                        local esp = { Container = Instance.new("Folder", ESP_Container), Lines = {} }
                        
                        -- Chams
                        esp.HL = Instance.new("Highlight", esp.Container)
                        esp.HL.Adornee = enemy
                        esp.HL.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        esp.HL.OutlineTransparency = 1
                        
                        -- HUD (Nome, HP, Arma, Distância)
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

                        -- Corner Box Nativo 2D
                        esp.BoxGui = Instance.new("ScreenGui", ESP_Container)
                        esp.Box = Instance.new("Frame", esp.BoxGui)
                        esp.Box.BackgroundTransparency = 1
                        local stroke = Instance.new("UIStroke", esp.Box)
                        stroke.Thickness = 2
                        esp.BoxStroke = stroke

                        -- Skeleton Lines
                        for _, bone in pairs(BonesMap) do
                            local line = Instance.new("LineHandleAdornment", esp.Container)
                            line.Thickness = 3
                            line.AlwaysOnTop = true
                            table.insert(esp.Lines, {line, bone[1], bone[2]})
                        end

                        ActiveESP[enemy] = esp
                    end

                    -- ATUALIZA O ESP
                    local esp = ActiveESP[enemy]
                    
                    -- Atualiza Textos
                    local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude * 0.28)
                    esp.Text.Text = enemy.Name .. " [" .. dist .. "m]"
                    
                    local tool = enemy:FindFirstChildOfClass("Tool")
                    esp.Weapon.Text = tool and tool.Name or "None"
                    
                    if hum then
                        local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        esp.Text.TextColor3 = Color3.fromRGB(255, hp * 255, 0) -- Muda de verde pra vermelho
                    end

                    -- Visibilidade HUD
                    esp.BB.Enabled = (CFG.NameDist or CFG.Gun or CFG.Health)
                    esp.Text.Visible = (CFG.NameDist or CFG.Health)
                    esp.Weapon.Visible = CFG.Gun

                    -- Visibilidade Chams
                    esp.HL.Enabled = CFG.Chams
                    esp.HL.FillColor = clr

                    -- Visibilidade Skeleton
                    for _, data in pairs(esp.Lines) do
                        local line, part1Name, part2Name = data[1], data[2], data[3]
                        local p1 = enemy:FindFirstChild(part1Name)
                        local p2 = enemy:FindFirstChild(part2Name)
                        
                        if CFG.Skeleton and p1 and p2 then
                            line.Adornee = p1
                            line.CFrame = CFrame.new(Vector3.new(), p2.Position - p1.Position)
                            line.Length = (p2.Position - p1.Position).Magnitude
                            line.Color3 = clr
                            line.Visible = true
                        else
                            line.Visible = false
                        end
                    end

                    -- Atualiza Corner Box 2D Nativa
                    local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if CFG.CornerBox and onScreen then
                        local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                        local bottom = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                        local height = math.abs(top.Y - bottom.Y)
                        local width = height / 1.8
                        
                        esp.Box.Size = UDim2.new(0, width, 0, height)
                        esp.Box.Position = UDim2.new(0, pos.X - (width/2), 0, top.Y)
                        esp.BoxStroke.Color = clr
                        esp.BoxGui.Enabled = true
                    else
                        esp.BoxGui.Enabled = false
                    end

                    -- HITBOX EXPANDER (Max 3)
                    if CFG.Hitbox and isEnemy then
                        local size = math.clamp(CFG.HitboxSize, 1, 3)
                        head.Size = Vector3.new(size, size, size)
                        head.Transparency = 0.6
                        head.Material = Enum.Material.ForceField
                        head.CanCollide = false
                    end

                    -- AIMBOT / AUTO SHOOT LOGIC
                    if isEnemy and onScreen then
                        local distToCrosshair = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        if distToCrosshair < closestDist then
                            closestDist = distToCrosshair
                            closestEnemy = head
                        end
                    end
                end
            end
        end
    end

    -- EXECUTA AIMBOT / AUTO SHOOT (Se encontrou alguém dentro do FOV)
    if closestEnemy then
        if CFG.SilentAim then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestEnemy.Position)
        end
        if CFG.AutoShoot then
            -- Força o toque na tela (Trigger)
            pcall(function() mouse1press(); task.wait(0.01); mouse1release() end)
        end
    end

    -- SPINBOT
    if CFG.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
    end

    -- NIGHT MODE
    Lighting.ClockTime = CFG.NightMode and 0 or 14
    Lighting.Ambient = CFG.NightMode and Color3.fromRGB(15, 15, 15) or Color3.fromRGB(128, 128, 128)

    -- SKIN CHANGER & NEON WEAPONS (Aplica na Câmera/Mão)
    if CFG.SkinChanger then
        local mat = Enum.Material.Foil
        if CFG.SkinMode == "Gold" then mat = Enum.Material.Foil
        elseif CFG.SkinMode == "ForceField" then mat = Enum.Material.ForceField
        elseif CFG.SkinMode == "Neon" then mat = Enum.Material.Neon
        elseif CFG.SkinMode == "Diamond" then mat = Enum.Material.Ice end

        for _, v in pairs(Camera:GetDescendants()) do
            if v:IsA("BasePart") and not v.Name:match("Arm") and not v.Name:match("Hand") then
                v.Material = mat
                if CFG.SkinMode == "Neon" then v.Color = Color3.fromRGB(220, 20, 60) end
            end
        end
    end
end)

Notification.new({ Title = "Neverlose Privado", Content = "Motor Dinâmico Ativado com Sucesso!", Duration = 5 })
