/*-------------------------------------------------------------------------------------------------------------------------
	Community Ban
	Inspired by Overv's ban plugin for evolve
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Community Ban"
PLUGIN.Description = "Community Bans a Player"
PLUGIN.Author = "Aperture Hosting"
PLUGIN.ChatCommand = "comban"
PLUGIN.Usage = "<steamid|nick> <duration in minutes| 0 for Permanent ban> <reason>"
PLUGIN.Privileges = { "community_ban" }

function PLUGIN:Call( ply, args )

	if ( ply:EV_HasPrivilege( "community_ban" ) ) then
		if ( args[1] and args[2] ) then
			
			local target_ply
			
			--[[
				Get the Player
			]]
			if ( string.match( args[1], "STEAM_[0-5]:[0-9]:[0-9]+" ) ) then
				target_ply = player.GetBySteamID( args[1] )
			else
				target_ply = evolve:FindPlayer( args[1] )
				
				if(#target_ply>1)then
				
					evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( target_ply, true ), evolve.colors.white, "?" )
				
				elseif(#target_ply==1)then
				
					target_ply = target_ply[1]
					target_uid = target_ply:UniqueID()
					
				end
			end
			
			if target_player then
				--[[
					Check for Immunity. Inspired by Overv's ban plugin for evolve
				]]
				
				local plyImmunity = tonumber( evolve.ranks[ ply:EV_GetRank() ].Immunity )
				local vicImmunity = tonumber( evolve.ranks[ target_ply:EV_GetRank() ].Immunity )
				
				if ( !target_uid or vicImmunity > plyImmunity ) then
					evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers2 )
					return
				end
				--[[
					Ban Part
				]]
				local length = math.Clamp( tonumber( args[2] ) or 5, 0, 10080 ) * 60
				local reason = table.concat( args, " ", 3 )
					if ( #reason == 0 ) then reason = "No reason specified" end
				
				WoltLabCBridge.BanPlayer(target_ply:SteamID64(),reason,length)
				target_player:Kick([[ 
					WoltLab Community Bridge 
					------------------------ 
					Community Ban 
					 
					Staff SteamID: ]]..ply:SteamID()..[[  
					Reason: ]]..reason..[[ 
					Unban Date: ]]..os.date( "%H:%M:%S - %d/%m/%Y" , (lenght+os.time()) )..[[ 
					Your SteamID: ]]..target_ply:SteamID()..[[
				]])
				
				if ( length == 0 ) then
					evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " banned ", evolve.colors.red, target_ply:Nick(), evolve.colors.white, " permanently (" .. reason .. ")." )
				else
					evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " banned ", evolve.colors.red, target_ply:Nick(), evolve.colors.white, " for " .. length / 60 .. " minutes (" .. reason .. ")." )
				end
			else
				evolve:Notify( ply, evolve.colors.red, "Invalid Player!" )
			end
		else
			evolve:Notify( ply, evolve.colors.red, "Not enough arguments!" )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
	
end

evolve:RegisterPlugin( PLUGIN )