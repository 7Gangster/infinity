local screenW, screenH = guiGetScreenSize()
local resW, resH = 1280, 720
local x, y = screenW/resW, screenH/resH

local fonts = {
    dxCreateFont('assets/Poppins-Regular.ttf', 20),
    dxCreateFont('assets/Poppins-Regular.ttf', 12),
}

local playingMinigame = false
local barTime = Config.startBarTime
local antigoBarTime = Config.startBarTime
local tick = getTickCount()
local timer = {}
local barColor = tocolor(0, 209, 255, 255)
local atualKey = 'a'
local eventToExecute = nil
local element = nil

function minigameRender()
    local anim = interpolateBetween(antigoBarTime, 0, 0, barTime, 0, 0, (getTickCount() - tick)/500, 'Linear')
    antigoBarTime = barTime


    dxDrawText('Pressione a tecla', 569, 527, 122, 18, white, 1, fonts[2], 'center', 'center')

    dxDrawRoundedRectangle(x*580, y*549, x*100, y*100, tocolor(0, 0, 0, 0.7*255), 5)
    dxDrawText(string.upper(atualKey), 580, 549, 100, 100, white, 1, fonts[1], 'center', 'center')

    dxDrawRoundedRectangle(x*580, y*653, x*100, y*6, tocolor(0, 0, 0, 0.7*255), 2)
    dxDrawRoundedRectangle(x*580, y*653, x*anim, y*6, barColor, 2)
end

addEvent('startMinigame', true)
addEventHandler('startMinigame', root, function(event, elemento)
    if not isEventHandlerAdded('onClientRender', root, minigameRender) then 
        if not playingMinigame then 
            eventToExecute = event
            element = elemento
            addEventHandler('onClientRender', root, minigameRender)
            playingMinigame = true
            barTime = Config.startBarTime
            barColor = tocolor(0, 209, 255, 255)
            atualKey = Config.keys[math.random(1, #Config.keys)]
            timer[localPlayer] = setTimer(function()
                if barTime - 15 <= 0 then 
                    barColor = tocolor(255, 55, 55)
                    barTime = 100
                    killTimer(timer[localPlayer])
                    if element then
                        triggerServerEvent(eventToExecute, localPlayer, localPlayer, 'fail', element)
                    else
                        triggerServerEvent(eventToExecute, localPlayer, localPlayer, 'fail')
                    end
                    playingMinigame = false
                    setTimer(function()
                        removeEventHandler('onClientRender', root, minigameRender)
                        timer[localPlayer] = nil
                    end, 1000, 1)
                else
                    barTime = barTime - 15
                    tick = getTickCount()
                end
            end, 1000, 0)
        end
    end
end)

addEventHandler('onClientKey', root, function(k, s)
    if s then
        if playingMinigame == true then
            if atualKey == k then 
                if barTime + 15 >= 100 then
                    barColor = tocolor(55, 255, 75)
                    barTime = 100
                    killTimer(timer[localPlayer])
                    if element then
                        triggerServerEvent(eventToExecute, localPlayer, localPlayer, 'success', element)
                    else
                        triggerServerEvent(eventToExecute, localPlayer, localPlayer, 'success')
                    end
                    setTimer(function()
                        removeEventHandler('onClientRender', root, minigameRender)
                        playingMinigame = false
                        timer[localPlayer] = nil
                    end, 1000, 1)
                else
                    barTime = barTime + 15
                    atualKey = Config.keys[math.random(1, #Config.keys)]
                    tick = getTickCount()
                end
            else
                barColor = tocolor(255, 55, 55)
                barTime = 100
                killTimer(timer[localPlayer])
                if element then
                    triggerServerEvent(eventToExecute, localPlayer, localPlayer, 'fail', element)
                else
                    triggerServerEvent(eventToExecute, localPlayer, localPlayer, 'fail')
                end
                playingMinigame = false
                setTimer(function()
                    removeEventHandler('onClientRender', root, minigameRender)
                    timer[localPlayer] = nil
                end, 1000, 1)
            end
        end
    end
end)

function dxDrawRoundedRectangle(x, y, rx, ry, color, radius)
    rx = rx - radius * 2
    ry = ry - radius * 2
    x = x + radius
    y = y + radius
    if (rx >= 0) and (ry >= 0) then
        dxDrawRectangle(x, y, rx, ry, color)
        dxDrawRectangle(x, y - radius, rx, radius, color)
        dxDrawRectangle(x, y + ry, rx, radius, color)
        dxDrawRectangle(x - radius, y, radius, ry, color)
        dxDrawRectangle(x + rx, y, radius, ry, color)
        dxDrawCircle(x, y, radius, 180, 270, color, color, 7)
        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7)
    end
end

_dxDrawText = dxDrawText
function dxDrawText (text, sx, sy, sw, sh, ...)
    local sx, sy, sw, sh = x * sx, y * sy, x * sw, y * sh

    return _dxDrawText (text, sx, sy, (sx + sw), (sy + sh), ...)
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

function isCursorOnElement(x, y, w, h)
    if (not isCursorShowing()) then
        return false
    end
    local mx, my = getCursorPosition()
    local fullx, fully = guiGetScreenSize()
    cursorx, cursory = mx*fullx, my*fully
    if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
        return true
    else
        return false
    end
end