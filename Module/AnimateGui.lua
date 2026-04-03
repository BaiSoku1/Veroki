local RunService = game:GetService("RunService")
local Animation = {}
local connections = {}

local function ClearAllAnimations()
    for _, c in ipairs(connections) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(connections)
end

function Animation.Apply(theme, rootObj, settings)
    ClearAllAnimations()
    
    if not theme or not rootObj or not getgenv().ShineEnabled or not theme.ShineEnabled or not theme.Shine then
        return
    end
    
    local ShineConfig = theme.Shine
    local Speed = (settings and settings.Speed) or ShineConfig.Speed or 0.5
    local RotationSpeed = (settings and settings.RotationSpeed) or ShineConfig.RotationSpeed or 25
    local ColorSequence = ShineConfig.ColorSequence
    
    for _, obj in ipairs(rootObj:GetDescendants()) do
        if obj:IsA("UIGradient") and obj.Name == "WindUIGradient" then
            local t = 0
            local conn
            conn = RunService.RenderStepped:Connect(function(dt)
                t = obj:GetAttribute("Shine_Time") or 0
                t += dt * Speed
                obj:SetAttribute("Shine_Time", t)
                
                obj.Rotation = (t * RotationSpeed) % 360
                
                if ColorSequence then
                    obj.Color = ColorSequence
                end
            end)
            table.insert(connections, conn)
        end
        
        if obj:IsA("UIStroke") and theme.StrokeShine then
            local fromColor = theme.StrokeDark or theme.Text or Color3.new(0.5, 0.5, 0.5)
            local shineColor = theme.Accent or Color3.new(1, 1, 1)
            
            local t = 0
            local conn
            conn = RunService.RenderStepped:Connect(function(dt)
                t = obj:GetAttribute("Shine_Time_Stroke") or 0
                t += dt * Speed
                obj:SetAttribute("Shine_Time_Stroke", t)
                
                local pulse = (math.sin(t) + 1) / 2
                obj.Color = fromColor:Lerp(shineColor, pulse)
            end)
            table.insert(connections, conn)
        end
    end
end

return Animation
