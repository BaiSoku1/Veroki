# DraconicBtn Library Documentation

## Overview
DraconicBtn is a Roblox GUI library for creating stylish, draggable buttons with toggle functionality. Buttons have two shapes (square/rectangle and circle) and can be modified through a simple API.

## Features
- 🎨 **Two Button Types**: Standard buttons and toggle switches
- 🔄 **Shape Switching**: Hold button to reveal shape changer (○/▢)
- 🖱️ **Draggable**: All buttons can be dragged anywhere on screen
- 🎯 **Error Handling**: Clear error messages for invalid operations
- 📦 **Global Access**: Buttons accessible via `getgenv().DraconicBtn`

## Installation
```lua
-- Simply load the library script
local DraconicBtn = loadstring(game:HttpGet("https://your-host.com/DraconicBtn.lua"))()
```

## Quick Start
```lua
-- Create a button
local GravityBtn = DraconicBtn:Button({
    Name = "GravityFlag",
    Text = "Gravity",
    Position = "(0.425, -6, 0.45, -4)",
    UiScale = 1,
    Visible = true,
    Callback = function()
        print("Gravity toggled!")
    end
})

-- Create a toggle
local FlyBtn = DraconicBtn:Toggle({
    Name = "FlyFlag",
    Text = "Fly",
    Value = false,
    Position = "(0.425, -93, 0.45, 13)",
    UiScale = 1,
    Visible = true,
    Callback = function(state)
        print("Fly is:", state and "ON" or "OFF")
    end
})

-- Modify buttons using global access
getgenv().DraconicBtn.GravityFlag:TitelSet("Anti-Gravity")
getgenv().DraconicBtn.FlyFlag:ValueSet(true)
```

## API Reference

### Creating Buttons

#### `DraconicBtn:Button(config)`
Creates a standard push button.

| Parameter | Type | Description | Required |
|-----------|------|-------------|----------|
| Name | string | Unique identifier for global access | Yes |
| Text | string | Button label | Yes |
| Position | string | UDim2 values as "(xScale, xOffset, yScale, yOffset)" | Yes |
| UiScale | number | Size multiplier | No |
| Visible | boolean | Initial visibility | No |
| Callback | function | Called when button clicked | No |
| ChangeCallback | function | Called when shape changes | No |

**Returns**: Button object for method chaining

#### `DraconicBtn:Toggle(config)`
Creates a toggle switch button.

| Parameter | Type | Description | Required |
|-----------|------|-------------|----------|
| Name | string | Unique identifier for global access | Yes |
| Text | string | Button label | Yes |
| Value | boolean | Initial state (true = On, false = Off) | No |
| Position | string | UDim2 values as "(xScale, xOffset, yScale, yOffset)" | Yes |
| UiScale | number | Size multiplier | No |
| Visible | boolean | Initial visibility | No |
| Callback | function | Called when toggled (receives state) | No |
| ChangeCallback | function | Called when shape changes | No |

**Returns**: Toggle object for method chaining

### Common Methods (All Buttons)

#### `:TitelSet(newText)`
Changes the button's text.
```lua
getgenv().DraconicBtn.MyButton:TitelSet("New Text")
```

#### `:VisibleSet(isVisible)`
Shows or hides the button.
```lua
getgenv().DraconicBtn.MyButton:VisibleSet(false) -- Hide
```

#### `:PositionSet(xScale, xOffset, yScale, yOffset)`
Moves the button to a new position.
```lua
getgenv().DraconicBtn.MyButton:PositionSet(0.5, 0, 0.5, 0) -- Center
```

#### `:UIScaleSet(newScale)`
Resizes the button.
```lua
getgenv().DraconicBtn.MyButton:UIScaleSet(2) -- Double size
```

#### `:GetPosition()`
Returns the button's current UDim2 position.

#### `:GetVisible()`
Returns boolean indicating if button is visible.

#### `:GetText()`
Returns the button's current text.

#### `:Destroy()`
Removes the button completely.
```lua
getgenv().DraconicBtn.MyButton:Destroy()
```

### Toggle-Only Methods

#### `:ValueSet(newValue)`
Sets the toggle state (true = On, false = Off).
```lua
getgenv().DraconicBtn.MyToggle:ValueSet(true) -- Turn on
```

#### `:GetValue()`
Returns the current toggle state.

### Error Handling Examples

```lua
-- This will error (Button doesn't have ValueSet)
getgenv().DraconicBtn.MyButton:ValueSet(true) 
-- Error: "DraconicBtn Error: ValueSet is not available for Button type. Use Toggle instead."

-- This will error (wrong parameter type)
getgenv().DraconicBtn.MyToggle:VisibleSet("true")
-- Error: "DraconicBtn Error: VisibleSet expects a boolean, got string"
```

## Advanced Examples

### Multiple Buttons with Different Names
```lua
-- Create buttons with unique names
DraconicBtn:Button({
    Name = "GravityBtn",
    Text = "Gravity",
    Position = "(0.3, 0, 0.3, 0)",
    Callback = function() print("Gravity") end
})

DraconicBtn:Toggle({
    Name = "FlyToggle",
    Text = "Fly",
    Position = "(0.3, 0, 0.5, 0)",
    Callback = function(s) print("Fly:", s) end
})

-- Access them globally
getgenv().DraconicBtn.GravityBtn:TitelSet("Anti-Gravity")
getgenv().DraconicBtn.FlyToggle:ValueSet(true)
```

### Dynamic Button Management
```lua
-- Store references
local buttons = {}

for i = 1, 5 do
    local btn = DraconicBtn:Button({
        Name = "Btn" .. i,
        Text = "Button " .. i,
        Position = string.format("(0.1, %d, 0.1, %d)", i * 50, i * 50),
        Callback = function()
            print("Button", i, "clicked!")
        end
    })
    table.insert(buttons, btn)
end

-- Destroy all buttons after 10 seconds
task.wait(10)
for _, btn in pairs(buttons) do
    btn:Destroy()
end
```

## Notes
- Buttons are draggable by default
- Hold a button for 0.5 seconds to reveal the shape changer
- Clicking outside any button hides all shape changers
- All methods include type checking and descriptive error messages
- Buttons are stored in `getgenv().DraconicBtn` for global access

## Error Messages Reference

| Error | Cause |
|-------|-------|
| "ValueSet is not available for Button type" | Called ValueSet on a standard button |
| "GetValue is not available for Button type" | Called GetValue on a standard button |
| "TitelSet expects a string" | Passed non-string to TitelSet |
| "ValueSet expects a boolean" | Passed non-boolean to ValueSet |
| "VisibleSet expects a boolean" | Passed non-boolean to VisibleSet |
| "UIScaleSet expects a number" | Passed non-number to UIScaleSet |
| "PositionSet xScale must be a number" | Invalid coordinate type |

## License
Free to use and modify. Created for the Roblox community.
