/*
	©2019 Walrusking
	This was created by Walrusking[
		SteamID: STEAM_0:0:103519394
		Link to profile: http://steamcommunity.com/id/Walrusking_1/
	]
*/

include("shared.lua")

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

function SWEP:DoDrawCrosshair()
	surface.SetDrawColor(Color(255,255,255))
	draw.NoTexture()
	draw.Circle( ScrW() / 2, ScrH() / 2, 2, 100 )
	return true
end

net.Receive("wkdevtool-boundingbox", function(len,sender)
	local self = net.ReadTable()
	if self.press == 0 then
		surface.PlaySound("UI/buttonclick.wav")
		self.pos = self.HitPos
	elseif self.press == 1 then
		surface.PlaySound("UI/buttonclick.wav")
		self.pos2 = LocalPlayer():GetEyeTrace().HitPos
	elseif self.press >= 2 then
		surface.PlaySound("UI/buttonclickrelease.wav")
		print("[DEV TOOLS] { min = Vector("..math.Round(self.pos.x)..", "..math.Round(self.pos.y)..", "..math.Round(self.pos.z).."), max = Vector("..math.Round(self.pos2.x)..", "..math.Round(self.pos2.y)..", "..math.Round(self.pos2.z)..") }")
		self.pos = nil
		self.pos2 = nil
		self.press = -1
	end
	self.press = self.press + 1
	LocalPlayer():GetActiveWeapon().BoundingBox = self
	net.Start("wkdevtool-boundingbox")
		net.WriteTable(self)
	net.SendToServer()
end)

hook.Add( "HUDPaint", "WKDevTools-ToScreen", function()
	if !LocalPlayer():Alive() then return end
	if !LocalPlayer():HasWeapon("dev_tool") then return end
	local wep = LocalPlayer():GetActiveWeapon()
	if wep:GetClass() == "dev_tool" then
		if isvector(wep.BoundingBox.pos) then
			local pos = wep.BoundingBox.pos:ToScreen()
			draw.SimpleText(math.Round(wep.BoundingBox.pos.x)..", "..math.Round(wep.BoundingBox.pos.y)..", "..math.Round(wep.BoundingBox.pos.z), "Trebuchet24", pos.x, pos.y, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		if isvector(wep.BoundingBox.pos2) then
			local pos = wep.BoundingBox.pos2:ToScreen()
			draw.SimpleText(math.Round(wep.BoundingBox.pos2.x)..", "..math.Round(wep.BoundingBox.pos2.y)..", "..math.Round(wep.BoundingBox.pos2.z), "Trebuchet24", pos.x, pos.y, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		local num = 0
		for k,v in pairs(ents.GetAll()) do
			if v:GetClass() == "prop_physics" then
				if v:GetNWBool("wkdevtool_point") then
					local pos = v:GetPos():ToScreen()
					num = num + 1
					draw.SimpleText("Point: "..num, "Trebuchet24", pos.x, pos.y, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		end
	end
end)

hook.Add( "PreDrawTranslucentRenderables", "WKDevTools-wireframe", function()
	if !LocalPlayer():Alive() then return end
	if !LocalPlayer():HasWeapon("dev_tool") then return end
	local wep = LocalPlayer():GetActiveWeapon()
	if wep:GetClass() == "dev_tool" then
		if isvector(wep.BoundingBox.pos) then
			if isvector(wep.BoundingBox.pos2) then
				render.DrawWireframeBox(wep.BoundingBox.pos, Angle(0,0,0), Vector(0,0,0), WorldToLocal(wep.BoundingBox.pos2, Angle(0,0,0), wep.BoundingBox.pos, Angle(0,0,0)), Color(0, 255, 0))
				render.DrawWireframeSphere(wep.BoundingBox.pos2, 5, 25, 25, Color(255, 0, 0))
			else
				local tr = LocalPlayer():GetEyeTrace()
				render.DrawWireframeBox(wep.BoundingBox.pos, Angle(0,0,0), Vector(0,0,0), WorldToLocal(LocalPlayer():EyePos() + LocalPlayer():EyeAngles():Forward( ) * 50, Angle(0,0,0), wep.BoundingBox.pos, Angle(0,0,0)), Color(0, 255, 0))
			end
			render.DrawWireframeSphere(wep.BoundingBox.pos, 5, 25, 25, Color(0, 0, 255))
		end
	end
end )

hook.Add( "PreDrawHalos", "WKDevTools-SeePoints", function()
	if !LocalPlayer():Alive() then return end
	if !LocalPlayer():HasWeapon("dev_tool") then return end
	local wep = LocalPlayer():GetActiveWeapon()
	if !IsValid(wep) then return end
	if !wep:GetClass() == "dev_tool" then return end
	for k, v in pairs(ents.GetAll()) do
		if v:GetClass() == "prop_physics" then
			if v:GetNWBool("wkdevtool_point") then
				halo.Add({v}, Color( 0, 255, 0 ), 1, 1, 5, true, true)
			end
		end
	end
end )

net.Receive("wkdevtool-printpoints", function(len,sender)
	local table = net.ReadTable()
	surface.PlaySound("UI/buttonclickrelease.wav")
	print("[DEV TOOLS] {")
	for k,v in pairs(table) do
		if !IsValid(v) then table.Empty(table) print("}") return end
		local pos = v:GetPos()
		k = k - 1
		print("["..k.."] = { position = Vector("..math.Round(pos.x)..", "..math.Round(pos.y)..", "..math.Round(pos.z)..") },")
	end
	print("}")
end)

net.Receive("wkdevtool-nicepos", function(len,sender)
	local pos = LocalPlayer():GetPos()
	local ang = LocalPlayer():EyeAngles()
	print("[DEV TOOLS] { position = Vector("..math.Round(pos.x)..", "..math.Round(pos.y)..", "..math.Round(pos.z).."), angle = Angle("..math.Round(ang.x)..", "..math.Round(ang.y)..", "..math.Round(ang.z)..") }")
end)
