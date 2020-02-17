local PANEL = {}

function PANEL:Init()

    self.Header = vgui.Create( "DButton", self )
	self.Header.DoClick = function() self:DoClick() end
	self.Header.DoRightClick = function() self:DoRightClick() end

	self.DraggerBar = vgui.Create( "DListView_DraggerBar", self )

	self:SetMinWidth( 10 )
    self:SetMaxWidth( 19200 )
        
    function self.Header:Paint(w, h)
        surface.SetDrawColor(50, 50, 50)
        surface.DrawRect(0, 0, w, h)
    end

    self.Header:SetColor(Color(255, 255, 255))
    self.Header:SetFont("arrestLabel")
    
    function self.DraggerBar:Paint(w, h)
        surface.SetDrawColor(75, 75, 75)
        surface.DrawRect(0, 0, w, h)
    end



end

derma.DefineControl( "arrest_listViewColumn", "", PANEL, "DListView_Column" )