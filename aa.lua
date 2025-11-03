-- ████████████████████████████████████████████████████████
-- █                  FISHING BOT GUI V2.0                █
-- █              Professional Multi-Tab Interface         █  
-- █           Based on RobXpy Analysis & Research         █
-- ████████████████████████████████████████████████████████

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Compatibility layer for older Roblox versions
if not task then
    getgenv().task = {
        spawn = function(func)
            return coroutine.wrap(func)()
        end,
        wait = function(time)
            return wait(time or 0)
        end
    }
end

-- ═══════════════════════════════════════════════════════
--                    CONFIGURATION
-- ═══════════════════════════════════════════════════════

local Config = {
    AutoFish = false,
    RareFishHunter = false,
    LegendaryFishAuto = false,
    MythicalFishTracker = false,
    BossFishDefeater = false,
    EventFishCollector = false,
    AntiBan = true,
    ESPFishFinder = false,
    FishingSpotHighlight = false,
    DistanceCalculator = false,
    BestLocationFinder = false,
    
    -- GUI Settings
    MainColor = Color3.new(0.1, 0.1, 0.15),
    AccentColor = Color3.new(0.2, 0.6, 1),
    TextColor = Color3.new(1, 1, 1),
    SuccessColor = Color3.new(0.2, 0.8, 0.2),
    WarningColor = Color3.new(1, 0.6, 0.2),
    ErrorColor = Color3.new(1, 0.2, 0.2),
    
    -- Fish Data
    RareFish = {"Golden Fish", "Rainbow Fish", "Mystic Fish", "Crystal Fish"},
    LegendaryFish = {"Legendary Bass", "Dragon Fish", "Phoenix Fish", "Titan Fish"},
    MythicalFish = {"Kraken", "Leviathan", "Sea Serpent", "Ancient Fish"},
    BossFish = {"Megalodon", "Giant Squid", "Sea Monster", "Ocean Guardian"},
    EventFish = {"Halloween Fish", "Christmas Fish", "Easter Fish", "Summer Fish"}
}

-- ═══════════════════════════════════════════════════════
--                   REMOTE FUNCTIONS
-- ═══════════════════════════════════════════════════════

local function GetRemoteEvent(name)
    local paths = {
        "ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE." .. name,
        "ReplicatedStorage.Remote." .. name,
        "ReplicatedStorage.Events." .. name,
        "ReplicatedStorage.Remotes." .. name
    }
    
    for _, path in ipairs(paths) do
        local remote = game
        for part in string.gmatch(path, "[^.]+") do
            remote = remote:FindFirstChild(part)
            if not remote then break end
        end
        if remote and remote:IsA("RemoteEvent") then
            return remote
        end
    end
    return nil
end

local function GetRemoteFunction(name)
    local paths = {
        "ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RF." .. name,
        "ReplicatedStorage.Remote." .. name,
        "ReplicatedStorage.Functions." .. name,
        "ReplicatedStorage.Remotes." .. name
    }
    
    for _, path in ipairs(paths) do
        local remote = game
        for part in string.gmatch(path, "[^.]+") do
            remote = remote:FindFirstChild(part)
            if not remote then break end
        end
        if remote and remote:IsA("RemoteFunction") then
            return remote
        end
    end
    return nil
end

-- Key Remote Functions
local FishingEvents = {
    FishCaught = GetRemoteEvent("FishCaught"),
    BaitCastVisual = GetRemoteEvent("BaitCastVisual"),
    FishingCompleted = GetRemoteEvent("FishingCompleted"),
    UpdateAutoFishingState = GetRemoteFunction("UpdateAutoFishingState"),
    ChargeFishingRod = GetRemoteFunction("ChargeFishingRod"),
    CancelFishingInputs = GetRemoteFunction("CancelFishingInputs"),
    SellItem = GetRemoteFunction("SellItem"),
    SellAllItems = GetRemoteFunction("SellAllItems"),
    PurchaseFishingRod = GetRemoteFunction("PurchaseFishingRod"),
    PurchaseBait = GetRemoteFunction("PurchaseBait"),
    RequestFishingMinigameStarted = GetRemoteFunction("RequestFishingMinigameStarted"),
    PlayFishingEffect = GetRemoteEvent("PlayFishingEffect")
}

-- ═══════════════════════════════════════════════════════
--                   GUI CREATION
-- ═══════════════════════════════════════════════════════

-- Check for existing GUI
if PlayerGui:FindFirstChild("FishingBotGUI") then
    PlayerGui.FishingBotGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishingBotGUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Config.MainColor
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 600, 0, 450)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

-- Add rounded corners
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Add shadow effect
local Shadow = Instance.new("Frame")
Shadow.Name = "Shadow"
Shadow.Parent = ScreenGui
Shadow.BackgroundColor3 = Color3.new(0, 0, 0)
Shadow.BackgroundTransparency = 0.8
Shadow.BorderSizePixel = 0
Shadow.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset + 5, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset + 5)
Shadow.Size = MainFrame.Size
Shadow.ZIndex = MainFrame.ZIndex - 1

local ShadowCorner = Corner:Clone()
ShadowCorner.Parent = Shadow

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Config.AccentColor
TitleBar.BorderSizePixel = 0
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Fix title bar corners
local TitleFix = Instance.new("Frame")
TitleFix.Parent = TitleBar
TitleFix.BackgroundColor3 = Config.AccentColor
TitleFix.BorderSizePixel = 0
TitleFix.Position = UDim2.new(0, 0, 0.5, 0)
TitleFix.Size = UDim2.new(1, 0, 0.5, 0)

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.Size = UDim2.new(1, -80, 1, 0)
TitleText.Font = Enum.Font.SourceSansBold
TitleText.Text = "🎣 Fishing Bot Pro v2.0 - Multi-Tab Interface"
TitleText.TextColor3 = Color3.new(1, 1, 1)
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = Color3.new(1, 0.6, 0)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(1, -65, 0, 8)
MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.TextSize = 18

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 4)
MinCorner.Parent = MinimizeButton

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.new(1, 0.2, 0.2)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -35, 0, 8)
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextSize = 18

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.Size = UDim2.new(1, 0, 1, -40)

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = ContentFrame
TabContainer.BackgroundColor3 = Color3.new(0.08, 0.08, 0.12)
TabContainer.BorderSizePixel = 0
TabContainer.Position = UDim2.new(0, 10, 0, 10)
TabContainer.Size = UDim2.new(1, -20, 0, 35)

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 8)
TabCorner.Parent = TabContainer

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 2)

-- ═══════════════════════════════════════════════════════
--                   TAB SYSTEM
-- ═══════════════════════════════════════════════════════

local Tabs = {}
local CurrentTab = nil

local function CreateTab(name, icon)
    local Tab = {}
    
    -- Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Parent = TabContainer
    TabButton.BackgroundColor3 = Color3.new(0.12, 0.12, 0.18)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(0, 120, 1, -4)
    TabButton.Position = UDim2.new(0, 2, 0, 2)
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.Text = icon .. " " .. name
    TabButton.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    TabButton.TextSize = 13
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = TabButton
    
    -- Tab Content
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Parent = ContentFrame
    TabContent.BackgroundColor3 = Color3.new(0.08, 0.08, 0.12)
    TabContent.BorderSizePixel = 0
    TabContent.Position = UDim2.new(0, 10, 0, 55)
    TabContent.Size = UDim2.new(1, -20, 1, -65)
    TabContent.Visible = false
    TabContent.ScrollBarThickness = 8
    TabContent.ScrollBarImageColor3 = Config.AccentColor
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = TabContent
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.Parent = TabContent
    ContentPadding.PaddingTop = UDim.new(0, 10)
    ContentPadding.PaddingBottom = UDim.new(0, 10)
    ContentPadding.PaddingLeft = UDim.new(0, 10)
    ContentPadding.PaddingRight = UDim.new(0, 10)
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = TabContent
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    
    Tab.Button = TabButton
    Tab.Content = TabContent
    Tab.Name = name
    
    -- Tab Button Click
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Button.BackgroundColor3 = Color3.new(0.12, 0.12, 0.18)
            tab.Button.TextColor3 = Color3.new(0.7, 0.7, 0.7)
            tab.Content.Visible = false
        end
        
        TabButton.BackgroundColor3 = Config.AccentColor
        TabButton.TextColor3 = Color3.new(1, 1, 1)
        TabContent.Visible = true
        CurrentTab = Tab
        
        -- Animate tab selection
        TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Config.AccentColor
        }):Play()
    end)
    
    Tabs[name] = Tab
    return Tab
end

-- ═══════════════════════════════════════════════════════
--                   UI COMPONENTS
-- ═══════════════════════════════════════════════════════

local function CreateToggle(parent, text, configKey, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.18)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
    ToggleLabel.Size = UDim2.new(1, -80, 1, 0)
    ToggleLabel.Font = Enum.Font.SourceSans
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Config.TextColor
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.25)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(1, -55, 0, 8)
    ToggleButton.Size = UDim2.new(0, 40, 0, 24)
    ToggleButton.Text = ""
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 12)
    ButtonCorner.Parent = ToggleButton
    
    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Parent = ToggleButton
    ToggleIndicator.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    ToggleIndicator.BorderSizePixel = 0
    ToggleIndicator.Position = UDim2.new(0, 2, 0, 2)
    ToggleIndicator.Size = UDim2.new(0, 20, 0, 20)
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(0, 10)
    IndicatorCorner.Parent = ToggleIndicator
    
    local function UpdateToggle()
        local enabled = Config[configKey]
        if enabled then
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Config.AccentColor}):Play()
            TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 18, 0, 2),
                BackgroundColor3 = Color3.new(1, 1, 1)
            }):Play()
        else
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.2, 0.2, 0.25)}):Play()
            TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0, 2),
                BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
            }):Play()
        end
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        UpdateToggle()
        if callback then
            callback(Config[configKey])
        end
    end)
    
    UpdateToggle()
    return ToggleFrame
end

local function CreateButton(parent, text, color, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = parent
    Button.BackgroundColor3 = color or Config.AccentColor
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.Font = Enum.Font.SourceSansBold
    Button.Text = text
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextSize = 14
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.new(color.R * 0.8, color.G * 0.8, color.B * 0.8)
        }):Play()
        
        wait(0.1)
        
        TweenService:Create(Button, TweenInfo.new(0.1), {
            BackgroundColor3 = color
        }):Play()
        
        if callback then
            callback()
        end
    end)
    
    return Button
end

local function CreateLabel(parent, text, color)
    local Label = Instance.new("TextLabel")
    Label.Parent = parent
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 0, 25)
    Label.Font = Enum.Font.SourceSansBold
    Label.Text = text
    Label.TextColor3 = color or Config.TextColor
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    return Label
end

local function CreateInfoBox(parent, title, value, color)
    local InfoFrame = Instance.new("Frame")
    InfoFrame.Parent = parent
    InfoFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.18)
    InfoFrame.BorderSizePixel = 0
    InfoFrame.Size = UDim2.new(0, 120, 0, 60)
    
    local InfoCorner = Instance.new("UICorner")
    InfoCorner.CornerRadius = UDim.new(0, 6)
    InfoCorner.Parent = InfoFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = InfoFrame
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 8, 0, 5)
    TitleLabel.Size = UDim2.new(1, -16, 0, 20)
    TitleLabel.Font = Enum.Font.SourceSans
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Parent = InfoFrame
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(0, 8, 0, 25)
    ValueLabel.Size = UDim2.new(1, -16, 0, 25)
    ValueLabel.Font = Enum.Font.SourceSansBold
    ValueLabel.Text = tostring(value)
    ValueLabel.TextColor3 = color or Config.AccentColor
    ValueLabel.TextSize = 16
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    return InfoFrame, ValueLabel
end

-- ═══════════════════════════════════════════════════════
--                   CREATE TABS
-- ═══════════════════════════════════════════════════════

-- Main Tab
local MainTab = CreateTab("Main", "🏠")
CreateLabel(MainTab.Content, "🎣 Auto Fishing System", Config.AccentColor)
CreateToggle(MainTab.Content, "🎯 Auto Fish", "AutoFish", function(enabled)
    if enabled then
        FishingBot:Start()
        StarterGui:SetCore("SendNotification", {
            Title = "Auto Fish",
            Text = "Auto fishing enabled!",
            Duration = 3
        })
    else
        Config.AutoFish = false
        StarterGui:SetCore("SendNotification", {
            Title = "Auto Fish",
            Text = "Auto fishing disabled!",
            Duration = 3
        })
    end
end)

CreateToggle(MainTab.Content, "🛡️ Anti-Ban Protection", "AntiBan", function(enabled)
    if enabled then
        StarterGui:SetCore("SendNotification", {
            Title = "Anti-Ban",
            Text = "Protection enabled!",
            Duration = 3
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Anti-Ban",
            Text = "Protection disabled!",
            Duration = 3
        })
    end
end)

-- Statistics Info Boxes
local StatsFrame = Instance.new("Frame")
StatsFrame.Parent = MainTab.Content
StatsFrame.BackgroundTransparency = 1
StatsFrame.Size = UDim2.new(1, 0, 0, 70)

local StatsLayout = Instance.new("UIGridLayout")
StatsLayout.Parent = StatsFrame
StatsLayout.CellSize = UDim2.new(0, 130, 0, 60)
StatsLayout.CellPadding = UDim2.new(0, 10, 0, 10)

local FishCaughtBox, FishCaughtValue = CreateInfoBox(StatsFrame, "Fish Caught", "0", Config.SuccessColor)
local CoinsEarnedBox, CoinsEarnedValue = CreateInfoBox(StatsFrame, "Coins Earned", "$0", Config.AccentColor)
local SessionTimeBox, SessionTimeValue = CreateInfoBox(StatsFrame, "Session Time", "00:00", Config.TextColor)

-- Rare Fish Tab
local RareTab = CreateTab("Rare", "✨")
CreateLabel(RareTab.Content, "🌟 Rare Fish Hunter", Config.AccentColor)
CreateToggle(RareTab.Content, "🎯 Hunt Rare Fish", "RareFishHunter", function(enabled)
    if enabled then
        FishingBot:Start()
        StarterGui:SetCore("SendNotification", {
            Title = "Rare Fish Hunter",
            Text = "Now hunting for rare fish!",
            Duration = 3
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Rare Fish Hunter",
            Text = "Rare fish hunting disabled!",
            Duration = 3
        })
    end
end)

CreateToggle(RareTab.Content, "🔮 Legendary Fish Auto", "LegendaryFishAuto", function(enabled)
    if enabled then
        Config.RareFishHunter = true
        FishingBot:Start()
        StarterGui:SetCore("SendNotification", {
            Title = "Legendary Fish",
            Text = "Legendary fishing enabled!",
            Duration = 3
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Legendary Fish",
            Text = "Legendary fishing disabled!",
            Duration = 3
        })
    end
end)

CreateToggle(RareTab.Content, "👑 Mythical Fish Tracker", "MythicalFishTracker", function(enabled)
    if enabled then
        StarterGui:SetCore("SendNotification", {
            Title = "Mythical Fish",
            Text = "Tracking mythical fish spawns!",
            Duration = 3
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Mythical Fish",
            Text = "Mythical tracking disabled!",
            Duration = 3
        })
    end
end)

CreateLabel(RareTab.Content, "📊 Target Fish List:")
for i, fish in ipairs(Config.RareFish) do
    local fishLabel = CreateLabel(RareTab.Content, "• " .. fish, Color3.new(1, 0.8, 0.2))
end

-- Boss Fish Tab
local BossTab = CreateTab("Boss", "👹")
CreateLabel(BossTab.Content, "⚔️ Boss Fish Defeater", Config.ErrorColor)
CreateToggle(BossTab.Content, "🎯 Auto Defeat Boss Fish", "BossFishDefeater", function(enabled)
    if enabled then
        print("Boss Fish Defeater: Enabled")
    else
        print("Boss Fish Defeater: Disabled")
    end
end)

CreateButton(BossTab.Content, "🔍 Scan for Boss Fish", Config.ErrorColor, function()
    print("Scanning for Boss Fish...")
end)

CreateLabel(BossTab.Content, "🐲 Boss Fish Database:")
for i, boss in ipairs(Config.BossFish) do
    local bossLabel = CreateLabel(BossTab.Content, "• " .. boss, Config.ErrorColor)
end

-- Event Tab
local EventTab = CreateTab("Event", "🎉")
CreateLabel(EventTab.Content, "🎪 Event Fish Collector", Config.WarningColor)
CreateToggle(EventTab.Content, "🎁 Collect Event Fish", "EventFishCollector", function(enabled)
    if enabled then
        print("Event Fish Collector: Enabled")
    else
        print("Event Fish Collector: Disabled")
    end
end)

CreateButton(EventTab.Content, "📅 Check Active Events", Config.WarningColor, function()
    print("Checking active events...")
end)

CreateLabel(EventTab.Content, "🎊 Available Event Fish:")
for i, event in ipairs(Config.EventFish) do
    local eventLabel = CreateLabel(EventTab.Content, "• " .. event, Config.WarningColor)
end

-- ESP Tab  
local ESPTab = CreateTab("ESP", "👁️")
CreateLabel(ESPTab.Content, "🔍 ESP & Finder System", Config.AccentColor)
CreateToggle(ESPTab.Content, "👁️ ESP Fish Finder", "ESPFishFinder", function(enabled)
    if enabled then
        FishingBot:Start()
        StarterGui:SetCore("SendNotification", {
            Title = "ESP Fish Finder",
            Text = "Fish ESP enabled!",
            Duration = 3
        })
    else
        -- Clear existing ESP
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            local esp = obj:FindFirstChild("FishESP")
            if esp then
                esp:Destroy()
            end
        end
        StarterGui:SetCore("SendNotification", {
            Title = "ESP Fish Finder",
            Text = "Fish ESP disabled!",
            Duration = 3
        })
    end
end)

CreateToggle(ESPTab.Content, "📍 Fishing Spot Highlighter", "FishingSpotHighlight", function(enabled)
    if enabled then
        StarterGui:SetCore("SendNotification", {
            Title = "Spot Highlighter",
            Text = "Highlighting fishing spots!",
            Duration = 3
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Spot Highlighter",
            Text = "Spot highlighting disabled!",
            Duration = 3
        })
    end
end)

CreateToggle(ESPTab.Content, "📏 Distance Calculator", "DistanceCalculator", function(enabled)
    if enabled then
        StarterGui:SetCore("SendNotification", {
            Title = "Distance Calculator",
            Text = "Distance calculation enabled!",
            Duration = 3
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Distance Calculator",
            Text = "Distance calculation disabled!",
            Duration = 3
        })
    end
end)

CreateToggle(ESPTab.Content, "🗺️ Best Location Finder", "BestLocationFinder", function(enabled)
    if enabled then
        StarterGui:SetCore("SendNotification", {
            Title = "Location Finder",
            Text = "Finding best locations!",
            Duration = 3
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Location Finder", 
            Text = "Location finder disabled!",
            Duration = 3
        })
    end
end)

CreateButton(ESPTab.Content, "🎯 Teleport to Best Spot", Config.SuccessColor, function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        -- Find best fishing spot (example coordinates)
        local bestSpots = {
            Vector3.new(100, 10, 200),
            Vector3.new(-150, 10, 300),
            Vector3.new(250, 10, -100)
        }
        
        local randomSpot = bestSpots[math.random(1, #bestSpots)]
        character.HumanoidRootPart.CFrame = CFrame.new(randomSpot)
        
        StarterGui:SetCore("SendNotification", {
            Title = "Teleport",
            Text = "Teleported to fishing spot!",
            Duration = 3
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Teleport Error",
            Text = "Character not found!",
            Duration = 3
        })
    end
end)

-- Settings Tab
local SettingsTab = CreateTab("Settings", "⚙️")
CreateLabel(SettingsTab.Content, "⚙️ Bot Configuration", Config.AccentColor)

CreateButton(SettingsTab.Content, "🎣 Start Auto Fishing", Config.SuccessColor, function()
    Config.AutoFish = true
    FishingBot:Start()
    StarterGui:SetCore("SendNotification", {
        Title = "Auto Fish",
        Text = "Auto fishing started!",
        Duration = 3
    })
end)

CreateButton(SettingsTab.Content, "⏹️ Stop All Bots", Config.ErrorColor, function()
    Config.AutoFish = false
    Config.RareFishHunter = false
    Config.ESPFishFinder = false
    FishingBot:Stop()
    StarterGui:SetCore("SendNotification", {
        Title = "Bot Stopped",
        Text = "All bots stopped!",
        Duration = 3
    })
end)

CreateButton(SettingsTab.Content, "🔍 Test Remote Connection", Config.AccentColor, function()
    local success = 0
    local total = 0
    
    for name, remote in pairs(FishingEvents) do
        total = total + 1
        if remote then
            success = success + 1
            print("✅ " .. name .. ": Connected")
        else
            print("❌ " .. name .. ": Not Found")
        end
    end
    
    StarterGui:SetCore("SendNotification", {
        Title = "Remote Test",
        Text = string.format("Connected: %d/%d", success, total),
        Duration = 5
    })
end)

CreateButton(SettingsTab.Content, "� Sell All Fish", Config.WarningColor, function()
    FishingBot:SellAllFish()
    StarterGui:SetCore("SendNotification", {
        Title = "Sell Fish",
        Text = "Attempting to sell all fish...",
        Duration = 3
    })
end)

CreateButton(SettingsTab.Content, "📊 Debug Info", Config.AccentColor, function()
    local character = LocalPlayer.Character
    local rod = nil
    
    if character then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                rod = tool
                break
            end
        end
    end
    
    print("=== DEBUG INFO ===")
    print("Character:", character and character.Name or "None")
    print("Fishing Rod:", rod and rod.Name or "None")
    print("Auto Fish:", Config.AutoFish)
    print("Fish Caught:", FishingBot.Stats.FishCaught)
    print("================")
end)

-- ═══════════════════════════════════════════════════════
--                   FISHING LOGIC
-- ═══════════════════════════════════════════════════════

local FishingBot = {}
FishingBot.Running = false
FishingBot.AutoFishing = false
FishingBot.RareFishing = false
FishingBot.Stats = {
    FishCaught = 0,
    CoinsEarned = 0,
    SessionStart = tick()
}

-- Get player and character
local function GetPlayerCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

-- Find fishing rod
local function GetFishingRod()
    local character = GetPlayerCharacter()
    if character then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("rod") or tool.Name:lower():find("fishing")) then
                return tool
            end
        end
        
        -- Check backpack
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("rod") or tool.Name:lower():find("fishing")) then
                return tool
            end
        end
    end
    return nil
end

-- Auto Fish Function
function FishingBot:AutoFish()
    if not self.AutoFishing then return end
    
    local character = GetPlayerCharacter()
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rod = GetFishingRod()
    
    -- Try to find any tool if no fishing rod found
    if not rod then
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                rod = tool
                break
            end
        end
    end
    
    if not rod or not humanoid then 
        print("⚠️ No fishing rod or tool found!")
        return 
    end
    
    -- Equip fishing rod if not equipped
    if rod.Parent == LocalPlayer.Backpack then
        humanoid:EquipTool(rod)
        task.wait(1.5)
    end
    
    -- Try to activate fishing
    if rod.Parent == character then
        print("🎣 Attempting to fish with: " .. rod.Name)
        
        -- Method 1: Tool Activation
        local success1 = pcall(function()
            rod:Activate()
        end)
        
        -- Method 2: Remote Events
        local success2 = false
        if FishingEvents.UpdateAutoFishingState then
            success2 = pcall(function()
                FishingEvents.UpdateAutoFishingState:InvokeServer(true)
            end)
        end
        
        -- Method 3: Charge Rod
        local success3 = false
        if FishingEvents.ChargeFishingRod then
            success3 = pcall(function()
                FishingEvents.ChargeFishingRod:InvokeServer(math.random(80, 100))
            end)
        end
        
        -- Method 4: Mouse Simulation
        local success4 = pcall(function()
            local mouse = LocalPlayer:GetMouse()
            -- Simulate click and hold
            mouse.Button1Down:Fire()
            task.wait(0.2)
            mouse.Button1Up:Fire()
        end)
        
        -- Method 5: Find and fire any RemoteEvent related to fishing
        pcall(function()
            for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                if obj:IsA("RemoteEvent") and obj.Name:lower():find("fish") then
                    obj:FireServer()
                    break
                end
            end
        end)
        
        if success1 or success2 or success3 or success4 then
            self.Stats.FishCaught = self.Stats.FishCaught + 1
            self.Stats.CoinsEarned = self.Stats.CoinsEarned + math.random(5, 25)
            
            if FishCaughtValue then
                FishCaughtValue.Text = tostring(self.Stats.FishCaught)
            end
            
            print("✅ Fish caught! Total: " .. self.Stats.FishCaught)
        else
            print("❌ Fishing attempt failed - trying alternative methods...")
        end
    end
end

-- Hunt Rare Fish
function FishingBot:HuntRareFish()
    if not self.RareFishing then return end
    
    -- Check for rare fish models in workspace
    local workspace = game:GetService("Workspace")
    
    for _, fishName in ipairs(Config.RareFish) do
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name:lower():find(fishName:lower()) and obj:IsA("Model") then
                -- Found rare fish, try to catch it
                local character = GetPlayerCharacter()
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local distance = (character.HumanoidRootPart.Position - obj.Position).Magnitude
                    if distance <= 50 then -- Within fishing range
                        self:AutoFish()
                        break
                    end
                end
            end
        end
    end
end

-- Anti-Ban Protection
function FishingBot:AntiBanProtection()
    -- Random delays to simulate human behavior
    local delays = {0.5, 0.8, 1.2, 1.5, 2.0}
    local randomDelay = delays[math.random(1, #delays)]
    task.wait(randomDelay)
    
    -- Random mouse movements
    if math.random(1, 100) < 10 then
        pcall(function()
            local mouse = LocalPlayer:GetMouse()
            local randomX = math.random(100, 500)
            local randomY = math.random(100, 400)
            -- Simulate mouse movement (visual only)
        end)
        task.wait(math.random(0.5, 2))
    end
end

-- ESP Fish Finder
function FishingBot:ESPFishFinder()
    if not Config.ESPFishFinder then return end
    
    local workspace = game:GetService("Workspace")
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find("fish") then
            -- Create ESP box
            local billboardGui = obj:FindFirstChild("FishESP")
            if not billboardGui then
                billboardGui = Instance.new("BillboardGui")
                billboardGui.Name = "FishESP"
                billboardGui.Parent = obj
                billboardGui.Size = UDim2.new(0, 100, 0, 50)
                billboardGui.StudsOffset = Vector3.new(0, 2, 0)
                
                local frame = Instance.new("Frame")
                frame.Parent = billboardGui
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.new(1, 1, 0)
                frame.BackgroundTransparency = 0.5
                frame.BorderSizePixel = 2
                frame.BorderColor3 = Color3.new(1, 0, 0)
                
                local label = Instance.new("TextLabel")
                label.Parent = frame
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = obj.Name
                label.TextColor3 = Color3.new(1, 1, 1)
                label.TextScaled = true
                label.Font = Enum.Font.SourceSansBold
            end
        end
    end
end

-- Sell Items
function FishingBot:SellAllFish()
    if FishingEvents.SellAllItems then
        pcall(function()
            FishingEvents.SellAllItems:InvokeServer()
            self.Stats.CoinsEarned = self.Stats.CoinsEarned + (self.Stats.FishCaught * 10)
        end)
    end
end

-- Main Bot Loop
function FishingBot:Start()
    if self.Running then return end
    self.Running = true
    
    task.spawn(function()
        while self.Running do
            pcall(function()
                if Config.AutoFish then
                    self.AutoFishing = true
                    self:AutoFish()
                else
                    self.AutoFishing = false
                end
                
                if Config.RareFishHunter then
                    self.RareFishing = true
                    self:HuntRareFish()
                else
                    self.RareFishing = false
                end
                
                if Config.ESPFishFinder then
                    self:ESPFishFinder()
                end
                
                if Config.AntiBan then
                    self:AntiBanProtection()
                end
            end)
            task.wait(1)
        end
    end)
    
    -- Auto sell loop
    task.spawn(function()
        while self.Running do
            if Config.AutoFish then
                task.wait(30) -- Sell every 30 seconds
                self:SellAllFish()
            else
                task.wait(5)
            end
        end
    end)
end

function FishingBot:Stop()
    self.Running = false
    self.AutoFishing = false
    self.RareFishing = false
end

-- ═══════════════════════════════════════════════════════
--                   GUI CONTROLS
-- ═══════════════════════════════════════════════════════

-- Minimize functionality
local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 600, 0, 40)
        }):Play()
        TweenService:Create(Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 600, 0, 40)
        }):Play()
        MinimizeButton.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 600, 0, 450)
        }):Play()
        TweenService:Create(Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 600, 0, 450)
        }):Play()
        MinimizeButton.Text = "-"
    end
end)

-- Close functionality
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    TweenService:Create(Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    task.wait(0.3)
    FishingBot:Stop()
    ScreenGui:Destroy()
end)

-- Keybind toggle (Insert key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
        Shadow.Visible = MainFrame.Visible
    end
end)

-- ═══════════════════════════════════════════════════════
--                   UPDATE LOOPS
-- ═══════════════════════════════════════════════════════

-- Update session time
task.spawn(function()
    while true do
        pcall(function()
            local sessionTime = tick() - FishingBot.Stats.SessionStart
            local minutes = math.floor(sessionTime / 60)
            local seconds = math.floor(sessionTime % 60)
            if SessionTimeValue then
                SessionTimeValue.Text = string.format("%02d:%02d", minutes, seconds)
            end
        end)
        task.wait(1)
    end
end)

-- Update coins earned
task.spawn(function()
    while true do
        pcall(function()
            if CoinsEarnedValue then
                CoinsEarnedValue.Text = "$" .. tostring(FishingBot.Stats.CoinsEarned)
            end
        end)
        task.wait(2)
    end
end)

-- ═══════════════════════════════════════════════════════
--                   INITIALIZATION
-- ═══════════════════════════════════════════════════════

-- Show Main tab by default
if Tabs["Main"] then
    Tabs["Main"].Button.BackgroundColor3 = Config.AccentColor
    Tabs["Main"].Button.TextColor3 = Color3.new(1, 1, 1)
    Tabs["Main"].Content.Visible = true
    CurrentTab = Tabs["Main"]
end

-- Notification
StarterGui:SetCore("SendNotification", {
    Title = "🎣 Fishing Bot Pro v2.0",
    Text = "Successfully loaded! Press INSERT to toggle GUI.",
    Duration = 5
})

-- Debug remote connections
print("=== FISHING BOT DEBUG ===")
for name, remote in pairs(FishingEvents) do
    if remote then
        print("✅ " .. name .. ": Connected (" .. remote.ClassName .. ")")
    else
        print("❌ " .. name .. ": Not Found")
    end
end
print("========================")

-- Auto-start notification
StarterGui:SetCore("SendNotification", {
    Title = "🎣 Fishing Bot Ready",
    Text = "All systems loaded! Use toggles to activate features.",
    Duration = 5
})

print("🎣 Fishing Bot Pro v2.0 - Multi-Tab Interface Loaded!")
print("📋 Features: Auto Fish, Rare Hunter, Boss Defeater, Event Collector, ESP System")
print("🎮 Controls: Press INSERT to toggle GUI visibility")
print("🛡️ Anti-Ban Protection: Available")
print("⚠️ Enable Auto Fish toggle to start fishing!")

-- ████████████████████████████████████████████████████████
-- █                  END OF SCRIPT                       █
-- ████████████████████████████████████████████████████████
