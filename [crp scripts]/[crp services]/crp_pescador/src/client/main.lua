local isca = false

local font = dxCreateFont('src/assets/Roboto.ttf', 12, false, 'default')

local icon = svgCreate(24, 24, [[
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <rect width="24" height="24" fill="url(#pattern0)"/>
    <defs>
    <pattern id="pattern0" patternContentUnits="objectBoundingBox" width="1" height="1">
    <use xlink:href="#image0_19_6" transform="scale(0.00195312)"/>
    </pattern>
    <image id="image0_19_6" width="512" height="512" xlink:href="data:image/png;base64,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"/>
    </defs>
    </svg>
]])
local bg = svgCreate(288, 51, [[
    <svg width="288" height="51" viewBox="0 0 288 51" fill="none" xmlns="http://www.w3.org/2000/svg">
    <rect x="0.5" y="0.5" width="287" height="50" rx="9.5" fill="#212121" stroke="url(#paint0_linear_19_4)"/>
    <defs>
    <linearGradient id="paint0_linear_19_4" x1="42" y1="-2.00001" x2="-8.50001" y2="47.5" gradientUnits="userSpaceOnUse">
    <stop stop-color="#A7A7A7"/>
    <stop offset="1" stop-color="#A7A7A7" stop-opacity="0"/>
    </linearGradient>
    </defs>
    </svg>
]])

addEventHandler('onClientClick', root, function(b, s, x, y, wordx, wordy, wordz, clickedElement)
    if b == 'left' and s == 'down' then 
        if getPlayerInZone() then
            if getPedWeapon(localPlayer) == 7 and not getElementData(localPlayer, 'pescando') then
                if testLineAgainstWater(wordx, wordy, wordz, wordx, wordy, wordz+500) then
                    wordx, wordy, wordz = getWorldFromScreenPosition ( x, y, 20)
                    if isLineOfSightClear(wordx, wordy, wordz, wordx, wordy, wordz+500) then
                        triggerServerEvent('comecarPescador', localPlayer, localPlayer)
                    end
                end
            end
        end
    end
end)

bindKey('backspace', 'down', function()
    if getElementData(localPlayer, 'pescando') then 
        setElementFrozen(localPlayer, false)
        setElementData(localPlayer, 'pescando', false)
        triggerServerEvent('setAnim', localPlayer, localPlayer)
    end
end)

addEvent('destroyIsca', true)
addEventHandler('destroyIsca', root, function()
	if isElement(isca) and isca then 
       destroyElement(isca)
       isca = false
    end
end)

rendermeta = function()
    if getElementData(localPlayer, 'pescador >> meta') and getElementData(localPlayer, 'pescador') then
        dxSetBlendMode( 'add' )
        dxDrawImage(1612, 20, 288, 51, bg)
        dxSetBlendMode( 'blend' )
        dxDrawText('Peixes pescados - '..(getElementData(localPlayer, 'peixes') or 0)..'/'..(getElementData(localPlayer, 'pescador >> meta') or 0), 1658, 28, 219, 34, white, 1, font, 'center', 'center')
        dxDrawImage(1624, 34, 24, 24, icon)
    end
end
addEventHandler('onClientRender', root, rendermeta)

function getPlayerInZone() 
    local b = false
    for i,v in ipairs(cfg.zonas) do
        local x, y, z = getElementPosition(localPlayer)
        if getDistanceBetweenPoints3D(x, y, z, v[1], v[2], v[3]) <= 100 then 
            b = true
        end
    end
    return b
end