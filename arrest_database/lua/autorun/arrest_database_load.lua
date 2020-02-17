print("Loading Arrest Database by Eclipse (STEAM_0:0:169836462)")
if SERVER then 
    include("arrest_database/sh_config.lua")
    include("arrest_database/sv_sqlFunctions.lua")
    include("arrest_database/sh_networking.lua")
    AddCSLuaFile()
    AddCSLuaFile("arrest_database/sh_networking.lua")
    AddCSLuaFile("arrest_database/cl_panel.lua")
    AddCSLuaFile("arrest_database/cl_fonts.lua")
    AddCSLuaFile("arrest_database/sh_config.lua")
    resource.AddFile("resource/arrest_leftarrow.png")
    resource.AddFile("resource/arrest_rightarrow.png")
    resource.AddFile("resource/arrest_tick.png")
end

if CLIENT then
    include("arrest_database/sh_config.lua")
    include("arrest_database/cl_fonts.lua")
    include("arrest_database/cl_panel.lua")
    include("arrest_database/sh_networking.lua")
end