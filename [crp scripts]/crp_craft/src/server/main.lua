addEvent('openBancada', true)
addEventHandler('openBancada', root, function ( player, element )

    local type = getElementData(element, 'Bancada') 
    local acl = getElementData(element, 'ACL') or 'Everyone'

    if type then 

        if aclGetGroup(acl) and isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup(acl)) then 
            if cfg.types[type] then 
                triggerClientEvent(player, 'managePanel', player, true)
                triggerClientEvent(player, 'updateCraft', player, cfg.types[type])
            end
        end
        
    end

end)

addEvent('startCraft', true)
addEventHandler('startCraft', root, function (player, item, qtd)
    local count = 0
    for i,v in ipairs(item.items) do 
        if exports.crp_inventory:getItem(player, v.item) >= v.qtd*qtd then 
            count = count +1
        else
            msg(player, 'Você precisa de '..v.qtd*qtd..'x '..v.item, 'error')
        end
    end
    if count == #item.items then 
        for i,v in ipairs(item.items) do 
            if exports.crp_inventory:getItem(player, v.item) >= v.qtd*qtd then 
                exports.crp_inventory:takeItem(player, v.item, v.qtd*qtd)
            end
        end
        triggerClientEvent(player, 'startCraft', player, item, qtd)
    end
end)

addEvent('endCraft', true)
addEventHandler('endCraft', root, function ( player, item, qtd)
    exports.crp_inventory:giveItem(player, item.item, qtd)
end)

addEvent('bancada >> maconha', true)
addEventHandler('bancada >> maconha', root, function( bancada )
    setElementData(bancada, 'Bancada', 'maconha')
end)

function loadBanch ( )
    for i,v in ipairs(cfg.bancadas) do 
        local marker = createMarker(v[1], v[2], v[3] -0.9, 'cylinder', 1, 0, 0, 0, 0)
        setElementData(marker, 'Bancada', v[4])
        setElementData(marker, 'ACL', v[5])
    end
end

addEventHandler('onMarkerHit', resourceRoot, function ( player )
    if getElementType(player) == 'player' then 
        if getElementData(source, 'Bancada') then 
            triggerEvent('openBancada', player, player, source)
        end
    end
end)

function msg(player, msg, type)
    return exports.crp_notify:addBox(player, msg, type)
end

loadBanch ( )