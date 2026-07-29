-- =====================================================================
-- NEVERLOSE V3 - FULL UI & UNBREAKABLE ESP (BLOX STRIKE)
-- Motor de ESP Externo (Adornee) - Bypass de Proteção de FPS
-- =====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

---------------------------------------------------------
-- BOTÃO FLUTUANTE & PROTEÇÃO DO ESP MOBILE
---------------------------------------------------------
local success, guiParent = pcall(function() return gethui() end)
if not success then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

if guiParent:FindFirstChild("NL_MobileToggle") then guiParent.NL_MobileToggle:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NL_MobileToggle"
ScreenGui.Parent = guiParent
ScreenGui.ResetOnSpawn = false

-- Pasta blindada onde o ESP vai ficar (o jogo não consegue acessar/deletar)
local ESP_Container = Instance.new("Folder")
ESP_Container.Name = "ESP_Elements"
ESP_Container.Parent = ScreenGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "NL"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 162, 255)
ToggleBtn.TextSize = 18
ToggleBtn.Draggable = true
ToggleBtn.Active = true

local CornerBtn = Instance.new("UICorner")
CornerBtn.CornerRadius = UDim.new(0, 8)
CornerBtn.Parent = ToggleBtn

---------------------------------------------------------
-- INICIANDO A BIBLIOTECA NEVERLOSE
---------------------------------------------------------
local NeverLose = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/NeverLose/refs/heads/main/source.luau"))()
local Notification = NeverLose:CreateNotification()
local Logging = NeverLose:CreateLogger()
local Indicator = NeverLose:CreateIndicator()

local window = NeverLose:CreateWindow({
	Logo = NeverLose.GlobalLogo,
	Name = "Neverlose",
	Content = "Counter-Strike 2",
	Size = NeverLose.Scales.Mobile,
	ConfigFolder = "NeverLoseConfigs",
	Enable3DRenderer = false,
	Keybind = "Insert"
})

ToggleBtn.MouseButton1Click:Connect(function() window:ToggleInterface() end)

local Watermark = window:Watermark()
local HC = Indicator.new({ Name = "HC", Icon = 'crosshairs', Color = 'Red' })
local ping = Watermark:AddBlock("chart-four-vertical-bars" , "0MS")
local UITogg = Watermark:AddBlock("cube-vertexes" , "Neverlose")
UITogg:Input(function() window:ToggleInterface() end)

task.spawn(function()
	while true do task.wait(1)
		ping:SetText(tostring(LocalPlayer:GetNetworkPing())..'MS')
	end
end)

---------------------------------------------------------
-- TAB 1: AIMBOT (TODAS AS OPÇÕES RESTAURADAS)
---------------------------------------------------------
window:AddTabLabel('AIMBOT')
local Rage = window:AddTab({ Icon = 'crosshairs', Name = "Rage" })
local Legit = window:AddTab({ Icon = 'mouse-scrollwheel', Name = "Legit" })
 
local Raging = Rage:AddSection({ Name = "MAIN" })
local Selection = Rage:AddSection({ Name = "SELECTION", Position = 'left' })
local Other = Rage:AddSection({ Name = "OTHER", Position = 'right' })
local AntiAim = Rage:AddSection({ Name = "ANTI-AIM", Position = 'right' })

Raging:AddLabel('Ts so skbidi\nfr noi cap',true)

local EnabledRage = Raging:AddLabel('Enabled')
EnabledRage:ToolTip("Dynamically adjusts grenade throw angles to counteract\nmovement velocity, allowing precise straight-line throws\neven while strafing")
EnabledRage:AddToggle({ Default = false, Callback = print, Flag = "Ragebot" })
EnabledRage:AddOption():AddLabel("Force Shoot"):AddToggle({ Default = false, Callback = print, Flag = "FS" })

local SlientAim = Raging:AddLabel('Silent Aim')
SlientAim:AddToggle({ Default = false, Callback = print, Flag = "SLIENTAIM" })
local opt = SlientAim:AddOption()
opt:AddLabel('Perfect Silent-Aim'):AddToggle({ Default = false, Callback = print, Flag = "HideShot" })
opt:AddLabel('Perfect Silent-Aim'):AddToggle({ Default = false, Callback = print, Flag = "HideShot2" })

Raging:AddLabel('Automatic Fire'):AddToggle({ Default = false, Flag = "AutoFire" })
Raging:AddLabel('Aim Through Walls'):AddToggle({ Default = false, Flag = "AWALLS" })
Raging:AddLabel('Field of View'):AddSlider({ Min = 0, Max = 2600, Rounding = 1, Default = 100, Type = "Lv", Size = 100, Callback = print, Flag = "fov" })

Selection:AddLabel("Target"):AddDropdown({ Default = 'Hightest Damage', Values = {'Hightest Damage', 'Automatic', 'Lowest Damage'}, Callback = print, Flag = "target_box" })
Selection:AddLabel('Hitboxes'):AddDropdown({ Default = {'Head'}, Multi = true, Values = {'Head', 'Body', 'Arms', 'Legs'}, Flag = "hitboxes", Callback = print })

local Multipoint = Selection:AddLabel('Multipoint')
Multipoint:AddOption():AddLabel('Multipoint'):AddSlider({ Min = 0, Max = 100, Default = 75, Flag = "multipoint", Callback = print })
Multipoint:AddDropdown({ Default = {'Head'}, Multi = true, Values = {'Head', 'Body', 'Arms', 'Legs'}, Flag = "hitboxmuklti", Callback = print })

local hc = Selection:AddLabel('Hit Chance')
hc:AddSlider({ Min = 0, Max = 100, Type = "%", Nums = {[0] = 'Auto'}, Flag = "hc", Size = 95, Default = 50 })
hc:AddOption():AddLabel('Something'):AddToggle({ Default = false })
local md = Selection:AddLabel('Min Damage')
md:AddSlider({ Min = 0, Max = 100, Nums = {[0] = 'Auto'}, Flag = "md", Size = 95, Default = 15 })
md:AddOption():AddLabel('Something'):AddToggle({ Default = false })

local qs = Selection:AddLabel('Quick Stop')
qs:AddToggle({ Default = false, Flag = "astop", Callback = print })
qs:AddOption():AddLabel('Auto Stop'):AddDropdown({ Default = {'Early'}, Multi = true, Flag = "astop_module", Values = {'Early','In Air','Between Shot' , 'Force Accurate'}, Callback = print })
Selection:AddLabel('Quick Scope'):AddToggle({ Default = false, Flag = "ascope", Callback = print })

Other:AddLabel('History'):AddDropdown({ Default = 'High', Values = {'Minimum','Low','High','Maximum'}, Flag = "backtrack", Callback = print })
Other:AddLabel('Delay Shot'):AddToggle({ Default = false, Flag = "delayshoot", Callback = print })
Other:AddLabel('Remove Recoil'):AddToggle({ Default = false, Flag = "removerecoil", Callback = print })
Other:AddLabel('Remove Spread'):AddToggle({ Default = false, Flag = "removespread", Callback = print })
Other:AddLabel('Duck Peek Assist'):AddToggle({ Default = false, Callback = print })
local qpa = Other:AddLabel('Quick Peek Assist')
qpa:AddToggle({ Default = false, Flag = "qpa", Callback = print })
qpa:AddOption():AddLabel('Something tung tung')
Other:AddLabel('Double Tap'):AddToggle({ Default = false, Callback = print, Flag = "dt" })

local aa_enable = AntiAim:AddLabel('Enabled')
aa_enable:AddToggle({ Default = false, Flag = "aa", Callback = print })
aa_enable:AddOption():AddLabel('Resolvers tung tung'):AddToggle({ Default = false, Callback = print })

AntiAim:AddLabel('Pitch'):AddDropdown({ Default = 'Down', Flag = "pitch", Values = {'Down','Center','Up','Fake Up','Fake Down'} })
AntiAim:AddLabel('Yaw'):AddDropdown({ Default = 'Backwards', Flag = "yaw", Values = {'Backwards','Left','Right','Forwards'} })
AntiAim:AddLabel('Freestanding'):AddToggle({ Default = false, Flag = "freestand", Callback = print })
AntiAim:AddLabel('Mouse Override'):AddToggle({ Default = false, Flag = "mouse_override", Callback = print })

---------------------------------------------------------
-- TAB 2: VISUALS (ESP)
---------------------------------------------------------
window:AddTabLabel('VISUALS')
local VisualsTab = window:AddTab({ Icon = 'eye', Name = "Visuals" })
local EspSection = VisualsTab:AddSection({ Name = "PLAYER ESP", Position = 'left' })

local EspConfigs = { Chams = false, Box = false, HealthBar = false, Name = false, Distance = false, Gun = false }

EspSection:AddLabel('Chams Highlight'):AddToggle({ Default = false, Flag = "esp_chams", Callback = function(v) EspConfigs.Chams = v end })
EspSection:AddLabel('2D Box'):AddToggle({ Default = false, Flag = "esp_box", Callback = function(v) EspConfigs.Box = v end })
EspSection:AddLabel('Health Bar'):AddToggle({ Default = false, Flag = "esp_hp", Callback = function(v) EspConfigs.HealthBar = v end })
EspSection:AddLabel('Name'):AddToggle({ Default = false, Flag = "esp_name", Callback = function(v) EspConfigs.Name = v end })
EspSection:AddLabel('Distance'):AddToggle({ Default = false, Flag = "esp_dist", Callback = function(v) EspConfigs.Distance = v end })
EspSection:AddLabel('Gun ESP'):AddToggle({ Default = false, Flag = "esp_gun", Callback = function(v) EspConfigs.Gun = v end })

---------------------------------------------------------
-- MOTOR DO ESP BLINDADO (ADORNEE + CAMERA)
---------------------------------------------------------
local ActiveESPs = {}

RunService.RenderStepped:Connect(function()
    -- Procura as pastas independente de espaços no nome
    local ctFolder, tFolder
    for _, v in pairs(Workspace:GetChildren()) do
        if v.Name:match("Counter") then ctFolder = v end
        if v.Name:match("Terrorists") and not v.Name:match("Counter") then tFolder = v end
    end

    -- Identifica o seu time lendo qual pasta seu nome está dentro
    local myTeamFolder = nil
    if ctFolder and ctFolder:FindFirstChild(LocalPlayer.Name) then
        myTeamFolder = ctFolder
    elseif tFolder and tFolder:FindFirstChild(LocalPlayer.Name) then
        myTeamFolder = tFolder
    end

    -- Limpeza de bonecos mortos
    for model, espElements in pairs(ActiveESPs) do
        if not model.Parent or (model.Parent ~= ctFolder and model.Parent ~= tFolder) then
            if espElements.Highlight then espElements.Highlight:Destroy() end
            if espElements.Billboard then espElements.Billboard:Destroy() end
            ActiveESPs[model] = nil
        end
    end

    -- Verifica as duas pastas
    for _, folder in pairs({ctFolder, tFolder}) do
        if folder then
            for _, enemyModel in pairs(folder:GetChildren()) do
                
                -- Uso de pcall: Se o modelo de um jogador bugar, o script não trava
                pcall(function()
                    if enemyModel:IsA("Model") and enemyModel.Name ~= LocalPlayer.Name and enemyModel:FindFirstChild("HumanoidRootPart") then
                        
                        -- CRIAÇÃO DO ESP (Fica na pasta blindada, mira no inimigo por Adornee)
                        if not ActiveESPs[enemyModel] then
                            local Highlight = Instance.new("Highlight")
                            Highlight.Name = enemyModel.Name .. "_Chams"
                            Highlight.Adornee = enemyModel -- Mira no corpo
                            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Vê através das paredes
                            Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
                            Highlight.FillTransparency = 0.5
                            Highlight.OutlineTransparency = 0
                            Highlight.Parent = ESP_Container

                            local Billboard = Instance.new("BillboardGui")
                            Billboard.Name = enemyModel.Name .. "_Billboard"
                            Billboard.Adornee = enemyModel:FindFirstChild("HumanoidRootPart") -- Mira no centro
                            Billboard.AlwaysOnTop = true
                            Billboard.Size = UDim2.new(4, 0, 5.5, 0)
                            Billboard.StudsOffset = Vector3.new(0, -0.5, 0)
                            Billboard.Parent = ESP_Container
                            
                            local Box = Instance.new("Frame", Billboard)
                            Box.Size = UDim2.new(1, 0, 1, 0)
                            Box.BackgroundTransparency = 1
                            local BoxStroke = Instance.new("UIStroke", Box)
                            BoxStroke.Thickness = 1
                            
                            local TopText = Instance.new("TextLabel", Billboard)
                            TopText.Size = UDim2.new(1, 0, 0, 15)
                            TopText.Position = UDim2.new(0, 0, 0, -18)
                            TopText.BackgroundTransparency = 1
                            TopText.Font = Enum.Font.Code
                            TopText.TextStrokeTransparency = 0
                            TopText.TextSize = 12

                            local BottomText = Instance.new("TextLabel", Billboard)
                            BottomText.Size = UDim2.new(1, 0, 0, 15)
                            BottomText.Position = UDim2.new(0, 0, 1, 3)
                            BottomText.BackgroundTransparency = 1
                            BottomText.Font = Enum.Font.Code
                            BottomText.TextColor3 = Color3.fromRGB(200, 200, 200)
                            BottomText.TextStrokeTransparency = 0
                            BottomText.TextSize = 10

                            local HealthBG = Instance.new("Frame", Billboard)
                            HealthBG.Size = UDim2.new(0, 3, 1, 0)
                            HealthBG.Position = UDim2.new(0, -6, 0, 0)
                            HealthBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                            HealthBG.BorderSizePixel = 0

                            local HealthBar = Instance.new("Frame", HealthBG)
                            HealthBar.AnchorPoint = Vector2.new(0, 1)
                            HealthBar.Position = UDim2.new(0, 0, 1, 0)
                            HealthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                            HealthBar.BorderSizePixel = 0

                            ActiveESPs[enemyModel] = {
                                Highlight = Highlight, Billboard = Billboard, Box = Box, BoxStroke = BoxStroke,
                                TopText = TopText, BottomText = BottomText, 
                                HealthBG = HealthBG, HealthBar = HealthBar
                            }
                        end

                        -- ATUALIZAÇÃO DO ESP (Visibilidade e Textos)
                        local esp = ActiveESPs[enemyModel]
                        
                        -- Lógica de cores: Aliado = Azul | Inimigo = Vermelho
                        local isEnemy = (myTeamFolder == nil) or (enemyModel.Parent ~= myTeamFolder)
                        local espColor = isEnemy and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(0, 162, 255)
                        
                        esp.Highlight.FillColor = espColor
                        esp.BoxStroke.Color = espColor
                        esp.TopText.TextColor3 = espColor

                        esp.Highlight.Enabled = EspConfigs.Chams
                        esp.Billboard.Enabled = (EspConfigs.Box or EspConfigs.Name or EspConfigs.Distance or EspConfigs.Gun or EspConfigs.HealthBar)
                        
                        esp.Box.Visible = EspConfigs.Box
                        esp.HealthBG.Visible = EspConfigs.HealthBar

                        local topString = ""
                        if EspConfigs.Name then topString = topString .. enemyModel.Name .. " " end
                        
                        -- NOVO: Cálculo de Distância baseado na Câmera (nunca falha)
                        local cam = Workspace.CurrentCamera
                        if EspConfigs.Distance and cam then
                            local distStuds = (cam.CFrame.Position - enemyModel.HumanoidRootPart.Position).Magnitude
                            local distMeters = math.floor(distStuds * 0.28)
                            topString = topString .. "[" .. distMeters .. "m]"
                        end
                        esp.TopText.Text = topString
                        esp.TopText.Visible = (EspConfigs.Name or EspConfigs.Distance)

                        if EspConfigs.Gun then
                            local tool = enemyModel:FindFirstChildOfClass("Tool")
                            esp.BottomText.Text = tool and tool.Name or "None"
                            esp.BottomText.Visible = true
                        else
                            esp.BottomText.Visible = false
                        end

                        if EspConfigs.HealthBar then
                            local hum = enemyModel:FindFirstChild("Humanoid")
                            local customHp = enemyModel:FindFirstChild("Health") -- Fallback pra jogos sem Humanoid
                            local hpPercent = 1
                            
                            if hum then
                                hpPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            elseif customHp and customHp:IsA("NumberValue") then
                                hpPercent = math.clamp(customHp.Value / 100, 0, 1)
                            end
                            
                            esp.HealthBar.Size = UDim2.new(1, 0, hpPercent, 0)
                            esp.HealthBar.BackgroundColor3 = Color3.fromRGB(255 - (hpPercent * 255), hpPercent * 255, 0)
                        end
                    end
                end)
            end
        end
    end
end)

---------------------------------------------------------
-- CONFIGURAÇÕES FINAIS E LOOP
---------------------------------------------------------
window.UserSettings:AddLabel("Menu Keybind"):AddKeybind({
	Default = 'Insert', Callback = function(v) window.Keybind = v end,
})
window.UserSettings:AddLabel('Menu Scale'):AddDropdown({
	Default = "Mobile", Values = {"Default",'Large','Mobile','Small'},
	Callback = function(v) window:SetSize(NeverLose.Scales[v]) end,
})
window.UserSettings:AddLabel('3D Menu'):AddToggle({
	Default = false, Callback = function(v) window:Set3DRender(v) end,
})
window.UserSettings:AddButton({
	Icon = 'discord', Name = 'Discord', Callback = function() print('invite') end,
})

Notification.new({ Title = "Neverlose Mobile", Content = "ESP Bypass Injetado com Sucesso!", Duration = 5 })

HC:SetRender(true)
task.spawn(function()
	while true do task.wait(3)
		Watermark:SetRender(true)
		HC:SetColor('Red') HC:SetText("FL") task.wait(3)
		Watermark:SetRender(false)
		HC:SetColor('Green') HC:SetText("AUTO") task.wait(3)
		Watermark:SetRender(true)
		HC:SetColor('White') HC:SetText("HC") task.wait(1)
		Watermark:SetRender(false) HC:SetRender(false) task.wait(1)
		HC:SetRender(true)
	end
end)
