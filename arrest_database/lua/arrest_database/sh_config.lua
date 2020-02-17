arrestData = {}
arrestData.cfg = {}


-- LUA tends to unorder tables that don't use numeric keys
arrestData.cfg.order = {"Level 1 Crimes", "Level 2 Crimes", "Level 3 Crimes", "Level 4 Crimes",}

arrestData.cfg.crimes = {
    ["Level 1 Crimes"] = {
        [1] = "Loitering",
        [2] = "Weapon out",
        [3] = "Invalid ID",
        [4] = "Disorderly conduct",
        [5] = "Dishonesty",
        [6] = "Tresspassing",
        [7] = "Misuse of Imperial equipment"
    },
    ["Level 2 Crimes"] = {
       [1] = "Discharging weapon",
       [2] = "Disobeying Orders",
       [3] = "Theft",
       [4] = "Releasing Prisoner",
       [5] = "Unauthorised Access to Controls",
       [6] = "Falsifying ID",
       [7] = "Impersonation",
    },
    ["Level 3 Crimes"] = {
       [1] = "Attempted Murder",
       [2] = "Murder",
       [3] = "Manslaughter",
       [4] = "Blackmail/Extortion",
       [5] = "War criminal",
       [6] = "Ordered by a person of High Authority",
       [7] = "Disrespect of a high Authority",
       [8] = "Disrespect of a regiment",
       [9] = "Personal disrespect towards another personnel",
       [10] = "Obstruction of Justice",
    },
    ["Level 4 Crimes"] = {
        [1] = "Treason",
        [2] = "High Treason",
        [3] = "Attempted Assassination of a high ranking member",
        [4] = "Assasination of a member with extreme authority",
    }
}

-- Regiments allowed to save arrests
arrestData.allowedSaveJobs = {
    ["Shock"] = true,
    ["Riot"] = true,
    ["ISB"] = true,
    ["Imperial High Command"] = true,
    ["Inferno Squad"] = true
}
-- Clearnce level allowed to delete. Player's regiment must be in the above
arrestData.allowedDeleteCL = {
    ["4"] = true,
    ["5"] = true,
    ["6"] = true,
    ["All Access"] = true
}

-- Staff ranks that can override the above tables
arrestData.staffOverride = {
    ["Moderator"] = true,
    ["Senior Moderator"] = true,
    ["Admin"] = true,
    ["superadmin"] = true
}