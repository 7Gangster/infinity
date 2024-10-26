addEvent('examinar', true)
addEventHandler('examinar', root, function ( player, type, element )
    if type == 'player' then 
        if not getElementData(player, 'Sangrando') then 
            msg(player, 'Você não esta sangrando.', 'info')
        else
            msg(player, 'Sangramento encontrado.', 'blood')
        end
    elseif type == 'vehicle' then 
        msg(player, 'Estado do motor: '..(getElementHealth(element)/10)..'%', 'info')
    end
end)

addEvent('setWalkStyle', true)
addEventHandler('setWalkStyle', root, function ( player, style )
    setPedWalkingStyle(player, style)
end)

addEvent('copyChave', true)
addEventHandler('copyChave', root, function ( player, vehicle )
    if getElementData(vehicle, 'Vehicle > ID') then 
        giveItem(player, 'chavecarro', 1, {
            vehicle = getElementData(vehicle, 'Vehicle > ID'),
        })
    end
end)

function msg(player, msg, type)
    return exports.crp_notify:addBox(player, msg, type)
end

function giveItem(player, item, qtd, data)
    return exports['crp_inventory']:giveItem(player, item, qtd, data)
end