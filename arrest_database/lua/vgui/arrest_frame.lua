local PANEL = {}

function PANEL:Init()

	self.lblTitle:SetText("")
	self.labelTitle = vgui.Create("DLabel", self)
	self.labelTitle:SetFont("arrestTitle")
	self.labelTitle:SetText("hi")
	self.labelTitle:SetPos(10, 0)
	self.labelTitle:SetSize(500, ScrH() * 0.05)

	-- Hiding useless buttons
	self.btnMaxim:SetVisible(false)
	self.btnMinim:SetVisible(false)

	self:SetBackgroundBlur(true)

end

function PANEL:SetTitle(txt)
	self.labelTitle:SetText(txt)
end



function PANEL:Paint( w, h )
	if ( self.m_bBackgroundBlur ) then
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end

 --  derma.SkinHook( "Paint", "Frame", self, w, h )
	surface.SetDrawColor(75, 75, 75)
	surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(50, 50, 50)
	surface.DrawRect(0, 0, w, h * 0.1)
  
    return true

end

derma.DefineControl("arrest_frame", "Arrest Frame", PANEL, "DFrame")