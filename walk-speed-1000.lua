--[[ 
    ROBLOX WALK SPEED ADJUSTER - 1000
    Simple script to set walk speed to 1000
    Place this in StarterPlayer > StarterCharacterScripts
]]

local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")

-- Set walk speed to 1000
humanoid.WalkSpeed = 1000

print("✓ Walk Speed Set to 1000!")
