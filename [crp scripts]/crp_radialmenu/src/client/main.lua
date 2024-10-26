local painel = {}

local startPage = {}

local slots = {
    {860, 261, 200, 200},
    {1015, 352, 200, 200},
    {1015, 529, 200, 200},
    {860, 617, 200, 200},
    {705, 529, 200, 200},
    {705, 352, 200, 200},
}

function render () 

    local alpha = interpolateBetween(painel.alpha[1], 0, 0, painel.alpha[2]-30 or 0, 0, 0, (getTickCount()-painel.tick)/500, 'Linear')
    local alpha2 = interpolateBetween(painel.alpha[1], 0, 0, painel.alpha[2]-70 or 0, 0, 0, (getTickCount()-painel.tick)/500, 'Linear')
    if painel.closing then 
        alpha2 = interpolateBetween(30, 0, 0, 0, 0, 0, (getTickCount()-painel.tick)/300, 'Linear')
        alpha = interpolateBetween(70, 0, 0, 0 or 0, 0, 0, (getTickCount()-painel.tick)/300, 'Linear')
    end
    local alpha3 = interpolateBetween(painel.alpha[1], 0, 0, painel.alpha[2], 0, 0, (getTickCount()-painel.tick)/500, 'Linear')

    dxDrawPolygon ( 860, 440, 200, 200, isCursorOnElement((860+35), (440+43), 129, 114) and tocolor('42D47E', alpha) or tocolor('000000', alpha))
    if not painel.pagina then
        dxDrawImage((860+200/2-80/2), (440+200/2-100/2), 80, 80, img.close, 0, 0, 0, tocolor('FFFFFF', alpha3))
    else
        dxDrawImage((860+200/2-80/2), (440+200/2-100/2), 80, 80, img.back, 0, 0, 0, tocolor('FFFFFF', alpha3))
    end

    if painel.interactions then 
        local index = 0
        for i,v in ipairs(painel.interactions) do 
            index = index+1
            local x, y = interpolateBetween(860, 440, 0, slots[i][1], slots[i][2], 0, (getTickCount()-painel.tick2)/(300+index*10), 'Linear')
            dxDrawPolygon(x, y, slots[i][3], slots[i][4], isCursorOnElement((x+35), (y+43), 129, 114) and tocolor('42D47E', alpha) or tocolor('000000', alpha))
            dxDrawImage((x+(920-860)), (y+(310-261)-15), 80, 80, v.img, 0, 0, 0, tocolor('FFFFFF', alpha))
            dxDrawText(v.nome, x, (y+(379-261)-10), 200, 30, tocolor('FFFFFF', alpha), 1, font['poppins']['medium'][16], 'center', 'center')
        end
    end

    for i=1,#slots do 
        if painel.interactions then 
            if not painel.interactions[i] then
                local x, y = interpolateBetween(860, 440, 0, slots[i][1], slots[i][2], 0, (getTickCount()-painel.tick2)/(300+i*10), 'Linear')
                dxDrawPolygon(x, y, slots[i][3], slots[i][4], tocolor('000000', alpha2))
            end
        end
    end

    if painel.close then 
        painel.alpha = {100, 0}
        painel.tick = getTickCount()
        painel.close = false 
        painel.closing = true
    end

    if (getTickCount()-painel.tick)/300 >= 1 and painel.closing then 
        removeEventHandler('onClientRender', root, render)
        showCursor(false)
        painel = {}
    end

end

function openMenu ( )
    if not painel.state then 
        painel.state = true 
        painel.alpha = {0, 100}
        painel.close = false 
        painel.tick = getTickCount()
        painel.tick2 = getTickCount()
        painel.interactions = {}
        showCursor(true)
        setCursorPosition(screen[1]/2, screen[2]/2)
        triggerServerEvent('menu:get', localPlayer, localPlayer)
        addEventHandler('onClientRender', root, render)
    else 
        if not painel.closing then 
            painel.close = true
        end
    end
end
addCommandHandler('Abrir menu', openMenu)

addEventHandler('onClientClick', root, function ( b, s )
    if not painel.closing then 
        if painel.state then 
            if b == 'left' and s == 'down' then 
                if isCursorOnElement((860+35), (440+43), 129, 114) then 
                    if not painel.pagina then 
                        painel.close = true
                    else
                        if painel.pagina == painel.interactions then 
                            painel.interactions = startPage
                            painel.pagina = false
                        else
                            painel.interactions = painel.pagina
                        end
                        if startPage == painel.interactions then 
                            painel.pagina = false
                        end
                    end
                end
                for i,v in ipairs(painel.interactions) do 
                    if isCursorOnElement((slots[i][1]+35), (slots[i][2]+43), 129, 114) then 
                        if v.execute then 
                            local args = v.args or {}
                            triggerServerEvent(v.execute, localPlayer, localPlayer, unpack(args))
                        end
                        if v.pagina then 
                            painel.pagina = painel.interactions   
                            painel.interactions = v.pagina
                        end
                        if v.close then 
                            painel.close = true
                        end
                    end
                end
            end
        end
    end
end)

addEvent('menu:set', true)
addEventHandler('menu:set', root, function( data )
    painel.interactions = data
    startPage = data
end)

function getPagina (pagina)
    for i,v in ipairs(startPage) do 
        if v.pagina == pagina then 
            return startPage[i]
        end
    end
    return false
end

bindKey('f1', 'down', 'Abrir menu')
