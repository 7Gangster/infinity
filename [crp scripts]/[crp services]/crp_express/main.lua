local jb = exports.crp_jobmanager

function msg(player, msg, type, time)
    return exports.crp_notify:addBox(player, msg, type, time)
end

function notify ( player, msg )
    triggerClientEvent(player, 'jobmanager >> notify', player, {
        nome = 'DELUXE EXPRESS',
        color = '00F8B9',
        msg = msg,
        img = 'src/assets/notify/express.png',
    })
end

local vehicle = {}
local blip = {}
local box = {}
local marker = {}

addEvent('express >> startService', true)
addEventHandler('express >> startService', root, function(player)
    local grupo = getElementData(player, 'JobGroup')
    if getElementData(player, 'InService') then return msg(player, 'Você já esta em serviço.', 'error') end
    if grupo then 
        local list, players = jb:getMembersInGroup(grupo)
        for _, v in ipairs(list) do 
            notify(v, 'Serviço iniciado. Converse com o encarregado para pegar o veiculo.')
            setElementData(v, 'InService', 'Express')
            setElementData(v, 'EstacionarVeiculo', false)
        end
    else
        msg(player, 'Antes de iniciar serivço, crie um grupo no tablet.', 'error')
    end
end)

addEvent('express >> stopService', true)
addEventHandler('express >> stopService', root, function(player)
    local grupo = getElementData(player, 'JobGroup')
    if not getElementData(player, 'InService') then return msg(player, 'Você não esta em serviço.', 'error') end
    if grupo then 
        local list, players = jb:getMembersInGroup(grupo)
        local lider = jb:getGroupLider(grupo)
        if lider == player then 
            for _, v in ipairs(list) do 
                notify(v, 'O lider do grupo cancelou o serviço.')

                if vehicle[grupo] then 
                    destroyElement(vehicle[grupo])
                    vehicle[grupo] = nil
                end

                setElementData(v, 'Express:Entrega', false)
                setElementData(v, 'InService', false)

                toggleControl(v, 'sprint', true)
                toggleControl(v, 'jump', true)
                toggleControl(v, 'fire', true)
                toggleControl(v, 'action', true)
                toggleControl(v, 'enter_exit', true)

                if getElementData(v, 'CarregandoCaixa') then 
                    
                    setElementData(v, 'CarregandoCaixa', false)

                    destroyBox(v)

                    setElementData(v, 'EstacionarVeiculo', false)

                end

                for id, value in ipairs(cfg.entregas) do 
                    setElementVisibleTo(marker[id], v, false)
                    setElementVisibleTo(blip[id], v, false)
                end

                local chave = exports['crp_inventory']:getItemFromData ( lider, 'chavecarro', 'vehicle', 'EXPRESS-'..grupo)
                exports['crp_inventory']:takeItem(lider, 'chavecarro', 1, chave)

            end
        end
    end
end)

addEvent('express >> takevehicle', true)
addEventHandler('express >> takevehicle', root, function ( player )
    local grupo = getElementData(player, 'JobGroup')
    if grupo then 
        if vehicle[grupo] then return msg(player, 'Você já possui um veiculo em rua.', 'error') end
        if getElementData(player, 'InService') == 'Express' then 
            if player == jb:getGroupLider(grupo) then 
                local vehicleAssets = cfg.vehicle
                vehicle[grupo] = createVehicle(vehicleAssets.model, unpack(vehicleAssets.spawn))
                setElementData(vehicle[grupo], 'JobGroup', grupo)
                setElementData(vehicle[grupo], 'Job', 'Express')
                exports['crp_inventory']:giveItem(player, 'chavecarro', 1, {
                    vehicle = 'EXPRESS-'..grupo
                })
                setElementData(vehicle[grupo], 'Vehicle > ID', 'EXPRESS-'..grupo)
                local list, players = jb:getMembersInGroup(grupo)
                for _, v in ipairs(list) do 
                    notify(v, 'Veiculo carregado. Vá até o local marcado em seu gps e descarregue as caixas.')
                end
                addEventHandler('onVehicleExit', vehicle[grupo], destroyVehicle)
                createTarget( grupo )
            else
                msg(player, 'Apenas o lider do grupo pode pegar o veiculo.', 'error')
            end
        else
            msg(player, 'Você não está em serviço.', 'error')
        end
    end
end)

addEvent('express >> takebox', true)
addEventHandler('express >> takebox', root, function(player, element)
    local grupo = getElementData(player, 'JobGroup')
    if grupo then 
        if grupo == getElementData(element, 'JobGroup') then 
            if getElementData(player, 'InService') == 'Express' and not getElementData(player, 'CarregandoCaixa') then 
                local entrega = getElementData(player, 'Express:Entrega')
                if isElement(entrega) then 
                    local x, y, z = getElementPosition(player)
                    local x2, y2, z2 = getElementPosition(entrega)
                    local valor, meta = jb:getGroupMeta(grupo)
                    if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 20 then
                        if (valor + 1) < meta then
                            setElementData(player, 'CarregandoCaixa', true)
                            
                            msg(player, 'Entregue a caixa no local marcado.', 'info')
                            --triggerClientEvent(player, 'togglePoint', player, x2, y2, z2)
                            triggerClientEvent(player, 'togglePoint', player, x2, y2, z2, 'Local de entrega')
                            --notify(v, 'Veiculo carregado. Vá até o local marcado em seu gps e descarregue as caixas.')
                            toggleControl(player, 'sprint', false)
                            toggleControl(player, 'jump', false)
                            toggleControl(player, 'fire', false)
                            toggleControl(player, 'action', false)
                            toggleControl(player, 'enter_exit', false)

                            createBox(player)

                        elseif (valor + 1) == meta then 
                            if getPlayersEntregando (grupo) == 0 then 
                                setElementData(player, 'CarregandoCaixa', true)
                            
                                triggerClientEvent(player, 'togglePoint', player, x2, y2, z2, 'Local de entrega')
                                msg(player, 'Entregue a caixa no local marcado.', 'info')

                                toggleControl(player, 'sprint', false)
                                toggleControl(player, 'jump', false)
                                toggleControl(player, 'fire', false)
                                toggleControl(player, 'action', false)
                                toggleControl(player, 'enter_exit', false)

                                createBox(player)
                            end
                        else
                            msg(player, 'A meta ja foi cumprida.', 'error')
                        end
                    else
                        msg(player, 'Você está muito longe do local de entrega.', 'error') 
                    end
                end
            end
        end
    end
end)

function createTarget( grupo )
    if vehicle[grupo] and not isVehicleBlown(vehicle[grupo]) and not isElementInWater(vehicle[grupo]) then 
        local list, players = jb:getMembersInGroup(grupo)
        local random = math.random(1, #marker)
        local x, y = getElementPosition(marker[random])
        for _, v in ipairs(list) do 
            setElementData(v, 'Express:Entrega', marker[random])
            setElementVisibleTo(blip[random], v, true)
            setElementVisibleTo(marker[random], v, true)
            setElementData(v, 'gpsDestination', {x, y})
        end
        jb:setGroupMeta(grupo, 0, (5*players))
    end
end

function loadEntregas ( )
    for i,v in ipairs(cfg.entregas) do 
        marker[i] = createMarker(v[1], v[2], v[3], 'cylinder', 3, 0, 0, 0, 0)
        blip[i] = createBlipAttachedTo(marker[i], 0)
        setElementData(marker[i], 'id', i)
        setElementData(marker[i], 'Job', 'Express')
        setElementVisibleTo(marker[i], root, false)
        setElementVisibleTo(blip[i], root, false)
    end
    addEventHandler('onMarkerHit', resourceRoot, entregarCaixa)
end

function entregarCaixa (player)
    if getElementData(player, 'Express:Entrega') == source then 
        if getElementData(source, 'Job') == 'Express' then
            if getElementType(player) == 'player' then 
                if isElementVisibleTo(source, player) and getElementData(player, 'CarregandoCaixa') then 
                    local grupo = getElementData(player, 'JobGroup')
                    local list, players = jb:getMembersInGroup(grupo)
                    local valor, meta = jb:getGroupMeta(grupo)
                    local recompensa = {100 * players, 200 * players}
                    jb:updateGroupMeta(grupo, (( valor or 0 ) + 1))
                    for _, v in ipairs(list) do 
                        if (valor + 1) < meta then 
                            notify(v, string.gsub(getPlayerName(player), '_', ' ')..' entregou uma caixa. ['..(valor +1)..'/'..meta..']')
                        else
                            notify(v, string.gsub(getPlayerName(player), '_', ' ')..' entregou uma caixa. ['..(valor +1)..'/'..meta..']')
                            notify(v, 'Todas as caixas foram entregues. Volte a empresa e guarde o veiculo.')
                            setElementVisibleTo(source, v, false)
                            setElementVisibleTo(blip[getElementData(source, 'id')], v, false)
                            setElementData(v, 'EstacionarVeiculo', true)
                            setElementData(v, 'CarregandoCaixa', false)
                            triggerClientEvent(v, 'togglePoint', v, cfg.vehicle.spawn[1], cfg.vehicle.spawn[2], cfg.vehicle.spawn[3], 'Estacionar veiculo')
                            destroyBox(v)
                            setElementData(player, 'Express:Entrega', false)
                        end
                    end
                    toggleControl(player, 'sprint', true)
                    toggleControl(player, 'jump', true)
                    toggleControl(player, 'fire', true)
                    toggleControl(player, 'action', true)
                    toggleControl(player, 'enter_exit', true)
                    destroyBox(player)
                    setElementData(player, 'JobRecompensa', (getElementData(player, 'JobRecompensa') or 0) + math.random(recompensa[1], recompensa[2]))
                    setElementData(player, 'CarregandoCaixa', false)
                end
            end
        end
    end
end

function destroyVehicle (  player ) 
    local grupo = getElementData(source, 'JobGroup')
    if getElementData(source, 'JobGroup') then 
        if getElementData(source, 'JobGroup') == getElementData(player, 'JobGroup') then 
            if getElementData(player, 'EstacionarVeiculo') then 
                local lider = jb:getGroupLider(grupo)
                local x, y, z = getElementPosition(source)
                if getElementData(player, 'EstacionarVeiculo') then 
                    if getDistanceBetweenPoints3D(x, y, z, cfg.vehicle.spawn[1], cfg.vehicle.spawn[2], cfg.vehicle.spawn[3]) <= 20 then
                        removeEventHandler('onVehicleExit', source, destroyVehicle) 
                        destroyElement(source)
                        local list, players = jb:getMembersInGroup(grupo)
                        for _, v in ipairs(list) do 
                            setElementData(v, 'InService', false)
                            notify(v, 'Serviço finalizado. Pegue o dinheiro com o encarregado.')
                        end
                        vehicle[grupo] = nil
                        local chave = exports['crp_inventory']:getItemFromData ( lider, 'chavecarro', 'vehicle', getElementData(source, 'Vehicle > ID'))
                        exports['crp_inventory']:takeItem(lider, 'chavecarro', 1, chave)
                        setElementData(player, 'EstacionarVeiculo', false)
                    end
                end
            end
        end
    end
end

function getPlayersEntregando (grupo)
    local count = 0
    local list, players = jb:getMembersInGroup(grupo)
    for i,v in ipairs(list) do 
        if getElementData(v, 'CarregandoCaixa') then 
            count = count + 1
        end
    end
    return count
end

function createBox(player)
    if box[player] then 
        destroyElement(box[player])
        box[player] = nil
    end 
    box[player] = createObject(1271, 0, 0, 0)
    setObjectScale(box[player], 0.75)
    exports.pAttach:attach(box[player], player, 0, -0.5,0,0.4,0,0,0)
    return box[player]
end

function destroyBox(player)
    if box[player] then 
        destroyElement(box[player])
        box[player] = nil
    end 
end

setTimer(function()
    for _, player in ipairs(getElementsByType('player')) do 
        if getElementData(player, 'CarregandoCaixa') then
            setPedAnimation(player, 'CARRY', 'crry_prtial', 0, true, true, true)
            setControlState(player, 'sprint', false)
            setControlState(player, 'walk', true)
        end
    end
end, 1000, 0)

loadEntregas ( )