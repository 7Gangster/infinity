tablet = {}

local selected = {}
local bo_selected = {}
local proximaPagina = {}
proximaPagina.art = 0

local editbox = guiCreateEdit(-1, -1, 0, 0, '')
local desc = guiCreateEdit(-1, -1, 0, 0, '')

local slots = {
    artigos = {527, 557, 587, 617, 647, 677, 707, 738, 768, 798, 828},
    ficha = {315, 345, 375, 405, 435, 465, 495, 526, 556, 586, 616, 646, 676},
    bficha = {310, 340, 370, 400, 430, 460, 490, 520, 550, 580, 610, 640, 670}
}



target = false
barra_antiga = 'inicio'
barra_tick = 0
pagina = 'inicio'
barra = {
    ['inicio'] = 466,
    ['bficha'] = 516,
    ['prender'] = 566,
    ['cficha'] = 616,
}

local font = {
    ['regular'] = {
        dxCreateFont('src/assets/fonts/Roboto-Regular.ttf', 9, false, 'default'),
        dxCreateFont('src/assets/fonts/Roboto-Regular.ttf', 10, false, 'default'),
        dxCreateFont('src/assets/fonts/Roboto-Regular.ttf', 12, false, 'default'),
        dxCreateFont('src/assets/fonts/Roboto-Regular.ttf', 14, false, 'default'),
    },
    ['medium'] = {
        dxCreateFont('src/assets/fonts/Roboto-Medium.ttf', 9, false, 'default'),
        dxCreateFont('src/assets/fonts/Roboto-Medium.ttf', 10, false, 'default'),
        dxCreateFont('src/assets/fonts/Roboto-Medium.ttf', 12, false, 'default'),
        dxCreateFont('src/assets/fonts/Roboto-Medium.ttf', 14, false, 'default'),
    },
    ['bold'] = {
        dxCreateFont('src/assets/fonts/Roboto-Bold.ttf', 9, false, 'default'),
        dxCreateFont('src/assets/fonts/Roboto-Bold.ttf', 10, false, 'default'),
        dxCreateFont('src/assets/fonts/Roboto-Bold.ttf', 12, false, 'default'),
        dxCreateFont('src/assets/fonts/Roboto-Bold.ttf', 14, false, 'default'),
        dxCreateFont('src/assets/fonts/Roboto-Bold.ttf', 20, false, 'default'),
    },
}

render = function()
    --<< BACKGROUND >>--
    dxDrawImage(291, 112, 1337, 856, img.tablet)
    dxDrawRectangle(333, 153, 1257, 781, tocolor(17, 17, 17))

    -- << PESQUISA >>
    dxDrawRectangle(333, 153, 187, 781, tocolor(15, 15, 15))

    dxDrawImage(376, 197, 100, 100, img.avatar)
    dxDrawText(string.gsub(getPlayerName(localPlayer), '_', ' '), 332, 307, 188, 14, white, 1, font['regular'][2], 'center', 'center')
    dxDrawText((getElementData(localPlayer, 'ID') or 'N/A'), 395, 322, 62, 12, tocolor(255, 255, 255, 0.4*255), 1, font['regular'][1], 'center', 'center')


    -- << BARRINHA ANIMADA >>
    local anim = false
    if barra_antiga ~= pagina then
        anim = interpolateBetween(barra[barra_antiga], 0, 0, barra[pagina], 0, 0, (getTickCount() - barra_tick)/500, 'Linear')

        if (getTickCount() - barra_tick)/500 >= 1 then 
            barra_antiga = pagina
            barra_tick = nil
        end
    end

    if anim then
        dxDrawRectangle(519, anim, 2, 19, tocolor(191, 145, 249))
    else
        dxDrawRectangle(519, barra[pagina], 2, 19, tocolor(191, 145, 249))
    end

    -- << BOTOES >>

    dxDrawRectangle(333, 450, 187, 50, tocolor(16, 16, 16))
    dxDrawImage(347, 460, 30, 30, icon.home)
    dxDrawText('Inicio', 333, 468, 187, 15, white, 1, font['medium'][2], 'center', 'center') 
    
    dxDrawRectangle(333, 500, 187, 50, tocolor(18, 18, 18))
    dxDrawImage(347, 510, 30, 30, icon.search)
    dxDrawText('Buscar', 333, 518, 187, 15, white, 1, font['medium'][2], 'center', 'center') 

    dxDrawRectangle(333, 550, 187, 50, tocolor(16, 16, 16))
    dxDrawImage(347, 560, 30, 30, 'src/assets/handcuff.png')
    dxDrawText('Prender', 333, 568, 187, 15, white, 1, font['medium'][2], 'center', 'center') 

    dxDrawRectangle(333, 600, 187, 50, tocolor(18, 18, 18))
    dxDrawImage(347, 610, 30, 30, 'src/assets/ficha.png')
    dxDrawText('Criar', 333, 618, 187, 15, white, 1, font['medium'][2], 'center', 'center') 

    if pagina == 'inicio' then 
        dxDrawRoundedRectangle(569, 185, 498, 447, 10, tocolor(15, 15, 15))
        dxDrawRoundedRectangle(584, 200, 6, 20, 3, tocolor(191, 145, 249))
        dxDrawText('VEICULOS PROCURADOS', 598, 201, 172, 18, white, 1, font['bold'][3], 'left', 'center')
        dxDrawText('Indisponivel', 569, 185, 498, 447, white, 1, font['bold'][5], 'center', 'center')

        dxDrawRoundedRectangle(1084, 185, 456, 227, 10, tocolor(15, 15, 15))
        dxDrawRoundedRectangle(1098, 203, 6, 20, 3, tocolor(191, 145, 249))
        dxDrawText('POLICIAIS EM SERVIÇO', 1112, 204, 162, 18, white, 1, font['bold'][3], 'left', 'center')

        local police = 0
        for i,v in ipairs(getElementsByType('player')) do 
            if getElementData(v, 'police >> duty') then 
                police = police +1
            end
        end
        dxDrawText(police, 1084, 185, 456, 227, white, 1, font['bold'][5], 'center', 'center')

        dxDrawRoundedRectangle(1084, 422, 456, 227, 10, tocolor(15, 15, 15))
        dxDrawRoundedRectangle(1098, 441, 6, 20, 3, tocolor(191, 145, 249))
        dxDrawText('PRISÕES REALIZADAS', 1112, 442, 162, 18, white, 1, font['bold'][3], 'left', 'center')
        dxDrawText((tablet.prisoes or 0), 1084, 422, 456, 227, white, 1, font['bold'][5], 'center', 'center')

        dxDrawRoundedRectangle(1084, 657, 456, 227, 10, tocolor(15, 15, 15))
        dxDrawRoundedRectangle(1098, 677, 6, 20, 3, tocolor(191, 145, 249))
        dxDrawText('MULTAS REALIZADAS', 1112, 678, 162, 18, white, 1, font['bold'][3], 'left', 'center')
        dxDrawText((tablet.multas or 0), 1084, 657, 456, 227, white, 1, font['bold'][5], 'center', 'center')

        dxDrawRoundedRectangle(569, 650, 498, 234, 10, tocolor(15, 15, 15))
        dxDrawRoundedRectangle(587, 667, 6, 20, 3, tocolor(191, 145, 249))
        dxDrawText('LOGS', 601, 668, 38, 18, white, 1, font['bold'][3], 'left', 'center')
        dxDrawText('Indisponivel', 569, 650, 498, 234, white, 1, font['bold'][5], 'center', 'center')
    elseif pagina == 'bficha' then
        -- << PESQUISA >>
        if not bo_selected then
            dxDrawRoundedRectangle(620, 203, 726, 44, 10, tocolor(15, 15, 15))
            dxDrawRoundedRectangle(1348, 203, 44, 44, 10, tocolor(191, 145, 249))
            dxDrawImage(1358, 213, 24, 24, icon.search2, 0, 0, 0, tocolor(0, 0, 0))
            local text = 'Insira o RG ou CPF'
            if guiGetText(editbox) ~= '' then 
                text = guiGetText(editbox)
            end
            dxDrawText(text, 633, 212, 682, 25, white, 1, font['regular'][4], 'left', 'center')

            -- << INFORMAÇÕES >>

            if tablet.pesquisa then

                dxDrawRoundedRectangle(620, 257, 200, 200, 10, tocolor(15,15,15))
                dxDrawRoundedRectangle(620, 462, 197, 244, 10, tocolor(15,15,15))
                dxDrawRoundedRectangle(630, 476, 5, 14, 3, tocolor(191,145,249))
                dxDrawText('INFORMAÇÕES', 642, 476, 159, 14, white, 1, font['medium'][2], 'left', 'center')
                dxDrawText('Nome: '..tablet.pesquisa.nome..'\nRG: '..tablet.pesquisa.id..' \nPassagens: '..tablet.pesquisa.passagens, 632, 499, 173, 164, white, 1, font['regular'][2], 'left', 'top', false, true)
            
                -- << GRID >>
            
                dxDrawRoundedRectangle(835, 259, 557, 447, 10, tocolor(15,15,15))
                dxDrawRoundedRectangle(856, 277, 6, 20, 3, tocolor(191,145,249))
                dxDrawText('FICHA CRIMINAL', 870, 278, 201, 14, white, 1, font['bold'][3], 'left', 'center')

                -- 315, 345, 375, 405, 435, 465, 495, 526, 556, 586, 616, 646, 676

                dxDrawRectangle(835, 315, 557, 30, tocolor(18, 18, 18))
                dxDrawRectangle(835, 345, 557, 30, tocolor(16, 16, 16))
                dxDrawRectangle(835, 375, 557, 30, tocolor(18, 18, 18))
                dxDrawRectangle(835, 405, 557, 30, tocolor(16, 16, 16))
                dxDrawRectangle(835, 435, 557, 30, tocolor(18, 18, 18))
                dxDrawRectangle(835, 465, 557, 30, tocolor(16, 16, 16))
                dxDrawRectangle(835, 495, 557, 30, tocolor(18, 18, 18))
                dxDrawRectangle(835, 526, 557, 30, tocolor(16, 16, 16))
                dxDrawRectangle(835, 556, 557, 30, tocolor(18, 18, 18))
                dxDrawRectangle(835, 586, 557, 30, tocolor(16, 16, 16))
                dxDrawRectangle(835, 616, 557, 30, tocolor(18, 18, 18))
                dxDrawRectangle(835, 646, 557, 30, tocolor(16, 16, 16))
                dxDrawRectangle(835, 676, 557, 30, tocolor(18, 18, 18))

                local index = 0
                for i,v in ipairs(tablet.pesquisa.prisoes) do 
                    if index <= 12 then
                        index = index +1
                        dxDrawText('Preso em '..v.data..' pelo policial '..v.policial, 835+10, slots.ficha[index], 547, 30, white, 1, font['regular'][1], 'left', 'center')
                        dxDrawRoundedRectangle(1358, (slots.ficha[index]+6), 24, 22, 5, tocolor(191, 145, 249))
                        dxDrawImage(1362, (slots.ficha[index]+9), 16, 16, icon.eye)
                    end
                end

            end
        else
            dxDrawRoundedRectangle(580, 197, 6, 20, 3, tocolor(191,145,249))
            dxDrawText(tablet.pesquisa.nome..' - OCORRÊNCIA #'..bo_selected, 594, 198, 443, 19, white, 1, font['bold'][3], 'left', 'center')

            dxDrawRoundedRectangle(580, 254, 385, 87, 10, tocolor(15,15,15))
            dxDrawRoundedRectangle(590, 263, 6, 20, 3, tocolor(191,145,249))
            dxDrawText('REMETENTE', 604, 264, 201, 18, white, 1, font['medium'][3], 'left', 'center')
            dxDrawText(tablet.pesquisa.prisoes[bo_selected].policial, 604, 288, 201, 44, white, 1, font['regular'][2], 'left', 'center')

            dxDrawRoundedRectangle(580, 347, 385, 87, 10, tocolor(15,15,15))
            dxDrawRoundedRectangle(590, 356, 6, 20, 3, tocolor(191,145,249))
            dxDrawText('DATA', 604, 357, 201, 14, white, 1, font['medium'][3], 'left', 'center')
            dxDrawText(tablet.pesquisa.prisoes[bo_selected].data, 604, 381, 201, 44, white, 1, font['regular'][2], 'left', 'center')

            dxDrawRoundedRectangle(580, 440, 385, 261, 10, tocolor(15,15,15))
            dxDrawRoundedRectangle(590, 449, 6, 20, 3, tocolor(191,145,249))
            dxDrawText('DESCRIÇÃO', 604, 450, 201, 14, white, 1, font['medium'][3], 'left', 'center', false, true)
            dxDrawText(tablet.pesquisa.prisoes[bo_selected].desc, 604, 483, 334, 200, white, 1, font['regular'][2], 'left', 'top', false, true)

            dxDrawRoundedRectangle(973, 254, 557, 447, 10, tocolor(15,15,15))
            dxDrawRoundedRectangle(994, 272, 6, 20, 3, tocolor(191,145,249))
            dxDrawText('ARTIGOS', 1008, 273, 201, 18, white, 1, font['medium'][3], 'left', 'center')

            dxDrawRectangle(973, 310, 557, 30, tocolor(18, 18, 18))
            dxDrawRectangle(973, 340, 557, 30, tocolor(16, 16, 16))
            dxDrawRectangle(973, 370, 557, 30, tocolor(18, 18, 18))
            dxDrawRectangle(973, 400, 557, 30, tocolor(16, 16, 16))
            dxDrawRectangle(973, 430, 557, 30, tocolor(18, 18, 18))
            dxDrawRectangle(973, 460, 557, 30, tocolor(16, 16, 16))
            dxDrawRectangle(973, 490, 557, 30, tocolor(18, 18, 18))
            dxDrawRectangle(973, 520, 557, 30, tocolor(16, 16, 16))
            dxDrawRectangle(973, 550, 557, 30, tocolor(18, 18, 18))
            dxDrawRectangle(973, 580, 557, 30, tocolor(16, 16, 16))
            dxDrawRectangle(973, 610, 557, 30, tocolor(18, 18, 18))
            dxDrawRectangle(973, 640, 557, 30, tocolor(16, 16, 16))
            dxDrawRectangle(973, 670, 557, 30, tocolor(18, 18, 18))

            local index = 0
            for i,v in ipairs(getTableArtigos(tablet.pesquisa.prisoes[bo_selected].artigos)) do 
                if index <= 12 then
                    index = index +1
                    local tempo = 'Desconhecido'
                    for k,vv in ipairs(cfg.artigos) do 
                        if vv.art == tostring(v) then 
                            tempo = vv.tempo
                        end
                    end
                    dxDrawText('Artigo '..v..' - '..tempo..' meses', 997, slots.ficha[index], 547, 30, white, 1, font['regular'][1], 'left', 'center')
                end
            end
        end
        

    elseif pagina == 'prender' then
        -- << PESQUISA >>
        dxDrawRoundedRectangle(620, 203, 726, 44, 10, tocolor(15, 15, 15))
        dxDrawRoundedRectangle(1348, 203, 44, 44, 10, tocolor(191, 145, 249))
        dxDrawImage(1358, 213, 24, 24, icon.search2, 0, 0, 0, tocolor(0, 0, 0))
        local text = 'Insira o RG ou CPF'
        if guiGetText(editbox) ~= '' then 
            text = guiGetText(editbox)
        end
        dxDrawText(text, 633, 212, 682, 25, white, 1, font['regular'][4], 'left', 'center')

        if target then 
            dxDrawRoundedRectangle(620, 257, 200, 200, 10, tocolor(15, 15, 15))

            dxDrawRoundedRectangle(834, 257, 640, 200, 10, tocolor(15, 15, 15))
            dxDrawRoundedRectangle(844, 266, 6, 20, 3, tocolor(191,145,249))
            dxDrawText('OCORRIDO', 858, 267, 201, 14, white, 1, font['medium'][2], 'left', 'center')
            local text = 'Escreva aqui...'
            if guiGetText(desc) ~= '' then 
                text = guiGetText(desc)
            end
            dxDrawText(text, 858, 300, 582, 134, white, 1, font['regular'][1], 'left', 'top', false, true)

            dxDrawRoundedRectangle(620, 471, 557, 387, 10, tocolor(15, 15, 15))
            dxDrawRoundedRectangle(641, 489, 6, 20, 3, tocolor(191,145,249))
            dxDrawText('ARTIGOS', 655, 490, 201, 14, white, 1, font['medium'][2], 'left', 'center')

            -- << GRID 1 >>
            dxDrawRectangle(620, 527, 557, 30, tocolor(18, 18, 18))
            dxDrawRectangle(620, 557, 557, 30, tocolor(16, 16, 16))
            dxDrawRectangle(620, 587, 557, 30, tocolor(18, 18, 18))
            dxDrawRectangle(620, 617, 557, 30, tocolor(16, 16, 16))
            dxDrawRectangle(620, 647, 557, 30, tocolor(18, 18, 18))
            dxDrawRectangle(620, 677, 557, 30, tocolor(16, 16, 16))
            dxDrawRectangle(620, 707, 557, 30, tocolor(18, 18, 18))
            dxDrawRectangle(620, 738, 557, 30, tocolor(16, 16, 16))
            dxDrawRectangle(620, 768, 557, 30, tocolor(18, 18, 18))
            dxDrawRectangle(620, 798, 557, 30, tocolor(16, 16, 16))
            dxDrawRectangle(620, 828, 557, 30, tocolor(18, 18, 18))

            local index = 0
            for i,v in ipairs(cfg.artigos) do 
                if (i > proximaPagina.art and index < 11) then
                    index = index +1
                    if isCursorOnElement(620, slots.artigos[index], 557, 30) then 
                        dxDrawRectangle(620, slots.artigos[index], 557, 30, tocolor(255, 255, 255))
                    end
                    dxDrawText('Artigo '..v.art..' - '..v.nome..' ('..v.tempo..' meses)', 630, slots.artigos[index], 547, 30, isCursorOnElement(630, slots.artigos[index], 547, 30) and tocolor(0, 0, 0) or white, 1, font['regular'][1], 'left', 'center')
                end
            end

            dxDrawRoundedRectangle(1191, 471, 283, 297, 10, tocolor(15, 15, 15))
            dxDrawRoundedRectangle(1213, 494, 6, 20, 3, tocolor(191,145,249))
            dxDrawText('ARTIGOS SELECIONADOS', 1227, 495, 201, 14, white, 1, font['medium'][2], 'left', 'center')

            -- << GRID 2 >>
            dxDrawRectangle(1191, 527, 283, 30, tocolor(18, 18, 18))
            dxDrawRectangle(1191, 557, 283, 30, tocolor(16, 16, 16))
            dxDrawRectangle(1191, 587, 283, 30, tocolor(18, 18, 18))
            dxDrawRectangle(1191, 617, 283, 30, tocolor(16, 16, 16))
            dxDrawRectangle(1191, 647, 283, 30, tocolor(18, 18, 18))
            dxDrawRectangle(1191, 677, 283, 30, tocolor(16, 16, 16))
            dxDrawRectangle(1191, 707, 283, 30, tocolor(18, 18, 18))
            dxDrawRectangle(1191, 738, 283, 30, tocolor(16, 16, 16))

            local index = 0
            for i,v in ipairs(selected) do 
                if index <= 8 then
                    index = index +1
                    if isCursorOnElement(1191, slots.artigos[index], 293, 30) then 
                        dxDrawRectangle(1191, slots.artigos[index], 293, 30, tocolor(255, 255, 255))
                    end
                    dxDrawText('Artigo '..v.art..' - '..v.nome..' ('..v.tempo..' meses)', 1201, slots.artigos[index], 283, 30, isCursorOnElement(1191, slots.artigos[index], 283, 30) and tocolor(0, 0, 0) or white, 1, font['regular'][1], 'left', 'center')
                end
            end

            

            dxDrawRoundedRectangle(1191, 778, 283, 80, 10, isCursorOnElement(1191, 778, 283, 80) and tocolor(38, 38, 38) or tocolor(15, 15, 15))
            dxDrawText('C O N F I R M A R', 1191, 778, 283, 80, white, 1, font['bold'][3], 'center', 'center')
        end

    end

end

addEvent('police >> tablet', true)
addEventHandler('police >> tablet', root, function(execute, table)
    if execute == 'open' then 
        if not isEventHandlerAdded('onClientRender', root, render) then 
            addEventHandler('onClientRender', root, render)
            showCursor(true)
            barra_antiga = 'inicio'
            barra_tick = 0
            pagina = 'inicio'
        end
    elseif execute == 'close' then 
        if isEventHandlerAdded('onClientRender', root, render) then 
            removeEventHandler('onClientRender', root, render)
            showCursor(false)
        end
    elseif execute == 'update' then
        tablet = table
    end
end)

-- << CLICK EVENT >>

addEventHandler('onClientClick', root, function(b, s)
    if isEventHandlerAdded('onClientRender', root, render) then 
        if b == 'left' and s == 'down' then 
            -- << barra de pesquisa >>
            if isCursorOnElement(333, 450, 187, 50) then 
                if pagina == 'inicio' then return true end
                pagina = 'inicio'
                barra_tick = getTickCount()
            elseif isCursorOnElement(333, 500, 187, 50) then 
                if pagina == 'bficha' then return true end
                pagina = 'bficha'
                bo_selected = false
                barra_tick = getTickCount()
            elseif isCursorOnElement(333, 550, 187, 50) then 
                if pagina == 'prender' then return true end
                pagina = 'prender'
                barra_tick = getTickCount()
            elseif isCursorOnElement(333, 600, 187, 50) then 
                if pagina == 'cficha' then return true end
                pagina = 'cficha'
                barra_tick = getTickCount()
            end

            if pagina == 'bficha' then 
                if isCursorOnElement(633, 212, 682, 25) then 
                    guiFocus(editbox)
                    guiSetText(editbox, '')
                    toggleAllControls(false, false, true)
                    return true
                elseif isCursorOnElement(1348, 203, 44, 44) then
                    triggerServerEvent('tablet >> pesquisar', localPlayer, localPlayer, guiGetText(editbox))
                end
                if tablet.pesquisa then
                    local linha = 0
                    for i,v in ipairs(tablet.pesquisa.prisoes) do 
                        if linha <= 12 then
                            linha = linha+1
                            if isCursorOnElement(1358, (slots.ficha[linha]+6), 24, 22) then 
                            bo_selected = i 
                            end
                        end
                    end
                end
                toggleAllControls(true, false, true)
            elseif pagina == 'prender' then 
                if isCursorOnElement(633, 212, 682, 25) then 
                    guiFocus(editbox)
                    guiSetText(editbox, '')
                    toggleAllControls(false, false, true)
                    return true
                elseif isCursorOnElement(1348, 203, 44, 44) then
                    for i,v in ipairs(getElementsByType('player')) do
                        if getElementData(v, 'ID') == tonumber(guiGetText(editbox)) then 
                            target = v
                            return true
                        end
                    end
                    target = false
                elseif isCursorOnElement(858, 300, 582, 134) and target then 
                    guiFocus(desc)
                    toggleAllControls(false, false, true)
                    return true
                elseif isCursorOnElement(1191, 778, 283, 80) and target then 
                    local texto = 'Não informado'
                    if guiGetText(desc) ~= '' then 
                        texto = guiGetText(desc)
                    end
                    triggerServerEvent('tablet >> prender', localPlayer, localPlayer, tonumber(guiGetText(editbox)), selected, texto)
                    selected = {}
                    toggleAllControls(true)
                end
                if target then
                    local linha = 0
                    local linha2 = 0
                    for i,v in ipairs(selected) do 
                        if i <= 8 then
                            if isCursorOnElement(1191, slots.artigos[i], 283, 30) then 
                                table.remove(selected, i)
                            end
                        end
                    end
                    for i,v in ipairs(cfg.artigos) do 
                        if (i > proximaPagina.art and linha < 11) then
                            --if linha <= 11 then
                                linha = linha +1
                                if isCursorOnElement(630, slots.artigos[linha], 547, 30) then 
                                    for k,vv in ipairs(selected) do 
                                        if vv.art == v.art then 
                                            return true
                                        end
                                    end
                                    table.insert(selected, cfg.artigos[i])
                                end
                            --send
                        end
                    end
                end
            end
        end
        toggleAllControls(true)
    end
end)

function scroll(button)
    if isEventHandlerAdded('onClientRender', root, render) then
        if isCursorOnElement(620, 471, 557, 387) then
            if (button == 'mouse_wheel_down') then
                proximaPagina.art = proximaPagina.art + 1
                if (proximaPagina.art > #cfg.artigos - 11) then
                    proximaPagina.art = #cfg.artigos - 11
                end
            elseif (button == 'mouse_wheel_up') then
                if (proximaPagina.art > 0) then
                    proximaPagina.art = proximaPagina.art - 1
                end
            end
        end
    end
end
bindKey('mouse_wheel_up', 'down', scroll)
bindKey('mouse_wheel_down', 'down', scroll)

addEventHandler('onClientRender', root, function()
    if getElementData(localPlayer, 'Preso') then 
        if getElementData(localPlayer, 'Preso') ~= 1 then
            dxDrawText('Restam #BF91F9'..getElementData(localPlayer, 'Preso')..' #ffffffmeses', 0, 0+50, 1920, 1080, white, 1, font['bold'][5], 'center', 'top', false, true, true, true)
        else
            dxDrawText('Resta #BF91F9'..getElementData(localPlayer, 'Preso')..' #ffffffmes', 0, 0+50, 1920, 1080, white, 1, font['bold'][5], 'center', 'top', false, true, true, true)
        end
    end
end)

function getTableArtigos(string)
    local valores = {}
    for valor in string:gmatch("%d+") do
        -- Converta o valor de string para número (opcional)
        valor = tonumber(valor)
        
        -- Adicione o valor à tabela
        table.insert(valores, valor)
    end
    return valores
end