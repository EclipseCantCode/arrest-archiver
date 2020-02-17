local CATEGORY_NAME = "Imperial Gaming"


function ulx.rfa( ply )
    net.Start("eclipse.openRFAMenu")
    net.Send(ply)
end

local rfa = ulx.command( CATEGORY_NAME, "ulx rfa", ulx.rfa, "!rfa" )
rfa:defaultAccess( ULib.ACCESS_ADMIN )
rfa:help( "RFA a prisoner." )

function ulx.viewRFA( ply )
    net.Start("eclipse.openViewRFAMenu")
    net.Send(ply)
end

local rfa = ulx.command( CATEGORY_NAME, "ulx viewrfa", ulx.viewRFA, "!viewrfa" )
rfa:defaultAccess( ULib.ACCESS_ADMIN )
rfa:help( "View RFAs for a player" )
