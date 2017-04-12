/*-------------------------------------------------------------------------------------------------------------------------
	Community Ban
	Inspired by Overv's ban plugin for evolve
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Community SteamID Ban"
PLUGIN.Description = "Community Bans a Player"
PLUGIN.Author = "Aperture Hosting"
PLUGIN.ChatCommand = "comidban"
PLUGIN.Usage = "<steamid|nick> <duration in minutes| 0 for Permanent ban> <reason>"
PLUGIN.Privileges = { "community_idban" }

function PLUGIN:Call( ply, args )

	if ( ply:EV_HasPrivilege( "community_ban" ) ) then
		if ( args[1] and args[2] ) then
			
			local target_ply
			
			--[[
				Get the Player
			]]
			if ( string.match( args[1], "STEAM_[0-5]:[0-9]:[0-9]+" ) ) then
				WoltLabCBridge.BanPlayer(util.SteamIDTo64( args[1] ),table.concat( args, " ", 3 ),tonumber(args[2])*60)
			end
			
		else
			evolve:Notify( ply, evolve.colors.red, "Not enough arguments!" )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
	
end

evolve:RegisterPlugin( PLUGIN )