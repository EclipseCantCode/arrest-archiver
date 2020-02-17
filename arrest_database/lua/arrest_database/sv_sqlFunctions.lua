require("mysqloo")
arrestDB = mysqloo.connect("localhost", "arrests", "123", "arrests")
arrestDB:connect()
-- SETUP QUERY
local setupQuery = arrestDB:query("CREATE TABLE IF NOT EXISTS arrests.data(Date date, Time int, Arrester varchar(255),  Name varchar(255), SteamID varchar(255), Regiment varchar(255), Rank varchar(255), Reason varchar(1000))")

function setupQuery.onError(q, err)
    print(err)
end

function setupQuery.onSuccess(q)
    print("Arrest Database setup completed")
end

function arrestDB.onConnected(db)
    print("Arrest Database connected")
    setupQuery:start()
end

-- Save Arrest Query
function saveArrest(arresting_ply, arrested_ply, reason)
    local saveQuery = arrestDB:query("INSERT INTO data VALUES('" .. os.date("%Y-%m-%d") .. "', '" .. os.time() .. "', '" .. arresting_ply:Name() .. "', '" .. arrested_ply:Name() .. "', '" .. arrested_ply:SteamID() .. "', '" .. "Storm Trooper" .. "', '" .. "Private" .. "', '" .. reason .. "')")

    function saveQuery.onSuccess(q)
        hook.Run("savedArrest", arresting_ply, arrested_ply, reason)
    end

    function saveQuery.onError(q, err)
        print("ARREST SYSTEM ERROR:" .. err)
    end

    saveQuery:start()
end

-- Get By Date Query
function getArrest(type, input)
    local arrestQuery = arrestDB:query("SELECT * from arrests.data WHERE " .. type .. " = '" .. input .. "'")

    function arrestQuery.onError(q, err)
        print(err)
    end

    arrestQuery:start()

    return arrestQuery
end

-- Remove arrest Query
function removeArrest(time, arrester)
    local removeQuery = arrestDB:query("DELETE FROM `data` WHERE Time = '" .. time .. "' AND Arrester = '" .. arrester .. "'")

    function removeQuery.onError(q, err)
        print("Arrest DB ERROR " .. err)
    end

    removeQuery:start()
end

function arrestDB.onConnectionFailed(db, err)
    print([[
              _____  _____  ______  _____ _______      _______     _______ _______ ______ __  __      ______      _____ _      
        /\   |  __ \|  __ \|  ____|/ ____|__   __|    / ____\ \   / / ____|__   __|  ____|  \/  |    |  ____/\   |_   _| |     
       /  \  | |__) | |__) | |__  | (___    | |      | (___  \ \_/ / (___    | |  | |__  | \  / |    | |__ /  \    | | | |     
      / /\ \ |  _  /|  _  /|  __|  \___ \   | |       \___ \  \   / \___ \   | |  |  __| | |\/| |    |  __/ /\ \   | | | |     
     / ____ \| | \ \| | \ \| |____ ____) |  | |       ____) |  | |  ____) |  | |  | |____| |  | |    | | / ____ \ _| |_| |____ 
    /_/    \_\_|  \_\_|  \_\______|_____/   |_|      |_____/   |_| |_____/   |_|  |______|_|  |_|    |_|/_/    \_\_____|______|                                                                                                                                                                                                                                                                                           
    ]])
    print("ARREST SYSTEM ERROR" .. err)
end