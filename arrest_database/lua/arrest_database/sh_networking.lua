if SERVER then
    util.AddNetworkString("eclipse.saveArrests")
    util.AddNetworkString("eclipse.requestArrests")
    util.AddNetworkString("eclipse.sendArrests")
    util.AddNetworkString("eclipse.chatArrest")
    util.AddNetworkString("eclipse.deleteArrest")
    util.AddNetworkString("eclipse.openRFAMenu")

    net.Receive("eclipse.saveArrests", function(len, ply)
        
      --  if not arrestData.allowedSaveJobs[TeamTable[ply:Team()].Regiment] and not arrestData.staffOverride[ply:GetUserGroup()]  then return end

        local arrestedPlySteamID = net.ReadString()
        local reason = net.ReadString()
        local arrestedPly = player.GetBySteamID(arrestedPlySteamID)
        net.Start("eclipse.chatArrest")
        net.WriteString(ply:SteamID())
        net.WriteString(arrestedPly:SteamID())
        net.WriteString(reason)
        net.Broadcast()
        saveArrest(ply, arrestedPly, reason)
    end)

    net.Receive("eclipse.requestArrests", function(len, ply)
    --    if not arrestData.allowedSaveJobs[TeamTable[ply:Team()].Regiment] and not arrestData.staffOverride[ply:GetUserGroup()]  then return end
        local getBy = net.ReadString()
        local comparison = net.ReadString()
        local query = getArrest(getBy, comparison)

        function query.onSuccess(q)
            local dataToSend = util.Compress(util.TableToJSON(query:getData()))
            net.Start("eclipse.sendArrests")
            net.WriteInt(#dataToSend, 32)
            net.WriteData(dataToSend, #dataToSend)
            net.Send(ply)

        end
    end)

    net.Receive("eclipse.deleteArrest", function(len, ply)
    --    if (arrestData.allowedSaveJobs[TeamTable[ply:Team()].Regiment] and arrestData.allowedDeleteCL[TeamTable[ply:Team()].Clearnce]) or arrestData.staffOverride[ply:GetUserGroup()] then return end
        local time = net.ReadString()
        local arrester = net.ReadString()
        removeArrest(time, arrester)
    end)
end

if CLIENT then
    net.Receive("eclipse.chatArrest", function() 
    local arresterID = net.ReadString()
    local arrestedID = net.ReadString()
    local reason = net.ReadString()
    local arrester = player.GetBySteamID(arresterID)
    local arrested = player.GetBySteamID(arrestedID)

    chat.AddText(Color(255,255,255), "[", Color(255, 0, 0), "AOS-SUBMIT", Color(255,255,255),"] ", team.GetColor(arrester:Team()), arrester:Name(), Color(255,255,255), " has subbmitted an AOS for ", team.GetColor(arrested:Team()), arrested:Name(), Color(255, 255, 255) , " with the reason " .. reason)
    
    end)

    net.Receive("eclipse.openRFAMenu", arrestData.createSelectMenu)

end