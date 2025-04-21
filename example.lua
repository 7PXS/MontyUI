local MontyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/7PXS/MontyUI/refs/heads/main/Source/Library.lua"))()

-- Create the main UI window with title
local UI = MontyUI.new("Monty Hub")

-- Create categories
local playerCategory = UI:CreateCategory("Player", nil, 1)
local visualsCategory = UI:CreateCategory("Visuals", nil, 2)
local combatCategory = UI:CreateCategory("Combat", nil, 3)
local miscCategory = UI:CreateCategory("Misc", nil, 4)

-- Player Tab
local playerTab = UI:CreateTab("Player", "PLAYER", playerCategory, 1)

-- Movement Section
local movementSection = playerTab:CreateSection("Movement")

-- Create a toggle
local speedToggle = movementSection:CreateToggle("Speed Boost", false, function(value)
    -- Speed boost logic here
    local player = game.Players.LocalPlayer
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        if value then
            humanoid.WalkSpeed = 32
        else
            humanoid.WalkSpeed = 16
        end
    end
end)

-- Create a slider
local jumpSection = playerTab:CreateSection("Jump Power")

local jumpSlider = jumpSection:CreateSlider("Jump Power", 50, 300, 50, 0, function(value)
    -- Jump power logic here
    local player = game.Players.LocalPlayer
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        humanoid.JumpPower = value
    end
end, "Power")

-- Character Section
local characterSection = playerTab:CreateSection("Character")

local noFallToggle = characterSection:CreateToggle("No Fall Damage", false, function(value)
    -- No fall damage logic here
    print("No Fall Damage:", value)
end)

local noClipToggle = characterSection:CreateToggle("NoClip", false, function(value)
    -- NoClip logic here
    print("NoClip:", value)
end)

-- Visuals Tab
local visualsTab = UI:CreateTab("Visuals", "VISUALS", visualsCategory, 1)

-- Create subtabs
local visualSubTabs = visualsTab:CreateSubTabs({"World", "ESP", "Effects"})

-- World subtab
local worldLightingSection = visualSubTabs.World:CreateSection("Lighting")

local brightnessSlider = worldLightingSection:CreateSlider("Brightness", 0, 100, 50, 0, function(value)
    -- Brightness logic here
    game.Lighting.Brightness = value / 50
end, "%")

local timeSlider = worldLightingSection:CreateSlider("Time of Day", 0, 24, 12, 1, function(value)
    -- Time of day logic here
    game.Lighting.ClockTime = value
end, "hr")

local ambientSection = visualSubTabs.World:CreateSection("Ambient")

local ambientColorPicker = ambientSection:CreateColorPicker("Ambient Color", Color3.fromRGB(127, 127, 127), function(color)
    -- Ambient color logic here
    game.Lighting.Ambient = color
end)

-- ESP subtab
local espSection = visualSubTabs.ESP:CreateSection("Players ESP")

local espToggle = espSection:CreateToggle("Enable ESP", false, function(value)
    -- ESP logic here
    print("ESP Enabled:", value)
end)

local boxESPToggle = espSection:CreateToggle("Box ESP", false, function(value)
    -- Box ESP logic here
    print("Box ESP:", value)
end)

local nameESPToggle = espSection:CreateToggle("Name ESP", false, function(value)
    -- Name ESP logic here
    print("Name ESP:", value)
end)

local distanceESPToggle = espSection:CreateToggle("Distance ESP", false, function(value)
    -- Distance ESP logic here
    print("Distance ESP:", value)
end)

local teamESPSection = visualSubTabs.ESP:CreateSection("Team Settings")

local teamColorToggle = teamESPSection:CreateToggle("Team Colors", true, function(value)
    -- Team colors logic here
    print("Team Colors:", value)
end)

-- Effects subtab
local effectsSection = visualSubTabs.Effects:CreateSection("Visual Effects")

local motionBlurToggle = effectsSection:CreateToggle("Motion Blur", false, function(value)
    -- Motion blur logic here
    print("Motion Blur:", value)
end)

local bloomToggle = effectsSection:CreateToggle("Bloom Effect", false, function(value)
    -- Bloom effect logic here
    print("Bloom Effect:", value)
end)

-- Combat Tab
local combatTab = UI:CreateTab("Combat", "COMBAT", combatCategory, 1)

-- Aimbot Section
local aimbotSection = combatTab:CreateSection("Aimbot")

local aimbotToggle = aimbotSection:CreateToggle("Enable Aimbot", false, function(value)
    -- Aimbot logic here
    print("Aimbot Enabled:", value)
end)

local aimbotKeyDropdown = aimbotSection:CreateDropdown("Aimbot Key", {"Right Mouse", "Left Mouse", "E", "Q", "Shift"}, "Right Mouse", function(option)
    -- Aimbot key logic here
    print("Aimbot Key:", option)
end)

local aimbotTargetSection = combatTab:CreateSection("Aimbot Targets")

local targetHeadToggle = aimbotTargetSection:CreateToggle("Target Head", true, function(value)
    -- Target head logic here
    print("Target Head:", value)
end)

local targetTorsoToggle = aimbotTargetSection:CreateToggle("Target Torso", false, function(value)
    -- Target torso logic here
    print("Target Torso:", value)
end)

local smoothnessSlider = aimbotSection:CreateSlider("Smoothness", 0, 100, 50, 0, function(value)
    -- Smoothness logic here
    print("Aimbot Smoothness:", value)
end, "%")

local fovSlider = aimbotSection:CreateSlider("FOV", 0, 500, 100, 0, function(value)
    -- FOV logic here
    print("Aimbot FOV:", value)
end, "px")

-- Gun mods section
local gunModsSection = combatTab:CreateSection("Gun Mods")

local noRecoilToggle = gunModsSection:CreateToggle("No Recoil", false, function(value)
    -- No recoil logic here
    print("No Recoil:", value)
end)

local noSpreadToggle = gunModsSection:CreateToggle("No Spread", false, function(value)
    -- No spread logic here
    print("No Spread:", value)
end)

local rapidFireToggle = gunModsSection:CreateToggle("Rapid Fire", false, function(value)
    -- Rapid fire logic here
    print("Rapid Fire:", value)
end)

-- Misc Tab
local miscTab = UI:CreateTab("Misc", "SETTINGS", miscCategory, 1)

-- Settings Section
local settingsSection = miscTab:CreateSection("Settings")

local autoSaveToggle = settingsSection:CreateToggle("Auto Save Config", true, function(value)
    -- Auto save logic here
    print("Auto Save Config:", value)
end)

local configSection = miscTab:CreateSection("Configuration")

local saveConfigButton = configSection:CreateButton("Save Configuration", function()
    -- Save config logic here
    print("Saving configuration...")
end)

local loadConfigButton = configSection:CreateButton("Load Configuration", function()
    -- Load config logic here
    print("Loading configuration...")
end)

local resetConfigButton = configSection:CreateButton("Reset to Default", function()
    -- Reset config logic here
    print("Resetting to default configuration...")
end)

-- Credits Section
local creditsSection = miscTab:CreateSection("Credits")
local creditsLabel = creditsSection:CreateLabel("Created by YourName")
local versionLabel = creditsSection:CreateLabel("Version: 1.0.0")

-- Information Section
local infoSection = miscTab:CreateSection("Information")
local gameLabel = infoSection:CreateLabel("Game: " .. game.Name)
local playersLabel = infoSection:CreateLabel("Players: " .. #game.Players:GetPlayers() .. "/" .. game.Players.MaxPlayers)

-- Update players count
spawn(function()
    while wait(5) do
        playersLabel:UpdateText("Players: " .. #game.Players:GetPlayers() .. "/" .. game.Players.MaxPlayers)
    end
end)

-- Keybind to toggle UI visibility
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        UI.Main.Visible = not UI.Main.Visible
    end
end)
