WoltLabCBridge = WoltLabCBridge or {}


WoltLabCBridge.WoltLabOptions = {
	WSC30_WCF = {
		UserTable = "wcf1_user",
		UserToRankTable = "wcf1_user_to_group",
		RankTable = "wcf1_user_group",
		LanguageTable = "wcf1_language_item",
		languageItemField = "languageItem",
		languageValueField = "languageItemValue",
		groupIDField = "groupID",
		groupNameField = "groupName",
		UserIDField = "userID",
		IsBannedField = "banned",
		BanReason = "banReason",
		BanExpirationField = "banExpires"
	}
}



function WoltLabCBridge.PrintChat(Text)

	net.Start("WL_Bridge_ChatPrint")
		net.WriteString(Text)
	net.Broadcast()
	
end

function WoltLabCBridge.GiveRank(ply,rank)

	if evolve then
		if not ply:IsUserGroup( rank ) then
			ply:EV_SetRank( rank )
			WoltLabCBridge.PrintChat("Adding "..ply:Nick().." to group "..rank)
		end
	elseif ulx then
		if not ply:IsUserGroup( rank ) then
			ply:SetUserGroup( rank )
			WoltLabCBridge.PrintChat("Adding "..ply:Nick().." to group "..rank)
		end
	end
	
end



net.Receive( "wlb_send_settings", function( len, pl )
	WoltLabCBridge.Settings = net.ReadTable()
	WoltLabCBridge.SaveMySQLData()
	WoltLabCBridge.ConnectToMySQLDatabase()
	WoltLabCBridge.BanSyncCheck()
end )

net.Receive( "wlb_LoadWLgroups", function( len, pl )
	if evolve then
		if pl:EV_HasPrivilege( "wlb_menu" ) then
			WoltLabCBridge.GetWebsiteGroups(pl)
		end
	elseif ulx then
		if ULib.ucl.query(pl,"ulx wlbmenu"	) then
			WoltLabCBridge.GetWebsiteGroups(pl)
		end
	end
end )

net.Receive( "wlb_connect", function( len, pl )
	if evolve then
		if pl:EV_HasPrivilege( "wlb_menu" ) then
			WoltLabCBridge.ConnectToMySQLDatabase()
			print("Auth Success")
		else
			print("Auth Failed")
		end
	elseif ulx then
		if ULib.ucl.query(pl,"ulx wlbmenu"	) then
			WoltLabCBridge.ConnectToMySQLDatabase()
			print("Auth Success")
		else
			print("Auth Failed")
		end
	else
		print("No valid Admin mod found!")
	end
end )


util.AddNetworkString( "WL_Bridge_ChatPrint" )
util.AddNetworkString( "wlb_OpenMenu" )
util.AddNetworkString( "wlb_send_settings" )
util.AddNetworkString( "wlb_LoadWLgroups" )
util.AddNetworkString( "wlb_connect" )
util.AddNetworkString( "wlb_GiveWLTable" )