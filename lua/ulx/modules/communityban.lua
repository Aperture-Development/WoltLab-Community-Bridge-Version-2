
WoltLabCBridge = WoltLabCBridge or {}
WoltLabCBridge.ULX = WoltLabCBridge.ULX or {}

--[[
	Function to ban an steamID
]]
function WoltLabCBridge.ULX.banid( calling_ply, steamid, minutes, reason )
	steamid = steamid:upper()
	if not ULib.isValidSteamID( steamid ) then
		ULib.tsayError( calling_ply, "Invalid SteamID." )
		return
	end

	local name
	local plys = player.GetAll()
	for i=1, #plys do
		if plys[ i ]:SteamID() == steamid then
			name = plys[ i ]:Nick()
			break
		end
	end
	WoltLabCBridge.BanPlayer(util.SteamIDTo64( steamid ),reason,(minutes*60))
	
end

local WL_Bridge_BanID = ulx.command( "WoltLab Bridge", "ulx combanid", WoltLabCBridge.ULX.banid, "!cbanid" )
WL_Bridge_BanID:addParam{ type=ULib.cmds.StringArg, hint="SteamID" }
WL_Bridge_BanID:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 for perma", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
WL_Bridge_BanID:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
WL_Bridge_BanID:defaultAccess( ULib.ACCESS_SUPERADMIN )
WL_Bridge_BanID:help( "Community Bans given ID" )


--[[
	Function to ban an active playing Player
]]
function WoltLabCBridge.ULX.ban( calling_ply, target_ply, minutes, reason )
	if target_ply:IsBot() then
		ULib.tsayError( calling_ply, "You cannot ban a bot.", true )
		return
	end
	
	WoltLabCBridge.BanPlayer(target_ply:SteamID64(),reason,(minutes*60))
	
	target_ply:Kick([[
				WoltLab Community Bridge 
				------------------------ 
				Community Ban 
				 
				Staff SteamID: ]]..calling_ply:SteamID()..[[  
				Reason: ]]..reason..[[ 
				Unban Date: ]]..os.date( "%H:%M:%S - %d/%m/%Y" , ((minutes*60)+os.time()) )..[[ 
				Your SteamID: ]]..target_ply:SteamID()..[[
			]])
end

local WL_Bridge_Ban = ulx.command( "WoltLab Bridge", "ulx comban", WoltLabCBridge.ULX.ban, "!cban" )
WL_Bridge_Ban:addParam{ type=ULib.cmds.PlayerArg }
WL_Bridge_Ban:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 for perma", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
WL_Bridge_Ban:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
WL_Bridge_Ban:defaultAccess( ULib.ACCESS_SUPERADMIN )
WL_Bridge_Ban:help( "Community Bans target" )



--[[
	Function to Community unban a player
]]
function WoltLabCBridge.ULX.unban( calling_ply, steamid )
	steamid = steamid:upper()
	if not ULib.isValidSteamID( steamid ) then
		ULib.tsayError( calling_ply, "Invalid SteamID." )
		return
	end

	WoltLabCBridge.UnbanPlayer(util.SteamIDTo64( steamid ))
end

local WL_Bridge_Unban = ulx.command( "WoltLab Bridge", "ulx comunban", WoltLabCBridge.ULX.unban,"!cunban" )
WL_Bridge_Unban:addParam{ type=ULib.cmds.StringArg, hint="SteamID" }
WL_Bridge_Unban:defaultAccess( ULib.ACCESS_SUPERADMIN )
WL_Bridge_Unban:help( "Community Unbans SteamID." )