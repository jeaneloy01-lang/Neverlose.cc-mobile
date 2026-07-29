-- Carrega a Library idêntica à foto do Neverlose
local Neverlose = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxciaz/UniversalVisuals/main/NeverloseUI.lua"))()

-- Criar a Janela (idêntica ao Print)
local Window = Neverlose:CreateWindow({
    Title = "Neverlose",
    SubTitle = "Blox Strike",
    Game = "Counter-Strike 2", -- Subtítulo estilizado igual na print
    User = game.Players.LocalPlayer.DisplayName, -- Seu nome/Avatar no canto inferior esquerdo
    UserTitle = "Neverlose User"
})

---------------------------------------------------------
-- BOTÃO DE TOGGLE PARA MOBILE (ABRIR/FECHAR MENU NO DELTA)
---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "NLMobileToggle"
ScreenGui.Parent = game.CoreGui

ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
ToggleButton.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleButton.Size = UDim2.new(0, 42, 0, 42)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "NL"
ToggleButton.TextColor3 = Color3.fromRGB(0, 162, 255)
ToggleButton.TextSize = 18
ToggleButton.Active = true
ToggleButton.Draggable = true

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    Window:Toggle()
end)

---------------------------------------------------------
-- TAB: AIMBOT (Rage / Legit)
---------------------------------------------------------
local AimbotTab = Window:AddTab("Aimbot", "rbxassetid://6031280882")

-- Sub-abas do Aimbot (Rage / Legit)
local RagePage = AimbotTab:AddPage("Rage")
local LegitPage = AimbotTab:AddPage("Legit")

-- COLUNA 1: MAIN
local MainSection = RagePage:AddSection("MAIN")

MainSection:AddToggle("Enabled", false, function(state)
    -- Função do Aimbot Geral
end)

MainSection:AddToggle("Silent Aim", false, function(state)
    -- Função do Silent Aim
end)

MainSection:AddToggle("Automatic Fire", false, function(state)
    -- Função de Auto Fire
end)

MainSection:AddToggle("Aim Through Walls", false, function(state)
    -- Aim através de paredes
end)

MainSection:AddSlider("Field of View", 30, 300, 100, function(value)
    -- Tamanho do FOV
end)

local TargetDropdown = MainSection:AddDropdown("Target", {"Highest Damage", "Closest", "Lowest Health"}, "Highest Damage", function(selected)
    -- Seleção do Alvo
end)

local HitboxDropdown = MainSection:AddDropdown("Hitboxes", {"Head", "Torso", "All"}, "Head", function(selected)
    -- Hitboxes
end)

MainSection:AddSlider("Hit Chance", 0, 100, 50, function(value)
    -- Porcentagem de acerto
end)

MainSection:AddSlider("Min Damage", 1, 100, 15, function(value)
    -- Dano Mínimo
end)

-- COLUNA 2: OTHER
local OtherSection = RagePage:AddSection("OTHER")

OtherSection:AddDropdown("History", {"Low", "Medium", "High"}, "High", function(selected)
end)

OtherSection:AddToggle("Delay Shot", false, function(state) end)
OtherSection:AddToggle("Remove Recoil", false, function(state) end)
OtherSection:AddToggle("Remove Spread", false, function(state) end)
OtherSection:AddToggle("Duck Peek Assist", false, function(state) end)
OtherSection:AddToggle("Quick Peek Assist", false, function(state) end)
OtherSection:AddToggle("Double Tap", false, function(state) end)

---------------------------------------------------------
-- SEÇÃO ANTI-AIM (COLUNA OTHER)
---------------------------------------------------------
local AntiAimSection = RagePage:AddSection("ANTI-AIM")

AntiAimSection:AddToggle("Enabled", false, function(state) end)
AntiAimSection:AddDropdown("Pitch", {"None", "Down", "Up", "Zero"}, "Down", function(selected) end)
AntiAimSection:AddDropdown("Yaw", {"None", "Backwards", "Spin", "Jitter"}, "Backwards", function(selected) end)
AntiAimSection:AddToggle("Freestanding", false, function(state) end)
AntiAimSection:AddToggle("Mouse Override", false, function(state) end)

---------------------------------------------------------
-- DEMAIS ABAS (VISUALS / MISC)
---------------------------------------------------------
local VisualsTab = Window:AddTab("Visuals", "rbxassetid://6031763426")
local VisualsPage = VisualsTab:AddPage("ESP")
local EspMain = VisualsPage:AddSection("PLAYER ESP")

EspMain:AddToggle("Box ESP", false, function(state) end)
EspMain:AddToggle("Name ESP", false, function(state) end)
EspMain:AddToggle("Chams Highlight", false, function(state)
    -- Ativa/Desativa o Highlight dos Inimigos
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            if state then
                if not player.Character:FindFirstChild("NL_Chams") then
                    local h = Instance.new("Highlight")
                    h.Name = "NL_Chams"
                    h.FillColor = Color3.fromRGB(0, 162, 255)
                    h.OutlineColor = Color3.fromRGB(0, 0, 0)
                    h.Parent = player.Character
                end
            else
                if player.Character:FindFirstChild("NL_Chams") then
                    player.Character.NL_Chams:Destroy()
                end
            end
        end
    end
end)
