local table = {
    handlerAdded = false,
    window = 'inital',
    imagesFiles = {
        [1] = 'assets/images/base.png',
        [2] = 'assets/images/base2.png',
    },
    fonts = {
        [1] = dxCreateFont('assets/fonts/bold.ttf', 12),
        [2] = dxCreateFont('assets/fonts/bold.ttf', 10),
        [3] = dxCreateFont('assets/fonts/bold.ttf', 11),
    },
	animationPanel = {
        tickElement = 0,
        start = -1920,
        finish = 0
    },
    pos = {
        {816, 615, 89, 51, 'Cancelar', '2C2C2C', 'FFFFFF'},
        {916, 615, 89, 51, 'Dinheiro', '32AC9C', '26262C'},
        {1016, 615, 89, 51, 'Cartão', '32AC9C', '26262C'},
    },
}

local function open()
    dxSetBlendMode('modulate_add')

    if table.window == 'inital' then 
        dxDrawImage(800, 402, 320, 275, table.imagesFiles[1])
        dxDrawText('Cobrar Cliente', 800, 427, 320, 19, tocolor(255,255,255,255), 1, table.fonts[1], 'center', 'center', false)
        dxDrawText('Cliente #', 820, 472, 69, 16, tocolor(255,255,255,255), 1, table.fonts[1], 'center', 'center', false)
        createEditBox('class.passaport-client', 830, 500, 280, 20, {using = false, font = table.fonts[3], masked = false, onlynumber = true, textalign = 'center', maxcharacters = 4, othertext = 'Passaport', text = {255, 255, 255, 255}, selected = {222, 222, 222, 222}}, false)
        dxDrawText('Valor de cobrança $', 825, 549, 135, 16, tocolor(255,255,255,255), 1, table.fonts[1], 'center', 'center', false)
        createEditBox('class.valor-client', 830, 577, 280, 20, {using = false, font = table.fonts[3], masked = false, onlynumber = true, textalign = 'center', maxcharacters = 7, othertext = 'Valor de cobrança', text = {255, 255, 255, 255}, selected = {222, 222, 222, 222}}, false)
        for i,v in ipairs(table.pos) do 
            dxDrawImage(v[1], v[2], v[3], v[4], table.imagesFiles[2], 0,0,0, tocolor(v[6]))
            dxDrawText(v[5], v[1]+4, v[2]+11, 80, 30, tocolor(v[7]), 1, table.fonts[2], 'center', 'center', false)
        end
    end
    showCursor(true)

    dxSetBlendMode('blend')   
end

addEventHandler('onClientClick', root, function(press, state)
    if table.handlerAdded == true then
        if press == 'left' and state == 'up' then
            if table.window == 'inital' then
                for i,v in ipairs(table.pos) do 
                    if isCursorOnElement(v[1], v[2], v[3], v[4]) then
                        local passaport = dxGetEditBoxText('class.passaport-client')
                        local price = dxGetEditBoxText('class.valor-client')
                        if v[5] == 'Cancelar' then
                            closeMenu()
                        else
                            if passaport ~= '' and price ~= '' then
                                triggerServerEvent('class.informations', localPlayer, localPlayer, v[5], passaport, price)
								closeMenu()
                            else
                                iprint('insire informações')
                            end
                        end
                    end
                end
            end
        end
    end
end)

addEvent('class.openCash', true)
addEventHandler('class.openCash', root, function()
    if table.handlerAdded == false then
        table.handlerAdded = true
        addEventHandler('onClientRender', root, open, false, 'high')
        showCursor(true)
    else
        closeMenu()
    end
end)

function closeMenu()
    if table.handlerAdded == true then
        table.handlerAdded = false
        table.window = 'inital'
        removeEventHandler('onClientRender', root, open)
        showCursor(false)
    end
end
bindKey('backspace', 'down', closeMenu)