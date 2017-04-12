WoltLabCBridge = WoltLabCBridge or {}
WoltLabCBridge.Settings = WoltLabCBridge.Settings or {}
WoltLabCBridge.Settings.GrouptoRank = WoltLabCBridge.Settings.GrouptoRank or {}

function WoltLabCBridge.SaveSettings()
	net.Start("wlb_send_settings")
		net.WriteTable(WoltLabCBridge.Settings)
	net.SendToServer()
end

function WoltLabCBridge.TabletoDList(tbl,DList)
	for k,v in pairs(tbl) do
		DList:AddLine(v.WebsiteGroup,v.InGameRank)
	end
end

function WoltLabCBridge.WLTabletoDList(tbl,DList)
	for k,v in pairs(tbl) do
		DList:AddLine(v.GroupID,v.GroupName)
	end
end

net.Receive( "WL_Bridge_ChatPrint", function( len, pl )
	chat.AddText(Color(255,255,255,255),"[",Color( 58, 109, 156, 255 ),"WoltLab Bridge",Color(255,255,255,255),"] ",Color(255,191,0,255),net.ReadString())
end )

