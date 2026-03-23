--[[
    Premium UI Library for Roblox (Luau)
    Theme: Black & White with Animated Rotating Gradients
    Features: Full modular system, animations, key system, notifications, etc.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ClipboardService = (cloneref and cloneref(game:GetService("Clipboard"))) or game:GetService("Clipboard")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local PremiumUI = {}
PremiumUI.__index = PremiumUI

-- Constants
local THEMES = {
    Dark = {
        Background = Color3.fromRGB(15, 15, 15),
        Surface = Color3.fromRGB(25, 25, 25),
        SurfaceLight = Color3.fromRGB(35, 35, 35),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(170, 170, 170),
        Accent = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(50, 50, 50),
        Danger = Color3.fromRGB(220, 50, 50),
        Success = Color3.fromRGB(50, 220, 50),
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 245),
        Surface = Color3.fromRGB(255, 255, 255),
        SurfaceLight = Color3.fromRGB(240, 240, 240),
        Text = Color3.fromRGB(20, 20, 20),
        TextSecondary = Color3.fromRGB(100, 100, 100),
        Accent = Color3.fromRGB(0, 0, 0),
        Border = Color3.fromRGB(220, 220, 220),
        Danger = Color3.fromRGB(220, 50, 50),
        Success = Color3.fromRGB(50, 200, 50),
    },
    GreenFreeze = {
        Background = Color3.fromRGB(10, 20, 10),
        Surface = Color3.fromRGB(15, 30, 15),
        SurfaceLight = Color3.fromRGB(20, 40, 20),
        Text = Color3.fromRGB(180, 255, 180),
        TextSecondary = Color3.fromRGB(100, 200, 100),
        Accent = Color3.fromRGB(0, 255, 0),
        Border = Color3.fromRGB(0, 80, 0),
        Danger = Color3.fromRGB(255, 80, 80),
        Success = Color3.fromRGB(80, 255, 80),
        GlowColor = Color3.fromRGB(0, 255, 0),
    }
}

-- Utility Functions
local function Tween(instance, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle[style or "Quad"], Enum.EasingDirection[direction or "Out"])
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function CreateGradientFrame(parent, position, size, color1, color2, rotationSpeed)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundTransparency = 1
    frame.Position = position
    frame.Size = size
    frame.ZIndex = 0
    
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 0
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(0.5, color2),
        ColorSequenceKeypoint.new(1, color1)
    })
    gradient.Parent = frame
    
    local connection
    connection = RunService.RenderStepped:Connect(function(dt)
        if not frame.Parent then connection:Disconnect() return end
        gradient.Rotation = (gradient.Rotation + (rotationSpeed or 10) * dt) % 360
    end)
    
    return frame, connection
end

-- Main UI Class
function PremiumUI:CreateWindow(config)
    config = config or {}
    local themeName = config.Theme or "Dark"
    local currentTheme = THEMES[themeName] or THEMES.Dark
    
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PremiumUI"
    screenGui.Parent = Player:WaitForChild("PlayerGui")
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    
    -- Main Container (for background gradient)
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Parent = screenGui
    mainContainer.BackgroundTransparency = 1
    mainContainer.Size = UDim2.new(1, 0, 1, 0)
    mainContainer.Position = UDim2.new(0, 0, 0, 0)
    
    -- Animated Background Gradient
    local bgGradient1 = Color3.fromRGB(20, 20, 20)
    local bgGradient2 = Color3.fromRGB(40, 40, 40)
    if themeName == "Light" then
        bgGradient1 = Color3.fromRGB(220, 220, 220)
        bgGradient2 = Color3.fromRGB(250, 250, 250)
    elseif themeName == "GreenFreeze" then
        bgGradient1 = Color3.fromRGB(0, 40, 0)
        bgGradient2 = Color3.fromRGB(0, 80, 0)
    end
    
    local bgFrame, bgConnection = CreateGradientFrame(mainContainer, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), bgGradient1, bgGradient2, 15)
    
    -- Main Window Frame
    local window = Instance.new("Frame")
    window.Name = "Window"
    window.Parent = mainContainer
    window.BackgroundColor3 = currentTheme.Background
    window.BorderSizePixel = 0
    window.ClipsDescendants = true
    window.Position = UDim2.new(0.5, -300, 0.5, -200)
    window.Size = UDim2.new(0, 600, 0, 400)
    window.BackgroundTransparency = 0.05
    
    -- Shadow
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Parent = window
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.6
    shadow.BorderSizePixel = 0
    shadow.Position = UDim2.new(0, 5, 0, 5)
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.ZIndex = -1
    
    -- Corner rounding (sharp but slight)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = window
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 6)
    shadowCorner.Parent = shadow
    
    -- Border Glow Effect
    local borderGlow = Instance.new("Frame")
    borderGlow.Name = "BorderGlow"
    borderGlow.Parent = window
    borderGlow.BackgroundTransparency = 1
    borderGlow.Position = UDim2.new(-0.01, 0, -0.01, 0)
    borderGlow.Size = UDim2.new(1.02, 0, 1.02, 0)
    borderGlow.ZIndex = -1
    
    local borderGradient = Instance.new("UIGradient")
    borderGradient.Rotation = 0
    borderGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, currentTheme.Accent),
        ColorSequenceKeypoint.new(0.5, currentTheme.Text),
        ColorSequenceKeypoint.new(1, currentTheme.Accent)
    })
    borderGradient.Parent = borderGlow
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 6)
    borderCorner.Parent = borderGlow
    
    local glowConnection
    glowConnection = RunService.RenderStepped:Connect(function(dt)
        if not borderGlow.Parent then glowConnection:Disconnect() return end
        borderGradient.Rotation = (borderGradient.Rotation + 25 * dt) % 360
    end)
    
    -- Title Bar (Draggable)
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Parent = window
    titleBar.BackgroundColor3 = currentTheme.Surface
    titleBar.BackgroundTransparency = 0.2
    titleBar.BorderSizePixel = 0
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 6)
    titleCorner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Parent = titleBar
    titleText.BackgroundTransparency = 1
    titleText.Position = UDim2.new(0, 12, 0, 0)
    titleText.Size = UDim2.new(0, 200, 1, 0)
    titleText.Text = config.Title or "Premium UI"
    titleText.TextColor3 = currentTheme.Text
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 14
    
    local authorText = Instance.new("TextLabel")
    authorText.Parent = titleBar
    authorText.BackgroundTransparency = 1
    authorText.Position = UDim2.new(0, 12, 0, 20)
    authorText.Size = UDim2.new(0, 200, 0, 16)
    authorText.Text = config.Author or ""
    authorText.TextColor3 = currentTheme.TextSecondary
    authorText.TextXAlignment = Enum.TextXAlignment.Left
    authorText.Font = Enum.Font.Gotham
    authorText.TextSize = 10
    
    -- Window Buttons
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Parent = titleBar
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Position = UDim2.new(1, -70, 0, 0)
    minimizeBtn.Size = UDim2.new(0, 30, 1, 0)
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = currentTheme.Text
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 20
    minimizeBtn.AutoButtonColor = false
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = titleBar
    closeBtn.BackgroundTransparency = 1
    closeBtn.Position = UDim2.new(1, -35, 0, 0)
    closeBtn.Size = UDim2.new(0, 35, 1, 0)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = currentTheme.Danger
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.AutoButtonColor = false
    
    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "Content"
    contentContainer.Parent = window
    contentContainer.BackgroundTransparency = 1
    contentContainer.Position = UDim2.new(0, 0, 0, 45)
    contentContainer.Size = UDim2.new(1, 0, 1, -45)
    
    -- Tabs Container
    local tabsContainer = Instance.new("Frame")
    tabsContainer.Name = "Tabs"
    tabsContainer.Parent = contentContainer
    tabsContainer.BackgroundTransparency = 1
    tabsContainer.Position = UDim2.new(0, 0, 0, 0)
    tabsContainer.Size = UDim2.new(1, 0, 0, 35)
    
    local pagesContainer = Instance.new("Frame")
    pagesContainer.Name = "Pages"
    pagesContainer.Parent = contentContainer
    pagesContainer.BackgroundTransparency = 1
    pagesContainer.Position = UDim2.new(0, 0, 0, 40)
    pagesContainer.Size = UDim2.new(1, 0, 1, -40)
    pagesContainer.ClipsDescendants = true
    
    -- State
    local uiState = {
        Visible = true,
        Minimized = false,
        CurrentTab = nil,
        Tabs = {},
        Elements = {},
        Theme = themeName,
        Colors = currentTheme,
        Window = window,
        ScreenGui = screenGui,
        Connections = {bgConnection, glowConnection},
        Pages = pagesContainer,
        TabsContainer = tabsContainer,
    }
    
    -- Dragging Logic
    local dragging = false
    local dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Minimize/Close
    local originalSize = window.Size
    minimizeBtn.MouseButton1Click:Connect(function()
        if uiState.Minimized then
            Tween(window, {Size = originalSize}, 0.3, "Quad")
            contentContainer.Visible = true
            uiState.Minimized = false
        else
            Tween(window, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 45)}, 0.3, "Quad")
            contentContainer.Visible = false
            uiState.Minimized = true
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        uiState.Visible = false
        Tween(window, {BackgroundTransparency = 1}, 0.2, "Quad")
        Tween(titleBar, {BackgroundTransparency = 1}, 0.2, "Quad")
        for _, child in pairs(pagesContainer:GetChildren()) do
            if child:IsA("Frame") then
                Tween(child, {BackgroundTransparency = 1}, 0.2, "Quad")
            end
        end
        task.wait(0.2)
        screenGui.Enabled = false
    end)
    
    -- Floating Toggle Button
    local toggleButton = Instance.new("ImageButton")
    toggleButton.Name = "ToggleUI"
    toggleButton.Parent = screenGui
    toggleButton.BackgroundColor3 = currentTheme.Surface
    toggleButton.BackgroundTransparency = 0.1
    toggleButton.Position = UDim2.new(0, 20, 1, -60)
    toggleButton.Size = UDim2.new(0, 45, 0, 45)
    toggleButton.Image = "rbxassetid://3926305904"
    toggleButton.ImageColor3 = currentTheme.Text
    toggleButton.ScaleType = Enum.ScaleType.Fit
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleButton
    
    toggleButton.MouseButton1Click:Connect(function()
        uiState.Visible = not uiState.Visible
        if uiState.Visible then
            screenGui.Enabled = true
            window.BackgroundTransparency = 0.05
            titleBar.BackgroundTransparency = 0.2
            Tween(window, {BackgroundTransparency = 0.05}, 0.2)
            Tween(titleBar, {BackgroundTransparency = 0.2}, 0.2)
        else
            Tween(window, {BackgroundTransparency = 1}, 0.2)
            Tween(titleBar, {BackgroundTransparency = 1}, 0.2)
            task.wait(0.2)
            screenGui.Enabled = false
        end
    end)
    
    -- Key System
    local keyValid = false
    local keySystemData = config.KeySystem
    
    local function ShowKeyDialog()
        local dialog = Instance.new("Frame")
        dialog.Parent = screenGui
        dialog.BackgroundColor3 = currentTheme.Background
        dialog.BorderSizePixel = 0
        dialog.Position = UDim2.new(0.5, -150, 0.5, -100)
        dialog.Size = UDim2.new(0, 300, 0, 200)
        dialog.BackgroundTransparency = 0.1
        dialog.ZIndex = 10
        
        local dialogCorner = Instance.new("UICorner")
        dialogCorner.CornerRadius = UDim.new(0, 8)
        dialogCorner.Parent = dialog
        
        local title = Instance.new("TextLabel")
        title.Parent = dialog
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 10, 0, 10)
        title.Size = UDim2.new(1, -20, 0, 30)
        title.Text = "Key Required"
        title.TextColor3 = currentTheme.Text
        title.Font = Enum.Font.GothamBold
        title.TextSize = 18
        
        local note = Instance.new("TextLabel")
        note.Parent = dialog
        note.BackgroundTransparency = 1
        note.Position = UDim2.new(0, 10, 0, 45)
        note.Size = UDim2.new(1, -20, 0, 40)
        note.Text = keySystemData.Note or "Enter the key to continue"
        note.TextColor3 = currentTheme.TextSecondary
        note.Font = Enum.Font.Gotham
        note.TextSize = 12
        note.TextWrapped = true
        
        local inputBox = Instance.new("TextBox")
        inputBox.Parent = dialog
        inputBox.BackgroundColor3 = currentTheme.Surface
        inputBox.Position = UDim2.new(0, 10, 0, 90)
        inputBox.Size = UDim2.new(1, -20, 0, 35)
        inputBox.PlaceholderText = "Enter key..."
        inputBox.Text = ""
        inputBox.TextColor3 = currentTheme.Text
        inputBox.Font = Enum.Font.Gotham
        inputBox.TextSize = 14
        
        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 4)
        inputCorner.Parent = inputBox
        
        local confirmBtn = Instance.new("TextButton")
        confirmBtn.Parent = dialog
        confirmBtn.BackgroundColor3 = currentTheme.Accent
        confirmBtn.Position = UDim2.new(0, 10, 0, 135)
        confirmBtn.Size = UDim2.new(0.5, -15, 0, 35)
        confirmBtn.Text = "Confirm"
        confirmBtn.TextColor3 = currentTheme.Background
        confirmBtn.Font = Enum.Font.GothamBold
        confirmBtn.TextSize = 14
        confirmBtn.AutoButtonColor = false
        
        local confirmCorner = Instance.new("UICorner")
        confirmCorner.CornerRadius = UDim.new(0, 4)
        confirmCorner.Parent = confirmBtn
        
        local cancelBtn = Instance.new("TextButton")
        cancelBtn.Parent = dialog
        cancelBtn.BackgroundColor3 = currentTheme.SurfaceLight
        cancelBtn.Position = UDim2.new(0.5, 5, 0, 135)
        cancelBtn.Size = UDim2.new(0.5, -15, 0, 35)
        cancelBtn.Text = "Cancel"
        cancelBtn.TextColor3 = currentTheme.Text
        cancelBtn.Font = Enum.Font.GothamBold
        cancelBtn.TextSize = 14
        cancelBtn.AutoButtonColor = false
        
        local cancelCorner = Instance.new("UICorner")
        cancelCorner.CornerRadius = UDim.new(0, 4)
        cancelCorner.Parent = cancelBtn
        
        local errorLabel = Instance.new("TextLabel")
        errorLabel.Parent = dialog
        errorLabel.BackgroundTransparency = 1
        errorLabel.Position = UDim2.new(0, 10, 0, 175)
        errorLabel.Size = UDim2.new(1, -20, 0, 20)
        errorLabel.Text = ""
        errorLabel.TextColor3 = currentTheme.Danger
        errorLabel.Font = Enum.Font.Gotham
        errorLabel.TextSize = 11
        
        local function CheckKey(key)
            if type(keySystemData.Key) == "table" then
                for _, k in pairs(keySystemData.Key) do
                    if k == key then return true end
                end
            elseif keySystemData.Key == key then
                return true
            end
            return false
        end
        
        confirmBtn.MouseButton1Click:Connect(function()
            local key = inputBox.Text
            if CheckKey(key) then
                keyValid = true
                dialog:Destroy()
                if keySystemData.Save then
                    -- Save locally (mock)
                end
                screenGui.Enabled = true
            else
                errorLabel.Text = "Invalid key!"
                Tween(errorLabel, {TextTransparency = 0}, 0.1)
                task.wait(1)
                Tween(errorLabel, {TextTransparency = 1}, 0.3)
            end
        end)
        
        cancelBtn.MouseButton1Click:Connect(function()
            dialog:Destroy()
            screenGui:Destroy()
        end)
    end
    
    if keySystemData then
        screenGui.Enabled = false
        if keySystemData.GetKey then
            keySystemData.GetKey(ShowKeyDialog)
        else
            ShowKeyDialog()
        end
        repeat task.wait() until keyValid
    end
    
    -- API Functions
    local windowAPI = {}
    
    function windowAPI:CreateTab(name, icon)
        local tabButton = Instance.new("TextButton")
        tabButton.Parent = tabsContainer
        tabButton.BackgroundTransparency = 1
        tabButton.Size = UDim2.new(0, 80, 1, 0)
        tabButton.Text = name
        tabButton.TextColor3 = currentTheme.TextSecondary
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 13
        tabButton.AutoButtonColor = false
        
        local page = Instance.new("ScrollingFrame")
        page.Parent = pagesContainer
        page.BackgroundTransparency = 1
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Position = UDim2.new(1, 0, 0, 0)
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.ScrollBarThickness = 4
        page.ScrollBarImageColor3 = currentTheme.Text
        page.BorderSizePixel = 0
        
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Parent = page
        pageLayout.Padding = UDim.new(0, 8)
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local pagePadding = Instance.new("UIPadding")
        pagePadding.Parent = page
        pagePadding.PaddingLeft = UDim.new(0, 12)
        pagePadding.PaddingRight = UDim.new(0, 12)
        pagePadding.PaddingTop = UDim.new(0, 8)
        pagePadding.PaddingBottom = UDim.new(0, 8)
        
        tabButton.MouseButton1Click:Connect(function()
            if uiState.CurrentTab then
                Tween(uiState.CurrentTab.Page, {Position = UDim2.new(1, 0, 0, 0)}, 0.2)
                uiState.CurrentTab.Button.TextColor3 = currentTheme.TextSecondary
            end
            Tween(page, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
            tabButton.TextColor3 = currentTheme.Accent
            uiState.CurrentTab = {Button = tabButton, Page = page}
        end)
        
        if not uiState.CurrentTab then
            tabButton.TextColor3 = currentTheme.Accent
            page.Position = UDim2.new(0, 0, 0, 0)
            uiState.CurrentTab = {Button = tabButton, Page = page}
        end
        
        local tabAPI = {}
        
        function tabAPI:CreateSection(title)
            local section = Instance.new("Frame")
            section.Parent = page
            section.BackgroundTransparency = 1
            section.Size = UDim2.new(1, 0, 0, 30)
            section.LayoutOrder = #page:GetChildren()
            
            local sectionText = Instance.new("TextLabel")
            sectionText.Parent = section
            sectionText.BackgroundTransparency = 1
            sectionText.Position = UDim2.new(0, 0, 0, 0)
            sectionText.Size = UDim2.new(1, 0, 1, 0)
            sectionText.Text = title
            sectionText.TextColor3 = currentTheme.Text
            sectionText.Font = Enum.Font.GothamBold
            sectionText.TextSize = 14
            sectionText.TextXAlignment = Enum.TextXAlignment.Left
            
            local line = Instance.new("Frame")
            line.Parent = section
            line.BackgroundColor3 = currentTheme.Border
            line.BorderSizePixel = 0
            line.Position = UDim2.new(0, 0, 1, -2)
            line.Size = UDim2.new(1, 0, 0, 1)
            
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
            pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
            end)
            
            return section
        end
        
        function tabAPI:CreateButton(config)
            local btnFrame = Instance.new("Frame")
            btnFrame.Parent = page
            btnFrame.BackgroundColor3 = currentTheme.Surface
            btnFrame.BackgroundTransparency = 0.3
            btnFrame.Size = UDim2.new(1, 0, 0, 42)
            btnFrame.LayoutOrder = #page:GetChildren()
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = btnFrame
            
            local btn = Instance.new("TextButton")
            btn.Parent = btnFrame
            btn.BackgroundTransparency = 1
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.Text = config.Title or "Button"
            btn.TextColor3 = currentTheme.Text
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 13
            btn.AutoButtonColor = false
            
            btn.MouseEnter:Connect(function()
                Tween(btnFrame, {BackgroundTransparency = 0.1}, 0.1)
            end)
            btn.MouseLeave:Connect(function()
                Tween(btnFrame, {BackgroundTransparency = 0.3}, 0.1)
            end)
            btn.MouseButton1Click:Connect(function()
                if config.Callback then config.Callback() end
            end)
            
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
            return btnFrame
        end
        
        function tabAPI:CreateToggle(config)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Parent = page
            toggleFrame.BackgroundColor3 = currentTheme.Surface
            toggleFrame.BackgroundTransparency = 0.3
            toggleFrame.Size = UDim2.new(1, 0, 0, 42)
            toggleFrame.LayoutOrder = #page:GetChildren()
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = toggleFrame
            
            local title = Instance.new("TextLabel")
            title.Parent = toggleFrame
            title.BackgroundTransparency = 1
            title.Position = UDim2.new(0, 12, 0, 0)
            title.Size = UDim2.new(0.7, 0, 1, 0)
            title.Text = config.Title or "Toggle"
            title.TextColor3 = currentTheme.Text
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Font = Enum.Font.Gotham
            title.TextSize = 13
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Parent = toggleFrame
            toggleBtn.BackgroundColor3 = currentTheme.SurfaceLight
            toggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
            toggleBtn.Size = UDim2.new(0, 40, 0, 24)
            toggleBtn.Text = ""
            toggleBtn.AutoButtonColor = false
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = toggleBtn
            
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Parent = toggleBtn
            toggleCircle.BackgroundColor3 = currentTheme.Text
            toggleCircle.Size = UDim2.new(0, 20, 0, 20)
            toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = toggleCircle
            
            local state = config.Default or false
            if state then
                toggleBtn.BackgroundColor3 = currentTheme.Accent
                toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
            end
            
            toggleBtn.MouseButton1Click:Connect(function()
                state = not state
                if state then
                    Tween(toggleBtn, {BackgroundColor3 = currentTheme.Accent}, 0.1)
                    Tween(toggleCircle, {Position = UDim2.new(1, -22, 0.5, -10)}, 0.1)
                else
                    Tween(toggleBtn, {BackgroundColor3 = currentTheme.SurfaceLight}, 0.1)
                    Tween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, -10)}, 0.1)
                end
                if config.Callback then config.Callback(state) end
            end)
            
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
            return toggleFrame
        end
        
        function tabAPI:CreateSlider(config)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Parent = page
            sliderFrame.BackgroundColor3 = currentTheme.Surface
            sliderFrame.BackgroundTransparency = 0.3
            sliderFrame.Size = UDim2.new(1, 0, 0, 65)
            sliderFrame.LayoutOrder = #page:GetChildren()
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = sliderFrame
            
            local title = Instance.new("TextLabel")
            title.Parent = sliderFrame
            title.BackgroundTransparency = 1
            title.Position = UDim2.new(0, 12, 0, 5)
            title.Size = UDim2.new(0.7, 0, 0, 20)
            title.Text = config.Title or "Slider"
            title.TextColor3 = currentTheme.Text
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Font = Enum.Font.Gotham
            title.TextSize = 13
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Parent = sliderFrame
            valueLabel.BackgroundTransparency = 1
            valueLabel.Position = UDim2.new(1, -50, 0, 5)
            valueLabel.Size = UDim2.new(0, 40, 0, 20)
            valueLabel.Text = tostring(config.Default or config.Min)
            valueLabel.TextColor3 = currentTheme.Accent
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.TextSize = 13
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Parent = sliderFrame
            sliderBg.BackgroundColor3 = currentTheme.SurfaceLight
            sliderBg.Position = UDim2.new(0, 12, 0, 35)
            sliderBg.Size = UDim2.new(1, -24, 0, 4)
            local bgCorner = Instance.new("UICorner")
            bgCorner.CornerRadius = UDim.new(1, 0)
            bgCorner.Parent = sliderBg
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Parent = sliderBg
            sliderFill.BackgroundColor3 = currentTheme.Accent
            sliderFill.Size = UDim2.new(0, 0, 1, 0)
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = sliderFill
            
            local min = config.Min or 0
            local max = config.Max or 100
            local value = config.Default or min
            
            local function UpdateSlider(val)
                val = math.clamp(val, min, max)
                value = val
                local percent = (value - min) / (max - min)
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                valueLabel.Text = tostring(math.floor(value))
                if config.Callback then config.Callback(value) end
            end
            
            UpdateSlider(value)
            
            local dragging = false
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local x = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local newVal = min + (max - min) * x
                    UpdateSlider(newVal)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local x = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local newVal = min + (max - min) * x
                    UpdateSlider(newVal)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
            return sliderFrame
        end
        
        function tabAPI:CreateDropdown(config)
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Parent = page
            dropdownFrame.BackgroundColor3 = currentTheme.Surface
            dropdownFrame.BackgroundTransparency = 0.3
            dropdownFrame.Size = UDim2.new(1, 0, 0, 42)
            dropdownFrame.LayoutOrder = #page:GetChildren()
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = dropdownFrame
            
            local title = Instance.new("TextLabel")
            title.Parent = dropdownFrame
            title.BackgroundTransparency = 1
            title.Position = UDim2.new(0, 12, 0, 0)
            title.Size = UDim2.new(0.5, 0, 1, 0)
            title.Text = config.Title or "Dropdown"
            title.TextColor3 = currentTheme.Text
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Font = Enum.Font.Gotham
            title.TextSize = 13
            
            local dropdownBtn = Instance.new("TextButton")
            dropdownBtn.Parent = dropdownFrame
            dropdownBtn.BackgroundColor3 = currentTheme.SurfaceLight
            dropdownBtn.Position = UDim2.new(1, -120, 0.5, -15)
            dropdownBtn.Size = UDim2.new(0, 110, 0, 30)
            dropdownBtn.Text = config.Options and config.Options[1] or "Select"
            dropdownBtn.TextColor3 = currentTheme.Text
            dropdownBtn.Font = Enum.Font.Gotham
            dropdownBtn.TextSize = 12
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = dropdownBtn
            
            local dropdownList = Instance.new("Frame")
            dropdownList.Parent = dropdownFrame
            dropdownList.BackgroundColor3 = currentTheme.Surface
            dropdownList.Position = UDim2.new(1, -120, 0, 45)
            dropdownList.Size = UDim2.new(0, 110, 0, 0)
            dropdownList.ClipsDescendants = true
            dropdownList.Visible = false
            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 4)
            listCorner.Parent = dropdownList
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.Parent = dropdownList
            listLayout.Padding = UDim.new(0, 2)
            
            local options = config.Options or {}
            local currentOption = options[1]
            
            for _, opt in pairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Parent = dropdownList
                optBtn.BackgroundColor3 = currentTheme.SurfaceLight
                optBtn.Size = UDim2.new(1, 0, 0, 28)
                optBtn.Text = opt
                optBtn.TextColor3 = currentTheme.Text
                optBtn.Font = Enum.Font.Gotham
                optBtn.TextSize = 12
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 4)
                optCorner.Parent = optBtn
                
                optBtn.MouseButton1Click:Connect(function()
                    currentOption = opt
                    dropdownBtn.Text = opt
                    dropdownList.Visible = false
                    Tween(dropdownList, {Size = UDim2.new(0, 110, 0, 0)}, 0.2)
                    if config.Callback then config.Callback(opt) end
                end)
            end
            
            dropdownBtn.MouseButton1Click:Connect(function()
                if dropdownList.Visible then
                    Tween(dropdownList, {Size = UDim2.new(0, 110, 0, 0)}, 0.2)
                    task.wait(0.2)
                    dropdownList.Visible = false
                else
                    dropdownList.Visible = true
                    local height = #options * 30
                    Tween(dropdownList, {Size = UDim2.new(0, 110, 0, height)}, 0.2)
                end
            end)
            
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
            return dropdownFrame
        end
        
        function tabAPI:CreateNotification(config)
            local notif = Instance.new("Frame")
            notif.Parent = screenGui
            notif.BackgroundColor3 = currentTheme.Surface
            notif.Position = UDim2.new(1, -320, 0, 50)
            notif.Size = UDim2.new(0, 300, 0, 60)
            notif.BackgroundTransparency = 0.1
            
            local notifCorner = Instance.new("UICorner")
            notifCorner.CornerRadius = UDim.new(0, 6)
            notifCorner.Parent = notif
            
            local text = Instance.new("TextLabel")
            text.Parent = notif
            text.BackgroundTransparency = 1
            text.Size = UDim2.new(1, -20, 1, 0)
            text.Position = UDim2.new(0, 10, 0, 0)
            text.Text = config.Title or "Notification"
            text.TextColor3 = currentTheme.Text
            text.TextXAlignment = Enum.TextXAlignment.Left
            text.Font = Enum.Font.Gotham
            text.TextSize = 13
            text.TextWrapped = true
            
            Tween(notif, {Position = UDim2.new(1, -320, 0, 50)}, 0.3)
            task.wait(3)
            Tween(notif, {Position = UDim2.new(1, 0, 0, 50)}, 0.3)
            task.wait(0.3)
            notif:Destroy()
        end
        
        function tabAPI:CreatePopup(config)
            -- Simple popup implementation
            local popup = Instance.new("Frame")
            popup.Parent = screenGui
            popup.BackgroundColor3 = currentTheme.Background
            popup.Position = UDim2.new(0.5, -150, 0.5, -75)
            popup.Size = UDim2.new(0, 300, 0, 150)
            popup.BackgroundTransparency = 0.1
            popup.ZIndex = 20
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = popup
            
            local title = Instance.new("TextLabel")
            title.Parent = popup
            title.BackgroundTransparency = 1
            title.Size = UDim2.new(1, 0, 0, 40)
            title.Text = config.Title or "Popup"
            title.TextColor3 = currentTheme.Text
            title.Font = Enum.Font.GothamBold
            title.TextSize = 16
            
            local desc = Instance.new("TextLabel")
            desc.Parent = popup
            desc.BackgroundTransparency = 1
            desc.Position = UDim2.new(0, 10, 0, 40)
            desc.Size = UDim2.new(1, -20, 0, 50)
            desc.Text = config.Description or ""
            desc.TextColor3 = currentTheme.TextSecondary
            desc.Font = Enum.Font.Gotham
            desc.TextSize = 12
            desc.TextWrapped = true
            
            local confirm = Instance.new("TextButton")
            confirm.Parent = popup
            confirm.BackgroundColor3 = currentTheme.Accent
            confirm.Position = UDim2.new(0, 10, 1, -40)
            confirm.Size = UDim2.new(0.5, -15, 0, 30)
            confirm.Text = "Confirm"
            confirm.TextColor3 = currentTheme.Background
            confirm.Font = Enum.Font.GothamBold
            
            local cancel = Instance.new("TextButton")
            cancel.Parent = popup
            cancel.BackgroundColor3 = currentTheme.SurfaceLight
            cancel.Position = UDim2.new(0.5, 5, 1, -40)
            cancel.Size = UDim2.new(0.5, -15, 0, 30)
            cancel.Text = "Cancel"
            cancel.TextColor3 = currentTheme.Text
            cancel.Font = Enum.Font.GothamBold
            
            confirm.MouseButton1Click:Connect(function()
                if config.Callback then config.Callback(true) end
                popup:Destroy()
            end)
            cancel.MouseButton1Click:Connect(function()
                if config.Callback then config.Callback(false) end
                popup:Destroy()
            end)
        end
        
        return tabAPI
    end
    
    function windowAPI:Notify(config)
        local notif = Instance.new("Frame")
        notif.Parent = screenGui
        notif.BackgroundColor3 = currentTheme.Surface
        notif.Position = UDim2.new(1, -320, 0, 50)
        notif.Size = UDim2.new(0, 300, 0, 60)
        notif.BackgroundTransparency = 0.1
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 6)
        notifCorner.Parent = notif
        
        local text = Instance.new("TextLabel")
        text.Parent = notif
        text.BackgroundTransparency = 1
        text.Size = UDim2.new(1, -20, 1, 0)
        text.Position = UDim2.new(0, 10, 0, 0)
        text.Text = config.Title or "Notification"
        text.TextColor3 = currentTheme.Text
        text.TextXAlignment = Enum.TextXAlignment.Left
        text.Font = Enum.Font.Gotham
        text.TextSize = 13
        text.TextWrapped = true
        
        Tween(notif, {Position = UDim2.new(1, -320, 0, 50)}, 0.3)
        task.wait(3)
        Tween(notif, {Position = UDim2.new(1, 0, 0, 50)}, 0.3)
        task.wait(0.3)
        notif:Destroy()
    end
    
    return windowAPI
end

return PremiumUI
