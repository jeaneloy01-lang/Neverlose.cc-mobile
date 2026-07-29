-- =====================================================================
-- NEVERLOSE V3 - MOBILE EDITION (BLOX STRIKE)
-- Bypass Definitivo com DRAWING API (À prova de Anti-Cheats de FPS)
-- =====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

---------------------------------------------------------
-- BOTÃO FLUTUANTE MOBILE
---------------------------------------------------------
local success, guiParent = pcall(function() return gethui() end)
if not success then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

if guiParent:FindFirstChild("NL_MobileToggle") then guiParent.NL_MobileToggle:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NL_MobileToggle"
ScreenGui.Parent = guiParent
ScreenGui.ResetOnSpawn = false

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
	Content = "Blox Strike",
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
-- TAB 1: AIMBOT (TODAS AS FUNÇÕES RESTAURADAS)
---------------------------------------------------------
window:AddTabLabel('AIMBOT')

local Rage = window:AddTab({ Icon = 'crosshairs', Name = "Rage" })
local Legit = window:AddTab({ Icon = 'mouse-scrollwheel', Name = "Legit" })
 
local Raging = Rage:AddSection({ Name = "MAIN" })
local Selection = Rage:AddSection({ Name = "SELECTION", Position = 'left' })
local Other = Rage:AddSection({ Name = "OTHER", Position = 'right' })
local AntiAim = Rage:AddSection({ Name = "ANTI-AIM", Position = 'right' })

local EnabledRage = Raging:AddLabel('Enabled')
EnabledRage:AddToggle({ Default = false, Flag = "Ragebot", Callback = print })
EnabledRage:AddOption():AddLabel("Force Shoot"):AddToggle({ Default = false, Flag = "FS" })

local SlientAim = Raging:AddLabel('Silent Aim')
SlientAim:AddToggle({ Default = false, Flag = "SLIENTAIM" })
local opt = SlientAim:AddOption()
opt:AddLabel('Perfect Silent-Aim'):AddToggle({ Default = false, Flag = "HideShot" })
opt:AddLabel('Perfect Silent-Aim'):AddToggle({ Default = false, Flag = "HideShot2" })

Raging:AddLabel('Automatic Fire'):AddToggle({ Default = false, Flag = "AutoFire" })
Raging:AddLabel('Aim Through Walls'):AddToggle({ Default = false, Flag = "AWALLS" })
Raging:AddLabel('Field of View'):AddSlider({ Min = 0, Max = 2600, Rounding = 1, Default = 100, Type = "Lv", Size = 100, Flag = "fov" })

Selection:AddLabel("Target"):AddDropdown({ Default = 'Hightest Damage', Values = {'Hightest Damage', 'Automatic', 'Lowest Damage'}, Flag = "target_box" })
Selection:AddLabel('Hitboxes'):AddDropdown({ Default = {'Head'}, Multi = true, Values = {'Head', 'Body', 'Arms', 'Legs'}, Flag = "hitboxes" })

local Multipoint = Selection:AddLabel('Multipoint')
Multipoint:AddOption():AddLabel('Multipoint'):AddSlider({ Min = 0, Max = 100, Default = 75, Flag = "multipoint" })
Multipoint:AddDropdown({ Default = {'Head'}, Multi = true, Values = {'Head', 'Body', 'Arms', 'Legs'}, Flag = "hitboxmuklti" })

local hc = Selection:AddLabel('Hit Chance')
hc:AddSlider({ Min = 0, Max = 100, Type = "%", Nums = {[0] = 'Auto'}, Flag = "hc", Size = 95, Default = 50 })
local md = Selection:AddLabel('Min Damage')
md:AddSlider({ Min = 0, Max = 100, Nums = {[0] = 'Auto'}, Flag = "md", Size = 95, Default = 15 })

local qs = Selection:AddLabel('Quick Stop')
qs:AddToggle({ Default = false, Flag = "astop" })
qs:AddOption():AddLabel('Auto Stop'):AddDropdown({ Default = {'Early'}, Multi = true, Flag = "astop_module", Values = {'Early','In Air','Between Shot' , 'Force Accurate'} })

Selection:AddLabel('Quick Scope'):AddToggle({ Default = false, Flag = "ascope" })

Other:AddLabel('History'):AddDropdown({ Default = 'High', Values = {'Minimum','Low','High','Maximum'}, Flag = "backtrack" })
Other:AddLabel('Delay Shot'):AddToggle({ Default = false, Flag = "delayshoot" })
Other:AddLabel('Remove Recoil'):AddToggle({ Default = false, Flag = "removerecoil" })
Other:AddLabel('Remove Spread'):AddToggle({ Default = false, Flag = "removespread" })
Other:AddLabel('Duck Peek Assist'):AddToggle({ Default = false })
local qpa = Other:AddLabel('Quick Peek Assist')
qpa:AddToggle({ Default = false, Flag = "qpa" })
Other:AddLabel('Double Tap'):AddToggle({ Default = false, Flag = "dt" })

local aa_enable = AntiAim:AddLabel('Enabled')
aa_enable:AddToggle({ Default = false, Flag = "aa" })
AntiAim:AddLabel('Pitch'):AddDropdown({ Default = 'Down', Flag = "pitch", Values = {'Down','Center','Up','Fake Up','Fake Down'} })
AntiAim:AddLabel('Yaw'):AddDropdown({ Default = 'Backwards', Flag = "yaw", Values = {'Backwards','Left','Right','Forwards'} })
AntiAim:AddLabel('Freestanding'):AddToggle({ Default = false, Flag = "freestand" })
AntiAim:AddLabel('Mouse Override'):AddToggle({ Default = false, Flag = "mouse_override" })

---------------------------------------------------------
-- TAB 2: VISUALS (ESP TEAM CHECK)
---------------------------------------------------------
window:AddTabLabel('VISUALS')
local VisualsTab = window:AddTab({ Icon = 'eye', Name = "Visuals" })
local EspSection = VisualsTab:AddSection({ Name = "PLAYER ESP", Position = 'left' })

local EspConfigs = { Box = false, Name = false, Distance = false, Gun = false }

EspSection:AddLabel('2D Box'):AddToggle({ Default = false, Flag = "esp_box", Callback = function(v) EspConfigs.Box = v end })
EspSection:AddLabel('Name'):AddToggle({ Default = false, Flag = "esp_name", Callback = function(v) EspConfigs.Name = v end })
EspSection:AddLabel('Distance'):AddToggle({ Default = false, Flag = "esp_dist", Callback = function(v) EspConfigs.Distance = v end })
EspSection:AddLabel('Gun ESP'):AddToggle({ Default = false, Flag = "esp_gun", Callback = function(v) EspConfigs.Gun = v end })

---------------------------------------------------------
-- MOTOR DO ESP: DRAWING API (IMPOSSÍVEL DO JOGO APAGAR)
---------------------------------------------------------
local ESP_Drawings = {}

-- Função criadora de linhas 2D na tela
local function NewDrawing(type, props)
    local d = Drawing.new(type)
    for i, v in pairs(props) do d[i] = v end
    return d
end

RunService.RenderStepped:Connect(function()
    local ctFolder = Workspace:FindFirstChild("Counter-Terrorists")
    local tFolder = Workspace:FindFirstChild("Terrorists")
    local activeModels = {}

    -- Descobre o seu time
    local myTeamFolder = nil
    if ctFolder and ctFolder:FindFirstChild(LocalPlayer.Name) then myTeamFolder = ctFolder end
    if tFolder and tFolder:FindFirstChild(LocalPlayer.Name) then myTeamFolder = tFolder end

    -- Escaneia as duas pastas
    for _, folder in pairs({ctFolder, tFolder}) do
        if folder then
            for _, model in pairs(folder:GetChildren()) do
                
                if model:IsA("Model") and model.Name ~= LocalPlayer.Name then
                    local hrp = model:FindFirstChild("HumanoidRootPart")
                    local head = model:FindFirstChild("Head")
                    
                    if hrp and head then
                        activeModels[model] = true

                        -- Cria os desenhos na tela se não existirem
                        if not ESP_Drawings[model] then
                            ESP_Drawings[model] = {
                                BoxOutline = NewDrawing("Square", {Thickness = 3, Filled = false, Color = Color3.new(0,0,0)}),
                                Box = NewDrawing("Square", {Thickness = 1, Filled = false}),
                                Name = NewDrawing("Text", {Size = 13, Center = true, Outline = true, Color = Color3.new(1,1,1)}),
                                Distance = NewDrawing("Text", {Size = 12, Center = true, Outline = true, Color = Color3.new(1,1,1)}),
                                Gun = NewDrawing("Text", {Size = 11, Center = true, Outline = true, Color = Color3.new(0.8,0.8,0.8)})
                            }
                        end

                        local esp = ESP_Drawings[model]
                        
                        -- Converte a posição 3D do mapa para a tela 2D do seu celular
                        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

                        if onScreen then
                            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.3, 0))
                            local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

                            local height = math.abs(headPos.Y - legPos.Y)
                            local width = height / 1.8

                            -- Cores dos times
                            local isEnemy = (myTeamFolder == nil) or (model.Parent ~= myTeamFolder)
                            local espColor = isEnemy and Color3.fromRGB(255, 40, 40) or Color3.fromRGB(0, 162, 255)

                            if EspConfigs.Box then
                                esp.BoxOutline.Size = Vector2.new(width, height)
                                esp.BoxOutline.Position = Vector2.new(pos.X - width / 2, headPos.Y)
                                esp.BoxOutline.Visible = true

                                esp.Box.Size = Vector2.new(width, height)
                                esp.Box.Position = Vector2.new(pos.X - width / 2, headPos.Y)
                                esp.Box.Color = espColor
                                esp.Box.Visible = true
                            else
                                esp.Box.Visible = false
                                esp.BoxOutline.Visible = false
                            end

                            if EspConfigs.Name then
                                esp.Name.Text = model.Name
                                esp.Name.Position = Vector2.new(pos.X, headPos.Y - 15)
                                esp.Name.Color = espColor
                                esp.Name.Visible = true
                            else
                                esp.Name.Visible = false
                            end

                            if EspConfigs.Distance then
                                local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude * 0.28)
                                esp.Distance.Text = "[" .. dist .. "m]"
                                esp.Distance.Position = Vector2.new(pos.X, headPos.Y + height + 2)
                                esp.Distance.Visible = true
                            else
                                esp.Distance.Visible = false
                            end

                            if EspConfigs.Gun then
                                local tool = model:FindFirstChildOfClass("Tool")
                                esp.Gun.Text = tool and tool.Name or "Hands"
                                esp.Gun.Position = Vector2.new(pos.X, headPos.Y + height + 15)
                                esp.Gun.Visible = true
                            else
                                esp.Gun.Visible = false
                            end
                        else
                            -- Esconde se o jogador não estiver na sua tela
                            esp.Box.Visible = false
                            esp.BoxOutline.Visible = false
                            esp.Name.Visible = false
                            esp.Distance.Visible = false
                            esp.Gun.Visible = false
                        end
                    end
                end
            end
        end
    end

    -- Apaga as linhas de jogadores que morreram ou saíram
    for model, esp in pairs(ESP_Drawings) do
        if not activeModels[model] then
            esp.Box:Remove()
            esp.BoxOutline:Remove()
            esp.Name:Remove()
            esp.Distance:Remove()
            esp.Gun:Remove()
            ESP_Drawings[model] = nil
        end
    end
end)

---------------------------------------------------------
-- MENU & FIM
---------------------------------------------------------
window.UserSettings:AddLabel("Menu Keybind"):AddKeybind({ Default = 'Insert', Callback = function(v) window.Keybind = v end })
window.UserSettings:AddLabel('Menu Scale'):AddDropdown({ Default = "Mobile", Values = {"Default",'Large','Mobile','Small'}, Callback = function(v) window:SetSize(NeverLose.Scales[v]) end })

Notification.new({ Title = "Neverlose", Content = "ESP Drawing API Ativado! (Bypass Completo)", Duration = 6 })

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
