-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Constants
local COLORS = {
    BACKGROUND = Color3.fromRGB(21, 22, 28),
    SIDEBAR = Color3.fromRGB(15, 16, 22),
    COMPONENT_BACKGROUND = Color3.fromRGB(29, 31, 39),
    TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),
    TEXT_SECONDARY = Color3.fromRGB(160, 170, 190),
    ACCENT = Color3.fromRGB(68, 114, 215),
    ACCENT_LIGHT = Color3.fromRGB(85, 130, 230),
    TOGGLE_ON = Color3.fromRGB(65, 150, 255),
    TOGGLE_OFF = Color3.fromRGB(60, 65, 80),
    TOGGLE_KNOB = Color3.fromRGB(255, 255, 255),
    SLIDER_BACKGROUND = Color3.fromRGB(40, 45, 55),
    SLIDER_FILL = Color3.fromRGB(65, 150, 255),
    SLIDER_KNOB = Color3.fromRGB(255, 255, 255),
    BORDER = Color3.fromRGB(40, 45, 55),
    TRANSPARENT = Color3.fromRGB(255, 255, 255)
}

local FONTS = {
    HEADER = Enum.Font.GothamBold,
    TEXT = Enum.Font.Gotham,
    LIGHT = Enum.Font.GothamMedium
}

local ICONS = {
    PLAYER = "rbxassetid://10734983823",
    LOOT = "rbxassetid://10734981858",
    COMBAT = "rbxassetid://10734981197",
    VISUALS = "rbxassetid://10734979870",
    GUN = "rbxassetid://10734979154",
    AMBIENT = "rbxassetid://10734978467",
    FUN = "rbxassetid://10734977865",
    SETTINGS = "rbxassetid://10734977223",
    CLOSE = "rbxassetid://10734974619"
}

function safeToString(value)
    if type(value) ~= "string" then
        return tostring(value)
    end
    return value
end

-- Utility Functions
local Utility = {}

function Utility.Tween(object, properties, duration, easingStyle, easingDirection)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(duration or 0.3, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

function Utility.CreateRoundUICorner(parent, cornerRadius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius or 6)
    corner.Parent = parent
    return corner
end

function Utility.CreateStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = color or COLORS.BORDER
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

-- Main Library
local MontyUI = {}
MontyUI.__index = MontyUI

-- Initialize the UI Library
function MontyUI.new(title)
    local self = setmetatable({}, MontyUI)
    
    -- Properties
    self.Visible = true
    self.ActiveTab = nil
    self.ActiveSubTab = nil
    self.TabContents = {}
    self.SubTabContents = {}
    self.Dragging = false
    self.DragStart = UDim2.new(0, 0, 0, 0)
    self.StartPos = UDim2.new(0.5, -350, 0.5, -200)
    
    -- Create the main UI
    self:CreateUI(title or "Monty Hub")
    
    return self
end

function MontyUI:CreateUI(title)
    -- Main UI
    self.MainUI = Instance.new("ScreenGui")
    self.MainUI.Name = "MontyUI"
    self.MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.MainUI.IgnoreGuiInset = true
    
    -- Handle different environments (game, exploit)
    if syn and syn.protect_gui then
        syn.protect_gui(self.MainUI)
        self.MainUI.Parent = game.CoreGui
    elseif gethui then
        self.MainUI.Parent = gethui()
    elseif game.CoreGui:FindFirstChild("RobloxGui") then
        self.MainUI.Parent = game.CoreGui.RobloxGui
    else
        self.MainUI.Parent = game.CoreGui
    end
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.BackgroundColor3 = COLORS.BACKGROUND
    Main.BorderSizePixel = 0
    Main.Position = self.StartPos
    Main.Size = UDim2.new(0, 700, 0, 400)
    Main.Visible = self.Visible
    Main.Parent = self.MainUI
    self.Main = Main
    
    -- UI Corner for Main
    Utility.CreateRoundUICorner(Main, 8)
    
    -- UI Stroke for Main
    Utility.CreateStroke(Main, 1, COLORS.BORDER)
    
    -- Shadow effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.Parent = Main
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = COLORS.SIDEBAR
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    self.TitleBar = TitleBar
    
    -- UI Corner for Title Bar
    Utility.CreateRoundUICorner(TitleBar, 8)
    
    -- Title Text
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = FONTS.HEADER
    Title.Text = title
    Title.TextColor3 = COLORS.TEXT_PRIMARY
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -28, 0.5, -10)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Image = ICONS.CLOSE
    CloseButton.ImageColor3 = COLORS.TEXT_SECONDARY
    CloseButton.Parent = TitleBar
    
    -- Fix for corner clipping in TitleBar
    local TitleBarBottom = Instance.new("Frame")
    TitleBarBottom.Name = "Bottom"
    TitleBarBottom.BackgroundColor3 = COLORS.SIDEBAR
    TitleBarBottom.BorderSizePixel = 0
    TitleBarBottom.Position = UDim2.new(0, 0, 1, -8)
    TitleBarBottom.Size = UDim2.new(1, 0, 0, 8)
    TitleBarBottom.Parent = TitleBar
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.BackgroundColor3 = COLORS.SIDEBAR
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 30)
    Sidebar.Size = UDim2.new(0, 200, 1, -30)
    Sidebar.Parent = Main
    self.Sidebar = Sidebar
    
    -- UI Corner for Sidebar
    Utility.CreateRoundUICorner(Sidebar, 8)
    
    -- Fix for corner clipping in Sidebar
    local SidebarRight = Instance.new("Frame")
    SidebarRight.Name = "Right"
    SidebarRight.BackgroundColor3 = COLORS.SIDEBAR
    SidebarRight.BorderSizePixel = 0
    SidebarRight.Position = UDim2.new(1, -8, 0, 0)
    SidebarRight.Size = UDim2.new(0, 8, 1, 0)
    SidebarRight.Parent = Sidebar
    
    -- Categories Container
    local Categories = Instance.new("ScrollingFrame")
    Categories.Name = "Categories"
    Categories.BackgroundTransparency = 1
    Categories.BorderSizePixel = 0
    Categories.Position = UDim2.new(0, 0, 0, 10)
    Categories.Size = UDim2.new(1, 0, 1, -10)
    Categories.CanvasSize = UDim2.new(0, 0, 0, 0)
    Categories.ScrollBarThickness = 3
    Categories.ScrollBarImageColor3 = COLORS.ACCENT
    Categories.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Categories.Parent = Sidebar
    self.SidebarCategories = Categories
    
    -- Layout for categories
    local CategoriesLayout = Instance.new("UIListLayout")
    CategoriesLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CategoriesLayout.Padding = UDim.new(0, 8)
    CategoriesLayout.Parent = Categories
    
    -- Padding for categories
    local CategoriesPadding = Instance.new("UIPadding")
    CategoriesPadding.PaddingLeft = UDim.new(0, 10)
    CategoriesPadding.PaddingRight = UDim.new(0, 10)
    CategoriesPadding.PaddingTop = UDim.new(0, 5)
    CategoriesPadding.PaddingBottom = UDim.new(0, 10)
    CategoriesPadding.Parent = Categories
    
    -- Content Frame
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.Position = UDim2.new(0, 200, 0, 30)
    Content.Size = UDim2.new(1, -200, 1, -30)
    Content.ClipsDescendants = true
    Content.Parent = Main
    self.ContentFrame = Content
    
    -- Event handlers
    CloseButton.MouseEnter:Connect(function()
        Utility.Tween(CloseButton, {ImageColor3 = COLORS.TEXT_PRIMARY}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Utility.Tween(CloseButton, {ImageColor3 = COLORS.TEXT_SECONDARY}, 0.2)
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        self.Visible = false
        Main.Visible = false
    end)
    
    -- Dragging functionality
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Category System
function MontyUI:CreateCategory(name, icon, layoutOrder)
    -- Create category label
    local categoryLabel = Instance.new("TextLabel")
    categoryLabel.Name = name .. "Category"
    categoryLabel.BackgroundTransparency = 1
    categoryLabel.Size = UDim2.new(1, 0, 0, 20)
    categoryLabel.Font = FONTS.LIGHT
    categoryLabel.Text = string.upper(name)
    categoryLabel.TextColor3 = COLORS.TEXT_SECONDARY
    categoryLabel.TextSize = 12
    categoryLabel.TextXAlignment = Enum.TextXAlignment.Left
    categoryLabel.LayoutOrder = layoutOrder or 0
    categoryLabel.Parent = self.SidebarCategories
    
    -- Create tabs container for this category
    local tabsContainer = Instance.new("Frame")
    tabsContainer.Name = name .. "Tabs"
    tabsContainer.BackgroundTransparency = 1
    tabsContainer.Size = UDim2.new(1, 0, 0, 0)
    tabsContainer.AutomaticSize = Enum.AutomaticSize.Y
    tabsContainer.LayoutOrder = layoutOrder and layoutOrder + 1 or 1
    tabsContainer.Parent = self.SidebarCategories
    
    -- Layout for tabs container
    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabsLayout.Padding = UDim.new(0, 5)
    tabsLayout.Parent = tabsContainer
    
    return {
        Label = categoryLabel,
        TabsContainer = tabsContainer
    }
end

-- Tab System
function MontyUI:CreateTab(name, icon, category, layoutOrder)
    -- Create content frame for this tab
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = name .. "Content"
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.ScrollBarThickness = 3
    contentFrame.ScrollBarImageColor3 = COLORS.ACCENT
    contentFrame.Visible = false
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentFrame.Parent = self.ContentFrame
    
    -- Layout for sections
    local sectionsLayout = Instance.new("UIListLayout")
    sectionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sectionsLayout.Padding = UDim.new(0, 10)
    sectionsLayout.Parent = contentFrame
    
    -- Padding for sections
    local sectionsPadding = Instance.new("UIPadding")
    sectionsPadding.PaddingLeft = UDim.new(0, 10)
    sectionsPadding.PaddingRight = UDim.new(0, 10) 
    sectionsPadding.PaddingTop = UDim.new(0, 10)
    sectionsPadding.PaddingBottom = UDim.new(0, 10)
    sectionsPadding.Parent = contentFrame
    
    -- Create tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.BackgroundTransparency = 1
    tabButton.Size = UDim2.new(1, 0, 0, 30)
    tabButton.Font = FONTS.TEXT
    tabButton.Text = ""
    tabButton.LayoutOrder = layoutOrder or 0
    
    if category and category.TabsContainer then
        tabButton.Parent = category.TabsContainer
    else
        tabButton.Parent = self.SidebarCategories
    end
    
    -- Icon for tab
    local iconImage = Instance.new("ImageLabel")
    iconImage.Name = "Icon"  
    iconImage.BackgroundTransparency = 1
    iconImage.Position = UDim2.new(0, 0, 0.5, -10)
    iconImage.Size = UDim2.new(0, 20, 0, 20)
    iconImage.Image = ICONS[string.upper(icon)] or icon
    iconImage.ImageColor3 = COLORS.TEXT_SECONDARY
    iconImage.Parent = tabButton
    
    -- Text for tab
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, 30, 0, 0)  
    textLabel.Size = UDim2.new(1, -30, 1, 0)
    textLabel.Font = FONTS.TEXT
    textLabel.Text = name
    textLabel.TextColor3 = COLORS.TEXT_SECONDARY
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = tabButton
    
    -- Active indicator
    local activeIndicator = Instance.new("Frame")
    activeIndicator.Name = "ActiveIndicator"
    activeIndicator.BackgroundColor3 = COLORS.ACCENT
    activeIndicator.Position = UDim2.new(0, -5, 0.5, -10)
    activeIndicator.Size = UDim2.new(0, 2, 0, 20)
    activeIndicator.Visible = false
    activeIndicator.Parent = tabButton
    
    -- Store tab information
    self.TabContents[name] = {
        ContentFrame = contentFrame,
        TabButton = tabButton,
        Icon = iconImage,
        Text = textLabel,
        ActiveIndicator = activeIndicator
    }
    
    -- Events
    tabButton.MouseEnter:Connect(function()
        if self.ActiveTab ~= name then
            Utility.Tween(iconImage, {ImageColor3 = COLORS.TEXT_PRIMARY}, 0.2)
            Utility.Tween(textLabel, {TextColor3 = COLORS.TEXT_PRIMARY}, 0.2)
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.ActiveTab ~= name then
            Utility.Tween(iconImage, {ImageColor3 = COLORS.TEXT_SECONDARY}, 0.2)
            Utility.Tween(textLabel, {TextColor3 = COLORS.TEXT_SECONDARY}, 0.2)
        end
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        -- Deactivate all tabs
        for tabName, tab in pairs(self.TabContents) do
            tab.ContentFrame.Visible = false
            tab.ActiveIndicator.Visible = false
            tab.Icon.ImageColor3 = COLORS.TEXT_SECONDARY
            tab.Text.TextColor3 = COLORS.TEXT_SECONDARY
        end
        
        -- Activate this tab
        contentFrame.Visible = true
        activeIndicator.Visible = true
        iconImage.ImageColor3 = COLORS.ACCENT
        textLabel.TextColor3 = COLORS.TEXT_PRIMARY
        self.ActiveTab = name
    end)
    
    -- If this is the first tab, activate it
    if not self.ActiveTab then
        contentFrame.Visible = true
        activeIndicator.Visible = true
        iconImage.ImageColor3 = COLORS.ACCENT
        textLabel.TextColor3 = COLORS.TEXT_PRIMARY
        self.ActiveTab = name
    end
    
    -- Return object to create sections
    return {
        Name = name,
        ContentFrame = contentFrame,
        
        -- Section Creator
        CreateSection = function(sectionName, layoutOrder)
            return self:CreateSection(sectionName, contentFrame, layoutOrder)
        end,
        
        -- Sub Tab Creator
        CreateSubTabs = function(subTabNames)
            return self:CreateSubTabs(subTabNames, contentFrame)
        end
    }
end

-- Fix for CreateSection function
function MontyUI:CreateSection(name, parent, layoutOrder)
    name = safeToString(name)

    -- Create the section frame
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = name .. "Section"
    sectionFrame.BackgroundColor3 = COLORS.COMPONENT_BACKGROUND
    sectionFrame.Size = UDim2.new(1, 0, 0, 0)
    sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
    sectionFrame.LayoutOrder = layoutOrder or 0
    sectionFrame.Parent = parent
    
    -- UI Corner
    Utility.CreateRoundUICorner(sectionFrame, 6)
    
    -- Section Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.Size = UDim2.new(1, -20, 0, 20)
    titleLabel.Font = FONTS.HEADER
    titleLabel.Text = name
    titleLabel.TextColor3 = COLORS.TEXT_PRIMARY
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = sectionFrame
    
    -- Items Container (rest of the code remains the same)
    local itemsContainer = Instance.new("Frame")
    itemsContainer.Name = "Items"
    itemsContainer.BackgroundTransparency = 1
    itemsContainer.Position = UDim2.new(0, 0, 0, 30)
    itemsContainer.Size = UDim2.new(1, 0, 0, 0)
    itemsContainer.AutomaticSize = Enum.AutomaticSize.Y
    itemsContainer.Parent = sectionFrame
    
    -- Layout for items
    local itemsLayout = Instance.new("UIListLayout")
    itemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    itemsLayout.Padding = UDim.new(0, 5)
    itemsLayout.Parent = itemsContainer
    
    -- Padding for items
    local itemsPadding = Instance.new("UIPadding")
    itemsPadding.PaddingLeft = UDim.new(0, 10)
    itemsPadding.PaddingRight = UDim.new(0, 10)
    itemsPadding.PaddingTop = UDim.new(0, 0)
    itemsPadding.PaddingBottom = UDim.new(0, 10)
    itemsPadding.Parent = itemsContainer
    
    -- Return object to create items
    return {
        Frame = sectionFrame,
        ItemsContainer = itemsContainer,
        
        CreateToggle = function(toggleName, default, callback, layoutOrder)
            return self:CreateToggle(toggleName, default, callback, itemsContainer, layoutOrder)
        end,
        
        CreateSlider = function(sliderName, min, max, default, decimals, callback, suffix, layoutOrder)
            return self:CreateSlider(sliderName, min, max, default, decimals, callback, suffix, itemsContainer, layoutOrder)
        end,
        
        CreateDropdown = function(dropdownName, options, default, callback, layoutOrder)
            return self:CreateDropdown(dropdownName, options, default, callback, itemsContainer, layoutOrder)
        end,
        
        CreateButton = function(buttonName, callback, layoutOrder)
            return self:CreateButton(buttonName, callback, itemsContainer, layoutOrder)
        end,
        
        CreateColorPicker = function(colorName, default, callback, layoutOrder)
            return self:CreateColorPicker(colorName, default, callback, itemsContainer, layoutOrder)
        end,
        
        CreateLabel = function(labelText, layoutOrder)
            return self:CreateLabel(labelText, itemsContainer, layoutOrder)
        end
    }
end

-- Fix for CreateToggle function
function MontyUI:CreateToggle(name, default, callback, parent, layoutOrder)
    name = safeToString(name)
    
    -- Create toggle container
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = name .. "Toggle"
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Size = UDim2.new(1, 0, 0, 30)
    toggleContainer.LayoutOrder = layoutOrder or 0
    toggleContainer.Parent = parent
    
    -- Toggle text
    local toggleText = Instance.new("TextLabel")
    toggleText.Name = "Text"
    toggleText.BackgroundTransparency = 1
    toggleText.Position = UDim2.new(0, 0, 0, 0)
    toggleText.Size = UDim2.new(1, -50, 1, 0)
    toggleText.Font = FONTS.TEXT
    toggleText.Text = name
    toggleText.TextColor3 = COLORS.TEXT_PRIMARY
    toggleText.TextSize = 14
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    toggleText.Parent = toggleContainer
    
    -- Toggle background
    local toggleBackground = Instance.new("Frame")
    toggleBackground.Name = "Background"
    toggleBackground.BackgroundColor3 = default and COLORS.TOGGLE_ON or COLORS.TOGGLE_OFF
    toggleBackground.Position = UDim2.new(1, -40, 0.5, -10)
    toggleBackground.Size = UDim2.new(0, 40, 0, 20)
    toggleBackground.Parent = toggleContainer
    
    -- Toggle background corner
    Utility.CreateRoundUICorner(toggleBackground, 10)
    
    -- Toggle knob
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Name = "Knob"
    toggleKnob.BackgroundColor3 = COLORS.TOGGLE_KNOB
    toggleKnob.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    toggleKnob.Size = UDim2.new(0, 16, 0, 16)
    toggleKnob.Parent = toggleBackground
    
    -- Toggle knob corner
    Utility.CreateRoundUICorner(toggleKnob, 8)
    
    -- Toggle button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "Button"
    toggleButton.BackgroundTransparency = 1
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.Text = ""
    toggleButton.Parent = toggleContainer
    
    -- Toggle state
    local enabled = default or false
    
    -- Toggle function
    local function updateToggle()
        enabled = not enabled
        Utility.Tween(toggleBackground, {BackgroundColor3 = enabled and COLORS.TOGGLE_ON or COLORS.TOGGLE_OFF}, 0.2)
        Utility.Tween(toggleKnob, {Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
        
        if callback then
            callback(enabled)
        end
    end
    
    -- Events
    toggleButton.MouseButton1Click:Connect(updateToggle)
    
    return {
        Toggle = function()
            updateToggle()
        end,
        
        SetState = function(state)
            if state ~= enabled then
                updateToggle()
            end
        end,
        
        GetState = function()
            return enabled
        end,
        
        UpdateText = function(newText)
            newText = safeToString(newText)
            toggleText.Text = newText
        end
    }
end

-- Fix for CreateSlider function
function MontyUI:CreateSlider(name, min, max, default, decimals, callback, suffix, parent, layoutOrder)
    name = safeToString(name)
    suffix = suffix and safeToString(suffix) or ""
    
    -- Validate inputs
    min = type(min) == "number" and min or 0
    max = type(max) == "number" and max or 100
    default = type(default) == "number" and math.clamp(default, min, max) or min
    decimals = type(decimals) == "number" and math.clamp(decimals, 0, 10) or 0
    
    -- Create slider container
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = name .. "Slider"
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.Size = UDim2.new(1, 0, 0, 50)
    sliderContainer.LayoutOrder = layoutOrder or 0
    sliderContainer.Parent = parent
    
    -- Slider text
    local sliderText = Instance.new("TextLabel")
    sliderText.Name = "Text"
    sliderText.BackgroundTransparency = 1
    sliderText.Position = UDim2.new(0, 0, 0, 0)
    sliderText.Size = UDim2.new(1, 0, 0, 20)
    sliderText.Font = FONTS.TEXT
    sliderText.Text = name
    sliderText.TextColor3 = COLORS.TEXT_PRIMARY
    sliderText.TextSize = 14
    sliderText.TextXAlignment = Enum.TextXAlignment.Left
    sliderText.Parent = sliderContainer
    
    -- Value text
    local valueText = Instance.new("TextLabel")
    valueText.Name = "Value"
    valueText.BackgroundTransparency = 1
    valueText.Position = UDim2.new(1, -50, 0, 0)
    valueText.Size = UDim2.new(0, 50, 0, 20)
    valueText.Font = FONTS.TEXT
    valueText.Text = tostring(default) .. suffix
    valueText.TextColor3 = COLORS.TEXT_SECONDARY
    valueText.TextSize = 14
    valueText.TextXAlignment = Enum.TextXAlignment.Right
    valueText.Parent = sliderContainer
    
    -- Slider background
    local sliderBackground = Instance.new("Frame")
    sliderBackground.Name = "Background"
    sliderBackground.BackgroundColor3 = COLORS.SLIDER_BACKGROUND
    sliderBackground.Position = UDim2.new(0, 0, 0, 25)
    sliderBackground.Size = UDim2.new(1, 0, 0, 6)
    sliderBackground.Parent = sliderContainer
    
    -- Slider background corner
    Utility.CreateRoundUICorner(sliderBackground, 3)
    
    -- Slider fill
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.BackgroundColor3 = COLORS.SLIDER_FILL
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.Parent = sliderBackground
    
    -- Slider fill corner
    Utility.CreateRoundUICorner(sliderFill, 3)
    
    -- Slider knob
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Name = "Knob"
    sliderKnob.BackgroundColor3 = COLORS.SLIDER_KNOB
    sliderKnob.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    sliderKnob.Size = UDim2.new(0, 12, 0, 12)
    sliderKnob.ZIndex = 2
    sliderKnob.Parent = sliderBackground
    
    -- Slider knob corner
    Utility.CreateRoundUICorner(sliderKnob, 6)
    
    -- Slider button
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "Button"
    sliderButton.BackgroundTransparency = 1
    sliderButton.Size = UDim2.new(1, 0, 1, 0)
    sliderButton.Text = ""
    sliderButton.ZIndex = 3
    sliderButton.Parent = sliderBackground
    
    -- Current value
    local value = default
    
    -- Format value
    local function formatValue(val)
        if decimals <= 0 then
            return math.floor(val)
        else
            local fmt = "%." .. decimals .. "f"
            return string.format(fmt, val)
        end
    end
    
    -- Update slider
    local function updateSlider(newValue)
        -- Clamp value
        newValue = math.clamp(newValue, min, max)
        value = newValue
        
        -- Calculate position
        local percent = (value - min) / (max - min)
        
        -- Update UI
        Utility.Tween(sliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
        Utility.Tween(sliderKnob, {Position = UDim2.new(percent, -6, 0.5, -6)}, 0.1)
        valueText.Text = formatValue(value) .. suffix
        
        -- Call callback
        if callback then
            callback(value)
        end
    end
    
    -- Drag functionality
    local isDragging = false
    
    sliderButton.MouseButton1Down:Connect(function()
        isDragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    sliderButton.MouseButton1Click:Connect(function()
        local mousePos = UserInputService:GetMouseLocation().X
        local sliderPos = sliderBackground.AbsolutePosition.X
        local sliderWidth = sliderBackground.AbsoluteSize.X
        local percent = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
        local newValue = min + (max - min) * percent
        updateSlider(newValue)
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
            local mousePos = UserInputService:GetMouseLocation().X
            local sliderPos = sliderBackground.AbsolutePosition.X
            local sliderWidth = sliderBackground.AbsoluteSize.X
            local percent = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
            local newValue = min + (max - min) * percent
            updateSlider(newValue)
        end
    end)
    
    -- Set default value
    updateSlider(default)
    
    return {
        SetValue = function(newValue)
            updateSlider(newValue)
        end,
        
        GetValue = function()
            return value
        end,
        
        UpdateText = function(newText)
            newText = safeToString(newText)
            sliderText.Text = newText
        end
    }
end

-- Fix for CreateDropdown function
function MontyUI:CreateDropdown(name, options, default, callback, parent, layoutOrder)
    name = safeToString(name)
    
    -- Options validation
    if type(options) ~= "table" or #options == 0 then
        options = {"Option 1"}
    end
    
    -- Default validation
    if type(default) ~= "string" or not table.find(options, default) then
        default = options[1]
    end
    
    -- Create dropdown container
    local dropdownContainer = Instance.new("Frame")
    dropdownContainer.Name = name .. "Dropdown"
    dropdownContainer.BackgroundTransparency = 1
    dropdownContainer.Size = UDim2.new(1, 0, 0, 50)
    dropdownContainer.LayoutOrder = layoutOrder or 0
    dropdownContainer.Parent = parent
    
    -- Dropdown text
    local dropdownText = Instance.new("TextLabel")
    dropdownText.Name = "Text"
    dropdownText.BackgroundTransparency = 1
    dropdownText.Position = UDim2.new(0, 0, 0, 0)
    dropdownText.Size = UDim2.new(1, 0, 0, 20)
    dropdownText.Font = FONTS.TEXT
    dropdownText.Text = name
    dropdownText.TextColor3 = COLORS.TEXT_PRIMARY
    dropdownText.TextSize = 14
    dropdownText.TextXAlignment = Enum.TextXAlignment.Left
    dropdownText.Parent = dropdownContainer
    
    -- Dropdown button
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "Button"
    dropdownButton.BackgroundColor3 = COLORS.COMPONENT_BACKGROUND
    dropdownButton.Position = UDim2.new(0, 0, 0, 25)
    dropdownButton.Size = UDim2.new(1, 0, 0, 30)
    dropdownButton.Font = FONTS.TEXT
    dropdownButton.Text = ""
    dropdownButton.TextColor3 = COLORS.TEXT_PRIMARY
    dropdownButton.TextSize = 14
    dropdownButton.Parent = dropdownContainer
    
    -- Dropdown corner
    Utility.CreateRoundUICorner(dropdownButton, 6)
    
    -- Selected value text
    local valueText = Instance.new("TextLabel")
    valueText.Name = "Value"
    valueText.BackgroundTransparency = 1
    valueText.Position = UDim2.new(0, 10, 0, 0)
    valueText.Size = UDim2.new(1, -40, 1, 0)
    valueText.Font = FONTS.TEXT
    valueText.Text = default
    valueText.TextColor3 = COLORS.TEXT_PRIMARY
    valueText.TextSize = 14
    valueText.TextXAlignment = Enum.TextXAlignment.Left
    valueText.Parent = dropdownButton
    
    -- Dropdown arrow
    local dropdownArrow = Instance.new("ImageLabel")
    dropdownArrow.Name = "Arrow"
    dropdownArrow.BackgroundTransparency = 1
    dropdownArrow.Position = UDim2.new(1, -25, 0.5, -8)
    dropdownArrow.Size = UDim2.new(0, 16, 0, 16)
    dropdownArrow.Image = "rbxassetid://6031091004"
    dropdownArrow.ImageColor3 = COLORS.TEXT_SECONDARY
    dropdownArrow.Parent = dropdownButton
    
    -- Options frame (dropdown menu)
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Name = "Options"
    optionsFrame.BackgroundColor3 = COLORS.COMPONENT_BACKGROUND
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Position = UDim2.new(0, 0, 1, 5)
    optionsFrame.Size = UDim2.new(1, 0, 0, #options * 30)
    optionsFrame.Visible = false
    optionsFrame.ZIndex = 10
    optionsFrame.Parent = dropdownButton
    
    -- Options corner
    Utility.CreateRoundUICorner(optionsFrame, 6)
    
    -- Current selection
    local selectedOption = default
    
    -- Create options
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = option .. "Option"
        optionButton.BackgroundTransparency = 1
        optionButton.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.Font = FONTS.TEXT
        optionButton.Text = option
        optionButton.TextColor3 = option == default and COLORS.ACCENT or COLORS.TEXT_PRIMARY
        optionButton.TextSize = 14
        optionButton.ZIndex = 11
        optionButton.Parent = optionsFrame
        
        -- Option events
        optionButton.MouseEnter:Connect(function()
            if option ~= selectedOption then
                Utility.Tween(optionButton, {BackgroundTransparency = 0.9}, 0.2)
            end
        end)
        
        optionButton.MouseLeave:Connect(function()
            if option ~= selectedOption then
                Utility.Tween(optionButton, {BackgroundTransparency = 1}, 0.2)
            end
        end)
        
        optionButton.MouseButton1Click:Connect(function()
            -- Update selection
            selectedOption = option
            valueText.Text = option
            
            -- Update appearance
            for _, child in pairs(optionsFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    child.TextColor3 = child.Text == option and COLORS.ACCENT or COLORS.TEXT_PRIMARY
                end
            end
            
            -- Close dropdown
            optionsFrame.Visible = false
            
            -- Call callback
            if callback then
                callback(option)
            end
        end)
    end
    
    -- Dropdown events
    dropdownButton.MouseButton1Click:Connect(function()
        optionsFrame.Visible = not optionsFrame.Visible
        local rotation = optionsFrame.Visible and 180 or 0
        Utility.Tween(dropdownArrow, {Rotation = rotation}, 0.2)
    end)
    
    -- Close dropdown when clicking elsewhere
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local inBounds = false
            
            -- Check if mouse is within dropdown bounds
            if optionsFrame.Visible then
                local framePos = optionsFrame.AbsolutePosition
                local frameSize = optionsFrame.AbsoluteSize
                
                inBounds = mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and
                           mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y
                
                if not inBounds then
                    local buttonPos = dropdownButton.AbsolutePosition
                    local buttonSize = dropdownButton.AbsoluteSize
                    
                    inBounds = mousePos.X >= buttonPos.X and mousePos.X <= buttonPos.X + buttonSize.X and
                               mousePos.Y >= buttonPos.Y and mousePos.Y <= buttonPos.Y + buttonSize.Y
                               
                    if not inBounds then
                        optionsFrame.Visible = false
                        Utility.Tween(dropdownArrow, {Rotation = 0}, 0.2)
                    end
                end
            end
        end
    end)
    
    return {
        SetOption = function(option)
            if table.find(options, option) then
                -- Update UI
                selectedOption = option
                valueText.Text = option
                
                -- Update appearance
                for _, child in pairs(optionsFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.TextColor3 = child.Text == option and COLORS.ACCENT or COLORS.TEXT_PRIMARY
                    end
                end
                
                -- Call callback
                if callback then
                    callback(option)
                end
            end
        end,
        
        GetOption = function()
            return selectedOption
        end,
        
        UpdateOptions = function(newOptions)
            if type(newOptions) == "table" and #newOptions > 0 then
                -- Clear old options
                for _, child in pairs(optionsFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                -- Update options frame size
                optionsFrame.Size = UDim2.new(1, 0, 0, #newOptions * 30)
                
                -- Check if selected option exists in new options
                if not table.find(newOptions, selectedOption) then
                    selectedOption = newOptions[1]
                    valueText.Text = selectedOption
                end
                
                -- Create new options
                for i, option in ipairs(newOptions) do
                    local optionButton = Instance.new("TextButton")
                    optionButton.Name = option .. "Option"
                    optionButton.BackgroundTransparency = 1
                    optionButton.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
                    optionButton.Size = UDim2.new(1, 0, 0, 30)
                    optionButton.Font = FONTS.TEXT
                    optionButton.Text = option
                    optionButton.TextColor3 = option == selectedOption and COLORS.ACCENT or COLORS.TEXT_PRIMARY
                    optionButton.TextSize = 14
                    optionButton.ZIndex = 11
                    optionButton.Parent = optionsFrame
                    
                    -- Option events
                    optionButton.MouseEnter:Connect(function()
                        if option ~= selectedOption then
                            Utility.Tween(optionButton, {BackgroundTransparency = 0.9}, 0.2)
                        end
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        if option ~= selectedOption then
                            Utility.Tween(optionButton, {BackgroundTransparency = 1}, 0.2)
                        end
                    end)
                    
                    optionButton.MouseButton1Click:Connect(function()
                        -- Update selection
                        selectedOption = option
                        valueText.Text = option
                        
                        -- Update appearance
                        for _, child in pairs(optionsFrame:GetChildren()) do
                            if child:IsA("TextButton") then
                                child.TextColor3 = child.Text == option and COLORS.ACCENT or COLORS.TEXT_PRIMARY
                            end
                        end
                        
                        -- Close dropdown
                        optionsFrame.Visible = false
                        
                        -- Call callback
                        if callback then
                            callback(option)
                        end
                    end)
                end
            end
        end,
        
        UpdateText = function(newText)
            newText = safeToString(newText)
            dropdownText.Text = newText
        end
    }
end

-- Fix for CreateButton function
function MontyUI:CreateButton(name, callback, parent, layoutOrder)
    name = safeToString(name)
    
    -- Create button container
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = name .. "Button"
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Size = UDim2.new(1, 0, 0, 30)
    buttonContainer.LayoutOrder = layoutOrder or 0
    buttonContainer.Parent = parent
    
    -- Button
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.BackgroundColor3 = COLORS.COMPONENT_BACKGROUND
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Font = FONTS.TEXT
    button.Text = name
    button.TextColor3 = COLORS.TEXT_PRIMARY
    button.TextSize = 14
    button.Parent = buttonContainer
    
    -- Button corner
    Utility.CreateRoundUICorner(button, 6)
    
    -- Button events
    button.MouseEnter:Connect(function()
        Utility.Tween(button, {BackgroundColor3 = Color3.fromRGB(
            COLORS.COMPONENT_BACKGROUND.R * 1.1,
            COLORS.COMPONENT_BACKGROUND.G * 1.1,
            COLORS.COMPONENT_BACKGROUND.B * 1.1
        )}, 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        Utility.Tween(button, {BackgroundColor3 = COLORS.COMPONENT_BACKGROUND}, 0.2)
    end)
    
    button.MouseButton1Down:Connect(function()
        Utility.Tween(button, {BackgroundColor3 = COLORS.ACCENT}, 0.1)
    end)
    
    button.MouseButton1Up:Connect(function()
        Utility.Tween(button, {BackgroundColor3 = Color3.fromRGB(
            COLORS.COMPONENT_BACKGROUND.R * 1.1,
            COLORS.COMPONENT_BACKGROUND.G * 1.1,
            COLORS.COMPONENT_BACKGROUND.B * 1.1
        )}, 0.1)
    end)
    
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return {
        UpdateText = function(newText)
            newText = safeToString(newText)
            button.Text = newText
        end
    }
end

-- Fix for CreateColorPicker function
function MontyUI:CreateColorPicker(name, default, callback, parent, layoutOrder)
    name = safeToString(name)
    
    -- Default color validation
    if typeof(default) ~= "Color3" then
        default = Color3.fromRGB(255, 255, 255)
    end
    
    -- Create color picker container
    local colorPickerContainer = Instance.new("Frame")
    colorPickerContainer.Name = name .. "ColorPicker"
    colorPickerContainer.BackgroundTransparency = 1
    colorPickerContainer.Size = UDim2.new(1, 0, 0, 50)
    colorPickerContainer.LayoutOrder = layoutOrder or 0
    colorPickerContainer.Parent = parent
    
    -- Color picker text
    local colorText = Instance.new("TextLabel")
    colorText.Name = "Text"
    colorText.BackgroundTransparency = 1
    colorText.Position = UDim2.new(0, 0, 0, 0)
    colorText.Size = UDim2.new(1, -60, 0, 20)
    colorText.Font = FONTS.TEXT
    colorText.Text = name
    colorText.TextColor3 = COLORS.TEXT_PRIMARY
    colorText.TextSize = 14
    colorText.TextXAlignment = Enum.TextXAlignment.Left
    colorText.Parent = colorPickerContainer
    
    -- Color display
    local colorDisplay = Instance.new("Frame")
    colorDisplay.Name = "Display"
    colorDisplay.BackgroundColor3 = default
    colorDisplay.Position = UDim2.new(1, -50, 0, 0)
    colorDisplay.Size = UDim2.new(0, 50, 0, 20)
    colorDisplay.Parent = colorPickerContainer
    
    -- Color display corner
    Utility.CreateRoundUICorner(colorDisplay, 6)
    
    -- Section Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.Size = UDim2.new(1, -20, 0, 20)
    titleLabel.Font = FONTS.HEADER
    titleLabel.Text = name
    titleLabel.TextColor3 = COLORS.TEXT_PRIMARY
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = sectionFrame
    
    -- Items Container
    local itemsContainer = Instance.new("Frame")
    itemsContainer.Name = "Items"
    itemsContainer.BackgroundTransparency = 1
    itemsContainer.Position = UDim2.new(0, 0, 0, 30)
    itemsContainer.Size = UDim2.new(1, 0, 0, 0)
    itemsContainer.AutomaticSize = Enum.AutomaticSize.Y
    itemsContainer.Parent = sectionFrame
    
    -- Layout for items
    local itemsLayout = Instance.new("UIListLayout")
    itemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    itemsLayout.Padding = UDim.new(0, 5)
    itemsLayout.Parent = itemsContainer
    
    -- Padding for items
    local itemsPadding = Instance.new("UIPadding")
    itemsPadding.PaddingLeft = UDim.new(0, 10)
    itemsPadding.PaddingRight = UDim.new(0, 10)
    itemsPadding.PaddingTop = UDim.new(0, 0)
    itemsPadding.PaddingBottom = UDim.new(0, 10)
    itemsPadding.Parent = itemsContainer
    
    -- Return object to create items
    return {
        Frame = sectionFrame,
        ItemsContainer = itemsContainer,
        
        CreateToggle = function(toggleName, default, callback, layoutOrder)
            return self:CreateToggle(toggleName, default, callback, itemsContainer, layoutOrder)
        end,
        
        CreateSlider = function(sliderName, min, max, default, decimals, callback, suffix, layoutOrder)
            return self:CreateSlider(sliderName, min, max, default, decimals, callback, suffix, itemsContainer, layoutOrder)
        end,
        
        CreateDropdown = function(dropdownName, options, default, callback, layoutOrder)
            return self:CreateDropdown(dropdownName, options, default, callback, itemsContainer, layoutOrder)
        end,
        
        CreateButton = function(buttonName, callback, layoutOrder)
            return self:CreateButton(buttonName, callback, itemsContainer, layoutOrder)
        end,
        
        CreateColorPicker = function(colorName, default, callback, layoutOrder)
            return self:CreateColorPicker(colorName, default, callback, itemsContainer, layoutOrder)
        end,
        
        CreateLabel = function(labelText, layoutOrder)
            return self:CreateLabel(labelText, itemsContainer, layoutOrder)
        end
    }
end

-- Sub Tab System
function MontyUI:CreateSubTabs(tabNames, parent)
    -- Create container for sub tabs
    local subTabContainer = Instance.new("Frame")
    subTabContainer.Name = "SubTabContainer"
    subTabContainer.BackgroundTransparency = 1
    subTabContainer.Size = UDim2.new(1, 0, 0, 40)
    subTabContainer.Parent = parent
    
    -- Tab Buttons Container
    local tabButtons = Instance.new("Frame")
    tabButtons.Name = "TabButtons"
    tabButtons.BackgroundColor3 = COLORS.COMPONENT_BACKGROUND
    tabButtons.Size = UDim2.new(1, 0, 0, 30)
    tabButtons.Parent = subTabContainer
    
    -- UI Corner for tab buttons
    Utility.CreateRoundUICorner(tabButtons, 6)
    
    -- Layout for buttons
    local buttonLayout = Instance.new("UIListLayout")
    buttonLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    buttonLayout.Padding = UDim.new(0, 0)
    buttonLayout.Parent = tabButtons
    
    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.BackgroundTransparency = 1
    contentContainer.Position = UDim2.new(0, 0, 0, 40)
    contentContainer.Size = UDim2.new(1, 0, 0, 0)
    contentContainer.AutomaticSize = Enum.AutomaticSize.Y
    contentContainer.Parent = subTabContainer
    
    local tabInfo = {}
    local contentFrames = {}
    local currentActiveTab = nil
    
    -- Calculate button width
    local buttonWidth = 1 / #tabNames
    
    -- Create tab buttons and content frames
    for i, tabName in ipairs(tabNames) do
        -- Create tab button
        local button = Instance.new("TextButton")
        button.Name = tabName .. "Button"
        button.BackgroundTransparency = 1
        button.Size = UDim2.new(buttonWidth, 0, 1, 0)
        button.Font = FONTS.TEXT
        button.Text = tabName
        button.TextColor3 = i == 1 and COLORS.TEXT_PRIMARY or COLORS.TEXT_SECONDARY
        button.TextSize = 14
        button.LayoutOrder = i
        button.Parent = tabButtons
        
        -- Active Indicator
        local activeIndicator = Instance.new("Frame")
        activeIndicator.Name = "ActiveIndicator"
        activeIndicator.BackgroundColor3 = COLORS.ACCENT
        activeIndicator.Position = UDim2.new(0, 0, 1, -2)
        activeIndicator.Size = UDim2.new(1, 0, 0, 2)
        activeIndicator.Visible = i == 1
        activeIndicator.Parent = button
        
        -- Create content frame
        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Name = tabName .. "Content"
        contentFrame.BackgroundTransparency = 1
        contentFrame.Size = UDim2.new(1, 0, 0, 0)
        contentFrame.AutomaticSize = Enum.AutomaticSize.Y
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentFrame.ScrollBarThickness = 3
        contentFrame.ScrollBarImageColor3 = COLORS.ACCENT
        contentFrame.Visible = i == 1
        contentFrame.ClipsDescendants = false
        contentFrame.Parent = contentContainer
        
        -- Layout for content
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.Parent = contentFrame
        
        -- Store tab information
        tabInfo[tabName] = {
            Button = button,
            ActiveIndicator = activeIndicator
        }
        
        contentFrames[tabName] = contentFrame
        
        -- Events
        button.MouseEnter:Connect(function()
            if currentActiveTab ~= tabName then
                Utility.Tween(button, {TextColor3 = COLORS.TEXT_PRIMARY}, 0.2)
            end
        end)
        
        button.MouseLeave:Connect(function()
            if currentActiveTab ~= tabName then
                Utility.Tween(button, {TextColor3 = COLORS.TEXT_SECONDARY}, 0.2)
            end
        end)
        
        button.MouseButton1Click:Connect(function()
            -- Deactivate all tabs
            for name, info in pairs(tabInfo) do
                info.Button.TextColor3 = COLORS.TEXT_SECONDARY
                info.ActiveIndicator.Visible = false
                contentFrames[name].Visible = false
            end
            
            -- Activate this tab
            button.TextColor3 = COLORS.TEXT_PRIMARY
            activeIndicator.Visible = true
            contentFrame.Visible = true
            currentActiveTab = tabName
        end)
    end
    
    -- Set first tab as active by default
    currentActiveTab = tabNames[1]
    
    -- Return object to create sections for each tab
    local subTabsObject = {}
    
    for _, tabName in ipairs(tabNames) do
        subTabsObject[tabName] = {
            CreateSection = function(sectionName, layoutOrder)
                return self:CreateSection(sectionName, contentFrames[tabName], layoutOrder)
            end
        }
    end
    
    return subTabsObject
end

return MontyUI
