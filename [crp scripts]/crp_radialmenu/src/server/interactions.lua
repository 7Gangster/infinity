addEvent('menu:get', true)
addEventHandler('menu:get', root, function( player )
    local t = {}

    table.insert(t, {nome = 'Cidadão', img = "src/assets/icons/player.png", pagina = {
        {nome = 'Examinar', img = "src/assets/icons/player.png", execute = 'examinar', close = true, args = {'player'}},
    }})

    table.insert(t, {nome = 'Estilos de Andar', img = "src/assets/icons/walk.png", pagina = {
        {nome = 'Padrão', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {0}},
        {nome = 'Padrão 2', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {54}},
        {nome = 'Obeso', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {55}},
        {nome = 'Obeso 2', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {124}},
        {nome = 'Musculoso', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {56}},
        {nome = 'Ver mais', img = "src/assets/icons/walk.png", pagina = {
            {nome = 'Furtivo', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {69}},
            {nome = 'Triste', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {119}},
            {nome = 'Idoso', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {120}},
            {nome = 'Gang 1', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {118}},
            {nome = 'Gang 2', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {121}},
            {nome = 'Ver mais', img = "src/assets/icons/walk.png", pagina = {
                {nome = 'Gang 3', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {122}},
                {nome = 'Apressado', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {125}},
                {nome = 'Bebado', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {126}},
                {nome = 'Policial', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {128}},
                {nome = 'Feminino', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {129}},
                {nome = 'Ver mais', img = "src/assets/icons/walk.png", pagina = {
                    {nome = 'Idosa', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {130}},
                    {nome = 'Empoderada', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {131}},
                    {nome = 'Modelo', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {133}},
                    {nome = 'Obesa', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {135}},
                    {nome = 'Apressada', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {136}},
                    {nome = 'Idosa Obesa', img = "src/assets/icons/walk.png", execute = 'setWalkStyle', close = true, args = {137}},
                }},
            }},
        }},
    }})

    if getElementData(player, "class:inGasStation") then
        if not getElementData(player, "class:fueling") then
            table.insert(t, {nome = 'Abastecer', img = "src/assets/icons/fueling.png", execute = 'class:openGasStationS', close = true})
        end
    end

    if getElementData(player, 'InService') == 'Pescador' then 
        if not getElementData(player, 'pescando') then 
            if exports.crp_inventory:getItem(player, 'vara') >= 1 then 
                table.insert(t, {nome = 'Pescar', img = "src/assets/icons/work.png", execute = 'comecarPescador', close = true})
            end
        end
    end

    --table.insert(t, {nome = 'Animações Favoritas', img = "src/assets/icons/dance.png", close = true})
    
    local vehicle = getVehicle ( player, 5 )
    if vehicle then 
        local pagina = {}
        if not isVehicleLocked(vehicle) then 

            if not isPedInVehicle(player) then
                table.insert(pagina, {nome = 'Verificar motor', img = "src/assets/icons/vehicle.png", execute = 'examinar', close = true, args = {'vehicle', vehicle}})
            end
            if getElementData(vehicle, 'Vehicle > Owner') == getElementData(player, 'ID') then 
                table.insert(pagina, {nome = 'Fazer copia da chave', img = "src/assets/icons/vehicle.png", execute = 'copyChave', close = true, args = {vehicle}})
            end
            if getElementData(vehicle, 'Vehicle > ID') and not isPedInVehicle(player) then 
                table.insert(pagina, {nome = 'Abrir porta-malas', img = "src/assets/icons/vehicle.png", execute = 'interaction >> portamalas', close = true, args = {vehicle}})
            end
            if not isPedInVehicle(player) then
                table.insert(pagina, {nome = 'Entrar na mala', img = "src/assets/icons/vehicle.png", execute = 'interaction >> entrarmala', close = true, args = {vehicle}})
            end
            if exports.crp_inventory:getItemData(player, 'chavecarro', 'vehicle') == getElementData(vehicle, 'Vehicle > ID') then 
                table.insert(pagina, {nome = 'Trancar Veiculo', img = "src/assets/icons/vehicle.png", execute = 'dealership >> lock', close = true, args = {vehicle}})
            end
            table.insert(t, {nome = 'Veiculo', img = 'src/assets/icons/vehicle.png', pagina = pagina})
        else
            if exports.crp_inventory:getItemData(player, 'chavecarro', 'vehicle') == getElementData(vehicle, 'Vehicle > ID') then 
                table.insert(pagina, {nome = 'Destrancar Veiculo', img = "src/assets/icons/vehicle.png", execute = 'dealership >> lock', close = true, args = {vehicle}})
            end
            table.insert(t, {nome = 'Veiculo', img = 'src/assets/icons/vehicle.png', pagina = pagina})
        end

    end

    if getElementData(player, 'police >> duty') then 

        local pagina = {
            {nome = 'Agarrar', img = 'src/assets/icons/arrest.png', execute = 'interaction >> agarrar'},
            {nome = 'Colocar no veiculo', img = 'src/assets/icons/vehicle.png', execute = 'interaction >> colocarveiculo'},
            {nome = 'Revistar', img = 'src/assets/icons/arrest.png', execute = 'interaction >> revistar', args = {getPlayerNearest ( player, 1 )}},
        }

        table.insert(t, {nome = 'Trabalho', img = 'src/assets/icons/work.png', pagina = pagina})
    end

    triggerClientEvent(player, 'menu:set', player, t)
end)

function getVehicle ( player, distance )
    local target = false
    for i,v in ipairs(getElementsByType('vehicle')) do 
        local x, y, z = getElementPosition(player)
        local x2, y2, z2 = getElementPosition(v)
        if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= distance then 
            target = v
        end
    end
    return target
end

function getPlayerNearest ( player, distance )
    local target = false
    for i,v in ipairs(getElementsByType('player')) do 
        if v ~= player then 
            local x, y, z = getElementPosition(player)
            local x2, y2, z2 = getElementPosition(v)
            if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= distance then 
                target = v
            end
        end
    end
    return target
end

function getFavoriteAnimations ( )
end