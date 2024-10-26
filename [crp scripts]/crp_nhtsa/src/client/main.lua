local vehicles = {
    {nome='NISSAN GTR', multas=1000, imposto=0, id=3, placa = 'CRP-9430', garagem=5},
    {nome='NISSAN GTR', multas=1000, imposto=0, id=3, placa = 'CRP-9430', garagem=0},
    {nome='NISSAN GTR', multas=1000, imposto=0, id=3, placa = 'CRP-9430', garagem=0},
    {nome='NISSAN GTR', multas=1000, imposto=0, id=3, placa = 'CRP-9430', garagem=0},
    {nome='NISSAN GTR', multas=1000, imposto=0, id=3, placa = 'CRP-9430', garagem=0},
    {nome='NISSAN GTR', multas=1000, imposto=0, id=3, placa = 'CRP-9430', garagem=0},

}

local selected = false

local font1 = dxCreateFont('src/assets/fonts/Roboto-Medium.ttf', 14, false, 'default')
local font2 = dxCreateFont('src/assets/fonts/Roboto-Regular.ttf', 12, false, 'default')
local font3 = dxCreateFont('src/assets/fonts/Roboto-Regular.ttf', 10, false, 'default')
local font4 = dxCreateFont('src/assets/fonts/Roboto-Medium.ttf', 10, false, 'default')
local font5 = dxCreateFont('src/assets/fonts/Roboto-Bold.ttf', 12, false, 'default')

local background = svgCreate(951, 366, [[
    <svg width="951" height="366" viewBox="0 0 951 366" fill="none" xmlns="http://www.w3.org/2000/svg">
    <rect width="950" height="1" transform="matrix(1 0 0 -1 0 48)" fill="#D9D9D9" fill-opacity="0.1"/>
    <rect width="366" height="1" transform="matrix(0 1 1 0 602 0)" fill="#D9D9D9" fill-opacity="0.1"/>
    <rect width="951" height="366" rx="10" fill="#26222A" fill-opacity="0.45"/>
    <rect x="0.5" y="0.5" width="950" height="365" rx="9.5" stroke="white" stroke-opacity="0.1"/>
    </svg>]]
)

local localize = svgCreate(24, 24, [[
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
    <mask id="mask0_64_326" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="0" y="0" width="24" height="24">
    <rect width="24" height="24" fill="#D9D9D9"/>
    </mask>
    <g mask="url(#mask0_64_326)">
    <path d="M12 12C12.55 12 13.0208 11.8042 13.4125 11.4125C13.8042 11.0208 14 10.55 14 10C14 9.45 13.8042 8.97917 13.4125 8.5875C13.0208 8.19583 12.55 8 12 8C11.45 8 10.9792 8.19583 10.5875 8.5875C10.1958 8.97917 10 9.45 10 10C10 10.55 10.1958 11.0208 10.5875 11.4125C10.9792 11.8042 11.45 12 12 12ZM12 19.35C14.0333 17.4833 15.5417 15.7875 16.525 14.2625C17.5083 12.7375 18 11.3833 18 10.2C18 8.38333 17.4208 6.89583 16.2625 5.7375C15.1042 4.57917 13.6833 4 12 4C10.3167 4 8.89583 4.57917 7.7375 5.7375C6.57917 6.89583 6 8.38333 6 10.2C6 11.3833 6.49167 12.7375 7.475 14.2625C8.45833 15.7875 9.96667 17.4833 12 19.35ZM12 22C9.31667 19.7167 7.3125 17.5958 5.9875 15.6375C4.6625 13.6792 4 11.8667 4 10.2C4 7.7 4.80417 5.70833 6.4125 4.225C8.02083 2.74167 9.88333 2 12 2C14.1167 2 15.9792 2.74167 17.5875 4.225C19.1958 5.70833 20 7.7 20 10.2C20 11.8667 19.3375 13.6792 18.0125 15.6375C16.6875 17.5958 14.6833 19.7167 12 22Z" fill="white"/>
    </g>
    </svg>
]])

local imposto = svgCreate(24, 24, [[
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
    <mask id="mask0_64_320" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="0" y="0" width="24" height="24">
    <rect width="24" height="24" fill="#D9D9D9"/>
    </mask>
    <g mask="url(#mask0_64_320)">
    <path d="M6 22C5.16667 22 4.45833 21.7083 3.875 21.125C3.29167 20.5417 3 19.8333 3 19V16H6V2H21V19C21 19.8333 20.7083 20.5417 20.125 21.125C19.5417 21.7083 18.8333 22 18 22H6ZM18 20C18.2833 20 18.5208 19.9042 18.7125 19.7125C18.9042 19.5208 19 19.2833 19 19V4H8V16H17V19C17 19.2833 17.0958 19.5208 17.2875 19.7125C17.4792 19.9042 17.7167 20 18 20ZM9 9V7H18V9H9ZM9 12V10H18V12H9ZM6 20H15V18H5V19C5 19.2833 5.09583 19.5208 5.2875 19.7125C5.47917 19.9042 5.71667 20 6 20ZM6 20H5H15H6Z" fill="white"/>
    </g>
    </svg>

]])

local button = svgCreate(267, 55, [[
    <svg width="267" height="55" viewBox="0 0 267 55" fill="none" xmlns="http://www.w3.org/2000/svg">
    <rect width="267" height="55" rx="10" fill="#26222A" fill-opacity="0.45"/>
    <rect x="0.5" y="0.5" width="266" height="54" rx="9.5" stroke="white" stroke-opacity="0.1"/>
    </svg>

]])



local slots = {
    382,
    428,
    474,
    520,
    566,
    612,
    658
}


render = function()
    dxDrawRoundedRectangle(397, 174, 1126, 732, 10, tocolor(40, 38, 43, 0.95*255))
    
    -- << cabeçalho >>
    dxDrawText('Seja bem vindo(a),', 447, 227, 348, 33, white, 1, font1, 'left', 'center')
    dxDrawText(getPlayerName(localPlayer), 447, 251, 348, 33, tocolor(153, 153, 153), 1, font2, 'left', 'center')
    dxDrawImage(1323, 240, 150, 39.53, 'src/assets/logo.png')

    -- << grid >>
    dxDrawImage(476, 335, 951, 366, background)
    dxDrawText('Veiculo', 476, 352, 603, 19, white, 1, font4, 'center', 'center')
    dxDrawText('Impostos ou multas', 1078, 352, 348, 19, white, 1, font4, 'center', 'center')

    for i,v in ipairs(vehicles) do 
        if i <= 7 then 
            dxDrawText(v.nome, 476, slots[i], 603, 43, white, 1, font3, 'center', 'center')
            dxDrawText('$'..((v.multas+v.imposto) or 0), 1078, slots[i], 348, 43, white, 1, font3, 'center', 'center')
            dxDrawRectangle(476, (slots[i]+43), 950, 1, tocolor(217, 217, 217, 0.1*255))
            if selected == i then 
                dxDrawRectangle(477, slots[i], 950, 43, tocolor(255, 255, 255, 0.1*255))
            end
        end
    end

    -- << down >>

    if selected then
        dxDrawRoundedRectangle(477, 736, 6, 24, 5, tocolor(143, 86, 216))
        dxDrawText('INFORMAÇÕES DO VEICULO', 491, 737, 277, 23, white, 1, font5, 'left', 'center')

        local status = 'Guardado na garagem '..vehicles[selected].garagem
        if vehicles[selected].garagem == 0 then 
            status = 'Em rua'
        end

        dxDrawText('Status: '..status..'\nPlaca: '..vehicles[selected].placa..'\nImpostos: $'..vehicles[selected].imposto..'\nMulta: $'..vehicles[selected].multas, 498, 774, 462, 86, white, 1, font3, 'left', 'top')

        dxDrawImage(1161, 736, 267, 55, button)
        dxDrawImage(1172, 752, 24, 24, localize)
        dxDrawText('Rastrear veiculo', 1161, 736, 267, 55, white, 1, font4, 'center', 'center')
        
        if (vehicles[selected].multas + vehicles[selected].imposto) > 0 then
            dxDrawImage(1161, 798, 267, 55, button)
            dxDrawImage(1172, 814, 24, 24, imposto)
            dxDrawText('Pagar impostos/multas', 1172, 798, 267, 55, white, 1, font4, 'center', 'center')
        end
    end

end

-- << ABRIR / FECHAR >>

addEvent('detran >> open',  true)
addEventHandler('detran >> open', root, function(table)
    if not isEventHandlerAdded('onClientRender', root, render) then 
        addEventHandler('onClientRender', root, render)
        showCursor(true)
        vehicles = table
    else
        removeEventHandler('onClientRender', root, render)
        showCursor(false)
    end
end)

bindKey('backspace', 'down', function()
    if isEventHandlerAdded('onClientRender', root, render) then 
        removeEventHandler('onClientRender', root, render)
        showCursor(false)
    end
end)

-- << CLICK EVENT >>

addEventHandler('onClientClick', root, function(b, s)
    if b == 'left' and s == 'down' then 
        if isEventHandlerAdded('onClientRender', root, render) then 
            for i,v in ipairs(vehicles) do 
                if i <= 7 then 
                    if isCursorOnElement(477, slots[i], 950, 43) then 
                        if selected ~= i then
                            selected = i
                        else
                            selected = false 
                        end
                        return true
                    end
                end
            end
            if selected then 
                if isCursorOnElement(1161, 736, 267, 55) then 
                    triggerServerEvent('detran >> rastrear', localPlayer, localPlayer, vehicles[selected].id)
                elseif isCursorOnElement(1161, 798, 267, 55) then 
                    if (vehicles[selected].multas + vehicles[selected].imposto) > 0 then
                        triggerServerEvent('detran >> pagartaxa', localPlayer, localPlayer, vehicles[selected].id)
                    end
                end
            end
        end
    end
end)