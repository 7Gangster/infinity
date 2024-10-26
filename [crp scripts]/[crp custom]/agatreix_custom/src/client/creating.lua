
local gender = false
local painel = false
local gender_tick = 0

local ped

local slotsPele = {
    {1436, 265, 29, 31},
    {1479, 265, 29, 31},
    {1522, 265, 29, 31},
    {1565, 265, 29, 31},
    {1608, 265, 29, 31},
}

local rosto = 1
local pele = 1
local sobrancelha = 0
local corSobrancelha = 1
local barba = 0
local corBarba = 1
local cabelo = 0
local corCabelo = 1

local rostos = {
    [1] = {1, 2, 3, 4, 5},
    [2] = {6, 7, 8, 9, 10},
    [3] = {11, 12, 13, 14, 15},
    [4] = {16, 17, 18, 19, 20},
    [5] = {21, 22, 23, 24, 25}
}

local sobrancelhas = {
    [1] = {1, 2, 3, 4, 5, 6},
    [2] = {7, 8, 9, 10, 11, 12},
    [3] = {13, 14, 15, 16, 17, 18},
    [4] = {19, 20, 21, 22, 23, 24},
    [5] = {25, 26, 27, 28, 29, 30},    
    [6] = {31, 32, 33, 34, 35, 36},    
    [7] = {37, 38, 39, 40, 41, 42},    
    [8] = {43, 44, 45, 46, 47, 48},    
    [9] = {49, 50, 51, 52, 53, 54},    
}

local barbas = {
    [1] = {1, 2, 3, 4, 5, 6},
    [2] = {7, 8, 9, 10, 11, 12},
    [3] = {13, 14, 15, 16, 17, 18},
    [4] = {19, 20, 21, 22, 23, 24},
    [5] = {25, 26, 27, 28, 29, 30},    
    [6] = {31, 32, 33, 34, 35, 36},    
    [7] = {37, 38, 39, 40, 41, 42},    
    [8] = {43, 44, 45, 46, 47, 48},    
    [9] = {49, 50, 51, 52, 53, 54},    
}


local clothes = {
    [7] = {
        ['rosto'] = {
            {'Rosto 1'},
            {'Rosto 2'},
            {'Rosto 3'},
            {'Rosto 4'},
            {'Rosto 5'},
        },
        ['pele'] = {
            {'Pele clara'},
            {'Pele branca'},
            {'Pele parda'},
            {'Pele indiana'},
            {'Pele escura'}
        },
        ['sobrancelha'] = {
            {'Sobrancelha 1'},
            {'Sobrancelha 2'},
            {'Sobrancelha 3'},
            {'Sobrancelha 4'},
            {'Sobrancelha 5'},
            {'Sobrancelha 6'},
            {'Sobrancelha 7'},
            {'Sobrancelha 8'},
            {'Sobrancelha 9'},
        },
        ['cabelo'] = {
            {'Raspado'},
            {'Mano Brown'},
            {'Topete'},
            {'Dreads'},
            {'Tranças'}
        },
        ['barba'] = {
            {'Barba 1'},
            {'Barba 2'},
            {'Barba 3'}, 
            {'Barba 4'},
            {'Barba 5'},
            {'Barba 6'}
        }
    },
    [9] = {
        ['rosto'] = {
            {'Rosto 1'},
            {'Rosto 2'},
            {'Rosto 3'},
            {'Rosto 4'},
            {'Rosto 5'},
        },
        ['pele'] = {
            {'Pele clara'},
            {'Pele branca'},
            {'Pele parda'},
            {'Pele indiana'},
            {'Pele escura'}
        },
        ['sobrancelha'] = {
            {'Sobrancelha 1'},
            {'Sobrancelha 2'},
            {'Sobrancelha 3'},
            {'Sobrancelha 4'},
            {'Sobrancelha 5'},
            {'Sobrancelha 6'},
            {'Sobrancelha 7'},
            {'Sobrancelha 8'},
            {'Sobrancelha 9'},
        },
        ['cabelo'] = {
            {'Cabelo 1'},
            {'Cabelo 2'},
            {'Cabelo 3'},
            {'Cabelo 4'},
            {'Cabelo 5'},
        }
    }
}

local render = function() 

    dxDrawRoundedRectangle ( 1385, 174, 299, 732, 15, tocolor('222831'))

    dxDrawText('Tons de pele', 1385, 216, 297, 16, white, 1, font['roboto']['regular'][16], 'center', 'center')

    dxDrawRoundedRectangle ( 1436, 265, 29, 31, 5, tocolor('B99180'))
    dxDrawRoundedRectangle ( 1479, 265, 29, 31, 5, tocolor('875C48'))
    dxDrawRoundedRectangle ( 1522, 265, 29, 31, 5, tocolor('7F5343'))
    dxDrawRoundedRectangle ( 1565, 265, 29, 31, 5, tocolor('946D53'))
    dxDrawRoundedRectangle ( 1608, 265, 29, 31, 5, tocolor('543A33'))

    if pele then 
        dxDrawImage(slotsPele[pele][1], slotsPele[pele][2], slotsPele[pele][3], slotsPele[pele][4], img.selected)
    end

    -- << rosto >>
    dxDrawText('Rosto', 1385, 352, 297, 16, white, 1, font['roboto']['regular'][16], 'center', 'center')

    dxDrawRoundedRectangle(1465, 390, 40, 36, 3, tocolor('E0E0E0'))
    dxDrawText('<', 1465, 390, 40, 36, tocolor('1D1D1D'), 1, font['roboto']['regular'][16], 'center', 'center')
    dxDrawRoundedRectangle(1568, 390, 40, 36, 3, tocolor('E0E0E0'))
    dxDrawText('>', 1568, 390, 40, 36, tocolor('1D1D1D'), 1, font['roboto']['regular'][16], 'center', 'center')

    dxDrawRectangle(1502, 425, 69, 1.5, tocolor('E0E0E0'))
    dxDrawText(rosto, 1505, 390, 63, 35, white, 1, font['roboto']['regular'][14], 'center', 'center')

    -- << cabelo >>
    dxDrawText('Cabelo', 1405, 476, 124, 22, white, 1, font['roboto']['regular'][16], 'center', 'center')

    dxDrawRoundedRectangle(1405, 524.67, 34.77, 31.29, 3, tocolor('E0E0E0'))
    dxDrawText('<', 1405, 524.67, 34.77, 31.29, tocolor('1D1D1D'), 1, font['roboto']['regular'][16], 'center', 'center')
    dxDrawRoundedRectangle(1494.52, 524.67, 34.77, 31.29, 3, tocolor('E0E0E0'))
    dxDrawText('>', 1494.52, 524.67, 34.77, 31.29, tocolor('1D1D1D'), 1, font['roboto']['regular'][16], 'center', 'center')

    dxDrawRectangle(1437.16, 555, 59.97, 1.5, tocolor('E0E0E0'))
    dxDrawText(cabelo, 1440, 525, 55, 30, white, 1, font['roboto']['regular'][14], 'center', 'center')

    dxDrawText('Cor', 1542, 476, 124, 22, white, 1, font['roboto']['regular'][16], 'center', 'center')

    dxDrawRoundedRectangle(1542, 524.67, 34.77, 31.29, 3, tocolor('E0E0E0'))
    dxDrawText('<', 1542, 524.67, 34.77, 31.29, tocolor('1D1D1D'), 1, font['roboto']['regular'][16], 'center', 'center')
    dxDrawRoundedRectangle(1631.52, 524.67, 34.77, 31.29, 3, tocolor('E0E0E0'))
    dxDrawText('>', 1631.52, 524.67, 34.77, 31.29, tocolor('1D1D1D'), 1, font['roboto']['regular'][16], 'center', 'center')

    dxDrawRectangle(1574.16, 555, 59.97, 1.5, tocolor('E0E0E0'))
    dxDrawText(corCabelo, 1577, 525, 55, 30, white, 1, font['roboto']['regular'][14], 'center', 'center')

    -- << sobrancelha >>
    dxDrawText('Sobrancelha', 1405, 606, 124, 22, white, 1, font['roboto']['regular'][16], 'center', 'center')

    dxDrawRoundedRectangle(1405, 654.67, 34.77, 31.29, 3, tocolor('E0E0E0'))
    dxDrawText('<', 1405, 654.67, 34.77, 31.29, tocolor('1D1D1D'), 1, font['roboto']['regular'][16], 'center', 'center')
    dxDrawRoundedRectangle(1494.52, 654.67, 34.77, 31.29, 3, tocolor('E0E0E0'))
    dxDrawText('>', 1494.52, 654.67, 34.77, 31.29, tocolor('1D1D1D'), 1, font['roboto']['regular'][16], 'center', 'center')
    
    dxDrawRectangle(1437.16, 685.09, 59.97, 1.5, tocolor('E0E0E0'))
    dxDrawText(sobrancelha, 1440, 655, 55, 30, white, 1, font['roboto']['regular'][14], 'center', 'center')
    
    dxDrawText('Cor', 1542, 606, 124, 22, white, 1, font['roboto']['regular'][16], 'center', 'center')
    
    dxDrawRoundedRectangle(1542, 654.67, 34.77, 31.29, 3, tocolor('E0E0E0'))
    dxDrawText('<', 1542, 654.67, 34.77, 31.29, tocolor('1D1D1D'), 1, font['roboto']['regular'][16], 'center', 'center')
    dxDrawRoundedRectangle(1631.52, 654.67, 34.77, 31.29, 3, tocolor('E0E0E0'))
    dxDrawText('>', 1631.52, 654.67, 34.77, 31.29, tocolor('1D1D1D'), 1, font['roboto']['regular'][16], 'center', 'center')
    
    dxDrawRectangle(1574.16, 685.09, 59.97, 1.5, tocolor('E0E0E0'))
    dxDrawText(corSobrancelha, 1577, 655, 55, 30, white, 1, font['roboto']['regular'][14], 'center', 'center')

    -- << barba >>
    if gender == 7 then 
        dxDrawText('Pelos Faciais', 1405, 736, 124, 22, white, 1, font['roboto']['regular'][16], 'center', 'center')

        dxDrawRoundedRectangle(1405, 784.67, 34.77, 31.29, 3, tocolor('E0E0E0'))
        dxDrawText('<', 1405, 784.67, 34.77, 31.29, tocolor('1D1D1D'), 1, font['roboto']['regular'][16], 'center', 'center')
        dxDrawRoundedRectangle(1494.52, 784.67, 34.77, 31.29, 3, tocolor('E0E0E0'))
        dxDrawText('>', 1494.52, 784.67, 34.77, 31.29, tocolor('1D1D1D'), 1, font['roboto']['regular'][16], 'center', 'center')
        
        dxDrawRectangle(1437.16, 815.09, 59.97, 1.5, tocolor('E0E0E0'))
        dxDrawText(barba, 1440, 785, 55, 30, white, 1, font['roboto']['regular'][14], 'center', 'center')
        
        dxDrawText('Cor', 1542, 736, 124, 22, white, 1, font['roboto']['regular'][16], 'center', 'center')
        
        dxDrawRoundedRectangle(1542, 784.67, 34.77, 31.29, 3, tocolor('E0E0E0'))
        dxDrawText('<', 1542, 784.67, 34.77, 31.29, tocolor('1D1D1D'), 1, font['roboto']['regular'][16], 'center', 'center')
        dxDrawRoundedRectangle(1631.52, 784.67, 34.77, 31.29, 3, tocolor('E0E0E0'))
        dxDrawText('>', 1631.52, 784.67, 34.77, 31.29, tocolor('1D1D1D'), 1, font['roboto']['regular'][16], 'center', 'center')
        
        dxDrawRectangle(1574.16, 815.09, 59.97, 1.5, tocolor('E0E0E0'))
        dxDrawText(corBarba, 1577, 785, 55, 30, white, 1, font['roboto']['regular'][14], 'center', 'center')
    end

    dxDrawRoundedRectangle(1497, 859, 90.43, 26, 3, tocolor('92EA74'))
    dxDrawText('CONFIRMAR', 1497, 859, 90.43, 26, tocolor('1D1D1D'), 1, font['roboto']['regular'][10], 'center', 'center')
end

addEvent('openCreatePersonage', true)
addEventHandler('openCreatePersonage', root, function(model)
    setElementData(localPlayer, 'untoggle:hud', true)
    setCameraMatrix(-2387.8959960938, 2212.8176269531, 5.5970997810364, -2387.7958984375, 2211.8227539062, 5.5883421897888, 0, 70)
    addEventHandler('onClientRender', root, render)
    painel = true 
    showCursor(true)
    showChat(false)
    if not ped then 
        gender = model
        if model == 7 then 
            ped = createPed(gender, -2387.7509765625,2211.375,4.984375, 0)
            triggerEvent('setPlayerRoupa', localPlayer, ped, 'calca', 3, 16)
            triggerEvent('setPlayerRoupa', localPlayer, ped, 'camisa', 2, 6)
            setPele(ped)
        else
            ped = createPed(gender, -2387.7509765625,2211.375,4.984375, 0)
            triggerEvent('setPlayerRoupa', localPlayer, ped, 'blusa', 3, 3)
            triggerEvent('setPlayerRoupa', localPlayer, ped, 'calca', 2, 1)
            setPele(ped)
        end
    end
end)

addEventHandler('onClientClick', root, function(b, s)
    if painel == true then 
            if b == 'left' and s == 'down' then 
                if gender == 7 then

                    -- << pele >>
                    for i,v in ipairs(slotsPele) do 
                        if isCursorOnElement(v[1], v[2], v[3], v[4]) then 
                            pele = i
                            setPele(ped)
                            print('textura de Tom de pele: '..rostos[rosto][pele])
                        end
                    end

                    -- << rosto >>
                    if isCursorOnElement(1568, 390, 40, 36) then 
                        if rosto < #clothes[gender]['rosto'] then
                            rosto = rosto +1 
                            pele = 1
                            setPele(ped)
                        end
                    elseif isCursorOnElement(1465, 390, 40, 36) then 
                        if rosto > 1 then 
                            rosto = rosto -1
                            pele = 1
                            setPele(ped)
                        end
                    end

                    -- << sobrancelha >>
                    if isCursorOnElement(1494.52, 654.67, 34.77, 31.29) then 
                        if sobrancelha < #clothes[gender]['sobrancelha'] then 
                            sobrancelha = sobrancelha +1
                            triggerEvent('setPlayerRoupa', localPlayer, ped, 'sobrancelha', 1, sobrancelha)
                        end
                    elseif isCursorOnElement(1405, 654.67, 34.77, 31.29) then 
                        if sobrancelha > 0 then 
                            sobrancelha = sobrancelha -1
                            if sobrancelha == 0 then 
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'sobrancelha', 0, 1)
                            else
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'sobrancelha', 1, sobrancelha)
                            end
                        end
                    end

                    -- << sobrancelha cor >>
                    if isCursorOnElement(1631.52, 654.67, 34.77, 31.29) then 
                        if corSobrancelha < #sobrancelhas then 
                            corSobrancelha = corSobrancelha +1
                            triggerEvent('setPlayerRoupa', localPlayer, ped, 'sobrancelha', 1, sobrancelhas[corSobrancelha][sobrancelha])
                        end
                    elseif isCursorOnElement(1542, 654.67, 34.77, 31.29) then 
                        if corSobrancelha > 0 then 
                            corSobrancelha = corSobrancelha -1
                            if corSobrancelha == 0 then 
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'sobrancelha', 1, sobrancelha)
                            else
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'sobrancelha', 1, sobrancelhas[corSobrancelha][sobrancelha])
                            end
                        end
                    end

                    -- << cabelo >> 
                    if isCursorOnElement(1494.52, 524.67, 34.77, 31.29) then
                        if cabelo < #clothes[gender]['cabelo'] then 
                            cabelo = cabelo +1
                            triggerEvent('setPlayerRoupa', localPlayer, ped, 'cabelo', cabelo, corCabelo or 1)
                        end
                    elseif isCursorOnElement(1405, 524.67, 34.77, 31.29) then 
                        if cabelo > 0 then 
                            cabelo = cabelo -1
                            if cabelo == 0 then 
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'cabelo', 0, 1)
                            else
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'cabelo', cabelo, corCabelo or 1)
                            end
                        end
                    end

                    -- << cabelo cor >>
                    if isCursorOnElement(1631.52, 524.67, 34.77, 31.29) then
                        if corCabelo < 10 then 
                            corCabelo = corCabelo +1
                            triggerEvent('setPlayerRoupa', localPlayer, ped, 'cabelo', cabelo, corCabelo or 1)
                        end
                    elseif isCursorOnElement(1542, 524.67, 34.77, 31.29) then 
                        if corCabelo > 0 then 
                            corCabelo = corCabelo -1
                            if corCabelo == 0 then 
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'cabelo', cabelo, 1)
                            else
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'cabelo', cabelo, corCabelo or 1)
                            end
                        end
                    end


                    -- << barba >>
                    if isCursorOnElement(1494.52, 784.67, 34.77, 31.29) then
                        if barba < #clothes[gender]['barba'] then 
                            barba = barba +1
                            triggerEvent('setPlayerRoupa', localPlayer, ped, 'barba', 1, barba)
                        end
                    elseif isCursorOnElement(1405.52, 784.67, 34.77, 31.29) then 
                        if barba > 0 then 
                            barba = barba -1
                            if barba == 0 then 
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'barba', 0, 1)
                            else
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'barba', 1, barba)
                            end
                        end
                    end

                    -- << barba cor >>
                    if isCursorOnElement(1631.52, 784.67, 34.77, 31.29) then 
                        if corBarba < #barbas[barba] then 
                            corBarba = corBarba +1
                            triggerEvent('setPlayerRoupa', localPlayer, ped, 'barba', 1, barbas[corBarba][barba])
                        end
                    elseif isCursorOnElement(1542, 784.67, 34.77, 31.29) then 
                        if corBarba > 0 then 
                            corBarba = corBarba -1
                            if corBarba == 0 then 
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'barba', 1, barba)
                            else
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'barba', 1, barbas[corBarba][barba])
                            end
                        end
                    end


                    if isCursorOnElement(1497, 859, 90.43, 26) then
                        if gender == 7 then 
                            local valueb = 0
                            if barba > 0 then
                                valueb = 1 
                            end
                            local roupas = {
                                {'cabelo', cabelo, corCabelo or 1},
                                {'barba', valueb, barbas[corBarba or 1][barba] or 1},
                                {'sobrancelha', 1, sobrancelhas[corSobrancelha or 1][sobrancelha] or 1},
                                {'rosto', 1, rostos[rosto][pele]},
                                {'braco', 1, pele},
                                {'corpo', 1, pele},
                                {'calca', 0, 16},
                                {'cueca', 1, 1},
                                {'camisa', 0, 0},
                                {'pernas', 1, pele},
                                {'pe', 1, pele},
                                {'tenis', 1, 1}
                            }
                            triggerServerEvent('SpawnPlayer', localPlayer, localPlayer, gender, roupas, pele)
                            removeEventHandler('onClientRender', root, render)
                            destroyElement(ped)
                            setElementData(localPlayer, 'untoggle:hud', false)
                            painel = false 
                            showCursor(false)
                            showChat(true)
                        end 
                    end
                elseif gender == 9 then 
                    if isCursorOnElement(1497, 859, 90.43, 26) then
                        local roupas = {
                            {'cabelo', cabelo, corCabelo or 1},
                            {'sobrancelha', 1, sobrancelhas[corSobrancelha or 1][sobrancelha]},
                            {'rosto', 1, rostos[rosto][pele]},
                            {'braco', 1, pele},
                            {'corpo', 1, pele},
                            {'calca', 2, 1},
                            {'blusa', 3, 3},
                            {'pernas', 1, pele},
                            {'pe', 1, pele},
                            {'tenis', 1, 1}
                        }
                        destroyElement(ped)
                        triggerServerEvent('SpawnPlayer', localPlayer, localPlayer, gender, roupas, pele)
                        removeEventHandler('onClientRender', root, render)
                        painel = false 
                        showCursor(false)
                        showChat(true)
                        setElementData(localPlayer, 'untoggle:hud', false)
                    end 

                    for i,v in ipairs(slotsPele) do 
                        if isCursorOnElement(v[1], v[2], v[3], v[4]) then 
                            pele = i
                            setPele(ped)
                            print('textura de Tom de pele: '..rostos[rosto][pele])
                        end
                    end

                    -- << rosto >>
                    if isCursorOnElement(1568, 390, 40, 36) then 
                        if rosto < #clothes[gender]['rosto'] then
                            rosto = rosto +1 
                            pele = 1
                            setPele(ped)
                        end
                    elseif isCursorOnElement(1465, 390, 40, 36) then 
                        if rosto > 1 then 
                            rosto = rosto -1
                            pele = 1
                            setPele(ped)
                        end
                    end

                    -- << sobrancelha >>
                    if isCursorOnElement(1494.52, 654.67, 34.77, 31.29) then 
                        if sobrancelha < #clothes[gender]['sobrancelha'] then 
                            sobrancelha = sobrancelha +1
                            triggerEvent('setPlayerRoupa', localPlayer, ped, 'sobrancelha', 1, sobrancelha)
                        end
                    elseif isCursorOnElement(1405, 654.67, 34.77, 31.29) then 
                        if sobrancelha > 0 then 
                            sobrancelha = sobrancelha -1
                            if sobrancelha == 0 then 
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'sobrancelha', 0, 1)
                            else
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'sobrancelha', 1, sobrancelha)
                            end
                        end
                    end

                    -- << sobrancelha cor >>
                    if isCursorOnElement(1631.52, 654.67, 34.77, 31.29) then 
                        if corSobrancelha < #sobrancelhas then 
                            corSobrancelha = corSobrancelha +1
                            triggerEvent('setPlayerRoupa', localPlayer, ped, 'sobrancelha', 1, sobrancelhas[corSobrancelha][sobrancelha])
                        end
                    elseif isCursorOnElement(1542, 654.67, 34.77, 31.29) then 
                        if corSobrancelha > 0 then 
                            corSobrancelha = corSobrancelha -1
                            if corSobrancelha == 0 then 
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'sobrancelha', 1, sobrancelha)
                            else
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'sobrancelha', 1, sobrancelhas[corSobrancelha][sobrancelha])
                            end
                        end
                    end

                    -- << cabelo >> 
                    if isCursorOnElement(1494.52, 524.67, 34.77, 31.29) then
                        if cabelo < #clothes[gender]['cabelo'] then 
                            cabelo = cabelo +1
                            triggerEvent('setPlayerRoupa', localPlayer, ped, 'cabelo', cabelo, corCabelo or 1)
                        end
                    elseif isCursorOnElement(1405, 524.67, 34.77, 31.29) then 
                        if cabelo > 0 then 
                            cabelo = cabelo -1
                            if cabelo == 0 then 
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'cabelo', 0, 1)
                            else
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'cabelo', cabelo, corCabelo or 1)
                            end
                        end
                    end

                    -- << cabelo cor >>
                    if isCursorOnElement(1631.52, 524.67, 34.77, 31.29) then
                        if corCabelo < 10 then 
                            corCabelo = corCabelo +1
                            triggerEvent('setPlayerRoupa', localPlayer, ped, 'cabelo', cabelo, corCabelo or 1)
                        end
                    elseif isCursorOnElement(1542, 524.67, 34.77, 31.29) then 
                        if corCabelo > 0 then 
                            corCabelo = corCabelo -1
                            if corCabelo == 0 then 
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'cabelo', cabelo, 1)
                            else
                                triggerEvent('setPlayerRoupa', localPlayer, ped, 'cabelo', cabelo, corCabelo or 1)
                            end
                        end
                    end
            end
        end
    end
end)

function setPele(ped)
    triggerEvent('setPlayerRoupa', localPlayer, ped, 'rosto', 1, rostos[rosto][pele])
    triggerEvent('setPlayerRoupa', localPlayer, ped, 'braco', 1, pele)
    triggerEvent('setPlayerRoupa', localPlayer, ped, 'corpo', 1, pele)
    triggerEvent('setPlayerRoupa', localPlayer, ped, 'pernas', 1, pele)
    triggerEvent('setPlayerRoupa', localPlayer, ped, 'pe', 1, pele)
end

