local PLUGIN = {}
PLUGIN.Title = "WoltLab Bridge Menu"
PLUGIN.Description = "Opens the WoltLab Bridge menu"
PLUGIN.Author = "Aperture Hosting"
PLUGIN.ChatCommand = "wlbmenu"
PLUGIN.Usage = "No Arguments"
PLUGIN.Privileges = { "wlb_menu" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "wlb_menu" ) ) then
		if ply:IsPlayer() then
			net.Start("wlb_OpenMenu")
				net.WriteTable(WoltLabCBridge.Settings)
			net.Send(ply)
		else
			print("[WoltLab Bridge] Sorry but you have no GUI where I could open the menu :)")
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )