local barra = 50
local minigame = false
local timer = {}
local peixe = false

local font = dxCreateFont('src/assets/Roboto.ttf', 12, false, 'default')

render = function()
    dxDrawRoundedRectangle(672, 925, 576, 60, tocolor(33, 33, 33), 10)
    dxDrawRoundedRectangle(679, 932, 562, 46, tocolor(228, 55, 44), 10)
    dxDrawRoundedRectangle(679, 932, 562/100*barra, 46, tocolor(76, 197, 74), 10)
    
    dxDrawImage(926, 785, 70, 116, 'src/assets/mouse_l.png')
    dxDrawText('Clique com o botão esquerdo do mouse para evitar que o peixe escape.', 679+1, 985+1, 562, 32, tocolor(0, 0, 0), 1, font, 'center', 'center')
    dxDrawText('Clique com o botão esquerdo do mouse para evitar que o peixe escape.', 679, 985, 562, 32, white, 1, font, 'center', 'center')

    if (barra -peixe[2]) <= 0 then 
        endMinigame(false)
        killTimer(timer[localPlayer])
        timer[localPlayer] = nil
    elseif (barra +2) >= 100 then 
        endMinigame(true)
        killTimer(timer[localPlayer])
        timer[localPlayer] = nil
    end
end

addEvent('pescador:startMinigame', true)
addEventHandler('pescador:startMinigame', root, function()
    if not isEventHandlerAdded('onClientRender', root, render) then
        addEventHandler('onClientRender', root, render)
        toggleAllControls(false)
        peixe = cfg.peixes[math.random(1, #cfg.peixes)]
        barra = 50
        minigame = true
        showCursor(true)
        timer[localPlayer] = setTimer(function()
            barra = barra -peixe[2]
        end, 1000, 0)
    end
end)

function endMinigame(type)
    if type == true then 
        triggerServerEvent('recompensaPescador', localPlayer, localPlayer, peixe[1])
        removeEventHandler('onClientRender', root, render)

    else
        removeEventHandler('onClientRender', root, render)
        setElementData(localPlayer, 'pescando', false)
        triggerServerEvent('setAnim', localPlayer, localPlayer)
        setElementFrozen(localPlayer, false)
    end
    toggleAllControls(true)
    showCursor(false)
end

function onKey(b, s)
    if minigame then
        if s then
            if b == 'mouse1' then 
                barra = barra +1.5 + ((getElementData(localPlayer, 'level') or 1)/10)
            end
        end
    end
end
addEventHandler('onClientKey', root, onKey)