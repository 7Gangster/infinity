local jb = exports.crp_jobmanager
local vehicleAssets = cfg.vehicle

local markerEntrega = createMarker(vehicleAssets.position[1], vehicleAssets.position[2], vehicleAssets.position[3], 'cylinder', 5, 0, 0, 0, 0)

function msg(player, msg, type, time)
    return exports.crp_notify:addBox(player, msg, type, time)
end

function notify ( player, msg )
    triggerClientEvent(player, 'jobmanager >> notify', player, {
        nome = 'LOS SANTOS SANITARY',
        color = '00F8B9',
        msg = msg,
        img = 'src/assets/notify/trashman.png',
    })
end

local vehicle = {}
local shape = {}
local box = {}

addEvent('trashman >> startService', true)
addEventHandler('trashman >> startService', root, function(player)
    local grupo = getElementData(player, 'JobGroup')
    if getElementData(player, 'InService') then return msg(player, 'Você já esta em serviço.', 'error') end
    if grupo then 
        local list, players = jb:getMembersInGroup(grupo)
        for _, v in ipairs(list) do 
            notify(v, 'Serviço iniciado. Converse com o encarregado para pegar o veiculo.')
            setElementData(v, 'InService', 'Trashman')
        end
    else
        msg(player, 'Antes de iniciar serviço, crie um grupo no tablet.', 'error')
    end
end)

addEvent('trashman >> stopService', true)
addEventHandler('trashman >> stopService', root, function ( player )

    local grupo = getElementData(player, 'JobGroup')

    if getElementData(player, 'InService') then 
        local list, players = jb:getMembersInGroup(grupo)
        local lider = jb:getGroupLider(grupo)
        if lider == player then 
            for _, v in ipairs(list) do 
                setElementData(v, 'RotaCompleta', false)
                setElementData(v, 'InService', false)
                setElementData(v, 'CarregandoLixo', false)

                toggleControl(v, 'sprint', true)
                toggleControl(v, 'jump', true)
                toggleControl(v, 'fire', true)
                toggleControl(v, 'action', true)
                toggleControl(v, 'enter_exit', true)

                if vehicle[grupo] then 
                    destroyElement(vehicle[grupo])
                    vehicle[grupo] = nil
                end

                triggerClientEvent(v, 'togglePointF', v)

                destroyBox(v)

                jb:setGroupMeta(grupo, 0, 0)

                notify(v, 'O lider do grupo cancelou o serviço.')

                
            end
        
            local chave = exports['crp_inventory']:getItemFromData ( player, 'chavecarro', 'vehicle', 'TRASH-'..grupo)
            exports['crp_inventory']:takeItem(player, 'chavecarro', 1, chave)

            destroyElement(shape[grupo].totrash)
            destroyElement(shape[grupo].leftP)
            destroyElement(shape[grupo].rightP)

            shape[grupo] = false
        end
    end
end)

local sticking = false

addCommandHandler("offset",
    function(player, cmd, x, y, z)
        setElementAttachedOffsets(player, x, y, z)
    end
)

function stickOnTruck(player, _, _, truck, theShape)
    if player and truck then
        if not sticking then
            local theGroup = getElementData(player, "JobGroup")
            toggleControl(player, "walk", false)
            toggleControl(player, "fire", false)
            setElementFrozen(player, true)
            setPedAnimation(player, "ped", "jetpack_idle", -1, true, false, false)
            sticking = true
            local truckRX, truckRY, truckRZ = getElementRotation(truck)
            if theShape == shape[theGroup].leftP then
                attachElements(player, truck, -1.3, -3.5, 0, 0, 0, -170)
                setElementRotation(player, truckRX, truckRY, truckRZ + 270)
            else
                attachElements(player, truck, 1.3, -3.5, 0, 0, 0, 170)
                setElementRotation(player, truckRX, truckRY, truckRZ - 270)
            end
        else
            sticking = false
            detachElements(player, truck)
            toggleControl(player, "walk", false)
            toggleControl(player, "fire", false)
            setElementFrozen(player, false)
            setPedAnimation(player)
        end
    end
end

addEventHandler("onColShapeHit", root,
    function(thePlayer)
        if getElementType(thePlayer) == "player" then
            local grupo = getElementData(thePlayer, "JobGroup")
            if grupo then
                if source == shape[grupo].leftP or source == shape[grupo].rightP then
                    msg(thePlayer, 'Pressione E para segurar no caminhão.', 'info')
                    bindKey(thePlayer, 'e', 'down', stickOnTruck, vehicle[grupo], source)
                end
            end
        end
    end
)
addEventHandler("onColShapeLeave", root,
    function(thePlayer)
        if getElementType(thePlayer) == "player" then
            local grupo = getElementData(thePlayer, "JobGroup")
            if grupo then
                if source == shape[grupo].leftP or source == shape[grupo].rightP then
                    unbindKey(thePlayer, 'e', 'down', stickOnTruck)
                end
            end
        end
    end
)

addEvent('trashman >> getVehicle', true)
addEventHandler('trashman >> getVehicle', root, function ( player )
    local grupo = getElementData(player, 'JobGroup')
    if not getElementData(player, 'InService') then return 
        msg(player, 'Você não está em serviço.', 'error')
    end

    if grupo then 

        if vehicle[grupo] then 
            destroyElement(vehicle[grupo])
            vehicle[grupo] = nil
        end

        if not vehicle[grupo] then 
            if not shape[grupo] then shape[grupo] = {} end

            vehicle[grupo] = createVehicle(vehicleAssets.model, unpack(vehicleAssets.position))
            shape[grupo].totrash = createColSphere(vehicleAssets.position[1], vehicleAssets.position[2], vehicleAssets.position[3], 1.5)
            shape[grupo].leftP = createColSphere(vehicleAssets.position[1], vehicleAssets.position[2], vehicleAssets.position[3], 1.2)
            shape[grupo].rightP = createColSphere(vehicleAssets.position[1], vehicleAssets.position[2], vehicleAssets.position[3], 1.2)
            attachElements(shape[grupo].leftP, vehicle[grupo], -2, -3)
            attachElements(shape[grupo].rightP, vehicle[grupo], 2, -3)
            attachElements(shape[grupo].totrash, vehicle[grupo], 0, -4)
            setElementData(vehicle[grupo], 'JobGroup', grupo)
            setElementData(vehicle[grupo], 'Vehicle > ID', 'TRASH-'..grupo)
            setElementData(vehicle[grupo], 'Job', 'Trashman')


            exports['crp_inventory']:giveItem(player, 'chavecarro', 1, {
                vehicle = 'TRASH-'..grupo
            })

            jb:setGroupMeta(grupo, 0, math.random(10, 30))

            local list, players = jb:getMembersInGroup(grupo)
            local valor, meta = jb:getGroupMeta(grupo)
            for _, v in ipairs(list) do 

                setElementData(v, "Job:shape", shape[grupo].totrash)
                notify(v, 'O veiculo foi retirado. Colete '..meta..' lixos pelas lixeiras de Los Santos.')

            end
        end
    end

end)

addEvent('trashman >> guardarLixo', true)
addEventHandler('trashman >> guardarLixo', root, function ( player, element )

    local grupo = getElementData(player, 'JobGroup')
    if not getElementData(player, 'InService') then return 
        msg(player, 'Você não está em serviço.', 'error')
    end

    local valor, meta = jb:getGroupMeta(grupo)
    if (valor + 1) < meta then

        jb:updateGroupMeta(grupo, (( valor or 0 ) + 1))

        local list, players = jb:getMembersInGroup(grupo)
        for _, v in ipairs(list) do 
            notify(v, string.gsub(getPlayerName(player), '_', ' ')..' coletou um lixo. ['..(valor +1)..'/'..meta..']')
        end

        toggleControl(player, 'sprint', true)
        toggleControl(player, 'jump', true)
        toggleControl(player, 'fire', true)
        toggleControl(player, 'action', true)
        toggleControl(player, 'enter_exit', true)

        setElementData(player, 'CarregandoLixo', false)

        destroyBox(player)

    elseif (valor + 1) >= meta then 

        jb:updateGroupMeta(grupo, (( valor or 0 ) + 1))

        local list, players = jb:getMembersInGroup(grupo)
        for _, v in ipairs(list) do 
            notify(v, string.gsub(getPlayerName(player), '_', ' ')..' coletou um lixo. ['..(valor +1)..'/'..meta..']')
            notify(v, 'Todos os lixos foram coletados, volte a empresa para descarregar o veiculo.')

            setElementData(v, 'RotaCompleta', true)



            triggerClientEvent(v, 'togglePoint', v, vehicleAssets.position[1], vehicleAssets.position[2], vehicleAssets.position[3], 'Descarregar veiculo')
        end

        toggleControl(player, 'sprint', true)
        toggleControl(player, 'jump', true)
        toggleControl(player, 'fire', true)
        toggleControl(player, 'action', true)
        toggleControl(player, 'enter_exit', true)

        destroyBox(player)

        setElementData(player, 'CarregandoLixo', false)



    end
    
end)

local coletando = {}

addEvent('trashman >> pegarLixo', true)
addEventHandler('trashman >> pegarLixo', root, function ( player, element )

    local lixo = getElementData(element, 'LixosNaLixeira') or 0

    if getElementData(player, 'CarregandoLixo') then return end
    if lixo < 3 then 

        if coletando[player] then return end
        setElementData(element, 'LixosNaLixeira', lixo +1 )
        triggerClientEvent(player, 'ProgressBar', player, 10000, 'Coletando lixo')

        setElementFrozen(player, true)

        setPedAnimation(player, 'INT_SHOP', 'shop_loop', -1, false, false, false)

        coletando[player] = setTimer(function()

            setPedAnimation(player)

            local grupo = getElementData(player, 'JobGroup')
            if not getElementData(player, 'InService') then return 
                msg(player, 'Você não está em serviço.', 'error')
            end
        
            local valor, meta = jb:getGroupMeta(grupo)
            if (valor + 1) <= meta then

                createBox(player)

                toggleControl(player, 'sprint', false)
                toggleControl(player, 'jump', false)
                toggleControl(player, 'fire', false)
                toggleControl(player, 'action', false)
                toggleControl(player, 'enter_exit', false)

                setElementData(player, 'CarregandoLixo', true)

                setElementFrozen(player, false)

            end

            coletando[player] = nil

        end, 10000, 1)

        setTimer(function ( )
            setElementData(element, 'LixosNaLixeira', 0)
        end, 60000*10, 1)

    else

        msg(player, 'Lixeira vazia', 'error')

    end

end)

function descarregarCaminhao ( player )

    local grupo = getElementData(player, 'JobGroup')

    unbindKey(player, 'h', 'down', descarregarCaminhao)

    local v = getPedOccupiedVehicle(player)

    triggerClientEvent(player, 'ProgressBar', player, 60000, 'Descarregando caminhão.')

    setElementFrozen(player, true)
    setElementFrozen(v, true)

    setTimer(function()

        local list, players = jb:getMembersInGroup(grupo)
        local valor, meta = jb:getGroupMeta(grupo)
        for _, v in ipairs(list) do 

            notify(v, 'O serviço foi completo, colete seu salario com o encarregado.')

            setElementData(v, 'JobRecompensa', (getElementData(v, 'JobRecompensa') or 0) + meta*50)

            setElementData(v, 'InService', false)
            setElementData(v, 'RotaCompleta', false)

        end

        local chave = exports['crp_inventory']:getItemFromData ( player, 'chavecarro', 'vehicle', 'TRASH-'..grupo)
        exports['crp_inventory']:takeItem(player, 'chavecarro', 1, chave)

        setElementFrozen(player, false)

        if vehicle[grupo] then 
            destroyElement(vehicle[grupo])
            vehicle[grupo] = nil
        end

        if shape[grupo] then 
            destroyElement(shape[grupo].totrash)
            destroyElement(shape[grupo].leftP)
            destroyElement(shape[grupo].rightP)

            shape[grupo] = false
        end

    end, 60000, 1)
end

addEventHandler('onMarkerHit', markerEntrega, function ( player )
    if getElementType(player) == 'player' then 
        local grupo = getElementData(player, 'JobGroup')
        if grupo then 
            local vehicle = getPedOccupiedVehicle(player)
            if vehicle then 
                if getElementData(vehicle, 'JobGroup') == grupo then 
                    if getElementData(player, 'RotaCompleta') then 
                        local lider = jb:getGroupLider(grupo)
                        if lider == player then 

                            msg(player, 'Pressione H para descarregar o caminhão.', 'info')
                            bindKey(player, 'h', 'down', descarregarCaminhao)


                        end
                    end
                end
            end
        end
    end
end)

function createBox(player)
    if box[player] then 
        destroyElement(box[player])
        box[player] = nil
    end
    box[player] = createObject(1265, 0, 0, 0)
    setObjectScale(box[player], 0.7)
    exports.pAttach:attach(box[player], player, "right-hand", 0.1, 0, -0.1, 0, 0, 0)
    return box[player]
end

function destroyBox(player)
    if box[player] then 
        destroyElement(box[player])
        box[player] = nil
    end 
end
