/*
	©2019 Walrusking
	This was created by Walrusking[
		SteamID: STEAM_0:0:103519394
		Link to profile: http://steamcommunity.com/id/Walrusking_1/
	]
*/

AddCSLuaFile()
 
SWEP.PrintName = "Developer Tool"
SWEP.Author = "Walrusking"
SWEP.Instructions = "Left click: Add new point\nReload: Print all points to console\nRight Click: Create Bounding box"
SWEP.Category = "Other"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/v_Pistol.mdl"
SWEP.WorldModel = "models/weapons/w_Pistol.mdl"
SWEP.Base = "weapon_base"
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.Primary.Ammo = ""
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.DrawCrosshair = true

SWEP.Points = {}

SWEP.BoundingBox = {}
SWEP.BoundingBox.HitPos = nil
SWEP.BoundingBox.press = 0
SWEP.BoundingBox.pos = nil
SWEP.BoundingBox.pos2 = nil