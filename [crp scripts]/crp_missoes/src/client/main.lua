local textLegenda = ''
local font = dxCreateFont('src/assets/Roboto.ttf', 15, false, 'default')
local anim = {}

local gradient = svgCreate(1920, 628, [[<svg width="1920" height="628" viewBox="0 0 1920 628" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect width="1920" height="628" fill="url(#paint0_linear_10_4)" fill-opacity="0.8"/>
<defs>
<linearGradient id="paint0_linear_10_4" x1="960" y1="628" x2="960" y2="239" gradientUnits="userSpaceOnUse">
<stop/>
<stop offset="1" stop-opacity="0"/>
</linearGradient>
</defs>
</svg>
]])

legendaRender = function()
    local animate = interpolateBetween(anim.from, 0, 0, anim.to, 0, 0, (getTickCount() - anim.tick)/anim.time, 'Linear')
    dxDrawImage(0, 452, 1920, 628, gradient, 0, 0, 0, tocolor(255, 255, 255, animate))
    dxDrawText(textLegenda, 278, 949, 1367, 99, tocolor(0, 0, 0, animate), 1, font, 'center', 'top', false, true)
    dxDrawText(textLegenda, 277, 948, 1367, 99, tocolor(255, 255, 255, animate), 1, font, 'center', 'top', false, true)
    if (getTickCount() - anim.tick)/anim.close >= 1 then 
        anim.from = 255
        anim.to = 0
        anim.tick = getTickCount()
        setTimer(function()
            removeEventHandler('onClientRender', root, legendaRender)
            anim = {}
            textLegenda = ''
        end, 700, 1)
    end
end


function createLegenda (text)
    local letras = {}
    for i = 1,#text do 
        table.insert(letras, string.sub(text, i, i))
    end
    return letras
end

function drawLegenda (text, time)
    local i = 0
    setTimer(function()
        i = i +1
        textLegenda = textLegenda..''..text[i]
    end, time/#text, #text)
end

addEvent('toggleLegenda', true)
addEventHandler('toggleLegenda', root, function(text, time, type, sound)
    if type == 'toggle' then
        if not isEventHandlerAdded('onClientRender', root, legendaRender) then
            textLegenda = ''
            drawLegenda (createLegenda (text), time)
            addEventHandler('onClientRender', root, legendaRender)
            anim = {
                from = 0,
                to = 255,
                tick = getTickCount(),
                time = 700,
                close = time+1000
            }
            if sound then 
                playSound(sound, false)
            end
        end
    elseif type == 'untoggle' then 
        if isEventHandlerAdded('onClientRender', root, legendaRender) then
            textLegenda = ''
            removeEventHandler('onClientRender', root, legendaRender)
            anim = {}
        end
    end
end)

