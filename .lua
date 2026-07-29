local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. Notificação para confirmar que o botão Execute funcionou
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Delta Executor",
    Text = "Injetando Neverlose...",
    Duration = 3
})

-- 2. Bypass de CoreGui para Mobile (Delta)
local guiParent
if gethui then
    guiParent = gethui()
else
    guiParent = game:GetService("CoreGui")
end

-- Se o Delta bloquear o CoreGui, joga direto na tela do jogador
local success = pcall(function()
    local test = Instance.new("ScreenGui")
    test.Parent = guiParent
    test:Destroy()
end)

if not success then
    guiParent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Limpa a versão anterior se você executar duas vezes
if guiParent:FindFirstChild("NeverloseMobile") then
    guiParent.NeverloseMobile:Destroy()
end

-- 3. Criação da Interface
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeverloseMobile"
ScreenGui.Parent = guiParent
ScreenGui.ResetOnSpawn = false -- Impede que a UI suma quando você morrer

-- Botão Flutuante (NL)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "NL"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 162, 255)
ToggleBtn.TextSize = 20
ToggleBtn.Draggable = true
ToggleBtn.Active = true

local CornerBtn = Instance.new("UICorner")
CornerBtn.CornerRadius = UDim.new(0, 8)
CornerBtn.Parent = ToggleBtn

-- Janela Principal
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -135)
MainFrame.Size = UDim2.new(0, 400, 0, 270)
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Visible = false -- Começa escondida, clique no botão "NL" para abrir

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainFrame

-- Barra Superior
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
TopBar.Size = UDim2.new(1, 0, 0, 35)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 6)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0.03, 0, 0, 0)
TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "NEVERLOSE  |  Blox Strike"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Área de Rolagem
local Content = Instance.new("ScrollingFrame")
Content.Parent = MainFrame
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 10, 0, 45)
Content.Size = UDim2.new(1, -20, 1, -55)
Content.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Content.ScrollBarThickness = 4

local UIList = Instance.new("UIListLayout")
UIList.Parent = Content
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)

-- Função de criar os Toggles
local function createToggle(name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Content
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = "  " .. name .. " [ OFF ]"
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = btn

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.Text = "  " .. name .. " [ ON ]"
            btn.TextColor3 = Color3.fromRGB(0, 162, 255)
        else
            btn.Text = "  " .. name .. " [ OFF ]"
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        if callback then callback(enabled) end
    end)
end

-- Adicionando Cheats
createToggle("ESP Chams (Visual)", function(v)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if v then
                if not p.Character:FindFirstChild("NL_Chams") then
                    local h = Instance.new("Highlight")
                    h.Name = "NL_Chams"
                    h.FillColor = Color3.fromRGB(0, 162, 255)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.Parent = p.Character
                end
            else
                if p.Character:FindFirstChild("NL_Chams") then
                    p.Character.NL_Chams:Destroy()
                end
            end
        end
    end
end)

createToggle("Hitbox Expander", function(v)
    _G.HitboxStatus = v
    while _G.HitboxStatus do
        task.wait(1)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
                p.Character.HumanoidRootPart.Transparency = 0.5
                p.Character.HumanoidRootPart.BrickColor = BrickColor.new("Bright blue")
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
end)

-- Sistema de abrir e fechar a aba
local isOpen = false
ToggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    MainFrame.Visible = isOpen
end)
