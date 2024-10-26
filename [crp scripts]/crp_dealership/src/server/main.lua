
db = dbConnect('sqlite', 'src/assets/data.db')
print(db)
dbExec(db, 'CREATE TABLE IF NOT EXISTS vehicles (id, owner, model, position, garagem, color, status, handling, plate, vehicleid, livery, upgrades)')
dbExec(db, 'CREATE TABLE IF NOT EXISTS estoque (id, estoque)')

local veiculos = {}
local carros = {}


local popular = createBlip(2128.2180175781,-1132.6151123047,25.56517791748, 55)
local low = createBlip(2810.453, -1561.354, 11.094, 55)
local luxo = createBlip(-1955.2155761719,277.94232177734,35.46875, 55)
local moto = createBlip(2117.0046386719,1404.8736572266,11.1328125, 55)
local caminhao = createBlip(-59.238143920898,-313.21392822266,7.1209869384766, 55)

function DealershiploadVehicles()
    local estoque = {}
    for i,v in ipairs(Config.Veiculos) do 
        if getEstoque(i) > 0 then 
            table.insert(estoque, {i, getEstoque(i)})
            if not veiculos[i] then 
                veiculos[i] = createVehicle(v.model, v.position[1], v.position[2], v.position[3], v.position[4], v.position[5], v.position[6])
                setVehicleLocked(veiculos[i], true)
                setElementData(veiculos[i], 'dealership', {v.model, v.nome, v.preco, i})
                setElementFrozen(veiculos[i], true)
            end
            for k, player in ipairs(getElementsByType('player')) do
                setTimer(function()
                    triggerClientEvent(player, 'setCollision', player, veiculos[i])
                    triggerClientEvent(player, 'updateEstoque', player, estoque)
                end, 1000, 1)
            end
        else
            if veiculos[i] then 
                destroyElement(veiculos[i])
                veiculos[i] = nil
            end
        end
    end
end

function setEstoque()
    local result = dbPoll(dbQuery(db, 'SELECT * FROM estoque'), -1)
    for i,v in ipairs(Config.Veiculos) do 
        if not result[i] then 
            dbExec(db, 'INSERT INTO estoque VALUES (?, ?)', i, v.estoque)
        end
    end
end

function updateEstoque(id, value)
    local result = dbPoll(dbQuery(db, 'SELECT * FROM estoque WHERE id = ?', id), -1)
    if #result > 0 then 
        dbExec(db, 'UPDATE estoque SET estoque = ? WHERE id = ?', value, id)
        DealershiploadVehicles()
    end
end

function getEstoque(id)
    local result = dbPoll(dbQuery(db, 'SELECT * FROM estoque WHERE id = ?', id), -1)
    local estoque = Config.Veiculos[id].estoque
    if #result > 0 then 
        estoque = tonumber(result[1].estoque)
    end
    return estoque
end

addEvent('dealership >> buy', true)
addEventHandler('dealership >> buy', root, function(player, element)
    if client then
        player = client
    end
    local model, nome, preco, i = unpack(getElementData(element, 'dealership'))
	if exports.crp_inventory:getItem(player, 'dinheiro') >= preco then
        local result = dbPoll(dbQuery(db, 'SELECT * FROM vehicles WHERE owner = ?', getElementData(player, 'ID')), -1)
        local id = dbPoll(dbQuery(db, 'SELECT * FROM vehicles '), -1)
        if #result < Config.maxVehicles or isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup(Config.aclVip)) then 
			exports.crp_inventory:takeItem(player, 'dinheiro', preco)
            if #id > 0 then
                dbExec(db, 'INSERT INTO vehicles VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', (id[#id].id or 0)+1, getElementData(player, 'ID'), model, toJSON({0, 0, 0, 0}), 0, 0, toJSON({motor = 1000, fuel = 100, pneus = {0, 0, 0, 0}, locked = true}), toJSON({}), "CRP-"..math.random(1111, 9999), i, 0, toJSON({}))
                updateEstoque(i, (getEstoque(i) - 1))
                local carro = DealerShipspawnVehicle( (id[#id].id or 0)+1, Config.Veiculos[i].spawn)
                warpPedIntoVehicle(player, carro)
                exports.crp_inventory:giveItem(player, 'chavecarro', 1, {vehicle = (id[#id].id or 0)+1})
            else
                dbExec(db, 'INSERT INTO vehicles VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', 1, getElementData(player, 'ID'), model, toJSON({0, 0, 0, 0}), 0, 0, toJSON({motor = 1000, fuel = 100, pneus = {0, 0, 0, 0}, locked = true}), toJSON({}), "CRP-"..math.random(1111, 9999), i, 0, toJSON({}))
                updateEstoque(i, (getEstoque(i) - 1))
                local carro = DealerShipspawnVehicle( 1, Config.Veiculos[i].spawn)
                warpPedIntoVehicle(player, carro)
                exports.crp_inventory:giveItem(player, 'chavecarro', 1, {vehicle = 1})
            end
        else
            msg(player, 'Você já possui a quantidade máxima de veiculos.', 'error')
        end
    else
        msg(player, 'Você não possui dinheiro suficiente.', 'error')
    end
end)

addEvent('dealership >> givevehicle', true)
addEventHandler('dealership >> givevehicle', root, function(player, id, livery, color)
    if client then
        player = client
    end
    local result = dbPoll(dbQuery(db, 'SELECT * FROM vehicles WHERE owner = ?', getElementData(player, 'ID')), -1)
    local color = color or {255, 255, 255}
    if #result < Config.maxVehicles or isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup(Config.aclVip)) then 
        local veiculo = Config.Veiculos[id]
        local model, nome = veiculo.model, veiculo.name
        local id2 = dbPoll(dbQuery(db, 'SELECT * FROM vehicles '), -1)
        if #id2 > 0 then
            dbExec(db, 'INSERT INTO vehicles VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', (id2[#id2].id or 0)+1, getElementData(player, 'ID'), model, toJSON({0, 0, 0, 0}), tostring(5), toJSON({color[1], color[2], color[3]}), toJSON({motor = 1000, fuel = 100, pneus = {0, 0, 0, 0}, locked = true}), toJSON({}), "CRP-"..math.random(1111, 9999), id, (tostring(livery) or 0), toJSON({}))
        else 
            dbExec(db, 'INSERT INTO vehicles VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', 1, getElementData(player, 'ID'), model, toJSON({0, 0, 0, 0}), tostring(5), toJSON({color[1], color[2], color[3]}), toJSON({motor = 1000, fuel = 100, pneus = {0, 0, 0, 0}, locked = true}), toJSON({}), "CRP-"..math.random(1111, 9999), id, (tostring(livery) or 0), toJSON({}))
        end
        msg(player, 'Você ganhou um '..nome..'! O veiculo foi enviado para Garagem 5.', 'success')
    else
        msg(player, 'Você já possui a quantidade máxima de veiculos.', 'error')
    end
end)

addEvent('dealership >> takevehicle', true)
addEventHandler('dealership >> takevehicle', root, function(player, vehicleid)
    if client then
        player = client
    end
    local result = dbPoll(dbQuery(db, 'SELECT * FROM vehicles WHERE owner = ? AND id = ?', getElementData(player, 'ID'), vehicleid), -1)
    if #result > 0 then 
        dbExec(db, 'DELETE FROM vehicles WHERE owner = ? AND id = ?', getElementData(player, 'ID'), vehicleid)
    end
end)

function DealerShipspawnVehicle(vehicle_id, location)
    local result = dbPoll(dbQuery(db, 'SELECT * FROM vehicles WHERE id = ?', vehicle_id), -1)
    if #result > 0 then 
        local position = fromJSON(result[1].position)
        local x, y, z, rz = unpack(position)
        if x == 0 and y == 0 and z == 0 and rz == 0 then 
            if location then 
                local status = fromJSON(result[1].status)
                
                iprint(status)
                --local gas_type = Config.Veiculos[tonumber(result[1].vehicleid)].type_gas
                carros[vehicle_id] = createVehicle(result[1].model, location[1], location[2], location[3], 0, 0, location[4], result[1].plate)
                setElementData(carros[vehicle_id], 'Vehicle > ID', result[1].id)
                setElementData(carros[vehicle_id], 'Vehicle > Owner', result[1].owner)
                setElementData(carros[vehicle_id], 'Vehicle > Index', result[1].vehicleid)
                setElementHealth(carros[vehicle_id], status.motor)
                setElementData(carros[vehicle_id], 'Turbina', (status.turbina or false))
                setElementData(carros[vehicle_id], 'Fuel', status.fuel)
                if result[1].color ~= 0 then
                    local color = fromJSON(result[1].color)
                    setVehicleColor(carros[vehicle_id], color[1], color[2], color[3], color[1], color[2], color[3], color[1], color[2], color[3])
                end
                if result[1].livery ~= 0 then 
                    triggerClientEvent(root, 'setVehicleLivery', root, carros[vehicle_id], result[1].model, result[1].livery)
                end
                setVehicleWheelStates(carros[vehicle_id], status.pneus[1], status.pneus[2], status.pneus[3], status.pneus[4])
                setVehicleLocked(carros[vehicle_id], status.locked)

                return carros[vehicle_id]
            end
        else
            local status = fromJSON(result[1].status)
            local color = fromJSON(result[1].color)
            carros[vehicle_id] = createVehicle(result[1].model, x, y, z, 0, 0, rz, result[1].plate)
            setElementData(carros[vehicle_id], 'Vehicle > Owner', result[1].owner)
            setElementData(carros[vehicle_id], 'Turbina', (status.turbina or false))
            setElementData(carros[vehicle_id], 'Vehicle > ID', result[1].id)
            setElementData(carros[vehicle_id], 'Vehicle > Index', result[1].vehicleid)
            setElementHealth(carros[vehicle_id], status.motor)
            setElementData(carros[vehicle_id], 'Fuel', status.fuel)
            setVehicleColor(carros[vehicle_id], color[1], color[2], color[3], color[1], color[2], color[3], color[1], color[2], color[3])
            if status.pneus then
                setVehicleWheelStates(carros[vehicle_id], status.pneus[1], status.pneus[2], status.pneus[3], status.pneus[4])
            end
            setVehicleLocked(carros[vehicle_id], status.locked)
            setTimer(function()
                if result[1].livery ~= 0 then 
                    triggerClientEvent(root, 'setVehicleLivery', root, carros[vehicle_id], result[1].model, result[1].livery)
                end
            end, 1000, 1)
            local upgrades = fromJSON(result[1].upgrades)
            if upgrades and #upgrades > 0 then
                for i,v in ipairs(upgrades) do 
                    addVehicleUpgrade ( carros[vehicle_id], v )
                end
            end
            return carros[vehicle_id]
        end
    end
end

addEventHandler('onResourceStop', resourceRoot, function()
    local result = dbPoll(dbQuery(db, 'SELECT * FROM vehicles'), -1)
    if #result > 0 then 
        for i,v in ipairs(result) do 
            local id = tonumber(v.id)
            if carros[id] and isElement(carros[id]) then 
                local x, y, z = getElementPosition(carros[id])
                local rx, ry, rz = getElementRotation(carros[id])
                local gas_type = Config.Veiculos[v.vehicleid].type_gas
                local gas = getElementData(carros[id], 'Fuel')
                local color = toJSON({getVehicleColor(carros[id], true)})
                local position = toJSON({x, y, z, rz})
                local updates = getVehicleUpgrades()
                local pneus = { getVehicleWheelStates(carros[id]) }
                local locked = isVehicleLocked(carros[id])
                dbExec(db, 'UPDATE vehicles SET position = ?, status = ?, color = ?, livery = ?, upgrades = ? WHERE id = ?', position, toJSON({motor = getElementHealth(carros[id]), fuel = gas, pneus = pneus, locked = locked}), color, (tostring(getElementData(carros[id], 'ZN-VehLivery')) or 0), toJSON(updates), id)
            end
        end
    end
end)

addEventHandler('onResourceStart', resourceRoot, function()
    local result = dbPoll(dbQuery(db, 'SELECT * FROM vehicles'), -1)
    if #result > 0 then 
        for i,v in ipairs(result) do 
            print(v.garagem)
            if v.garagem == 0 or v.garagem == tostring(0) then 
                DealerShipspawnVehicle(v.id)
            end
        end
    end
end)

addEvent('dealership >> lock', true)
addEventHandler('dealership >> lock', root, function(player, element)
    --[[if getElementData(element, 'Vehicle > ID') or getElementData(element, 'ID') then ]]
    if exports['crp_inventory']:getItem(player, 'chavecarro') >= 1 then 
        local vehicle_id = (getElementData(element, 'Vehicle > ID') or 0)
        if exports['crp_inventory']:getItemData(player, 'chavecarro', 'vehicle', vehicle_id) == vehicle_id then
            --if --[[getElementData(element, 'Vehicle > Owner') == getElementData(player, 'ID')  or ]] exports.crp_inventory:getItemData(player, 'chavecarro', 'vehicle') == getElementData(element, 'Vehicle > ID') or 0 then 
                if isVehicleLocked(element) then 
                    setVehicleLocked(element, false)
                    setTimer(setVehicleOverrideLights, 100, 2, element, 2)
                    setTimer(setVehicleOverrideLights, 300, 2, element, 1)
                    msg(player, 'Veiculo destrancado', 'error')
                else
                    setVehicleLocked(element, true)
                    setTimer(setVehicleOverrideLights, 100, 2, element, 2)
                    setTimer(setVehicleOverrideLights, 300, 2, element, 1)
                    msg(player, 'Veiculo trancado', 'success')
                end
            end
        --end
    end
end)

addEventHandler('onPlayerLogin', root, function()
    DealershiploadVehicles()
end)

addEventHandler('onVehicleStartEnter', root, function()
    if isVehicleLocked(source) then 
        cancelEvent()
    end
end)

DealershiploadVehicles()
setEstoque()

getNearestObject = function(player, element, distance)
    local x, y, z = getElementPosition(player)
    local target = false
    if element then 
        for i,v in ipairs(getElementsByType(element)) do 
            local x2, y2, z2 = getElementPosition(v)
            if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= distance then 
                target = v
            end
        end
    end
    return target
end

addCommandHandler('guardarveiculos', function(player)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then
        for i,carro in ipairs(getElementsByType('vehicle')) do 
            if getElementData(carro, 'Vehicle > ID') then
                local id = getElementData(carro, 'Vehicle > ID')
                local x, y, z = getElementPosition(carro)
                local rx, ry, rz = getElementRotation(carro)
                local gas = getElementData(carro, 'Fuel')
                local color = toJSON({getVehicleColor(carro, true)})
                local position = toJSON({x, y, z, rz})
                local pneus = { getVehicleWheelStates(carro) }

                if getElementHealth(carro) < 350 then 
                    setElementHealth(carro, 350)
                end

                dbExec(db, 'UPDATE vehicles SET position = ?, garagem = ?, status = ?, color = ?, livery = ? WHERE id = ?', toJSON({0, 0, 0, 0}), '5', toJSON({motor = getElementHealth(carro), fuel = gas, pneus = pneus, locked = isVehicleLocked(carro)}), color, (getElementData(carro, 'ZN-VehLivery') or 0), id)

                destroyElement(carro)
                msg(player, 'Veiculo '..id..' guardado', 'info')
            end
        end
        msg(player, 'Todos veiculos na rua vazios foram enviados para a garagem.', 'success')
    end
end)

addCommandHandler('puxarveh', function(player, cmd, id)
    if not id then return end
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Staff')) then
        for i,carro in ipairs(getElementsByType('vehicle')) do 
            if getElementData(carro, 'Vehicle > ID') == tonumber(id) then 
                local x, y, z = getElementPosition(player)
                setElementPosition(carro, x, y, z)
                msg(player, 'Você puxou o veiculo '..id, 'info')
                break
            end
        end
    end
end)

addCommandHandler('id', function(player, cmd)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Staff')) then
        for i,carro in ipairs(getElementsByType('vehicle')) do 
            local x, y, z = getElementPosition(player)
            local x2, y2, z2 = getElementPosition(carro)
            if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 3 then 
                msg(player, 'ID do veiculo: '..(getElementData(carro, 'Vehicle > ID') or 'N/A'), 'info' )
            end
        end
    end
end)

addCommandHandler('imposto', function(player, cmd)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Admin')) then
        local result = dbPoll(dbQuery(db, 'SELECT * FROM vehicles'), -1)
        for i,v in ipairs(result) do 
            local result2 = dbPoll(dbQuery(db, 'SELECT * FROM taxas WHERE vehicle = ?', v.id), -1)
            if #result2 == 0 then 
                dbExec(db, 'INSERT INTO taxas VALUES (?, ?, ?)', v.id, (Config.Veiculos[v.vehicleid].preco/100*25), 0)
            else
                dbExec(db, 'UPDATE taxas SET imposto = ? WHERE vehicle = ?', result2[1].imposto+(Config.Veiculos[v.vehicleid].preco/100*25), v.id)
            end
            if result2[1].imposto+(Config.Veiculos[v.vehicleid].preco/100*25) >= (Config.Veiculos[v.vehicleid].preco/100*25)*4 then
                dbExec(db, 'DELETE FROM vehicles WHERE id = ?', v.id) 
                for k,carro in ipairs(getElementsByType('vehicle')) do 
                    if getElementData(carro, 'Vehicle > ID') == v.id then 
                        destroyElement(carro)
                        carros[v.id] = nil
                    end
                end
            end
        end
        msg(player, 'Impostos cobrados.', 'info')
    end
end)

Proposta = {}

addCommandHandler('vender', function(player, cmd, id, preco)
    if id and preco then 
        local id, preco = tonumber(id), tonumber(preco)
        local veh = getPedOccupiedVehicle(player)
        if Proposta[player] then return msg(player, 'Você já tem uma proposta pendente.', 'error') end
        if veh then 
            if preco < 0 then return end
            if getElementData(veh, 'Vehicle > ID') then 
                if getElementData(veh, 'Vehicle > Owner') == getElementData(player, 'ID') then 
                    local target = getPlayerFromID(id)
                    if target then
                        local result = dbPoll(dbQuery(db, 'SELECT * FROM vehicles WHERE owner = ?', getElementData(target, 'ID')), -1)
                        if #result < Config.maxVehicles or isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(target)), aclGetGroup(Config.aclVip)) then
                            if getElementData(target, 'proposta') then return msg(player, 'O jogador já tem uma proposta pendente.', 'error') end
                            msg(player, 'Proposta enviada.', 'success')
                            msg(target, 'Você recebeu uma proposta, olhe seu chat.', 'info')
                            outputChatBox('#9167e6[ DEALERSHIP ] #bebebeVocê deseja comprar o veiculo #9167e6'..Config.Veiculos[getElementData(veh, 'Vehicle > Index')].name..'#bebebe do jogador #9167e6'..getPlayerName(player)..'#bebebe por #9167e6$'..preco..'#bebebe? Se sim, use #9167e6/aceitar', target, 255, 255, 255, true)
                            setElementData(target, 'proposta', {veh, preco, player})
                            Proposta[player] = setTimer(function()
                                msg(target, 'Proposta expirada', 'error')
                                msg(player, 'Proposta expirada', 'error')
                                setElementData(target, 'proposta', nil)
                                Proposta[player] = nil
                            end, 60000, 1)
                        end
                    else
                        msg(player, 'Jogador inexistente.', 'error')
                    end
                else
                    msg(player, 'Esse veiculo não é seu.', 'error')
                end
            else
                msg(player, 'Esse veiculo não é seu.', 'error')
            end
        else
            msg(player, 'Você não está em nenhum veiculo.', 'error')
        end
    else
        msg(player, 'Use: /vender [id do jogador] [preco] dentro de seu veiculo', 'info')
    end
end)

addCommandHandler('aceitar', function(player)
    if getElementData(player, 'proposta') then 
        local veh, preco, target = unpack(getElementData(player, 'proposta'))
		if exports.crp_inventory:getItem(player, 'dinheiro') >= preco then
            if isPedInVehicle(target) then
                removePedFromVehicle(target)
            end
			exports.crp_inventory:giveItem(target, 'dinheiro', preco)
			exports.crp_inventory:takeItem(player, 'dinheiro', preco)
            setElementData(veh, 'Vehicle > Owner', getElementData(player, 'ID'))
            dbExec(db, 'UPDATE vehicles SET owner = ? WHERE id = ?', getElementData(player, 'ID'), getElementData(veh, 'Vehicle > ID') )
            msg(player, 'Veiculo comprado com sucesso.', 'success')
            msg(target, 'Veiculo vendido com sucesso.', 'success')
            setElementData(player, 'proposta', nil)
            killTimer(Proposta[target])
            Proposta[target] = nil
        else
            msg(player, 'Dinheiro insuficiente.', 'error')
            msg(target, 'O jogador não possui dinheiro suficiente.', 'error')
            setElementData(player, 'proposta', nil)
            killTimer(Proposta[target])
            Proposta[target] = nil
        end
    end
end)

addCommandHandler('debugvehicle', function(player, cmd, placa)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Admin')) then
        if placa then 
            local exec = dbExec(db, 'UPDATE vehicles SET position = ?, garagem = ? WHERE plate = ?', toJSON({0, 0, 0, 0}), 5, placa)
            if exec then
                for i,v in ipairs(getElementsByType('vehicle')) do 
                    if getVehiclePlateText(v) == placa then 
                        destroyElement(v)
                    end
                end
                exports.crp_notify:addBox(player, 'Veiculo de placa '..placa..' enviado para garagem 5.', 'success')
            end
        end
    end
end)

function getPlayerFromID(id)
    for i,player in ipairs(getElementsByType('player')) do 
        if getElementData(player, 'ID') == id then 
            return player
        end
    end
end