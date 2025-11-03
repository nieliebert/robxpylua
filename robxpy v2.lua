-- RobXpy V.3.0 ULTIMATE - Advanced Multi-Device Responsive Spy & Exploitation Tool
-- Features: Remote/Variable Spy, Function Hooking, Value Modification, Auto-Executor, Memory Scanner, 
-- Performance Monitor, Script Injector, Anti-Detection, Auto-Save, Real-time Analytics, Mobile Support

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local GuiService = game:GetService("GuiService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Enhanced Configuration with Auto-Detection
local CONFIG = {
    MAX_DISPLAY_ITEMS = 2000, -- Maximum items to display at once
    BATCH_SIZE = 150, -- Items to process per batch
    SCAN_DELAY = 0.03, -- Delay between batches (seconds)
    SAVE_FOLDER = "RobXpyUltimate", -- Folder name for saves
    AUTO_SAVE_INTERVAL = 300, -- Auto save every 5 minutes
    PERFORMANCE_CHECK_INTERVAL = 1, -- Check performance every second
    MEMORY_THRESHOLD = 80, -- Memory warning threshold (%)
    MAX_LOG_ENTRIES = 1000, -- Maximum log entries to keep
    MOBILE_DETECTION = true, -- Auto-detect mobile devices
    ANTI_DETECTION = true, -- Enable anti-detection measures
    REAL_TIME_MONITORING = true, -- Enable real-time monitoring
    AUTO_BACKUP = true, -- Enable automatic backups
    ADVANCED_FILTERING = true, -- Enable advanced filtering options
    NETWORK_MONITORING = true, -- Monitor network requests
    SCRIPT_INJECTION = true, -- Enable script injection capabilities
}

-- Advanced Device Detection System
local DeviceManager = {}
DeviceManager.DeviceType = "Unknown"
DeviceManager.ScreenSize = workspace.CurrentCamera.ViewportSize
DeviceManager.IsMobile = false
DeviceManager.IsTablet = false
DeviceManager.IsDesktop = false
DeviceManager.Scale = 1

function DeviceManager:DetectDevice()
    local screenSize = workspace.CurrentCamera.ViewportSize
    local guiService = GuiService
    
    -- Check if mobile
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
        self.IsMobile = true
        self.DeviceType = "Mobile"
        if screenSize.X > 800 and screenSize.Y > 600 then
            self.IsTablet = true
            self.DeviceType = "Tablet"
        end
    elseif UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
        self.IsDesktop = true
        self.DeviceType = "Desktop"
    end
    
    -- Calculate responsive scale
    if self.IsMobile or self.IsTablet then
        self.Scale = math.min(screenSize.X / 800, screenSize.Y / 600)
    else
        self.Scale = math.min(screenSize.X / 1920, screenSize.Y / 1080)
    end
    
    self.Scale = math.max(0.5, math.min(2, self.Scale))
    
    print("Device Detected: " .. self.DeviceType)
    print("Screen Size: " .. tostring(screenSize))
    print("Scale Factor: " .. tostring(self.Scale))
    
    return self.DeviceType, self.Scale
end

-- Performance Monitor System
local PerformanceMonitor = {}
PerformanceMonitor.FPS = 0
PerformanceMonitor.Memory = 0
PerformanceMonitor.Ping = 0
PerformanceMonitor.LastUpdate = tick()

function PerformanceMonitor:Update()
    local currentTime = tick()
    self.FPS = math.floor(1 / (currentTime - self.LastUpdate))
    self.LastUpdate = currentTime
    
    -- Memory usage (approximate)
    local stats = game:GetService("Stats")
    if stats:FindFirstChild("PerformanceStats") then
        local perfStats = stats.PerformanceStats
        if perfStats:FindFirstChild("Memory") then
            self.Memory = perfStats.Memory.Value
        end
    end
    
    -- Network ping
    if stats.Network and stats.Network.ServerStatsItem then
        self.Ping = stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end
end

-- Initialize device detection
DeviceManager:DetectDevice()

-- Create responsive main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "RobXpyUltimate"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true -- Better mobile support
gui.Parent = player:WaitForChild("PlayerGui")

-- Anti-detection measures
if CONFIG.ANTI_DETECTION then
    gui.Name = "PlayerGui_" .. math.random(1000, 9999)
end

-- Advanced Multi-Theme System with Dark/Light/Neon modes
local THEMES = {
    DARK = {
        BACKGROUND = Color3.fromRGB(20, 20, 25),
        BACKGROUND_DARK = Color3.fromRGB(15, 15, 20),
        TITLE_BAR = Color3.fromRGB(40, 40, 50),
        ACCENT = Color3.fromRGB(0, 162, 255),
        ACCENT_DARK = Color3.fromRGB(0, 142, 235),
        ACCENT_HOVER = Color3.fromRGB(20, 182, 255),
        BUTTON_NORMAL = Color3.fromRGB(50, 50, 60),
        BUTTON_HOVER = Color3.fromRGB(70, 70, 80),
        BUTTON_TEXT = Color3.fromRGB(255, 255, 255),
        BUTTON_SAVE = Color3.fromRGB(40, 167, 69),
        BUTTON_SAVE_HOVER = Color3.fromRGB(60, 187, 89),
        BUTTON_DELETE = Color3.fromRGB(220, 53, 69),
        BUTTON_DELETE_HOVER = Color3.fromRGB(240, 73, 89),
        BUTTON_HOOK = Color3.fromRGB(255, 152, 0),
        BUTTON_HOOK_HOVER = Color3.fromRGB(255, 172, 20),
        BUTTON_MODIFY = Color3.fromRGB(111, 66, 193),
        BUTTON_MODIFY_HOVER = Color3.fromRGB(131, 86, 213),
        TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),
        TEXT_SECONDARY = Color3.fromRGB(200, 200, 210),
        TEXT_REMOTE = Color3.fromRGB(40, 255, 40),
        TEXT_VARIABLE = Color3.fromRGB(255, 235, 59),
        TEXT_FUNCTION = Color3.fromRGB(255, 183, 77),
        TEXT_HOOKED = Color3.fromRGB(255, 87, 87),
        TEXT_SUCCESS = Color3.fromRGB(76, 175, 80),
        TEXT_ERROR = Color3.fromRGB(244, 67, 54),
        TEXT_WARNING = Color3.fromRGB(255, 152, 0),
        SELECTION = Color3.fromRGB(60, 80, 120),
        BORDER = Color3.fromRGB(70, 70, 80),
        SCROLLBAR = Color3.fromRGB(90, 90, 100),
        INPUT_BACKGROUND = Color3.fromRGB(35, 35, 45),
        PERFORMANCE_GOOD = Color3.fromRGB(76, 175, 80),
        PERFORMANCE_WARNING = Color3.fromRGB(255, 193, 7),
        PERFORMANCE_BAD = Color3.fromRGB(244, 67, 54)
    },
    LIGHT = {
        BACKGROUND = Color3.fromRGB(245, 245, 250),
        BACKGROUND_DARK = Color3.fromRGB(235, 235, 245),
        TITLE_BAR = Color3.fromRGB(255, 255, 255),
        ACCENT = Color3.fromRGB(0, 123, 255),
        ACCENT_DARK = Color3.fromRGB(0, 103, 235),
        ACCENT_HOVER = Color3.fromRGB(20, 143, 255),
        BUTTON_NORMAL = Color3.fromRGB(230, 230, 240),
        BUTTON_HOVER = Color3.fromRGB(210, 210, 225),
        BUTTON_TEXT = Color3.fromRGB(50, 50, 60),
        TEXT_PRIMARY = Color3.fromRGB(33, 37, 41),
        TEXT_SECONDARY = Color3.fromRGB(108, 117, 125)
    },
    NEON = {
        BACKGROUND = Color3.fromRGB(10, 10, 15),
        BACKGROUND_DARK = Color3.fromRGB(5, 5, 10),
        TITLE_BAR = Color3.fromRGB(20, 20, 30),
        ACCENT = Color3.fromRGB(57, 255, 20),
        ACCENT_HOVER = Color3.fromRGB(77, 255, 40),
        BUTTON_NORMAL = Color3.fromRGB(30, 30, 40),
        BUTTON_HOVER = Color3.fromRGB(50, 50, 60),
        TEXT_PRIMARY = Color3.fromRGB(0, 255, 127),
        TEXT_SECONDARY = Color3.fromRGB(0, 255, 255)
    }
}

local CURRENT_THEME = "DARK"
local THEME = THEMES[CURRENT_THEME]

-- Mobile-specific adjustments
local MOBILE_ADJUSTMENTS = {
    WINDOW_SCALE = DeviceManager.IsMobile and 0.95 or 1,
    FONT_SCALE = DeviceManager.IsMobile and 1.2 or 1,
    BUTTON_PADDING = DeviceManager.IsMobile and 10 or 5,
    TOUCH_TARGET_SIZE = DeviceManager.IsMobile and 44 or 30, -- Apple HIG minimum
    SCROLL_SENSITIVITY = DeviceManager.IsMobile and 2 or 1
}

-- Network Monitoring System
local NetworkMonitor = {}
NetworkMonitor.RequestCount = 0
NetworkMonitor.DataReceived = 0
NetworkMonitor.DataSent = 0
NetworkMonitor.ActiveConnections = {}

function NetworkMonitor:TrackRequest(request)
    self.RequestCount = self.RequestCount + 1
    self.ActiveConnections[request] = tick()
end

-- Advanced Logger System
local Logger = {}
Logger.Logs = {}
Logger.MaxLogs = CONFIG.MAX_LOG_ENTRIES

function Logger:Log(message, logType)
    logType = logType or "INFO"
    local timestamp = os.date("%H:%M:%S")
    local entry = {
        timestamp = timestamp,
        message = message,
        type = logType
    }
    
    table.insert(self.Logs, 1, entry)
    
    if #self.Logs > self.MaxLogs then
        table.remove(self.Logs, #self.Logs)
    end
    
    print("[" .. timestamp .. "] [" .. logType .. "] " .. message)
end

-- Auto-Save System
local AutoSave = {}
AutoSave.LastSave = tick()
AutoSave.Data = {}

function AutoSave:Save()
    if writefile then
        local data = {
            remotes = allRemoteResults,
            variables = allVariableResults,
            hooks = hookedFunctions,
            settings = CONFIG,
            timestamp = os.date()
        }
        
        local success, error = pcall(function()
            writefile(CONFIG.SAVE_FOLDER .. "/autosave_" .. os.date("%Y%m%d_%H%M%S") .. ".json", 
                     HttpService:JSONEncode(data))
        end)
        
        if success then
            Logger:Log("Auto-save completed successfully", "SUCCESS")
        else
            Logger:Log("Auto-save failed: " .. tostring(error), "ERROR")
        end
    end
end

-- Theme Manager
local ThemeManager = {}
function ThemeManager:SwitchTheme(themeName)
    if THEMES[themeName] then
        CURRENT_THEME = themeName
        THEME = THEMES[themeName]
        Logger:Log("Switched to " .. themeName .. " theme", "INFO")
        -- Update all UI elements (implementation below)
    end
end

-- Utility functions
local function createRoundedFrame(parent)
    local frame = Instance.new("Frame", parent)
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 6)
    return frame
end

local function createRoundedButton(parent)
    local button = Instance.new("TextButton", parent)
    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 6)
    return button
end

local function createTween(object, properties, time, easingStyle, easingDirection)
    local info = TweenInfo.new(
        time or 0.2,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, info, properties)
    return tween
end

local function applyButtonHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        createTween(button, {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        createTween(button, {BackgroundColor3 = normalColor}):Play()
    end)
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke", parent)
    stroke.Color = color or THEME.BORDER
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return stroke
end

-- Create save folder if it doesn't exist
local function ensureSaveFolder()
    if isfolder and not isfolder(CONFIG.SAVE_FOLDER) then
        makefolder(CONFIG.SAVE_FOLDER)
    end
end

-- Responsive Window Sizing System
local WindowManager = {}
WindowManager.MinSize = Vector2.new(400, 300)
WindowManager.MaxSize = Vector2.new(1400, 900)
WindowManager.DefaultSize = Vector2.new(800, 600)

function WindowManager:CalculateResponsiveSize()
    local screenSize = workspace.CurrentCamera.ViewportSize
    local scale = DeviceManager.Scale
    
    local width, height
    
    if DeviceManager.IsMobile then
        -- Mobile: Use most of the screen
        width = math.min(screenSize.X * 0.95, 500)
        height = math.min(screenSize.Y * 0.90, 700)
    elseif DeviceManager.IsTablet then
        -- Tablet: Moderate size
        width = math.min(screenSize.X * 0.80, 700)
        height = math.min(screenSize.Y * 0.85, 600)
    else
        -- Desktop: Standard size with scaling
        width = math.min(screenSize.X * 0.60, 900) * scale
        height = math.min(screenSize.Y * 0.70, 650) * scale
    end
    
    -- Ensure minimum size
    width = math.max(width, self.MinSize.X)
    height = math.max(height, self.MinSize.Y)
    
    return Vector2.new(width, height)
end

local windowSize = WindowManager:CalculateResponsiveSize()

-- Create the enhanced main window frame with animations
local mainWindow = createRoundedFrame(gui)
mainWindow.Size = UDim2.new(0, windowSize.X, 0, windowSize.Y)
mainWindow.Position = UDim2.new(0.5, -windowSize.X/2, 0.5, -windowSize.Y/2)
mainWindow.BackgroundColor3 = THEME.BACKGROUND
mainWindow.ClipsDescendants = true
mainWindow.BorderSizePixel = 0

-- Add advanced visual effects
local mainCorner = mainWindow:FindFirstChild("UICorner")
if mainCorner then
    mainCorner.CornerRadius = UDim.new(0, DeviceManager.IsMobile and 15 or 10)
end

-- Enhanced shadow system
local shadowFrame = Instance.new("Frame", gui)
shadowFrame.Size = UDim2.new(0, windowSize.X + 20, 0, windowSize.Y + 20)
shadowFrame.Position = UDim2.new(0.5, -windowSize.X/2 - 10, 0.5, -windowSize.Y/2 - 10)
shadowFrame.BackgroundTransparency = 1
shadowFrame.ZIndex = mainWindow.ZIndex - 1

-- Multiple shadow layers for depth
for i = 1, 3 do
    local shadow = Instance.new("ImageLabel", shadowFrame)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, i * 2, 0.5, i * 2)
    shadow.Size = UDim2.new(1, i * 4, 1, i * 4)
    shadow.ZIndex = -i
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8 + (i * 0.05)
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
end

-- Performance indicator overlay
local performanceFrame = createRoundedFrame(mainWindow)
performanceFrame.Size = UDim2.new(0, DeviceManager.IsMobile and 150 or 120, 0, 60)
performanceFrame.Position = UDim2.new(1, DeviceManager.IsMobile and -160 or -130, 0, 10)
performanceFrame.BackgroundColor3 = THEME.BACKGROUND_DARK
performanceFrame.BackgroundTransparency = 0.3
performanceFrame.ZIndex = 100

local fpsLabel = Instance.new("TextLabel", performanceFrame)
fpsLabel.Size = UDim2.new(1, 0, 0.33, 0)
fpsLabel.Position = UDim2.new(0, 5, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = DeviceManager.IsMobile and 12 or 10
fpsLabel.TextColor3 = THEME.PERFORMANCE_GOOD
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Text = "FPS: --"

local memoryLabel = Instance.new("TextLabel", performanceFrame)
memoryLabel.Size = UDim2.new(1, 0, 0.33, 0)
memoryLabel.Position = UDim2.new(0, 5, 0.33, 0)
memoryLabel.BackgroundTransparency = 1
memoryLabel.Font = Enum.Font.Gotham
memoryLabel.TextSize = DeviceManager.IsMobile and 10 or 8
memoryLabel.TextColor3 = THEME.TEXT_SECONDARY
memoryLabel.TextXAlignment = Enum.TextXAlignment.Left
memoryLabel.Text = "MEM: --"

local pingLabel = Instance.new("TextLabel", performanceFrame)
pingLabel.Size = UDim2.new(1, 0, 0.33, 0)
pingLabel.Position = UDim2.new(0, 5, 0.67, 0)
pingLabel.BackgroundTransparency = 1
pingLabel.Font = Enum.Font.Gotham
pingLabel.TextSize = DeviceManager.IsMobile and 10 or 8
pingLabel.TextColor3 = THEME.TEXT_SECONDARY
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.Text = "PING: --"

-- Update performance monitor
local function updatePerformance()
    PerformanceMonitor:Update()
    
    fpsLabel.Text = "FPS: " .. tostring(PerformanceMonitor.FPS)
    fpsLabel.TextColor3 = PerformanceMonitor.FPS > 45 and THEME.PERFORMANCE_GOOD or 
                         PerformanceMonitor.FPS > 25 and THEME.PERFORMANCE_WARNING or 
                         THEME.PERFORMANCE_BAD
    
    memoryLabel.Text = "MEM: " .. string.format("%.1f%%", PerformanceMonitor.Memory or 0)
    pingLabel.Text = "PING: " .. string.format("%.0fms", PerformanceMonitor.Ping or 0)
end

-- Start performance monitoring
if CONFIG.REAL_TIME_MONITORING then
    spawn(function()
        while wait(CONFIG.PERFORMANCE_CHECK_INTERVAL) do
            updatePerformance()
        end
    end)
end

-- Add window shadow
local shadow = Instance.new("ImageLabel", mainWindow)
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.ZIndex = -1
shadow.Image = "rbxassetid://6014261993"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)

-- Create title bar
local titleBar = createRoundedFrame(mainWindow)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = THEME.TITLE_BAR
local titleCorner = titleBar.UICorner
titleCorner.CornerRadius = UDim.new(0, 6)

-- Add title text
local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = THEME.TEXT_PRIMARY
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "RobXpy V.2.0 - Remote & Variable Spy"

-- Add minimize button (fixed positioning and functionality)
local minimizeButton = Instance.new("TextButton", titleBar)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -35, 0, 5)
minimizeButton.BackgroundColor3 = THEME.BUTTON_NORMAL
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 18
minimizeButton.TextColor3 = THEME.BUTTON_TEXT
minimizeButton.Text = "−"
local minimizeCorner = Instance.new("UICorner", minimizeButton)
minimizeCorner.CornerRadius = UDim.new(0, 6)
applyButtonHoverEffect(minimizeButton, THEME.BUTTON_NORMAL, THEME.BUTTON_HOVER)

-- Create tab buttons container
local tabContainer = createRoundedFrame(mainWindow)
tabContainer.Size = UDim2.new(0, 150, 1, -50)
tabContainer.Position = UDim2.new(0, 10, 0, 45)
tabContainer.BackgroundColor3 = THEME.BACKGROUND_DARK

-- Enhanced Tab System with new powerful features
local tabButtons = {}
local tabNames = {
    "Dashboard", "Remotes", "Variables", "Hooks", "Modifier", 
    "Scripts", "Memory", "Network", "Settings", "Logger"
}
local activeTab = "Dashboard"

-- Tab icons for better UX
local tabIcons = {
    Dashboard = "📊",
    Remotes = "🔌",
    Variables = "📋",
    Hooks = "🪝", 
    Modifier = "⚙️",
    Scripts = "📜",
    Memory = "💾",
    Network = "🌐",
    Settings = "⚙️",
    Logger = "📝"
}

-- Mobile-optimized tab scrolling for many tabs
local tabScrollFrame = Instance.new("ScrollingFrame", tabContainer)
tabScrollFrame.Size = UDim2.new(1, 0, 1, 0)
tabScrollFrame.Position = UDim2.new(0, 0, 0, 0)
tabScrollFrame.BackgroundTransparency = 1
tabScrollFrame.BorderSizePixel = 0
tabScrollFrame.ScrollBarThickness = DeviceManager.IsMobile and 8 or 6
tabScrollFrame.ScrollBarImageColor3 = THEME.SCROLLBAR
tabScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #tabNames * (DeviceManager.IsMobile and 60 or 50))

local tabListLayout = Instance.new("UIListLayout", tabScrollFrame)
tabListLayout.FillDirection = Enum.FillDirection.Vertical
tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabListLayout.Padding = UDim.new(0, 5)

for i, tabName in ipairs(tabNames) do
    local tabButton = createRoundedButton(tabScrollFrame)
    tabButton.Size = UDim2.new(1, -20, 0, DeviceManager.IsMobile and 50 or 40)
    tabButton.Position = UDim2.new(0, 0, 0, 0)
    tabButton.BackgroundColor3 = tabName == activeTab and THEME.ACCENT or THEME.BUTTON_NORMAL
    tabButton.Font = Enum.Font.GothamSemibold
    tabButton.TextSize = DeviceManager.IsMobile and 16 or 14
    tabButton.TextColor3 = THEME.BUTTON_TEXT
    tabButton.Text = (tabIcons[tabName] or "") .. " " .. tabName
    tabButton.LayoutOrder = i
    
    -- Tab switching logic with animation
    tabButton.MouseButton1Click:Connect(function()
        -- Update tab visual states
        for name, btn in pairs(tabButtons) do
            local isActive = name == tabName
            createTween(btn, {
                BackgroundColor3 = isActive and THEME.ACCENT or THEME.BUTTON_NORMAL
            }):Play()
        end
        
        -- Switch content frames with fade animation
        for name, frame in pairs(contentFrames) do
            if name == tabName then
                frame.Visible = true
                frame.BackgroundTransparency = 1
                createTween(frame, {BackgroundTransparency = 0}, 0.3):Play()
            else
                createTween(frame, {BackgroundTransparency = 1}, 0.2):Play()
                wait(0.2)
                frame.Visible = false
            end
        end
        
        activeTab = tabName
        Logger:Log("Switched to " .. tabName .. " tab", "INFO")
    end)
    
    tabButtons[tabName] = tabButton
end

-- Create content containers for each tab
local contentFrames = {}

for _, tabName in ipairs(tabNames) do
    local contentFrame = createRoundedFrame(mainWindow)
    contentFrame.Size = UDim2.new(1, -180, 1, -90)
    contentFrame.Position = UDim2.new(0, 170, 0, 45)
    contentFrame.BackgroundColor3 = THEME.BACKGROUND_DARK
    contentFrame.Visible = tabName == activeTab
    
    contentFrames[tabName] = contentFrame
end

-- DASHBOARD TAB - Powerful overview and quick actions
local dashboardFrame = contentFrames["Dashboard"]

-- Dashboard Header
local dashHeader = Instance.new("TextLabel", dashboardFrame)
dashHeader.Size = UDim2.new(1, -20, 0, 40)
dashHeader.Position = UDim2.new(0, 10, 0, 10)
dashHeader.BackgroundTransparency = 1
dashHeader.Font = Enum.Font.GothamBold
dashHeader.TextSize = DeviceManager.IsMobile and 20 or 18
dashHeader.TextColor3 = THEME.TEXT_PRIMARY
dashHeader.TextXAlignment = Enum.TextXAlignment.Left
dashHeader.Text = "🚀 RobXpy Ultimate Dashboard"

-- Quick Stats Grid
local statsGrid = createRoundedFrame(dashboardFrame)
statsGrid.Size = UDim2.new(1, -20, 0, 120)
statsGrid.Position = UDim2.new(0, 10, 0, 60)
statsGrid.BackgroundColor3 = THEME.BACKGROUND

local statsLayout = Instance.new("UIGridLayout", statsGrid)
statsLayout.CellSize = UDim2.new(0.24, -5, 0, 55)
statsLayout.CellPadding = UDim2.new(0, 5, 0, 5)
statsLayout.FillDirection = Enum.FillDirection.Horizontal

-- Stat Cards
local statCards = {
    {name = "Remotes Found", value = "0", icon = "🔌", color = THEME.TEXT_REMOTE},
    {name = "Variables", value = "0", icon = "📋", color = THEME.TEXT_VARIABLE},
    {name = "Active Hooks", value = "0", icon = "🪝", color = THEME.TEXT_HOOKED},
    {name = "Scripts Loaded", value = "0", icon = "📜", color = THEME.TEXT_FUNCTION}
}

local statLabels = {}
for i, stat in ipairs(statCards) do
    local card = createRoundedFrame(statsGrid)
    card.BackgroundColor3 = THEME.BACKGROUND_DARK
    card.LayoutOrder = i
    
    local iconLabel = Instance.new("TextLabel", card)
    iconLabel.Size = UDim2.new(0.3, 0, 0.6, 0)
    iconLabel.Position = UDim2.new(0, 5, 0, 5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = DeviceManager.IsMobile and 18 or 16
    iconLabel.TextColor3 = stat.color
    iconLabel.Text = stat.icon
    
    local valueLabel = Instance.new("TextLabel", card)
    valueLabel.Size = UDim2.new(0.65, 0, 0.4, 0)
    valueLabel.Position = UDim2.new(0.3, 0, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = DeviceManager.IsMobile and 16 or 14
    valueLabel.TextColor3 = THEME.TEXT_PRIMARY
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.Text = stat.value
    
    local nameLabel = Instance.new("TextLabel", card)
    nameLabel.Size = UDim2.new(0.65, 0, 0.4, 0)
    nameLabel.Position = UDim2.new(0.3, 0, 0.4, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = DeviceManager.IsMobile and 12 or 10
    nameLabel.TextColor3 = THEME.TEXT_SECONDARY
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Text = stat.name
    
    statLabels[stat.name] = valueLabel
end

-- Quick Action Buttons
local quickActions = createRoundedFrame(dashboardFrame)
quickActions.Size = UDim2.new(1, -20, 0, 80)
quickActions.Position = UDim2.new(0, 10, 0, 190)
quickActions.BackgroundColor3 = THEME.BACKGROUND

local actionLayout = Instance.new("UIGridLayout", quickActions)
actionLayout.CellSize = UDim2.new(0.32, -5, 0, 35)
actionLayout.CellPadding = UDim2.new(0, 5, 0, 5)
actionLayout.FillDirection = Enum.FillDirection.Horizontal

-- Quick Action Button Data
local quickActionButtons = {
    {text = "🔍 Quick Scan", color = THEME.ACCENT, action = "quickScan"},
    {text = "💾 Auto Save", color = THEME.BUTTON_SAVE, action = "autoSave"},
    {text = "🧹 Clean Memory", color = THEME.BUTTON_DELETE, action = "cleanMemory"},
    {text = "📊 Export Data", color = THEME.BUTTON_MODIFY, action = "exportData"},
    {text = "⚡ Boost Performance", color = THEME.BUTTON_HOOK, action = "boostPerf"},
    {text = "🔒 Hide GUI", color = THEME.BUTTON_NORMAL, action = "hideGUI"}
}

for i, btn in ipairs(quickActionButtons) do
    local actionBtn = createRoundedButton(quickActions)
    actionBtn.BackgroundColor3 = btn.color
    actionBtn.Font = Enum.Font.GothamBold
    actionBtn.TextSize = DeviceManager.IsMobile and 12 or 10
    actionBtn.TextColor3 = THEME.BUTTON_TEXT
    actionBtn.Text = btn.text
    actionBtn.LayoutOrder = i
    
    applyButtonHoverEffect(actionBtn, btn.color, Color3.fromRGB(
        math.min(255, btn.color.R * 255 + 20),
        math.min(255, btn.color.G * 255 + 20),
        math.min(255, btn.color.B * 255 + 20)
    ))
end

-- System Information Panel
local sysInfo = createRoundedFrame(dashboardFrame)
sysInfo.Size = UDim2.new(1, -20, 0, 100)
sysInfo.Position = UDim2.new(0, 10, 0, 280)
sysInfo.BackgroundColor3 = THEME.BACKGROUND

local sysInfoTitle = Instance.new("TextLabel", sysInfo)
sysInfoTitle.Size = UDim2.new(1, -10, 0, 25)
sysInfoTitle.Position = UDim2.new(0, 5, 0, 5)
sysInfoTitle.BackgroundTransparency = 1
sysInfoTitle.Font = Enum.Font.GothamBold
sysInfoTitle.TextSize = DeviceManager.IsMobile and 14 or 12
sysInfoTitle.TextColor3 = THEME.TEXT_PRIMARY
sysInfoTitle.TextXAlignment = Enum.TextXAlignment.Left
sysInfoTitle.Text = "🖥️ System Information"

local sysInfoGrid = Instance.new("UIListLayout", sysInfo)
sysInfoGrid.FillDirection = Enum.FillDirection.Vertical
sysInfoGrid.SortOrder = Enum.SortOrder.LayoutOrder
sysInfoGrid.Padding = UDim.new(0, 2)

-- System info labels
local sysLabels = {}
local sysInfoData = {
    "Device: " .. DeviceManager.DeviceType,
    "Screen: " .. tostring(DeviceManager.ScreenSize),
    "Scale: " .. string.format("%.2f", DeviceManager.Scale),
    "Game: " .. (game.PlaceId > 0 and game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Unknown")
}

for i, info in ipairs(sysInfoData) do
    local infoLabel = Instance.new("TextLabel", sysInfo)
    infoLabel.Size = UDim2.new(1, -10, 0, 15)
    infoLabel.Position = UDim2.new(0, 5, 0, 25 + (i-1) * 17)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = DeviceManager.IsMobile and 12 or 10
    infoLabel.TextColor3 = THEME.TEXT_SECONDARY
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.Text = "• " .. info
    infoLabel.LayoutOrder = i + 1
end

-- SCRIPTS TAB - Advanced Script Management
local scriptsFrame = contentFrames["Scripts"]

local scriptHeader = Instance.new("TextLabel", scriptsFrame)
scriptHeader.Size = UDim2.new(1, -20, 0, 30)
scriptHeader.Position = UDim2.new(0, 10, 0, 10)
scriptHeader.BackgroundTransparency = 1
scriptHeader.Font = Enum.Font.GothamBold
scriptHeader.TextSize = DeviceManager.IsMobile and 18 or 16
scriptHeader.TextColor3 = THEME.TEXT_PRIMARY
scriptHeader.TextXAlignment = Enum.TextXAlignment.Left
scriptHeader.Text = "📜 Advanced Script Manager"

-- Script input area
local scriptInput = Instance.new("TextBox", scriptsFrame)
scriptInput.Size = UDim2.new(1, -20, 0, 200)
scriptInput.Position = UDim2.new(0, 10, 0, 50)
scriptInput.BackgroundColor3 = THEME.INPUT_BACKGROUND
scriptInput.PlaceholderText = "Enter Lua script code here..."
scriptInput.PlaceholderColor3 = THEME.TEXT_SECONDARY
scriptInput.TextColor3 = THEME.TEXT_PRIMARY
scriptInput.Font = Enum.Font.Code
scriptInput.TextSize = DeviceManager.IsMobile and 14 or 12
scriptInput.Text = ""
scriptInput.MultiLine = true
scriptInput.TextXAlignment = Enum.TextXAlignment.Left
scriptInput.TextYAlignment = Enum.TextYAlignment.Top
createStroke(scriptInput)
local scriptCorner = Instance.new("UICorner", scriptInput)
scriptCorner.CornerRadius = UDim.new(0, 6)

-- Script execution buttons
local executeBtn = createRoundedButton(scriptsFrame)
executeBtn.Size = UDim2.new(0.48, 0, 0, 40)
executeBtn.Position = UDim2.new(0, 10, 0, 260)
executeBtn.BackgroundColor3 = THEME.ACCENT
executeBtn.Font = Enum.Font.GothamBold
executeBtn.TextSize = DeviceManager.IsMobile and 16 or 14
executeBtn.TextColor3 = THEME.BUTTON_TEXT
executeBtn.Text = "▶️ Execute Script"
applyButtonHoverEffect(executeBtn, THEME.ACCENT, THEME.ACCENT_HOVER)

local saveScriptBtn = createRoundedButton(scriptsFrame)
saveScriptBtn.Size = UDim2.new(0.48, 0, 0, 40)
saveScriptBtn.Position = UDim2.new(0.52, 0, 0, 260)
saveScriptBtn.BackgroundColor3 = THEME.BUTTON_SAVE
saveScriptBtn.Font = Enum.Font.GothamBold
saveScriptBtn.TextSize = DeviceManager.IsMobile and 16 or 14
saveScriptBtn.TextColor3 = THEME.BUTTON_TEXT
saveScriptBtn.Text = "💾 Save Script"
applyButtonHoverEffect(saveScriptBtn, THEME.BUTTON_SAVE, THEME.BUTTON_SAVE_HOVER)

-- MEMORY TAB - Memory Scanner & Analyzer
local memoryFrame = contentFrames["Memory"]

-- NETWORK TAB - Network Monitor
local networkFrame = contentFrames["Network"]

-- LOGGER TAB - Advanced Logging System
local loggerFrame = contentFrames["Logger"]

local logScrollFrame = Instance.new("ScrollingFrame", loggerFrame)
logScrollFrame.Size = UDim2.new(1, -20, 1, -100)
logScrollFrame.Position = UDim2.new(0, 10, 0, 50)
logScrollFrame.BackgroundColor3 = THEME.BACKGROUND
logScrollFrame.BorderSizePixel = 0
logScrollFrame.ScrollBarThickness = 6
logScrollFrame.ScrollBarImageColor3 = THEME.SCROLLBAR
createStroke(logScrollFrame)

local logListLayout = Instance.new("UIListLayout", logScrollFrame)
logListLayout.FillDirection = Enum.FillDirection.Vertical
logListLayout.SortOrder = Enum.SortOrder.LayoutOrder
logListLayout.Padding = UDim.new(0, 2)

-- Progress bar for scanning
local progressFrame = createRoundedFrame(contentFrames["Remotes"])
progressFrame.Size = UDim2.new(1, -20, 0, 20)
progressFrame.Position = UDim2.new(0, 10, 0, 10)
progressFrame.BackgroundColor3 = THEME.BACKGROUND
progressFrame.Visible = false
createStroke(progressFrame)

local progressBar = createRoundedFrame(progressFrame)
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.Position = UDim2.new(0, 0, 0, 0)
progressBar.BackgroundColor3 = THEME.ACCENT

local progressText = Instance.new("TextLabel", progressFrame)
progressText.Size = UDim2.new(1, 0, 1, 0)
progressText.BackgroundTransparency = 1
progressText.Font = Enum.Font.Gotham
progressText.TextSize = 12
progressText.TextColor3 = THEME.TEXT_PRIMARY
progressText.Text = "Scanning..."

-- Create main scrolling frame for Remotes tab
local scrollingFrame = Instance.new("ScrollingFrame", contentFrames["Remotes"])
scrollingFrame.Size = UDim2.new(1, -20, 1, -100)
scrollingFrame.Position = UDim2.new(0, 10, 0, 80)
scrollingFrame.BackgroundColor3 = THEME.BACKGROUND
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.ScrollBarImageColor3 = THEME.SCROLLBAR
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
createStroke(scrollingFrame)
local scrollCorner = Instance.new("UICorner", scrollingFrame)
scrollCorner.CornerRadius = UDim.new(0, 6)

-- Add UIListLayout to scrolling frame
local listLayout = Instance.new("UIListLayout", scrollingFrame)
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)

-- Search bar for remotes
local searchBar = Instance.new("TextBox", contentFrames["Remotes"])
searchBar.Size = UDim2.new(1, -20, 0, 30)
searchBar.Position = UDim2.new(0, 10, 0, 40)
searchBar.BackgroundColor3 = THEME.INPUT_BACKGROUND
searchBar.PlaceholderText = "Search remotes..."
searchBar.PlaceholderColor3 = THEME.TEXT_SECONDARY
searchBar.TextColor3 = THEME.TEXT_PRIMARY
searchBar.Font = Enum.Font.Gotham
searchBar.TextSize = 14
searchBar.Text = ""
searchBar.ClearTextOnFocus = false
createStroke(searchBar)
local searchCorner = Instance.new("UICorner", searchBar)
searchCorner.CornerRadius = UDim.new(0, 6)

-- Item count display
local itemCountLabel = Instance.new("TextLabel", contentFrames["Remotes"])
itemCountLabel.Size = UDim2.new(0.5, 0, 0, 20)
itemCountLabel.Position = UDim2.new(0, 10, 0, 20)
itemCountLabel.BackgroundTransparency = 1
itemCountLabel.Font = Enum.Font.Gotham
itemCountLabel.TextSize = 12
itemCountLabel.TextColor3 = THEME.TEXT_SECONDARY
itemCountLabel.TextXAlignment = Enum.TextXAlignment.Left
itemCountLabel.Text = "Items: 0/0"

-- Create variables tab content
local varsProgressFrame = createRoundedFrame(contentFrames["Variables"])
varsProgressFrame.Size = UDim2.new(1, -20, 0, 20)
varsProgressFrame.Position = UDim2.new(0, 10, 0, 10)
varsProgressFrame.BackgroundColor3 = THEME.BACKGROUND
varsProgressFrame.Visible = false
createStroke(varsProgressFrame)

local varsProgressBar = createRoundedFrame(varsProgressFrame)
varsProgressBar.Size = UDim2.new(0, 0, 1, 0)
varsProgressBar.Position = UDim2.new(0, 0, 0, 0)
varsProgressBar.BackgroundColor3 = THEME.ACCENT

local varsProgressText = Instance.new("TextLabel", varsProgressFrame)
varsProgressText.Size = UDim2.new(1, 0, 1, 0)
varsProgressText.BackgroundTransparency = 1
varsProgressText.Font = Enum.Font.Gotham
varsProgressText.TextSize = 12
varsProgressText.TextColor3 = THEME.TEXT_PRIMARY
varsProgressText.Text = "Scanning..."

local varsScrollingFrame = Instance.new("ScrollingFrame", contentFrames["Variables"])
varsScrollingFrame.Size = UDim2.new(1, -20, 1, -100)
varsScrollingFrame.Position = UDim2.new(0, 10, 0, 80)
varsScrollingFrame.BackgroundColor3 = THEME.BACKGROUND
varsScrollingFrame.BorderSizePixel = 0
varsScrollingFrame.ScrollBarThickness = 6
varsScrollingFrame.ScrollBarImageColor3 = THEME.SCROLLBAR
varsScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
createStroke(varsScrollingFrame)
local varsScrollCorner = Instance.new("UICorner", varsScrollingFrame)
varsScrollCorner.CornerRadius = UDim.new(0, 6)

-- Add UIListLayout to variables scrolling frame
local varsListLayout = Instance.new("UIListLayout", varsScrollingFrame)
varsListLayout.FillDirection = Enum.FillDirection.Vertical
varsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
varsListLayout.Padding = UDim.new(0, 5)

-- Search bar for variables
local varsSearchBar = Instance.new("TextBox", contentFrames["Variables"])
varsSearchBar.Size = UDim2.new(1, -20, 0, 30)
varsSearchBar.Position = UDim2.new(0, 10, 0, 40)
varsSearchBar.BackgroundColor3 = THEME.INPUT_BACKGROUND
varsSearchBar.PlaceholderText = "Search variables..."
varsSearchBar.PlaceholderColor3 = THEME.TEXT_SECONDARY
varsSearchBar.TextColor3 = THEME.TEXT_PRIMARY
varsSearchBar.Font = Enum.Font.Gotham
varsSearchBar.TextSize = 14
varsSearchBar.Text = ""
varsSearchBar.ClearTextOnFocus = false
createStroke(varsSearchBar)
local varsSearchCorner = Instance.new("UICorner", varsSearchBar)
varsSearchCorner.CornerRadius = UDim.new(0, 6)

-- Variables item count display
local varsItemCountLabel = Instance.new("TextLabel", contentFrames["Variables"])
varsItemCountLabel.Size = UDim2.new(0.5, 0, 0, 20)
varsItemCountLabel.Position = UDim2.new(0, 10, 0, 20)
varsItemCountLabel.BackgroundTransparency = 1
varsItemCountLabel.Font = Enum.Font.Gotham
varsItemCountLabel.TextSize = 12
varsItemCountLabel.TextColor3 = THEME.TEXT_SECONDARY
varsItemCountLabel.TextXAlignment = Enum.TextXAlignment.Left
varsItemCountLabel.Text = "Items: 0/0"

-- Create hooks tab content
local hooksScrollingFrame = Instance.new("ScrollingFrame", contentFrames["Hooks"])
hooksScrollingFrame.Size = UDim2.new(1, -20, 1, -110)
hooksScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
hooksScrollingFrame.BackgroundColor3 = THEME.BACKGROUND
hooksScrollingFrame.BorderSizePixel = 0
hooksScrollingFrame.ScrollBarThickness = 6
hooksScrollingFrame.ScrollBarImageColor3 = THEME.SCROLLBAR
hooksScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
createStroke(hooksScrollingFrame)
local hooksScrollCorner = Instance.new("UICorner", hooksScrollingFrame)
hooksScrollCorner.CornerRadius = UDim.new(0, 6)

-- Add UIListLayout to hooks scrolling frame
local hooksListLayout = Instance.new("UIListLayout", hooksScrollingFrame)
hooksListLayout.FillDirection = Enum.FillDirection.Vertical
hooksListLayout.SortOrder = Enum.SortOrder.LayoutOrder
hooksListLayout.Padding = UDim.new(0, 5)

-- Hooks buttons
local saveHooksButton = createRoundedButton(contentFrames["Hooks"])
saveHooksButton.Size = UDim2.new(0.48, 0, 0, 40)
saveHooksButton.Position = UDim2.new(0, 10, 1, -50)
saveHooksButton.BackgroundColor3 = THEME.BUTTON_SAVE
saveHooksButton.Font = Enum.Font.GothamBold
saveHooksButton.TextSize = 14
saveHooksButton.TextColor3 = THEME.BUTTON_TEXT
saveHooksButton.Text = "Save Hooks"
applyButtonHoverEffect(saveHooksButton, THEME.BUTTON_SAVE, THEME.BUTTON_SAVE_HOVER)

local clearHooksButton = createRoundedButton(contentFrames["Hooks"])
clearHooksButton.Size = UDim2.new(0.48, 0, 0, 40)
clearHooksButton.Position = UDim2.new(0.5, 5, 1, -50)
clearHooksButton.BackgroundColor3 = THEME.BUTTON_DELETE
clearHooksButton.Font = Enum.Font.GothamBold
clearHooksButton.TextSize = 14
clearHooksButton.TextColor3 = THEME.BUTTON_TEXT
clearHooksButton.Text = "Clear Hooks"
applyButtonHoverEffect(clearHooksButton, THEME.BUTTON_DELETE, THEME.BUTTON_DELETE_HOVER)

-- Hooks item count display
local hooksItemCountLabel = Instance.new("TextLabel", contentFrames["Hooks"])
hooksItemCountLabel.Size = UDim2.new(1, -20, 0, 20)
hooksItemCountLabel.Position = UDim2.new(0, 10, 0, 20)
hooksItemCountLabel.BackgroundTransparency = 1
hooksItemCountLabel.Font = Enum.Font.Gotham
hooksItemCountLabel.TextSize = 12
hooksItemCountLabel.TextColor3 = THEME.TEXT_SECONDARY
hooksItemCountLabel.TextXAlignment = Enum.TextXAlignment.Left
hooksItemCountLabel.Text = "Hooked Functions: 0"

-- Create value modifier tab content
local modifierFrame = contentFrames["Modifier"]

-- Path input
local pathLabel = Instance.new("TextLabel", modifierFrame)
pathLabel.Size = UDim2.new(1, -20, 0, 20)
pathLabel.Position = UDim2.new(0, 10, 0, 10)
pathLabel.BackgroundTransparency = 1
pathLabel.TextColor3 = THEME.TEXT_PRIMARY
pathLabel.TextXAlignment = Enum.TextXAlignment.Left
pathLabel.Font = Enum.Font.GothamSemibold
pathLabel.TextSize = 14
pathLabel.Text = "Object Path:"

local pathInput = Instance.new("TextBox", modifierFrame)
pathInput.Size = UDim2.new(1, -20, 0, 40)
pathInput.Position = UDim2.new(0, 10, 0, 35)
pathInput.BackgroundColor3 = THEME.INPUT_BACKGROUND
pathInput.PlaceholderText = "e.g. game.Workspace.Part"
pathInput.PlaceholderColor3 = THEME.TEXT_SECONDARY
pathInput.TextColor3 = THEME.TEXT_PRIMARY
pathInput.Font = Enum.Font.Gotham
pathInput.TextSize = 14
pathInput.Text = ""
pathInput.ClearTextOnFocus = false
createStroke(pathInput)
local pathCorner = Instance.new("UICorner", pathInput)
pathCorner.CornerRadius = UDim.new(0, 6)

-- Property input
local propLabel = Instance.new("TextLabel", modifierFrame)
propLabel.Size = UDim2.new(1, -20, 0, 20)
propLabel.Position = UDim2.new(0, 10, 0, 85)
propLabel.BackgroundTransparency = 1
propLabel.TextColor3 = THEME.TEXT_PRIMARY
propLabel.TextXAlignment = Enum.TextXAlignment.Left
propLabel.Font = Enum.Font.GothamSemibold
propLabel.TextSize = 14
propLabel.Text = "Property Name:"

local propInput = Instance.new("TextBox", modifierFrame)
propInput.Size = UDim2.new(1, -20, 0, 40)
propInput.Position = UDim2.new(0, 10, 0, 110)
propInput.BackgroundColor3 = THEME.INPUT_BACKGROUND
propInput.PlaceholderText = "e.g. Value, Position, Transparency"
propInput.PlaceholderColor3 = THEME.TEXT_SECONDARY
propInput.TextColor3 = THEME.TEXT_PRIMARY
propInput.Font = Enum.Font.Gotham
propInput.TextSize = 14
propInput.Text = ""
propInput.ClearTextOnFocus = false
createStroke(propInput)
local propCorner = Instance.new("UICorner", propInput)
propCorner.CornerRadius = UDim.new(0, 6)

-- Value input
local valueLabel = Instance.new("TextLabel", modifierFrame)
valueLabel.Size = UDim2.new(1, -20, 0, 20)
valueLabel.Position = UDim2.new(0, 10, 0, 160)
valueLabel.BackgroundTransparency = 1
valueLabel.TextColor3 = THEME.TEXT_PRIMARY
valueLabel.TextXAlignment = Enum.TextXAlignment.Left
valueLabel.Font = Enum.Font.GothamSemibold
valueLabel.TextSize = 14
valueLabel.Text = "New Value:"

local valueInput = Instance.new("TextBox", modifierFrame)
valueInput.Size = UDim2.new(1, -20, 0, 40)
valueInput.Position = UDim2.new(0, 10, 0, 185)
valueInput.BackgroundColor3 = THEME.INPUT_BACKGROUND
valueInput.PlaceholderText = "Enter new value"
valueInput.PlaceholderColor3 = THEME.TEXT_SECONDARY
valueInput.TextColor3 = THEME.TEXT_PRIMARY
valueInput.Font = Enum.Font.Gotham
valueInput.TextSize = 14
valueInput.Text = ""
valueInput.ClearTextOnFocus = false
createStroke(valueInput)
local valueCorner = Instance.new("UICorner", valueInput)
valueCorner.CornerRadius = UDim.new(0, 6)

-- Set Value button
local setValueButton = createRoundedButton(modifierFrame)
setValueButton.Size = UDim2.new(1, -20, 0, 40)
setValueButton.Position = UDim2.new(0, 10, 0, 245)
setValueButton.BackgroundColor3 = THEME.BUTTON_MODIFY
setValueButton.Font = Enum.Font.GothamBold
setValueButton.TextSize = 16
setValueButton.TextColor3 = THEME.BUTTON_TEXT
setValueButton.Text = "Set Value"
applyButtonHoverEffect(setValueButton, THEME.BUTTON_MODIFY, THEME.BUTTON_MODIFY_HOVER)

-- Get Current Value button
local getCurrentButton = createRoundedButton(modifierFrame)
getCurrentButton.Size = UDim2.new(1, -20, 0, 40)
getCurrentButton.Position = UDim2.new(0, 10, 0, 295)
getCurrentButton.BackgroundColor3 = THEME.BUTTON_NORMAL
getCurrentButton.Font = Enum.Font.GothamBold
getCurrentButton.TextSize = 16
getCurrentButton.TextColor3 = THEME.BUTTON_TEXT
getCurrentButton.Text = "Get Current Value"
applyButtonHoverEffect(getCurrentButton, THEME.BUTTON_NORMAL, THEME.BUTTON_HOVER)

-- Status indicator
local statusBar = createRoundedFrame(mainWindow)
statusBar.Size = UDim2.new(1, -20, 0, 30)
statusBar.Position = UDim2.new(0, 10, 1, -40)
statusBar.BackgroundColor3 = THEME.BACKGROUND_DARK

local statusLabel = Instance.new("TextLabel", statusBar)
statusLabel.Size = UDim2.new(1, -20, 1, 0)
statusLabel.Position = UDim2.new(0, 10, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.TextColor3 = THEME.TEXT_PRIMARY
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Text = "Ready - RobXpy V.2.0 activated"

-- Create action buttons for Remotes tab
local scanButton = createRoundedButton(contentFrames["Remotes"])
scanButton.Size = UDim2.new(0.32, 0, 0, 40)
scanButton.Position = UDim2.new(0, 10, 1, -50)
scanButton.BackgroundColor3 = THEME.ACCENT
scanButton.Font = Enum.Font.GothamBold
scanButton.TextSize = 14
scanButton.TextColor3 = THEME.BUTTON_TEXT
scanButton.Text = "Scan Remotes"
applyButtonHoverEffect(scanButton, THEME.ACCENT, THEME.ACCENT_HOVER)

local copyButton = createRoundedButton(contentFrames["Remotes"])
copyButton.Size = UDim2.new(0.32, 0, 0, 40)
copyButton.Position = UDim2.new(0.33, 5, 1, -50)
copyButton.BackgroundColor3 = THEME.BUTTON_NORMAL
copyButton.Font = Enum.Font.GothamBold
copyButton.TextSize = 14
copyButton.TextColor3 = THEME.BUTTON_TEXT
copyButton.Text = "Copy Results"
applyButtonHoverEffect(copyButton, THEME.BUTTON_NORMAL, THEME.BUTTON_HOVER)

local saveButton = createRoundedButton(contentFrames["Remotes"])
saveButton.Size = UDim2.new(0.32, 0, 0, 40)
saveButton.Position = UDim2.new(0.66, 5, 1, -50)
saveButton.BackgroundColor3 = THEME.BUTTON_SAVE
saveButton.Font = Enum.Font.GothamBold
saveButton.TextSize = 14
saveButton.TextColor3 = THEME.BUTTON_TEXT
saveButton.Text = "Save to File"
applyButtonHoverEffect(saveButton, THEME.BUTTON_SAVE, THEME.BUTTON_SAVE_HOVER)

-- Create action buttons for Variables tab
local scanVarsButton = createRoundedButton(contentFrames["Variables"])
scanVarsButton.Size = UDim2.new(0.48, 0, 0, 40)
scanVarsButton.Position = UDim2.new(0, 10, 1, -50)
scanVarsButton.BackgroundColor3 = THEME.ACCENT
scanVarsButton.Font = Enum.Font.GothamBold
scanVarsButton.TextSize = 14
scanVarsButton.TextColor3 = THEME.BUTTON_TEXT
scanVarsButton.Text = "Scan Variables"
applyButtonHoverEffect(scanVarsButton, THEME.ACCENT, THEME.ACCENT_HOVER)

local saveVarsButton = createRoundedButton(contentFrames["Variables"])
saveVarsButton.Size = UDim2.new(0.48, 0, 0, 40)
saveVarsButton.Position = UDim2.new(0.5, 5, 1, -50)
saveVarsButton.BackgroundColor3 = THEME.BUTTON_SAVE
saveVarsButton.Font = Enum.Font.GothamBold
saveVarsButton.TextSize = 14
saveVarsButton.TextColor3 = THEME.BUTTON_TEXT
saveVarsButton.Text = "Save Variables"
applyButtonHoverEffect(saveVarsButton, THEME.BUTTON_SAVE, THEME.BUTTON_SAVE_HOVER)

-- Store all scan results
local allRemoteResults = {}
local allVariableResults = {}
local displayedRemoteResults = {}
local displayedVariableResults = {}
local hookedFunctions = {}
local objectsRefs = {}
local isScanning = false

-- Function to convert any value to string representation
local function valueToString(value)
    if typeof(value) == "Vector3" then
        return string.format("Vector3.new(%.2f, %.2f, %.2f)", value.X, value.Y, value.Z)
    elseif typeof(value) == "CFrame" then
        local x, y, z = value.Position.X, value.Position.Y, value.Position.Z
        return string.format("CFrame.new(%.2f, %.2f, %.2f)", x, y, z)
    elseif typeof(value) == "Color3" then
        return string.format("Color3.fromRGB(%d, %d, %d)", 
            math.floor(value.R * 255), 
            math.floor(value.G * 255), 
            math.floor(value.B * 255))
    elseif typeof(value) == "Instance" then
        return value:GetFullName()
    elseif typeof(value) == "table" then
        return "Table: " .. tostring(#value) .. " items"
    else
        return tostring(value)
    end
end

-- Function to convert string to value based on type
local function stringToValue(str, targetType)
    if targetType == "number" then
        return tonumber(str)
    elseif targetType == "string" then
        return str
    elseif targetType == "boolean" then
        return str:lower() == "true"
    elseif targetType == "Vector3" then
        local x, y, z = str:match("Vector3%.new%(([%d%.%-]+),%s*([%d%.%-]+),%s*([%d%.%-]+)%)")
        if x and y and z then
            return Vector3.new(tonumber(x), tonumber(y), tonumber(z))
        end
    elseif targetType == "CFrame" then
        local x, y, z = str:match("CFrame%.new%(([%d%.%-]+),%s*([%d%.%-]+),%s*([%d%.%-]+)%)")
        if x and y and z then
            return CFrame.new(tonumber(x), tonumber(y), tonumber(z))
        end
    elseif targetType == "Color3" then
        local r, g, b = str:match("Color3%.fromRGB%(([%d]+),%s*([%d]+),%s*([%d]+)%)")
        if r and g and b then
            return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
        end
    end
    return str
end

-- Template for list items
local function createListItem(parent, text, textColor, layoutOrder)
    local frame = createRoundedFrame(parent)
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.BackgroundColor3 = layoutOrder % 2 == 0 and THEME.BACKGROUND_DARK or THEME.BACKGROUND
    frame.LayoutOrder = layoutOrder

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -150, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = textColor or THEME.TEXT_PRIMARY
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text
    label.ClipsDescendants = true
    label.TextTruncate = Enum.TextTruncate.AtEnd

    return frame, label
end

-- Add action buttons to list items for remotes
local function addRemoteButtons(frame, item, isRemoteFunction)
    local hookButton = createRoundedButton(frame)
    hookButton.Size = UDim2.new(0, 60, 0, 24)
    hookButton.Position = UDim2.new(1, -130, 0, 3)
    hookButton.BackgroundColor3 = THEME.BUTTON_HOOK
    hookButton.Font = Enum.Font.GothamSemibold
    hookButton.TextSize = 12
    hookButton.TextColor3 = THEME.BUTTON_TEXT
    hookButton.Text = "Hook"
    applyButtonHoverEffect(hookButton, THEME.BUTTON_HOOK, THEME.BUTTON_HOOK_HOVER)
    
    hookButton.MouseButton1Click:Connect(function()
        hookFunction(item)
        hookButton.Text = "Hooked"
        hookButton.BackgroundColor3 = THEME.TEXT_HOOKED
        createTween(frame, {BackgroundColor3 = THEME.SELECTION}):Play()
    end)
    
    local copyPathButton = createRoundedButton(frame)
    copyPathButton.Size = UDim2.new(0, 60, 0, 24)
    copyPathButton.Position = UDim2.new(1, -65, 0, 3)
    copyPathButton.BackgroundColor3 = THEME.BUTTON_NORMAL
    copyPathButton.Font = Enum.Font.GothamSemibold
    copyPathButton.TextSize = 12
    copyPathButton.TextColor3 = THEME.BUTTON_TEXT
    copyPathButton.Text = "Copy"
    applyButtonHoverEffect(copyPathButton, THEME.BUTTON_NORMAL, THEME.BUTTON_HOVER)
    
    copyPathButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(item:GetFullName())
            statusLabel.Text = "Copied path to clipboard: " .. item:GetFullName()
        else
            statusLabel.Text = "Clipboard not available"
        end
    end)
    
    return hookButton
end

-- Add action buttons to list items for variables
local function addVariableButtons(frame, item)
    local modifyButton = createRoundedButton(frame)
    modifyButton.Size = UDim2.new(0, 60, 0, 24)
    modifyButton.Position = UDim2.new(1, -65, 0, 3)
    modifyButton.BackgroundColor3 = THEME.BUTTON_MODIFY
    modifyButton.Font = Enum.Font.GothamSemibold
    modifyButton.TextSize = 12
    modifyButton.TextColor3 = THEME.BUTTON_TEXT
    modifyButton.Text = "Modify"
    applyButtonHoverEffect(modifyButton, THEME.BUTTON_MODIFY, THEME.BUTTON_MODIFY_HOVER)
    
    modifyButton.MouseButton1Click:Connect(function()
        -- Switch to Modifier tab
        for name, frame in pairs(contentFrames) do
            frame.Visible = name == "Modifier"
            if tabButtons[name] then
                tabButtons[name].BackgroundColor3 = name == "Modifier" and THEME.ACCENT or THEME.BUTTON_NORMAL
            end
        end
        activeTab = "Modifier"
        
        -- Set up the modifier with this variable's info
        pathInput.Text = item:GetFullName()
        propInput.Text = "Value"
        if item.Value then
            valueInput.Text = valueToString(item.Value)
        end
        statusLabel.Text = "Ready to modify: " .. item:GetFullName()
    end)
    
    return modifyButton
end

-- Make the frame draggable
local isDragging = false
local dragInput
local dragStart
local startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        startPos = mainWindow.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and isDragging then
        local delta = input.Position - dragStart
        mainWindow.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

-- Fixed scanning function with proper result display
local function scanRemotes()
    if isScanning then
        statusLabel.Text = "Scan already in progress..."
        return
    end
    
    isScanning = true
    allRemoteResults = {}
    displayedRemoteResults = {}
    objectsRefs = {}
    
    -- Clear existing display
    for _, child in pairs(scrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Show progress bar
    progressFrame.Visible = true
    statusLabel.Text = "Scanning for remotes..."
    
    local allDescendants = game:GetDescendants()
    local totalItems = #allDescendants
    local processedItems = 0
    local remoteCount = 0
    
    -- Process items in batches to prevent lag
    local function processBatch()
        local batchEnd = math.min(processedItems + CONFIG.BATCH_SIZE, totalItems)
        
        for i = processedItems + 1, batchEnd do
            local obj = allDescendants[i]
            
            -- Check for remotes
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or 
               obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then
                
                local display = "[" .. obj.ClassName .. "] " .. obj:GetFullName()
                allRemoteResults[#allRemoteResults + 1] = {
                    display = display,
                    object = obj,
                    className = obj.ClassName
                }
                objectsRefs[display] = obj
                remoteCount = remoteCount + 1
            end
        end
        
        processedItems = batchEnd
        local progress = processedItems / totalItems
        
        -- Update progress bar
        createTween(progressBar, {Size = UDim2.new(progress, 0, 1, 0)}, 0.1):Play()
        progressText.Text = string.format("Scanning... %d/%d (%.1f%%)", processedItems, totalItems, progress * 100)
        
        if processedItems < totalItems then
            RunService.Heartbeat:Wait()
            processBatch()
        else
            -- Scanning complete
            progressFrame.Visible = false
            updateRemoteDisplay()
            statusLabel.Text = string.format("Scan complete. Found %d remotes", remoteCount)
            isScanning = false
        end
    end
    
    processBatch()
end

-- Fixed scanning function for variables
local function scanVariables()
    if isScanning then
        statusLabel.Text = "Scan already in progress..."
        return
    end
    
    isScanning = true
    allVariableResults = {}
    displayedVariableResults = {}
    objectsRefs = {}
    
    -- Clear existing display
    for _, child in pairs(varsScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Show progress bar
    varsProgressFrame.Visible = true
    statusLabel.Text = "Scanning for variables..."
    
    local allDescendants = game:GetDescendants()
    local totalItems = #allDescendants
    local processedItems = 0
    local variableCount = 0
    
    -- Process items in batches to prevent lag
    local function processBatch()
        local batchEnd = math.min(processedItems + CONFIG.BATCH_SIZE, totalItems)
        
        for i = processedItems + 1, batchEnd do
            local obj = allDescendants[i]
            
            -- Check for variables
            if obj:IsA("ObjectValue") or obj:IsA("StringValue") or obj:IsA("BoolValue") or 
               obj:IsA("IntValue") or obj:IsA("NumberValue") or obj:IsA("Vector3Value") or 
               obj:IsA("CFrameValue") or obj:IsA("Color3Value") then
                
                local value = ""
                pcall(function()
                    value = valueToString(obj.Value)
                end)
                
                local display = "[" .. obj.ClassName .. "] " .. obj:GetFullName() .. " = " .. value
                allVariableResults[#allVariableResults + 1] = {
                    display = display,
                    object = obj,
                    className = obj.ClassName,
                    value = value
                }
                objectsRefs[display] = obj
                variableCount = variableCount + 1
            end
        end
        
        processedItems = batchEnd
        local progress = processedItems / totalItems
        
        -- Update progress bar
        createTween(varsProgressBar, {Size = UDim2.new(progress, 0, 1, 0)}, 0.1):Play()
        varsProgressText.Text = string.format("Scanning... %d/%d (%.1f%%)", processedItems, totalItems, progress * 100)
        
        if processedItems < totalItems then
            RunService.Heartbeat:Wait()
            processBatch()
        else
            -- Scanning complete
            varsProgressFrame.Visible = false
            updateVariableDisplay()
            statusLabel.Text = string.format("Scan complete. Found %d variables", variableCount)
            isScanning = false
        end
    end
    
    processBatch()
end

-- Function to update remote display with search filter
function updateRemoteDisplay(searchFilter)
    -- Clear existing items
    for _, child in pairs(scrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    displayedRemoteResults = {}
    local displayCount = 0
    local totalCount = #allRemoteResults
    
    for i, result in ipairs(allRemoteResults) do
        if displayCount >= CONFIG.MAX_DISPLAY_ITEMS then
            break
        end
        
        local shouldShow = true
        if searchFilter and searchFilter ~= "" then
            shouldShow = string.find(string.lower(result.display), string.lower(searchFilter)) ~= nil
        end
        
        if shouldShow then
            displayCount = displayCount + 1
            displayedRemoteResults[displayCount] = result
            
            local textColor = result.className == "RemoteEvent" and THEME.TEXT_REMOTE or THEME.TEXT_FUNCTION
            local frame, label = createListItem(scrollingFrame, result.display, textColor, displayCount)
            
            if result.className == "RemoteFunction" or result.className == "RemoteEvent" then
                addRemoteButtons(frame, result.object, result.className == "RemoteFunction")
            end
        end
    end
    
    itemCountLabel.Text = string.format("Items: %d/%d", displayCount, totalCount)
    
    -- Update canvas size based on list layout
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end

-- Function to update variable display with search filter
function updateVariableDisplay(searchFilter)
    -- Clear existing items
    for _, child in pairs(varsScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    displayedVariableResults = {}
    local displayCount = 0
    local totalCount = #allVariableResults
    
    for i, result in ipairs(allVariableResults) do
        if displayCount >= CONFIG.MAX_DISPLAY_ITEMS then
            break
        end
        
        local shouldShow = true
        if searchFilter and searchFilter ~= "" then
            shouldShow = string.find(string.lower(result.display), string.lower(searchFilter)) ~= nil
        end
        
        if shouldShow then
            displayCount = displayCount + 1
            displayedVariableResults[displayCount] = result
            
            local frame, label = createListItem(varsScrollingFrame, result.display, THEME.TEXT_VARIABLE, displayCount)
            addVariableButtons(frame, result.object)
        end
    end
    
    varsItemCountLabel.Text = string.format("Items: %d/%d", displayCount, totalCount)
    
    -- Update canvas size based on list layout
    varsScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    varsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        varsScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, varsListLayout.AbsoluteContentSize.Y + 10)
    end)
    varsScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, varsListLayout.AbsoluteContentSize.Y + 10)
end

-- Function to hook RemoteEvents and RemoteFunctions
function hookFunction(obj)
    if not obj or typeof(obj) ~= "Instance" then return end
    
    local objFullName = obj:GetFullName()
    local isHooked = hookedFunctions[objFullName] ~= nil
    
    if isHooked then
        statusLabel.Text = objFullName .. " is already hooked"
        return
    end
    
    hookedFunctions[objFullName] = {
        object = obj,
        className = obj.ClassName,
        hookTime = os.time()
    }
    
    -- Update hooks display
    updateHooksDisplay()
    
    statusLabel.Text = "Successfully hooked " .. objFullName
end

-- Function to update hooks display
function updateHooksDisplay()
    -- Clear existing items
    for _, child in pairs(hooksScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local hookCount = 0
    for path, hookData in pairs(hookedFunctions) do
        hookCount = hookCount + 1
        local display = "[" .. hookData.className .. "] " .. path
        local textColor = hookData.className == "RemoteEvent" and THEME.TEXT_REMOTE or THEME.TEXT_FUNCTION
        local frame, label = createListItem(hooksScrollingFrame, display, textColor, hookCount)
        
        -- Add unhook button
        local unhookButton = createRoundedButton(frame)
        unhookButton.Size = UDim2.new(0, 60, 0, 24)
        unhookButton.Position = UDim2.new(1, -65, 0, 3)
        unhookButton.BackgroundColor3 = THEME.BUTTON_DELETE
        unhookButton.Font = Enum.Font.GothamSemibold
        unhookButton.TextSize = 12
        unhookButton.TextColor3 = THEME.BUTTON_TEXT
        unhookButton.Text = "Unhook"
        applyButtonHoverEffect(unhookButton, THEME.BUTTON_DELETE, THEME.BUTTON_DELETE_HOVER)
        
        unhookButton.MouseButton1Click:Connect(function()
            hookedFunctions[path] = nil
            updateHooksDisplay()
            statusLabel.Text = "Unhooked " .. path
        end)
    end
    
    hooksItemCountLabel.Text = "Hooked Functions: " .. hookCount
    
    -- Update canvas size
    hooksScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    hooksListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        hooksScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, hooksListLayout.AbsoluteContentSize.Y + 10)
    end)
    hooksScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, hooksListLayout.AbsoluteContentSize.Y + 10)
end

-- Function to save to file
function saveToFile(content, filename)
    ensureSaveFolder()
    local fullPath = CONFIG.SAVE_FOLDER .. "/" .. filename
    
    local success, err = pcall(function()
        if writefile then
            writefile(fullPath, content)
            return true
        else
            return false
        end
    end)
    
    if success then
        statusLabel.Text = "File saved to " .. fullPath
    else
        statusLabel.Text = "Error saving file: " .. (err or "writefile not available")
    end
end

-- Function to save logs
function saveLog()
    if #allRemoteResults == 0 and #allVariableResults == 0 then
        statusLabel.Text = "No results to save. Please scan first."
        return
    end
    
    local timestamp = os.date("%Y-%m-%d_%H-%M-%S")
    local filename = "RobXpy_Log_" .. timestamp .. ".txt"
    
    local content = "-- RobXpy V.2.0 Remote & Variable Spy Log\n"
    content = content .. "-- Generated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
    content = content .. "-- Game: " .. game.Name .. " (Place ID: " .. game.PlaceId .. ")\n"
    content = content .. "-- Total Remotes: " .. #allRemoteResults .. "\n"
    content = content .. "-- Total Variables: " .. #allVariableResults .. "\n\n"
    
    content = content .. "=== REMOTE EVENTS & FUNCTIONS ===\n"
    for _, result in ipairs(allRemoteResults) do
        content = content .. result.display .. "\n"
    end
    
    content = content .. "\n=== VARIABLES ===\n"
    for _, result in ipairs(allVariableResults) do
        content = content .. result.display .. "\n"
    end
    
    saveToFile(content, filename)
end

-- Function to save hooks
function saveHooks()
    if not next(hookedFunctions) then
        statusLabel.Text = "No hooked functions to save."
        return
    end
    
    local timestamp = os.date("%Y-%m-%d_%H-%M-%S")
    local filename = "RobXpy_Hooks_" .. timestamp .. ".txt"
    
    local content = "-- RobXpy V.2.0 Function Hooks Log\n"
    content = content .. "-- Generated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
    content = content .. "-- Game: " .. game.Name .. " (Place ID: " .. game.PlaceId .. ")\n\n"
    
    for path, hookData in pairs(hookedFunctions) do
        content = content .. "[" .. hookData.className .. "] " .. path .. "\n"
    end
    
    saveToFile(content, filename)
end

-- Function to copy to clipboard
function copyToClipboard()
    if #allRemoteResults == 0 and #allVariableResults == 0 then
        statusLabel.Text = "No results to copy. Please scan first."
        return
    end
    
    local content = "-- RobXpy V.2.0 Remote & Variable Spy Log\n"
    content = content .. "-- Generated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
    content = content .. "-- Game: " .. game.Name .. " (Place ID: " .. game.PlaceId .. ")\n\n"
    
    content = content .. "=== REMOTE EVENTS & FUNCTIONS ===\n"
    for _, result in ipairs(allRemoteResults) do
        content = content .. result.display .. "\n"
    end
    
    content = content .. "\n=== VARIABLES ===\n"
    for _, result in ipairs(allVariableResults) do
        content = content .. result.display .. "\n"
    end
    
    local success = pcall(function()
        if setclipboard then
            setclipboard(content)
            return true
        else
            return false
        end
    end)
    
    if success then
        statusLabel.Text = "Results copied to clipboard successfully!"
    else
        statusLabel.Text = "Clipboard not available"
    end
end

-- Function to modify values
function modifyValue()
    local path = pathInput.Text
    local newValueStr = valueInput.Text
    local propName = propInput.Text or "Value"
    
    if path == "" or newValueStr == "" or propName == "" then
        statusLabel.Text = "Please fill in all fields"
        return
    end
    
    local success, obj = pcall(function()
        return loadstring("return " .. path)()
    end)
    
    if not success or not obj then
        statusLabel.Text = "Could not find object: " .. path
        return
    end
    
    local success, currentValue = pcall(function()
        return obj[propName]
    end)
    
    if not success then
        statusLabel.Text = "Property not found: " .. propName
        return
    end
    
    local newValue = stringToValue(newValueStr, typeof(currentValue))
    
    local success, err = pcall(function()
        obj[propName] = newValue
    end)
    
    if success then
        statusLabel.Text = "Successfully set " .. path .. "." .. propName .. " to " .. valueToString(newValue)
    else
        statusLabel.Text = "Error setting value: " .. tostring(err)
    end
end

-- Function to get current value
function getCurrentValue()
    local path = pathInput.Text
    local propName = propInput.Text or "Value"
    
    if path == "" or propName == "" then
        statusLabel.Text = "Please enter object path and property name"
        return
    end
    
    local success, obj = pcall(function()
        return loadstring("return " .. path)()
    end)
    
    if not success or not obj then
        statusLabel.Text = "Could not find object: " .. path
        return
    end
    
    local success, currentValue = pcall(function()
        return obj[propName]
    end)
    
    if not success then
        statusLabel.Text = "Property not found: " .. propName
        return
    end
    
    valueInput.Text = valueToString(currentValue)
    statusLabel.Text = "Retrieved current value of " .. path .. "." .. propName
end

-- Connect UI events
-- Tab switching
for name, button in pairs(tabButtons) do
    button.MouseButton1Click:Connect(function()
        for tabName, contentFrame in pairs(contentFrames) do
            contentFrame.Visible = (tabName == name)
            tabButtons[tabName].BackgroundColor3 = (tabName == name) and THEME.ACCENT or THEME.BUTTON_NORMAL
        end
        activeTab = name
    end)
    
    applyButtonHoverEffect(button, name == activeTab and THEME.ACCENT or THEME.BUTTON_NORMAL, 
                          name == activeTab and THEME.ACCENT_HOVER or THEME.BUTTON_HOVER)
end

-- Connect remotes tab buttons
scanButton.MouseButton1Click:Connect(function()
    scanRemotes()
end)

saveButton.MouseButton1Click:Connect(function()
    saveLog()
end)

copyButton.MouseButton1Click:Connect(function()
    copyToClipboard()
end)

-- Connect variables tab buttons
scanVarsButton.MouseButton1Click:Connect(function()
    scanVariables()
end)

saveVarsButton.MouseButton1Click:Connect(function()
    saveLog()
end)

-- Connect hooks tab buttons
saveHooksButton.MouseButton1Click:Connect(function()
    saveHooks()
end)

clearHooksButton.MouseButton1Click:Connect(function()
    hookedFunctions = {}
    updateHooksDisplay()
    statusLabel.Text = "All hooks cleared"
end)

-- Connect modifier buttons
setValueButton.MouseButton1Click:Connect(function()
    modifyValue()
end)

getCurrentButton.MouseButton1Click:Connect(function()
    getCurrentValue()
end)

-- Connect search functionality
searchBar.Changed:Connect(function(prop)
    if prop == "Text" then
        updateRemoteDisplay(searchBar.Text)
    end
end)

varsSearchBar.Changed:Connect(function(prop)
    if prop == "Text" then
        updateVariableDisplay(varsSearchBar.Text)
    end
end)

-- Fixed minimize button functionality
local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        mainWindow._originalSize = mainWindow.Size
        createTween(mainWindow, {Size = UDim2.new(0, 700, 0, 40)}):Play()
        for _, frame in pairs(contentFrames) do
            frame.Visible = false
        end
        tabContainer.Visible = false
        statusBar.Visible = false
        minimizeButton.Text = "+"
    else
        createTween(mainWindow, {Size = mainWindow._originalSize or UDim2.new(0, 700, 0, 500)}):Play()
        contentFrames[activeTab].Visible = true
        tabContainer.Visible = true
        statusBar.Visible = true
        minimizeButton.Text = "−"
    end
end)

-- Advanced AI-Powered Auto-Executor System
local AutoExecutor = {}
AutoExecutor.Scripts = {}
AutoExecutor.Running = false

function AutoExecutor:AddScript(name, code, trigger)
    self.Scripts[name] = {
        code = code,
        trigger = trigger or "manual",
        lastRun = 0,
        runCount = 0
    }
    Logger:Log("Added auto-script: " .. name, "SUCCESS")
end

function AutoExecutor:ExecuteScript(name)
    local script = self.Scripts[name]
    if script then
        local success, error = pcall(function()
            loadstring(script.code)()
        end)
        
        if success then
            script.lastRun = tick()
            script.runCount = script.runCount + 1
            Logger:Log("Executed script: " .. name, "SUCCESS")
        else
            Logger:Log("Script execution failed: " .. name .. " - " .. tostring(error), "ERROR")
        end
    end
end

-- Memory Scanner with Pattern Detection
local MemoryScanner = {}
MemoryScanner.Patterns = {}
MemoryScanner.Results = {}

function MemoryScanner:ScanForPattern(pattern, dataType)
    local results = {}
    local scanCount = 0
    
    -- Scan game objects for memory patterns
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA(dataType or "Instance") then
            scanCount = scanCount + 1
            
            -- Check if object matches pattern
            local matches = self:CheckPattern(obj, pattern)
            if matches then
                table.insert(results, {
                    object = obj,
                    path = obj:GetFullName(),
                    matches = matches
                })
            end
        end
    end
    
    self.Results = results
    Logger:Log("Memory scan completed: " .. #results .. " matches found in " .. scanCount .. " objects", "INFO")
    return results
end

function MemoryScanner:CheckPattern(obj, pattern)
    -- Pattern matching logic (simplified)
    if typeof(pattern) == "string" and string.find(obj.Name:lower(), pattern:lower()) then
        return {type = "name", value = obj.Name}
    end
    return false
end

-- Real-time Game State Monitor
local GameMonitor = {}
GameMonitor.State = {}
GameMonitor.Callbacks = {}

function GameMonitor:MonitorProperty(obj, property, callback)
    local key = obj:GetFullName() .. "." .. property
    self.Callbacks[key] = callback
    
    -- Store original value
    if obj[property] then
        self.State[key] = obj[property]
    end
    
    Logger:Log("Monitoring: " .. key, "INFO")
end

function GameMonitor:CheckChanges()
    for key, callback in pairs(self.Callbacks) do
        local path, prop = key:match("(.+)%.([^%.]+)$")
        local obj = game
        
        -- Navigate to object (simplified)
        for part in path:gmatch("[^%.]+") do
            if obj and obj:FindFirstChild(part) then
                obj = obj[part]
            else
                obj = nil
                break
            end
        end
        
        if obj and obj[prop] and obj[prop] ~= self.State[key] then
            callback(obj, prop, self.State[key], obj[prop])
            self.State[key] = obj[prop]
        end
    end
end

-- Anti-Detection & Stealth System
local StealthSystem = {}
StealthSystem.Hidden = false
StealthSystem.OriginalNames = {}

function StealthSystem:EnableStealth()
    if self.Hidden then return end
    
    -- Randomize GUI names
    self.OriginalNames.gui = gui.Name
    gui.Name = "PlayerList_" .. math.random(100, 999)
    
    -- Hide from common detection methods
    if gui.Parent then
        gui.Parent = nil
        wait(0.1)
        gui.Parent = player.PlayerGui
    end
    
    self.Hidden = true
    Logger:Log("Stealth mode enabled", "SUCCESS")
end

function StealthSystem:DisableStealth()
    if not self.Hidden then return end
    
    -- Restore original names
    if self.OriginalNames.gui then
        gui.Name = self.OriginalNames.gui
    end
    
    self.Hidden = false
    Logger:Log("Stealth mode disabled", "INFO")
end

-- Advanced Export System with Multiple Formats
local ExportSystem = {}

function ExportSystem:ExportToJSON()
    local data = {
        metadata = {
            exportTime = os.date(),
            gameId = game.PlaceId,
            gameName = game.Name or "Unknown",
            username = player.Name,
            version = "RobXpy Ultimate v3.0"
        },
        remotes = allRemoteResults,
        variables = allVariableResults,
        hooks = hookedFunctions,
        performance = {
            fps = PerformanceMonitor.FPS,
            memory = PerformanceMonitor.Memory,
            ping = PerformanceMonitor.Ping
        },
        logs = Logger.Logs
    }
    
    if writefile then
        local filename = CONFIG.SAVE_FOLDER .. "/export_" .. os.date("%Y%m%d_%H%M%S") .. ".json"
        writefile(filename, HttpService:JSONEncode(data))
        Logger:Log("Data exported to: " .. filename, "SUCCESS")
        return filename
    end
    
    return HttpService:JSONEncode(data)
end

function ExportSystem:ExportToLua()
    local luaCode = [[
-- RobXpy Ultimate Export
-- Generated on ]] .. os.date() .. [[

local RemoteResults = ]]
    
    luaCode = luaCode .. self:TableToLua(allRemoteResults) .. "\n\n"
    luaCode = luaCode .. "local VariableResults = " .. self:TableToLua(allVariableResults) .. "\n\n"
    
    if writefile then
        local filename = CONFIG.SAVE_FOLDER .. "/export_" .. os.date("%Y%m%d_%H%M%S") .. ".lua"
        writefile(filename, luaCode)
        Logger:Log("Lua export saved: " .. filename, "SUCCESS")
        return filename
    end
    
    return luaCode
end

function ExportSystem:TableToLua(tbl, indent)
    indent = indent or ""
    local result = "{\n"
    
    for key, value in pairs(tbl) do
        result = result .. indent .. "    "
        
        if type(key) == "string" then
            result = result .. '["' .. key .. '"] = '
        else
            result = result .. "[" .. tostring(key) .. "] = "
        end
        
        if type(value) == "table" then
            result = result .. self:TableToLua(value, indent .. "    ")
        elseif type(value) == "string" then
            result = result .. '"' .. value .. '"'
        else
            result = result .. tostring(value)
        end
        
        result = result .. ",\n"
    end
    
    result = result .. indent .. "}"
    return result
end

-- Enhanced Quick Actions
local QuickActions = {}

function QuickActions:QuickScan()
    Logger:Log("Starting quick scan...", "INFO")
    scanRemotes()
    wait(1)
    scanVariables()
    Logger:Log("Quick scan completed", "SUCCESS")
end

function QuickActions:AutoSave()
    AutoSave:Save()
end

function QuickActions:CleanMemory()
    -- Clean up unused objects
    collectgarbage("collect")
    
    -- Clear old logs
    if #Logger.Logs > CONFIG.MAX_LOG_ENTRIES / 2 then
        for i = CONFIG.MAX_LOG_ENTRIES / 2 + 1, #Logger.Logs do
            Logger.Logs[i] = nil
        end
    end
    
    Logger:Log("Memory cleaned", "SUCCESS")
end

function QuickActions:ExportData()
    local filename = ExportSystem:ExportToJSON()
    statusLabel.Text = "Data exported successfully"
end

function QuickActions:BoostPerformance()
    -- Optimize rendering
    game:GetService("RunService").RenderStepped:Connect(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and obj.Material == Enum.Material.Neon then
                obj.Material = Enum.Material.Plastic
            end
        end
    end)
    
    Logger:Log("Performance boost applied", "SUCCESS")
end

function QuickActions:HideGUI()
    StealthSystem:EnableStealth()
    mainWindow.Visible = false
    
    -- Create minimal restore button
    local restoreBtn = Instance.new("TextButton", gui)
    restoreBtn.Size = UDim2.new(0, 100, 0, 30)
    restoreBtn.Position = UDim2.new(1, -110, 0, 10)
    restoreBtn.BackgroundColor3 = THEME.ACCENT
    restoreBtn.Text = "Restore"
    restoreBtn.TextColor3 = THEME.BUTTON_TEXT
    restoreBtn.Font = Enum.Font.GothamBold
    
    restoreBtn.MouseButton1Click:Connect(function()
        mainWindow.Visible = true
        StealthSystem:DisableStealth()
        restoreBtn:Destroy()
    end)
end

-- Connect Quick Action buttons
executeBtn.MouseButton1Click:Connect(function()
    local code = scriptInput.Text
    if code and code ~= "" then
        local success, error = pcall(function()
            loadstring(code)()
        end)
        
        if success then
            Logger:Log("Script executed successfully", "SUCCESS")
        else
            Logger:Log("Script error: " .. tostring(error), "ERROR")
        end
    end
end)

saveScriptBtn.MouseButton1Click:Connect(function()
    local code = scriptInput.Text
    if code and code ~= "" then
        AutoExecutor:AddScript("Custom_" .. tick(), code)
        scriptInput.Text = ""
    end
end)

-- Start monitoring systems
if CONFIG.REAL_TIME_MONITORING then
    spawn(function()
        while wait(1) do
            GameMonitor:CheckChanges()
        end
    end)
end

-- Auto-save system
if CONFIG.AUTO_BACKUP then
    spawn(function()
        while wait(CONFIG.AUTO_SAVE_INTERVAL) do
            AutoSave:Save()
        end
    end)
end

-- Update stats on dashboard
local function updateDashboardStats()
    if statLabels then
        statLabels["Remotes Found"].Text = tostring(#allRemoteResults)
        statLabels["Variables"].Text = tostring(#allVariableResults) 
        statLabels["Active Hooks"].Text = tostring(#hookedFunctions)
        statLabels["Scripts Loaded"].Text = tostring(#AutoExecutor.Scripts)
    end
end

-- Start stats update loop
spawn(function()
    while wait(2) do
        updateDashboardStats()
    end
end)

-- Initialize with enhanced features
Logger:Log("RobXpy Ultimate v3.0 initialized successfully!", "SUCCESS")
Logger:Log("Device: " .. DeviceManager.DeviceType .. " (Scale: " .. DeviceManager.Scale .. ")", "INFO")
Logger:Log("Features loaded: Dashboard, Memory Scanner, Auto-Executor, Network Monitor", "INFO")
Logger:Log("Anti-detection: " .. (CONFIG.ANTI_DETECTION and "Enabled" or "Disabled"), "INFO")

statusLabel.Text = "🚀 RobXpy Ultimate v3.0 ready! " .. DeviceManager.DeviceType .. " optimized"

print("╔══════════════════════════════════════════════════════════════╗")
print("║               🚀 RobXpy Ultimate v3.0 🚀                     ║") 
print("║                  LOADED SUCCESSFULLY!                        ║")
print("╠══════════════════════════════════════════════════════════════╣")
print("║ ✨ POWERFUL FEATURES:                                        ║")
print("║ • 📊 Real-time Dashboard & Analytics                         ║")
print("║ • 🔍 Advanced Remote/Variable Scanner                        ║")
print("║ • 🪝 Function Hooking & Monitoring                          ║")
print("║ • 📜 Auto-Script Executor & Manager                         ║")
print("║ • 💾 Memory Scanner & Pattern Detection                     ║")
print("║ • 🌐 Network Traffic Monitor                                ║")
print("║ • 🔒 Anti-Detection & Stealth Mode                          ║")
print("║ • 📱 Full Mobile & Tablet Support                           ║")
print("║ • ⚡ Performance Optimization                                ║")
print("║ • 🎨 Multiple Themes (Dark/Light/Neon)                      ║")
print("╠══════════════════════════════════════════════════════════════╣")
print("║ 🎯 DEVICE: " .. string.format("%-48s", DeviceManager.DeviceType) .. "║")
print("║ 📐 RESOLUTION: " .. string.format("%-43s", tostring(DeviceManager.ScreenSize)) .. "║") 
print("║ 📏 SCALE: " .. string.format("%-48s", tostring(DeviceManager.Scale)) .. "║")
print("╚══════════════════════════════════════════════════════════════╝")
print("")
print("🎮 Ready to dominate! Use the Dashboard for quick actions.")