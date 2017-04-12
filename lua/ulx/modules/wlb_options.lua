WoltLabCBridge = WoltLabCBridge or {}
WoltLabCBridge.ULX = WoltLabCBridge.ULX or {}

function WoltLabCBridge.ULX.OpenWLBMenu( calling_ply )
	

	if calling_ply:IsPlayer() then
		net.Start("wlb_OpenMenu")
			net.WriteTable(WoltLabCBridge.Settings)
		net.Send(calling_ply)
	else
		print("[WoltLab Bridge] Sorry but you have no GUI where I could open the menu :)")
	end
	
	
end

local WL_Bridge_OpenMenu = ulx.command( "WoltLab Bridge", "ulx wlbmenu", WoltLabCBridge.ULX.OpenWLBMenu, "!wlbmenu" )
WL_Bridge_OpenMenu:defaultAccess( ULib.ACCESS_SUPERADMIN )
WL_Bridge_OpenMenu:help( "Opens the WL bridge menu" )