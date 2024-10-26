local screenW, screenH = guiGetScreenSize()
local x, y = screenW/1920, screenH/1080

local font_title = dxCreateFont('src/assets/Bold.ttf', 30, false, 'default')
local font_subtitle = dxCreateFont('src/assets/Medium.ttf', 10, false, 'default')

local painel = false
local timer = {}
local morto = false

local imagens = {

    bg = svgCreate(1920, 1080, string.format([[
        <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="%s" height="%s" fill="url(#paint0_linear_124_4)" fill-opacity="0.7"/>
            <defs>
            <linearGradient id="paint0_linear_124_4" x1="9.95863e-06" y1="516.5" x2="1920" y2="540" gradientUnits="userSpaceOnUse">
            <stop stop-color="#FF3868"/>
            <stop offset="0.990015" stop-color="#8638B0" stop-opacity="0.526042"/>
            </linearGradient>
            </defs>
        </svg>
    ]],screenW, screenH, screenW, screenH, screenW, screenH)),

    skull = svgCreate(359, 383, [[
        <svg width="360" height="384" viewBox="0 0 360 384" fill="none" xmlns="http://www.w3.org/2000/svg">
            <mask id="mask0_124_11" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="0" y="0" width="360" height="384">
            <rect width="359.05" height="383.069" fill="#FFFFFF"/>
            </mask>
            <g mask="url(#mask0_124_11)">
            <path d="M89.7626 351.147V283.312C80.0383 278.789 71.4984 272.738 64.1429 265.156C56.7873 257.574 50.5538 248.995 45.4423 239.418C40.3309 229.842 36.4661 219.6 33.848 208.693C31.2299 197.786 29.9209 186.746 29.9209 175.574C29.9209 133.542 43.884 99.0927 71.8101 72.2246C99.7362 45.3565 135.641 31.9225 179.525 31.9225C223.409 31.9225 259.314 45.3565 287.24 72.2246C315.166 99.0927 329.129 133.542 329.129 175.574C329.129 186.746 327.82 197.786 325.202 208.693C322.584 219.6 318.719 229.842 313.608 239.418C308.496 248.995 302.263 257.574 294.907 265.156C287.552 272.738 279.012 278.789 269.288 283.312V351.147H89.7626ZM119.683 319.225H134.644V287.302H164.565V319.225H194.485V287.302H224.406V319.225H239.367V262.562C248.842 260.168 257.257 256.178 264.612 250.591C271.968 245.005 278.201 238.354 283.313 230.64C288.424 222.925 292.352 214.413 295.094 205.102C297.837 195.791 299.208 185.948 299.208 175.574C299.208 142.321 288.175 115.386 266.108 94.7698C244.042 74.1532 215.181 63.8449 179.525 63.8449C143.869 63.8449 115.008 74.1532 92.9417 94.7698C70.875 115.386 59.8417 142.321 59.8417 175.574C59.8417 185.948 61.2131 195.791 63.9558 205.102C66.6986 214.413 70.6257 222.925 75.7372 230.64C80.8486 238.354 87.1445 245.005 94.6247 250.591C102.105 256.178 110.458 260.168 119.683 262.562V319.225ZM157.084 239.418H201.966L179.525 191.535L157.084 239.418ZM127.164 207.496C135.392 207.496 142.436 204.37 148.295 198.119C154.155 191.867 157.084 184.352 157.084 175.574C157.084 166.795 154.155 159.28 148.295 153.028C142.436 146.777 135.392 143.651 127.164 143.651C118.935 143.651 111.892 146.777 106.032 153.028C100.173 159.28 97.2428 166.795 97.2428 175.574C97.2428 184.352 100.173 191.867 106.032 198.119C111.892 204.37 118.935 207.496 127.164 207.496ZM231.887 207.496C240.115 207.496 247.159 204.37 253.018 198.119C258.878 191.867 261.807 184.352 261.807 175.574C261.807 166.795 258.878 159.28 253.018 153.028C247.159 146.777 240.115 143.651 231.887 143.651C223.658 143.651 216.614 146.777 210.755 153.028C204.895 159.28 201.966 166.795 201.966 175.574C201.966 184.352 204.895 191.867 210.755 198.119C216.614 204.37 223.658 207.496 231.887 207.496Z" fill="white"/>
            </g>
        </svg>
    ]])

}

render = function()
    --background
    dxDrawRectangle(0, 0, screenW, screenH, tocolor(0, 0, 0, 150))
    dxSetBlendMode('add')
    dxDrawImage(0, 0, screenW, screenH, imagens.bg, 0, 0, 0, tocolor(255,255,255,2))
    dxSetBlendMode('blend')
    --content
    dxSetBlendMode('add')
    dxDrawImage(x*780, y*317, x*359, y*383, imagens.skull, 0, 0, 0)
    dxSetBlendMode('blend')
    dxDrawText('VOCE ESTA INCONSCIENTE', 635, 686, 649, 58, white, 1, font_title, 'center', 'center')

    if morto == true then 
        dxDrawText('USE #8000FF/GG#FFFFFF PARA RENASCER OU ESPERE UM PARAMEDICO', 655, 744, 603, 19, tocolor(255, 255, 255, 0.7*255), 1, font_subtitle, 'center', 'center', false, false, false, true)
    else
        local timer = math.round(getTimerDetails(timer[localPlayer])/1000)
        dxDrawText('CASO UM PARAMÉDICO NÃO CHEGUE EM #8000FF'..timer..'#ffffff SEGUNDOS VOCÊ VAI MORRER', 655, 744, 603, 19, tocolor(255, 255, 255, 0.7*255), 1, font_subtitle, 'center', 'center', false, false, false, true)
    end
end

addEvent('medic >> open', true)
addEventHandler('medic >> open', root, function()
    if not painel then 
        morto = false
        addEventHandler('onClientRender', root, render)
        painel = true
        showCursor(true)
        toggleAllControls(false)
        showChat(false)
        timer[localPlayer] = setTimer(function()
            morto = true
        end, 60000*Config.TempoMorrer, 1)
    else
        removeEventHandler('onClientRender', root, render)
        painel = false
        showCursor(false)
        showChat(true)
        toggleAllControls(true)
        killTimer(timer[localPlayer])
        setElementData(localPlayer, 'player >> caido', false)
    end
end)

addCommandHandler('gg', function()
    if morto then 
        removeEventHandler('onClientRender', root, render)
        painel = false
        showCursor(false)
        showChat(true)
        toggleAllControls(true)
        triggerServerEvent('medic >> spawn', localPlayer, localPlayer)
        morto = false
    end
end)

addCommandHandler('camera', function()
    local camera = { getCameraMatrix() }
    setClipboard(table.concat(camera, ', '))
end)

addEventHandler('onClientPlayerDamage', localPlayer, function()
    if getElementData(localPlayer, 'player >> caido') then 
        cancelEvent()
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

function math.round(num, decimals)
    decimals = math.pow(10, decimals or 0)
    num = num * decimals
    if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
    return num
end


blood = {}

addEvent('createBlood', true)
addEventHandler('createBlood', root, function(element, x, y, z, rz)
	if blood[element] then
        destroyElement(blood[element])
        blood[element] = nil
	end
    blood[element] = createEffect("blood_heli", x, y, z+0.5, 0, 0, rz, 4, true)
end)

addEvent('destroyBlood', true)
addEventHandler('destroyBlood', root, function(element)
	if blood[element] then 
		destroyElement(blood[element])
		blood[element] = nil
	end
end)