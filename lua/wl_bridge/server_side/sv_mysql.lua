WoltLabCBridge = WoltLabCBridge or {}
WoltLabCBridge.GroupToRank = WoltLabCBridge.GroupToRank or {}
WoltLabCBridge.WoltLabGroups = WoltLabCBridge.WoltLabGroups or {}

require("mysqloo")

function WoltLabCBridge.GetMySQLData()

	if not (file.Exists( "wl_bridge/settings.txt", "DATA" )) then
	
		print("[WoltLab Bridge] Writting settings file")
		file.CreateDir( "wl_bridge" )

		WoltLabCBridge.Settings = {
			Host = "127.0.0.1",
			Port = 3306,
			Database = "",
			Username = "root",
			Password = "",
			GrouptoRank = {},
			Using = "WSC30_WCF",
			steamID64Field  = "steamID64",
			syncBans = 0
		}

		file.Write( "wl_bridge/settings.txt", util.TableToJSON( WoltLabCBridge.Settings, true ))

	else
	
		print("[WoltLab Bridge] Getting settings file")
		WoltLabCBridge.Settings = util.JSONToTable( file.Read( "wl_bridge/settings.txt", "DATA" ))
		WoltLabCBridge.BanSyncCheck()
		
	end
	
end


function WoltLabCBridge.SaveMySQLData()

	file.Write( "wl_bridge/settings.txt", util.TableToJSON( WoltLabCBridge.Settings, true ))
	
end

function WoltLabCBridge.ConnectToMySQLDatabase()
	
	require("mysqloo")
	WoltLabCBridge.DB = mysqloo.connect(WoltLabCBridge.Settings.Host, WoltLabCBridge.Settings.Username, WoltLabCBridge.Settings.Password, WoltLabCBridge.Settings.Database, WoltLabCBridge.Settings.Port)
	WoltLabCBridge.DB.onConnected = function() WoltLabCBridge.DefineSQL() print("Connected") end
	WoltLabCBridge.DB.onConnectionFailed = function() Msg("[WoltLab Bridge] Connection to database failed\n") end
	WoltLabCBridge.DB:connect()
	
end
--[[
	The SQL functions
]]
function WoltLabCBridge.DefineSQL()

	require("mysqloo")
	
	--Get the Group based on your Website group
	function WoltLabCBridge.GetGroup(ply)
	
		print("[WoltLab Bridge] Getting user group")
		
		local userID = nil
		local GetProfile = WoltLabCBridge.DB:query([[
			SELECT ]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].UserIDField..[[
			FROM ]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].UserTable..[[
			WHERE ]]..WoltLabCBridge.Settings.steamID64Field..[[=']]..ply:SteamID64()..[['
		]])
		
		
		
		GetProfile.onData = function(Q,D)
			
			userID = D.userID
			

			
			local GetGroupIDs = WoltLabCBridge.DB:query([[
				SELECT ]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].groupIDField..[[
				FROM ]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].UserToRankTable..[[
				WHERE ]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].UserIDField..[[=']]..userID..[['
			]])
			

			
			GetGroupIDs.onSuccess = function(Q,D2)
			
				local GroupIDs = D2
				local userGroups = 0
				
				for k,v in pairs(GroupIDs) do
				
					for k2,v2 in pairs(WoltLabCBridge.Settings.GrouptoRank) do
					
						if(tostring(v2.WebsiteGroup)==tostring(v.groupID))then
						
							WoltLabCBridge.GiveRank(ply,v2.InGameRank)
							userGroups = userGroups+1
							
						end
					end

				end
				
				if userGroups==0 then
				
					WoltLabCBridge.GiveRank(ply,"user")
					
				end
				
			end
			
			GetGroupIDs:start()
			
		end
		
		GetProfile:start()
	end

	--Get the ban data from the Website
	function WoltLabCBridge.GetBanList()
		
		WoltLabCBridge.BanList = WoltLabCBridge.BanList or {}
		
		local BanDataQ = WoltLabCBridge.DB:query([[	SELECT CONVERT(]]..WoltLabCBridge.Settings.steamID64Field..[[, CHAR(32)) as ]]..WoltLabCBridge.Settings.steamID64Field..[[ ,]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].BanReason..[[,]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].BanExpirationField..[[
													FROM ]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].UserTable..[[
													WHERE NOT ]]..WoltLabCBridge.Settings.steamID64Field..[[='' and ]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].IsBannedField..[[='1'
												]])
		
		
		BanDataQ.onSuccess = function(Q,D)
		
			
			WoltLabCBridge.BanList = D
			
		end
			
		BanDataQ.onError = function(Q,err,sql_s)
		
			print(err)
			
		end

		BanDataQ:start()
	end
	
	WoltLabCBridge.GetBanList()

	--Ban a Player on the Website
	function WoltLabCBridge.BanPlayer(SteamID64,reason,duration)

		local BanPlayerQ = WoltLabCBridge.DB:query([[
			UPDATE ]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].UserTable..[[
			SET ]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].IsBannedField..[[='1',
			]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].BanReason..[[=']]..WoltLabCBridge.DB:escape(reason)..[[',
			]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].BanExpirationField..[[=']]..(os.time()+duration)..[['
			WHERE ]]..WoltLabCBridge.Settings.steamID64Field..[[=']]..SteamID64..[['
		]])
		
		BanPlayerQ:start()
		
		WoltLabCBridge.GetBanList()
		
	end

	--Unban a Player on the Website
	function WoltLabCBridge.UnbanPlayer(SteamID64)
	
		local UnBanPlayerQ = WoltLabCBridge.DB:query([[
			UPDATE ]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].UserTable..[[
			SET ]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].IsBannedField..[[='0',
			]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].BanReason..[[='',
			]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].BanExpirationField..[[=''
			WHERE ]]..WoltLabCBridge.Settings.steamID64Field..[[=']]..SteamID64..[['
		]])
		
		UnBanPlayerQ:start()
		
		WoltLabCBridge.GetBanList()
		
	end
	
	--Gets the group of the player object
	function WoltLabCBridge.GetWebsiteGroups(ply)

		
		local groupTable = groupTable or {}
		local languageTable = languageTable or {}
		
		local WebsiteGroupsQ = WoltLabCBridge.DB:query([[
			SELECT ]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].groupIDField..[[,]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].groupNameField..[[
			FROM `]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].RankTable..[[`
		]])
		
		
		WebsiteGroupsQ.onSuccess = function(q,gtbl)
			
			groupTable = gtbl

			
			local LanguageTableQ = WoltLabCBridge.DB:query([[
				SELECT ]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].languageItemField..[[,
				]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].languageValueField..[[
				FROM ]]..WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].LanguageTable..[[
			]])
						
			LanguageTableQ.onSuccess = function(q,ltbl)
			
				languageTable = ltbl
				
				for k,v in pairs(groupTable) do
				
					if string.find( v[(WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].groupNameField)], "wcf")then
						
						for k2,v2 in pairs(languageTable) do
						
							if v[(WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].groupNameField)]==v2[(WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].languageItemField)] then
								
								v[(WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].groupNameField)] = v2[(WoltLabCBridge.WoltLabOptions[WoltLabCBridge.Settings.Using].languageValueField)]
							
							end
						end
					end
				end
				net.Start("wlb_GiveWLTable")
					net.WriteTable(groupTable)
				net.Send(ply)
			end
			
			LanguageTableQ:start()
			
		end
		
		
		WebsiteGroupsQ:start()
		
		return groupTable
	end
	
	--Gets ban table every 30 minutes (not modifiable)
	timer.Create( "GetBanTable", (60*30), 0, function()
	
		WoltLabCBridge.GetBanList()
		
	end )
	
end