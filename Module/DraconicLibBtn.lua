local DraconicBtn = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local LibBtnScreenGui = Instance.new("ScreenGui")
LibBtnScreenGui.Name = "DraconicButtonLibrary"
LibBtnScreenGui.ResetOnSpawn = false
LibBtnScreenGui.Parent = player:WaitForChild("PlayerGui")

local buttons = {}
local activeButton = nil
local holdTime = 0
local holdDuration = 0.5
local holdActive = false
local clickCancelled = false

local buttonReferences = {}

local DragSystem = {}

function DragSystem.IsMouseOverFrame(Frame: GuiObject, Position: Vector2): boolean
	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
	return Position.X >= AbsPos.X
		and Position.X <= AbsPos.X + AbsSize.X
		and Position.Y >= AbsPos.Y
		and Position.Y <= AbsPos.Y + AbsSize.Y
end

function DragSystem.IsClickInput(Input: InputObject): boolean
	return Input.UserInputState == Enum.UserInputState.Begin
		and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch)
end

function DragSystem.IsMoveInput(Input: InputObject): boolean
	return Input.UserInputState == Enum.UserInputState.Change
		and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
end

function DragSystem.MakeDraggable(MainFrame: GuiObject, DragFrame: GuiObject, CallbackTable)
	if not MainFrame or not DragFrame then
		warn("DragSystem.MakeDraggable: Missing required parameters")
		return
	end
	
	local dragging = false
	local dragInput = nil
	local dragStart = nil
	local startPos = nil
	local connection = nil
	
	function updatePosition(input)
		if not dragging or not dragStart then return end
		
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale, 
			startPos.X.Offset + delta.X,
			startPos.Y.Scale, 
			startPos.Y.Offset + delta.Y
		)
		
		if CallbackTable and CallbackTable.OnDragUpdate then
			CallbackTable.OnDragUpdate(MainFrame.Position)
		end
	end
	
	function onInputEnded()
		if dragging then
			dragging = false
			dragInput = nil
			dragStart = nil
			
			if CallbackTable and CallbackTable.OnDragEnd then
				CallbackTable.OnDragEnd(MainFrame.Position)
			end
			
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end
	
	function onInputChanged(_, input)
		if input == dragInput and input.UserInputState == Enum.UserInputState.End then
			onInputEnded()
		end
	end
	
	local inputBeganConnection = DragFrame.InputBegan:Connect(function(input)
		if DragSystem.IsClickInput(input) and not dragging then
			if DragSystem.IsMouseOverFrame(DragFrame, input.Position) then
				dragging = true
				dragInput = input
				dragStart = input.Position
				startPos = MainFrame.Position
				
				if CallbackTable and CallbackTable.OnDragStart then
					CallbackTable.OnDragStart()
				end
				
				if not connection then
					connection = input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							onInputEnded()
						end
					end)
				end
			end
		end
	end)
	
	local inputChangedConnection = DragFrame.InputChanged:Connect(function(input)
		if DragSystem.IsMoveInput(input) and dragging and input == dragInput then
			updatePosition(input)
		end
	end)
	
	local userInputChangedConnection = UserInputService.InputChanged:Connect(function(input)
		if DragSystem.IsMoveInput(input) and dragging and input == dragInput then
			updatePosition(input)
		end
	end)
	
	return function()
		inputBeganConnection:Disconnect()
		inputChangedConnection:Disconnect()
		userInputChangedConnection:Disconnect()
		if connection then
			connection:Disconnect()
		end
	end
end

function setCircleMode(frame, actionButton, changeBtn)
	frame.Size = UDim2.new(0, 44, 0, 44)
	frame.Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset, frame.Position.Y.Scale, frame.Position.Y.Offset)
	
	local mainCorner = frame:FindFirstChildOfClass("UICorner")
	if mainCorner then
		mainCorner.CornerRadius = UDim.new(1, 0)
	end
	
	actionButton.TextScaled = true
	actionButton.TextWrapped = true
	actionButton.TextSize = 19
	
	changeBtn.Text = "▢"
end

function setSquareMode(frame, actionButton, changeBtn)
	frame.Size = UDim2.new(0.15000000596046448, 0, 0.10000000149011612, 0)
	frame.Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset, frame.Position.Y.Scale, frame.Position.Y.Offset)
	
	local mainCorner = frame:FindFirstChildOfClass("UICorner")
	if mainCorner then
		mainCorner.CornerRadius = UDim.new(0, 15)
	end
	
	actionButton.TextScaled = false
	actionButton.TextWrapped = false
	actionButton.TextSize = 24
	
	changeBtn.Text = "○"
end

function createBaseButton(config)
	local ButtonFrame = Instance.new("Frame")
	ButtonFrame.Name = "FlagName"
	ButtonFrame.BackgroundColor3 = Color3.new(1, 1, 1)
	ButtonFrame.BackgroundTransparency = 0.699999988079071
	ButtonFrame.Position = UDim2.new(0, 0, 0, 0)
	ButtonFrame.Size = UDim2.new(0.15000000596046448, 0, 0.10000000149011612, 0)
	ButtonFrame.Visible = config.Visible or false
	ButtonFrame.Active = true
	ButtonFrame.Parent = LibBtnScreenGui
	
	local ButtonGradient = Instance.new("UIGradient")
	ButtonGradient.Name = "ButtonGradient"
	ButtonGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(0.027450980618596077, 0.16470588743686676, 0.32156863808631897)),
		ColorSequenceKeypoint.new(0.5, Color3.new(0.0470588244497776, 0.2980392277240753, 0.5568627715110779)),
		ColorSequenceKeypoint.new(1, Color3.new(0.08235294371843338, 0.3803921639919281, 0.7098039388656616))
	})
	ButtonGradient.Rotation = 182
	ButtonGradient.Parent = ButtonFrame
	
	local ButtonStroke = Instance.new("UIStroke")
	ButtonStroke.Name = "ButtonStroke"
	ButtonStroke.Color = Color3.new(1, 1, 1)
	ButtonStroke.Thickness = 2
	ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	ButtonStroke.Parent = ButtonFrame
	
	local ButtonStrokeGradient = Instance.new("UIGradient")
	ButtonStrokeGradient.Name = "ButtonStrokeGradient"
	ButtonStrokeGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(0.1568627506494522, 0.47058823704719543, 0.7843137383460999)),
		ColorSequenceKeypoint.new(1, Color3.new(0.03921568766236305, 0.1568627506494522, 0.3137255012989044))
	})
	ButtonStrokeGradient.Rotation = 218.5
	ButtonStrokeGradient.Parent = ButtonStroke
	
	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.Name = "ButtonCorner"
	ButtonCorner.CornerRadius = UDim.new(0, 15)
	ButtonCorner.Parent = ButtonFrame
	
	local ButtonAction = Instance.new("TextButton")
	ButtonAction.Name = "ActionButton"
	ButtonAction.BackgroundTransparency = 1
	ButtonAction.Size = UDim2.new(1, 0, 1, 0)
	ButtonAction.Text = config.Text or "ActionText"
	ButtonAction.TextColor3 = Color3.new(1, 1, 1)
	ButtonAction.TextSize = 24
	ButtonAction.Font = Enum.Font.SourceSansBold
	ButtonAction.Parent = ButtonFrame
	
	return ButtonFrame, ButtonAction
end

function safeCall(func, ...)
	local success, result = pcall(func, ...)
	if not success then
		warn("[DraconicBtn Error]: " .. tostring(result))
	end
	return result
end

function DraconicBtn:Button(config)
	local ButtonFrame, ButtonAction = createBaseButton(config)
	local ButtonChange = nil
	local ButtonMode = false
	
	ButtonFrame.Position = UDim2.new(
		tonumber(config.Position:match("([%d%.]+),")) or 0,
		tonumber(config.Position:match(",(%-?%d+),")) or 0,
		tonumber(config.Position:match(",(%d%.+),")) or 0,
		tonumber(config.Position:match(",(%-?%d+)$")) or 0
	)
	
	if config.UiScale then
		ButtonFrame.Size = UDim2.new(0.15000000596046448 * config.UiScale, 0, 0.10000000149011612 * config.UiScale, 0)
	end
	
	DragSystem.MakeDraggable(ButtonFrame, ButtonAction)
	
	ButtonChange = Instance.new("TextButton")
	ButtonChange.Name = "ChangeBtnType"
	ButtonChange.Size = UDim2.new(0, 28, 0, 28)
	ButtonChange.Position = UDim2.new(1, 6, 0.5, -14)
	ButtonChange.BackgroundColor3 = Color3.new(0.1568627506494522, 0.1568627506494522, 0.1568627506494522)
	ButtonChange.TextColor3 = Color3.new(1, 1, 1)
	ButtonChange.Text = "○"
	ButtonChange.Visible = false
	ButtonChange.Parent = ButtonFrame
	
	local ButtonChangeCorner = Instance.new("UICorner")
	ButtonChangeCorner.Name = "ChangeBtnCorner"
	ButtonChangeCorner.CornerRadius = UDim.new(1, 0)
	ButtonChangeCorner.Parent = ButtonChange
	
	local ButtonData = {
		Frame = ButtonFrame,
		Action = ButtonAction,
		Change = ButtonChange,
		Mode = ButtonMode,
		Type = "Button",
		Text = config.Text or "ActionText",
		Callback = config.Callback,
		ChangeCallback = config.ChangeCallback,
		Scale = config.UiScale or 1
	}
	
	ButtonAction.MouseButton1Click:Connect(function()
		if not clickCancelled and not holdActive then
			if ButtonData.Callback then
				safeCall(ButtonData.Callback)
			end
		end
		clickCancelled = false
	end)
	
	ButtonAction.MouseButton1Down:Connect(function()
		activeButton = ButtonFrame
		holdTime = tick()
		holdActive = false
		clickCancelled = false
	end)
	
	ButtonAction.MouseButton1Up:Connect(function()
		if activeButton == ButtonFrame then
			if not holdActive then
				activeButton = nil
			end
			holdActive = false
		end
	end)
	
	ButtonAction.MouseLeave:Connect(function()
		if activeButton == ButtonFrame and not holdActive then
			activeButton = nil
			holdTime = 0
		end
	end)
	
	ButtonChange.MouseButton1Click:Connect(function()
		ButtonData.Mode = not ButtonData.Mode
		if ButtonData.Mode then
			setCircleMode(ButtonFrame, ButtonAction, ButtonChange)
		else
			setSquareMode(ButtonFrame, ButtonAction, ButtonChange)
		end
		if ButtonData.ChangeCallback then
			safeCall(ButtonData.ChangeCallback, ButtonData.Mode)
		end
		ButtonChange.Visible = false
		activeButton = nil
		holdActive = false
	end)
	
	table.insert(buttons, ButtonFrame)
	
	local FlagName = {}
	FlagName.Frame = ButtonFrame
	FlagName.Action = ButtonAction
	FlagName.Change = ButtonChange
	FlagName.Data = ButtonData
	
	function FlagName:TitelSet(newText)
		if type(newText) ~= "string" then
			error("DraconicBtn Error: TitelSet expects a string, got " .. type(newText))
		end
		ButtonData.Text = newText
		ButtonAction.Text = newText
	end
	
	function FlagName:VisibleSet(isVisible)
		if type(isVisible) ~= "boolean" then
			error("DraconicBtn Error: VisibleSet expects a boolean, got " .. type(isVisible))
		end
		ButtonFrame.Visible = isVisible
	end
	
	function FlagName:PositionSet(xScale, xOffset, yScale, yOffset)
		if type(xScale) ~= "number" then error("DraconicBtn Error: PositionSet xScale must be a number") end
		if type(xOffset) ~= "number" then error("DraconicBtn Error: PositionSet xOffset must be a number") end
		if type(yScale) ~= "number" then error("DraconicBtn Error: PositionSet yScale must be a number") end
		if type(yOffset) ~= "number" then error("DraconicBtn Error: PositionSet yOffset must be a number") end
		ButtonFrame.Position = UDim2.new(xScale, xOffset, yScale, yOffset)
	end
	
	function FlagName:UIScaleSet(newScale)
		if type(newScale) ~= "number" then
			error("DraconicBtn Error: UIScaleSet expects a number, got " .. type(newScale))
		end
		ButtonData.Scale = newScale
		if ButtonData.Mode then
			ButtonFrame.Size = UDim2.new(0, 44 * newScale, 0, 44 * newScale)
		else
			ButtonFrame.Size = UDim2.new(0.15000000596046448 * newScale, 0, 0.10000000149011612 * newScale, 0)
		end
	end
	
	function FlagName:ValueSet(...)
		error("DraconicBtn Error: ValueSet is not available for Button type. Use Toggle instead.")
	end
	
	function FlagName:GetValue()
		error("DraconicBtn Error: GetValue is not available for Button type. Use Toggle instead.")
	end
	
	function FlagName:GetPosition()
		return ButtonFrame.Position
	end
	
	function FlagName:GetVisible()
		return ButtonFrame.Visible
	end
	
	function FlagName:GetText()
		return ButtonData.Text
	end
	
	function FlagName:Destroy()
		ButtonFrame:Destroy()
		for i, btn in ipairs(buttons) do
			if btn == ButtonFrame then
				table.remove(buttons, i)
				break
			end
		end
		if getgenv().DraconicBtn and getgenv().DraconicBtn[config.Name] then
			getgenv().DraconicBtn[config.Name] = nil
		end
	end
	
	if not getgenv().DraconicBtn then
		getgenv().DraconicBtn = {}
	end
	getgenv().DraconicBtn[config.Name or "FlagName"] = FlagName
	
	return FlagName
end

function DraconicBtn:Toggle(config)
	local ButtonFrame, ButtonAction = createBaseButton(config)
	local ButtonChange = nil
	local ButtonMode = false
	
	ButtonFrame.Position = UDim2.new(
		tonumber(config.Position:match("([%d%.]+),")) or 0,
		tonumber(config.Position:match(",(%-?%d+),")) or 0,
		tonumber(config.Position:match(",(%d%.+),")) or 0,
		tonumber(config.Position:match(",(%-?%d+)$")) or 0
	)
	
	if config.UiScale then
		ButtonFrame.Size = UDim2.new(0.15000000596046448 * config.UiScale, 0, 0.10000000149011612 * config.UiScale, 0)
	end
	
	DragSystem.MakeDraggable(ButtonFrame, ButtonAction)
	
	ButtonChange = Instance.new("TextButton")
	ButtonChange.Name = "ChangeBtnType"
	ButtonChange.Size = UDim2.new(0, 28, 0, 28)
	ButtonChange.Position = UDim2.new(1, 6, 0.5, -14)
	ButtonChange.BackgroundColor3 = Color3.new(0.1568627506494522, 0.1568627506494522, 0.1568627506494522)
	ButtonChange.TextColor3 = Color3.new(1, 1, 1)
	ButtonChange.Text = "○"
	ButtonChange.Visible = false
	ButtonChange.Parent = ButtonFrame
	
	local ButtonChangeCorner = Instance.new("UICorner")
	ButtonChangeCorner.Name = "ChangeBtnCorner"
	ButtonChangeCorner.CornerRadius = UDim.new(1, 0)
	ButtonChangeCorner.Parent = ButtonChange
	
	local ToggleValue = config.Value or false
	local ToggleMode = false
	
	if ToggleValue then
		ButtonAction.Text = config.Text .. " : On"
		ButtonFrame.BackgroundColor3 = Color3.new(0.1568627506494522, 0.47058823704719543, 0.7843137383460999)
	else
		ButtonAction.Text = config.Text .. " : Off"
		ButtonFrame.BackgroundColor3 = Color3.new(1, 1, 1)
	end
	
	local ButtonData = {
		Frame = ButtonFrame,
		Action = ButtonAction,
		Change = ButtonChange,
		Mode = ToggleMode,
		Type = "Toggle",
		Text = config.Text or "ActionText",
		Value = ToggleValue,
		Callback = config.Callback,
		ChangeCallback = config.ChangeCallback,
		Scale = config.UiScale or 1
	}
	
	ButtonAction.MouseButton1Click:Connect(function()
		if not clickCancelled and not holdActive then
			ButtonData.Value = not ButtonData.Value
			if ButtonData.Value then
				ButtonAction.Text = ButtonData.Text .. " : On"
				ButtonFrame.BackgroundColor3 = Color3.new(0.1568627506494522, 0.47058823704719543, 0.7843137383460999)
			else
				ButtonAction.Text = ButtonData.Text .. " : Off"
				ButtonFrame.BackgroundColor3 = Color3.new(1, 1, 1)
			end
			if ButtonData.Callback then
				safeCall(ButtonData.Callback, ButtonData.Value)
			end
		end
		clickCancelled = false
	end)
	
	ButtonAction.MouseButton1Down:Connect(function()
		activeButton = ButtonFrame
		holdTime = tick()
		holdActive = false
		clickCancelled = false
	end)
	
	ButtonAction.MouseButton1Up:Connect(function()
		if activeButton == ButtonFrame then
			if not holdActive then
				activeButton = nil
			end
			holdActive = false
		end
	end)
	
	ButtonAction.MouseLeave:Connect(function()
		if activeButton == ButtonFrame and not holdActive then
			activeButton = nil
			holdTime = 0
		end
	end)
	
	ButtonChange.MouseButton1Click:Connect(function()
		ButtonData.Mode = not ButtonData.Mode
		if ButtonData.Mode then
			setCircleMode(ButtonFrame, ButtonAction, ButtonChange)
		else
			setSquareMode(ButtonFrame, ButtonAction, ButtonChange)
			if ButtonData.Value then
				ButtonFrame.BackgroundColor3 = Color3.new(0.1568627506494522, 0.47058823704719543, 0.7843137383460999)
			else
				ButtonFrame.BackgroundColor3 = Color3.new(1, 1, 1)
			end
		end
		if ButtonData.ChangeCallback then
			safeCall(ButtonData.ChangeCallback, ButtonData.Mode)
		end
		ButtonChange.Visible = false
		activeButton = nil
		holdActive = false
	end)
	
	table.insert(buttons, ButtonFrame)
	
	local FlagName = {}
	FlagName.Frame = ButtonFrame
	FlagName.Action = ButtonAction
	FlagName.Change = ButtonChange
	FlagName.Data = ButtonData
	
	function FlagName:TitelSet(newText)
		if type(newText) ~= "string" then
			error("DraconicBtn Error: TitelSet expects a string, got " .. type(newText))
		end
		ButtonData.Text = newText
		if ButtonData.Value then
			ButtonAction.Text = newText .. " : On"
		else
			ButtonAction.Text = newText .. " : Off"
		end
	end
	
	function FlagName:ValueSet(newValue)
		if type(newValue) ~= "boolean" then
			error("DraconicBtn Error: ValueSet expects a boolean, got " .. type(newValue))
		end
		ButtonData.Value = newValue
		if newValue then
			ButtonAction.Text = ButtonData.Text .. " : On"
			ButtonFrame.BackgroundColor3 = Color3.new(0.1568627506494522, 0.47058823704719543, 0.7843137383460999)
		else
			ButtonAction.Text = ButtonData.Text .. " : Off"
			ButtonFrame.BackgroundColor3 = Color3.new(1, 1, 1)
		end
	end
	
	function FlagName:VisibleSet(isVisible)
		if type(isVisible) ~= "boolean" then
			error("DraconicBtn Error: VisibleSet expects a boolean, got " .. type(isVisible))
		end
		ButtonFrame.Visible = isVisible
	end
	
	function FlagName:PositionSet(xScale, xOffset, yScale, yOffset)
		if type(xScale) ~= "number" then error("DraconicBtn Error: PositionSet xScale must be a number") end
		if type(xOffset) ~= "number" then error("DraconicBtn Error: PositionSet xOffset must be a number") end
		if type(yScale) ~= "number" then error("DraconicBtn Error: PositionSet yScale must be a number") end
		if type(yOffset) ~= "number" then error("DraconicBtn Error: PositionSet yOffset must be a number") end
		ButtonFrame.Position = UDim2.new(xScale, xOffset, yScale, yOffset)
	end
	
	function FlagName:UIScaleSet(newScale)
		if type(newScale) ~= "number" then
			error("DraconicBtn Error: UIScaleSet expects a number, got " .. type(newScale))
		end
		ButtonData.Scale = newScale
		if ButtonData.Mode then
			ButtonFrame.Size = UDim2.new(0, 44 * newScale, 0, 44 * newScale)
		else
			ButtonFrame.Size = UDim2.new(0.15000000596046448 * newScale, 0, 0.10000000149011612 * newScale, 0)
		end
	end
	
	function FlagName:GetValue()
		return ButtonData.Value
	end
	
	function FlagName:GetPosition()
		return ButtonFrame.Position
	end
	
	function FlagName:GetVisible()
		return ButtonFrame.Visible
	end
	
	function FlagName:GetText()
		return ButtonData.Text
	end
	
	function FlagName:Destroy()
		ButtonFrame:Destroy()
		for i, btn in ipairs(buttons) do
			if btn == ButtonFrame then
				table.remove(buttons, i)
				break
			end
		end
		if getgenv().DraconicBtn and getgenv().DraconicBtn[config.Name] then
			getgenv().DraconicBtn[config.Name] = nil
		end
	end
	
	if not getgenv().DraconicBtn then
		getgenv().DraconicBtn = {}
	end
	getgenv().DraconicBtn[config.Name or "FlagName"] = FlagName
	
	return FlagName
end

RunService.Heartbeat:Connect(function()
	if activeButton and tick() - holdTime >= holdDuration then
		holdActive = true
		clickCancelled = true
		for _, btn in pairs(buttons) do
			if btn == activeButton then
				local changeBtn = btn:FindFirstChild("ChangeBtnType")
				if changeBtn then
					changeBtn.Visible = true
				end
			end
		end
	end
end)

UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local pos = UserInputService:GetMouseLocation()
		local objects = LibBtnScreenGui:GetGuiObjectsAtPosition(pos.X, pos.Y)
		local clickedOutside = true
		
		for _, obj in pairs(objects) do
			if obj:IsA("TextButton") or obj:IsA("Frame") then
				clickedOutside = false
				break
			end
		end
		
		if clickedOutside then
			for _, btn in pairs(buttons) do
				local changeBtn = btn:FindFirstChild("ChangeBtnType")
				if changeBtn then
					changeBtn.Visible = false
				end
			end
		end
	end
end)

getgenv().DraconicBtn = DraconicBtn
