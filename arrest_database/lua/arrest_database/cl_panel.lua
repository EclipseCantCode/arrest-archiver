function arrestData:createArrestInput()
    local frame = vgui.Create("arrest_frame")
    frame:SetSize(ScrW() * 0.5, ScrH() * 0.5)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("Arrest Input")
    local panel1 = vgui.Create("DPanel", frame)
    panel1:SetPos(0, 20)
    panel1:SetSize(frame:GetWide(), frame:GetTall() - 20)
    panel1:SetPaintBackground(false)
    local listView = vgui.Create("arrest_listView", panel1)
    listView:AddColumn("Name")
    listView:AddColumn("SteamID")
    listView:AddColumn("Regiment")
    listView:SetPos(10, panel1:GetTall() * 0.25)
    listView:SetSize(panel1:GetWide() - 20, panel1:GetTall() * 0.65)
    local searchText = vgui.Create("arrest_TEntry", panel1)
    searchText:SetPos(10, panel1:GetTall() * 0.11)
    local searchTerm = vgui.Create("arrest_combobox", panel1)
    searchTerm:SetPos(panel1:GetWide() * 0.4, panel1:GetTall() * 0.11)
    searchTerm:SetSize(300, ScrH() * 0.05)

    -- Get all the Search Terms based upon list view options
    for k, v in pairs(listView.Columns) do
        if k == 1 then
            searchTerm:AddChoice(v.Header:GetText(), v.Header:GetText(), true)
        else
            searchTerm:AddChoice(v.Header:GetText(), v.Header:GetText(), false)
        end
    end

    local function refreshList()
        local txt = searchText:GetValue()
        local term, _term = searchTerm:GetSelected()
        listView:Clear()

        -- We want something to come up
        if txt == "" then
            for k, v in pairs(player.GetAll()) do
                listView:AddLine(v:Name(), v:SteamID(), k)
            end

            return
        end

        for k, ply in pairs(player.GetAll()) do
            if term == "Name" then
                if string.find(string.lower(ply:Name()), string.lower(txt)) then
                    listView:AddLine(ply:Name(), ply:SteamID(), k)
                end
            elseif term == "SteamID" then
                if string.find(string.lower(ply:SteamID()), string.lower(txt)) then
                    listView:AddLine(ply:Name(), ply:SteamID(), k)
                end
            end
            --  elseif term == "Regiment" then
            --    if string.find(TeamTable[ply:Team()].Regiment), string.lower(txt)) then listView:AddLine(ply:Name(), k) end
        end
    end

    -- Surely there is a better way than this
    function searchText:OnChange()
        refreshList()
    end

    function searchTerm:OnSelect(index, value, data)
        refreshList()
    end

    for k, v in pairs(player.GetAll()) do
        listView:AddLine(v:Name(), v:SteamID(), k)
    end

    local nextButton = vgui.Create("DImageButton", panel1)
    nextButton:SetImage("resource/arrest_rightarrow.png")
    nextButton:SetPos(panel1:GetWide() - 50, panel1:GetTall() - 50)
    nextButton:SetSize(50, 50)
    -- Page 2: Crime Selection
    local panel2 = vgui.Create("DPanel", frame)
    panel2:SetPos(0, 20)
    panel2:SetSize(frame:GetWide(), frame:GetTall() - 20)
    panel2:SetPaintBackground(false)
    panel2:SetVisible(false)
    local possibleCrimes = vgui.Create("arrest_listView", panel2)
    possibleCrimes:AddColumn("Possible Crimes")
    possibleCrimes:SetPos(10, panel2:GetTall() * 0.12)
    possibleCrimes:SetSize(panel2:GetWide() * 0.33, panel2:GetTall() * 0.75)

    -- Load crimes in from sh_config
    for a, tableName in pairs(arrestData.cfg.order) do
        local table = arrestData.cfg.crimes[tableName]
        local line = possibleCrimes:AddLine(tableName)
        line.isHeader = true
        -- No need for loop because only 1 column
        local listText = line.Columns[1]
        listText:SetContentAlignment(5)

        function listText:Paint(w, h)
            surface.SetDrawColor(153, 0, 0)
            surface.DrawRect(0, 0, w, h)
        end

        for key, crime in pairs(table) do
            possibleCrimes:AddLine(crime)
        end
    end

    local commitedCrimes = vgui.Create("arrest_listView", panel2)
    commitedCrimes:AddColumn("Commited Crimes")
    commitedCrimes:SetPos(panel2:GetWide() * 0.66 + 10, panel2:GetTall() * 0.12)
    commitedCrimes:SetSize(panel2:GetWide() * 0.33, panel2:GetTall() * 0.75)

    -- The one on the left
    function possibleCrimes:OnClickLine(row, bClear)
        -- Test if one is a header
        if row.isHeader then return end
        commitedCrimes:AddLine(row:GetValue(1))
        self:RemoveLine(row:GetID())
    end

    -- right one on the right
    -- OnRowSelected wasn't being called?????????????????
    --[[
    function commitedCrimes:OnRowSelected(rowIndex, row)
    possibleCrimes:AddLine(row:GetValue(1))
    self:RemoveLine(rowIndex)
    end
    ]]
    -- Found the problem is OnRowSelected.... Adding to a dlistview already made brakes it?
    -- When put back it will be at the bottom. Far too lazy to fix, future me problem if I ever use this
    function commitedCrimes:OnClickLine(Line, bClear)
        self:RemoveLine(Line:GetID())
        possibleCrimes:AddLine(Line:GetValue(1))
    end

    local backButton = vgui.Create("DImageButton", panel2)
    backButton:SetImage("resource/arrest_leftarrow.png")
    backButton:SetPos(0, panel1:GetTall() - 50)
    backButton:SetSize(50, 50)
    local finishButton = vgui.Create("DImageButton", panel2)
    finishButton:SetImage("resource/arrest_tick.png")
    finishButton:SetPos(panel1:GetWide() - 50, panel1:GetTall() - 50)
    finishButton:SetSize(50, 50)

    function finishButton:DoClick()

        
        if table.Count(listView:GetSelected()) == 0 or not commitedCrimes:GetLines()[1] then
            notification.AddLegacy("Make sure all the data is filled in", NOTIFY_ERROR, 10)

            return
        end


        local steamID = listView:GetSelected()[1]:GetValue(2)
        print(table.Count(listView:GetSelected()))
        local selectedReasons = {}

        for k, v in pairs(commitedCrimes:GetLines()) do
            table.insert(selectedReasons, v:GetValue(1))
        end


        net.Start("eclipse.saveArrests")
        net.WriteString(steamID)
        net.WriteString(string.Implode(", ", selectedReasons))
        net.SendToServer()
        frame:Remove()
    end

    -- Switch Pages
    function backButton:DoClick()
        panel1:SetVisible(true)
        panel2:SetVisible(false)
    end

    function nextButton:DoClick()
        panel1:SetVisible(false)
        panel2:SetVisible(true)
    end
end

function arrestData:createArrestView()
    -- Just copied from above, because they're basicly the same.
    arrestViewPanel = vgui.Create("arrest_frame")
    arrestViewPanel:SetSize(ScrW() * 0.9, ScrH() * 0.5)
    arrestViewPanel:Center()
    arrestViewPanel:MakePopup()
    arrestViewPanel:SetTitle("Arrest View")
    local panel = vgui.Create("DPanel", arrestViewPanel)
    panel:SetPos(0, 20)
    panel:SetSize(arrestViewPanel:GetWide(), arrestViewPanel:GetTall() - 20)
    panel:SetPaintBackground(false)
    arrestlistViewPanel = vgui.Create("arrest_listView", panel)
    arrestlistViewPanel:AddColumn("Date")
    arrestlistViewPanel:AddColumn("Time")
    arrestlistViewPanel:AddColumn("Arrester")
    arrestlistViewPanel:AddColumn("Name")
    arrestlistViewPanel:AddColumn("SteamID")
    arrestlistViewPanel:AddColumn("Regiment, Rank")
    arrestlistViewPanel:AddColumn("Reason")
    arrestlistViewPanel:SetPos(10, panel:GetTall() * 0.25)
    arrestlistViewPanel:SetSize(panel:GetWide() - 20, panel:GetTall() * 0.65)

    function arrestlistViewPanel:OnRowRightClick(lineID, line)
        local menu = DermaMenu(line)
        menu:Open()

        menu:AddOption("Delete", function()

            Derma_Query("Are you sure you want to delete this arrest?", "Arrest Deletion", "Yes", function()
                net.Start("eclipse.deleteArrest")
                net.WriteString(line.time)
                net.WriteString(line:GetValue(3))
                net.SendToServer()
                arrestlistViewPanel:RemoveLine(lineID)
            end, "No")
        end)
    end

    local searchText = vgui.Create("arrest_TEntry", panel)
    searchText:SetPos(10, panel:GetTall() * 0.11)
    local searchTerm = vgui.Create("arrest_combobox", panel)
    searchTerm:SetPos(panel:GetWide() * 0.2, panel:GetTall() * 0.11)
    searchTerm:SetSize(300, ScrH() * 0.05)
    local dateColumn = searchTerm:AddChoice("Date", "Date", true)
    searchTerm:AddChoice("Arrester")
    searchTerm:AddChoice("Name")
    searchTerm:AddChoice("SteamID")
    searchTerm:AddChoice("Regiment")
    searchTerm:AddChoice("Rank")
    local searchButton = vgui.Create("DButton", panel)
    searchButton:SetText("SEARCH")
    searchButton:SetFont("arrestLabel")
    searchButton:SetPos(panel:GetWide() * 0.4, panel:GetTall() * 0.11)
    searchButton:SetSize(300, ScrH() * 0.05)

    function searchButton:DoClick()
        local searchTerm = searchTerm:GetSelected()
        local searchText = searchText:GetValue()
        net.Start("eclipse.requestArrests")
        net.WriteString(searchTerm)
        net.WriteString(searchText)
        net.SendToServer()
    end

    -- Default search is todays date ordered by time
    net.Start("eclipse.requestArrests")
    net.WriteString("Date")
    net.WriteString(os.date("%Y-%m-%d"))
    net.SendToServer()
end

-- Populate listview once netmsg is recieved
net.Receive("eclipse.sendArrests", function()
    local len = net.ReadInt(32)
    local tbl = table.Reverse(util.JSONToTable(util.Decompress(net.ReadData(len))))
    if not IsValid(arrestViewPanel) then return end
    arrestlistViewPanel:Clear()

    for k, arrest in pairs(tbl) do
        local line = arrestlistViewPanel:AddLine(arrest["Date"], os.date("%H:%M:%S", arrest["Time"]), arrest["Arrester"], arrest["Name"], arrest["SteamID"], arrest["Regiment"] .. ", " .. arrest["Rank"], arrest["Reason"])
        -- Keep os.time() for a unique key
        line.time = arrest["Time"]
        -- Sort by OS time to keep consistant
        line:SetSortValue(2, arrest["Time"])
        line:SetSortValue(1, arrest["Time"])
        print(line:GetSortValue(2))
    end
end)


function arrestData:createSelectMenu()
    local selectFrame = vgui.Create("arrest_frame")
    selectFrame:SetSize(ScrW() * 0.5, ScrH() * 0.5)
    selectFrame:Center()
    selectFrame:MakePopup()
    selectFrame:SetTitle("Arrest Input")

    local inputArrestButton = vgui.Create("DButton", selectFrame)
    inputArrestButton:SetPos(0, selectFrame:GetTall() * 0.15)
    inputArrestButton:SetSize(selectFrame:GetWide() * 0.49, selectFrame:GetTall() * 0.8)
    inputArrestButton:SetFont("arrestTitle")
    inputArrestButton:SetTextColor(Color(255,255,255))
    inputArrestButton:SetText("Make an RFA")
    function inputArrestButton:Paint(w, h)
        surface.SetDrawColor(50, 50, 50)
        surface.DrawRect(0, 0, w, h)
    end

    function inputArrestButton:DoClick()
        selectFrame:Remove()
        arrestData:createArrestInput()
    end

    local viewRFAButton = vgui.Create("DButton", selectFrame)
    viewRFAButton:SetPos(selectFrame:GetWide() * 0.51, selectFrame:GetTall() * 0.15)
    viewRFAButton:SetSize(selectFrame:GetWide() * 0.49, selectFrame:GetTall() * 0.8)
    viewRFAButton:SetFont("arrestTitle")
    viewRFAButton:SetTextColor(Color(255,255,255))
    viewRFAButton:SetText("View RFAs")
    function viewRFAButton:Paint(w, h)
        surface.SetDrawColor(50, 50, 50)
        surface.DrawRect(0, 0, w, h)
    end

    function viewRFAButton:DoClick()
        selectFrame:Remove()
        arrestData:createArrestView()
    end


 
end
