-- =====================================================================
-- NEVERLOSE V3 - MOBILE EDITION (BLOX STRIKE - TEAM CHECK ESP)
-- Configurado para Delta Executor (Android)
-- =====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

---------------------------------------------------------
-- BOTÃO FLUTUANTE MOBILE
---------------------------------------------------------
local success, guiParent = pcall(function() return gethui() end)
if not success then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

if guiParent:FindFirstChild("NL_MobileToggle") then
    guiParent.NL_MobileToggle:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NL_MobileToggle"
ScreenGui.Parent = guiParent

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
local Notification = NeverLose:CreateNotification();
local Logging = NeverLose:CreateLogger();
local Indicator = NeverLose:CreateIndicator();

local window = NeverLose:CreateWindow({
	Logo = NeverLose.GlobalLogo,
	Name = "Neverlose",
	Content = "Blox Strike",
	Size = NeverLose.Scales.Mobile,
	ConfigFolder = "NeverLoseConfigs",
	Enable3DRenderer = false,
	Keybind = "Insert"
});

ToggleBtn.MouseButton1Click:Connect(function()
    window:ToggleInterface()
end)

local Watermark = window:Watermark();
local HC = Indicator.new({ Name = "HC", Icon = 'crosshairs', Color = 'Red' })

local ping = Watermark:AddBlock("chart-four-vertical-bars" , "0MS");
local UITogg = Watermark:AddBlock("cube-vertexes" , "Neverlose");
UITogg:Input(function() window:ToggleInterface(); end);

task.spawn(function()
	while true do task.wait(1)
		ping:SetText(tostring(LocalPlayer:GetNetworkPing())..'MS')
	end
end)

---------------------------------------------------------
-- TAB 1: AIMBOT
---------------------------------------------------------
window:AddTabLabel('AIMBOT')
local Rage = window:AddTab({ Icon = 'crosshairs', Name = "Rage" })
local Legit = window:AddTab({ Icon = 'mouse-scrollwheel', Name = "Legit" })
 
local Raging = Rage:AddSection({ Name = "MAIN" })
local Selection = Rage:AddSection({ Name = "SELECTION", Position = 'left' })
local Other = Rage:AddSection({ Name = "OTHER", Position = 'right' })

local EnabledRage = Raging:AddLabel('Enabled')
EnabledRage:AddToggle({ Default = false, Flag = "Ragebot" })
local SlientAim = Raging:AddLabel('Silent Aim')
SlientAim:AddToggle({ Default = false, Flag = "SLIENTAIM" })
Raging:AddLabel('Field of View'):AddSlider({ Min = 0, Max = 2600, Rounding = 1, Default = 100, Type = "Lv", Size = 100, Flag = "fov" })
Selection:AddLabel('Hitboxes'):AddDropdown({ Default = {'Head'}, Multi = true, Values = {'Head', 'Body', 'Arms', 'Legs'}, Flag = "hitboxes" })
Other:AddLabel('Remove Recoil'):AddToggle({ Default = false, Flag = "removerecoil" })

---------------------------------------------------------
-- TAB 2: VISUALS (ESP TEAM CHECK)
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
-- MOTOR DO ESP (TEAM FOLDER CHECK)
---------------------------------------------------------
local ActiveESPs = {}

-- Descobre qual pasta é a do time inimigo baseando-se em onde está o seu nome
local function GetEnemyFolder()
    local ctFolder = Workspace:FindFirstChild("Counter-Terrorists")
    local tFolder = Workspace:FindFirstChild("Terrorists")
    local myName = LocalPlayer.Name

    if ctFolder and ctFolder:FindFirstChild(myName) then
        return tFolder
    elseif tFolder and tFolder:FindFirstChild(myName) then
        return ctFolder
    end
    return nil
end

RunService.RenderStepped:Connect(function()
    local enemyFolder = GetEnemyFolder()

    -- Remove ESP de bonecos que morreram ou foram apagados
    for model, espElements in pairs(ActiveESPs) do
        if not model.Parent or (enemyFolder and model.Parent ~= enemyFolder) then
            if espElements.Highlight then espElements.Highlight:Destroy() end
            if espElements.Billboard then espElements.Billboard:Destroy() end
            ActiveESPs[model] = nil
        end
    end

    if not enemyFolder then return end

    -- Aplica e atualiza o ESP apenas na pasta dos inimigos
    for _, enemyModel in pairs(enemyFolder:GetChildren()) do
        if enemyModel:IsA("Model") and enemyModel:FindFirstChild("HumanoidRootPart") then
            
            -- Cria a UI do inimigo se ainda não existir
            if not ActiveESPs[enemyModel] then
                local Highlight = Instance.new("Highlight")
                Highlight.Name = "NL_Chams"
                Highlight.FillColor = Color3.fromRGB(220, 20, 60) -- Vermelho avermelhado
                Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
                Highlight.FillTransparency = 0.5
                Highlight.OutlineTransparency = 0
                Highlight.Parent = enemyModel

                local Billboard = Instance.new("BillboardGui")
                Billboard.Name = "NL_ESP"
                Billboard.AlwaysOnTop = true
                Billboard.Size = UDim2.new(4, 0, 5.5, 0)
                Billboard.StudsOffset = Vector3.new(0, -0.5, 0)
                Billboard.Parent = enemyModel:FindFirstChild("HumanoidRootPart")
                
                local Box = Instance.new("Frame", Billboard)
                Box.Size = UDim2.new(1, 0, 1, 0)
                Box.BackgroundTransparency = 1
                local BoxStroke = Instance.new("UIStroke", Box)
                BoxStroke.Color = Color3.fromRGB(255, 255, 255)
                BoxStroke.Thickness = 1
                
                local TopText = Instance.new("TextLabel", Billboard)
                TopText.Size = UDim2.new(1, 0, 0, 15)
                TopText.Position = UDim2.new(0, 0, 0, -18)
                TopText.BackgroundTransparency = 1
                TopText.Font = Enum.Font.Code
                TopText.TextColor3 = Color3.fromRGB(255, 255, 255)
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
                    Highlight = Highlight, Billboard = Billboard, Box = Box, 
                    TopText = TopText, BottomText = BottomText, 
                    HealthBG = HealthBG, HealthBar = HealthBar
                }
            end

            -- Atualiza as informações do ESP em tempo real
            local esp = ActiveESPs[enemyModel]
            local hum = enemyModel:FindFirstChild("Humanoid")

            esp.Highlight.Enabled = EspConfigs.Chams
            esp.Billboard.Enabled = (EspConfigs.Box or EspConfigs.Name or EspConfigs.Distance or EspConfigs.Gun or EspConfigs.HealthBar)
            
            esp.Box.Visible = EspConfigs.Box
            esp.HealthBG.Visible = EspConfigs.HealthBar

            local topString = ""
            if EspConfigs.Name then topString = topString .. enemyModel.Name .. " " end
            
            if EspConfigs.Distance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distStuds = (LocalPlayer.Character.HumanoidRootPart.Position - enemyModel.HumanoidRootPart.Position).Magnitude
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

            if EspConfigs.HealthBar and hum then
                local hpPercent = hum.Health / hum.MaxHealth
                esp.HealthBar.Size = UDim2.new(1, 0, hpPercent, 0)
                esp.HealthBar.BackgroundColor3 = Color3.fromRGB(255 - (hpPercent * 255), hpPercent * 255, 0)
            end
        end
    end
end)

---------------------------------------------------------
-- CONFIGURAÇÕES E LOOP FINAL
---------------------------------------------------------
window.UserSettings:AddLabel("Menu Keybind"):AddKeybind({
	Default = 'Insert', Callback = function(v) window.Keybind = v end,
})

window.UserSettings:AddLabel('Menu Scale'):AddDropdown({
	Default = "Mobile", Values = {"Default",'Large','Mobile','Small'},
	Callback = function(v) window:SetSize(NeverLose.Scales[v]) end,
})

Notification.new({ Title = "Neverlose Mobile", Content = "ESP Inteligente (Teams) Injetado!", Duration = 5 })

HC:SetRender(true);
task.spawn(function()
	while true do task.wait(3)
		Watermark:SetRender(true);
		HC:SetColor('Red') HC:SetText("FL") task.wait(3);
		Watermark:SetRender(false);
		HC:SetColor('Green'); HC:SetText("AUTO") task.wait(3)
		Watermark:SetRender(true);
		HC:SetColor('White') HC:SetText("HC") task.wait(1)
		Watermark:SetRender(false); HC:SetRender(false); task.wait(1)
		HC:SetRender(true);
	end
end)
