-- MAP BUILDING.
loadstring(game:HttpGet("https://raw.githubusercontent.com/someonewholitterallywannamakethingsd/scripts1/refs/heads/main/warioapparitionmapbuild.lua"))()

-- wario time
repeat task.wait() until getgenv().triggerpart and getgenv().wario
local trigger = getgenv().triggerpart
local wario = getgenv().wario
local mesh = wario.Mesh
local lockpart = getgenv().lockpart
local wariohealth = 40 -- you have to stomp him 40 times.
local bitedamage = 20
local attackCooldown = false
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local stompoffset = 5
local isStomping = false
lp.CharacterAdded:Connect(function(newCharacter)
    isStomping = false
	attackCooldown = false
end)
if not isfile("youwantfun.mp3") then 
	writefile("youwantfun.mp3",game:HttpGet("https://github.com/someonewholitterallywannamakethingsd/scripts1/raw/refs/heads/main/NewSounds/Wario/youwantfun.mp3"))
end
if not isfile("laughing.mp3") then 
	writefile("laughing.mp3",game:HttpGet("https://github.com/someonewholitterallywannamakethingsd/scripts1/raw/refs/heads/main/NewSounds/Wario/laughing.mp3"))
end

if not isfile("waaa.wav") then 
	writefile("waaa.wav",game:HttpGet("https://github.com/someonewholitterallywannamakethingsd/scripts1/raw/refs/heads/main/NewSounds/Wario/waaa.wav"))
end

if not isfile("wayaya.wav") then 
	writefile("wayaya.wav",game:HttpGet("https://github.com/someonewholitterallywannamakethingsd/scripts1/raw/refs/heads/main/NewSounds/Wario/wayaya.wav"))
end

if not isfile("warioboom.wav") then 
	writefile("warioboom.wav",game:HttpGet("https://github.com/someonewholitterallywannamakethingsd/scripts1/raw/refs/heads/main/NewSounds/Wario/warioboom.wav"))
end

if not isfile("wariodie.wav") then 
	writefile("wariodie.wav",game:HttpGet("https://github.com/someonewholitterallywannamakethingsd/scripts1/raw/refs/heads/main/NewSounds/Wario/wariodie.wav"))
end

if not isfile("wariohit.wav") then 
	writefile("wariohit.wav",game:HttpGet("https://github.com/someonewholitterallywannamakethingsd/scripts1/raw/refs/heads/main/NewSounds/Wario/wariohit.wav"))
end

if not isfile("wariodevour.mp3") then 
	writefile("wariodevour.mp3",game:HttpGet("https://github.com/someonewholitterallywannamakethingsd/scripts1/raw/refs/heads/main/NewSounds/Wario/wariodevour.mp3"))
end

if not isfile("wariomusic.mp3") then 
	writefile("wariomusic.mp3",game:HttpGet("https://github.com/someonewholitterallywannamakethingsd/scripts1/raw/refs/heads/main/NewSounds/Wario/wariomusic.mp3"))
end

local laugh = getcustomasset("laughing.mp3")
local youwantfun = getcustomasset("youwantfun.mp3")
local waaa1 = getcustomasset("waaa.wav")
local wayaya1 = getcustomasset("wayaya.wav")
local warioboom1 = getcustomasset("warioboom.wav")
local wariohit1 = getcustomasset("wariohit.wav")
local wariodie1 = getcustomasset("wariodie.wav")
local wariodevour1 = getcustomasset("wariodevour.mp3")
local wariomusic1 = getcustomasset("wariomusic.mp3")

local rng = Random.new()
local waha = Instance.new("Sound")
waha.Volume = 5
waha.SoundId = laugh
waha.Parent = wario
local fun = Instance.new("Sound")
fun.Volume = 5
fun.SoundId = youwantfun
fun.Parent = wario
local waaa = Instance.new("Sound")
waaa.Volume = 5
waaa.SoundId = waaa1
waaa.Parent = wario
local wayaya = Instance.new("Sound")
wayaya.Volume = 5
wayaya.SoundId = wayaya1
wayaya.Parent = wario
local wariohit = Instance.new("Sound")
wariohit.Volume = 5
wariohit.SoundId = wariohit1
wariohit.Parent = workspace
local warioboom = Instance.new("Sound")
warioboom.Volume = 5
warioboom.SoundId = warioboom1
warioboom.Parent = workspace
local wariodie = Instance.new("Sound")
wariodie.Volume = 5
wariodie.SoundId = wariodie1
wariodie.Parent = wario
local wariodevour = Instance.new("Sound")
wariodevour.Volume = 5
wariodevour.SoundId = wariodevour1
wariodevour.Parent = wario
local wariomusic = Instance.new("Sound")
wariomusic.Volume = 3
wariomusic.SoundId = wariomusic1
wariomusic.Looped = true
wariomusic.Parent = workspace
local RunService = game:GetService("RunService")
local radius = 10
local speed = 20
local dist = (rp.Position - trigger.Position).Magnitude

local TweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(
    2,
    Enum.EasingStyle.Linear,
    Enum.EasingDirection.Out
)

local alpha = { Transparency = 0 }

local appear = TweenService:Create(wario, tweenInfo, alpha)

local function getMarioPosition()
	local player = game:GetService("Players").LocalPlayer
	if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		return player.Character.HumanoidRootPart.Position
	end
	return nil
end


if trigger and getgenv().SM64Teleport then
	getgenv().SM64Teleport(trigger)
elseif not getgenv().SM64Teleport then
	rp.CFrame = trigger.CFrame + Vector3.new(0, 3, 0)
	-- fallback so that if you didnt run the mario script, then your character will still teleport there
end
local connection
connection = RunService.Heartbeat:Connect(function()
	if rp and trigger then
		local dist = (rp.Position - trigger.Position).Magnitude
		if dist <= radius then
			connection:Disconnect()
			task.wait(2)
			appear:Play()
			appear.Completed:Wait()
			task.delay(1, function()
				if fun then fun:Play() end
			end)
			fun.Ended:Wait()
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "NOT MY SONG! SONG CREDITS:",
				Duration = 10,
				Text = 'Title: "The Wario Apparition (NO VOICE) - Super Mario 64 Soundtrack" Artist: Planet Bobstar', 
			})
			local chaseConnection

			chaseConnection = RunService.RenderStepped:Connect(function(dt)
				if not wario or not wario.Parent then
					chaseConnection:Disconnect()
					return
				end

				local targetPos = getMarioPosition()
				if targetPos then
					local currentPos = wario.Position
					local fixedY = 8
					local newPos = currentPos:Lerp(Vector3.new(targetPos.X, fixedY, targetPos.Z), dt * 1.2)
					wario.Position = newPos
					turn = CFrame.lookAt(wario.Position, Vector3.new(targetPos.X, wario.Position.Y, targetPos.Z))
					wario.CFrame = wario.CFrame:Lerp(turn, dt * 2)
				end
			end)
		end
	end
end)


fun.Ended:Wait()
task.spawn(function()
    while wariohealth > 0 and wario and wario.Parent do
	task.wait(1)
	if wariohealth <= 0 then 
           	break 
       	end
	waha.PlaybackSpeed = rng:NextNumber(0.53, 0.85)
        waha:Play()
	waha.Ended:Wait()
	task.wait(1)
    end
end)

wariomusic:Play()

local function onStomp()
    if wariohealth <= 0 then return end
    wariohealth = wariohealth - 1
	waha:Stop()
	local chosenSound = (math.random(1, 2) == 1) and waaa or wayaya
	wariohit:Play()
	chosenSound:Play()
	mesh.Scale = Vector3.new(0.011, 0.08, 0.01)
	mesh.TextureId = "rbxassetid://126248232939259"
    	chosenSound.Ended:Wait()
	mesh.Scale = Vector3.new(0.011, 0.011, 0.01)
	mesh.TextureId = "rbxassetid://118164342267624"
    	if wariohealth <= 0 then
		if chaseConnection then
       		chaseConnection:Disconnect()
        	chaseConnection = nil
    	end
		if wariohealth <= 0 then
   			wariomusic:Stop()
		end
		mesh.Scale = Vector3.new(0.011, 0.011, 0.01)
		mesh.TextureId = "rbxassetid://126248232939259"
        	task.spawn(function()
			wario.CanCollide = false
			wario.CanTouch = false
        	    	local spinTime = 5
            		local startTime = tick()
            		wariodie:Play()

			local deathCFrame = wario.CFrame

			while tick() - startTime < spinTime do
            		deathCFrame = deathCFrame * CFrame.Angles(0, math.rad(45), 0)
            		wario.CFrame = deathCFrame
            		task.wait()
        		end
			warioboom:Play()
			wario.Anchored = false
            		task.wait(3)
            		if wario and wario.Parent then
                		wario:Destroy()
				lockpart.CanCollide = false
				lockpart.CanTouch = false
				lockpart.Anchored = false
            		end
        	end)
	end
end

wario.Touched:Connect(function(hit)
	if wariohealth <= 0 then return end

	local char = hit.Parent
	if not char then return end
	local hitPlayer = Players:GetPlayerFromCharacter(char)
	if not hitPlayer then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local rp = char:FindFirstChild("HumanoidRootPart")
	if not hum or hum.Health <= 0 or not rp then return end
	local warioTopY = wario.Position.Y + (wario.Size.Y / 2)
	local playerFeetY = rp.Position.Y - 7
	local isAboveHat = playerFeetY >= (warioTopY - 1.5)-
	if isAboveHat then
		if isStomping then return end
		isStomping = true
		rp.AssemblyLinearVelocity = Vector3.new(rp.AssemblyLinearVelocity.X, 35, rp.AssemblyLinearVelocity.Z)

		onStomp()

		task.wait(0.8)
		if wariohealth > 0 then
			isStomping = false
		end

	else
		if attackCooldown or isStomping then return end

		local toPlayer = (rp.Position - wario.Position).Unit
		local isFacingPlayer = wario.CFrame.LookVector:Dot(toPlayer) > 0.2

		if isFacingPlayer then
			attackCooldown = true
			hum.Health = hum.Health - bitedamage

			if waha then waha:Play() end
			local knockbackDir = -wario.CFrame.LookVector
			rp.AssemblyLinearVelocity = Vector3.new(knockbackDir.X * 45, 15, knockbackDir.Z * 45)

			task.wait(1)
			attackCooldown = false
		end
	end
end)

local function applyMovementStats(char)
	local hum = char:WaitForChild("Humanoid")
	hum.WalkSpeed = 37
	hum.JumpPower = 50
	workspace.Gravity = 120
end

if lp.Character then
	applyMovementStats(lp.Character)
end

lp.CharacterAdded:Connect(function(newChar)
	applyMovementStats(newChar)
end)