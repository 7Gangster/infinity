local font = dxCreateFont("files/fonts/Roboto-Regular.ttf", 11)
local font2 = dxCreateFont("files/fonts/Roboto-Medium.ttf", 8)
local font3 = dxCreateFont("files/fonts/Roboto-Medium.ttf", 10)

posx = {}
local tick = getTickCount()

Positions_Mystery_Roulette = {
    [0] = {13, 1, 155, 92},
    [1] = {172, 1, 155, 92},
    [2] = {331, 1, 155, 92},
    [3] = {490, 1, 155, 92},
    [4] = {649, 1, 155, 92},
    [5] = {808, 1, 155, 92},
}

function dx()
    dxDrawImage(280, 265, 805, 238, "files/imgs/base.png")
    dxDrawText("CAIXA MISTERIOSA", 323, 287, 94, 17, tocolor(255, 255, 255, 255), 1.00, font, "left", "center", false, false, false, false, false)
    dxDrawImage(679, 336, 9, 20, "files/imgs/pin.png")
    dxSetRenderTarget(renderTgt, true)
        dxSetBlendMode("modulate_add")
            for i,v in ipairs(config["Mystery's"][typeMystery]) do
                if i <= #Positions_Mystery_Roulette then 
                    if not animation1 then 
                        posx[i] = interpolateBetween(Positions_Mystery_Roulette[i][1], 0, 0, Positions_Mystery_Roulette[i-1][1], 0, 0, ((getTickCount() - tick) / 1000), (animation3 and "OutBack" or "InBack"))
                    else 
                        posx[i] = interpolateBetween(0, 0, 0, 159, 0, 0, ((getTickCount() - tick) / 100), "Linear")
                    end 
                    dxDrawImage((animation1 and ((Positions_Mystery_Roulette[i][1]) - (posx[i])) or posx[i]), Positions_Mystery_Roulette[i][2], Positions_Mystery_Roulette[i][3], Positions_Mystery_Roulette[i][4], v[5])
                    dxDrawImage((animation1 and (((Positions_Mystery_Roulette[i][1]) - (posx[i])) + 43) or (posx[i] + 43)), Positions_Mystery_Roulette[i][2]+6, 70, 70, v[4])
                end 
            end 
        dxSetBlendMode()
    dxSetRenderTarget()
    dxSetBlendMode("add")
        dxDrawImage(280, 341, 805, 93, renderTgt)
    dxSetBlendMode()
    dxDrawText(lastCollect and string.upper(lastCollect) or "NINGUÉM COLETOU RECENTEMENTE!", 348, 449, 711, 39, tocolor(255, 255, 255, 255), 1.00, font2, "center", "center", false, false, false, true, false)
    if collectIten then
        dxDrawImage(280, 265, 805, 238, "files/imgs/shadow.png")
        dxDrawImage(581, 268, 204, 204, "files/imgs/success.png")
        dxDrawImage(605, 324, 155, 92, receivedIten[5])
        dxDrawImage(647, 333, 70, 70, receivedIten[4])
        dxDrawText("#B0B1B3VOCÊ RECEBEU 1x #FFFFFF"..string.upper(receivedIten[1]), 603, 297, 160, 14, tocolor(255, 255, 255, 255), 1.00, font3, "center", "center", false, false, false, true, false)
        dxDrawImage(605, 425, 155, 26, "files/imgs/button.png", 0, 0, 0, isMouseInPosition(605, 425, 155, 26) and tocolor(155, 111, 199) or tocolor(155, 111, 199, 70))
        dxDrawText("RECEBER", 605, 425, 155, 26, isMouseInPosition(605, 425, 155, 26) and tocolor(0, 0, 0, 255) or tocolor(0, 0, 0, 70), 1.00, font3, "center", "center", false, false, false, true, false)
    end
end

addEvent("JOAO.openMysteryBox", true)
addEventHandler("JOAO.openMysteryBox", root,
function(typeMystery_, lastCollect_)
    if not isEventHandlerAdded("onClientRender", root, dx) then
        collectIten = false
        receivedIten = {}
        lastCollect = lastCollect_
        typeMystery = typeMystery_
        local randomItemSequ = math.random(50, 100)
        setTimer(function()
            animation1 = true
        end, 1000, 1)
        setTimer(function()
            tableItensNew = {}
            for i,v in ipairs(config["Mystery's"][typeMystery]) do 
                if i == 1 then 
                    tableItensNew[#config["Mystery's"][typeMystery]] = v
                else 
                    tableItensNew[i-1] = v
                end
            end 
            config["Mystery's"][typeMystery] = tableItensNew
            tick = getTickCount()   
            TimerCaixa = setTimer(function()  
                tableItensNew = {}
                for i,v in ipairs(config["Mystery's"][typeMystery]) do
                    if i == 1 then
                        tableItensNew[#config["Mystery's"][typeMystery]] = v
                    else
                        tableItensNew[i-1] = v
                    end
                end 
                config["Mystery's"][typeMystery] = tableItensNew
                local _,  quantidade = getTimerDetails(TimerCaixa)
                if quantidade == 1 then 
                    receivedIten = config["Mystery's"][typeMystery][3]
                    animation1 = false 
                    animation3 = true 
                    setTimer(function  ()
                        collectIten = true
                    end, 1000, 1)
                end     
                tick = getTickCount()
            end, 100, randomItemSequ)
        end, 1000, 1)
        addEventHandler("onClientRender", root, dx)
        showCursor(true)
    end
end)

addEventHandler("onClientClick", root,
function(_, state)
    if state == "up" then
        if isEventHandlerAdded("onClientRender", root, dx) then
            if collectIten then
                if isMouseInPosition(605, 425, 155, 26) then
                    triggerServerEvent("JOAO.collectItem", localPlayer, localPlayer, receivedIten)
                    closeMenu()
                end
            end
        end 
    end
end)

function closeMenu()
    if isEventHandlerAdded("onClientRender", root, dx) then
        removeEventHandler("onClientRender", root, dx)
        showCursor(false)
    end
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == "string" and isElement( pElementAttachedTo ) and type( func ) == "function" then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == "table" and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end