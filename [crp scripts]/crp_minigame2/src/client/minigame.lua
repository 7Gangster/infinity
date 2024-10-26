local screenW, screenH = guiGetScreenSize()

local fonts = {
    poppins_r12 = dxCreateFont('src/client/assets/fonts/Poppins-Regular.ttf', 12),
}

local miniWidth, miniHeight, centerSize = 110, 110, 25
local miniX, miniY = (screenW / 2 - miniWidth / 2), (screenH / 2 - miniHeight / 2)
local centerX, centerY = (screenW / 2 - centerSize / 2), (screenH / 2 - centerSize / 2)

local p_playingMiniGame = false
local tick

local m_type, m_theSpeed, m_theKey, m_theKey_choose
local m_markR, m_markerR, m_try

local speed 

local atual = 0
local fases

local function render()
    dxDrawImage(miniX, miniY, miniWidth, miniHeight, "src/client/assets/images/circle.png")
    dxDrawRoundedRectangle(centerX, centerY, centerSize, centerSize, tocolor(41, 47, 51), 5)
    dxDrawText(m_theKey, centerX + centerSize / 2 - dxGetTextWidth(m_theKey, 1, fonts.poppins_r12)/ 2, centerY + 3, centerSize, centerSize, tocolor(255, 255, 255), 1, fonts.poppins_r12)

    if m_markR >= 360 then
        m_try = m_try + 1
        m_markR = 0
    end
    m_markR = m_markR + m_theSpeed
    if m_try >= 2 then
        destroyMinigame()
    end
    dxDrawImage(miniX, miniY, 110, 110, "src/client/assets/images/"..m_type[1]..".png", m_markerR, 0, 0)
    dxDrawImage(miniX, miniY, 110, 110, "src/client/assets/images/mark.png", m_markR, 0, 0)
end

local eventToExecute, theElement

function createMiniGame(event, player, spd)
    if not isEventHandlerAdded("onClientRender", root, render) then
        if not p_playingMiniGame then
            eventToExecute = event
            theElement = player
            m_type = cache.markers[math.random(#cache.markers)]
            speed = spd or false
            m_theSpeed = math.random(2, 10)
            if speed then 
                fases = #speed or 2
                m_theSpeed = speed[1] or math.random(2, 10)
            else
                fases = 2
            end
            m_markR = 0
            m_try = 0
            atual = 1
            m_parts = 0
            m_markerR = math.random(0, 360)
            m_theKey_choose = math.random(1, 2)
            m_theKey = cache.keys[m_theKey_choose][math.random(#cache.keys[m_theKey_choose])]
            p_playingMiniGame = true
            toggleAllControls(false)
            setElementData(localPlayer, "class:blockAction", true)
            addEventHandler("onClientKey", root, keyToDo)
            addEventHandler("onClientRender", root, render)
        end
    end
end
addEvent("class:startMinigame", true)
addEventHandler("class:startMinigame", root, createMiniGame)

function destroyMinigame()
    removeEventHandler("onClientKey", root, keyToDo)
    removeEventHandler("onClientRender", root, render)
    p_playingMiniGame = false
    theElement = false
    eventToExecute = false
    toggleAllControls(true)
    setElementData(localPlayer, "class:blockAction", false)
end

function finishMinigame(type)
    if type == "success" then
        if theElement then
            triggerServerEvent(eventToExecute, localPlayer, localPlayer, 'success', theElement)
        else
            triggerServerEvent(eventToExecute, localPlayer, localPlayer, 'success')
        end
    elseif type == "fail" then
        if theElement then
            triggerServerEvent(eventToExecute, localPlayer, localPlayer, 'fail', theElement)
        else
            triggerServerEvent(eventToExecute, localPlayer, localPlayer, 'fail')
        end
    end
    destroyMinigame()
end

function keyToDo(button, press)
    if press then
        if p_playingMiniGame then
            if m_theKey == button then
                if m_markR >= m_markerR and m_markR <= m_markerR + m_type[2] then

                    local qSpeed = 2
                    if speed then 
                        qSpeed = #speed 
                    end
                    --if m_parts <= math.random(2, 3) then
                    if atual < (qSpeed or 2) then
                        m_type = cache.markers[math.random(#cache.markers)]
                        if not speed then 
                            m_theSpeed = math.random(2, 10)
                        else
                            m_theSpeed = speed[atual+1]
                        end
                        atual = atual +1
                        m_markR = 0
                        m_try = 0
                        m_parts = m_parts + 2
                        m_markerR = math.random(0, 360)
                        m_theKey = cache.keys[m_theKey_choose][math.random(#cache.keys[m_theKey_choose])]
                    else
                        finishMinigame('success')
                    end
                else
                    finishMinigame("fail")
                end
            else
                finishMinigame("fail")
            end
        end
    end
end


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