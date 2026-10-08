--[[ 
    ROBLOX AUTO STEAL SCRIPT
    Features: Auto Steal, Anti-Trap, Anti-Hit Guard, Safe Zone Teleport, Walk Speed
    Place this in StarterPlayer > StarterCharacterScripts or StarterPlayer > StarterPlayerScripts
]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ============ CONFIG ============
local WALK_SPEED = 25 -- Change walk speed
local SAFE_ZONE_POS = Vector3.new(0, 50, 0) -- Safe zone coordinate, adjust to your game
local AUTO_STEAL_ENABLED = true
local ANTI_HIT_GUARD = true
local ANTI_TRAP_ENABLED = true
local EGG_TELEPORT = true

-- ============ ANTI-HIT GUARD ============
local lastHitTime = 0
local hitCooldown = 0.5

if ANTI_HIT_GUARD then
    humanoid.Touched:Connect(function(hit)
        if hit.Parent ~= character then
            local timeSinceLastHit = tick() - lastHitTime
            if timeSinceLastHit > hitCooldown then
                -- Teleport away from hit
                rootPart.CFrame = rootPart.CFrame + Vector3.new(math.random(-10, 10), 5, math.random(-10, 10))
                lastHitTime = tick()
            end
        end
    end)
end

-- ============ WALK SPEED BOOST ============
humanoid.WalkSpeed = WALK_SPEED

-- ============ ANTI-TRAP (Detect falling and teleport) ============
local lastTrapTime = 0
local trapCooldown = 1

if ANTI_TRAP_ENABLED then
    game:GetService("RunService").Heartbeat:Connect(function()
        local humanoidState = humanoid:GetState()
        
        -- Check if falling or in danger
        if humanoidState == Enum.HumanoidStateType.Freefall or humanoidState == Enum.HumanoidStateType.Flying then
            local timeSinceLastTrap = tick() - lastTrapTime
            if timeSinceLastTrap > trapCooldown then
                -- Teleport to safe zone
                rootPart.CFrame = CFrame.new(SAFE_ZONE_POS)
                lastTrapTime = tick()
            end
        end
    end)
end

-- ============ AUTO STEAL ============
if AUTO_STEAL_ENABLED then
    game:GetService("RunService").Heartbeat:Connect(function()
        local workspace = game.Workspace
        
        -- Look for items to steal (adjust name based on your game)
        for _, item in pairs(workspace:GetChildren()) do
            if item:IsA("Model") or item:IsA("Part") then
                -- Check if item is an egg, gem, or treasure
                if string.match(item.Name:lower(), "egg") or 
                   string.match(item.Name:lower(), "gem") or
                   string.match(item.Name:lower(), "treasure") or
                   string.match(item.Name:lower(), "coin") then
                    
                    -- Check distance
                    local distance = (rootPart.Position - item.Position).Magnitude
                    if distance < 50 then
                        -- Auto teleport to item and grab it
                        rootPart.CFrame = item.CFrame + Vector3.new(0, 3, 0)
                        wait(0.1)
                        
                        -- Try to activate/touch the item
                        if item:FindFirstChild("TouchInterest") then
                            game:GetService("RunService").Heartbeat:Wait()
                        end
                    end
                end
            end
        end
    end)
end

-- ============ EGG TELEPORT TO SAFE ZONE ============
if EGG_TELEPORT then
    game:GetService("RunService").Heartbeat:Connect(function()
        local egg = game.Workspace:FindFirstChild("Egg") -- Change "Egg" to actual egg name in your game
        
        if egg then
            local distance = (rootPart.Position - egg.Position).Magnitude
            
            -- If near egg, automatically teleport to safe zone
            if distance < 20 then
                rootPart.CFrame = CFrame.new(SAFE_ZONE_POS)
                wait(0.5)
            end
        end
    end)
end

-- ============ GUI BUTTON FOR MANUAL SAFE ZONE TELEPORT ============
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoStealGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Safe Zone Button
local safeZoneBtn = Instance.new("TextButton")
safeZoneBtn.Name = "SafeZoneButton"
safeZoneBtn.Size = UDim2.new(0, 150, 0, 50)
safeZoneBtn.Position = UDim2.new(0.85, 0, 0.45, 0)
safeZoneBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
safeZoneBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
safeZoneBtn.Text = "SAFE ZONE"
safeZoneBtn.Font = Enum.Font.GothamBold
safeZoneBtn.TextSize = 16
safeZoneBtn.Parent = screenGui

safeZoneBtn.MouseButton1Click:Connect(function()
    rootPart.CFrame = CFrame.new(SAFE_ZONE_POS)
end)

-- Egg Teleport Button
local eggBtn = Instance.new("TextButton")
eggBtn.Name = "EggButton"
eggBtn.Size = UDim2.new(0, 150, 0, 50)
eggBtn.Position = UDim2.new(0.85, 0, 0.55, 0)
eggBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
eggBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
eggBtn.Text = "TELEPORT EGG"
eggBtn.Font = Enum.Font.GothamBold
eggBtn.TextSize = 16
eggBtn.Parent = screenGui

eggBtn.MouseButton1Click:Connect(function()
    local egg = game.Workspace:FindFirstChild("Egg")
    if egg then
        rootPart.CFrame = egg.CFrame + Vector3.new(0, 3, 0)
    end
end)

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0, 200, 0, 50)
statusLabel.Position = UDim2.new(0.85, 0, 0.35, 0)
statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.Text = "✓ Script Active\nSpeed: " .. WALK_SPEED
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Parent = screenGui

print("✓ Auto Steal Script Loaded!")
print("Walk Speed: " .. WALK_SPEED)
print("Safe Zone: " .. tostring(SAFE_ZONE_POS))
