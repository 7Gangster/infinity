local page = 'inicio'
local tick = false
local code = 'jdfikyh3e7u4tyurt'
local timer = 0
local timerAbrindo = 0
local editando = false

local edit = guiCreateEdit(-1203, -346859, 0, 0, '')
guiSetVisible(edit, false)

local font = dxCreateFont('src/assets/UbuntuMono-Regular.ttf', 15)

local bg = svgCreate(895, 608, [[<svg width="895" height="608" viewBox="0 0 895 608" fill="none" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
<rect x="100" y="40" width="705" height="525" fill="black"/>
<rect y="608" width="608" height="895" transform="rotate(-90 0 608)" fill="url(#pattern0)"/>
<defs>
<pattern id="pattern0" patternContentUnits="objectBoundingBox" width="1" height="1">
<use xlink:href="#image0_3_13" transform="matrix(0.004089 0 0 0.00277778 -0.23602 0)"/>
</pattern>
<image id="image0_3_13" width="360" height="360" xlink:href="data:image/png;base64,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"/>
</defs>
</svg>
]])

renderHacker = function()
    local anim = interpolateBetween(1080, 0, 0, 236, 0, 0, (getTickCount()-tick)/1000, 'Linear')
    dxDrawImage(512, anim, 895, 608, 'src/assets/hacker.png')
    if page == 'inicio' then 
        if (getTickCount()-tick)/1000 >= 1 then 
            dxDrawText('Invadindo sistema . . .', 638, 530, 653, 20, tocolor(112, 255, 0), 1, font, 'center', 'center')
        end
    elseif page == 'content' then 
        dxDrawText(code, 875, 476, 170, 20, tocolor(112, 255, 0), 1, font, 'center', 'center')
        dxDrawRoundedRectangle(732, 521, 457, 45, 5, tocolor(255, 255, 255))
        dxDrawRoundedRectangle(733, 522, 455, 43, 5, tocolor(0, 0, 0))
        if guiGetText(edit) == '' then
            dxDrawText('Digite o código acima...', 733, 522, 455, 43, white, 1, font, 'center', 'center')
        else
            dxDrawText(guiGetText(edit), 733, 522, 455, 43, white, 1, font, 'center', 'center')
        end
        dxDrawText(math.round(getTimerDetails(timer)/1000, 1)..'s', 935, 590, 50, 20, white, 1, font, 'center', 'center')
    end
end

addEvent('hacker:start', true)
addEventHandler('hacker:start', resourceRoot, function()
    if not isEventHandlerAdded('onClientRender', root, renderHacker) then 
        toggleAllControls(false, false, true)
        showCursor(true)
        addEventHandler('onClientRender', root, renderHacker)
        page = 'inicio'
        tick = getTickCount()
        guiSetVisible(edit, true)
        timerAbrindo = setTimer(function()
            code = generateCode(15)
            guiFocus(edit)
            editando = true
            guiSetText(edit, '')
            page = 'content'
            timer = setTimer(function()
                if guiGetText(edit) == code then 
                    removeEventHandler('onClientRender', root, renderHacker)
                    page = 'inicio'
                    guiSetVisible(edit, false)
                    toggleAllControls(true, false, true)
                    editando = false
                    showCursor(false)
                    triggerServerEvent('endMission', localPlayer, localPlayer, 'hacker', 'success')
                else
                    removeEventHandler('onClientRender', root, renderHacker)
                    page = 'inicio'
                    guiSetVisible(edit, false)
                    toggleAllControls(true, false, true)
                    editando = false
                    showCursor(false)
                    triggerServerEvent('endMission', localPlayer, localPlayer, 'hacker', 'fail')
                end
            end, 15000, 1)
        end, 5000, 1)
    end
end)

bindKey('backspace', 'down', function()
    if isEventHandlerAdded('onClientRender', root, renderHacker) then 
        if page == 'content' then 
            if not editando then 
                removeEventHandler('onClientRender', root, renderHacker)
                page = 'inicio'
                toggleAllControls(true, false, true)
                guiSetVisible(edit, false)
                showCursor(false)
                triggerServerEvent('endMission', localPlayer, localPlayer, 'hacker', 'fail')
            end
        elseif page == 'inicio' then
            killTimer(timerAbrindo)
            timerAbrindo = nil 
            toggleAllControls(true, false, true)
            removeEventHandler('onClientRender', root, renderHacker)
            page = 'inicio'
            showCursor(false)
            guiSetVisible(edit, false)
            triggerServerEvent('endMission', localPlayer, localPlayer, 'hacker', 'fail')
        end
    end
end)

bindKey('enter', 'down', function()
    if editando then 
        if guiGetText(edit) == code then 
            removeEventHandler('onClientRender', root, renderHacker)
            page = 'inicio'
            guiSetVisible(edit, false)
            editando = false
            toggleAllControls(true, false, true)
            killTimer(timer)
            showCursor(false)
            timer = nil
            triggerServerEvent('endMission', localPlayer, localPlayer, 'hacker', 'success')
            -- recompensa
        else
            removeEventHandler('onClientRender', root, renderHacker)
            page = 'inicio'
            toggleAllControls(true, false, true)
            guiSetVisible(edit, false)
            showCursor(false)
            editando = false
            killTimer(timer)
            timer = nil
            triggerServerEvent('endMission', localPlayer, localPlayer, 'hacker', 'fail')
            -- voce falhou
        end
    end
end)

addEventHandler('onClientClick', root, function(b, s)
    if isEventHandlerAdded('onClientRender', root, renderHacker) then 
        if page == 'content' then 
            if b == 'left' and s == 'down' then 
                if isCursorOnElement(733, 522, 455, 43) then 
                    guiFocus(edit)
                    editando = true 
                else
                    editando = false
                end
            end
        end
    end
end)

function math.round(num, decimals)
    decimals = math.pow(10, decimals or 0)
    num = num * decimals
    if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
    return num / decimals
end

function generateCode(num)
    local keys = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", ";", "/", "#", "=" }
    local text = ''
    for i=1,num do
        local random = math.random(1, 2)
        if random == 1 then
            text = text..''..keys[math.random(1, #keys)] 
        else
            text = text..''..string.upper(keys[math.random(1, #keys)]) 
        end
    end
    return text
end