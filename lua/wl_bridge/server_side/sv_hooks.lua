function WoltLabCBridge.BanSyncCheck()

	if WoltLabCBridge.Settings.syncBans==1 then
		--Hook to check if someone is banned
		hook.Add( "CheckPassword", "WLBridge_BanCheck", function(steamID64)
			
			--local variables to smplify things
			local banCount = 0
			local banTable = {}
			
			
			--Check for an entry in the ban table
			for k,v in pairs(WoltLabCBridge.BanList) do
				
				
				if v[WoltLabCBridge.Settings.steamID64Field]==steamID64 then
				
					banCount = banCount+1
					banTable.reason = v[WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].BanReason]
					
					if v[WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].BanExpirationField]=="0" then
					
						banTable.unbanDate = "Never"
					
					else
						
						banTable.unbanDate = os.date( "%H:%M:%S - %d/%m/%Y" , tonumber(v[WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].BanExpirationField])) 
						
					end
				end
			end
			
			--Check if the banCount is higher or equal to 1
			if banCount>=1 then
			
				return false ,[[
								WoltLab Community Bridge
								------------------------
								Community Ban
								
								Reason: ]]..banTable.reason..[[ 
								Expires: ]]..banTable.unbanDate..[[
								]]
			else
			
				return nil
				
			end
		end)
	elseif WoltLabCBridge.Settings.syncBans==0 then
	
		hook.Remove("CheckPassword", "WLBridge_BanCheck")
		
	end
end

--Check on spawn for the players group
hook.Add( "PlayerInitialSpawn", "WLBridge_GroupCheck", function(ply)

	WoltLabCBridge.GetGroup(ply)
	
end )

--the script init
hook.Add( "Initialize", "WoltLabBridge_Init", function() 

	WoltLabCBridge.GetMySQLData()
	WoltLabCBridge.ConnectToMySQLDatabase()
	WoltLabCBridge.BanSyncCheck()
	
end )
