-- =====================================================================
-- NEVERLOSE V3 - MOBILE EDITION (BLOX STRIKE)
-- Configurado para Delta Executor (Android)
-- =====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

---------------------------------------------------------
-- BOTÃO FLUTUANTE MOBILE (INJETADO ANTES DA UI)
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
	Size = NeverLose.Scales.Mobile, -- Escala de celular forçada
	ConfigFolder = "NeverLoseConfigs",
	Enable3DRenderer = false,
	Keybind = "Insert"
});

-- Função do botão Mobile
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
-- TAB 1: AIMBOT (Rage / Legit)
---------------------------------------------------------
window:AddTabLabel('AIMBOT')
local Rage = window:AddTab({ Icon = 'crosshairs', Name = "Rage" })
local Legit = window:AddTab({ Icon = 'mouse-scrollwheel', Name = "Legit" })
 
local Raging = Rage:AddSection({ Name = "MAIN" })
local Selection = Rage:AddSection({ Name = "SELECTION", Position = 'left' })
local Other = Rage:AddSection({ Name = "OTHER", Position = 'right' })
local AntiAim = Rage:AddSection({ Name = "ANTI-AIM", Position = 'right' })

local EnabledRage = Raging:AddLabel('Enabled')
EnabledRage:AddToggle({ Default = false, Flag = "Ragebot" })
EnabledRage:AddOption():AddLabel("Force Shoot"):AddToggle({ Default = false, Flag = "FS" })

local SlientAim = Raging:AddLabel('Silent Aim')
SlientAim:AddToggle({ Default = false, Flag = "SLIENTAIM" })
local opt = SlientAim:AddOption();
opt:AddLabel('Perfect Silent-Aim'):AddToggle({ Default = false, Flag = "HideShot" })

Raging:AddLabel('Automatic Fire'):AddToggle({ Default = false, Flag = "AutoFire" })
Raging:AddLabel('Aim Through Walls'):AddToggle({ Default = false, Flag = "AWALLS" })
Raging:AddLabel('Field of View'):AddSlider({ Min = 0, Max = 2600, Rounding = 1, Default = 100, Type = "Lv", Size = 100, Flag = "fov" })

Selection:AddLabel("Target"):AddDropdown({ Default = 'Hightest Damage', Values = {'Hightest Damage', 'Automatic', 'Lowest Damage'}, Flag = "target_box" })
Selection:AddLabel('Hitboxes'):AddDropdown({ Default = {'Head'}, Multi = true, Values = {'Head', 'Body', 'Arms', 'Legs'}, Flag = "hitboxes" })

local hc = Selection:AddLabel('Hit Chance')
hc:AddSlider({ Min = 0, Max = 100, Type = "%", Nums = {[0] = 'Auto'}, Flag = "hc", Size = 95, Default = 50 })
local md = Selection:AddLabel('Min Damage')
md:AddSlider({ Min = 0, Max = 100, Nums = {[0] = 'Auto'}, Flag = "md", Size = 95, Default = 15 })

Other:AddLabel('History'):AddDropdown({ Default = 'High', Values = {'Minimum','Low','High','Maximum'}, Flag = "backtrack" })
Other:AddLabel('Remove Recoil'):AddToggle({ Default = false, Flag = "removerecoil" })
Other:AddLabel('Remove Spread'):AddToggle({ Default = false, Flag = "removespread" })
Other:AddLabel('Double Tap'):AddToggle({ Default = false, Flag = "dt" })

local aa_enable = AntiAim:AddLabel('Enabled');
aa_enable:AddToggle({ Default = false, Flag = "aa" })
AntiAim:AddLabel('Pitch'):AddDropdown({ Default = 'Down', Flag = "pitch", Values = {'Down','Center','Up','Fake Up','Fake Down'} })
AntiAim:AddLabel('Yaw'):AddDropdown({ Default = 'Backwards', Flag = "yaw", Values = {'Backwards','Left','Right','Forwards'} })

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

-- Motor do ESP
local function CreateESP(player)
	if player == LocalPlayer then return end

	local Highlight = Instance.new("Highlight")
	Highlight.Name = "NL_Chams"
	Highlight.FillColor = Color3.fromRGB(150, 0, 255)
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0

	local Billboard = Instance.new("BillboardGui")
	Billboard.Name = "NL_ESP"
	Billboard.AlwaysOnTop = true
	Billboard.Size = UDim2.new(4, 0, 5.5, 0)
	Billboard.StudsOffset = Vector3.new(0, -0.5, 0)
	
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

	RunService.RenderStepped:Connect(function()
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
			local char = player.Character
			local hum = char.Humanoid
			
			if Highlight.Parent ~= char then Highlight.Parent = char end
			if Billboard.Parent ~= char.HumanoidRootPart then Billboard.Parent = char.HumanoidRootPart end

			Highlight.Enabled = EspConfigs.Chams
			Billboard.Enabled = (EspConfigs.Box or EspConfigs.Name or EspConfigs.Distance or EspConfigs.Gun or EspConfigs.HealthBar)
			
			Box.Visible = EspConfigs.Box
			HealthBG.Visible = EspConfigs.HealthBar

			local topString = ""
			if EspConfigs.Name then topString = topString .. player.Name .. " " end
			
			if EspConfigs.Distance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				local distStuds = (LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
				local distMeters = math.floor(distStuds * 0.28)
				topString = topString .. "[" .. distMeters .. "m]"
			end
			TopText.Text = topString
			TopText.Visible = (EspConfigs.Name or EspConfigs.Distance)

			if EspConfigs.Gun then
				local tool = char:FindFirstChildOfClass("Tool")
				BottomText.Text = tool and tool.Name or "None"
				BottomText.Visible = true
			else
				BottomText.Visible = false
			end

			if EspConfigs.HealthBar then
				local hpPercent = hum.Health / hum.MaxHealth
				HealthBar.Size = UDim2.new(1, 0, hpPercent, 0)
				HealthBar.BackgroundColor3 = Color3.fromRGB(255 - (hpPercent * 255), hpPercent * 255, 0)
			end
		else
			Highlight.Parent = nil
			Billboard.Parent = nil
		end
	end)
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

---------------------------------------------------------
-- CONFIGURAÇÕES (SETTINGS)
---------------------------------------------------------
window.UserSettings:AddLabel("Menu Keybind"):AddKeybind({
	Default = 'Insert',
	Callback = function(v) window.Keybind = v end,
})

window.UserSettings:AddLabel('Menu Scale'):AddDropdown({
	Default = "Mobile",
	Values = {"Default",'Large','Mobile','Small'},
	Callback = function(v) window:SetSize(NeverLose.Scales[v]) end,
})

window.UserSettings:AddLabel('3D Menu'):AddToggle({
	Default = false,
	Callback = function(v) window:Set3DRender(v) end,
})

Notification.new({ Title = "Neverlose Mobile", Content = "Injetado com sucesso pelo Delta!", Duration = 5 })

---------------------------------------------------------
-- LOOP DE INDICADORES VISUAIS
---------------------------------------------------------
HC:SetRender(true);
task.spawn(function()
	while true do task.wait(3)
		Watermark:SetRender(true);
		HC:SetColor('Red')
		HC:SetText("FL")
		task.wait(3);
		Watermark:SetRender(false);
		HC:SetColor('Green');
		HC:SetText("AUTO")
		task.wait(3)
		Watermark:SetRender(true);
		HC:SetColor('White')
		HC:SetText("HC")
		task.wait(1)
		Watermark:SetRender(false);
		HC:SetRender(false);
		task.wait(1)
		HC:SetRender(true);
	end
end)
