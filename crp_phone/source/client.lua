local phone = {}
local notify = {}
local homeNotify = {}
local apps = {}
local scroll = {
    galeria = 0,
    conversas = 0,
    contatos = 0,
}
local slots = {}
local notifyTick = 0
local printing = false
local isOpen = false
local editBox = {
    ['browse'] = guiCreateEdit(0, 0, 0, 0, ''),
    ['ln'] = guiCreateEdit(0, 0, 0, 0, ''),
    ['fn'] = guiCreateEdit(0, 0, 0, 0, ''),
    ['number'] = guiCreateEdit(0, 0, 0, 0, ''),
}
local images = {}

local camera = dxCreateScreenSource(1920, 1080)

local meses = {['1'] = 'janeiro', ['2'] = 'fevereiro', ['3'] = 'março', ['4'] = 'abril', ['5'] = 'maio', ['6'] = 'junho', ['7'] = 'julho', ['8'] = 'agosto', ['9'] = 'setembro', ['10'] = 'outubro', ['11'] = 'novembro', ['12'] = 'dezembro'}    

function render ( )

    --427.21
    local y, alpha = interpolateBetween((config.overlay.y+607), 0, 0, config.overlay.y, 100, 0, (getTickCount()-phone.tick)/500, 'Linear')
    local white = _tocolor(255, 255, 255, (alpha / 100 * 255))
    local x = config.overlay.x --1590.21

    dxDrawImage(x, y, config.overlay.widht, config.overlay.height, 'assets/images/overlay.png', 0, 0, 0, _tocolor(255, 255, 255, (alpha / 100 * 255)))
    if phone.page == 'home' or phone.page == 'block' then 
        dxDrawImage(x+22, y+18, (config.overlay.widht-44), (config.overlay.height-36), phone.wallpaper or 'assets/images/wallpaper.png', 0, 0, 0, _tocolor(255, 255, 255, (alpha / 100 * 255)))
    else 


        local time = getRealTime()
        local hour = time.hour
        local minute = time.minute
        local day = time.monthday
        local month = time.month + 1
        local year = time.year+1900


        dxDrawText(string.format('%02d:%02d', hour, minute), x+50, y+27, 38, 17, white, 1, getFont('semibold', 12))
        dxDrawText('100', x+338, y+31, 16, 6, tocolor('000000'), 1, getFont('semibold', 8), 'center', 'center')

    end
    dxDrawImage(x+295, y+27, 63, 14, 'assets/images/stats.png', 0, 0, 0, _tocolor(255, 255, 255, (alpha / 100 * 255)))
    if phone.page ~= 'home' then 
        dxDrawRoundedRectangle(x+115, y+722-10, 170, 5, 5, isCursorOnElement(x+115, y+722-10, 170, 15) and tocolor('FFFFFF', alpha-30) or _tocolor(255, 255, 255, (alpha / 100 * 255)))
    end

    if phone.page then 
        if phone.page == 'block' then 
            local time = getRealTime()
            local hour = time.hour
            local minute = time.minute
            local day = time.monthday
            local month = time.month + 1
            local year = time.year+1900

            dxDrawImage(x+192, y+76, 16, 24, 'assets/images/lock.png', 0, 0, 0, _tocolor(255, 255, 255, (alpha / 100 * 255)))
            dxDrawText(day..' de '..meses[''..month..'']..', '..year, x+73, y+132, 253, 23, white, 1, getFont('semibold', 16), 'center', 'top')
            dxDrawText(string.format('%02d:%02d', hour, minute), x+91, y+151, 218, 79, white, 1, getFont('semibold', 55), 'center', 'top')
            dxDrawText('Chip', x+50, y+27, 38, 17, white, 1, getFont('semibold', 12), 'center', 'center')


            if homeNotify then 
                if #homeNotify > 0 then 
                    for i,v in ipairs(homeNotify) do 
                        if i > 0 and i <= 4 and v then 

                            local y = y + 270 + (-77 + (77 * i))
                            local x = x+36
                            
                            local x = interpolateBetween(x - 20, 0, 0, x, 0, 0, (getTickCount()-v.tick)/500, 'Linear')
                            local alpha = interpolateBetween(0, 0, 0, 100, 0, 0, (getTickCount()-v.tick)/700, 'Linear')

                            dxDrawImage(x, y, 328, 70, 'assets/images/basenotify.png', 0, 0, 0, tocolor('FFFFFF', alpha))
                            dxDrawImage(x+8, y+16, 38, 38, v.img, 0, 0, 0, tocolor('FFFFFF', alpha))
                            dxDrawText(v.title, x+55, y+12, 66, 16, tocolor('000000', alpha), 1, getFont('medium', 13))
                            dxDrawText(v.msg, x+55, y+28, 262, 13, tocolor('2D2D2D', alpha), 1, getFont('regular', 10), 'left', 'top', false, true)

                        end
                    end
                end
            end

            dxDrawImage(x+59, y+628, 281, 50, 'assets/images/cameraelight.png', 0, 0, 0, white)

        elseif phone.page == 'home' then 

            local time = getRealTime()
            local hour = time.hour
            local minute = time.minute
            local day = time.monthday
            local month = time.month + 1
            local year = time.year+1900


            dxDrawText(string.format('%02d:%02d', hour, minute), x+50, y+27, 38, 17, white, 1, getFont('semibold', 12))
            dxDrawRoundedRectangle(x+38, y+657, 320, 57, 20, tocolor('FFFFFF', alpha-60))
            
            local iX = 0
            local iY = 1
            for i,v in ipairs(config.apps) do 


                if iX == 4 then 
                    iX = 0
                    iY = iY +1
                end
                iX = iX +1

                local x = x + 55 + (-78 + (78 * iX)) 
                local y = y + 88 + (-88 + (88 * iY))


                if v.nome then
                    dxDrawText(v.nome, x, y+55, 55, 15, white, 1, getFont('regular', 10), 'center')
                end

                if not isCursorOnElement(x, y, 55, 55) then 
                    dxDrawImage(x, y, 55, 55, v.image, 0, 0, 0, white)
                else
                    dxDrawImage(x, y, 55, 55, v.image, 0, 0, 0, tocolor('FFFFFF', alpha-20))
                end

                if not apps[i] then 
                    apps[i] = {image = v.image, page = v.page, position = {x, y, 55, 55}}
                end

            end

        elseif phone.page == 'camera' then 



            dxUpdateScreenSource(camera)

            local w, h = 500, 900
            local u, v = 1920/2-(w/2), 1080/2-(h/2)
            dxDrawImageSection(x+17+2, y+62, 360, 510, u, v, w, h, camera)

            dxDrawImage(x+17+2, y+572, 360, 42.12, 'assets/images/camera/bottom.png', 0, 0, 0, white)
            dxDrawImage(x+165-2, y+631, 67, 65, 'assets/images/camera/circle.png', 0, 0, 0, isCursorOnElement(x+165-2, y+631, 67, 65) and tocolor('FFFFFF', alpha-20) or white)
            if not printing then
                dxDrawImage(x+165-2, y+631, 67, 65, 'assets/images/camera/border.png', 0, 0, 0, isCursorOnElement(x+165-2, y+631, 67, 65) and tocolor('FFFFFF', alpha-20) or white)
            end
            
            if phone.galeria then 
                if #phone.galeria > 0 then 
                    dxDrawImage(x+37, y+639, 50, 50, phone.galeria[#phone.galeria].path, 0, 0, 0, white)
                end
            end

            if printing then 

                local a = interpolateBetween(printing[1], 0, 0, printing[2], 0, 0, (getTickCount()-printing[3])/printing[4], 'Linear')
                --dxDrawImage(x+124.79, y+482.79, 50, 50, 'assets/images/camera/border.png', 0, 0, 0, isCursorOnElement(x+124.79, y+482.79, 50, 50) and tocolor('FFFFFF', alpha-20) or white)
                dxDrawImage(x+17.54+2, y+18.29, 355.97, 713.57, 'assets/images/background.png', 0, 0, 0, tocolor('FFFFFF', a))

                
                if (getTickCount()-printing[3])/printing[4] >= 1 then 
                    if printing[1] == 0 then 
                        printing = {100, 0, getTickCount(), 200}
                    else
                        printing = false
                    end
                end

            end
        elseif phone.page == 'galeria' then 
            if not phone.selectedImage then 
                dxDrawText('Fotos', x+20, y+74, 355, 29, white, 1, getFont('semibold', 20), 'center', 'top')
            end

            if phone.galeria then 

                local iX2 = 0
                local iY2 = 1

                if not slots.galeria then 
                    slots.galeria = {}
                end

                if not phone.selectedImage then 
                    for i, v in ipairs(phone.galeria) do 

                        if iX2 == 5 then 
                            iX2 = 0
                            iY2 = iY2 +1
                        end
                        iX2 = iX2 +1
                        
                        local Y2 = iY2 - scroll.galeria

                        print(Y2)

                        if Y2 > 0 and Y2 <= 7 then 
                            local x = x + 31 + (-68 + (68 * iX2))
                            local y = y + 130 + (-77.15 + (77.15 * Y2))

                            dxDrawRectangle(x, y, 65, 74.15, white)

                            if not isDownloadingImage ( v.fileName ) then 
                                dxDrawImage(x, y, 65, 74.15, v.path)
                            end
                            
                        end

                    end
                end

                if phone.selectedImage then 

                    local image = phone.galeria[phone.selectedImage]

                    dxDrawRectangle(x+21, y+97, 357, 564, white)
                    dxDrawImage(x+21, y+97, 357, 564, image.path)
                    dxDrawText(image.fileName, x+20, y+64, 355, 24, white, 1, getFont('medium', 10), 'center')
                    dxDrawImage(x+180, y+670, 35, 35, 'assets/images/galeria/trash.png', 0, 0, 0, isCursorOnElement(x+180, y+670, 35, 35) and tocolor('FFFFFF', alpha-20) or white)
                    dxDrawText('<', x+28, y+50, 22, 39, tocolor('032F5A', alpha), 1, getFont('regular', 30))
                    
                end
            end
        elseif phone.page == 'contatos' then 

            local x = x -5
            dxDrawText('Contatos', x+41.91, y+76.28, 156.51, 27.16, white, 1, getFont('semibold', 16))
            dxDrawText('+', x+355, y+76, 19, 27, tocolor('065EB5', alpha), 1, getFont('semibold', 20))

            dxDrawRoundedRectangle(x+41.91, y+119.48, 329.35, 25.92, 5, tocolor('161616', alpha))
            dxDrawImage(x+52.8, y+124.42, 16.33, 14.81, 'assets/images/phone-app/browse.png', 0, 0, 0, white)

            local text = guiGetText(editBox['browse'])
            if text == '' then 
                dxDrawText('Buscar', x+80.2, y+119.48, 59.88, 25.92, white, 1, getFont('semibold', 10), 'left', 'center')
            else
                dxDrawText(text, x+80.2, y+119.48, 59.88, 25.92, white, 1, getFont('semibold', 10), 'left', 'center')
            end

            dxDrawImage(x+41.91, y+166.39, 55.8, 55.8, 'assets/images/phone-app/avatar.png', 0, 0, 0, tocolor('4c4c4c', alpha))
            dxDrawText(string.gsub(getPlayerName(localPlayer), '_', ' '), x+108.59, y+179.97, 126.57, 12.34, white, 1, getFont('semibold', 12))
            dxDrawText(getElementData(localPlayer, 'Numero') or 'Meu contato', x+108.59, y+197.25, 126.57, 12.34, tocolor('4c4c4c', alpha), 1, getFont('semibold', 10))
            if phone.contatos then 
                if #phone.contatos > 0 then 
                    
                    local index = 0
                    for i,v in ipairs(phone.contatos) do 

                        if index >= (scroll.contatos or 0) and index <= 6 then 
                            if text == '' or string.find(v.nome, text) then 
                                index = index + 1

                                local x = x+41.91
                                local y = y + 239.22 + ( -58.01 + (58.01 * index) )

                                dxDrawRectangle(x, y, 329, 1, tocolor('4C4C4C', alpha))
                                dxDrawText(v.nome, x, y+10, 242, 14, white, 1, getFont('semibold', 10))
                                dxDrawText(v.numero, x, y+24, 242, 14, tocolor('4C4C4C', alpha), 1, getFont('semibold', 10))

                                dxDrawImage(x+257.22, y+14.22, 16.33, 14.81, 'assets/images/phone-app/phone.png', 0, 0, 0, isCursorOnElement(x+257.22, y+14.22, 16.33, 14.81) and white or tocolor('4C4C4C', alpha))
                                dxDrawImage(x+287.16, y+14.22, 16.33, 14.81, 'assets/images/phone-app/edit.png', 0, 0, 0, isCursorOnElement(x+287.16, y+14.22, 16.33, 14.81) and white or tocolor('4C4C4C', alpha))
                                dxDrawImage(x+317.1, y+14.22, 12.25, 14.28, 'assets/images/phone-app/trash.png', 0, 0, 0, isCursorOnElement(x+317.1, y+14.22, 12.25, 14.28) and white or tocolor('4C4C4C', alpha))
                            end
                        end

                    end

                end
            end

            dxDrawImage(x+130, y+655, 25.92, 25.92, 'assets/images/phone-app/historic.png', 0, 0, 0, tocolor('4c4c4c', alpha))
            dxDrawText('Recentes', x+130, y+684, 25.92, 25.92, tocolor('4c4c4c', alpha), 1, getFont('regular', 9), 'center')
            dxDrawImage(x+195, y+655, 25.92, 25.92, 'assets/images/phone-app/contatos.png', 0, 0, 0, tocolor('065EB5', alpha))
            dxDrawText('Contatos', x+195, y+684, 25.92, 25.92, tocolor('065EB5', alpha), 1, getFont('regular', 9), 'center')
            dxDrawImage(x+260, y+655, 25.92, 25.92, 'assets/images/phone-app/teclado.png', 0, 0, 0, tocolor('4c4c4c', alpha))
            dxDrawText('Teclado', x+260, y+684, 25.92, 25.92, tocolor('4c4c4c', alpha), 1, getFont('regular', 9), 'center')
        elseif phone.page == 'add-contato' then 
            
            local firstName = guiGetText(editBox['fn'])
            local lastName = guiGetText(editBox['ln'])
            local number = guiGetText(editBox['number'])

            dxDrawText('Cancel', x+36, y+56, 53, 22, tocolor('0075FF', alpha), 1, getFont('semibold', 12))
            dxDrawText('Done', x+319, y+56, 42, 22, tocolor('0075FF', alpha), 1, getFont('semibold', 12))

            dxDrawImage(x+140, y+111, 120, 120, 'assets/images/phone-app/contatos.png', 0, 0, 0, tocolor('4C4C4C', alpha))

            dxDrawRoundedRectangle(x+36, y+297, 325, 68, 5, tocolor('090909', alpha))

            if firstName == '' then 
                dxDrawText('Nome', x+51, y+297, 289, 34, tocolor('626262', alpha), 1, getFont('medium', 10), 'left', 'center')
            else
                dxDrawText(firstName, x+51, y+297, 289, 34, white, 1, getFont('medium', 10), 'left', 'center')
            end

            dxDrawRectangle(x+51, y+331, 296, 1, tocolor('121212', alpha))

            if lastName == '' then 
                dxDrawText('Sobrenome', x+51, y+332, 289, 34, tocolor('626262', alpha), 1, getFont('medium', 10), 'left', 'center')
            else
                dxDrawText(lastName, x+51, y+332, 289, 34, white, 1, getFont('medium', 10), 'left', 'center')
            end

            dxDrawRoundedRectangle(x+36, y+388, 325, 34, 5, tocolor('090909', alpha))
            if number == '' then 
                dxDrawText('Número', x+44, y+394, 315, 22, tocolor('0075FF', alpha), 1, getFont('medium', 10), 'left', 'center')
            else
                dxDrawText(number, x+44, y+394, 315, 22, tocolor('0075FF', alpha), 1, getFont('medium', 10), 'left', 'center')
            end

            dxDrawImage(x+130, y+655, 25.92, 25.92, 'assets/images/phone-app/historic.png', 0, 0, 0, tocolor('4c4c4c', alpha))
            dxDrawText('Recentes', x+130, y+684, 25.92, 25.92, tocolor('4c4c4c', alpha), 1, getFont('regular', 9), 'center')
            dxDrawImage(x+195, y+655, 25.92, 25.92, 'assets/images/phone-app/contatos.png', 0, 0, 0, tocolor('065EB5', alpha))
            dxDrawText('Contatos', x+195, y+684, 25.92, 25.92, tocolor('065EB5', alpha), 1, getFont('regular', 9), 'center')
            dxDrawImage(x+260, y+655, 25.92, 25.92, 'assets/images/phone-app/teclado.png', 0, 0, 0, tocolor('4c4c4c', alpha))
            dxDrawText('Teclado', x+260, y+684, 25.92, 25.92, tocolor('4c4c4c', alpha), 1, getFont('regular', 9), 'center')
        elseif phone.page == 'edit-contato' then 
            
            local firstName = guiGetText(editBox['fn'])
            local lastName = guiGetText(editBox['ln'])

            dxDrawText('Cancel', x+36, y+56, 53, 22, tocolor('0075FF', alpha), 1, getFont('semibold', 12))
            dxDrawText('Done', x+319, y+56, 42, 22, tocolor('0075FF', alpha), 1, getFont('semibold', 12))

            dxDrawImage(x+140, y+111, 120, 120, 'assets/images/phone-app/contatos.png', 0, 0, 0, tocolor('4C4C4C', alpha))

            dxDrawRoundedRectangle(x+36, y+297, 325, 68, 5, tocolor('090909', alpha))

            if firstName == '' then 
                dxDrawText('Nome', x+51, y+297, 289, 34, tocolor('626262', alpha), 1, getFont('medium', 10), 'left', 'center')
            else
                dxDrawText(firstName, x+51, y+297, 289, 34, white, 1, getFont('medium', 10), 'left', 'center')
            end

            dxDrawRectangle(x+51, y+331, 296, 1, tocolor('121212', alpha))

            if lastName == '' then 
                dxDrawText('Sobrenome', x+51, y+332, 289, 34, tocolor('626262', alpha), 1, getFont('medium', 10), 'left', 'center')
            else
                dxDrawText(lastName, x+51, y+332, 289, 34, white, 1, getFont('medium', 10), 'left', 'center')
            end

            dxDrawImage(x+130, y+655, 25.92, 25.92, 'assets/images/phone-app/historic.png', 0, 0, 0, tocolor('4c4c4c', alpha))
            dxDrawText('Recentes', x+130, y+684, 25.92, 25.92, tocolor('4c4c4c', alpha), 1, getFont('regular', 9), 'center')
            dxDrawImage(x+195, y+655, 25.92, 25.92, 'assets/images/phone-app/contatos.png', 0, 0, 0, tocolor('065EB5', alpha))
            dxDrawText('Contatos', x+195, y+684, 25.92, 25.92, tocolor('065EB5', alpha), 1, getFont('regular', 9), 'center')
            dxDrawImage(x+260, y+655, 25.92, 25.92, 'assets/images/phone-app/teclado.png', 0, 0, 0, tocolor('4c4c4c', alpha))
            dxDrawText('Teclado', x+260, y+684, 25.92, 25.92, tocolor('4c4c4c', alpha), 1, getFont('regular', 9), 'center')
        
        elseif phone.page == 'mensagens' then 

            dxDrawText('Mensagens', x+42, y+58, 135, 29, white, 1, getFont('semibold', 20), 'left', 'top')
            dxDrawImage(x+334, y+63, 20, 20, 'assets/images/messages/edit.png', 0, 0, 0, white)

            dxDrawRoundedRectangle(x+35, y+104, 329.35, 25.92, 5, tocolor('161616', alpha))
            dxDrawImage(x+45.89, y+108.94, 16.33, 14.81, 'assets/images/phone-app/browse.png', 0, 0, 0, white)

            local text = guiGetText(editBox['browse'])
            if text == '' then 
                dxDrawText('Buscar', x+70.3, y+104, 59.88, 25.92, white, 1, getFont('semibold', 10), 'left', 'center')
            else
                dxDrawText(text, x+70.3, y+104, 59.88, 25.92, white, 1, getFont('semibold', 10), 'left', 'center')
            end

            if phone.conversas then 
                local index = 0
                for i,v in ipairs(phone.conversas) do 
                    if index >= (scroll.conversas or 0) and index <= 9 then 
                        if text == '' or string.find((v.nome or v.numero), text) then 

                            index = index +1

                            local y = y+156+(-57 + (57 * index))
                            local x = x+35

                            dxDrawImage(x+8, y, 40, 40, 'assets/images/phone-app/contatos.png', 0, 0, 0, tocolor('8F8D93', alpha))
                            dxDrawText((v.nome or v.numero), x+60, y, 208, 22, white, 1, getFont('semibold', 12), 'left', 'center')
                            dxDrawText(v.lastMsg.msg or '', x+60, y+16, 208, 22, tocolor('ADADAD', alpha), 1, getFont('regular', 10), 'left', 'center')
                            dxDrawImage(x+304, y, 24, 24, 'assets/images/messages/expand.png', 0, 0, 0, tocolor('D9D9D9', alpha))
                            dxDrawRectangle(x, y+49, 329, 1, tocolor('161616', alpha))

                            if v.notify then 
                                dxDrawImage(x-9, y+19, 10, 10, 'assets/images/messages/circle.png', 0, 0, 0, tocolor('065EB5', alpha))
                            end

                        end
                    end
                end
            end

        end
    end

    
    if notify then 
        if #notify > 0 then 
            for i,v in ipairs(notify) do 
                if i > 0 and i <= 4 and v then 

                    local y = y + 53 + (-78 + (78 * i))
                    local x = x+21

                    local x = interpolateBetween(x - 20, 0, 0, x, 0, 0, (getTickCount()-v.tick)/500, 'Linear')
                    local alpha = interpolateBetween(0, 0, 0, 100, 0, 0, (getTickCount()-v.tick)/700, 'Linear')

                    dxDrawImage(x+10, y, 356-20, 70, 'assets/images/basenotify.png', 0, 0, 0, white)
                    dxDrawImage(x+18, y+15, 39, 38, v.img, 0, 0, 0, white)
                    dxDrawText(v.title, x+65, y+12, 66, 16, tocolor('000000', alpha), 1, getFont('medium', 13))
                    dxDrawText(v.msg, x+66, y+28, 262, 13, tocolor('2D2D2D', alpha), 1, getFont('regular', 10), 'left', 'top', false, true)

                    if (getTickCount() - v.tick) / v.time >= 1 then 
                        table.insert(homeNotify, {img = v.img, title = v.title, msg = v.msg, tick = getTickCount()})
                        table.remove(notify, i)

                        if #notify == 0 then 
                            notifyTick = 0
                        end
                    end

                end
            end
        end
    end

end

function managePhone ( type, value )
    if type == 'open' then 
        if not isOpen then 
            addEventHandler('onClientRender', root, render)
            addEventHandler('onClientClick', root, clickManager)
            addEventHandler('onClientKey', root, keyManager)
            isOpen = true 
            showCursor(true)
            phone = {}
            apps = {}
            phone.page = 'home'
            phone.tick = getTickCount()
            phone.page = 'block'
        else
            removeEventHandler('onClientRender', root, render)
            removeEventHandler('onClientClick', root, clickManager)
            removeEventHandler('onClientKey', root, keyManager)
            isOpen = false 
            showCursor(false)
            if phone.page == 'camera' then 
                manageCamera(false)
            end
        end

    elseif type == 'close' then 
        if isOpen then 
            removeEventHandler('onClientRender', root, render)
            removeEventHandler('onClientClick', root, clickManager)
            removeEventHandler('onClientKey', root, keyManager)
            isOpen = false 
            showCursor(false)
            if phone.page == 'camera' then 
                manageCamera(false)
            end
        end
    elseif type == 'photos' then 
        phone.galeria = value

        for i,v in ipairs(phone.galeria) do 
            if not fileExists(v.path) then 
                downloadImage ( v.fileName )
            end
        end
    elseif type == 'contatos' then 
        phone.contatos = value
    end
end
addEvent('managePhone', true)
addEventHandler('managePhone', resourceRoot, managePhone)

function clickManager (b, s )

    local x, y = config.overlay.x, config.overlay.y

    if isOpen then 
        if phone.page then 
            if phone.page == 'block' then 
                if homeNotify then 
                    if #homeNotify > 0 then 
                        for i,v in ipairs(homeNotify) do 
                            if i <= 4 then 

                                local y = y + 270 + (-77 + (77 * i))
                                local x = x+36

                                if isCursorOnElement(x, y, 328, 70) then 
                                    table.remove(homeNotify, i)
                                    break
                                end
                            end
                        end
                    end
                end
                if isCursorOnElement(x+290.58, y+628, 50, 50) then 
                    phone.page = 'camera'
                    manageCamera(true)
                end
            elseif phone.page == 'home' then 
                if apps then 
                    if #apps > 0 then 
                        for i,v in ipairs(apps) do 
                            if isCursorOnElement(unpack(v.position)) then 
                                phone.page = v.page 
                                if v.page == 'camera' then 
                                    manageCamera (true)
                                end
                                if v.page == 'galeria' then 
                                    triggerServerEvent('getPhotos', localPlayer, localPlayer)
                                end
                                if v.page == 'contatos' then 
                                    triggerServerEvent('getContatos', localPlayer, localPlayer)
                                end
                                if v.page == 'mensagens' then
                                    phone.conversas = {
                                        {
                                            nome = 'Paulinho',
                                            numero = '123-456',
                                            notify = true,
                                            lastMsg = {msg = 'Salve fiote'},
                                        },
                                        {
                                            nome = 'Paulinho',
                                            numero = '123-456',
                                            notify = true,
                                            lastMsg = {msg = 'Salve fiote'},
                                        },
                                        {
                                            nome = 'Paulinho',
                                            numero = '123-456',
                                            notify = true,
                                            lastMsg = {msg = 'Salve fiote'},
                                        },
                                        {
                                            nome = 'Paulinho',
                                            numero = '123-456',
                                            notify = true,
                                            lastMsg = {msg = 'Salve fiote'},
                                        },
                                        {
                                            nome = 'Paulinho',
                                            numero = '123-456',
                                            notify = true,
                                            lastMsg = {msg = 'Salve fiote'},
                                        },
                                        {
                                            nome = 'Paulinho',
                                            numero = '123-456',
                                            notify = true,
                                            lastMsg = {msg = 'Salve fiote'},
                                        },
                                    } 
                                end
                                break 
                            end
                        end
                    end
                end
            elseif phone.page == 'camera' then 

                if isCursorOnElement(x+165-2, y+631, 67, 65) then 
                    if not printing then 
                        printing = {0, 100, getTickCount(), 800}
                        takePicture()
                    end
                elseif isCursorOnElement(x+37, y+639, 50, 50) then 
                    if phone.galeria then 
                        if #phone.galeria > 0 then 
                            manageCamera(false)
                            phone.page = 'galeria'
                            phone.selectedImage = #phone.galeria
                        end
                    end
                end

            elseif phone.page == 'galeria' then 

                local ciX2 = 0
                local ciY2 = 1
                if phone.galeria then 
                    if not phone.selectedImage then 
                        for i, v in ipairs(phone.galeria) do 

                            if ciX2 == 5 then 
                                ciX2 = 0
                                ciY2 = ciY2 +1
                            end
                            ciX2 = ciX2 +1

                            local Y2 = ciY2 - scroll.galeria
                            
                            if Y2 > 0 and Y2 <= 7 then 
                                local x = x + 31 + (-68 + (68 * ciX2))
                                local y = y + 130 + (-77.15 + (77.15 * Y2))
        
                                if isCursorOnElement(x, y, 65, 74.15) then 
                                    
                                    phone.selectedImage = i

                                end
                                
                            end
        
                        end
                    else
                        if isCursorOnElement(x+28, y+50, 22, 39) then 
                            phone.selectedImage = false
                        elseif isCursorOnElement(x+180, y+670, 35, 35) then 
                            triggerServerEvent('server:deleteImage', localPlayer, localPlayer, phone.galeria[phone.selectedImage].fileName)
                            phone.selectedImage = false
                        end
                    end
                end

            elseif phone.page == 'contatos' then 

                if isCursorOnElement(x+41.91, y+119.48, 329.35, 25.92) then 
                    guiFocus(editBox['browse'])
                elseif isCursorOnElement(x+355, y+76, 19, 27) then 
                    phone.page = 'add-contato'
                end

                if phone.contatos then 
                    if #phone.contatos > 0 then 
                        
                        local k = 0
                        for i,v in ipairs(phone.contatos) do 
    
                            if k >= (scroll.contatos or 0) and k <= 6 then 
                                local text = guiGetText(editBox['browse'])
                                if text == '' or string.find(v.nome, text) then 
                                    k = k + 1
    
                                    local x = x+41.91 -5
                                    local y = y + 239.22 + ( -58.01 + (58.01 * k) )
                                
                                    if isCursorOnElement(x+257.22, y+14.22, 16.33, 14.81) then 
                                        -- ligar
                                    elseif isCursorOnElement(x+287.16, y+14.22, 16.33, 14.81) then 
                                        phone.page = 'edit-contato'
                                        phone.selectedContato = v.numero
                                        guiSetText(editBox['fn'], v.nome)
                                    elseif isCursorOnElement(x+317.1, y+14.22, 12.25, 14.28) then 
                                        triggerServerEvent('deleteContato', resourceRoot, localPlayer, v.numero)
                                        break
                                    end
                                
                                end
                            end
    
                        end
    
                    end
                end
            elseif phone.page == 'add-contato' then 
                if isCursorOnElement(x+51, y+297, 289, 34) then
                    guiFocus(editBox['fn']) 
                elseif isCursorOnElement(x+51, y+332, 289, 34) then
                    guiFocus(editBox['ln']) 
                elseif isCursorOnElement(x+44, y+394, 315, 22) then
                    guiFocus(editBox['number']) 
                elseif isCursorOnElement(x+319, y+56, 42, 22) then 
                    if guiGetText(editBox['fn']) ~= '' and guiGetText(editBox['number']) ~= '' then 

                        triggerServerEvent('addContato', resourceRoot, localPlayer, guiGetText(editBox['fn']), guiGetText(editBox['ln']), guiGetText(editBox['number']))
                        phone.page = 'contatos'
                    
                    end
                elseif isCursorOnElement(x+36, y+56, 53, 22) then
                    phone.page = 'contatos' 
                end
            elseif phone.page == 'edit-contato' then 
                if isCursorOnElement(x+51, y+297, 289, 34) then
                    guiFocus(editBox['fn']) 
                elseif isCursorOnElement(x+51, y+332, 289, 34) then
                    guiFocus(editBox['ln']) 
                elseif isCursorOnElement(x+319, y+56, 42, 22) then 
                    if guiGetText(editBox['fn']) ~= '' and phone.selectedContato then 

                        triggerServerEvent('editContato', resourceRoot, localPlayer, guiGetText(editBox['fn']), guiGetText(editBox['ln']), phone.selectedContato)
                        phone.page = 'contatos'
                        phone.selectedContato = false 
                        guiSetText(editBox['fn'], '')
                        guiSetText(editBox['ln'], '')
                    
                    end
                elseif isCursorOnElement(x+36, y+56, 53, 22) then
                    phone.page = 'contatos' 
                    phone.selectedContato = false 
                    guiSetText(editBox['fn'], '')
                    guiSetText(editBox['ln'], '')
                end
            end

            if notify then 
                if #notify > 0 then 
                    for i,v in ipairs(notify) do 
                        if i <= 4 then 

                            local y = y + 53 + (-78 + (78 * i))
                            local x = x+21        

                            if isCursorOnElement(x+10, y, 356-20, 70) then 
                                table.insert(homeNotify, {img = v.img, title = v.title, msg = v.msg, tick = getTickCount()})
                                table.remove(notify, i)
                                break
                            end
                        end
                    end
                end
            end

            if phone.page ~= 'home' then 
                if isCursorOnElement(x+115, y+722-10-5, 170, 15) then 
                    if phone.page == 'camera' then 
                        manageCamera (false)
                    end
                    phone.page = 'home'
                    return true
                end
            end
        end
    end
end

function keyManager (b, s)
    if isOpen then 
        if s then 
            if b == 'mouse_wheel_down' then 
                if phone.page == 'galeria' and not phone.selectedImage then 
                    local sc = scroll.galeria or 0
                    if phone.galeria then 
                        if #phone.galeria > 35 and sc < (#phone.galeria/7) then 
                            scroll.galeria = sc + 1
                            print(scroll.galeria)
                        end
                    end
                end
            elseif b == 'mouse_wheel_up' then 
                if phone.page == 'galeria' and not phone.selectedImage then 
                    local sc = scroll.galeria or 0
                    if phone.galeria then 
                        if sc >= 1 and scroll.galeria -1 >= 0 then 
                            scroll.galeria = sc - 1
                            print(scroll.galeria)
                        end
                    end
                end
            end
        end
    end
end

bindKey('k', 'down', function ( )
    managePhone ( 'open' )
end)

addCommandHandler('notify', function ( )
    triggerEvent('phone:notify', localPlayer, 'Instagram', 'João Feijão (@joaozinho) começou a seguir você.', 'assets/images/icons/instagram.png' )
end)



addEvent('phone:notify', true)
addEventHandler('phone:notify', root, function(title, msg, image)
    if isOpen then 
        table.insert(notify, {img = image, title = title, msg = msg, tick = getTickCount(), time = 5000})
    else
        table.insert(notify, {img = image, title = title, msg = msg, tick = getTickCount(), time = 5000})
        if notifyTick == 0 then 
            notifyTick = getTickCount()
        end
    end
end)

addEventHandler('onClientRender', root, function ()
    if not isOpen then 
        if notify then 
            if #notify > 0 then 
                local y, alpha = interpolateBetween(1080, 0, 0, 948, 100, 0, (getTickCount()-notifyTick)/400, 'Linear')
                local white = _tocolor(255, 255, 255, (alpha / 100 * 255))
                local x = config.overlay.x
                local time = getRealTime()
                local hour = time.hour
                local minute = time.minute
            
                dxDrawImage(x, y, config.overlay.widht, config.overlay.height, 'assets/images/overlay.png', 0, 0, 0, _tocolor(255, 255, 255, (alpha / 100 * 255)))
                dxDrawImage(x+22, y+18, (config.overlay.widht-44), (config.overlay.height-36), phone.wallpaper or 'assets/images/wallpaper.png', 0, 0, 0, _tocolor(255, 255, 255, (alpha / 100 * 255)))
                dxDrawImage(x+295, y+27, 63, 14, 'assets/images/stats.png', 0, 0, 0, _tocolor(255, 255, 255, (alpha / 100 * 255)))
                dxDrawText(string.format('%02d:%02d', hour, minute), x+50, y+27, 38, 17, white, 1, getFont('semibold', 12))

                for i,v in ipairs(notify) do 
                    if i > 0 and i == #notify and v then 
    
                        local y = y + 53
                        local x = x+30
    
                        dxDrawImage(x, y, 340, 70, 'assets/images/basenotify.png', 0, 0, 0, white)
                        dxDrawImage(x+18, y+15, 39, 38, v.img, 0, 0, 0, white)
                        dxDrawText(v.title, x+65, y+12, 66, 16, tocolor('000000', alpha), 1, getFont('medium', 12))
                        dxDrawText(v.msg, x+65, y+28, 262, 13, tocolor('2D2D2D', alpha), 1, getFont('regular', 10), 'left', 'top', false, true)
    
                        if (getTickCount() - v.tick) / v.time >= 1 then 
                            table.insert(homeNotify, {img = v.img, title = v.title, msg = v.msg, tick = getTickCount()})
                            table.remove(notify, i)

                            if #notify == 0 then 
                                notifyTick = 0
                            end
                        end
    
                    end
                end

            end
        end
    end
end)

-- CAMERA
local sw, sh = guiGetScreenSize()
local speed, strafespeed = 0, 0
local rotX, rotY = 0,0
local mouseFrameDelay = 0

local options = 
{
    invertMouseLook = false,
    mouseSensitivity = 0.15
}

function math.clamp ( value, lower, upper )
 value, lower, upper = tonumber ( value ), tonumber ( lower ), tonumber ( upper )
 if value and lower and upper then
  if value < lower then 
   value = lower
  elseif value > upper then 
   value = upper 
  end
  return value
 end
 return false
end


function getElementOffset ( entity, offX, offY, offZ )
    local posX, posY, posZ = 0, 0, 0
    if isElement ( entity ) and type ( offX ) == "number" and type ( offY ) == "number" and type ( offZ ) == "number" then
     local center = getElementMatrix ( entity )
     if center then
      posX = offX * center [ 1 ] [ 1 ] + offY * center [ 2 ] [ 1 ] + offZ * center [ 3 ] [ 1 ] + center [ 4 ] [ 1 ]
      posY = offX * center [ 1 ] [ 2 ] + offY * center [ 2 ] [ 2 ] + offZ * center [ 3 ] [ 2 ] + center [ 4 ] [ 2 ]
      posZ = offX * center [ 1 ] [ 3 ] + offY * center [ 2 ] [ 3 ] + offZ * center [ 3 ] [ 3 ] + center [ 4 ] [ 3 ]
     end
    end
    return posX, posY, posZ
end

function cameraRender ( )
    local PI = math.pi
    --[[
    if getKeyState ( "num_4" ) then
     rotX = rotX - options.mouseSensitivity * 0.05745
    elseif getKeyState ( "num_6" ) then
     rotX = rotX + options.mouseSensitivity * 0.05745
    end
    if getKeyState ( "num_8" ) then
     rotY = rotY + options.mouseSensitivity * 0.05745  
     rotY = math.clamp ( rotY, -PI / 2.05, PI / 2.05 )
    elseif getKeyState ( "num_2" ) then
     rotY = rotY - options.mouseSensitivity * 0.05745
     rotY = math.clamp ( rotY, -PI / 2.05, PI / 2.05 )
    end]]
    local cameraAngleX = rotX 
    local cameraAngleY = rotY
   
    local freeModeAngleZ = math.sin(cameraAngleY)
    local freeModeAngleY = math.cos(cameraAngleY) * math.cos(cameraAngleX)
    local freeModeAngleX = math.cos(cameraAngleY) * math.sin(cameraAngleX)
   
    local camPosX, camPosY, camPosZ = getPedBonePosition ( localPlayer, 25 )
    camPosZ = camPosZ + 0.29
   
    if rotY < 0 and isPedInVehicle ( localPlayer ) ~= true then
     local r = getPedRotation ( localPlayer )
     camPosX = camPosX - math.sin ( math.rad(r) ) * (-rotY/4.5)
     camPosY = camPosY + math.cos ( math.rad(r) ) * (-rotY/4.5)
    end
    local camTargetX = camPosX + freeModeAngleX * 100
    local camTargetY = camPosY + freeModeAngleY * 100
    local camTargetZ = camPosZ + freeModeAngleZ * 100
     
    local camAngleX = camPosX - camTargetX
    local camAngleY = camPosY - camTargetY
    local camAngleZ = 0
    
    local angleLength = math.sqrt(camAngleX*camAngleX+camAngleY*camAngleY+camAngleZ*camAngleZ)
   
     local camNormalizedAngleX = camAngleX / angleLength
     local camNormalizedAngleY = camAngleY / angleLength
     local camNormalizedAngleZ = 0
    
     local normalAngleX = 0
     local normalAngleY = 0
     local normalAngleZ = 1
   
     local normalX = (camNormalizedAngleY * normalAngleZ - camNormalizedAngleZ * normalAngleY)
     local normalY = (camNormalizedAngleZ * normalAngleX - camNormalizedAngleX * normalAngleZ)
     local normalZ = (camNormalizedAngleX * normalAngleY - camNormalizedAngleY * normalAngleX)
     
   
     camPosX = camPosX + freeModeAngleX * speed
     camPosY = camPosY + freeModeAngleY * speed
     camPosZ = camPosZ + freeModeAngleZ * speed
   
     camPosX = camPosX + normalX * strafespeed
     camPosY = camPosY + normalY * strafespeed
     camPosZ = camPosZ + normalZ * strafespeed
     
     camTargetX = camPosX + freeModeAngleX * 100
     camTargetY = camPosY + freeModeAngleY * 100
     camTargetZ = camPosZ + freeModeAngleZ * 100
    
     if isPedInVehicle ( localPlayer ) and getKeyState ( "mouse1" ) ~= true then
      if getControlState ( "vehicle_look_behind" ) then
       camTargetX, camTargetY, camTargetZ = getElementOffset ( localPlayer, 0, -3, 0 )
      else
       camTargetX, camTargetY, camTargetZ = getElementOffset ( localPlayer, 0, 3, 0 )
      end
     end
    
    setPedAimTarget ( localPlayer, camTargetX, camTargetY, camTargetZ )
    setCameraMatrix ( camPosX, camPosY, camPosZ, camTargetX, camTargetY, camTargetZ )
   
end

function mousecalc ( _, _, aX, aY )
    if isCursorShowing ( ) or isMTAWindowActive ( ) then
     mouseFrameDelay = 5
     return
    elseif mouseFrameDelay > 0 then
     mouseFrameDelay = mouseFrameDelay - 1
     return
    end

    aX = aX - sw / 2 
    aY = aY - sh / 2
    
    if options.invertMouseLook then
     aY = -aY
    end
    
    rotX = rotX + aX * options.mouseSensitivity * 0.01745
    rotY = rotY - aY * options.mouseSensitivity * 0.01745
       
    local PI = math.pi
    if rotX > PI then
     rotX = rotX - 2 * PI
    elseif rotX < -PI then
     rotX = rotX + 2 * PI
    end
       
    if rotY > PI then
     rotY = rotY - 2 * PI
    elseif rotY < -PI then
     rotY = rotY + 2 * PI
    end
   
    rotY = math.clamp ( rotY, -PI / 2.05, PI / 2.05 )
end
   
function cursor ( )
    showCursor(not isCursorShowing())
end

function manageCamera (state)
    if state then 
        setPedAnimation( localPlayer, "PED", "gang_gunstand")
        addEventHandler('onClientPreRender', root, cameraRender)
        addEventHandler('onClientCursorMove', root, mousecalc)
        bindKey('mouse2', 'both', cursor)
    else
        setPedAnimation( localPlayer )
        removeEventHandler('onClientPreRender', root, cameraRender)
        removeEventHandler('onClientCursorMove', root, mousecalc)
        setCameraTarget(localPlayer)
        unbindKey('mouse2', 'both', cursor)

        speed, strafespeed = 0, 0
        rotX, rotY = 0,0
        mouseFrameDelay = 0
    end
end

guiSetInputMode("no_binds_when_editing")