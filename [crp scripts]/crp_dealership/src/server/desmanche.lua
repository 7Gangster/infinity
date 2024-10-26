local db = dbConnect('sqlite', 'src/assets/data.db')

local desmanche = {}
local travado = {}
local desmanchando = {}

for i,v in ipairs(Config.Desmanche.Markers) do 
	desmanche[i] = exports['crp_markers']:createMarker('desmanche', Vector3 {v[1], v[2], v[3]-0.9})
end

addEventHandler('onMarkerHit', root, function(player)
	if getElementType(player) == 'player' then
		for i,v in ipairs(desmanche) do
			if source == v then
				local vehicle = getPedOccupiedVehicle(player) 
				if vehicle then 
					msg(player, 'Pressione "E" para travar o veiculo.', 'info')
					bindKey(player, 'e', 'down', travarCarro, source)
				end
			end
		end
	end
end)

addEventHandler('onMarkerLeave', root, function(player)
	if getElementType(player) == 'player' then
		for i,v in ipairs(desmanche) do
			if source == v then
				unbindKey(player, 'e', 'down', travarCarro)
			end
		end
	end
end)

function travarCarro (player, b, s, marker)
	local vehicle = getPedOccupiedVehicle(player) 
	if vehicle then 
		if isElementWithinMarker( vehicle, marker ) then 
			if not travado[vehicle] then
				setElementFrozen(vehicle, true)
				travado[vehicle] = true
				setElementData(vehicle, 'Travado', true)
				msg(player, 'Veiculo travado. Saia do veiculo e interaja com ele para iniciar o desmanche.', 'success')
			else
				travado[vehicle] = false
				setElementFrozen(vehicle, false)
				setElementData(vehicle, 'Travado', false)
				msg(player, 'Veiculo destravado.', 'success')
			end
		end
	end
end

addEvent('dealership >> desmanchar', true)
addEventHandler('dealership >> desmanchar', root, function(player, element)
	if travado[element] then 
		if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Vagos')) then
			local id, index = getElementData(element, 'Vehicle > ID'), getElementData(element, 'Vehicle > Index')
			if id then 
				local preco = Config.Veiculos[index].preco
				local porcentagem = Config.Desmanche.Porcentagem
				local valor = preco/100*porcentagem
				local novovalor = preco-valor
				msg(player, 'Desmanche iniciado. Aguarde 2 minutos', 'success')
				triggerClientEvent(player, 'ProgressBar', player, 60000*2)
				setVehicleLocked(element, true)
				setElementFrozen(player, true)
				setPedAnimation(player, 'BOMBER', 'BOM_Plant', 60000*2, true, true, false)
				setTimer(function()
					setElementFrozen(player, false)
					travado[element] = false
					setElementData(element, 'Travado', false)
					local x, y, z = getElementPosition(element)
					local rx, ry, rz = getElementRotation(element)
					local gas = getElementData(element, 'Fuel')
					local color = toJSON({getVehicleColor(element, true)})
					local position = toJSON({x, y, z, rz})
					local pneus = { getVehicleWheelStates(element) }

					dbExec(db, 'UPDATE vehicles SET position = ?, garagem = ?, status = ?, color = ?, livery = ? WHERE id = ?', toJSON({0, 0, 0, 0}), '5', toJSON({motor = 350, fuel = gas, pneus = pneus, locked = isVehicleLocked(element)}), color, (getElementData(element, 'ZN-VehLivery') or 0), id)

					local result2 = dbPoll(dbQuery(db, 'SELECT * FROM taxas WHERE vehicle = ?', id), -1)
					if #result2 == 0 then 
						dbExec(db, 'INSERT INTO taxas VALUES (?, ?, ?)', id, 0, novovalor)
					else
						dbExec(db, 'UPDATE taxas SET multa = ? WHERE vehicle = ?', result2[1].multa+novovalor, id)
					end

					destroyElement(element)

    				exports.crp_inventory:giveItem(player, 'dinheiro', novovalor)

					msg(player, 'Voce desmanchou um '..Config.Veiculos[index].name..' e ganhou R$'..novovalor, 'success')
				end, 60000*2, 1)
			end
		end
	end
end)