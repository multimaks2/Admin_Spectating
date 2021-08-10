
local testMod = true -- true Вкл/ false Выкл

function getPlayerFromID ( id )
    for k, player in ipairs ( getElementsByType ( "player" ) ) do
        local p_id = getElementData ( player, "ID" )
        if ( p_id == tonumber(id) ) then
            player_n = getPlayerName ( player )
            return player, player_n
        end
    end
    return false
end

function spectated(thePlayer, Command, target)
    local accName = getAccountName ( getPlayerAccount ( thePlayer ) )
    if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin_2_lvl" ) )
        or isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin_3_lvl" ) )
        or isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin_4_lvl" ) )
        or isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin_5_lvl" ) )
        or isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin_6_lvl" ) )
        or isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin_7_lvl" ) ) then
        -- local targetplayer = getPlayerFromID (tonumber(target))
        local x,y,z = getElementPosition( thePlayer )
        triggerClientEvent ( thePlayer, "setDataSpectate", thePlayer)
        setElementAlpha(thePlayer, 0)
        setElementData(thePlayer,"Видимость",false)
    end
end
addEventHandler("CommmandHandler", getRootElement(), spectated )
addCommandHandler("sp", spectated)

attSpec = function(UserData,specData)
    attachElements (UserData,(specData), 0, 0, -6 )
    setElementAlpha(UserData, 0)
    setElementData(UserData,"Видимость",false)
end
addEvent( "attSpec", true )
addEventHandler( "attSpec", resourceRoot, attSpec )

function sNvSp(thePly,playerOther,nx, ny, nz)
    detachElements( thePly,playerOther)
    setElementPosition ( thePly, nx, ny, nz+1.5 )
    setElementAlpha(thePly, 255)
    setElementData(thePly,"Видимость",true)
end
addEvent("sNvSp", true)
addEventHandler("sNvSp", getRootElement(), sNvSp)

function pedLoad (  )
if testMod = true then
        for i = 1,50 do
          local peds = createPed ( 120, 2478+i*10, -745,12 )
          setElementData(peds,"ID",i)
        end
    end
end
addEventHandler ( "onResourceStart", getResourceRootElement(), pedLoad )
