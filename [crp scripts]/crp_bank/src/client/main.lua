local scrollY = 0
local lastPosition = 0
local positions = {}
local bank = {}
local render = dxCreateRenderTarget(1052, 718, true)

local slots = {
    contas = {
        {241, 199, 328, 145},
        {241, 359, 328, 145},
        {241, 519, 328, 145},
        {241, 679, 328, 145},
    }
}

local editbox = {
    guiCreateEdit(-1, -1, 0, 0, ''),
    guiCreateEdit(-1, -1, 0, 0, ''),
    guiCreateEdit(-1, -1, 0, 0, ''),
    guiCreateEdit(-1, -1, 0, 0, ''),
}

function renderBank ( )

    dxDrawRoundedRectangle(225, 135, 1440, 810, 10, tocolor('222831', 100))

    -- << CONTAS >> 
    dxDrawText('Contas', 243, 153, 167, 31, white, 1, font['roboto']['medium'][16])
    dxDrawText('Chafe Bank', (243-30), 153, 1440, 31, white, 1, font['roboto']['medium'][16], 'right')

        if bank.contas then 
            if type(bank.contas) == 'table' then 
                if #bank.contas > 0 then 
                    for i,v in ipairs(bank.contas) do 
                        local accountType = 'Personal Account'
                        if v.type == 'empresa' then 
                            accountType = 'Company Account'
                        end
                        local priorityAccount = {'Primaria', 'Secundaria', 'Terciaria'}
                        local accountPriority = 'Principal'
                        if i ~= 1 then 
                            accountPriority = priorityAccount[i]
                        end
                        local x, y, w, h = unpack(slots.contas[i])
                        dxDrawImage(x, y, w, h, img.base)
                        dxDrawText(accountType..' / '..v.id, (x+9), (y+11), 216, 31, white, 1, font['roboto']['regular'][14], 'left', 'top')
                        dxDrawText(accountPriority, (x+9), (y+34), 216, 31, white, 1, font['roboto']['regular'][10], 'left', 'top')
                        dxDrawText(v.user, (x+9), (y+55), 216, 31, white, 1, font['roboto']['regular'][12], 'left', 'top')
                        dxDrawText('$ '..v.saldo, (x+158), (y+43), 159, 25, white, 1, font['roboto']['regular'][16], 'right', 'top')
                        dxDrawText('Saldo disponivel', (x+158), (y+75), 159, 25, white, 1, font['roboto']['regular'][10], 'right', 'top')
                    
                        if bank.type == 'bank' then 
                            dxDrawRoundedRectangle((x+5), (y+110), 95, 31, 4, isCursorOnElement((x+5), (y+105), 75, 31, 4) and tocolor('95EF77', 80) or tocolor('95EF77', 100))
                            dxDrawText('DEPOSITAR', (x+5), (y+110), 95, 31, tocolor('1F150D', 100), 1, font['roboto']['regular'][8], 'center', 'center')
                            dxDrawRoundedRectangle((x+85+20), (y+110), 75, 31, 4, isCursorOnElement((x+85), (y+105), 75, 31, 4) and tocolor('F2A365', 80) or tocolor('F2A365', 100))
                            dxDrawText('RETIRAR', (x+85+20), (y+110), 75, 31, tocolor('1F150D', 100), 1, font['roboto']['regular'][8], 'center', 'center')
                        elseif bank.type == 'atm' then 
                            dxDrawRoundedRectangle((x+5), (y+110), 75, 31, 4, isCursorOnElement((x+5), (y+105), 75, 31, 4) and tocolor('F2A365', 80) or tocolor('F2A365', 100))
                            dxDrawText('RETIRAR', (x+5), (y+110), 75, 31, tocolor('1F150D', 100), 1, font['roboto']['regular'][8], 'center', 'center')
                        end

                        dxDrawRoundedRectangle((x+219), (y+110), 100, 31, 4, isCursorOnElement((x+219), (y+105), 75, 31, 4) and tocolor('D9D9D9', 80) or tocolor('D9D9D9', 100))
                        dxDrawText('TRANSFERIR', (x+219), (y+110), 100, 31, tocolor('1F150D', 100), 1, font['roboto']['regular'][8], 'center', 'center')
                    end
                end

                --[[
                if bank.type == 'bank' then 
                    if #bank.contas < 4 then 
                        local x, y, w, h = unpack(slots.contas[#bank.contas+1])
                        dxDrawImage(x+(w/2-50/2), y+(h/2-50/2), 50, 50, img.add, 0, 0, 0, isCursorOnElement(x+(w/2-50/2), y+(h/2-50/2), 50, 50) and tocolor('FFFFFF', 100) or tocolor('FFFFFF', 70))
                    end
                end]]
            end
        end

    -- << HISTORICO >>
    if bank.selected then 
        if bank.historic and #bank.historic > 0 then 
            dxDrawImage(592, 197, 1052, 718, render)
        else
            dxDrawText('NENHUMA TRANSAÇÃO ENCONTRADA', 592, 197, 1052, 718, white, 1, font['roboto']['regular'][12], 'center', 'top')
        end
    else
        dxDrawText('NENHUMA CONTA SELECIONADA', 592, 197, 1052, 718, white, 1, font['roboto']['regular'][12], 'center', 'top')
    end

    -- << paginas >>

    if bank.page then
        if bank.page == 'saque' then 
            local v = bank.selected
            local accountType = 'Personal Account'
            if v.type == 'empresa' then 
                accountType = 'Company Account'
            end
            dxDrawRoundedRectangle(660, 380, 600, 320, 10, tocolor('30475E'))
            dxDrawText(accountType..' /\n'..v.id, 660, 400, 600, 59, white, 1, font['roboto']['regular'][20], 'center', 'top')

            dxDrawText('Valor', 810, 492, 300, 21, tocolor('C1C8CF'), 1, font['roboto']['regular'][10], 'left', 'top')
            dxDrawText('$   #ffffff'..guiGetText(editbox[1]), 810, 515, 300, 26, tocolor('C1C8CF'), 1, font['roboto']['regular'][10], 'left', 'top', false, false, false, true)
            dxDrawRectangle(810, 539, 300, 2, tocolor('FCFDFD'))

            dxDrawText('Comentario', 810, 572, 300, 21, tocolor('C1C8CF'), 1, font['roboto']['regular'][10], 'left', 'top')
            dxDrawText('//   #ffffff'..guiGetText(editbox[2]), 810, 595, 300, 26, tocolor('C1C8CF'), 1, font['roboto']['regular'][10], 'left', 'top', false, false, false, true)
            dxDrawRectangle(810, 620, 300, 2, tocolor('FCFDFD'))

            dxDrawRoundedRectangle(810, 653, 88, 30, 4, isCursorOnElement(810, 653, 88, 30) and tocolor('F2A365', 90) or tocolor('F2A365', 100))
            dxDrawText('CANCELAR', 810, 653, 88, 30, tocolor('1F150D'), 1, font['roboto']['regular'][8], 'center', 'center')

            dxDrawRoundedRectangle(1046, 653, 88, 30, 4, isCursorOnElement(1046, 653, 88, 30) and tocolor('92E976', 90) or tocolor('92E976', 100))
            dxDrawText('SACAR', 1046, 653, 88, 30, tocolor('1F150D'), 1, font['roboto']['regular'][8], 'center', 'center')
        elseif bank.page == 'deposito' then 
            local v = bank.selected
            local accountType = 'Personal Account'
            if v.type == 'empresa' then 
                accountType = 'Company Account'
            end
            dxDrawRoundedRectangle(660, 380, 600, 320, 10, tocolor('30475E'))
            dxDrawText(accountType..' /\n'..v.id, 660, 400, 600, 59, white, 1, font['roboto']['regular'][20], 'center', 'top')

            dxDrawText('Valor', 810, 492, 300, 21, tocolor('C1C8CF'), 1, font['roboto']['regular'][10], 'left', 'top')
            dxDrawText('$   #ffffff'..guiGetText(editbox[1]), 810, 515, 300, 26, tocolor('C1C8CF'), 1, font['roboto']['regular'][10], 'left', 'top', false, false, false, true)
            dxDrawRectangle(810, 539, 300, 2, tocolor('FCFDFD'))

            dxDrawText('Comentario', 810, 572, 300, 21, tocolor('C1C8CF'), 1, font['roboto']['regular'][10], 'left', 'top')
            dxDrawText('//   #ffffff'..guiGetText(editbox[2]), 810, 595, 300, 26, tocolor('C1C8CF'), 1, font['roboto']['regular'][10], 'left', 'top', false, false, false, true)
            dxDrawRectangle(810, 620, 300, 2, tocolor('FCFDFD'))

            dxDrawRoundedRectangle(810, 653, 88, 30, 4, isCursorOnElement(810, 653, 88, 30) and tocolor('F2A365', 90) or tocolor('F2A365', 100))
            dxDrawText('CANCELAR', 810, 653, 88, 30, tocolor('1F150D'), 1, font['roboto']['regular'][8], 'center', 'center')

            dxDrawRoundedRectangle(1046, 653, 88, 30, 4, isCursorOnElement(1046, 653, 88, 30) and tocolor('92E976', 90) or tocolor('92E976', 100))
            dxDrawText('DEPOSITAR', 1046, 653, 88, 30, tocolor('1F150D'), 1, font['roboto']['regular'][8], 'center', 'center')
        elseif bank.page == 'transferencia' then 
            local v = bank.selected
            local accountType = 'Personal Account'
            if v.type == 'empresa' then 
                accountType = 'Company Account'
            end
            dxDrawRoundedRectangle(660, 380, 600, 320, 10, tocolor('30475E'))
            dxDrawText(accountType..' /\n'..v.id, 660, 400, 600, 59, white, 1, font['roboto']['regular'][20], 'center', 'top')

            dxDrawText('Valor', 810, 492, 300, 21, tocolor('C1C8CF'), 1, font['roboto']['regular'][10], 'left', 'top')
            dxDrawText('$   #ffffff'..guiGetText(editbox[1]), 810, 515, 300, 26, tocolor('C1C8CF'), 1, font['roboto']['regular'][10], 'left', 'top', false, false, false, true)
            dxDrawRectangle(810, 539, 300, 2, tocolor('FCFDFD'))

            dxDrawText('Conta', 810, 572, 300, 21, tocolor('C1C8CF'), 1, font['roboto']['regular'][10], 'left', 'top')
            dxDrawText('//   #ffffff'..guiGetText(editbox[2]), 810, 595, 300, 26, tocolor('C1C8CF'), 1, font['roboto']['regular'][10], 'left', 'top', false, false, false, true)
            dxDrawRectangle(810, 620, 300, 2, tocolor('FCFDFD'))

            dxDrawRoundedRectangle(810, 653, 88, 30, 4, isCursorOnElement(810, 653, 88, 30) and tocolor('F2A365', 90) or tocolor('F2A365', 100))
            dxDrawText('CANCELAR', 810, 653, 88, 30, tocolor('1F150D'), 1, font['roboto']['regular'][8], 'center', 'center')

            dxDrawRoundedRectangle(1046, 653, 88, 30, 4, isCursorOnElement(1046, 653, 88, 30) and tocolor('92E976', 90) or tocolor('92E976', 100))
            dxDrawText('TRANSFERIR', 1046, 653, 88, 30, tocolor('1F150D'), 1, font['roboto']['regular'][8], 'center', 'center')
        end 
    end

end



function updateRender ( scroll )
    dxSetRenderTarget(render, true)
    if bank.historic then 
        local i = #bank.historic+1
        for _,v in ipairs(bank.historic) do 
            i = i-1
            if i == 0 then 
                i = 1 
            end
            local conta = v.conta
            local y = (-219 + (219*i) - scroll)
            local accountType = 'Personal Account'
            if conta.type == 'empresa' then 
                accountType = 'Company Account'
            end
            dxDrawRoundedRectangle(0, y, 1048, 202, 5, tocolor('30475E'), false, true)
            dxDrawText2(accountType.. ' / '..conta.id..' - '..v.type, 8, y + 13, 404, 31, white, 1, font['roboto2']['regular'][14], 'left', 'top')
            _dxDrawRectangle(7, y+42, 1016, 2, tocolor('D9D9D9'))
            if v.type == 'Transferencia' or v.type == 'Saque' then 
                dxDrawText2('-$'..v.amount, 7, y + 54, 109, 25, tocolor('F2A365'), 1, font['roboto2']['regular'][16], 'left', 'top')
            elseif v.type == 'Deposito' or v.type == 'Recibo' then
                dxDrawText2('+$'..v.amount, 7, y + 54, 109, 25, tocolor('95EF77'), 1, font['roboto2']['regular'][16], 'left', 'top')
            end
            dxDrawText2(conta.user, 247, y + 58, 216, 31, white, 1, font['roboto2']['regular'][16], 'left', 'top')
            dxDrawText2(v.data, 824, y + 58, 216, 31, white, 1, font['roboto2']['regular'][14], 'left', 'top')
            if v.msg then 
                dxDrawText2('Mensagem', 7, y + 132, 216, 31, tocolor('98A3AF'), 1, font['roboto2']['regular'][10], 'left', 'top')
                dxDrawText2(v.msg, 7, y + 157, 732, 22, tocolor('98A3AF'), 1, font['roboto2']['regular'][10], 'left', 'top')
            end
            _dxDrawRectangle(7, y+179, 1016, 2, tocolor('D9D9D9'))
            positions[i] = {0, y, 1048, 202}
            if i == #bank.historic then
                lastPosition = y 
            end
        end
    end
    dxSetRenderTarget()
end 

addEvent('bank:manager', true)
addEventHandler('bank:manager', root, function ( type, accounts, historic, typeBank )
    if type == 'open' then 
        if not isEventHandlerAdded('onClientRender', root, renderBank) then 
            addEventHandler('onClientRender', root, renderBank)
            showCursor(true)
            showChat(false)
        end
        dxDrawRoundedRectangle(0, 0, 1048, 202, 5, tocolor('FFFFFF', 0))
        bank.type = typeBank or 'atm'
        if accounts then 
            bank.contas = accounts or {}
        end
        if historic then 
            bank.historic = historic or {}
            updateRender ( 0 )
            scrollY = 0
        end
        setElementData(localPlayer, 'ActionBar', false)
    elseif type == 'close' then 
        if isEventHandlerAdded('onClientRender', root, renderBank) then 
            removeEventHandler('onClientRender', root, renderBank)
            showCursor(false)
            showChat(true)
        end
        bank = {}
        setElementData(localPlayer, 'ActionBar', true)
    elseif type == 'update' then 
        if accounts then 
            bank.contas = accounts or {}
        end
        if historic then 
            bank.historic = historic or {}
            scrollY = 0
        end
        updateRender ( 0 )
    end
end)


function scroll ( key )
    if isEventHandlerAdded('onClientRender', root, renderBank) then 
        if bank.historic then 
            if key == 'mouse_wheel_down' then 
                if scrollY + 30 <= (-219 + (219*(#bank.historic)) - 202) then 
                    scrollY = scrollY + 30
                    updateRender( scrollY )
                end
            elseif key == 'mouse_wheel_up' then 
                if scrollY - 30 > 0 then 
                    scrollY = scrollY - 30
                    updateRender( scrollY )
                else
                    if scrollY > 0 then 
                        scrollY = 0
                        updateRender( 0 )
                    end
                end
            end
        end
    end
end
bindKey('mouse_wheel_down', 'down', scroll)
bindKey('mouse_wheel_up', 'down', scroll)

function click ( b, s )
    if isEventHandlerAdded('onClientRender', root, renderBank) then 
        if b == 'left' and s == 'down' then 
            if not bank.page then 
                if #bank.contas > 0 then 
                    for i,v in ipairs(bank.contas) do 
                        local x, y, w, h = unpack(slots.contas[i])
                        if not bank.selected or bank.selected ~= bank.contas[i] then 
                            if isCursorOnElement(x, y, w, h) then 
                                bank.selected = bank.contas[i]
                                triggerServerEvent('getLogs', resourceRoot, localPlayer, bank.selected.id, true)
                            end
                        end
                        if bank.type == 'bank' then 
                            if isCursorOnElement((x+5), (y+110), 95, 31) then 
                                bank.page = 'deposito'
                                bank.selected = bank.contas[i]
                            elseif isCursorOnElement((x+85+20), (y+110), 75, 31) then 
                                bank.page = 'saque'
                                bank.selected = bank.contas[i]
                            end
                        elseif bank.type == 'atm' then 
                            if isCursorOnElement((x+5), (y+110), 75, 31) then 
                                bank.page = 'saque'
                                bank.selected = bank.contas[i]
                            end
                        end
                        if isCursorOnElement((x+219), (y+110), 100, 31) then 
                            bank.page = 'transferencia'
                            bank.selected = bank.contas[i]
                        end
                    end
                end
            end
            if bank.page == 'saque' or bank.page == 'deposito' then 
                if isCursorOnElement(810, 515, 300, 26) then
                    guiFocus(editbox[1])
                elseif isCursorOnElement(810, 595, 300, 26) then 
                    guiFocus(editbox[2])
                elseif isCursorOnElement(810, 653, 88, 30) then
                    bank.page = nil 
                    bank.selected = nil 
                elseif isCursorOnElement(1046, 653, 88, 30) then
                    local value = tonumber(guiGetText(editbox[1]))
                    if not type(value) == 'number' then 
                        return false
                    end
                    print(value)
                    triggerServerEvent('bank:'..bank.page, localPlayer, localPlayer, bank.selected.id, value, guiGetText(editbox[2]))
                    bank.page = nil 
                    bank.selected = nil 
                end
            end
            if bank.page == 'transferencia' then 
                if isCursorOnElement(810, 515, 300, 26) then
                    guiFocus(editbox[1])
                elseif isCursorOnElement(810, 595, 300, 26) then 
                    guiFocus(editbox[2])
                elseif isCursorOnElement(810, 653, 88, 30) then
                    bank.page = nil 
                    bank.selected = nil 
                elseif isCursorOnElement(1046, 653, 88, 30) then
                    local value = tonumber(guiGetText(editbox[1]))
                    if not type(value) == 'number' then 
                        return false
                    end
                    print(value)
                    triggerServerEvent('bank:'..bank.page, localPlayer, localPlayer, bank.selected.id, value, guiGetText(editbox[2]), 'Enviou para: '..guiGetText(editbox[2]))
                    bank.page = nil 
                    bank.selected = nil 
                end
            end
        end
    end
end
addEventHandler('onClientClick', root, click)

bindKey('backspace', 'down', function()
    if isEventHandlerAdded('onClientRender', root, renderBank) then 
        if not bank.page then 
            setElementData(localPlayer, 'ActionBar', true)
            removeEventHandler('onClientRender', root, renderBank)
            showCursor(false)
            showChat(true)
            bank = {}
        end
    end
end)

function dxDrawText2 (text, x, y, w, h, ...)
    return _dxDrawText(text, x, y, (w+x), (h+y), ...)
end