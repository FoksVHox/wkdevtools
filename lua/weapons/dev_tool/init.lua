/*
	©2019 Walrusking
	This was created by Walrusking[
		SteamID: STEAM_0:0:103519394
		Link to profile: http://steamcommunity.com/id/Walrusking_1/
	]
*/

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("wkdevtool-printpoints")
util.AddNetworkString("wkdevtool-boundingbox")
util.AddNetworkString("wkdevtool-nicepos")

function SWEP:AddPos()
	local tr = self.Owner:GetEyeTrace()
	local pos = tr.HitPos
	local newpos = ents.Create("prop_physics")
	newpos:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	newpos:SetRenderMode(RENDERMODE_NONE)
	newpos:DrawShadow(false)
	newpos:SetCollisionGroup(COLLISION_GROUP_WORLD)
	newpos:SetPos(pos)
	newpos:Spawn()
	newpos:SetNWBool("wkdevtool_point",true)
	undo.Create( "devtool_recent_point" )
		undo.AddEntity( newpos )
		undo.SetPlayer( self.Owner )
		undo.AddFunction(function()
			if table.HasValue(self.Points, newpos) then
				table.remove(self.Points)
			end
		end)
	undo.Finish()
	local phys = newpos:GetPhysicsObject()
	phys:EnableMotion(false)
	table.insert(self.Points, newpos)
end

function SWEP:Reload()
	if self.Owner:KeyPressed(IN_RELOAD) then
		if IsFirstTimePredicted() then
			if table.IsEmpty(self.Points) then return end
			net.Start("wkdevtool-printpoints")
				net.WriteTable(self.Points)
			net.Send(self.Owner)
		end
	end
end

function SWEP:PrimaryAttack()
	self:AddPos()
	return true
end

function SWEP:SecondaryAttack()
	if self.Owner:KeyPressed(IN_ATTACK2) then
		if IsFirstTimePredicted() then
			self.BoundingBox.HitPos = self.Owner:GetEyeTrace().HitPos
			net.Start("wkdevtool-boundingbox")
				net.WriteTable(self.BoundingBox)
			net.Send(self.Owner)
		end
	end
end

net.Receive("wkdevtool-boundingbox", function(len,sender)
	local newtable = net.ReadTable()

	newtable.Owner:GetActiveWeapon().BoundingBox = newtable
end)

function SWEP:Deploy()
	self:SetHoldType( "normal" )
	self.BoundingBox.Owner = self.Owner
    return true
end

function SWEP:Holster()
    return true
end