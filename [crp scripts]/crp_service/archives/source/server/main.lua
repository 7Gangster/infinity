local marker = {}
local timer_service = {}

for i,v in ipairs(Config.Markers) do 
    local interior = v.int or 0
    local dimensao = v.dim or 0
    marker[i] = exports['crp_markers']:createMarker('get_service', Vector3 { v[1], v[2], v[3]-0.9})
    setElementInterior(marker[i], interior)
    setElementDimension(marker[i], dimensao)
    setElementData(marker[i], 'service:marker', {v[4], v[5], v[6], v[7]})
    if v.model then
        setElementData(marker[i], 'skin', v.model)
        setElementData(marker[i], 'roupas', toJSON(v.roupas))
    end
    if v.roupas and not v.model then 
        iprint(v.roupas)
        setElementData(marker[i], 'roupas', toJSON(v.roupas))
    end
end

function startService(player, b, s, marker)
    local acl, diretory, element, nomeGroup = unpack(getElementData(marker, 'service:marker'))
    if not getElementData(player, element) then 
        local time = getRealTime()
        setElementData(player, element, true)
        triggerClientEvent(player, 'startService', player, diretory, nomeGroup)
        Config.server_Notification(player, 'Serviço iniciado com sucesso.', 'success')
        Config.server_Notification(player, 'Proximo salário as: '..string.format("%02d:%02d", time.hour+1, time.minute), 'info')
        if getElementData(marker, 'roupas') then 
            local roupas = fromJSON(getElementData(marker, 'roupas'))
            local roupas_antigas = exports['agatreix_custom']:getClothes(player)
            setAccountData(getPlayerAccount(player), 'roupas:antigas', toJSON( roupas_antigas ))
            if getElementData(marker, 'skin') then
                setElementModel(player, getElementData(marker, 'skin'))
            end
            for i,v in ipairs(roupas) do 
                triggerEvent('setPlayerClothe', player, player, v[1], v[2], v[3])
            end
            return true;
        end
        timer_service[player] = setTimer(function()
            local time = getRealTime()
            givePlayerMoney(player, Config.Salarios[acl])
            Config.server_Notification(player, 'Você recebeu seu salario de R$'..Config.Salarios[acl], 'success')
            Config.server_Notification(player, 'Proximo salário as: '..string.format("%02d:%02d", time.hour+1, time.minute), 'info')
        end, 60000*60, 0)
    end
end

function stopService(player, b, s, marker)
    local acl, diretory, element, nomeGroup = unpack(getElementData(marker, 'service:marker'))
    if getElementData(player, element) then 
        setElementData(player, element, false)
        if isTimer(timer_service[player]) then 
            killTimer(timer_service[player])
            timer_service[player] = nil
            triggerClientEvent(player, 'startService', player)
        end
        if getElementModel(player) == 280 or getElementModel(player) == 281 or getElementModel(player) == 282 or getElementModel(player) == 283 or getElementModel(player) == 284 or getElementModel(player) == 285 then
            exports['agatreix_custom']:onLogin(player)
        end
        Config.server_Notification(player, 'Serviço finalizado.', 'info')
    end
end

addEventHandler('onMarkerHit', root, function(player, dim)
    if getElementType(player) == 'player' then 
        if getElementData(source, 'service:marker') then 
            local acl, diretory, element, nomeGroup = unpack(getElementData(source, 'service:marker'))
            local account = 'user.'..getAccountName(getPlayerAccount(player))
            if isObjectInACLGroup(account, aclGetGroup(acl)) then 
                if not getElementData(player, element) then
                    Config.server_Notification(player, 'Pressione "E" para iniciar seu serviço', 'info')
                    bindKey(player, 'E', 'down', startService, source)
                else
                    Config.server_Notification(player, 'Pressione "E" para encerrar seu serviço', 'info')
                    bindKey(player, 'E', 'down', stopService, source)
                end
            end
        end
    end
end)

addEventHandler('onPlayerQuit', root, function()
    if isTimer(timer_service[source]) then 
        killTimer(timer_service[source])
        timer_service[source] = nil
    end
end)

addEventHandler('onMarkerLeave', root, function(player)
    if getElementType(player) == 'player' then 
        if getElementData(source, 'service:marker') then 
            unbindKey(player, 'E', 'down', startService, source)
            unbindKey(player, 'E', 'down', stopService, source)
        end
    end
end)