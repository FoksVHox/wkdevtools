/*
	©2019 Walrusking
	This was created by Walrusking[
		SteamID: STEAM_0:0:103519394
		Link to profile: http://steamcommunity.com/id/Walrusking_1/
	]
*/

concommand.Add( "nicepos", function( ply, cmd, args )
	if ply:IsPlayer() and ply:Alive() then
		local pos = ply:GetPos()
		local ang = ply:EyeAngles()
		print("[DEV TOOLS] { position = Vector("..math.Round(pos.x)..", "..math.Round(pos.y)..", "..math.Round(pos.z).."), angle = Angle("..math.Round(ang.x)..", "..math.Round(ang.y)..", "..math.Round(ang.z)..") }")
	else
		print("You need to be ingame to use this command.")
	end
end)

concommand.Add( "manybots", function( ply, cmd, args )
	local bots = args[1] or 5
	if ply:IsPlayer() and ply:IsSuperAdmin() then
		net.Start("wkdevtool-createbots")
			net.WriteInt(bots, 8)
		net.SendToServer()
	else
		for i=1,bots do
			print("Trying to spawn bot #"..i)
			RunConsoleCommand("bot")
		end
	end
end)