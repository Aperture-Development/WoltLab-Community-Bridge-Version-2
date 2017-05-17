--Clientside GUI
WoltLabBGUI = WoltLabBGUI or {}
WoltLabCBridge = WoltLabCBridge or {}
WoltLabCBridge.Settings = WoltLabCBridge.Settings or {}
WoltLabCBridge.Settings.GrouptoRank = WoltLabCBridge.Settings.GrouptoRank or {}

net.Receive( "wlb_GiveWLTable", function( len, pl )
	WoltLabCBridge.WoltLabTable = net.ReadTable()
	WoltLabBGUI.WebsiteRankTable:Clear()
	for k,v in pairs(WoltLabCBridge.WoltLabTable) do
		PrintTable(v)
		print(k)
		WoltLabBGUI.WebsiteRankTable:AddLine(v.groupID,v.groupName)
	end
end)

--VGUI

net.Receive( "wlb_OpenMenu", function( len, pl )
	WoltLabCBridge.Settings = net.ReadTable()
	
	

	WoltLabBGUI.Main = vgui.Create( "DFrame" )
	WoltLabBGUI.Main:SetSize( 500, 550 )
	WoltLabBGUI.Main:Center()
	WoltLabBGUI.Main:MakePopup()
	WoltLabBGUI.Main:SetTitle( "WoltLab Community Bridge Configuration" )
	WoltLabBGUI.Main.Paint = function()
		draw.RoundedBox( 8, 0, 0, WoltLabBGUI.Main:GetWide(), WoltLabBGUI.Main:GetTall(), Color( 58, 109, 156, 255 ) ) 
	end

	WoltLabBGUI.HostIP = vgui.Create( "DLabel", WoltLabBGUI.Main )
	WoltLabBGUI.HostIP:SetPos( 40, 50 )
	WoltLabBGUI.HostIP:SetText( "HostIP:" )
	
	WoltLabBGUI.HostIPInput = vgui.Create( "DTextEntry", WoltLabBGUI.Main ) -- create the form as a child of frame
	WoltLabBGUI.HostIPInput:SetPos( 100, 50 )
	WoltLabBGUI.HostIPInput:SetSize( 250, 25 )
	WoltLabBGUI.HostIPInput:SetText( WoltLabCBridge.Settings.Host or "Empty" )
	WoltLabBGUI.HostIPInput.OnChange = function( self )
		WoltLabCBridge.Settings.Host = self:GetValue()
	end
	
	
	WoltLabBGUI.Port = vgui.Create( "DLabel", WoltLabBGUI.Main )
	WoltLabBGUI.Port:SetPos( 40, 80 )
	WoltLabBGUI.Port:SetText( "Port:" )
	
	WoltLabBGUI.PortInput = vgui.Create( "DTextEntry", WoltLabBGUI.Main ) -- create the form as a child of frame
	WoltLabBGUI.PortInput:SetPos( 100, 80 )
	WoltLabBGUI.PortInput:SetSize( 250, 25 )
	WoltLabBGUI.PortInput:SetText( WoltLabCBridge.Settings.Port or "Empty" )
	WoltLabBGUI.PortInput.OnChange = function( self )
		WoltLabCBridge.Settings.Port = tonumber(self:GetValue())
	end
	
	
	WoltLabBGUI.Username = vgui.Create( "DLabel", WoltLabBGUI.Main )
	WoltLabBGUI.Username:SetPos( 40, 110 )
	WoltLabBGUI.Username:SetText( "Username:" )
	
	WoltLabBGUI.UsernameInput = vgui.Create( "DTextEntry", WoltLabBGUI.Main ) -- create the form as a child of frame
	WoltLabBGUI.UsernameInput:SetPos( 100, 110 )
	WoltLabBGUI.UsernameInput:SetSize( 250, 25 )
	WoltLabBGUI.UsernameInput:SetText( WoltLabCBridge.Settings.Username or "Empty" )
	WoltLabBGUI.UsernameInput.OnChange = function( self )
		WoltLabCBridge.Settings.Username = self:GetValue()
	end
	
	
	WoltLabBGUI.Password = vgui.Create( "DLabel", WoltLabBGUI.Main )
	WoltLabBGUI.Password:SetPos( 40, 140 )
	WoltLabBGUI.Password:SetText( "Password:" )
	
	WoltLabBGUI.PasswordInput = vgui.Create( "DTextEntry", WoltLabBGUI.Main ) -- create the form as a child of frame
	WoltLabBGUI.PasswordInput:SetPos( 100, 140 )
	WoltLabBGUI.PasswordInput:SetSize( 250, 25 )
	WoltLabBGUI.PasswordInput:SetText( WoltLabCBridge.Settings.Password or "Empty" )
	WoltLabBGUI.PasswordInput.OnChange = function( self )
		WoltLabCBridge.Settings.Password = self:GetValue()
	end
	
	
	WoltLabBGUI.Database = vgui.Create( "DLabel", WoltLabBGUI.Main )
	WoltLabBGUI.Database:SetPos( 40, 170 )
	WoltLabBGUI.Database:SetText( "Database:" )
	
	WoltLabBGUI.DatabaseInput = vgui.Create( "DTextEntry", WoltLabBGUI.Main ) -- create the form as a child of frame
	WoltLabBGUI.DatabaseInput:SetPos( 100, 170 )
	WoltLabBGUI.DatabaseInput:SetSize( 250, 25 )
	WoltLabBGUI.DatabaseInput:SetText( WoltLabCBridge.Settings.Database or "Empty" )
	WoltLabBGUI.DatabaseInput.OnChange = function( self )
		WoltLabCBridge.Settings.Database = self:GetValue()
	end
	
	WoltLabBGUI.RTIGGL = vgui.Create( "DLabel", WoltLabBGUI.Main )
	WoltLabBGUI.RTIGGL:SetPos( 130, 205 )
	WoltLabBGUI.RTIGGL:SetSize( 250, 20 )
	WoltLabBGUI.RTIGGL:SetText( "Website Group to In Game Rank Table" )
	
	WoltLabBGUI.RankToWebGroup = vgui.Create( "DListView",WoltLabBGUI.Main )
	WoltLabBGUI.RankToWebGroup:SetPos( 100, 230 )
	WoltLabBGUI.RankToWebGroup:SetSize( 250, 150 )
	WoltLabBGUI.RankToWebGroup:SetMultiSelect( false )
	WoltLabBGUI.RankToWebGroup:AddColumn( "Website Group ID" )
	WoltLabBGUI.RankToWebGroup:AddColumn( "In Game Rank" )
	WoltLabBGUI.RankToWebGroup.OnRowRightClick = function(lineID,line)				
		WoltLabBGUI.RankToWebGroup.Menu = DermaMenu() 		-- Is the same as vgui.Create( "DMenu" )
		WoltLabBGUI.RankToWebGroup.Menu:AddOption( "Remove" )
		WoltLabBGUI.RankToWebGroup.Menu:SetPos(gui.MousePos())		-- Add a simple option.
		--WoltLabBGUI.RankToWebGroup.Menu:SetIcon( "icon16/delete" )	-- SetIcon possible like this
		WoltLabBGUI.RankToWebGroup.Menu.OptionSelected = function(option,text)
			WoltLabBGUI.RankToWebGroup:RemoveLine( line )
		end

		WoltLabBGUI.RankToWebGroup.Menu:Open()
	end
	
	WoltLabBGUI.WebsiteGroupInput = vgui.Create( "DTextEntry", WoltLabBGUI.Main ) -- create the form as a child of frame
	WoltLabBGUI.WebsiteGroupInput:SetPos( 100, 380 )
	WoltLabBGUI.WebsiteGroupInput:SetSize( 100, 25 )
	WoltLabBGUI.WebsiteGroupInput:SetText( "Website Group ID" )
	WoltLabBGUI.WebsiteGroupInput.OnChange = function( self )
		WoltLabCBridge.TableAddGroup = self:GetValue() 
	end
	
	WoltLabBGUI.InGameRank = vgui.Create( "DTextEntry", WoltLabBGUI.Main ) -- create the form as a child of frame
	WoltLabBGUI.InGameRank:SetPos( 200, 380 )
	WoltLabBGUI.InGameRank:SetSize( 100, 25 )
	WoltLabBGUI.InGameRank:SetText( "In Game Rank" )
	WoltLabBGUI.InGameRank.OnChange = function( self )
		WoltLabCBridge.TableAddRank = self:GetValue()
	end
	
	WoltLabBGUI.AddtoTableButton = vgui.Create( "DButton", WoltLabBGUI.Main ) 
	WoltLabBGUI.AddtoTableButton:SetText( "Add" )					
	WoltLabBGUI.AddtoTableButton:SetPos( 300, 380 )					
	WoltLabBGUI.AddtoTableButton:SetSize( 50, 25 )					
	WoltLabBGUI.AddtoTableButton.DoClick = function()				
		WoltLabBGUI.RankToWebGroup:AddLine(WoltLabCBridge.TableAddGroup,WoltLabCBridge.TableAddRank)
		WoltLabBGUI.WebsiteGroupInput:SetText( "Website Group ID" )
		WoltLabBGUI.InGameRank:SetText( "In Game Rank" )
	end 
	
	WoltLabBGUI.WebsiteRankTable = vgui.Create( "DListView",WoltLabBGUI.Main )
	WoltLabBGUI.WebsiteRankTable:SetPos( 100, 420 )
	WoltLabBGUI.WebsiteRankTable:SetSize( 250, 120 )
	WoltLabBGUI.WebsiteRankTable:SetMultiSelect( false )
	WoltLabBGUI.WebsiteRankTable:AddColumn( "Website Group ID" )
	WoltLabBGUI.WebsiteRankTable:AddColumn( "Group Name" )
	
	WoltLabBGUI.ConnectButton = vgui.Create( "DButton", WoltLabBGUI.Main ) 
	WoltLabBGUI.ConnectButton:SetText( "Connect" )					
	WoltLabBGUI.ConnectButton:SetPos( 400, 430 )					
	WoltLabBGUI.ConnectButton:SetSize( 100, 25 )					
	WoltLabBGUI.ConnectButton.DoClick = function()	
		net.Start("wlb_connect")
		net.SendToServer()
	end
	
	WoltLabBGUI.SaveSettingsButton = vgui.Create( "DButton", WoltLabBGUI.Main ) 
	WoltLabBGUI.SaveSettingsButton:SetText( "Save Settings" )					
	WoltLabBGUI.SaveSettingsButton:SetPos( 400, 460 )					
	WoltLabBGUI.SaveSettingsButton:SetSize( 100, 25 )					
	WoltLabBGUI.SaveSettingsButton.DoClick = function()				
		
		WoltLabCBridge.Settings.GrouptoRank = {}
		
		for k, line in pairs( WoltLabBGUI.RankToWebGroup:GetLines())  do
			table.insert( WoltLabCBridge.Settings.GrouptoRank ,  {WebsiteGroup = line:GetValue( 1 ),InGameRank = line:GetValue( 2 )} )
		end
		
		WoltLabCBridge.SaveSettings()
	end
	
	WoltLabBGUI.CloseSettingsButton = vgui.Create( "DButton", WoltLabBGUI.Main ) 
	WoltLabBGUI.CloseSettingsButton:SetText( "Close Settings" )					
	WoltLabBGUI.CloseSettingsButton:SetPos( 400, 490 )					
	WoltLabBGUI.CloseSettingsButton:SetSize( 100, 25 )					
	WoltLabBGUI.CloseSettingsButton.DoClick = function()				
		WoltLabBGUI.Main:Close()			
	end 
	
	WoltLabBGUI.LoadWebsiteTable = vgui.Create( "DButton", WoltLabBGUI.Main ) 
	WoltLabBGUI.LoadWebsiteTable:SetText( "Load Groups" )					
	WoltLabBGUI.LoadWebsiteTable:SetPos( 400, 520 )					
	WoltLabBGUI.LoadWebsiteTable:SetSize( 100, 25 )					
	WoltLabBGUI.LoadWebsiteTable.DoClick = function()				
		net.Start("wlb_LoadWLgroups")
		net.SendToServer()
	end 
	
	WoltLabBGUI.SyncBans = vgui.Create( "DCheckBoxLabel", WoltLabBGUI.Main ) 
	WoltLabBGUI.SyncBans:SetPos( 400, 400 )
	WoltLabBGUI.SyncBans:SetText( "Ban Sync" )
	WoltLabBGUI.SyncBans:SetValue( WoltLabCBridge.Settings.syncBans or 0 )
	WoltLabBGUI.SyncBans:SizeToContents()
	function WoltLabBGUI.SyncBans:OnChange( val )
		if val then
			WoltLabCBridge.Settings.syncBans = 1
		else
			WoltLabCBridge.Settings.syncBans = 0
		end
	end
	
	WoltLabBGUI.SteamIDFieldLabel = vgui.Create( "DLabel", WoltLabBGUI.Main )
	WoltLabBGUI.SteamIDFieldLabel:SetPos( 400, 340 )
	WoltLabBGUI.SteamIDFieldLabel:SetSize( 100, 25 )
	WoltLabBGUI.SteamIDFieldLabel:SetText( "Table SteamID Field" )
	
	WoltLabBGUI.SteamIDFieldName = vgui.Create( "DTextEntry", WoltLabBGUI.Main ) -- create the form as a child of frame
	WoltLabBGUI.SteamIDFieldName:SetPos( 400, 360 )
	WoltLabBGUI.SteamIDFieldName:SetSize( 99, 25 )
	WoltLabBGUI.SteamIDFieldName:SetText( WoltLabCBridge.Settings.steamID64Field or "steamID64" )
	WoltLabBGUI.SteamIDFieldName.OnChange = function( self )
		WoltLabCBridge.Settings.steamID64Field = self:GetValue()
	end
	
	WoltLabBGUI.WoltLabVersionLabel = vgui.Create( "DLabel", WoltLabBGUI.Main )
	WoltLabBGUI.WoltLabVersionLabel:SetPos( 400, 300 )
	WoltLabBGUI.WoltLabVersionLabel:SetSize( 100, 25 )
	WoltLabBGUI.WoltLabVersionLabel:SetText( "WoltLab Version" )
	
	WoltLabBGUI.WoltLabVersion = vgui.Create( "DComboBox", WoltLabBGUI.Main )
	WoltLabBGUI.WoltLabVersion:SetPos( 400, 320 )
	WoltLabBGUI.WoltLabVersion:SetSize( 100, 20 )
	WoltLabBGUI.WoltLabVersion:SetValue( WoltLabCBridge.Settings.Using or "WSC30_WCF" )
	WoltLabBGUI.WoltLabVersion:AddChoice( "WSC30_WCF" )
	WoltLabBGUI.WoltLabVersion.OnSelect = function( panel, index, value )
		WoltLabCBridge.Settings.Using = value
	end
	
	WoltLabCBridge.TabletoDList(WoltLabCBridge.Settings.GrouptoRank,WoltLabBGUI.RankToWebGroup)
	
	if WoltLabCBridge.WoltLabTable then
		WoltLabCBridge.WLTabletoDList(WoltLabCBridge.WoltLabTable,WoltLabBGUI.WebsiteRankTable)
	end
	 
end)
