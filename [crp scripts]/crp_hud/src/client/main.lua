local visible = false

local font1 = dxCreateFont('src/assets/Ubuntu-Medium.ttf', 12, false, 'default')
local font2 = dxCreateFont('src/assets/Ubuntu-Regular.ttf', 9, false, 'default')

local falando = false

local alpha = 0
local aumentando = true 
local diminuindo = false

local progressBar = false

createCircleStroke('velocimetro_bg', 74, 74, 6, -85)
createCircleStroke('velocimetro', 74, 74, 6, -85)
createCircleStroke('gas_bg', 50, 50, 6, -30)
createCircleStroke('gas', 50, 50, 6, -30)

local font = dxCreateFont('src/assets/Ubuntu-Regular.ttf', 10, false, 'default')

local strokes = {
    [1] = SVGCache:new(60, 60, 'polygon', {51, 255, 135}, false, false, 3),
    [2] = SVGCache:new(60, 60, 'polygon', {198, 198, 198}, false, false, 3),
    [3] = SVGCache:new(60, 60, 'polygon', {255, 154, 62}, false, false, 3),
    [4] = SVGCache:new(60, 60, 'polygon', {68, 154, 255}, false, false, 3),
    [5] = SVGCache:new(60, 60, 'polygon', {187, 2, 2}, false, false, 3),
    [6] = SVGCache:new(60, 60, 'polygon', {255, 248, 68}, false, false, 3),
    [7] = SVGCache:new(60, 60, 'polygon', {255, 255, 255}, false, false, 3),
    mic = SVGCache:new(60, 60, 'polygon', {255, 255, 255}, false, false, 3),
    mic_on = SVGCache:new(60, 60, 'polygon', {255, 255, 0}, false, false, 3),
    mic_on2 = SVGCache:new(60, 60, 'polygon', {0, 117, 255}, false, false, 3),
    --back = SVGCache:new(61, 61, 'polygon', {255, 255, 255}, false, false, 3),
}

local tick = {    
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
    [5] = 0,
    [6] = 0,
    [7] = 0,
    ['mick'] = 0,
}

local cache = {
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
    [5] = 0,
    [6] = 0,
}

local mic = 0


local antigo = {}
local valor = {}

local rot = 0

addEventHandler('onClientRender', root, function()


    dxDrawImage((1920-50-10), 15, 50, 50, 'src/assets/logo.png', 0, 0, 0, tocolor('FFFFFF', 30))

    if visible then 
        local voz = (getElementData(localPlayer, 'char:voice_modo') or 60)
        if mic ~= voz then 
            tick.mic = getTickCount() 
            antigo.mic = mic
            mic = voz
        end

        local mic = interpolateBetween(antigo.mic, 0, 0, voz, 0, 0, (getTickCount()-tick.mic)/1000, 'Linear')
        dxDrawImage(15, 1007, 60, 60, 'src/assets/bg.png')
        if falando then 
            if not getElementData(localPlayer, 'Class.Active') then 
                strokes['mic_on']:update(15+0.8, 1007.2, 255, mic)
                dxSetBlendMode('add')
                dxDrawImage((15+60/2-(22/2)), (1007+60/2-(22/2)), 22, 22, icons.mic, 0, 0, 0, tocolor('FFFF00'))
                dxSetBlendMode('blend')
            else
                strokes['mic_on2']:update(15+0.8, 1007.2, 255, mic)
                dxSetBlendMode('add')
                dxDrawImage((15+60/2-(22/2)), (1007+60/2-(22/2)), 22, 22, icons.radio, 0, 0, 0, tocolor('0377FF'))
                dxSetBlendMode('blend')
            end
        else
            if not getElementData(localPlayer, 'Class.Active') then 
                strokes['mic']:update(15+0.8, 1007.2, 255, mic)
                dxSetBlendMode('add')
                dxDrawImage((15+60/2-(22/2)), (1007+60/2-(22/2)), 22, 22, icons.mic, 0, 0, 0, tocolor('FFFFFF'))
                dxSetBlendMode('blend')
            else
                strokes['mic']:update(15+0.8, 1007.2, 255, mic)
                dxSetBlendMode('add')
                dxDrawImage((15+60/2-(22/2)), (1007+60/2-(22/2)), 22, 22, icons.radio, 0, 0, 0, tocolor('FFFFFF'))
                dxSetBlendMode('blend')
            end
        end

        if (getTickCount()-tick['mic'])/1000 >= 1 then 
            antigo['mic'] = mic or 0
            tick['mic'] = 0
        end

        local index = 0
        for i,v in ipairs(cache) do 
            --iprint(table.concat(cache, ', '))
            if cache[i] ~= getValue(i) then 
                tick[i] = getTickCount() 
                antigo[i] = v
                cache[i] = getValue(i)
            end

            valor[i] = interpolateBetween(antigo[i] or getValue(i), 0, 0, getValue(i), 0, 0, (getTickCount()-tick[i])/1000, 'Linear')

            if v > 0 and v < 100 then

                index = index + 1
                local x = (81 + (-66 + (66 * index)))

                if strokes[i] then 
                    dxDrawImage(x, 1007-0.5, 60, 60, 'src/assets/bg.png')
                    dxSetBlendMode('add')
                    dxDrawImage((x+60/2-(22/2)), (1007+60/2-(23/2)), 22, 22, icons[i])
                    dxSetBlendMode('blend')
                    strokes[i]:update(x+1.2, 1007.5, 255, valor[i])
                end

            end

            if (getTickCount()-tick[i])/1000 >= 1 then 
                cache[i] = valor[i]
                antigo[i] = getValue(i) or 0
                tick[i] = 0
            end

        end

        if isPedInVehicle(localPlayer) then
            local vehicle = getPedOccupiedVehicle(localPlayer) 
            local speed = math.floor(getElementSpeed(vehicle, 1) / 1.609344)
            local speedText = tostring(math.floor(speed))
            local formatSpeed = string.format("%03d", speedText)
            local value = 64.83
            
            setSVGOffset('velocimetro_bg', value)
            drawItem('velocimetro_bg', 252, 923, tocolor('FFFFFF', 40), true)
            setSVGOffset('velocimetro', value/250*speed)
            drawItem('velocimetro', 252, 923, tocolor('FFFFFF', 100), true)
    
            dxDrawText(formatSpeed, 260.79, 940.78, 55.23, 25.11, white, 1, font1, 'center', 'top')
            dxDrawText('MPH', 263.3, 963.38, 51.47, 18.83, white, 1, font2, 'center', 'top')
    
            local value = 66.72
            setSVGOffset('gas_bg', value)
            drawItem('gas_bg', 307.23, 945.89, tocolor('FFFFFF', 40), true)
            setSVGOffset('gas', value/100*(getElementData(vehicle, 'Fuel') or 50))
            drawItem('gas', 307.23, 945.89, tocolor('FFFFFF'), true)
    
            dxDrawImage(324.53, 960.67, 16, 16, icons.gas)
    
            if not getElementData(localPlayer, 'Cinto') then 
    
                if aumentando then 
                    alpha = alpha +1
                    if alpha >= 100 then 
                        alpha = 100
                        diminuindo = true 
                        aumentando = false
                    end
                elseif diminuindo then 
                    alpha = alpha -1
                    if alpha <= 0 then 
                        alpha = 0
                        diminuindo = false 
                        aumentando = true
                    end
                end
    
                dxDrawImage(356, 930, 20, 20, icons.cinto, 0, 0, 0, tocolor('FFFFFF', alpha))
            end
        end

    end

    if progressBar then 

        local barra = interpolateBetween(0, 0, 0, 100, 0, 0, (getTickCount()-progressBar.tick)/progressBar.time, 'OutQuad')
        local alpha = interpolateBetween(progressBar.alpha[1], 0, 0, progressBar.alpha[2], 0, 0, (getTickCount()-progressBar.alpha[3])/500, 'Linear')
        local alpha2 = interpolateBetween(progressBar.alpha[1], 0, 0, progressBar.alpha[2]-40, 0, 0, (getTickCount()-progressBar.alpha[3])/500, 'Linear')

        rot = rot + 1

        dxDrawImage(837, 968, 40, 40, icons.polygon, 0, 0, 0, tocolor('FFFFFF', alpha))
        dxDrawImage(847, 978, 20, 20, icons.clock, rot, 0, 0, tocolor('FFFFFF', alpha))

        -- barra
        dxDrawImageSection(892, 988, 179/100*100, 25, 0, 0, 179/100*100, 25, icons.progressbar,0, 0, 0, tocolor('000000', alpha2))
        dxDrawImageSection(892, 988, 179/100*barra, 25, 0, 0, 179/100*barra, 25, icons.progressbar, 0, 0, 0, tocolor('FFFFFF', alpha))

        dxDrawText(progressBar.text, (892+1), (960+1), 179, 15, tocolor('000000', alpha2), 1, font, 'center', 'top')
        dxDrawText(progressBar.text, 892, 960, 179, 15, tocolor('FFFFFF', alpha), 1, font, 'center', 'top')

        if progressBar.alpha[2] ~= 0 then 
            if (getTickCount()-progressBar.tick)/progressBar.time >= 1 then 
                progressBar.alpha = {100, 0, getTickCount()}
            end
        end

        if progressBar.alpha[2] == 0 then 
            if (getTickCount()-progressBar.alpha[3])/500 >= 1 then 
                progressBar = false
            end
        end
    end

end)

function getValue ( key )
    
    if cache[key] then 

        local key = tostring(key)

        if key == '1' then 
            return getElementHealth(localPlayer)
        elseif key == '2' then 
            return getPedArmor(localPlayer)
        elseif key == '3' then 
            return getElementData(localPlayer, 'fome') or 0
        elseif key == '4' then 
            return getElementData(localPlayer, 'sede') or 0
        elseif key == '6' then 
            return getElementData(localPlayer, 'Luck') or 0
        elseif key == '5' then 
            return getElementData(localPlayer, 'Stress') or 0
        elseif key == '7' then 
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if vehicle then 
                return getElementData(vehicle, 'Fuel') or 0
            end
        end

    end

    return 0
end

local voiceType = 3
local voiceState = {
    {2, 20},
    {5, 40},
    {10, 60},
    {15, 80},
    {20, 100},
}

addCommandHandler('Mudar tom de voz', function()
    if voiceType < #voiceState then 
        setElementData(localPlayer, 'char:voice', voiceState[voiceType+1][1])
        setElementData(localPlayer, 'char:voice_modo', voiceState[voiceType+1][2])
        voiceType = voiceType +1
    else
        setElementData(localPlayer, 'char:voice', voiceState[1][1])
        setElementData(localPlayer, 'char:voice_modo', voiceState[1][2])
        voiceType = 1
    end
end)

bindKey('f4', 'down', 'Mudar tom de voz')

addEventHandler('onClientPlayerVoiceStart', root, function()
    if source == localPlayer then 
        falando = true
    end
end)

addEventHandler('onClientPlayerVoiceStop', root, function()
    if source == localPlayer then 
        falando = nil
    end
end)

bindKey('f10', 'down', function()
    if getElementData(localPlayer, 'ID') then 
        setVisible(not visible)
        exports['crp_radar']:setVisible(not visible)
    end
end)

local components = { "area_name", "radio", "vehicle_name" }
function setHud()
    setPlayerHudComponentVisible("armour", false)
    setPlayerHudComponentVisible("wanted", false)
    setPlayerHudComponentVisible("weapon", false)
    setPlayerHudComponentVisible("money", false)
    setPlayerHudComponentVisible("health", false)
    setPlayerHudComponentVisible("clock", false)
    setPlayerHudComponentVisible("breath", false)
    setPlayerHudComponentVisible("ammo", false)
    setPlayerHudComponentVisible("radar", false)

    for _, component in ipairs( components ) do
        setPlayerHudComponentVisible( component, false )
    end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), setHud)


-- PROGRESSBAR

addEvent('ProgressBar', true)
addEventHandler('ProgressBar', root, function(time, text)
    if not progressBar then 
        progressBar = {
            tick = getTickCount(),
            time = time,
            text = text or 'Carregando...',
            alpha = {0, 100, getTickCount()},
        }
    end
end)

function getElementSpeed(theElement, unit)
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function setVisible ( state )
    visible = state
end
addEvent('setHudVisible', true)
addEventHandler('setHudVisible', root, setVisible)
addCommandHandler('hud', setVisible)
icons = {

    mic = svgCreate(16, 16, [[
        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
        <mask id="mask0_32_45" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="0" y="0" width="16" height="16">
        <rect width="16" height="16" fill="#FFFFFF"/>
        </mask>
        <g mask="url(#mask0_32_45)">
        <path d="M8.00016 9.3335C7.44461 9.3335 6.97239 9.13905 6.5835 8.75016C6.19461 8.36127 6.00016 7.88905 6.00016 7.3335V3.3335C6.00016 2.77794 6.19461 2.30572 6.5835 1.91683C6.97239 1.52794 7.44461 1.3335 8.00016 1.3335C8.55572 1.3335 9.02794 1.52794 9.41683 1.91683C9.80572 2.30572 10.0002 2.77794 10.0002 3.3335V7.3335C10.0002 7.88905 9.80572 8.36127 9.41683 8.75016C9.02794 9.13905 8.55572 9.3335 8.00016 9.3335ZM7.3335 14.0002V11.9502C6.17794 11.7946 5.22239 11.2779 4.46683 10.4002C3.71127 9.52238 3.3335 8.50016 3.3335 7.3335H4.66683C4.66683 8.25572 4.99183 9.04183 5.64183 9.69183C6.29183 10.3418 7.07794 10.6668 8.00016 10.6668C8.92239 10.6668 9.7085 10.3418 10.3585 9.69183C11.0085 9.04183 11.3335 8.25572 11.3335 7.3335H12.6668C12.6668 8.50016 12.2891 9.52238 11.5335 10.4002C10.7779 11.2779 9.82239 11.7946 8.66683 11.9502V14.0002H7.3335Z" fill="white"/>
        </g>
        </svg>
    ]]),

    [1] = svgCreate(16, 16, [[
        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
        <mask id="mask0_27_18" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="0" y="0" width="16" height="16">
        <rect width="16" height="16" fill="#FFFFFF"/>
        </mask>
        <g mask="url(#mask0_27_18)">
        <path d="M7.99992 13.9997L7.03325 13.133C5.91103 12.1219 4.98325 11.2497 4.24992 10.5164C3.51659 9.78302 2.93325 9.12469 2.49992 8.54136C2.06659 7.95802 1.76381 7.42191 1.59159 6.93302C1.41936 6.44414 1.33325 5.94414 1.33325 5.43302C1.33325 4.38858 1.68325 3.51636 2.38325 2.81636C3.08325 2.11636 3.95547 1.76636 4.99992 1.76636C5.5777 1.76636 6.1277 1.88858 6.64992 2.13302C7.17214 2.37747 7.62214 2.72191 7.99992 3.16636C8.3777 2.72191 8.8277 2.37747 9.34992 2.13302C9.87214 1.88858 10.4221 1.76636 10.9999 1.76636C12.0444 1.76636 12.9166 2.11636 13.6166 2.81636C14.3166 3.51636 14.6666 4.38858 14.6666 5.43302C14.6666 5.94414 14.5805 6.44414 14.4083 6.93302C14.236 7.42191 13.9333 7.95802 13.4999 8.54136C13.0666 9.12469 12.4833 9.78302 11.7499 10.5164C11.0166 11.2497 10.0888 12.1219 8.96658 13.133L7.99992 13.9997Z" fill="white"/>
        </g>
        </svg>
    ]]),

    [2] = svgCreate(16, 16, [[
        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
        <mask id="mask0_27_43" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="0" y="0" width="16" height="16">
        <rect width="16" height="16" fill="#FFFFFF"/>
        </mask>
        <g mask="url(#mask0_27_43)">
        <path d="M7.99984 14.6668C6.45539 14.2779 5.18039 13.3918 4.17484 12.0085C3.16928 10.6252 2.6665 9.08905 2.6665 7.40016V3.3335L7.99984 1.3335L13.3332 3.3335V7.40016C13.3332 9.08905 12.8304 10.6252 11.8248 12.0085C10.8193 13.3918 9.54428 14.2779 7.99984 14.6668Z" fill="white"/>
        </g>
        </svg>
    ]]),

    [3] = svgCreate(16, 16, [[
        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<mask id="mask0_27_55" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="0" y="0" width="16" height="16">
<rect width="16" height="16" fill="#FFFFFF"/>
</mask>
<g mask="url(#mask0_27_55)">
<path d="M2.66683 14C2.30016 14 1.98627 13.8694 1.72516 13.6083C1.46405 13.3472 1.3335 13.0333 1.3335 12.6667V10.6667H14.6668V12.6667C14.6668 13.0333 14.5363 13.3472 14.2752 13.6083C14.0141 13.8694 13.7002 14 13.3335 14H2.66683ZM8.00016 9C7.60016 9 7.2835 9.11111 7.05016 9.33333C6.81683 9.55556 6.38905 9.66667 5.76683 9.66667C5.14461 9.66667 4.72238 9.55556 4.50016 9.33333C4.27794 9.11111 3.96683 9 3.56683 9C3.16683 9 2.85016 9.11111 2.61683 9.33333C2.3835 9.55556 1.95572 9.66667 1.3335 9.66667V8.33333C1.7335 8.33333 2.05016 8.22222 2.2835 8C2.51683 7.77778 2.94461 7.66667 3.56683 7.66667C4.18905 7.66667 4.61127 7.77778 4.8335 8C5.05572 8.22222 5.36683 8.33333 5.76683 8.33333C6.16683 8.33333 6.4835 8.22222 6.71683 8C6.95016 7.77778 7.37794 7.66667 8.00016 7.66667C8.62238 7.66667 9.05016 7.77778 9.2835 8C9.51683 8.22222 9.8335 8.33333 10.2335 8.33333C10.6335 8.33333 10.9446 8.22222 11.1668 8C11.3891 7.77778 11.8113 7.66667 12.4335 7.66667C13.0557 7.66667 13.4946 7.77778 13.7502 8C14.0057 8.22222 14.3113 8.33333 14.6668 8.33333V9.66667C14.0446 9.66667 13.6279 9.55556 13.4168 9.33333C13.2057 9.11111 12.9002 9 12.5002 9C12.1002 9 11.7779 9.11111 11.5335 9.33333C11.2891 9.55556 10.8557 9.66667 10.2335 9.66667C9.61127 9.66667 9.1835 9.55556 8.95016 9.33333C8.71683 9.11111 8.40016 9 8.00016 9ZM1.3335 6.66667V6C1.3335 4.72222 1.93627 3.73611 3.14183 3.04167C4.34738 2.34722 5.96683 2 8.00016 2C10.0335 2 11.6529 2.34722 12.8585 3.04167C14.0641 3.73611 14.6668 4.72222 14.6668 6V6.66667H1.3335Z" fill="white"/>
</g>
</svg>

    ]]),

    [4] = svgCreate(16, 16, [[
        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<mask id="mask0_27_67" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="0" y="0" width="16" height="16">
<rect width="16" height="16" fill="#FFFFFF"/>
</mask>
<g mask="url(#mask0_27_67)">
<path d="M7.99984 14.3332C6.52206 14.3332 5.26373 13.8221 4.22484 12.7998C3.18595 11.7776 2.6665 10.5332 2.6665 9.0665C2.6665 8.3665 2.80262 7.69706 3.07484 7.05817C3.34706 6.41928 3.73317 5.85539 4.23317 5.3665L7.99984 1.6665L11.7665 5.3665C12.2665 5.85539 12.6526 6.41928 12.9248 7.05817C13.1971 7.69706 13.3332 8.3665 13.3332 9.0665C13.3332 10.5332 12.8137 11.7776 11.7748 12.7998C10.7359 13.8221 9.47761 14.3332 7.99984 14.3332Z" fill="white"/>
</g>
</svg>

    ]]),

    progressbar = svgCreate(179, 25, [[
        <svg width="179" height="25" viewBox="0 0 179 25" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M12.2603 0L22.878 6.25V18.75L12.2603 25L1.64256 18.75V6.25L12.2603 0Z" fill="white"/>
        <path d="M34.3289 0L44.9466 6.25V18.75L34.3289 25L23.7112 18.75V6.25L34.3289 0Z" fill="white"/>
        <path d="M56.3972 0L67.0149 6.25V18.75L56.3972 25L45.7795 18.75V6.25L56.3972 0Z" fill="white"/>
        <path d="M78.4658 0L89.0835 6.25V18.75L78.4658 25L67.8481 18.75V6.25L78.4658 0Z" fill="white"/>
        <path d="M100.534 0L111.152 6.25V18.75L100.534 25L89.9165 18.75V6.25L100.534 0Z" fill="white"/>
        <path d="M122.603 0L133.221 6.25V18.75L122.603 25L111.985 18.75V6.25L122.603 0Z" fill="white"/>
        <path d="M144.671 0L155.289 6.25V18.75L144.671 25L134.053 18.75V6.25L144.671 0Z" fill="white"/>
        <path d="M166.74 0L177.357 6.25V18.75L166.74 25L156.122 18.75V6.25L166.74 0Z" fill="white"/>
        </svg>
        
    ]]),

    polygon = svgCreate(36, 40, [[
        <svg width="36" height="40" viewBox="0 0 36 40" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M18 0L35.3205 10V30L18 40L0.679491 30V10L18 0Z" fill="white"/>
        </svg>
    ]]),

    clock = svgCreate(20, 20, [[
        <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<mask id="mask0_46_44" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="0" y="0" width="20" height="20">
<rect width="20" height="20" fill="#D9D9D9"/>
</mask>
<g mask="url(#mask0_46_44)">
<path d="M6.66659 16.6667H13.3333V14.1667C13.3333 13.2501 13.0069 12.4654 12.3541 11.8126C11.7013 11.1598 10.9166 10.8334 9.99992 10.8334C9.08325 10.8334 8.29853 11.1598 7.64575 11.8126C6.99297 12.4654 6.66659 13.2501 6.66659 14.1667V16.6667ZM3.33325 18.3334V16.6667H4.99992V14.1667C4.99992 13.3195 5.19784 12.5244 5.59367 11.7813C5.9895 11.0383 6.54159 10.4445 7.24992 10.0001C6.54159 9.55564 5.9895 8.96189 5.59367 8.21883C5.19784 7.47578 4.99992 6.68064 4.99992 5.83341V3.33341H3.33325V1.66675H16.6666V3.33341H14.9999V5.83341C14.9999 6.68064 14.802 7.47578 14.4062 8.21883C14.0103 8.96189 13.4583 9.55564 12.7499 10.0001C13.4583 10.4445 14.0103 11.0383 14.4062 11.7813C14.802 12.5244 14.9999 13.3195 14.9999 14.1667V16.6667H16.6666V18.3334H3.33325Z" fill="black"/>
</g>
</svg>

    ]]),
    
    [5] = svgCreate(16, 16, [[
        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<mask id="mask0_46_78" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="0" y="0" width="16" height="16">
<rect width="16" height="16" fill="#FFFFFF"/>
</mask>
<g mask="url(#mask0_46_78)">
<path d="M9.5 14C9.35556 14 9.21389 13.9861 9.075 13.9583C8.93611 13.9306 8.8 13.8889 8.66667 13.8333V2.16667C8.8 2.11111 8.93611 2.06944 9.075 2.04167C9.21389 2.01389 9.35556 2 9.5 2C10.0778 2 10.575 2.19444 10.9917 2.58333C11.4083 2.97222 11.6333 3.45 11.6667 4.01667C12.3222 4.10556 12.875 4.4 13.325 4.9C13.775 5.4 14 5.98889 14 6.66667C14 6.91111 13.9694 7.14444 13.9083 7.36667C13.8472 7.58889 13.7556 7.8 13.6333 8C13.7556 8.2 13.8472 8.41389 13.9083 8.64167C13.9694 8.86945 14 9.1 14 9.33333C14 10.0222 13.775 10.6139 13.325 11.1083C12.875 11.6028 12.3167 11.8944 11.65 11.9833C11.5944 12.5389 11.3639 13.0139 10.9583 13.4083C10.5528 13.8028 10.0667 14 9.5 14ZM6.5 14C5.93333 14 5.44444 13.8028 5.03333 13.4083C4.62222 13.0139 4.38889 12.5389 4.33333 11.9833C3.66667 11.8944 3.11111 11.6 2.66667 11.1C2.22222 10.6 2 10.0111 2 9.33333C2 9.1 2.03056 8.86945 2.09167 8.64167C2.15278 8.41389 2.24444 8.2 2.36667 8C2.24444 7.8 2.15278 7.58889 2.09167 7.36667C2.03056 7.14444 2 6.91111 2 6.66667C2 5.98889 2.22222 5.40278 2.66667 4.90833C3.11111 4.41389 3.66111 4.12222 4.31667 4.03333C4.35 3.46667 4.57778 2.98611 5 2.59167C5.42222 2.19722 5.92222 2 6.5 2C6.64444 2 6.78611 2.01667 6.925 2.05C7.06389 2.08333 7.2 2.12778 7.33333 2.18333V13.8333C7.2 13.8889 7.06389 13.9306 6.925 13.9583C6.78611 13.9861 6.64444 14 6.5 14Z" fill="white"/>
</g>
</svg>

    ]]),

    [6] = svgCreate(16, 16, [[
        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<mask id="mask0_46_84" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="0" y="0" width="16" height="16">
<rect width="16" height="16" fill="#FFFFFF"/>
</mask>
<g mask="url(#mask0_46_84)">
<path d="M7.34997 14V12.5667C6.76108 12.4333 6.25275 12.1778 5.82497 11.8C5.39719 11.4222 5.0833 10.8889 4.8833 10.2L6.11663 9.7C6.2833 10.2333 6.53052 10.6389 6.8583 10.9167C7.18608 11.1944 7.61663 11.3333 8.14997 11.3333C8.60552 11.3333 8.99163 11.2306 9.3083 11.025C9.62497 10.8194 9.7833 10.5 9.7833 10.0667C9.7833 9.67778 9.66108 9.36945 9.41663 9.14167C9.17219 8.91389 8.60552 8.65556 7.71663 8.36667C6.76108 8.06667 6.10552 7.70833 5.74997 7.29167C5.39441 6.875 5.21663 6.36667 5.21663 5.76667C5.21663 5.04444 5.44997 4.48333 5.91663 4.08333C6.3833 3.68333 6.86108 3.45556 7.34997 3.4V2H8.6833V3.4C9.23886 3.48889 9.69719 3.69167 10.0583 4.00833C10.4194 4.325 10.6833 4.71111 10.85 5.16667L9.61663 5.7C9.4833 5.34444 9.29441 5.07778 9.04997 4.9C8.80552 4.72222 8.47219 4.63333 8.04997 4.63333C7.56108 4.63333 7.18886 4.74167 6.9333 4.95833C6.67775 5.175 6.54997 5.44444 6.54997 5.76667C6.54997 6.13333 6.71663 6.42222 7.04997 6.63333C7.3833 6.84444 7.96108 7.06667 8.7833 7.3C9.54997 7.52222 10.1305 7.875 10.525 8.35833C10.9194 8.84167 11.1166 9.4 11.1166 10.0333C11.1166 10.8222 10.8833 11.4222 10.4166 11.8333C9.94997 12.2444 9.37219 12.5 8.6833 12.6V14H7.34997Z" fill="white"/>
</g>
</svg>

    ]]),

    [7] = svgCreate(16, 16, [[
        <svg width="17" height="17" viewBox="0 0 17 17" fill="none" xmlns="http://www.w3.org/2000/svg">
<mask id="mask0_114_7" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="0" y="0" width="17" height="17">
<rect x="0.349365" y="0.18042" width="16" height="16" fill="#D9D9D9"/>
</mask>
<g mask="url(#mask0_114_7)">
<path d="M3.01611 14.1804V3.51375C3.01611 3.14709 3.14667 2.8332 3.40778 2.57209C3.66889 2.31098 3.98278 2.18042 4.34945 2.18042H8.34945C8.71611 2.18042 9.03 2.31098 9.29111 2.57209C9.55222 2.8332 9.68278 3.14709 9.68278 3.51375V8.18042H10.3494C10.7161 8.18042 11.03 8.31098 11.2911 8.57209C11.5522 8.8332 11.6828 9.14709 11.6828 9.51375V12.5138C11.6828 12.7026 11.7467 12.861 11.8744 12.9888C12.0022 13.1165 12.1606 13.1804 12.3494 13.1804C12.5383 13.1804 12.6967 13.1165 12.8244 12.9888C12.9522 12.861 13.0161 12.7026 13.0161 12.5138V7.71375C12.9161 7.76931 12.8106 7.80542 12.6994 7.82209C12.5883 7.83875 12.4717 7.84709 12.3494 7.84709C11.8828 7.84709 11.4883 7.68598 11.1661 7.36375C10.8439 7.04153 10.6828 6.64709 10.6828 6.18042C10.6828 5.82486 10.78 5.50542 10.9744 5.22209C11.1689 4.93875 11.4272 4.73598 11.7494 4.61375L10.3494 3.21375L11.0494 2.51375L13.5161 4.91375C13.6828 5.08042 13.8078 5.27486 13.8911 5.49709C13.9744 5.71931 14.0161 5.94709 14.0161 6.18042V12.5138C14.0161 12.9804 13.855 13.3749 13.5328 13.6971C13.2106 14.0193 12.8161 14.1804 12.3494 14.1804C11.8828 14.1804 11.4883 14.0193 11.1661 13.6971C10.8439 13.3749 10.6828 12.9804 10.6828 12.5138V9.18042H9.68278V14.1804H3.01611ZM4.34945 6.84709H8.34945V3.51375H4.34945V6.84709ZM12.3494 6.84709C12.5383 6.84709 12.6967 6.7832 12.8244 6.65542C12.9522 6.52764 13.0161 6.36931 13.0161 6.18042C13.0161 5.99153 12.9522 5.8332 12.8244 5.70542C12.6967 5.57764 12.5383 5.51375 12.3494 5.51375C12.1606 5.51375 12.0022 5.57764 11.8744 5.70542C11.7467 5.8332 11.6828 5.99153 11.6828 6.18042C11.6828 6.36931 11.7467 6.52764 11.8744 6.65542C12.0022 6.7832 12.1606 6.84709 12.3494 6.84709Z" fill="white"/>
</g>
</svg>

    ]]),

    gas = svgCreate(16, 16, [[
        <svg width="17" height="17" viewBox="0 0 17 17" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M11.2428 14.9533H1.04318C0.762694 14.9533 0.533203 15.1827 0.533203 15.4632V16.4832C0.533203 16.7637 0.762694 16.9932 1.04318 16.9932H11.2428C11.5233 16.9932 11.7528 16.7637 11.7528 16.4832V15.4632C11.7528 15.1827 11.5233 14.9533 11.2428 14.9533ZM16.2533 4.09388L13.6716 1.51211C13.4739 1.31449 13.1488 1.31449 12.9512 1.51211L12.591 1.87228C12.3934 2.0699 12.3934 2.39501 12.591 2.59263L13.7927 3.79427V5.77362C13.7927 6.66928 14.4588 7.40875 15.3226 7.53305V12.6583C15.3226 13.0791 14.9784 13.4233 14.5576 13.4233C14.1369 13.4233 13.7927 13.0791 13.7927 12.6583V11.6384C13.7927 10.0893 12.5368 8.8335 10.9878 8.8335H10.7328V2.71375C10.7328 1.5886 9.81802 0.673828 8.69288 0.673828H3.59308C2.46794 0.673828 1.55316 1.5886 1.55316 2.71375V13.9333H10.7328V10.3634H10.9878C11.6922 10.3634 12.2627 10.934 12.2627 11.6384V12.5245C12.2627 13.7261 13.1233 14.8194 14.3186 14.9437C15.6892 15.0808 16.8526 14.0034 16.8526 12.6583V5.53776C16.8526 4.99591 16.6358 4.47636 16.2533 4.09388ZM8.69288 6.79358H3.59308V2.71375H8.69288V6.79358Z" fill="#F8F8F8"/>
</svg>

    ]]),

    cinto = svgCreate(21, 21, [[
        <svg width="21" height="21" viewBox="0 0 21 21" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M10.4112 0.567383C11.0292 0.567383 11.6218 0.778996 12.0588 1.15567C12.4958 1.53234 12.7413 2.04322 12.7413 2.57592C12.7413 3.69065 11.7044 4.58445 10.4112 4.58445C9.7932 4.58445 9.20054 4.37284 8.76356 3.99617C8.32658 3.61949 8.08109 3.10861 8.08109 2.57592C8.08109 2.04322 8.32658 1.53234 8.76356 1.15567C9.20054 0.778996 9.7932 0.567383 10.4112 0.567383ZM10.8655 13.412C12.5205 13.4064 14.1742 13.4903 15.817 13.663C15.8869 10.9314 15.6073 8.52118 15.0714 7.59725C14.9199 7.3261 14.7102 7.09512 14.4888 6.89427L5.08693 13.8438C6.67139 13.6229 8.66361 13.412 10.8655 13.412ZM5.12188 15.6314C5.27334 17.3788 5.57625 19.1463 6.06557 20.6527H8.47721C8.13934 19.769 7.89469 18.7346 7.70828 17.6399C7.70828 17.6399 10.4112 17.1981 13.1141 17.6399C12.9277 18.7346 12.683 19.769 12.3452 20.6527H14.7568C15.2694 19.0961 15.5723 17.2483 15.7238 15.4205C14.1117 15.2525 12.4893 15.1686 10.8655 15.1694C8.61701 15.1694 6.65974 15.3803 5.12188 15.6314ZM10.4112 5.58872C10.4112 5.58872 6.91605 5.58872 5.75101 7.59725C5.35489 8.28016 5.09858 9.75643 5.01703 11.5742L12.6481 5.93017C11.4947 5.58872 10.4112 5.58872 10.4112 5.58872ZM18.0655 4.25304L16.7374 2.91737L12.6481 5.94021C13.2888 6.13102 13.9646 6.4323 14.4888 6.89427L18.0655 4.25304ZM20.5121 14.4564C20.4073 14.4263 18.7296 13.9543 15.817 13.663C15.8053 14.2355 15.7704 14.828 15.7238 15.4205C18.3451 15.7017 19.848 16.1335 19.8713 16.1335L20.5121 14.4564ZM5.01703 11.5742L0.426758 14.9686L1.46365 16.4549C1.48695 16.4449 2.8384 15.9929 5.12188 15.6314C4.99373 14.2154 4.95878 12.8194 5.01703 11.5742Z" fill="#F24E1E"/>
        </svg>

    ]]),

    radio = svgCreate(16, 16, [[
        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<mask id="mask0_80_12" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="0" y="0" width="16" height="16">
<rect width="16" height="16" fill="#D9D9D9"/>
</mask>
<g mask="url(#mask0_80_12)">
<path d="M8 15.3333V13.9999H12.6667V13.3333H10V7.99992H12.6667V7.33325C12.6667 6.04436 12.2111 4.94436 11.3 4.03325C10.3889 3.12214 9.28889 2.66659 8 2.66659C6.71111 2.66659 5.61111 3.12214 4.7 4.03325C3.78889 4.94436 3.33333 6.04436 3.33333 7.33325V7.99992H6V13.3333H3.33333C2.96667 13.3333 2.65278 13.2027 2.39167 12.9416C2.13056 12.6805 2 12.3666 2 11.9999V7.33325C2 6.51103 2.15833 5.73603 2.475 5.00825C2.79167 4.28047 3.22222 3.64436 3.76667 3.09992C4.31111 2.55547 4.94722 2.12492 5.675 1.80825C6.40278 1.49159 7.17778 1.33325 8 1.33325C8.82222 1.33325 9.59722 1.49159 10.325 1.80825C11.0528 2.12492 11.6889 2.55547 12.2333 3.09992C12.7778 3.64436 13.2083 4.28047 13.525 5.00825C13.8417 5.73603 14 6.51103 14 7.33325V13.9999C14 14.3666 13.8694 14.6805 13.6083 14.9416C13.3472 15.2027 13.0333 15.3333 12.6667 15.3333H8Z" fill="white"/>
</g>
</svg>

    ]])


}

--[[
    ==========================
                FPS
    ==========================
]]

function fps ()
    if not getElementData(localPlayer, 'untoggle:hud') then 
        if getElementData(getLocalPlayer(), "FPS") then
            playerFPS = getElementData(getLocalPlayer(),"FPS")
        else
            playerFPS = 0
        end
    
        if getElementData(localPlayer, "FpsAtivado") == true then
            dxDrawText(""..playerFPS.." FPS", 11, 11, 10, 40, tocolor(0, 0, 0, 255), 1.0, 'default-bold', "left", "top", false, false, false, true, false)
            dxDrawText(""..playerFPS.." FPS", 10, 10, 10, 40, tocolor(255, 255, 255, 255), 1.0, 'default-bold', "left", "top", false, false, false, true, false)
        end

    end
end
addEventHandler('onClientRender', root, fps)

addCommandHandler( 'fps', function()
    setElementData(localPlayer, "FpsAtivado", not (getElementData(localPlayer, "FpsAtivado") or false))
end)

local counter = 0

addEventHandler("onClientRender", getRootElement(),
    function()
        if not starttick then
            starttick = getTickCount()
        end
        counter = counter + 1
        currenttick = getTickCount()
        if currenttick - starttick >= 1000 then
            setElementData(getLocalPlayer(), "FPS", counter)
            counter = 0
            starttick = false
        end
    end
)