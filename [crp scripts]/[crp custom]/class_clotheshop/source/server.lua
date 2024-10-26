marker = {}

addEventHandler('onResourceStart', resourceRoot,
function(resourceName)
    if (resourceName == resource) then
        outputDebugString('[ '.. getResourceName(getThisResource()) ..' ]: The resource was launched successfully', 4, 200, 119, 192)
        loadMarkers ( )
    end
end)

addEvent('class.setRoupa', true)
addEventHandler('class.setRoupa', root, function(player, clothes)
    for i,v in pairs(clothes) do 

        exports['agatreix_custom']:setroupa(player, getElementModel(player), i, v[1], v[2])

        if getElementModel(player) == 7 or getElementModel(player) == 9 then 
            if i ~= 'cabelo' and i ~='barba' and i ~='sobrancelha' then 
                if not v[4] then 
                    exports.crp_inventory:giveItem(player, i..'-'..v[1]..'-'..v[2], 1)
                else
                    exports.crp_inventory:giveItem(player, v[4]..'-'..v[1]..'-'..v[2], 1)
                end
            end
        end

    end
end)

addEvent('class.buyRoupa', true)
addEventHandler('class.buyRoupa', root, function(ply, arg1, arg2, arg3)
    triggerClientEvent(root, 'setPlayerRoupa', ply, ply, arg1, arg2, arg3)
end)

function openShop ( player, _, _, type, camera )
    if config.slots[type][getElementModel(player)] then 
		if exports.crp_inventory:getItem(player, 'dinheiro') >= 150 then
			exports.crp_inventory:takeItem(player, 'dinheiro', 150)
        	triggerClientEvent(player, 'class.openClotheShop', player, config.slots[type][getElementModel(player)], type, camera, getRoupas ( player ))
        	unbindKey(player, 'e', 'down', openShop)
			triggerClientEvent(player, 'class.bindE2', root)
		else
			exports['crp_notify']:addBox(player, 'Você não possui 150 dolares', 'error', 5000)
		end
    end
end

function loadMarkers ( )
    for i,v in ipairs(config.markers) do 
        local marker = createMarker(v[1], v[2], v[3], 'cylinder', 1.5, 0, 0, 0, 10)
        createBlip(v[1], v[2], v[3], v.blip or 54)
        setElementData(marker, 'Shop-Type', v[4])
        setElementData(marker, 'Camera', v.camera)
    end

end

function handlePlayerHitMarker(player)
    if getElementType(player) == 'player' then 
        if getElementData(source, 'Shop-Type') then 
			triggerClientEvent(player, 'class.bindE', root)
            bindKey(player, 'e', 'down', openShop, getElementData(source, 'Shop-Type'), getElementData(source, 'Camera'))
        end
    end
end

function handlePlayerLeaveMarker(player)
    if getElementType(player) == 'player' then 
        if getElementData(source, 'Shop-Type') then 
			triggerClientEvent(player, 'class.bindE2', root)
            unbindKey(player, 'e', 'down', openShop)
        end
    end
end
addEventHandler("onMarkerHit", resourceRoot, handlePlayerHitMarker)
addEventHandler("onMarkerLeave", resourceRoot, handlePlayerLeaveMarker)

function getRoupas ( player )
    local tabela = exports['agatreix_custom']:getRoupas(getElementData(player, 'ID'), getElementModel(player))
    local clothes = {}
    for i,v in ipairs(tabela) do 
        clothes[v[1]] = {v[2], v[3]}
    end
    return clothes
end