/*
	©2019 Walrusking
	This was created by Walrusking[
		SteamID: STEAM_0:0:103519394
		Link to profile: http://steamcommunity.com/id/Walrusking_1/
	]
*/

util.AddNetworkString("wkdevtool-createbots")

net.Receive("wkdevtool-createbots", function( len, sender )
	local bots = net.ReadInt(8)
	for i=1,bots do
		print("Trying to spawn bot #"..i)
		RunConsoleCommand("bot")
	end
end)