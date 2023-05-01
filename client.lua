aSpectator = { Offset = 5, AngleX = 0, AngleZ = 30, Spectating = nil }
loadstring(exports.dgs:dgsImportFunction())()
local x,y = guiGetScreenSize()
local px,py = x/1920,y/1080
local s1,s2 = 275,450
srfont = dxCreateFont("font.ttf",10)
Nx,Ny,Nz = nil,nil,nil
local selectPly = nil
local data = 2
zagl = false
Fonts =
    {
        txt = dgsCreateFont ( 'font.ttf', 10*(px/py), false, 'antialiased' ),
    }

Textures =
    {
        Background = dgsCreateRoundRect(12.5,false,tocolor(0,0,0,150)),
        selLab = dgsCreateRoundRect(5,false,tocolor(0,0,0,200)),
        scrl = dgsCreateRoundRect(7,false,tocolor(255,255,255,255)),
        but = dgsCreateRoundRect(4,false,tocolor(250,40,10,100)),
        but1 = dgsCreateRoundRect(4,false,tocolor(0,250,10,100)),
        but3 = dgsCreateRoundRect(4,false,tocolor(0,250,250,100)),
        ButEx1 = dgsCreateRoundRect(12.5,false,tocolor(0,0,0,150)),
        ButEx2 = dgsCreateRoundRect(12.5,false,tocolor(0,0,0,100)),
        ButEx3 = dgsCreateRoundRect(12.5,false,tocolor(155,155,0,175)),
    }

mains = function ()
    Nx,Ny,Nz = getElementPosition (getLocalPlayer())
    showCursor(true)
    main = dgsCreateImage(5, y/3, s1,s2, Textures.Background, false)
    Lab  = dgsCreateLabel(0.26,0.0075,0,0,"Слежка за игроками",true,main)
    scrollpane = dgsCreateScrollPane(5,25,s1-10,s2-35,false,main)
    for i,v in ipairs(dgsGetChildren(scrollpane)) do
        destroyElement(v)
    end
    for i,v in ipairs(getElementsByType("ped")) do
        local imLab = dgsCreateImage(0,0+20*i-15,s1/1.1,20, Textures.selLab, false,scrollpane)
        local lb = dgsCreateLabel(5,2,90,25,tostring("Персонаж - "..getElementData(v,"ID")),false,imLab)
        local bt = dgsCreateButton (0.65, 0.075, 0.35, 0.85, 'наблюдать', true, imLab, nil, nil, nil, Textures.but, Textures.but1, Textures.but3,  nil, nil, nil)
        dgsSetFont(lb, Fonts.txt)
        dgsSetFont(bt, Fonts.txt)
        addEventHandler( "onDgsMouseClick", bt, function( button, state )
            if button ~= "left" or state ~= "up" then return end
            setDataSp(i,v)
            triggerServerEvent ( "attSpec", resourceRoot, getLocalPlayer(),v )
            showCursor(false)
        end )
    end
    local bar1 = dgsScrollPaneGetScrollBar(scrollpane)
    dgsSetProperty( bar1, "alpha", 0.7 )
    dgsSetProperty( bar1, "image", { nil,Textures.scrl, nil } )
    dgsSetProperty( bar1, "cursorColor",{ 0xFFC0C0C0, 0xFFFFFAFA, 0xFFDCDCDC } )
    dgsSetProperty( bar1, "imageRotation", { { { 0, 270, 270 } }, { 270, 0, 0 } } )
    dgsSetProperty( bar1, "troughWidth", { 0, 0 } )
    dgsSetProperty( bar1, "arrowWidth", { 0, 0 } )
    dgsSetProperty( bar1, "multiplier", { 0.5, false } )
    dgsSetProperty( bar1, "length", { 1, false } )
    dgsSetProperty( bar1, "scrollArrow", false )
    dgsSetProperty( bar1, "scrollmultiplier", { 1, false } )
    dgsSetFont(Lab, Fonts.txt)
    exit = dgsCreateButton (5,y/3+s2,s1,40, 'Перестать следить', false, nil, 0xFFFFFFFF, 1, 1, Textures.ButEx1, Textures.ButEx2, Textures.ButEx3,  0xFFFFFFFF, 0xFFe1e1e1, 0xFFd2d2d2)
    dgsSetFont(exit, Fonts.txt)
    addEventHandler( "onDgsMouseClick", exit, function( button, state )
        if button ~= "left" or state ~= "up" then return end
        ExitSp()
        delDataSp()
        triggerServerEvent ( "sNvSp", resourceRoot, getLocalPlayer(),selectPly, Nx,Ny,Nz )
    end )
end

ExitSp = function()
    setCameraTarget ( localPlayer )
    showCursor(false)
    toggleControl ( "fire", true )
    toggleControl ( "aim_weapon", true )
    removeEventHandler ( "onClientCursorMove", root, CursorMove )
    removeEventHandler ( "onClientPreRender", root, Render )
    unbindKey ( "mouse_wheel_up", "down", MoveOffset, -1 )
    unbindKey ( "mouse_wheel_down", "down", MoveOffset, 1 )
    if  isElement(main) then
        destroyElement(main)
    end
    if  isElement(Lab) then
        destroyElement(Lab)
    end
    if  isElement(scrollpane) then
        destroyElement(scrollpane)
    end
    if  isElement(imLab) then
        destroyElement(imLab)
    end
    if  isElement(lb) then
        destroyElement(lb)
    end
    if  isElement(bt) then
        destroyElement(bt)
    end
    if  isElement(exit) then
        destroyElement(exit)
    end
end

setDataSp = function(a1,a2)
    selectPly = a2
    return true
end

function callSpServ()
    mains()
    zagl = true
end
addEvent( "setDataSpectate", true )
addEventHandler( "setDataSpectate", localPlayer, callSpServ )

getDataSp = function()
    return selectPly
end

delDataSp = function()
    selectPly = nil
    return true
end

function SpRender ()
    if selectPly then
        dxDrawText ( "Слежка за ID -"..getElementData(selectPly,"ID") or 0, x /2, 0, y/2, 0, tocolor ( 255, 0, 0, 255 ), 1 )
        return
    end
end

function CursorMove ( rx, ry, x, y )
    if isChatBoxInputActive() then return end
    if ( not isCursorShowing() ) then
        local sx, sy = guiGetScreenSize ()
        aSpectator.AngleX = ( aSpectator.AngleX + ( x - sx / 2 ) / 5 ) % 360
        aSpectator.AngleZ = ( aSpectator.AngleZ + ( y - sy / 2 ) / 5 ) % 360
        if ( aSpectator.AngleZ > 180 ) then
            if ( aSpectator.AngleZ < 315 ) then aSpectator.AngleZ = 315 end
        else
            if ( aSpectator.AngleZ > 45 ) then aSpectator.AngleZ = 45 end
        end
    end
end

function Render ()
    local sx, sy = guiGetScreenSize ()
    if ( not selectPly ) then
        return
    end
    local x, y, z = getElementPosition (selectPly )
    if ( not x ) then
        return
    end
    local offset = data
    local ox, oy, oz
    ox = x - math.sin ( math.rad ( aSpectator.AngleX ) ) * offset
    oy = y - math.cos ( math.rad ( aSpectator.AngleX ) ) * offset
    oz = z + math.tan ( math.rad ( aSpectator.AngleZ ) ) * offset
    setCameraMatrix ( ox, oy, oz, x, y, z )

    if getKeyState("mouse2")  then
        showCursor(true)
    else
        showCursor(false)
    end
end

function MoveOffset ( key, state, inc )
    if ( not isCursorShowing() ) then
        data =data + tonumber ( inc )
        if ( data > 70 ) then data = 70
        elseif ( data < 2 ) then data = 2 end
    end
end

checkSp = function()
    if selectPly then
        SpRender()
        if zagl == true then
            zagl = false
            addEventHandler ( "onClientCursorMove", root, CursorMove )
            addEventHandler ( "onClientPreRender", root, Render )
            bindKey ( "mouse_wheel_up", "down", MoveOffset, -1 )
            bindKey ( "mouse_wheel_down", "down", MoveOffset, 1 )
            toggleControl ( "fire", false )
            toggleControl ( "aim_weapon", false )
        end
    end
end
addEventHandler("onClientRender",root,checkSp)

addEventHandler ( "onClientRender", root,
    function ( )
        for k,ply in ipairs(getElementsByType('ped')) do
            local x,y,z = getElementPosition(ply)
            local x1,y1,z1 = x,y,z-0.75
            local px,py,pz = getElementPosition(getLocalPlayer())
            local distance = getDistanceBetweenPoints3D ( x,y,z,px,py,pz )
            local Mx, My, Mz = getCameraMatrix()
            if ( getDistanceBetweenPoints3D ( x,y,z, getElementPosition ( localPlayer ) ) ) < 54 then
                local coords = { getScreenFromWorldPosition ( x,y,z+0.1 ) }
                if coords[1] and coords[2] then
                    if processLineOfSight(x1,y1,z1, Mx, My, Mz, true, false, false, true, false, true) then break end
                    dxDrawText ( "ID -"..getElementData(ply,"ID") or 0, coords[1], coords[2], coords[1], coords[2], tocolor(255,255,255), math.min ( 0.4*(15/distance)/1.4,1), "default","center" )
                end
            end
        end
    end
)

