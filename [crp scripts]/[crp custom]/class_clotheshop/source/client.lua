local table = {
    handlerAdded = false,
    handlerAdded2 = false,
    slotValues = {},
    slotValues2 = {},
    config = {},
    type = {},
    clothes = {},
    oldClothes = {},
    selectcam = false,
    modelo = 0,
    textura = 0,
    value = 0,
    window = 'inital',
    imagesFiles = {
        [1] = 'assets/images/rectangle.png',
        [2] = 'assets/images/rectangle2.png',
        [3] = 'assets/images/rectangle3.png',
        [4] = 'assets/images/rectangle4.png',
        [5] = 'assets/images/rectangle5.png',
        [6] = 'assets/images/icon1.png',
        [7] = 'assets/images/icon2.png',
        [8] = 'assets/images/icon3.png',
        [9] = 'assets/images/icon4.png',
        [10] = 'assets/images/icon5.png',
        [11] = 'assets/images/icon6.png',
        [12] = 'assets/images/icon7.png',
        [13] = 'assets/images/rectangle6.png',
    },
    fonts = {
        [1] = dxCreateFont('assets/fonts/bold.ttf', 12),
    },
	animationPanel = {
        tickElement = 0,
        start = -1920,
        finish = 0
    },
}



local function open()
    dxSetBlendMode('modulate_add')
    if table.window == 'inital' then 
        p(10, 40, 364, 40, table.imagesFiles[1],0,0,0, tocolor(37, 38, 43, 255))
        t(table.type, 15, 40, 68, 40, tocolor(255, 255, 255, 255), 1, table.fonts[1], 'center', 'center', false)
        t('^', 348, 40, 17, 40, tocolor(255, 255, 255, 255), 1, table.fonts[1], 'center', 'center', false)
    end
    if table.window == 'select' then 
        p(10, 40, 364, 40, table.imagesFiles[1],0,0,0, tocolor(53, 191, 158, 255))
        t(table.type, 15, 40, 68, 40, tocolor(255, 255, 255, 255), 1, table.fonts[1], 'center', 'center', false)
        t('^', 348, 40, 17, 40, tocolor(255, 255, 255, 255), 1, table.fonts[1], 'center', 'center', false)
        
        if table.config then
            line = 0
            for i, v in ipairs(table.config) do
                line = line + 1
                local distancia = 109
                p(10, 88 - distancia + line * distancia, 360, 101, table.imagesFiles[3],0,0,0, tocolor(37, 38, 43, 255))
                t(v['slotName'], 20, 96 - distancia + line * distancia, 68, 17, tocolor(255, 255, 255, 255), 1, table.fonts[1], 'left', 'center', false)
                t('Modelo', 20, 124 - distancia + line * distancia, 50, 17, tocolor(255, 255, 255, 255), 1, table.fonts[1], 'left', 'center', false)
                t(''..table.slotValues[v.slotType]..' / '..(v['valueMaxCategoria'] or 0)..'', 138, 124 - distancia + line * distancia, 50, 17, tocolor(255, 255, 255, 255), 1, table.fonts[1], 'right', 'center', false)
                t('Textura', 205, 124 - distancia + line * distancia, 50, 17, tocolor(255, 255, 255, 255), 1, table.fonts[1], 'left', 'center', false)
                t(''..table.slotValues2[v.slotType]..' / '..(config.txds[getElementModel(localPlayer)][v.slotType][(table.slotValues or 1)[v.slotType]] or 0)..'', 310, 124 - distancia + line * distancia, 50, 17, tocolor(255, 255, 255, 255), 1, table.fonts[1], 'right', 'center', false)
                p(23, 149 - distancia + line * distancia, 30, 30, table.imagesFiles[4],0,0,0, tocolor(45, 46, 54, 255))
                t('<', 23, 149 - distancia + line * distancia, 30, 30, tocolor(255, 255, 255, 255), 1, table.fonts[1], 'center', 'center', false)
                p(55, 149 - distancia + line * distancia, 101, 30, table.imagesFiles[5],0,0,0, tocolor(45, 46, 54, 255))
                t(table.slotValues[v.slotType], 55, 149 - distancia + line * distancia, 101, 30, tocolor(255, 255, 255, 255), 1, table.fonts[1], 'center', 'center', false)
                p(158, 149 - distancia + line * distancia, 30, 30, table.imagesFiles[4],0,0,0, tocolor(45, 46, 54, 255))
                t('>', 158, 149 - distancia + line * distancia, 30, 30, tocolor(255, 255, 255, 255), 1, table.fonts[1], 'center', 'center', false)
                p(198, 149 - distancia + line * distancia, 30, 30, table.imagesFiles[4],0,0,0, tocolor(45, 46, 54, 255))
                t('<', 198, 149 - distancia + line * distancia, 30, 30, tocolor(255, 255, 255, 255), 1, table.fonts[1], 'center', 'center', false)
                p(230, 149 - distancia + line * distancia, 101, 30, table.imagesFiles[5],0,0,0, tocolor(45, 46, 54, 255))
                t(table.slotValues2[v.slotType], 230, 149 - distancia + line * distancia, 101, 30, tocolor(255, 255, 255, 255), 1, table.fonts[1], 'center', 'center', false)
                p(333, 149 - distancia + line * distancia, 30, 30, table.imagesFiles[4],0,0,0, tocolor(45, 46, 54, 255))
                t('>', 333, 149 - distancia + line * distancia, 30, 30, tocolor(255, 255, 255, 255), 1, table.fonts[1], 'center', 'center', false)
            
            end
        end

        if table.selectcam == false then
            p(384, 40, 40, 40, table.imagesFiles[2],0,0,0, tocolor(37, 38, 43, 255))
            p(384, 40, 40, 40, table.imagesFiles[12],0,0,0, tocolor(255, 255, 255, 255))
            p(384, 90, 40, 40, table.imagesFiles[2],0,0,0, tocolor(37, 38, 43, 255))
            p(384, 90, 40, 40, table.imagesFiles[11],0,0,0, tocolor(255, 255, 255, 255))
            p(384, 140, 40, 40, table.imagesFiles[2],0,0,0, tocolor(37, 38, 43, 255))
            p(384, 140, 40, 40, table.imagesFiles[7],0,0,0, tocolor(255, 255, 255, 255))
            p(384, 190, 40, 40, table.imagesFiles[2],0,0,0, tocolor(37, 38, 43, 255))
            p(384, 190, 40, 40, table.imagesFiles[6],0,0,0, tocolor(255, 255, 255, 255))
        else
            p(384, 40, 40, 40, table.imagesFiles[2],0,0,0, tocolor(53, 191, 158, 255))
            p(384, 40, 40, 40, table.imagesFiles[12],0,0,0, tocolor(255, 255, 255, 255))
            
            p(434, 40, 40, 40, table.imagesFiles[2],0,0,0, tocolor(37, 38, 43, 255))
            p(434, 40, 40, 40, table.imagesFiles[10],0,0,0, tocolor(255, 255, 255, 255))
            p(484, 40, 40, 40, table.imagesFiles[2],0,0,0, tocolor(37, 38, 43, 255))
            p(484, 40, 40, 40, table.imagesFiles[9],0,0,0, tocolor(255, 255, 255, 255))
            p(534, 40, 40, 40, table.imagesFiles[2],0,0,0, tocolor(37, 38, 43, 255))
            p(534, 40, 40, 40, table.imagesFiles[8],0,0,0, tocolor(255, 255, 255, 255))

            p(384, 90, 40, 40, table.imagesFiles[2],0,0,0, tocolor(37, 38, 43, 255))
            p(384, 90, 40, 40, table.imagesFiles[11],0,0,0, tocolor(255, 255, 255, 255))
            p(384, 140, 40, 40, table.imagesFiles[2],0,0,0, tocolor(37, 38, 43, 255))
            p(384, 140, 40, 40, table.imagesFiles[7],0,0,0, tocolor(255, 255, 255, 255))
            p(384, 190, 40, 40, table.imagesFiles[2],0,0,0, tocolor(37, 38, 43, 255))
            p(384, 190, 40, 40, table.imagesFiles[6],0,0,0, tocolor(255, 255, 255, 255))
        end

    end
    dxSetBlendMode('blend')   
end

local function bindE()
    local interpolate = interpolateBetween(table.animationPanel.start, 0, 0, table.animationPanel.finish, 0, 0, (getTickCount() - table.animationPanel.tickElement) / 800, 'OutQuad')
    dxSetBlendMode('modulate_add')
		p(interpolate + 10, 711, 206, 45, table.imagesFiles[13])
        t('[E] Interagir - $150', interpolate + 10, 711, 206, 45, tocolor(255, 255, 255, 255), 1, table.fonts[1], 'center', 'center', false)

    dxSetBlendMode('blend')   
end

addEvent('class.bindE', true)
addEventHandler('class.bindE', root, function()
	if table.handlerAdded2 == false then
        table.animationPanel.start, table.animationPanel.finish, table.animationPanel.tickElement = -1920, 0, getTickCount()
    	addEventHandler('onClientRender', root, bindE, false, 'high')
		table.handlerAdded2 = true
	end
end)

addEvent('class.bindE2', true)
addEventHandler('class.bindE2', root, function()
	if table.handlerAdded2 == true then
        table.animationPanel.start, table.animationPanel.finish, table.animationPanel.tickElement = 0, -1920, getTickCount()
		setTimer(function()
    		removeEventHandler('onClientRender', root, bindE)
			table.handlerAdded2 = false
		end, 800, 1)
	end
end)

addEventHandler('onClientClick', root, function(press, state)
    local x, y, z = getCameraMatrix(localPlayer)
    local camg, camg2, camg3 = x, y, z
    
    if table.handlerAdded == true then
        if press == 'left' and state == 'up' then
            if table.window == 'inital' then
                setTimer(function()                
                    if isCursorOnElement(10, 40, 364, 40) then
                        table.window = 'select'
                    end
                end, 100, 1)
            end
            if table.window == 'select' then
                setTimer(function()                
                    if isCursorOnElement(10, 40, 364, 40) then
                        table.window = 'inital'
                    end
                end, 50, 1)
                if isCursorOnElement(385, 190, 40, 40) then
                    for i,v in pairs(table.oldClothes) do 
                        triggerEvent('setPlayerRoupa', localPlayer, localPlayer, i, v[1], v[2])
                    end 
                    closeMenu()
                end
                if isCursorOnElement(379, 36, 52, 47) then
                    if table.selectcam == false then
                        table.selectcam = true
                        
                    else
                        table.selectcam = false
                    end
                end 
                if isCursorOnElement(435, 40, 40, 40) then
                    if table.selectcam == true then
                        setCameraLookAtBone ( camg, camg2, camg3, localPlayer, 21 )
                    end
                end 
                if isCursorOnElement(485, 40, 40, 40) then
                    if table.selectcam == true then
                        setCameraLookAtBone ( camg, camg2, camg3, localPlayer, 3 )
                    end
                end 
                if isCursorOnElement(535, 40, 40, 40) then
                    if table.selectcam == true then
                        setCameraLookAtBone ( camg, camg2, camg3, localPlayer, 52 )
                    end
                end 
                if isCursorOnElement(385, 90, 40, 40) then
                    local x, y, z = getElementRotation(localPlayer)
                    setElementRotation(localPlayer, x, y, z+15)
                end
                if isCursorOnElement(384, 190, 40, 40) then 

                elseif isCursorOnElement(384, 140, 40, 40) then 
                    triggerServerEvent('class.setRoupa', localPlayer, localPlayer, table.clothes)
                    closeMenu()
                end
                if table.config then
                    line = 0
                    for i, v in ipairs(table.config) do
                        line = line + 1
                        local distancia = 109
                        if isCursorOnElement(23, 149 - distancia + line * distancia, 30, 30) then
                            if table.slotValues[v.slotType] > 0 then
                                table.slotValues[v.slotType] = table.slotValues[v.slotType] - 1
                                table.clothes[v.slotType] = {table.slotValues[v.slotType], table.slotValues2[v.slotType], v.item or false}
                                if table.slotValues[v.slotType] == 0 then 
                                    table.clothes[v.slotType] = nil
                                end

                                triggerEvent('setPlayerRoupa', localPlayer, localPlayer, v.slotType, table.slotValues[v.slotType], 1)

                                if table.slotValues[v.slotType] == 0 then 
                                    triggerEvent('setPlayerRoupa', localPlayer, localPlayer, v.slotType, table.oldClothes[v.slotType][1], table.oldClothes[v.slotType][2])
                                end

                                --triggerServerEvent('class.setRoupa', localPlayer, localPlayer, v.slotType, table.slotValues[v.slotType], 1)
                                
                            end
                        end
                        if isCursorOnElement(158, 149 - distancia + line * distancia, 30, 30) then
                            if table.slotValues[v.slotType] < tonumber(v['valueMaxCategoria']) then
                                table.slotValues[v.slotType] = table.slotValues[v.slotType] + 1
                                table.slotValues2[v.slotType] = 1
                                table.clothes[v.slotType] = {table.slotValues[v.slotType], table.slotValues2[v.slotType], v.item or false}

                                triggerEvent('setPlayerRoupa', localPlayer, localPlayer, v.slotType, table.slotValues[v.slotType], 1)
                                --triggerServerEvent('class.setRoupa', localPlayer, localPlayer, v.slotType, table.slotValues[v.slotType], 1)
                            end
                        end
                        if isCursorOnElement(198, 149 - distancia + line * distancia, 30, 30) then
                            if table.slotValues2[v.slotType] > 0 then
                                table.slotValues2[v.slotType] = table.slotValues2[v.slotType] - 1
                                table.clothes[v.slotType] = {table.slotValues[v.slotType], table.slotValues2[v.slotType], v.item or false}
                                if table.slotValues[v.slotType] == 0 then 
                                    table.clothes[v.slotType] = nil
                                end

                                triggerEvent('setPlayerRoupa', localPlayer, localPlayer, v.slotType, table.slotValues[v.slotType], table.slotValues2[v.slotType])
                                --triggerServerEvent('class.setRoupa', localPlayer, localPlayer, v.slotType, table.slotValues[v.slotType], table.slotValues2[v.slotType])
                            end
                        end
                        if isCursorOnElement(333, 149 - distancia + line * distancia, 30, 30) then
                            if table.slotValues2[v.slotType] < (config.txds[getElementModel(localPlayer)][v.slotType][(table.slotValues or 1)[v.slotType]] or 0)then
                                table.slotValues2[v.slotType] = table.slotValues2[v.slotType] + 1
                                table.clothes[v.slotType] = {table.slotValues[v.slotType], table.slotValues2[v.slotType], v.item or false}

                                triggerEvent('setPlayerRoupa', localPlayer, localPlayer, v.slotType, table.slotValues[v.slotType], table.slotValues2[v.slotType])
                                --triggerServerEvent('class.setRoupa', localPlayer, localPlayer, v.slotType, table.slotValues[v.slotType], table.slotValues2[v.slotType])
                            end
                        end
                    end
                end
            end
        end
    end
end)

addEvent('class.openClotheShop', true)
addEventHandler('class.openClotheShop', root, function(assets, type, camera, clothes)
    if table.handlerAdded == false then
        table.handlerAdded = true
        table.oldClothes = clothes 
        iprint(table.oldClothes)
        table.clothes = {}
        table.config = assets
        for _, v in ipairs(table.config) do
            table.slotValues[v.slotType] = 0
            table.slotValues2[v.slotType] = 1
        end
        table.type = type
        addEventHandler('onClientRender', root, open, false, 'high')
        setCameraMatrix(unpack(camera))
        showCursor(true)
    end
end)

function closeMenu()
    if table.handlerAdded == true then
        table.handlerAdded = false
        table.window = 'inital'
        removeEventHandler('onClientRender', root, open)
        showCursor(false)
        setCameraTarget(localPlayer, nil)
    end
end
bindKey('backspace', 'down', closeMenu)
bindKey('escape', 'down', closeMenu)