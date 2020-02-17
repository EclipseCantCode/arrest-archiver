local PANEL = {}

function PANEL:Init()
    self.DropButton = vgui.Create("DPanel", self)

    self.DropButton.Paint = function(panel, w, h)
        derma.SkinHook("Paint", "ComboDownArrow", panel, w, h)
    end

    self.DropButton:SetMouseInputEnabled(false)
    self.DropButton.ComboBox = self
    self:SetTall(22)
    self:Clear()
    self:SetContentAlignment(4)
    self:SetTextInset(8, 0)
    self:SetIsMenu(true)
    self:SetSortItems(true)
    self:SetFont("arrestLabel")
    self:SetTextColor(Color(255, 255, 255))
end

function PANEL:Paint(w, h)
    -- Draw a Border
    surface.SetDrawColor(50, 50, 50)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:OpenMenu()
    -- Copied from https://github.com/Facepunch/garrysmod/blob/b82c4b63c6161d313978c05036a76a9b39378414/garrysmod/lua/vgui/dcombobox.lua
    if (pControlOpener and pControlOpener == self.TextEntry) then return end
    -- Don't do anything if there aren't any options..
    if (#self.Choices == 0) then return end

    -- If the menu still exists and hasn't been deleted
    -- then just close it and don't open a new one.
    if (IsValid(self.Menu)) then
        self.Menu:Remove()
        self.Menu = nil
    end

    self.Menu = DermaMenu(false, self)

    if (self:GetSortItems()) then
        local sorted = {}

        for k, v in pairs(self.Choices) do
            local val = tostring(v) --tonumber( v ) || v -- This would make nicer number sorting, but SortedPairsByMemberValue doesn't seem to like number-string mixing

            if (string.len(val) > 1 and not tonumber(val) and val:StartWith("#")) then
                val = language.GetPhrase(val:sub(2))
            end

            table.insert(sorted, {
                id = k,
                data = v,
                label = val
            })
        end

        for k, v in SortedPairsByMemberValue(sorted, "label") do
            local option = self.Menu:AddOption(v.data, function()
                self:ChooseOption(v.data, v.id)
            end)

            function option:Paint(w, h)
                surface.SetDrawColor(75, 75, 75)
                surface.DrawRect(0, 0, w, h)
            end

            option:SetColor(Color(255,255,255))

            if (self.ChoiceIcons[v.id]) then
                option:SetIcon(self.ChoiceIcons[v.id])
            end
        end
    else
        for k, v in pairs(self.Choices) do
            local option = self.Menu:AddOption(v, function()
                self:ChooseOption(v, k)
            end)

            function option:Paint(w, h)
                surface.SetDrawColor(75, 75, 75)
                surface.DrawRect(0, 0, w, h)
            end

            option:SetColor(Color(255,255,255))

            if (self.ChoiceIcons[k]) then
                option:SetIcon(self.ChoiceIcons[k])
            end
        end
    end

    local x, y = self:LocalToScreen(0, self:GetTall())
    self.Menu:SetMinimumWidth(self:GetWide())
    self.Menu:Open(x, y, false, self)

    
end

derma.DefineControl("arrest_combobox", "Arrest Frame", PANEL, "DComboBox")