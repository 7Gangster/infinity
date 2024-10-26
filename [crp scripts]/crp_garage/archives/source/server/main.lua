local functions = { };
local resource = { ['Database'] = false, ['Marker'] = {}, ['Vehicle'] = {} };
local config = getConfig();

functions.startGarages = function()
    resource['Database'] = dbConnect('sqlite', 'archives/assets/database/garages-db.sql');
    for i, v in pairs(config['Garages']) do
        dbExec(resource['Database'], 'CREATE TABLE IF NOT EXISTS `class_'..i.. '` (id INTEGER PRIMARY KEY AUTOINCREMENT, account TEXT, indexVeh INTEGER, Combustivel INTEGER, Motor INTEGER, Situacao TEXT, Position JSON, Rotation JSON)');
        local marker = createMarker(v['Position'].x, v['Position'].y, (v['Position'].z - 1), 'cylinder', 1.2, 255, 255, 255, 90);
        resource['Marker'][marker] = {true, v, i};
    end
    outputDebugString('['..getResourceName(getThisResource())..'] Sistema iniciado com sucesso.', 4, 61, 67, 128)
end
addEventHandler('onResourceStart', resourceRoot, functions.startGarages);

functions.hitGarages = function(hitElement, dimension)
    if resource['Marker'][source] then
        if (resource['Marker'][source][1]) then
            if (hitElement) and (getElementType(hitElement) == 'player') and (not isGuestAccount(getPlayerAccount(hitElement))) and (not getPedOccupiedVehicle(hitElement)) and (dimension) then    
                local values = resource['Marker'][source][2];
                if (not getElementData(hitElement, values['Data Permissions'])) then return config.serverNotify(hitElement, config['Messages']['notPermission'][1], config['Messages']['notPermission'][2], config['TimeDefault']) end
                local index = resource['Marker'][source][3];
                local result = dbPoll(dbQuery(resource['Database'], 'SELECT * FROM `class_'..index..'` WHERE account = ?', getAccountName(getPlayerAccount(hitElement))), -1);
                triggerClientEvent(hitElement, 'CLASS >> GARAGE MANAGER', resourceRoot, values, result, index);
            end
        end
    end
end
addEventHandler('onMarkerHit', root, functions.hitGarages);

functions.buyVehicle = function(thePlayer, value, select, tableInfos, id)
    print(id)
    dbExec(resource['Database'], 'INSERT INTO `class_'..tableInfos['index']..'` (account, indexVeh, Combustivel, Motor, Situacao, Position, Rotation) VALUES (?, ?, ?, ?, ?, ?, ?)', getAccountName(getPlayerAccount(thePlayer)), select, 100, 100, 'Guardado', toJSON({unpack(config['Garages'][id]['SpawnPosition'])}), toJSON({unpack(config['Garages'][id]['SpawnRotation'])}))
    exports.crp_inventory:takeItem(player, 'dinheiro', value['Price'])
end

addEvent('CLASS >> VEHICLE MANAGER', true)
addEventHandler('CLASS >> VEHICLE MANAGER', root,
    function(thePlayer, value, index, tableInfos, select, typeManager, id)
        if typeManager == 'garage' then
            local vehID = tonumber(value['id'])
            if resource['Vehicle'][vehID] then return config.serverNotify(thePlayer, config['Messages']['vehicleSpawned2'][1], config['Messages']['vehicleSpawned2'][2], config['TimeDefault']); end
            local Position = fromJSON(value['Position']);
            local Rotation = fromJSON(value['Rotation']);
            resource['Vehicle'][vehID] = createVehicle(tableInfos['Vehicles'][index]['ID'], Position[1], Position[2], Position[3], Rotation[1], Rotation[2], Rotation[3]);
            setElementHealth(resource['Vehicle'][vehID], (tonumber(value['Motor'])*10));
            setElementData(resource['Vehicle'][vehID], tostring(config['ElementData Gasoline']), (tonumber(value['Combustivel'])))
            setElementData(resource['Vehicle'][vehID], 'Vehicle > Owner', getElementData(thePlayer, 'ID'))
            --warpPedIntoVehicle(thePlayer, resource['Vehicle'][vehID]);
            dbExec(resource['Database'], 'UPDATE `class_'..tableInfos['index']..'` SET Situacao = ? WHERE id = ?', 'Em Rua', vehID);
            config.serverNotify(thePlayer, config['Messages']['takeVehicle'][1], config['Messages']['takeVehicle'][2], config['TimeDefault']);
            return true
        elseif typeManager == 'shop' then
            local result = dbPoll(dbQuery(resource['Database'], 'SELECT * FROM `class_'..tableInfos['index']..'` WHERE account = ?', getAccountName(getPlayerAccount(thePlayer))), -1)
            if not result or #result == 0 then
                functions.buyVehicle(thePlayer, value, select, tableInfos, id)
                config.serverNotify(thePlayer, config['Messages']['buyVehicle'][1], config['Messages']['buyVehicle'][2], config['TimeDefault']);
                return true
            else
                for i, v in ipairs(result) do
                    if v['indexVeh'] == select then
                        config.serverNotify(thePlayer, config['Messages']['vehicleExists'][1], config['Messages']['vehicleExists'][2], config['TimeDefault']);
                        return false
                    end
                end
            end
        
            functions.buyVehicle(thePlayer, value, select, tableInfos, id)
            config.serverNotify(thePlayer, config['Messages']['buyVehicle'][1], config['Messages']['buyVehicle'][2], config['TimeDefault']);
            return true
            
        elseif typeManager == 'destroy' then
            local result = dbPoll(dbQuery(resource['Database'], 'SELECT * FROM `class_'..tableInfos['index']..'` WHERE account = ?', getAccountName(getPlayerAccount(thePlayer))), -1);
            if result and #result > 0 then
        
                for i, v in ipairs(result) do
                    if resource['Vehicle'][v['id']] and isElement(resource['Vehicle'][v['id']]) then
                        local x, y, z = getElementPosition(thePlayer);
                        local x1, y1, z1 = getElementPosition(resource['Vehicle'][v['id']])
                        if getDistanceBetweenPoints3D(x, y, z, x1, y1, z1) < config['DistanceGarage'] then
                            dbExec(resource['Database'], 'UPDATE `class_'..tableInfos['index']..'` SET Situacao = ?, Combustivel = ?, Motor = ?, Position = ?, Rotation = ? WHERE id = ?', 'Guardado', tonumber((getElementData(resource['Vehicle'][v['id']], config['ElementData Gasoline']) or 0 )), (getElementHealth(resource['Vehicle'][v['id']]) / 10), toJSON({getElementPosition(resource['Vehicle'][v['id']])}), toJSON({getElementRotation(resource['Vehicle'][v['id']])}), v['id'])
                            destroyElement(resource['Vehicle'][v['id']])
                            resource['Vehicle'][v['id']] = nil
                            config.serverNotify(thePlayer, config['Messages']['destroyVehicle'][1], config['Messages']['destroyVehicle'][2], config['TimeDefault'])
                            break
                        end
                    end
                end
            end
        end
    end
)


function getPlayerMoney ( player )
    return exports.crp_inventory:getItem(player, 'dinheiro') or 0
end

function givePlayerMoney ( player, amount )
    return exports.crp_inventory:giveItem(player, 'dinheiro', amount) or false
end

function takePlayerMoney ( player, amount )
    return exports.crp_inventory:takeItem(player, 'dinheiro', amount) or false
end