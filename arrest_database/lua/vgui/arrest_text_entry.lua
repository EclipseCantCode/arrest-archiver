local PANEL = {}


function PANEL:Init()

    self:SetTextColor(Color(0,0,0))
    self:SetSize(300, ScrH() * 0.05)
    self:SetFont("arrestLabel")

end

function PANEL:PerformLayout()
    self:SetPaintBackground(true)
    self:SetBGColor(0,0,0)
end

derma.DefineControl( "arrest_TEntry", "A simple TextEntry control", PANEL, "DTextEntry" )