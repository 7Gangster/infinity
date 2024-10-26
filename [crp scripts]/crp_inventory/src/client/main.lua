local peso = 0
local pesoMax = 10

local qtd = guiCreateEdit(-1, -1, 0, 0, '')
local editing = false
guiSetVisible(qtd, false)
guiEditSetMaxLength(qtd, 7)

local fade = {}
local inventory = {}
local inventory2 = {}
local selected = nil
local selected2 = nil
local closing = false
inventory2.items = {}

local scrollData = {0, 0}

local slots = {
    {118, 213, 135, 135},
    {256, 213, 135, 135},
    {394, 213, 135, 135},
    {532, 213, 135, 135},
    {671, 213, 135, 135},

    {118, 352, 135, 135},
    {256, 352, 135, 135},
    {394, 352, 135, 135},
    {532, 352, 135, 135},
    {671, 352, 135, 135},

    {118, 491, 135, 135},
    {256, 491, 135, 135},
    {394, 491, 135, 135},
    {532, 491, 135, 135},
    {671, 491, 135, 135},

    {118, 630, 135, 135},
    {256, 630, 135, 135},
    {394, 630, 135, 135},
    {532, 630, 135, 135},
    {671, 630, 135, 135},

    {118, 769, 135, 135},
    {256, 769, 135, 135},
    {394, 769, 135, 135},
    {532, 769, 135, 135},
    {671, 769, 135, 135},
}

function renderInventory ( )

    local fading = interpolateBetween(fade[1], 0, 0, fade[2], 0, 0, (getTickCount()-fade[3])/fade[4], 'Linear')

    if cfg.client.blur then 
        cfg.client.blur:dxDrawBluredRectangle (0, 0, screen[1]+1, screen[2]+1, tocolor('FFFFFF', fading))
    end

    dxDrawRoundedRectangle(96, 155, 737, 771, 5, tocolor('1E1F2C', fading-5))
    dxDrawRoundedRectangle(1087, 155, 737, 771, 5, tocolor('1E1F2C', fading-5))

    -- Informações 
    dxDrawRectangle(119, 202, 689, 6, tocolor('181A22', fading))
    dxDrawRectangle(119, 202, 689/pesoMax*peso, 6, tocolor('FFFFFF', fading))
    dxDrawText('Jogador', 119, 173, 402, 27, tocolor('FFFFFF', fading), 1, font['poppins']['semibold'][20], 'left', 'top')
    dxDrawText(string.format("%.1f", tostring(peso))..'/'..pesoMax, 642, 173, 166, 26, tocolor('FFFFFF', fading), 1, font['poppins']['semibold'][16], 'right', 'top')


    local k = 0
    for i,v in ipairs(slots) do 
        -- Esquerda
        dxDrawRectangle(v[1], v[2], v[3], v[4], isCursorOnElement(v[1], v[2], v[3], v[4]) and tocolor('30313C', fading-50) or tocolor('30313C', fading-5))


        if cfg.client.actionBar then
            if i <= 4 and i >= 1 then
                if i > (scrollData[1] or 0) and i <= #slots then
                    dxDrawText(i, v[1], v[2], v[3], v[4], tocolor('272730', fading), 1, font['roboto']['regular'][40], 'center', 'center')
                end
            end
        end

        -- Direita

        local maxSlots = inventory2.slots or 50

        if i <= maxSlots then 
            dxDrawRectangle((v[1]+993), v[2], v[3], v[4], isCursorOnElement((v[1]+993), v[2], v[3], v[4]) and tocolor('30313C', fading-50) or tocolor('30313C', fading-5))
        end
    end

    for item,v in pairs(inventory) do 
        local i = (v.slot-scrollData[1]) 
        if i > 0 and i <= #slots then
            dxDrawRectangle((slots[i][1]), (slots[i][2]+130), 135/100*(v.health or 100), 5, tocolor(getHealthColor((v.health or 100)), fading))
            dxDrawImage((slots[i][1]+26), (slots[i][2]+27), 79, 79, 'src/assets/itens/'..v.item..'.png', 0, 0, 0, tocolor('FFFFFF', fading))
            dxDrawText(v.nome, (slots[i][1]+7), (slots[i][2]+7), 128, 18, tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12],'left', 'top')
            dxDrawText(v.qtd..'x', (slots[i][1]+16), (slots[i][2]+112), 128, 18, tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12], 'left', 'top')
            dxDrawText(string.format("%.1f", tostring(v.peso)), (slots[i][1]+75), (slots[i][2]+112), 45, 18, tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12], 'right', 'top')
        end
    end

    -- Scrollbar
    dxDrawRectangle(803, 213, 5, 691, tocolor('161820', fading))
    dxDrawRectangle(803, (212+(scrollData[1]/5*(691/5))), 5, (691/5), tocolor('393B41', fading))

    dxDrawRectangle(1796, 213, 5, 691, tocolor('161820', fading))
    dxDrawRectangle(1796, (212+(scrollData[2]/5*(691/5))), 5, (691/5), tocolor('393B41', fading))

    -- Meio 

    dxDrawRoundedRectangle (856, 398, 208, 214, 5, tocolor('1E1F2C', fading-5))

    dxDrawRectangle(872, 415, 176, 50, tocolor('444555', fading-5))
    if guiGetText(qtd) == '' then
        if editing then 
            dxDrawText('|', 872, 415, 176, 50, tocolor('FFFFFF', fading), 1, font['roboto']['regular'][12], 'center', 'center')
        else
            dxDrawText('Quantidade', 872, 415, 176, 50, tocolor('FFFFFF', fading), 1, font['roboto']['regular'][12], 'center', 'center')
        end
    else
        if editing then
            dxDrawText(guiGetText(qtd)..'|', 872, 415, 176, 50, tocolor('FFFFFF', fading), 1, font['roboto']['regular'][12], 'center', 'center')
        else
            dxDrawText(guiGetText(qtd), 872, 415, 176, 50, tocolor('FFFFFF', fading), 1, font['roboto']['regular'][12], 'center', 'center')
        end
    end
    dxDrawRectangle(872, 473, 176, 56, tocolor('444555', fading-5))
    dxDrawText('Usar', 872, 473, 176, 56, tocolor('FFFFFF', fading), 1, font['roboto']['regular'][12], 'center', 'center')
    dxDrawRectangle(872, 537, 176, 55, tocolor('444555', fading-5))
    dxDrawText('Enviar', 872, 537, 176, 55, tocolor('FFFFFF', fading), 1, font['roboto']['regular'][12], 'center', 'center')

    -- Direita

    if not inventory2.type then 
        dxDrawText('Chão', 1111, 173, 402, 27, tocolor('FFFFFF', fading), 1, font['poppins']['semibold'][20], 'left', 'top')
        local i = 0
        if inventory2.items then
            for item,v in ipairs(inventory2.items) do 
                if item > (scrollData[2]) and item < #slots then
                    i = i+1
                    dxDrawRectangle((slots[i][1]+993), (slots[i][2]+130), 135/100*(v.health or 100), 5, tocolor(getHealthColor((v.health or 100))))
                    dxDrawImage((slots[i][1]+26+993), (slots[i][2]+27), 79, 79, 'src/assets/itens/'..v.item..'.png', 0, 0, 0, tocolor('FFFFFF', fading))
                    dxDrawText(v.nome, (slots[i][1]+7+993), (slots[i][2]+7), 128, 18, tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12],'left', 'top')
                    dxDrawText(v.qtd..'x', (slots[i][1]+16+993), (slots[i][2]+112), 128, 18, tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12], 'left', 'top')
                    dxDrawText(string.format("%.1f", tostring(v.peso)), (slots[i][1]+75+993), (slots[i][2]+112), 45, 18, tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12], 'right', 'top')
                end
            end
        end
    elseif inventory2.type == 'Shop' then 
        local loja = inventory2.nome or 'Loja'
        dxDrawText(loja, 1111, 163, 402, 27, tocolor('FFFFFF', fading), 1, font['poppins']['semibold'][20], 'left', 'top')
        dxDrawText('Você tem #95EF77$ '..formatNumber(getItem('dinheiro'), '.')..'#bebebe para gastar.', 1111, 188, 402, 27, tocolor('bebebe', fading), 1, font['roboto']['regular'][12], 'left', 'top', false, false, false, true)
        local i = 0
        if inventory2.items then
            for item,v in ipairs(inventory2.items) do 
                if item > (scrollData[2]) and item < #slots then
                    i = i+1
                    dxDrawRectangle((slots[i][1]+993), (slots[i][2]+135-21), 135, 21, tocolor('1C2227', fading))
                    dxDrawText('$'..formatNumber(v.preco, '.'), (slots[i][1]+993), (slots[i][2]+135-21), 135, 21, tocolor('95EF77', fading), 1, font['roboto']['regular'][10], 'center', 'center')
                    dxDrawImage((slots[i][1]+26+993), (slots[i][2]+27), 79, 79, 'src/assets/itens/'..v.item..'.png', 0, 0, 0, tocolor('FFFFFF', fading))
                    dxDrawText(cfg.items[v.item].nome, (slots[i][1]+7+993), (slots[i][2]+7), 128, 18, tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12],'left', 'top')
                    dxDrawText(string.format("%.1f", tostring((cfg.items[v.item].peso or 0))), (slots[i][1]+75+993), (slots[i][2]+96), 45, 18, tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12], 'right', 'top')
                end
            end
        end
    elseif inventory2.type == 'Bau' then 
        dxDrawRectangle(1110, 202, 689, 6, tocolor('181A22', fading))
        dxDrawRectangle(1110, 202, 689/(inventory2.pesoMax or 0)*(inventory2.peso or 0), 6, tocolor('FFFFFF', fading))
        dxDrawText(string.format("%.1f", tostring((inventory2.peso or 0)))..'/'..(inventory2.pesoMax or 0), 1747, 173, 166, 26, tocolor('FFFFFF', fading), 1, font['poppins']['semibold'][16], 'left', 'top')
        dxDrawText(inventory2.name or 'Bau', 1111, 173, 402, 27, tocolor('FFFFFF', fading), 1, font['poppins']['semibold'][20], 'left', 'top')
        local i = 0
        if inventory2.items then
            for item,v in ipairs(inventory2.items) do 
                if item <= (inventory2.slots or 50) and item > (scrollData[2]) and i <= #slots then
                    i = i+1
                    if slots[i] then 
                        dxDrawRectangle((slots[i][1]+993), (slots[i][2]+130), 135/100*(v.health or 100), 5, tocolor(getHealthColor((v.health or 100))))
                        dxDrawImage((slots[i][1]+26+993), (slots[i][2]+27), 79, 79, 'src/assets/itens/'..v.item..'.png', 0, 0, 0, tocolor('FFFFFF', fading))
                        dxDrawText(v.nome, (slots[i][1]+7+993), (slots[i][2]+7), 128, 18, tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12],'left', 'top')
                        dxDrawText(v.qtd..'x', (slots[i][1]+16+993), (slots[i][2]+112), 128, 18, tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12], 'left', 'top')
                        dxDrawText(string.format("%.1f", tostring(v.peso)), (slots[i][1]+75+993), (slots[i][2]+112), 45, 18, tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12], 'right', 'top')
                    end
                end
            end
        end
    elseif inventory2.type == 'Revist' then 
        dxDrawRectangle(1110, 202, 689, 6, tocolor('181A22', fading))
        dxDrawRectangle(1110, 202, 689/(inventory2.pesoMax or 0)*(inventory2.peso or 0), 6, tocolor('FFFFFF', fading))
        dxDrawText(string.format("%.1f", tostring((inventory2.peso or 0)))..'/'..(inventory2.pesoMax or 0), 1747, 173, 166, 26, tocolor('FFFFFF', fading), 1, font['poppins']['semibold'][16], 'left', 'top')
        dxDrawText(string.gsub(getPlayerName(inventory2.element), '_', ' '), 1111, 173, 402, 27, tocolor('FFFFFF', fading), 1, font['poppins']['semibold'][20], 'left', 'top')
        local i = 0
        if inventory2.items then
            for item,v in ipairs(inventory2.items) do 
                if item > (scrollData[2]) and item < #slots then
                    i = i+1
                    dxDrawRectangle((slots[i][1]+993), (slots[i][2]+130), 135/100*(v.health or 100), 5, tocolor(getHealthColor((v.health or 100))))
                    dxDrawImage((slots[i][1]+26+993), (slots[i][2]+27), 79, 79, 'src/assets/itens/'..v.item..'.png', 0, 0, 0, tocolor('FFFFFF', fading))
                    dxDrawText(v.nome, (slots[i][1]+7+993), (slots[i][2]+7), 128, 18, tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12],'left', 'top')
                    dxDrawText(v.qtd..'x', (slots[i][1]+16+993), (slots[i][2]+112), 128, 18, tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12], 'left', 'top')
                    dxDrawText(string.format("%.1f", tostring(v.peso)), (slots[i][1]+75+993), (slots[i][2]+112), 45, 18, tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12], 'right', 'top')
                end
            end
        end
    end

    if fade[2] ~= 0 then
        for i,v in ipairs(slots) do 
            if isCursorOnElement( v[1], v[2], v[3], v[4] ) then 
                if getItemFromSlot ( i+scrollData[1] ) then
                    if not selected then
                        local x, y = (v[1]+54), (v[2]-119)
                        local item = inventory[getItemFromSlot ( i+scrollData[1] )]
                        dxDrawRoundedRectangle(x, y, 326, 139, 5, tocolor('20202D'))
                        dxDrawText(item.nome, (x+17), (y+20), 290, 37, white, 1, font['poppins']['semibold'][20], 'left', 'top')
                        dxDrawRectangle((x+19), (y+57), 288, 2, tocolor('464753'))
                        local text = 'Peso: '..item.peso..' | Qualidade: '..item.health
                        if item.vehicle then 
                            text = 'Veiculo: '..item.vehicle..' | '..text
                        end
                        if item.owner then 
                            text = 'Dono: '..item.owner..' | '..text
                        end
                        dxDrawText(text, (x+19), (y+64), 288, 100, tocolor('bebebe'), 1, font['poppins']['regular'][12], 'left', 'top', false, true, false)
                        local desc = 'Descrição:'
                        if item.desc then
                            desc = item.desc
                        end
                        dxDrawText(desc, (x+19), (y+64) + 12, 288, 100, tocolor('bebebe'), 1, font['poppins']['regular'][12], 'left', 'top', false, true, false)
                    end
                    break
                end
            end
            if isCursorOnElement( (v[1]+993), v[2], v[3], v[4] ) then 
                if getItemFromSlot2 ( i+scrollData[1] ) then
                    if not selected2 then
                        if not inventory2.type or inventory2.type == 'Bau' then
                            local x, y = (v[1]+993+54), (v[2]-119)
                            local item = inventory2.items[getItemFromSlot2 ( i+scrollData[1] )]
                            dxDrawRoundedRectangle(x, y, 326, 139, 5, tocolor('20202D'))
                            dxDrawText(item.nome, (x+17), (y+20), 290, 37, white, 1, font['poppins']['semibold'][20], 'left', 'top')
                            dxDrawRectangle((x+19), (x+57), 288, 2, tocolor('464753'))
                            local text = 'Peso: '..item.peso..' | Qualidade: '..item.health
                            if item.vehicle then 
                                text = 'Veiculo: '..item.vehicle..' | '..text
                            end
                            if item.owner then 
                                text = 'Dono: '..item.owner..' | '..text
                            end
                            dxDrawText(text, (x+19), (y+64), 288, 100, tocolor('bebebe'), 1, font['poppins']['regular'][12], 'left', 'top', false, true, false)
                        end
                    end
                end
                break
            end
        end
    end

    -- Arrastando
    local mx, my = getCursorPosition ()
    local fullx, fully = guiGetScreenSize ()
    local cursorx, cursory = (mx*1920)-(sx*135/2), (my*1080)-(sx*135/2)
    if selected then
        local i = selected.item
        _dxDrawRectangle(sx*cursorx, sy*cursory, sx*135, sy*135, tocolor('30313C', fading)) 
        _dxDrawRectangle(sx*(cursorx), sy*(cursory+130), sx*135/100*(i.health or 0), sy*5, tocolor(getHealthColor((i.health or 0)), fading))
        _dxDrawImage(sx*(cursorx+26), sy*(cursory+27), sx*79, sy*79, 'src/assets/itens/'..i.img..'.png', 0, 0, 0, tocolor('FFFFFF', fading))
        _dxDrawText(i.nome, sx*(cursorx+7), sy*(cursory+7), sx*(128+cursorx+7), sy*(18+cursory+7), tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12],'left', 'top')
        _dxDrawText(i.qtd..'x', sx*(cursorx+16), sy*(cursory+112), sx*(128+cursorx+16), sy*(18+cursory+112), tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12], 'left', 'top')
        _dxDrawText(string.format("%.1f", tostring(i.peso)), sx*(cursorx+75), sy*(cursory+112), sx*(45+cursorx+75), sy*(18+cursory+112), tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12], 'right', 'top')
    elseif selected2 then 
        if inventory2.type == 'Shop' then 
            _dxDrawRectangle(sx*cursorx, sy*cursory, sx*135, sy*135, tocolor('30313C', fading)) 
            _dxDrawRectangle(sx*(cursorx), sy*(cursory+135-21), sx*135, sy*21, tocolor('1C2227', fading))
            _dxDrawText('$'..formatNumber(selected2.item.preco, '.'), sx*(cursorx), sy*(cursory+135-21), sx*(135+cursorx), sy*(21+cursory+135-21), tocolor('95EF77', fading), 1, font['roboto']['regular'][10], 'center', 'center')
            _dxDrawImage(sx*(cursorx+26), sy*(cursory+27), sx*79, sy*79, 'src/assets/itens/'..selected2.item.img..'.png', 0,0,0, tocolor('FFFFFF', fading))
            _dxDrawText(selected2.item.nome, sx*(cursorx+7), sy*(cursory+7), sx*(128+cursorx+7), sy*(18+cursory+7), tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12],'left', 'top')
            --_dxDrawText(i.qtd..'x', sx*(cursorx+16), sy*(cursory+112), sx*(128+cursorx+16), sy*(18+cursory+112), tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12], 'left', 'top')
            _dxDrawText(string.format("%.1f", tostring(selected2.item.peso or 0)), sx*(cursorx+75), sy*(cursory+96), sx*(45+cursorx+75), sy*(18+cursory+96), tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12], 'right', 'top')
        else 
            local i = selected2.item
            _dxDrawRectangle(sx*cursorx, sy*cursory, sx*135, sy*135, tocolor('30313C', fading)) 
            _dxDrawRectangle(sx*(cursorx), sy*(cursory+130), sx*135/100*(i.health or 0), sy*5, tocolor(getHealthColor((i.health or 0)), fading))
            _dxDrawImage(sx*(cursorx+26), sy*(cursory+27), sx*79, sy*79, 'src/assets/itens/'..i.img..'.png', 0, 0, 0, tocolor('FFFFFF', fading))
            _dxDrawText(i.nome, sx*(cursorx+7), sy*(cursory+7), sx*(128+cursorx+7), sy*(18+cursory+7), tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12],'left', 'top')
            _dxDrawText(i.qtd..'x', sx*(cursorx+16), sy*(cursory+112), sx*(128+cursorx+16), sy*(18+cursory+112), tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12], 'left', 'top')
            _dxDrawText(string.format("%.1f", tostring(i.peso)), sx*(cursorx+75), sy*(cursory+112), sx*(45+cursorx+75), sy*(18+cursory+112), tocolor('FFFFFF', fading), 1, font['poppins']['regular'][12], 'right', 'top')
        end
    end



end

addCommandHandler('Abrir/fechar inventario', function ()
    if not getElementData(localPlayer, 'ID') then return end
    if not isEventHandlerAdded('onClientRender', root, renderInventory) then 
        triggerServerEvent('openInv', localPlayer, localPlayer)
        exports.crp_hud:setVisible(false)
        addEventHandler('onClientRender', root, renderInventory)
        scrollData = {0, 0}
        showCursor(true)
        fade = {0, 100, getTickCount(), 300}
    else
        if not editing and not closing then 
            fade = {100, 0, getTickCount(), 300}
            if inventory2.type == 'Bau' then
                triggerServerEvent('closeBau', localPlayer, localPlayer, inventory2.element)
            end
            closing = setTimer(function ( )
                removeEventHandler('onClientRender', root, renderInventory)
                showCursor(false)
                triggerServerEvent('updateServerData', localPlayer, localPlayer, inventory)
                inventory2 = {}
                closing = false
            end, 300, 1)
            exports.crp_hud:setVisible(true)
        end
    end
end)
bindKey("'", 'down', 'Abrir/fechar inventario')

addEvent('openShop', true)
addEventHandler('openShop', root, function ( items, nome, bs )
    if not isEventHandlerAdded('onClientRender', root, renderInventory) then 
        triggerServerEvent('updateItems', localPlayer, localPlayer)
        addEventHandler('onClientRender', root, renderInventory)
        showCursor(true)
        fade = {0, 100, getTickCount(), 300}
    end
    scrollData = {0, 0}
    inventory2 = {
        type = 'Shop',
        buy_or_sell = bs,
        nome = nome,
        items = items
    }
end)

addEvent('openBau', true)
addEventHandler('openBau', root, function ( id, items, peso, pesoMax, element, assets )
    if not isEventHandlerAdded('onClientRender', root, renderInventory) then 
        triggerServerEvent('updateItems', localPlayer, localPlayer)
        addEventHandler('onClientRender', root, renderInventory)
        showCursor(true)
        fade = {0, 100, getTickCount(), 300}
    end
    scrollData = {0, 0}
    local assets = assets or {}
    inventory2 = {
        id = id,
        type = 'Bau',
        name = assets.name or 'Bau',
        slots = assets.slots or 50,
        element = element,
        peso = peso,
        pesoMax = pesoMax,
        items = items
    }
end)

addEvent('openRevistar', true)
addEventHandler('openRevistar', root, function ( items, peso, pesoMax, element )
    if not isEventHandlerAdded('onClientRender', root, renderInventory) then 
        addEventHandler('onClientRender', root, renderInventory)
        showCursor(true)
        fade = {0, 100, getTickCount(), 300}
        triggerServerEvent('updateItems', localPlayer, localPlayer)
    end
    scrollData = {0, 0}
    setTimer(function()
        inventory2 = {
            type = 'Revist',
            element = element,
            peso = peso,
            pesoMax = pesoMax,
            items = items
        }
    end, 1000, 1)
end)

addEvent('updateInventory2', true)
addEventHandler('updateInventory2', root, function ( items, peso, pesoMax, type )
    if peso then 
        inventory2.peso = peso
    end
    if pesoMax then 
        inventory2.pesoMax = pesoMax
    end
    if items then 
        inventory2.items = items
    end
end)

addEventHandler('onClientClick', root, function(b, s)
    if isEventHandlerAdded('onClientRender', root, renderInventory) then 
        if b == 'left' and s == 'down' then 
            if isCursorOnElement(872, 415, 176, 50) then 
                guiFocus(qtd)
                editing = true
                return true
            end
            for item,v in ipairs(inventory) do 
                local i = (v.slot-scrollData[1]) 
                if i > 0 and i <= #slots then
                    if isCursorOnElement(slots[i][1], slots[i][2], slots[i][3], slots[i][4]) then 
                        selected = {
                            slot = v.slot, 
                            item = {
                                index = item,
                                id = v.id,
                                nome = v.nome,
                                qtd = v.qtd,
                                peso = v.peso,
                                owner = v.owner or false,
                                vehicle = v.vehicle or false,
                                img = v.item,
                                health = v.health
                            }
                        }
                    end
                end
            end
            local k = 0
            if inventory2.items then
                for item,v in ipairs(inventory2.items) do 
                    if item > (scrollData[2]) and item < #slots then
                        k = k+1
                        if isCursorOnElement(slots[k][1]+993, slots[k][2], slots[k][3], slots[k][4]) then 
                            if inventory2.type == 'Shop' then
                                selected2 = {
                                    slot = k, 
                                    item = {
                                        nome = cfg.items[v.item].nome,
                                        preco = v.preco,
                                        peso = cfg.items[v.item].peso,
                                        img = v.item,
                                    }
                                }
                            else
                                selected2 = {
                                    slot = k, 
                                    item = {
                                        nome = v.nome,
                                        qtd = v.qtd,
                                        peso = v.peso,
                                        img = v.item,
                                        vehicle = v.vehicle or false,
                                        owner = v.owner or false,
                                        id = v.id,
                                        health = v.health
                                    }
                                }
                            end
                        end
                    end
                end
            end
            editing = false
        elseif b == 'left' and s == 'up' then 
            if selected then 
                for i,v in ipairs(slots) do 
                    if isCursorOnElement(v[1], v[2], v[3], v[4]) then
                        if not getItemFromSlot ( i+scrollData[1] ) then 
                            inventory[selected.item.index].slot = i+scrollData[1]
                        else
                            inventory[selected.item.index].slot = i+scrollData[1]
                            inventory[getItemFromSlot ( i+scrollData[1] )].slot = selected.slot
                        end
                        triggerServerEvent("updateSlots", localPlayer, localPlayer, selected.item.index, inventory[selected.item.index].slot)
                    end
                end
                if isCursorOnElement(1111, 213, 685, 691) then 
                    -- Passar pro lado direito
                    if inventory2.type == 'Bau' then 
                        triggerServerEvent('addItemBau', localPlayer, localPlayer, inventory2.id, selected.item, getQuantity ( ))
                    elseif inventory2.type == 'Shop' then 
                        if inventory2.buy_or_sell == 'sell' then 
                            triggerServerEvent('buyorsell', localPlayer, localPlayer, inventory2.buy_or_sell, selected2.item.img, getQuantity(), getQuantity()*selected2.item.preco)
                        end
                    end
                    if not inventory2.type then 
                        triggerServerEvent('dropItem', localPlayer, localPlayer, selected.item, getQuantity())
                    end
                elseif isCursorOnElement(872, 473, 176, 56) then 
                    triggerServerEvent('useItem', localPlayer, localPlayer, selected.item.img, getQuantity(), selected.item)
                elseif isCursorOnElement(872, 537, 176, 55) then 
                    triggerServerEvent('sendItem', localPlayer, localPlayer, selected.item, getQuantity())
                end
                selected = nil
            elseif selected2 then 
                if inventory2.type == 'Shop' then 
                    if isCursorOnElement(118, 213, 685, 691) then 
                        if inventory2.buy_or_sell == 'buy' then 
                            triggerServerEvent('buyorsell', localPlayer, localPlayer, inventory2.buy_or_sell, selected2.item.img, getQuantity(), getQuantity()*selected2.item.preco)
                        end
                    end
                else
                    if isCursorOnElement(118, 213, 685, 691) then 
                        if inventory2.type == 'Bau' then 
                            triggerServerEvent('takeItemBau', localPlayer, localPlayer, inventory2.id, selected2.item, getQuantity ( ))
                        elseif inventory2.type == 'Revist' then 
                            triggerServerEvent('revistar >> takeItem', localPlayer, localPlayer, selected2.item, getQuantity ( ), inventory2.element)
                        end
                        if not inventory2.type then 
                            triggerServerEvent('takeDropItem', localPlayer, localPlayer, selected2.item.img, getQuantity ( ), selected2.item)
                        end
                    end
                end
                selected2 = nil
            end
        elseif b == 'right' and s == 'down' then 
            if cfg.client.fastUse then
                for item,v in ipairs(inventory) do 
                    local i = (v.slot-scrollData[1]) 
                    if i > 0 and i <= #slots then
                        if isCursorOnElement(slots[i][1], slots[i][2], slots[i][3], slots[i][4]) then 
                            triggerServerEvent('useItem', localPlayer, localPlayer, v.item, getQuantity(), {
                                index = item,
                                id = v.id,
                                nome = v.nome,
                                qtd = v.qtd,
                                peso = v.peso,
                                owner = v.owner or false,
                                rg = v.rg or false,
                                vehicle = v.vehicle or false,
                                img = v.item,
                                health = v.health
                            })
                        end
                    end
                end
            end
        end
    end
end)

function scroll ( b )
    if isEventHandlerAdded('onClientRender', root, renderInventory) then
        if isCursorOnElement(118, 213, 685, 691) then
            if b == 'mouse_wheel_down' then 
                if (scrollData[1] + 5) >= #slots then 
                    scrollData[1] = #slots - 5
                else
                    scrollData[1] = scrollData[1] + 5
                end
            elseif b == 'mouse_wheel_up' then
                if (scrollData[1] - 5) <= 0 then 
                    scrollData[1] = 0
                else
                    scrollData[1] = scrollData[1] - 5
                end
            end
        elseif isCursorOnElement(1111, 213, 685, 691) then
            if (inventory2.slots or 50) > 25 then 
                if b == 'mouse_wheel_down' then 
                    if (scrollData[2] + 5) >= #slots then 
                        scrollData[2] = #slots - 5
                    else
                        scrollData[2] = scrollData[2] + 5
                    end
                elseif b == 'mouse_wheel_up' then
                    if (scrollData[2] - 5) <= 0 then 
                        scrollData[2] = 0
                    else
                        scrollData[2] = scrollData[2] - 5
                    end
                end
            end
        end
    end
end
bindKey('mouse_wheel_down', 'down', scroll)
bindKey('mouse_wheel_up', 'down', scroll)

function actionBar ( b )
    if getElementData(localPlayer, 'ActionBar') == true and not getElementData(localPlayer, "class:blockAction") then 
        if cfg.client.actionBar then
            local b = tonumber(b)
            if inventory then
                if #inventory > 0 then
                    if not editing then
                        if getItemFromSlot(b) then 
                            local i = getItemFromSlot(b)
                            triggerServerEvent('useItem', localPlayer, localPlayer, inventory[i].item, 1, inventory[i])
                        end
                    end
                end
            end
        end
    end
end
bindKey('1', 'down', actionBar)
bindKey('2', 'down', actionBar)
bindKey('3', 'down', actionBar)
bindKey('4', 'down', actionBar)

addEvent('updateInventory', true)
addEventHandler('updateInventory', root, function(type, table, PESO, PESOMAX)
    if type == 'player' then 
        inventory = table
        if PESO and PESOMAX then 
            peso = PESO
            pesoMax = PESOMAX
        end
    elseif type == 'bau' then 
        inventory2.items = table 
        inventory2.peso = PESO
    elseif type == 'drop' then 
        if inventory2.type == 'Bau' or inventory2.type == 'Revist' or inventory2.type == 'Shop' then return end
        inventory2.type = nil
        inventory2.items = table
    end
end)


function getHealthColor ( health )
    local health = tonumber(health)
    if health <= 100 and health > 70 then 
        return '00F8B9'
    elseif health <= 70 and health > 30 then 
        return 'EBFF00'
    else
        return 'AA0000'
    end
end

function getQuantity ( )
    local qtd = tonumber(guiGetText(qtd))
    if type (qtd) == 'number' then 
        if qtd > 0 then
            local qtd = math.floor(math.abs(qtd))
            return qtd
        end
    end
    return 1
end

function getItemFromSlot ( slot )
    if inventory then
        for i,v in ipairs(inventory) do 
            if v.slot == slot then 
                return i
            end
        end
    end
    return false
end

function getItemFromSlot2 ( slot )
    if inventory2.items then
        local i = 0
        for item ,v in pairs(inventory2.items) do 
            if item > (scrollData[2]) and item < #slots then
                i = i+1
                if i == slot then 
                    return item
                end
            end
        end
    end
    return false
end

addEvent('fecharInventario', true)
addEventHandler('fecharInventario', root, function ( )
    if isEventHandlerAdded('onClientRender', root, renderInventory) then 
        if not closing then
            editing = false
            fade = {100, 0, getTickCount(), 300}
            if inventory2.type == 'Bau' then
                triggerServerEvent('closeBau', localPlayer, localPlayer, inventory2.element)
            end
            closing = setTimer(function ( )
                removeEventHandler('onClientRender', root, renderInventory)
                showCursor(false)
                triggerServerEvent('updateServerData', localPlayer, localPlayer, inventory)
                inventory2 = {}
                closing = false
            end, 300, 1)
        end
    end
end)

-- << NOTIFY ITEM >> 

local notify = {}
local tickNotify = 0
local position = {
    {776, 892, 110, 105},
    {897, 892, 110, 105},
    {1019, 892, 110, 105},
}

addEventHandler('onClientRender', root, function ( )
    if #notify > 0 then 
        for i,v in ipairs(notify) do 
            if #notify > 3 then 
                table.remove(notify, 1)
                tickNotify = getTickCount()
            end
            if #notify == 1 then 
                local alpha = interpolateBetween(v.alpha[1], 0, 0, v.alpha[2], 0, 0, (getTickCount()-v.tick)/500, 'Linear')
                local x, y = interpolateBetween(v.position[1], v.position[2], 0, position[2][1], position[2][2], 0, (getTickCount()-tickNotify)/750, 'OutQuad')
                dxDrawRectangle(x, y, position[2][3], position[2][4], tocolor('2F303B', alpha-5))
                dxDrawRectangle(x, (y+position[2][4]), position[2][3], 2, tocolor('FFFFFF', alpha))
                dxDrawText(v.type..' '..v.qtd..'x', (x+5), (y+5), position[2][3], 20, tocolor('FFFFFF', alpha), 1, font['roboto']['regular'][10], 'left', 'top')
                dxDrawImage((x+22), (y+14), 66, 66, 'src/assets/itens/'..v.item..'.png', 0, 0, 0, tocolor('FFFFFF', alpha))
                dxDrawText(cfg.items[v.item].nome, (x), (y+80), position[2][3], 20, tocolor('FFFFFF', alpha), 1, font['roboto']['regular'][10], 'center', 'top')
                if (getTickCount()-v.tick)/750 >= 1 then 
                    v.position[1] = x 
                    v.position[2] = y
                end
                if (getTickCount()-v.tick)/4000 >= 1 then 
                    v.alpha = {100, 0}
                    v.tick = getTickCount()
                end
                if v.alpha[1] == 100 then
                    if (getTickCount()-v.tick)/1000 >= 1 then 
                        table.remove(notify, i)
                        tickNotify = getTickCount()
                    end
                end
            else 
                local alpha = interpolateBetween(v.alpha[1], 0, 0, v.alpha[2], 0, 0, (getTickCount()-v.tick)/300, 'Linear')
                local x, y = interpolateBetween(v.position[1], v.position[2], 0, position[i][1], position[i][2], 0, (getTickCount()-tickNotify)/750, 'OutQuad')
                dxDrawRectangle(x, y, position[i][3], position[i][4], tocolor('2F303B', alpha-5))
                dxDrawRectangle(x, (y+position[i][4]), position[i][3], 2, tocolor('FFFFFF', alpha))
                dxDrawText(v.type..' '..v.qtd..'x', (x+5), (y+5), position[i][3], 20, tocolor('FFFFFF', alpha), 1, font['roboto']['regular'][10], 'left', 'top')
                dxDrawImage((x+22), (y+14), 66, 66, 'src/assets/itens/'..v.item..'.png', 0, 0, 0, tocolor('FFFFFF', alpha))
                dxDrawText(cfg.items[v.item].nome, (x), (y+80), position[i][3], 20, tocolor('FFFFFF', alpha), 1, font['roboto']['regular'][10], 'center', 'top')
                if (getTickCount()-v.tick)/750 >= 1 then 
                    v.position[1] = x 
                    v.position[2] = y
                end
                if (getTickCount()-v.tick)/4000 >= 1 then 
                    v.alpha = {100, 0}
                    v.tick = getTickCount()
                end
                if v.alpha[1] == 100 then
                    if (getTickCount()-v.tick)/1000 >= 1 then 
                        table.remove(notify, i)
                        tickNotify = getTickCount()
                    end
                end
            end
        end
    end
end)

addEvent('notifyItem', true)
addEventHandler('notifyItem', root, function ( item, qtd, type )
    local id = (#notify or 0) + 1
    if id > 3 then 
        table.remove(notify, 1)
        tickNotify = getTickCount()
        id = 3
    end
    if id == 1 then 
        id = 2
    end
    tickNotify = getTickCount()
    local data = {
        item = item,
        qtd = qtd,
        type = type,
        alpha = {0, 100},
        tick = getTickCount(),
        position = {position[id][1], (position[id][2]+105)}
    }
    table.insert(notify, data)
end)


-- << HOT BAR >>

local hotbar = {}
local slots = {
    {754, 932},
    {859, 932},
    {965, 932},
    {1071, 932},
}

function renderHotBar ( )

    local alpha = interpolateBetween(hotbar.alpha[1], 0, 0, hotbar.alpha[2], 0, 0, (getTickCount()-hotbar.alpha[3])/hotbar.alpha[4], 'Linear')
    local y = interpolateBetween(hotbar.position[1], 0, 0, hotbar.position[2], 0, 0, (getTickCount()-hotbar.position[3])/hotbar.position[4], 'OutQuad')

    for i,v in ipairs( slots ) do 
        local item = inventory[getItemFromSlot(i)]
        dxDrawRectangle(v[1], v[2]-y, 96, 92, tocolor('2F303B', alpha))
        dxDrawRectangle(v[1], v[2]+92-y, 96, 2, tocolor('D9D9D9', alpha))
        dxDrawText(i, v[1], v[2]-y, 96, 92, tocolor('272730', alpha), 1, font['roboto']['regular'][40], 'center', 'center')
        if item then 
            dxDrawText(item.nome, v[1], v[2]+70-y, 96, 17, tocolor('FFFFFF', alpha), 1, font['poppins']['regular'][10], 'center', 'center')
            dxDrawImage(v[1]+19, v[2]+7-y, 58, 58, 'src/assets/itens/'..item.item..'.png', 0, 0, 0, tocolor('FFFFFF', alpha))
        end
    end

    if (getTickCount()-hotbar.alpha[3])/hotbar.alpha[4] >= 1 then 
        hotbar.closing = false
        hotbar.opening = false
    end

end

bindKey('tab', 'both', function ( )
    if inventory then 
        if not hotbar.state then 
            if not isEventHandlerAdded('onClientRender', root, renderHotBar) then 
                addEventHandler('onClientRender', root, renderHotBar)
            end
            if not hotbar.opening then 
                hotbar.opening = true
                hotbar.alpha = {0, 100, getTickCount(), 300}
                hotbar.position = {-92, 0, getTickCount(), 500}
            end
            hotbar.state = true
            hotbar.closing = false
        else
            if not hotbar.closing then 
                hotbar.closing = true
                hotbar.alpha = {100, 0, getTickCount(), 300}
                hotbar.position = {0, -92, getTickCount(), 500}
                setTimer(function()
                    if isEventHandlerAdded('onClientRender', root, renderHotBar) then 
                        removeEventHandler('onClientRender', root, renderHotBar)
                    end
                end, 500, 1)
            end
            hotbar.opening = false
            hotbar.state = false
        end
    end
end)

-- weapon

addEventHandler('onClientRender', root, function ( )
    if getElementData(localPlayer, 'Arma-Equipada') then 
        print(getSlotFromWeapon(getPedWeapon(localPlayer)))
        if getSlotFromWeapon(getPedWeapon(localPlayer)) ~= 0 and getSlotFromWeapon(getPedWeapon(localPlayer)) ~= 1 then 
            if getPedTotalAmmo(localPlayer) == 1 then 
                toggleControl('fire', false)
                toggleControl('action', false)
            else
                toggleControl('fire', true)
                toggleControl('action', true)
            end
        else
            toggleControl('fire', true)
            toggleControl('action', true)
        end
    end
end)

--[[
    dxDrawRectangle(position[i][1], position[i][2], position[i][3], position[i][4], tocolor('2F303B', alpha-5))
                dxDrawRectangle(position[i][1], (position[i][2]+position[i][4]), position[i][3], 2, tocolor('FFFFFF', alpha))
                dxDrawText(v.type..' '..v.qtd..'x', (position[i][1]+5), (position[i][2]+5), position[i][3], 20, tocolor('FFFFFF', alpha), 1, font['roboto']['regular'][10], 'left', 'top')
                dxDrawImage((position[2][1]+22), (position[i][2]+14), 66, 66, 'src/assets/itens/'..v.item..'.png', 0, 0, 0, tocolor('FFFFFF', alpha))
                dxDrawText(cfg.items[v.item].nome, (position[i][1]), (position[i][2]+80), position[i][3], 20, tocolor('FFFFFF', alpha), 1, font['roboto']['regular'][10], 'center', 'top')
]]

-- << RECOIL SYSTEM >>



function recoil()

    local recoil = cfg.recoil
	if recoil[getPedWeapon(localPlayer)] then 
		local rotation = 360 - getPedCameraRotation(localPlayer)
		local w, h = guiGetScreenSize () -- thompson
		local xg, yg, zg = getWorldFromScreenPosition ( w/2, h/2, 50 )
		setCameraTarget(xg, yg, zg+(recoil[getPedWeapon(localPlayer)].y))

		if math.random(1, 2) == 1 then
			setPedCameraRotation(localPlayer, rotation + (recoil[getPedWeapon(localPlayer)].x))
		else
			setPedCameraRotation(localPlayer, rotation - (recoil[getPedWeapon(localPlayer)].x))
		end
	end

end
addEventHandler("onClientPlayerWeaponFire", localPlayer, recoil)

function getItem(item) 
    local qtd = 0
    if #inventory > 0 then 
        for i,v in ipairs(inventory) do 
            if v.item == item then 
                qtd = qtd + v.qtd
            end
        end
    end
    return qtd
end

