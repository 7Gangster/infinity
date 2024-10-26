addEvent('oxy:startService', true)
addEventHandler('oxy:startService', root, function ( player )
    local grupo = getElementData(player, 'JobGroup') 
    if grupo then 
        if not getElementData(player, 'InService') then 
            setElementData(player, 'InService', 'Oxy')
        else
            msg(player, 'Você já esta em serviço.', 'error')
        end
    end
end)

function msg ( player, msg, type )
    exports['crp_notify']:addBox(player, msg, type)
end