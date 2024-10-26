img = {}

craft = {

    painel = {
        state = false,
        selected = false,
        qtd = 1,
        slots = {
            
            {33, 41},
            {165, 41},
            {297, 41},
            {429, 41},
            {561, 41},

            {33, 183},
            {165, 183},
            {297, 183},
            {429, 183},
            {561, 183},

            {33, 325},
            {165, 325},
            {297, 325},
            {429, 325},
            {561, 325},

            {33, 467},
            {165, 467},
            {297, 467},
            {429, 467},
            {561, 467},
            
        },
        slotsCraft = {
            {758, 366},
            {851, 366},
            {944, 366},
            {1037, 366},
            {758, 459},
            {851, 459},
            {944, 459},
            {1037, 459},
        }
    },

    core = function ( )
        addEvent('managePanel', true)
        addEventHandler('managePanel', root, craft.functions.managePanel)
        addEvent('updateCraft', true)
        addEventHandler('updateCraft', root, craft.functions.update)
        addEvent('startCraft', true)
        addEventHandler('startCraft', root, craft.functions.startCraft)

        --bindKey('tab', 'down', craft.functions.managePanel, not craft.painel.state)
    end,

    events = {
        render = function ( )

            local alpha = craft.painel.anims.alpha
            local alpha = interpolateBetween(alpha[1], 0, 0, alpha[2], 0, 0, (getTickCount()-alpha[3])/alpha[4], 'Linear')
            local x, y = interpolateBetween(craft.painel.anims.position.x[1], craft.painel.anims.position.y[1], 0, craft.painel.anims.position.x[2], craft.painel.anims.position.y[2], 0, (getTickCount()-craft.painel.anims.position.tick)/craft.painel.anims.position.time, 'OutQuad')

            dxDrawRoundedRectangle(x, y, 1202, 738, 15, tocolor('000000', alpha-50))

            if craft.painel.crafts then 
                local index = 0
                for i,v in pairs(craft.painel.crafts) do 
                    index = index + 1
                    local x, y = x + craft.painel.slots[index][1], y + craft.painel.slots[index][2]
                    if craft.painel.selected == i then 
                        dxDrawImage(x, y, 125, 132, 'src/assets/selected.png', 0, 0, 0, tocolor('FFFFFF', alpha))
                    else
                        dxDrawRoundedRectangle(x, y, 125, 132, 5, tocolor('000000', alpha-35))
                    end
                    dxDrawImage(x+18, y+8, 90, 90, v.img, 0, 0, 0, tocolor('FFFFFF', alpha))
                    dxDrawText(v.nome, x, y+104, 125, 17, tocolor('8E9296', alpha), 1, getFont('regular', 10), 'center', 'center')
                end
            end

            if craft.painel.selected then 
                local item = craft.painel.crafts[craft.painel.selected]
                dxDrawRoundedRectangle(x+708, y+41, 466, 658, 10, tocolor('000000', alpha-50))
                dxDrawImage(x+758, y+93, 142, 142, 'src/assets/selected.png', 0, 0, 0, tocolor('FFFFFF', alpha))
                dxDrawImage(x+769, y+104, 120, 120, item.img, 0, 0, 0, tocolor('FFFFFF', alpha))
                if craft.painel.crafting then 

                    local barra = interpolateBetween(0, 0, 0, 234, 0, 0, (getTickCount()-craft.painel.crafting.tick)/craft.painel.crafting.time, 'OutQuad')
                    dxDrawImage(x+998, y+127, 31, 31, img.clock, 0, 0, 0, tocolor('FFFFFF', alpha-70))
                    dxDrawImageSection(x+910, y+233, barra, 2, 0, 0, barra, 2, img.line, 0, 0, 0, tocolor('FFFFFF', alpha))
                    dxDrawText(formatTime(math.floor(getTimerDetails(craft.painel.crafting.timer)/1000)), x+964, y+157, 139, 48, tocolor('FFFFFF', alpha), 1, getFont('regular', 35))

                else

                    dxDrawImage(x+910, y+233, 234, 2, img.line, 0, 0, 0, tocolor('FFFFFF', alpha))
                    dxDrawImage(x+998, y+127, 31, 31, img.clock, 0, 0, 0, tocolor('FFFFFF', alpha-70))
                    dxDrawText(formatTime(item.time*craft.painel.qtd), x+964, y+157, 139, 48, tocolor('FFFFFF', alpha), 1, getFont('regular', 35))

                end
                dxDrawText(string.upper(item.nome), x+758, y+258, 139, 48, tocolor('FFFFFF', alpha), 1, getFont('regular', 20), 'left', 'top')
                dxDrawText('#828282Tipo: #FFFFFF'..(item.type or 'Comum'), x+758, y+310, 94, 20, tocolor('FFFFFF', alpha), 1, getFont('regular', 10), 'left', 'top', false, false, false, true)
                dxDrawText('#828282Peso: #FFFFFF'..(item.peso or 0.0)..'kg', x+863, y+310, 94, 20, tocolor('FFFFFF', alpha), 1, getFont('regular', 10), 'left', 'top', false, false, false, true)
                dxDrawText('#828282Economia: #FFFFFF$'..(item.preco or 0), x+972, y+310, 94, 20, tocolor('FFFFFF', alpha), 1, getFont('regular', 10), 'left', 'top', false, false, false, true)
            
                for i,v in ipairs(item.items) do 
                    local x, y = x + craft.painel.slotsCraft[i][1], y + craft.painel.slotsCraft[i][2]
                    dxDrawRoundedRectangle(x, y, 83, 84, 4, tocolor('000000', alpha-30))
                    dxDrawImage(x+16, y+17, 50, 50, v.img, 0, 0, 0, tocolor('FFFFFF', alpha))
                    dxDrawText(v.qtd*craft.painel.qtd..'x', x+54, y+59, 20, 16, tocolor('FFFFFF', alpha), 1, getFont('regular', 9), 'right')
                end

                dxDrawImage(x+781, y+579, 316, 68, isCursorOnElement(x+896, y+579, 211, 68) and 'src/assets/button1.png' or 'src/assets/button0.png')
                dxDrawRectangle(x+801, y+599, 26, 28, isCursorOnElement(x+801, y+599, 26, 28) and tocolor('FFFFFF', 70) or tocolor('FFFFFF', 50))
                dxDrawText('<', x+801, y+599, 26, 28, tocolor('FFFFFF'), 1, getFont('regular', 11), 'center', 'center')
                dxDrawRectangle(x+863, y+599, 26, 28, isCursorOnElement(x+863, y+599, 26, 28) and tocolor('FFFFFF', 70) or tocolor('FFFFFF', 50))
                dxDrawText('>', x+863, y+599, 26, 28, tocolor('FFFFFF'), 1, getFont('regular', 11), 'center', 'center')
                dxDrawRectangle(x+828, y+626, 34, 1, tocolor('FFFFFF', 50))
                dxDrawText(craft.painel.qtd, x+827, y+599, 36, 28, tocolor('FFFFFF'), 1, getFont('regular', 13), 'center', 'center')
            end
        end,
        click = function ( b, s )
            if b == 'left' and s == 'down' then 
                if not craft.painel.closing and not craft.painel.crafting then
                    if craft.painel.crafts then 
                        local i = 0
                        for k,v in pairs(craft.painel.crafts) do 
                            i = i + 1
                            local x, y = 359 + craft.painel.slots[i][1], 171 + craft.painel.slots[i][2]
                            if isCursorOnElement(x, y, 125, 132) then 
                                if craft.painel.selected == k then craft.painel.selected = false return true end
                                craft.painel.selected = k
                            end
                        end
                    end
                    if craft.painel.selected then 
                        local x, y = 359, 171
                        if isCursorOnElement(x+801, y+599, 26, 28) then 
                            craft.painel.qtd = craft.painel.qtd -1
                            if craft.painel.qtd <= 0 then
                                craft.painel.qtd = 1 
                            end
                        elseif isCursorOnElement(x+863, y+599, 26, 28) then 
                            craft.painel.qtd = craft.painel.qtd +1
                        elseif isCursorOnElement(x+896, y+579, 211, 68) then 
                            --craft.functions.startCraft(craft.painel.crafts[craft.painel.selected])
                            triggerServerEvent('startCraft', localPlayer, localPlayer, craft.painel.crafts[craft.painel.selected], craft.painel.qtd)
                        end
                    end
                end
            end
        end,
        key = function ( b, s )
            if s then 
                if b == 'backspace' then 
                    if not craft.painel.closing and not craft.painel.crafting then 
                        craft.painel.closing = true
                        craft.painel.anims = {
                            alpha = {100, 0, getTickCount(), 500},
                            position = {
                                x = {359, 359},
                                y = {171, (171+738)},
                                tick = getTickCount(),
                                time = 750,
                            }
                        }
                        setTimer(function()
                            craft.functions.managePanel(false)
                            craft.painel.closing = false
                        end, 750, 1)
                    end
                end
            end
        end,
    },
    
    functions = {
        managePanel = function ( open )
            if open then 
                if not craft.painel.state then 
                    addEventHandler('onClientRender', root, craft.events.render)
                    addEventHandler('onClientClick', root, craft.events.click)
                    addEventHandler('onClientKey', root, craft.events.key)
                    img = manageSVG ( true )
                    craft.painel.state = true
                    craft.painel.crafts = {}
                    craft.painel.anims = {
                        alpha = {0, 100, getTickCount(), 500},
                        position = {
                            x = {359, 359},
                            y = {(171+738), 171},
                            tick = getTickCount(),
                            time = 750,
                        }
                    }
                    showCursor(true)
                end
            else
                if craft.painel.state then 
                    removeEventHandler('onClientRender', root, craft.events.render)
                    removeEventHandler('onClientClick', root, craft.events.click)
                    removeEventHandler('onClientKey', root, craft.events.key)
                    manageSVG ( false )
                    craft.painel.state = false
                    showCursor(false)
                end
            end
        end,
        startCraft = function ( item, qtd )
            iprint(item)
            if not craft.painel.crafting then 
                craft.painel.crafting = {
                    tick = getTickCount(),
                    time = item.time*1000*qtd,
                    timer = setTimer(function()
                        triggerServerEvent('endCraft', localPlayer, localPlayer, item, qtd)
                        craft.painel.crafting = nil
                    end, item.time*1000*qtd, 1)
                }
            end
        end,
        update = function ( crafts )
            craft.painel.crafts = crafts
        end,
    },
}

craft.core ()

function formatTime ( sec )
    local minutos, segundos = math.modf(sec/60)
    segundos = segundos*60
    return string.format("%02d:%02d", minutos, segundos)
end