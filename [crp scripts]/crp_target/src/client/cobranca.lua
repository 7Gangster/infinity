local screenW, screenH = guiGetScreenSize()
local x, y = screenW/1920, screenH/1080

local element_target = nil
local painel_money = false
local cobranca = nil
local editing = false
local font = dxCreateFont('src/assets/fonts/Poppins-Regular.ttf', 12, false, 'default')
local value_gui = guiCreateEdit(-1000, -1000, 0, 0, '')
guiSetVisible(value_gui, false)
guiSetAlpha(value_gui, 0)


render_sendmoney = function()
    dxDrawRoundedRectangle(x*705, y*444, x*510, y*192, tocolor(46, 50, 62, 0.9*255), 10)

    dxDrawRoundedRectangle(x*736, y*479, x*448, y*62, tocolor(0, 0, 0, 0.31*255), 5)
    if guiGetText(value_gui) == '' then 
        dxDrawText('Insira o valor', 753, 479, 431, 59, white, 1, font, 'left', 'center')
    else
        dxDrawText(guiGetText(value_gui), 753, 479, 431, 59, white, 1, font, 'left', 'center')
    end

    dxDrawRoundedRectangle(x*736, y*547, x*448, y*58, isCursorOnElement(x*736, y*547, x*448, y*58) and tocolor(149, 239, 119, 0.9*255) or tocolor(149, 239, 119), 5)
    dxDrawText('ENVIAR COBRANÇA', 736, 547, 448, 58, tocolor(35, 41, 49), 1, font, 'center', 'center')
end

renderInfoCobranca = function()
    if cobranca then 
        local barra = interpolateBetween(0, 0, 0, 100, 0, 0, (getTickCount() - cobranca.tick)/10000, 'Linear')

        dxDrawRoundedRectangle(x*746, y*901, x*427, y*138, tocolor(33, 33, 33), 7)
        dxDrawText('O cidadão '..getPlayerName(cobranca.sender)..'#ffffff te enviou uma cobrança \n Valor: '..Config.Identidade.CorTemaHTML..'$'..cobranca.valor..'#FFFFFF\nPressione '..Config.Identidade.CorTemaHTML..'H #FFFFFFpara paga-lo', 778, 917, 363, 105, white, 1, font, 'center', 'center', false, true, false, true)
        dxDrawRectangle(x*746, y*1030, x*427/100*barra, y*10, tocolor(Config.Identidade.CorTemaRGB[1], Config.Identidade.CorTemaRGB[2], Config.Identidade.CorTemaRGB[3]))

        if (getTickCount() - cobranca.tick)/10000 >= 1 then 
            removeEventHandler('onClientRender', root, renderInfoCobranca)
            cobranca = nil
        end

    end
end



addEvent('interaction >> sendmoney:openpanel', true)
addEventHandler('interaction >> sendmoney:openpanel', root, function(target)
    if not painel_money then
        addEventHandler('onClientRender', root, render_sendmoney)
        painel_money = true
        guiSetText(value_gui, '')
        showCursor(true)
        element_target = target
    end
end)

addEventHandler('onClientKey', root, function(b, s)
    if painel_money then
        if b == 'backspace' and s then
            if editing then return end
            if not guiFocus(value_gui) then return print('Está editando o gui' ) end 
            removeEventHandler('onClientRender', root, render_sendmoney)
            painel_money = false
            showCursor(false)
        end
    end
    if b == 'h' and s then 
        if cobranca then 
            triggerServerEvent('accept >> cobranca', localPlayer, localPlayer, cobranca.sender, cobranca.valor)
            removeEventHandler('onClientRender', root, renderInfoCobranca)
            cobranca = nil
        end
    end
end)

addEvent('openInfoCobranca', true)
addEventHandler('openInfoCobranca', root, function(sender, valor)

    if not cobranca then
        addEventHandler('onClientRender', root, renderInfoCobranca)
        cobranca = {sender = sender, valor = valor, tick = getTickCount()}
    end

end)



addEventHandler('onClientClick', root, function(b, s)
    if b == 'left' and s == 'down' then 
        if painel_money then 
            if isCursorOnElement(x*736, y*479, x*448, y*62) then 
                guiFocus(value_gui)
                editing = true
                return true
            elseif isCursorOnElement(x*736, y*547, x*448, y*58) then
                if guiGetText(value_gui) ~= '' then 
                    if type(tonumber(guiGetText(value_gui))) == 'number' then 
                        triggerServerEvent('interaction >> sendcobranca', localPlayer, localPlayer, element_target, tonumber(guiGetText(value_gui)))
                        removeEventHandler('onClientRender', root, render_sendmoney)
                        painel_money = false
                        showCursor(false)
                    end
                end
            end
            editing = false
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