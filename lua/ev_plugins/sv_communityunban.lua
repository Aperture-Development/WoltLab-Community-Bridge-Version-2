/*-------------------------------------------------------------------------------------------------------------------------
	Unban a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Community Unban"
PLUGIN.Description = "Community Unban a player."
PLUGIN.Author = "Aperture Hosting"
PLUGIN.ChatCommand = "comunban"
PLUGIN.Usage = "<steamid>"
PLUGIN.Privileges = { "community_unban" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "community_unban" ) ) then
		print(args[1])
		if ( args[1] ) then
			local uniqueID
			
			if ( args[1]:match( "^STEAM_%d:%d:%d+$" ) ) then
				WoltLabCBridge.UnbanPlayer(util.SteamIDTo64( args[1] ))
			else
				evolve:Notify( ply, evolve.colors.red, "Invalid SteamID!" )
			end
			
		else
			evolve:Notify( ply, evolve.colors.red, "You need to specify a SteamID!" )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )