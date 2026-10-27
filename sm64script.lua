--[[
SUPER PLATFORMER 64
ʀɑɪɴʙowɴooʙ¹²⁷, gildedcore¹²⁷©. 2025-2026
]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local character = LocalPlayer.Character
local humanoid = character:WaitForChild("Humanoid")

if humanoid.RigType ~= Enum.HumanoidRigType.R15 then
	game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "SUPER PLATFORMER 64: ERROR!!",
	Text = "Use R15 to make the magic work!", 
	})
end
local function load(char)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/someonewholitterallywannamakethingsd/scripts1/refs/heads/main/obfuscatedsm64movement.lua"))()
end

if character then
    load(character)
end

LocalPlayer.CharacterAdded:Connect(load)

local RunService = game:GetService("RunService")
local camera = game.Workspace.CurrentCamera

local CAMERA_DELAY = 0.1
local CAMERA_OFFSET = Vector3.new(0, 1, 0)

local currentRootPart = nil

local function updateCharacter(newChar)
	currentRootPart = newChar:WaitForChild("HumanoidRootPart", 5)
end

LocalPlayer.CharacterAdded:Connect(updateCharacter)

if LocalPlayer.Character then
	updateCharacter(character)
end

local previousPosition = Vector3.new()

RunService.RenderStepped:Connect(function(deltaTime)
	if not currentRootPart or not currentRootPart.Parent then return end
	if previousPosition == Vector3.new() then
		previousPosition = currentRootPart.Position
	end
	local currentPosition = currentRootPart.Position
	local targetPosition = currentPosition + CAMERA_OFFSET
	local newCameraPosition = previousPosition:Lerp(targetPosition, deltaTime / CAMERA_DELAY)
	local zoomLevel = (camera.CFrame.Position - camera.Focus.Position).Magnitude
	local cameraRotation = camera.CFrame - camera.CFrame.Position
	camera.CFrame = CFrame.new(newCameraPosition - cameraRotation.LookVector * zoomLevel) * cameraRotation
	previousPosition = newCameraPosition
end)


game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "SUPER PLATFORMER 64 LOADED",
	Text = "Credits to GildedCore127/AbsoluteManiac. no CurrentAngle used", 
})