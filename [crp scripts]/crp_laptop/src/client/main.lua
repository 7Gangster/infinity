local gne = cfg.crypto.valorBase

local bussines = {
    slots = {
        {423, 382},
        {973, 382},
        {423, 573},
        {423, 573},
    },
    slots2 = {
        {429, 419},
        {699, 419},
        {970, 419},
        {1240, 419},

        {429, 595},
        {699, 595},
        {970, 595},
        {1240, 595},
    },
}

local laptop = {}
local scroll = {
    ['boosting-sell'] = 0,
}
local renderTarget = dxCreateRenderTarget(1069, 423, true)

function render ( )

    local alpha = interpolateBetween(laptop.anims.alpha[1], 0, 0, laptop.anims.alpha[2], 0, 0, (getTickCount()-laptop.anims.alpha[3])/laptop.anims.alpha[4], 'Linear')
    local time = getRealTime()

    local monthday = time.monthday
    local month = time.month
    local year = time.year

    local formattedTime = string.format("%02d/%02d/%04d", monthday, month + 1, year + 1900 , hours, minutes, seconds)
    -- base
    dxDrawImage(144, 75, 1632, 918, 'src/assets/bg.png', 0, 0, 0, tocolor('FFFFFF', alpha))

    --dxDrawText(string.format('%02d:%02d', time.hour, time.minute), 1695, 940, 65, 14, tocolor('FFFFFF', alpha), 1, getFont('regular', 12), 'center', 'top')
    dxDrawText(string.format('%02d:%02d', time.hour, time.minute), 1695, 940, 65, 14, tocolor('FFFFFF', alpha), 1, getFont('regular', 10), 'center', 'top')
    dxDrawText(formattedTime, 1695, 957, 65, 14, tocolor('FFFFFF', alpha), 1, getFont('regular', 10), 'center', 'top')

    -- aplicativos
    dxDrawImage(176, 99, 67, 79, 'src/assets/apps/lixeira.png', 0, 0, 0, isCursorOnElement(176, 99, 67, 79) and tocolor('FFFFFF', alpha-30) or tocolor('FFFFFF', alpha))
    dxDrawImage(184, 208, 60, 83, 'src/assets/apps/crypto.png', 0, 0, 0, isCursorOnElement(184, 208, 60, 83) and tocolor('FFFFFF', alpha-30) or tocolor('FFFFFF', alpha))
    dxDrawImage(180, 318, 79, 83, 'src/assets/apps/business.png', 0, 0, 0, isCursorOnElement(180, 318, 79, 83) and tocolor('FFFFFF', alpha-30) or tocolor('FFFFFF', alpha))
    dxDrawImage(183, 431, 60, 82, 'src/assets/apps/bennys.png', 0, 0, 0, isCursorOnElement(180, 431, 67, 77) and tocolor('FFFFFF', alpha-30) or tocolor('FFFFFF', alpha))
    
    if laptop.vpn then 
        dxDrawImage(289, 103, 69, 80, 'src/assets/apps/boosting.png', 0, 0, 0, isCursorOnElement(289, 103, 69, 80) and tocolor('FFFFFF', alpha-30) or tocolor('FFFFFF', alpha))
        dxDrawImage(276, 207, 90, 80, 'src/assets/apps/demonweb.png', 0, 0, 0, isCursorOnElement(276, 207, 90, 80) and tocolor('FFFFFF', alpha-30) or tocolor('FFFFFF', alpha))
        dxDrawImage(276, 318, 90, 101, 'src/assets/apps/criminal.png', 0, 0, 0, isCursorOnElement(276, 318, 90, 101) and tocolor('FFFFFF', alpha-30) or tocolor('FFFFFF', alpha))
    end

    if laptop.crypto then 
        dxDrawImage(392, 230, 1136, 609, 'src/assets/app.png')
        dxDrawImage(392, 267, 1136, 572, img.gradient)
        dxDrawText('Crypto Shop', 410, 237, 104, 20, tocolor('FFFFFF', alpha), 1, getFont('medium', 15), 'left', 'center')

        dxDrawRoundedRectangle(760, 368, 400, 370, 10, tocolor('25262B', 100))
        dxDrawRectangle(760, 397, 400, 2, tocolor('373A40', 100))
        dxDrawImage(770, 381, 14, 8, img.money)
        dxDrawText('Buy', 789, 375, 26, 15, tocolor('FFFFFF', alpha), 1, getFont('regular', 10), 'center')
        dxDrawImage(840, 379, 13, 14, img.transfer)
        dxDrawText('Transfer', 850, 375, 68, 15, tocolor('FFFFFF', alpha), 1, getFont('regular', 10), 'center')
        dxDrawImage(932, 381, 14, 8, img.money)
        dxDrawText('Sell', 930, 375, 68, 15, tocolor('FFFFFF', alpha), 1, getFont('regular', 10), 'center')

        if laptop.crypto.page == 'buy' then 

            local edit = laptop.crypto.editBox
            local text = guiGetText(edit)
            if text == '' then 
                text = 'QTD'
            end

            dxDrawRectangle(768, 397, 55, 2, tocolor('B197FC'))
            dxDrawText('Buy Crypto', 884, 420, 152, 29, tocolor('B197FC'), 1, getFont('semibold', 25), 'center')
            dxDrawImage(860, 477, 200, 36, img.button)
            dxDrawText('GNE', 872, 487, 39, 16, white, 1, getFont('regular', 12), 'center', 'center')
            dxDrawText('Você possui: '..(getElementData(localPlayer, 'GNE') or 0), 897, 532, 89, 16, white, 1, getFont('semibold', 14), 'left', 'top')
            dxDrawText('1 GNE = '..gne..' USD', 897, 552, 69, 18, white, 1, getFont('semibold', 14), 'left', 'top')
            dxDrawImage(860, 587, 200, 36, img.button)
            dxDrawImage(871, 600, 14, 13, img.diamond)
            dxDrawText(text, 897, 588, 149, 35, tocolor('FFFFFF'), 1, getFont('regular', 12), 'left', 'center')
            dxDrawText('Total: '..((tonumber(text) or 0)*gne)..' USD', 835, 642, 250, 0, white, 1, getFont('semibold', 14), 'center')
            dxDrawRoundedRectangle(835, 676, 250, 36, 5, isCursorOnElement(835, 676, 250, 36) and tocolor('B197FC', 100) or tocolor('373A40', 100))
            dxDrawText('Confirmar', 835, 676, 250, 36, white, 1, getFont('semibold', 14), 'center', 'center')
        elseif laptop.crypto.page == 'sell' then 

            local edit = laptop.crypto.editBox
            local text = guiGetText(edit)
            if text == '' then 
                text = 'QTD'
            end

            dxDrawRectangle(924, 397, 55, 2, tocolor('B197FC'))
            dxDrawText('Sell Crypto', 884, 420, 152, 29, tocolor('B197FC'), 1, getFont('semibold', 25), 'center')
            dxDrawImage(860, 477, 200, 36, img.button)
            dxDrawText('GNE', 872, 487, 39, 16, white, 1, getFont('regular', 12), 'center', 'center')
            dxDrawText('Você possui: '..(getElementData(localPlayer, 'GNE') or 0)..' GNE', 897, 532, 89, 16, white, 1, getFont('semibold', 14), 'left', 'top')
            --dxDrawText('1 GNE = 100 USD', 897, 552, 69, 18, white, 1, getFont('semibold', 14), 'left', 'top')
            dxDrawImage(860, 587, 200, 36, img.button)
            dxDrawImage(871, 600, 14, 13, img.diamond)
            dxDrawText(text, 897, 588, 149, 35, tocolor('FFFFFF'), 1, getFont('regular', 12), 'left', 'center')
            dxDrawText('Você recebe: '..((tonumber(text) or 0)*gne)..' USD', 835, 642, 250, 0, white, 1, getFont('semibold', 14), 'center')
            dxDrawRoundedRectangle(835, 676, 250, 36, 5, isCursorOnElement(835, 676, 250, 36) and tocolor('B197FC', 100) or tocolor('373A40', 100))
            dxDrawText('Confirmar', 835, 676, 250, 36, white, 1, getFont('semibold', 14), 'center', 'center')
        elseif laptop.crypto.page == 'transfer' then 

            local edit = laptop.crypto.editBox
            local text = guiGetText(edit)
            if text == '' then 
                text = 'QTD'
            end
            local edit2 = laptop.crypto.playerID
            local text2 = guiGetText(edit2)
            if text2 == '' then 
                text2 = 'PLAYER ID'
            end

            dxDrawRectangle(851, 397, 55, 2, tocolor('B197FC'))
            dxDrawText('Transfer Crypto', 884, 420, 152, 29, tocolor('B197FC'), 1, getFont('semibold', 25), 'center')
            dxDrawImage(860, 477, 200, 36, img.button)
            dxDrawText('GNE', 872, 487, 39, 16, white, 1, getFont('regular', 12), 'center', 'center')
            dxDrawText('Você possui: '..(getElementData(localPlayer, 'GNE') or 0)..' GNE', 897, 532, 89, 16, white, 1, getFont('semibold', 14), 'left', 'top')
            --dxDrawText('1 GNE = 100 USD', 897, 552, 69, 18, white, 1, getFont('semibold', 14), 'left', 'top')
            dxDrawImage(860, 570, 200, 36, img.button)
            dxDrawImage(870, 581, 14, 14, img.person)
            dxDrawText(text2, 897, 570, 149, 35, tocolor('FFFFFF'), 1, getFont('regular', 12), 'left', 'center')
            dxDrawImage(860, 622, 200, 36, img.button)
            dxDrawImage(870, 633, 14, 13, img.diamond)
            dxDrawText(text, 897, 622, 149, 35, tocolor('FFFFFF'), 1, getFont('regular', 12), 'left', 'center')
            --dxDrawText('Você recebe: '..((tonumber(text) or 0)*100)..' USD', 835, 642, 250, 0, white, 1, getFont('semibold', 14), 'center')
            dxDrawRoundedRectangle(835, 676, 250, 36, 5, isCursorOnElement(835, 676, 250, 36) and tocolor('B197FC', 100) or tocolor('373A40', 100))
            dxDrawText('Confirmar', 835, 676, 250, 36, white, 1, getFont('semibold', 14), 'center', 'center')
        end
    end

    if laptop.bussines then 

        dxDrawImage(392, 230, 1136, 609, 'src/assets/app.png')
        dxDrawText('Business Management', 410, 237, 229, 21, white, 1, getFont('medium', 15), 'left', 'top')

        if laptop.bussines.page == 'home' then 

            dxDrawText('Negocios disponíveis', 421, 311, 249, 29, tocolor('D1D4DC'), 1, getFont('semibold', 20))

            dxDrawRectangle(425, 362, 1070, 4, tocolor('292C36'))

            if laptop.bussines.groups then 
                for i,v in ipairs(laptop.bussines.groups) do 
                    if i <= 4 then 
                        local x, y = unpack(bussines.slots[i])
                        dxDrawRoundedRectangle(x, y, 522, 175, 10, tocolor('282A37'))
                        dxDrawText(v.nome, x+19, y+29, 277, 21, white, 1, getFont('bold', 15), 'left')
                        dxDrawText('Cargo: '..v.cargo, x+19, y+51, 82, 18, white, 1, getFont('regular', 12), 'left')

                        dxDrawRoundedRectangle(x+19, y+128, 102, 32, 14, isCursorOnElement(x+19, y+128, 102, 32) and tocolor('1F202B', 70) or tocolor('1F202B'))
                        dxDrawText('VISUALIZAR', x+19, y+128, 102, 32, white, 1, getFont('regular', 10), 'center', 'center')
                    end
                end
            end
        elseif laptop.bussines.page == 'grupo' then 

            local grupo = laptop.bussines.groups[laptop.bussines.selected]
            local cargo = cfg.grupos[grupo.id].cargos[grupo.cargo]

            dxDrawImage(422, 277, 33, 30, img.work)
            dxDrawText(grupo.nome, 422, 332, 156, 21, white, 1, getFont('semibold', 20))

            dxDrawText('Nivel: '..grupo.level, 482, 275, 68, 21, tocolor('ffffff'), 1, getFont('semibold', 15))
            dxDrawRoundedRectangle(482, 300, 1029, 6, 2, tocolor('373737'))

            dxDrawImage(1376, 316, 135, 33, img.buttonGrupo2, 0, 0, 0, isCursorOnElement(1376, 316, 135, 33) and tocolor('FFFFFF', 70) or tocolor('FFFFFF', 100))
            dxDrawText('Sair do grupo', 1376, 316, 135, 33, white, 1, getFont('semibold', 12), 'center', 'center')
            if laptop.bussines.playerSelected then 
                if cargo.permissoes['remover'] then
                    dxDrawImage(1376, 355, 135, 33, img.buttonGrupo, 0, 0, 0, isCursorOnElement(1376, 355, 135, 33) and tocolor('FFFFFF', 70) or tocolor('FFFFFF', 100))
                    dxDrawText('Remover', 1376, 355, 135, 33, white, 1, getFont('semibold', 12), 'center', 'center')
                end
                if cargo.permissoes['rebaixar'] then 
                    dxDrawImage(1233, 355, 135, 33, img.buttonGrupo, 0, 0, 0, isCursorOnElement(1233, 355, 135, 33) and tocolor('FFFFFF', 70) or tocolor('FFFFFF', 100))
                    dxDrawText('Rebaixar', 1233, 355, 135, 33, white, 1, getFont('semibold', 12), 'center', 'center')
                end
                if cargo.permissoes['promover'] then 
                    dxDrawImage(1090, 355, 135, 33, img.buttonGrupo, 0, 0, 0, isCursorOnElement(1090, 355, 135, 33) and tocolor('FFFFFF', 70) or tocolor('FFFFFF', 100))
                    dxDrawText('Promover', 1090, 355, 135, 33, white, 1, getFont('semibold', 12), 'center', 'center')
                end
            end

            if cargo.permissoes['convidar'] then 
                dxDrawImage(1233, 316, 135, 33, img.buttonGrupo, 0, 0, 0, isCursorOnElement(1233, 316, 135, 33) and tocolor('FFFFFF', 70) or tocolor('FFFFFF', 100))
                dxDrawText('Convidar', 1233, 316, 135, 33, white, 1, getFont('semibold', 12), 'center', 'center')
            end
            
            dxDrawRectangle(415, 402, 1096, 2, tocolor('505152'))

            local index = 0
            for i,v in ipairs(grupo.players) do 

                if index >= laptop.bussines.scroll and index <= 8 then 
                    index = index +1
                

                    local x, y = unpack(bussines.slots2[index])
                    if laptop.bussines.playerSelected == index then 
                        dxDrawImage(x, y, 256, 160, img.slotBussines)
                    else
                        dxDrawRoundedRectangle(x, y, 256, 160, 13, tocolor('282A37'))
                    end
                    dxDrawImage(x+13.99, y+43, 69.95, 75, img.person2)
                    dxDrawText(v.nome.. ' ('..v.id..')', x+91.4, y+63, 170.68, 19, white, 1, getFont('regular', 12))
                    dxDrawText(v.cargo, x+91.4, y+79, 170.68, 19, tocolor('A1A1A1'), 1, getFont('regular', 10))

                    if v.player then 
                        dxDrawImage(x+64.36, y+97, 14, 15, img.circle, 0, 0, 0, tocolor('90FF5C'))
                    else
                        dxDrawImage(x+64.36, y+97, 14, 15, img.circle, 0, 0, 0, tocolor('FF5C5C'))
                    end
                end

                
            end

            if laptop.bussines.invite then 
                dxDrawRoundedRectangle(768, 444, 403, 168, 20, tocolor('191B21'))
                dxDrawText('Convidar membro', 797, 461, 140, 19, white, 1, getFont('semibold', 14))
                dxDrawText('x', 1143, 461, 9, 16, white, 1, getFont('semibold', 14))
    
                dxDrawRoundedRectangle(791, 488, 357, 48, 2, tocolor('282A31', 53))
    
                if guiGetText(laptop.bussines.invite.editbox) == '' then 
                    dxDrawText('Passaporte', 791, 488, 357, 48, white, 1, getFont('regular', 12), 'center', 'center')
                else
                    dxDrawText(guiGetText(laptop.bussines.invite.editbox), 791, 488, 357, 48, white, 1, getFont('regular', 12), 'center', 'center')
                end
    
                dxDrawRoundedRectangle(791, 544, 357, 41, 2, isCursorOnElement(791, 544, 357, 41) and tocolor('30313C', 60) or tocolor('30313C', 90))
                dxDrawText('Enviar convite', 791, 544, 357, 41, white, 1, getFont('regular', 12), 'center', 'center')
    
            end
            
        end
        


    end


end

function laptopManager ( type, value )
    if type == 'open' then 
        if not laptop.state then 
            laptop.state = true 
            addEventHandler('onClientRender', root, render)
            addEventHandler('onClientClick', root, clickManager)
            addEventHandler('onClientKey', root, keyManager)
            laptop.anims = {
                alpha = {0, 100, getTickCount(), 500},
            }
            manageSVG(true)
            showCursor(true)
            triggerServerEvent('openLaptop', localPlayer, localPlayer)
        end
    elseif type == 'close' then 
        if laptop.state then 
            laptop.state = false
            removeEventHandler('onClientRender', root, render)
            removeEventHandler('onClientClick', root, clickManager)
            removeEventHandler('onClientKey', root, keyManager)
            showCursor(false)
            manageSVG(false)
        end
    elseif type == 'vpn' then 
        laptop.vpn = value
    elseif type == 'gne' then 
        gne = value
    end
end
addEvent('laptopManager', true)
addEventHandler('laptopManager', root, laptopManager)

addEvent('openLaptop', true)
addEventHandler('openLaptop', root, function()
    if laptop.state then 
        laptopManager('close')
    else
        laptopManager('open')
    end
end)

function clickManager ( b, s )
    if b == 'left' and s == 'down' then 
        if isCursorOnElement(184, 208, 60, 83) then 
            if not laptop.crypto then 
                laptop.crypto = {}
                laptop.crypto.page = 'buy'
                laptop.crypto.editBox = guiCreateEdit(-1, -1, 0, 0, '')
                laptop.crypto.playerID = guiCreateEdit(-1, -1, 0, 0, '')
                guiEditSetMaxLength(laptop.crypto.editBox, 9)
                guiEditSetMaxLength(laptop.crypto.playerID, 9)
            else
                destroyElement(laptop.crypto.editBox)
                destroyElement(laptop.crypto.playerID)
                laptop.crypto = false 
            end
        elseif isCursorOnElement(180, 318, 79, 83) then 
            if not laptop.bussines then 
                laptop.bussines = {}
                laptop.bussines.page = 'home'
                triggerServerEvent('getGroups', resourceRoot, localPlayer)
                --[[laptop.bussines.groups = {
                    {
                        nome = 'Los Santos Police Department',
                        cargo = 'Cadete',
                        level = 1,
                        id = 1,
                        players = {
                            {
                                nome = 'Carlos Eduardo',
                                id = 1,
                                player = localPlayer,
                                cargo = 'Cadete'
                            }
                        },
                    },
                }]]
            else
                laptop.bussines = false 
            end
        end

        if laptop.bussines then 
            if isCursorOnElement(1488, 239, 22, 20) then
                laptop.bussines = false 
                return true
            end
            if laptop.bussines.page == 'home' then 
                if laptop.bussines.groups then 
                    for i,v in ipairs(laptop.bussines.groups) do 
                        local x, y = unpack(bussines.slots[i])
                        if isCursorOnElement(x+19, y+128, 102, 32) then 
                            laptop.bussines.page = 'grupo'
                            laptop.bussines.scroll = 0
                            laptop.bussines.selected = i 
                            break
                        end
                    end
                end
            elseif laptop.bussines.page == 'grupo' then 

                local grupo = laptop.bussines.groups[laptop.bussines.selected]
                local cargo = cfg.grupos[grupo.id].cargos[grupo.cargo]

                local k = 0
                for i,v in ipairs(grupo.players) do 
                    if k >= laptop.bussines.scroll and k <= 8 then 
                        k = k +1
                        local x, y = unpack(bussines.slots2[k])
                        if isCursorOnElement(x, y, 256, 160) then
                            if not laptop.bussines.playerSelected or laptop.bussines.playerSelected ~= k then 
                                laptop.bussines.playerSelected = k
                            else
                                laptop.bussines.playerSelected = nil
                            end
                        end
                    end
                end

                if isCursorOnElement(1376, 316, 135, 33) then 
                    triggerServerEvent('grupo:sair', localPlayer, localPlayer, grupo)
                    laptop.bussines = false
                    return true
                end

                if laptop.bussines.playerSelected then 
                    if cargo.permissoes['promover'] then 
                        if isCursorOnElement(1090, 355, 135, 33) then 

                            local target = grupo.players[laptop.bussines.playerSelected]
                            triggerServerEvent('grupo:promover', localPlayer, localPlayer, target, grupo)
                            
                        end
                    end

                    if cargo.permissoes['rebaixar'] then 
                        if isCursorOnElement(1233, 355, 135, 33) then 

                            local target = grupo.players[laptop.bussines.playerSelected]
                            triggerServerEvent('grupo:rebaixar', localPlayer, localPlayer, target, grupo)
                            
                        end
                    end

                    if cargo.permissoes['remover'] then 
                        if isCursorOnElement(1376, 355, 135, 33) then 

                            local target = grupo.players[laptop.bussines.playerSelected]
                            triggerServerEvent('grupo:remover', localPlayer, localPlayer, target, grupo)
                            
                        end
                    end


                end

                if cargo.permissoes['convidar'] then 
                    if isCursorOnElement(1233, 316, 135, 33) then 

                        print('clicou')
                        if not laptop.bussines.invite then 
                            laptop.bussines.invite = {
                                editbox = guiCreateEdit(-1, -1, 0, 0, ''),
                            }
                        else
                            laptop.bussines.invite = false 
                        end
                        
                    end

                    if laptop.bussines.invite then 
                        if isCursorOnElement(791, 488, 357, 48) then 
                            guiFocus(laptop.bussines.invite.editbox)
                        elseif isCursorOnElement(1143, 461, 9, 16) then 
                            laptop.bussines.invite = false 
                        elseif isCursorOnElement(791, 544, 357, 41) then 
                            local target = guiGetText(laptop.bussines.invite.editbox)
                            if target == '' then return end
                            triggerServerEvent('group:invite_player', localPlayer, localPlayer, target, grupo)
                        end
                    end
                end
            end
        end

        -- // CRYPTO
        if laptop.crypto then 
            if isCursorOnElement(1488, 239, 22, 20) then
                destroyElement(laptop.crypto.editBox)
                destroyElement(laptop.crypto.playerID)
                laptop.crypto = false 
            elseif isCursorOnElement(789, 377, 26, 15) then
                laptop.crypto.page = 'buy'
            elseif isCursorOnElement(850, 377, 68, 15) then
                laptop.crypto.page = 'transfer'
            elseif isCursorOnElement(930, 377, 68, 15) then
                laptop.crypto.page = 'sell'
            end
            if laptop.crypto then 
                if laptop.crypto.page == 'buy' or laptop.crypto.page == 'sell' then 
                    if isCursorOnElement(860, 587, 200, 36) then 
                        guiFocus(laptop.crypto.editBox)
                    elseif isCursorOnElement(835, 676, 250, 36) then 
                        triggerServerEvent(laptop.crypto.page..'GNE', resourceRoot, localPlayer, guiGetText(laptop.crypto.editBox))
                    end
                elseif laptop.crypto.page == 'transfer' then 
                    if isCursorOnElement(860, 622, 200, 36) then 
                        guiFocus(laptop.crypto.editBox)
                    elseif isCursorOnElement(860, 570, 200, 36) then 
                        guiFocus(laptop.crypto.playerID)
                    elseif isCursorOnElement(835, 676, 250, 36) then 
                        triggerServerEvent(laptop.crypto.page..'GNE', resourceRoot, localPlayer, guiGetText(laptop.crypto.editBox), guiGetText(laptop.crypto.playerID))
                    end
                end
            end
        end

        --[[
        if laptop.boosting then 
            if isCursorOnElement(1488, 239, 22, 20) then
                laptop.boosting = false 
            end
        end]]
    end
end

addEvent('updateBussines', true)
addEventHandler('updateBussines', root, function (groups)
    laptop.bussines.groups = groups
end)

function keyManager ( b, s )
    if s then 
        if b == 'escape' then 
            laptopManager('close')
            cancelEvent()
        elseif b == 'mouse_wheel_down' then 
            if laptop.bussines then 
                if laptop.bussines.page == 'grupo' then 
                    local players = laptop.bussines.groups[laptop.bussines.selected].players
                    if #players > 8 then 
                        if laptop.bussines.scroll < (#players -4) then 
                            laptop.bussines.scroll = (laptop.bussines.scroll or 0) + 4
                        end
                    end
                end
            end
        elseif b == 'mouse_wheel_up' then 
            if laptop.bussines then 
                if laptop.bussines.page == 'grupo' then 
                    if laptop.bussines.scroll >= 4 then 
                        laptop.bussines.scroll = (laptop.bussines.scroll or 0) -4
                    end
                end
            end
        end
    end
end

function formatTime ( sec )
    local minutos, segundos = math.modf(sec/60)
    segundos = segundos*60
    return string.format("%02d:%02d", minutos, segundos)
end