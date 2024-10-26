local selected = nil

local ped = {}
local train
local gender = false
local creating = false

local nome = guiCreateEdit(-1, -1, 0, 0, '')
local sobrenome = guiCreateEdit(-1, -1, 0, 0, '')
local idade = guiCreateEdit(-1, -1, 0, 0, '')

guiEditSetMaxLength(nome, 9)
guiEditSetMaxLength(sobrenome, 9)
guiEditSetMaxLength(idade, 2)

local characters = {}

function renderChars ( )

    if creating then 
        renderCreate()
    else
        if not selected then 
            dxDrawImage(938, 983, 44, 43, 'src/assets/add.png')
            dxDrawRoundedRectangle(768, 99, 384, 110, 10, tocolor('232831', 98))
            if #characters == 0 then 
                dxDrawText('Crie seu personagem', 768, 101, 384, (135-99), white, 1, font['regular'][4], 'center', 'center')
            else
                dxDrawText('Selecione um personagem', 768, 101, 384, (135-99), white, 1, font['regular'][4], 'center', 'center')
            end

            dxDrawRoundedRectangle(787, 135, 346, 2, 2, tocolor('FFFFFF', 100))
    
            dxDrawRoundedRectangle(787, 154, 168, 27, 10, tocolor('3F4042', 90))
            dxDrawText('DELETAR', 846, 159, 67, 36, tocolor('232931'), 1, font['regular'][2], 'left', 'top')
            dxDrawRoundedRectangle(965, 154, 168, 27, 10, tocolor('3F4042', 90))
            dxDrawText('SPAWN', 1028, 159, 67, 36, tocolor('232931'), 1, font['regular'][2], 'left', 'top')
        else
            dxDrawRoundedRectangle(768, 99, 384, 110, 10, tocolor('232831', 98))
            dxDrawText(selected.nome..' - '..selected.id..'', 768, 101, 384, (135-99), white, 1, font['regular'][4], 'center', 'center')
            dxDrawRoundedRectangle(787, 135, 346, 2, 2, tocolor('FFFFFF', 100))
    
            dxDrawRoundedRectangle(787, 154, 168, 27, 10, tocolor('F2A365'))
            dxDrawText('DELETAR', 846, 159, 67, 36, tocolor('232931'), 1, font['regular'][2], 'left', 'top')
            dxDrawRoundedRectangle(965, 154, 168, 27, 10, tocolor('95EF77'))
            dxDrawText('SPAWN', 1028, 159, 67, 36, tocolor('232931'), 1, font['regular'][2], 'left', 'top')
        end
    end

end

function renderCreate ()

    dxDrawRoundedRectangle(719, 152, 482, 815, 10, tocolor('232831', 90))
    dxDrawRoundedRectangle(761, 897, 177, 43, 10, tocolor('F2A365'))
    dxDrawText('CANCELAR', 761, 897, 177, 43, tocolor('232931'), 1, font['regular'][3], 'center', 'center')
    dxDrawRoundedRectangle(982, 897, 177, 43, 10, tocolor('95EF77'))
    dxDrawText('CRIAR', 982, 897, 177, 43, tocolor('232931'), 1, font['regular'][3], 'center', 'center')

    dxDrawText('Escolha o sexo:', 903, 180, 136, 22, white, 1, font['regular'][3], 'left', 'top')
    if gender == 'male' then 
        dxDrawImage(749, 203, 202, 389, 'src/assets/male1.png')
    else
        dxDrawImage(749, 203, 202, 389, 'src/assets/male0.png')
    end

    if gender == 'female' then 
        dxDrawImage(916, 152, 270, 440, 'src/assets/female1.png')
    else
        dxDrawImage(916, 152, 270, 440, 'src/assets/female0.png')
    end

    dxDrawText('Primeiro nome', 774, 620, 136, 22, tocolor('9E9E9E'), 1, font['regular'][3], 'left', 'top')
    dxDrawRectangle(898, 650, 260, 2, tocolor('9E9E9E'))
    dxDrawText(guiGetText(nome), 908, (650-46), 260, 46, tocolor('9E9E9E'), 1, font['regular'][3], 'left', 'center')
    dxDrawText('Último nome', 780, 685, 136, 22, tocolor('9E9E9E'), 1, font['regular'][3], 'left', 'top')
    dxDrawRectangle(898, 714, 260, 2, tocolor('9E9E9E'))
    dxDrawText(guiGetText(sobrenome), 908, (714-46), 260, 46, tocolor('9E9E9E'), 1, font['regular'][3], 'left', 'center')
    dxDrawText('Idade', 798, 750, 136, 22, tocolor('9E9E9E'), 1, font['regular'][3], 'left', 'top')
    dxDrawRectangle(898, 778, 260, 2, tocolor('9E9E9E'))
    dxDrawText(guiGetText(idade), 908, (778-46), 260, 46, tocolor('9E9E9E'), 1, font['regular'][3], 'left', 'center')


end

addEventHandler('onClientResourceStart', resourceRoot, function()
    fadeCamera(false)
    -- puxar personagens
    string = '.'
    timer = setTimer(function()
        if string == '.' then 
            string = '..'
        elseif string == '..' then 
            string = '...'
        elseif string == '...' then 
            string = '.'
        end
    end, 500, 0)
    local function render ()
        dxDrawText('Carregando personagens '..string..'', 0, 0, 1920, 1080, white, 1, font['semibold'][4], 'center', 'center')
    end
    addEventHandler('onClientRender', root, render)
    triggerServerEvent('getCharacters', localPlayer, localPlayer)
    setElementData(localPlayer, 'untoggle:hud', true)

    setTimer(function()
        train = createVehicle(449 , 1455.571, 2636.429, 10.82) -- Modelo do trem e coordenadas iniciais
        setTrainSpeed(train, -0.38) -- Velocidade do trem a cada mais velocidade mais longe ele vai parar :)
        killTimer(timer)
        timer = nil
        removeEventHandler('onClientRender', root, render)
        setCameraMatrix(unpack(cfg.camera))
        fadeCamera(true)
        addEventHandler('onClientRender', root, renderChars)
        showCursor(true)
    end, 5000, 1)
end)

addEventHandler('onClientClick', root, function(b, s, _, _, wx, wy, wz, element)
    if b == 'left' and s == 'down' then 
        if isEventHandlerAdded('onClientRender', root, renderChars) then 
            if not creating then 
                if not selected then
                    if #characters < cfg.maxCharacters then
                        if isCursorOnElement(938, 983, 44, 43) then
                            creating = true
                            return true
                        end
                    end
                elseif selected then 
                    if isCursorOnElement(965, 154, 168, 27) then 
                        triggerServerEvent('loginCharacter', localPlayer, localPlayer, selected.id)
                        close ()
                    end
                end
                if element then 
                    if getElementType(element) == 'ped' then 
                        if getElementData(element, 'id') then 
                            if selected ~= characters[getElementData(element, 'id')] then
                                local i = getElementData(element, 'id')
                                selected = characters[getElementData(element, 'id')]
                                setCameraMatrix(cfg.positions[i][1], cfg.positions[i][2]+2.5, cfg.positions[i][3]+0.5, cfg.positions[i][1], cfg.positions[i][2], cfg.positions[i][3]+0.5, 0, 50)
                                
                            else 
                                selected = nil 
                                setCameraMatrix(unpack(cfg.camera))
    
                            end
                        end
                    end
                    return true
                end
            else
                if isCursorOnElement(753, 205, 181, 380) then 
                    gender = 'male'
                elseif isCursorOnElement(984, 212, 181, 380) then 
                    gender = 'female'
                elseif isCursorOnElement(903, (650-46), 260, 46) then 
                    guiFocus(nome)
                elseif isCursorOnElement(903, (714-46), 260, 46) then 
                    guiFocus(sobrenome)
                elseif isCursorOnElement(903, (778-46), 260, 46) then 
                    guiFocus(idade)
                elseif isCursorOnElement(761, 897, 177, 43) then 
                    creating = false 
                elseif isCursorOnElement(982, 897, 177, 43) then 
                    creating = false 
                    if guiGetText(nome) == '' then return end
                    if guiGetText(sobrenome) == '' then return end
                    if guiGetText(idade) == '' then return end
                    if not gender then return end
                    local skin = 7
                    if gender == 'male' then 
                        skin = 7
                    elseif gender == 'female' then 
                        skin = 9
                    end
                    triggerServerEvent('createCharacter', localPlayer, localPlayer, guiGetText(nome), guiGetText(sobrenome), guiGetText(idade), skin)
                    close ()
                end
            end
        end
    end
end)

function close ()
    fadeCamera(false)
    timer = setTimer(function()
    if string == '.' then 
        string = '..'
    elseif string == '..' then 
        string = '...'
    elseif string == '...' then 
            string = '.'
        end
    end, 500, 0)
    local function render ()
       dxDrawText('Carregando '..string..'', 0, 0, 1920, 1080, white, 1, font['semibold'][4], 'center', 'center')
    end
    addEventHandler('onClientRender', root, render)
    removeEventHandler('onClientRender', root, renderChars)
    setTimer(function()
        removeEventHandler('onClientRender', root, render)
        showCursor(false)
        killTimer(timer)
        fadeCamera(true)
        setElementData(localPlayer, 'untoggle:hud', false)
        characters = {}
        for i,v in ipairs(ped) do 
            destroyElement(v)
        end
        destroyElement(train)
    end, 5000, 1)
end

bindKey('backspace', 'down', function()
    if isEventHandlerAdded('onClientRender', root, renderChars) then
        if not creating then 
            if selected then 
                selected = nil
                setCameraMatrix(unpack(cfg.camera))
            end 
        else
            creating = false
        end
    end
end)

function loadPeds ( tabela )
    characters = tabela
    iprint(tabela)
    for i,v in ipairs(tabela) do 
        if ped[i] then 
            destroyElement(ped[i])
            ped[i] = nil
        end

        ped[i] = createPed(v.skin, cfg.positions[i][1], cfg.positions[i][2], cfg.positions[i][3], cfg.positions[i][4])
        setElementFrozen(ped[i], true)
        setElementData(ped[i], 'id', i)
        setElementData(ped[i], 'Pele', v.pele)
        for k, value in ipairs(v.clothes) do 
            if value[1] == 'pernas' or value[1] == 'bracos' or value[1] == 'pe' or value[2] == 'pe2' then 
                triggerEvent('setPlayerRoupa', localPlayer, ped[i], value[1], value[2], v.pele)
            else
                triggerEvent('setPlayerRoupa', localPlayer, ped[i], value[1], value[2], value[3])
            end
        end
        setTimer(function ( )
            setPedAnimation(ped[i], 'ped', 'XPRESSscratch', -1, true, false, false, true)
        end, math.random(500, 2000), 1)
    end
end
addEvent('loadCharacters', true)
addEventHandler('loadCharacters', root, loadPeds)

local cams = {
    [1] = {825.48577880859, -1381.0322265625, -2.2186999320984, 824.86242675781, -1380.259765625, -2.0970122814178, 0, 70},
    [2] = {842.1826171875, -1372.3100585938, 1.1538000106812, 841.20678710938, -1372.0993652344, 1.0959347486496, 0, 70}
}

addEvent('animation', true)
addEventHandler('animation', root, function ( )

    local trem = createVehicle(449, 774.613, -1329.625, -1.28)
    fadeCamera ( false )
    playSound('src/assets/buzina.mp3')

    local render = function ( )
        local time = getRealTime()
        local monthday = time.monthday
        local month = time.month+1
        local year = time.year
        local formattedTime = string.format("%02d/%02d/%04d", monthday, month, year + 1900)
        dxDrawText('Market Station - Los Santos \n'..formattedTime, 0, 0, 1920, 1080, white, 1, font['semibold'][4], 'center', 'center')
    end

    setTimer(function()
        setCameraMatrix(unpack(cams[1]))
        addEventHandler('onClientRender', root, render)
    end, 1000, 1)

    setTimer(function()

        fadeCamera(true)
        removeEventHandler('onClientRender', root, render)

        setTrainSpeed(trem, -0.5)

        playSound('src/assets/trem.mp3')
        
        setTimer(function ( )
            fadeCamera(false)
            setTimer(function()
                fadeCamera(true)
                destroyElement(trem)
                setElementPosition(localPlayer, 825.55181884766,-1370.0285644531,-0.50146150588989)
                setElementRotation(localPlayer, -0, 0, 311.56674194336)
                setCameraTarget(localPlayer)
            end, 3000, 1)
        end, 5000, 1)
    
    end, 10000, 1)


end)

--[[addCommandHandler('teste', function ( )
    triggerEvent('animation', localPlayer)
end)

addCommandHandler('camera', function()
    local camera = { getCameraMatrix() }
    setClipboard(table.concat(camera, ', '))
end) ]] --