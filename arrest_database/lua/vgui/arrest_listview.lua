local PANEL = {}

function PANEL:Init()
    self:SetSortable( true )
	self:SetMouseInputEnabled( true )
	self:SetMultiSelect( false )
	self:SetHideHeaders( false )

	self:SetPaintBackground( false )
	self:SetHeaderHeight( 30 )
	self:SetDataHeight( 17 )

	self.Columns = {}

	self.Lines = {}
	self.Sorted = {}

	self:SetDirty( true )

    self.pnlCanvas = vgui.Create( "Panel", self )

	self.VBar = vgui.Create( "DVScrollBar", self )
    self.VBar:SetZPos( 20 )
    
end

function PANEL:AddColumn(strName, iPosition)

    local pColumn = nil

	if ( self.m_bSortable ) then
		pColumn = vgui.Create( "arrest_listViewColumn", self )
	else
		pColumn = vgui.Create( "arrest_listViewColumn", self )
	end

	pColumn:SetName( strName )
	pColumn:SetZPos( 10 )

	if ( iPosition ) then

		table.insert( self.Columns, iPosition, pColumn )

		for i = 1, #self.Columns do
			self.Columns[ i ]:SetColumnID( i )
		end

	else

		local ID = table.insert( self.Columns, pColumn )
		pColumn:SetColumnID( ID )

	end

	self:InvalidateLayout()
    

	return pColumn


end

function PANEL:AddLine( ... )

	self:SetDirty( true )
	self:InvalidateLayout()

	local Line = vgui.Create( "DListView_Line", self.pnlCanvas )
	local ID = table.insert( self.Lines, Line )

	Line:SetListView( self )
	Line:SetID( ID )

	-- This assures that there will be an entry for every column
	for k, v in pairs( self.Columns ) do
		Line:SetColumnText( k, "" )
	end

	for k, v in pairs( {...} ) do
		Line:SetColumnText( k, v )
	end

	-- Make appear at the bottom of the sorted list
	local SortID = table.insert( self.Sorted, Line )

	if ( SortID % 2 == 1 ) then
		Line:SetAltLine( true )
    end
    
    function Line:Paint(w, h)
        if Line:GetID() % 2 == 0 then
            surface.SetDrawColor(110, 110, 110)
        else
            surface.SetDrawColor(100, 100, 100)
        end
        surface.DrawRect(0, 0, w, h)
    end

	function self:OnRowSelected(rowIndex, row)
		-- Only 1 will ever be set, so unset others
        for k, v in pairs(self:GetLines()) do
            function v:Paint(w, h)
                if v:GetID() % 2 == 0 then
                    surface.SetDrawColor(110, 110, 110)
                else
                    surface.SetDrawColor(100, 100, 100)
                end
                surface.DrawRect(0, 0, w, h)
            end
        end
        function row:Paint(w, h)
            surface.SetDrawColor(255, 0, 0)
            surface.DrawRect(0, 0, w, h)
        end

	end
	
	for k, v in pairs(Line.Columns) do
		v:SetColor(Color(255,255,255))
	end

	return Line

end




derma.DefineControl( "arrest_listView", "A simple TextEntry control", PANEL, "DListView" )