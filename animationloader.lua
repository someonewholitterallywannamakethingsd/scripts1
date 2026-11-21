-- ANIMATION LOADER (ANY RIG WHATSOEVER)
-- thx gemini i dont really wanna code this for 3485798723486729346 years

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ANIMATION LOADER LOADED",
        Text = "yeah lets go",
        Duration = 10
    })
end)

print("HELL YEAHHHHHHHH WE ARE IN")
-- [[ to load your keyframes, do getgenv().loadanim(yourassetidhere, youranimationnamehere)
and to play your animations, do
local yourloadedanimnamehere = getgenv().loadanim(yourassetidhere, youranimationnamehere)
getgenv().playanim(yourrighere, yourloadedanimnamehere, false) 

set it to true if you need to loop it. good luck mate
]]

local runs = game:GetService("RunService")
local currentTrack = nil
local currentAnimData = nil
local rigmap = getgenv().rigmap

getgenv().loadanim = function(assetId, animName)
    local success, result = pcall(function()
        return game:GetObjects("rbxassetid://" .. assetId)
    end)
    
    if not success or not result or not result[1] then
        warn("Loader: Failed to fetch asset ID:", assetId)
        return nil
    end
    
    local root = result[1]
    local animSavesObj = root:FindFirstChild("AnimSaves", true)
    local container = root
    if animSavesObj then
        if animSavesObj:IsA("ObjectValue") and animSavesObj.Value then
            container = animSavesObj.Value
        elseif animSavesObj:IsA("Folder") or animSavesObj:IsA("Model") then
            container = animSavesObj
        elseif animSavesObj:IsA("KeyframeSequence") then
            container = animSavesObj.Parent
        else
            container = animSavesObj
        end
    end
    local keyframeSeq = container:FindFirstChild(animName, true) or root:FindFirstChild(animName, true)
    if keyframeSeq and keyframeSeq:IsA("ObjectValue") then
        keyframeSeq = keyframeSeq.Value
    end
    
    if not keyframeSeq or not keyframeSeq:IsA("KeyframeSequence") then
        warn("Loader: Could not find valid KeyframeSequence for:", animName)
        return nil
    end
    local keyframes = {}
    local maxDuration = 0
    
    local function scanForFrames(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("Keyframe") then
                local poses = {}
                
                local function extractPoses(poseNode)
                    for _, pChild in ipairs(poseNode:GetChildren()) do
                        if pChild:IsA("Pose") then
                            poses[pChild.Name] = {
                                CFrame = pChild.CFrame,
                                Weight = pChild.Weight
                            }
                            extractPoses(pChild)
                        end
                    end
                end
                
                extractPoses(child)
                
                table.insert(keyframes, {
                    Time = child.Time,
                    Poses = poses
                })
                
                if child.Time > maxDuration then
                    maxDuration = child.Time
                end
            else
                scanForFrames(child)
            end
        end
    end
    
    scanForFrames(keyframeSeq)
    
    if #keyframes == 0 then
        warn("Loader: KeyframeSequence '" .. animName .. "' had 0 keyframes!")
        return nil
    end
    
    table.sort(keyframes, function(a, b) return a.Time < b.Time end)
    if maxDuration <= 0 then
        maxDuration = keyframes[#keyframes].Time
    end
    
    return {
        Keyframes = keyframes,
        Duration = maxDuration
    }
end

local function applyUniversalPoses(rig, poses, alpha)
    local map = getgenv().rigmap
    if not map then
        warn("SHIT. rigmap's nil. check if you defined it AFTER the loadstring.")
        return
    end
    for poseName, poseData in pairs(poses) do
        local motorName = map[poseName]
        if motorName then
            local motor = rig:FindFirstChild(motorName, true)
            if motor and motor:IsA("Motor6D") then
                local targetCFrame = poseData.CFrame
                if poseName == "Torso" then
                    local _, _, _, xx, xy, xz, yx, yy, yz, zx, zy, zz = targetCFrame:GetComponents()
                    targetCFrame = CFrame.new(0, 0, 0, xx, xy, xz, yx, yy, yz, zx, zy, zz)
                end

                motor.Transform = targetCFrame
            end
        end
    end
end

getgenv().playanim = function(rig, animData, isLooped)
    if not animData or not animData.Keyframes then
        return
    end
    if currentTrack then
        currentTrack:Disconnect()
        currentTrack = nil
        currentAnimData = nil
    end
    
    currentAnimData = animData
    local startTime = tick()
    local keyframes = animData.Keyframes
    local totalDuration = animData.Duration
    
    currentTrack = runs.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        
        if elapsed >= totalDuration then
            if isLooped then
                startTime = tick()
                elapsed = 0
            else
                currentTrack:Disconnect()
                currentTrack = nil
                currentAnimData = nil
                return
            end
        end
        
        local prevKey, nextKey
        for i = 1, #keyframes - 1 do
            if elapsed >= keyframes[i].Time and elapsed <= keyframes[i+1].Time then
                prevKey = keyframes[i]
                nextKey = keyframes[i+1]
                break
            end
        end
        if not prevKey and #keyframes > 0 then
            prevKey = keyframes[#keyframes]
            nextKey = keyframes[1]
        end
        if prevKey and nextKey then
            local timeRange = nextKey.Time - prevKey.Time
            local alpha = timeRange > 0 and math.clamp((elapsed - prevKey.Time) / timeRange, 0, 1) or 1
            applyUniversalPoses(rig, nextKey.Poses, alpha)
        end
    end)
end