function msg(player, msg, type)
	exports.crp_notify:addBox(player, msg, type)
end

local Config = exports.crp_dealership:getConfig()

local marker = exports.crp_markers:createMarker('document', Vector3{cfg.markerabrir[1], cfg.markerabrir[2], cfg.markerabrir[3]-0.9})

local db = {
	src = dbConnect('sqlite', 'src/assets/data.db'),
	conce = dbConnect('sqlite', ':crp_dealership/src/assets/data.db'),
}

dbExec(db.conce, 'CREATE TABLE IF NOT EXISTS taxas (vehicle, imposto, multa)')



addEventHandler('onMarkerHit', marker, function(player)
	if getElementType(player) == 'player' then 
		triggerClientEvent(player, 'detran >> open', player, getVehiclesTable(player))
	end
end)

Delay = {}

addEvent('detran >> rastrear', true)
addEventHandler('detran >> rastrear', root, function(player, id)
	local vehicle = false
	for i,v in ipairs(getElementsByType('vehicle')) do 
		if getElementData(v, 'Vehicle > ID') == id then 
			vehicle = v
		end
	end

	if Delay[player] then return msg(player, 'Você já está rastreando seu veiculo.', 'error') end
	if vehicle then 
		local x, y, z = getElementPosition(vehicle)
		blip = createBlipAttachedTo(vehicle, 0)
		setElementVisibleTo(blip, root, false)
		setElementVisibleTo(blip, player, true)
		msg(player, 'O seu veiculo ficara marcado por 5 minutos.', 'info')
		triggerClientEvent(player, 'criarRota', player, x, y)
		triggerClientEvent(player, 'togglePoint', player, x, y, z, 'Seu veiculo')
		Delay[player] = setTimer(function()
			destroyElement(blip)
			triggerClientEvent(player, 'togglePointF', player)
			Delay[player] = nil
		end, 60000*5, 1)
	else
		msg(player, 'O veiculo está guardado.', 'error')
	end
end)

addEvent('detran >> pagartaxa', true)
addEventHandler('detran >> pagartaxa', root, function(player, id)
	local database = db.conce 
	local result = dbPoll(dbQuery(database, 'SELECT * FROM taxas WHERE vehicle = ?', id), -1)
	if #result > 0 then 
		if (result[1].multa + result[1].imposto) > 0 then 
			local taxa = (result[1].multa + result[1].imposto)
			if exports.crp_inventory:getItem(player, 'dinheiro') >= taxa then 
				exports.crp_inventory:takeItem(player, 'dinheiro', taxa)
				dbExec(database, 'UPDATE taxas SET multa = ?, imposto = ? WHERE vehicle = ?', 0, 0, id)
				msg(player, 'Você pagou as taxas do seu veiculo.', 'success')
			else
				msg(player, 'Você não possui dinheiro suficiente', 'error')
			end
		end
	end
end)

addCommandHandler('multar', function(player, cmd, placa, valor)
	local database = db.conce 
	if isObjectInACLGroup( 'user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Policial') ) then
		if placa and valor then
			local result = dbPoll(dbQuery(database, 'SELECT * FROM vehicles WHERE plate = ?', placa), -1)
			if #result > 0 then 
				local result2 = dbPoll(dbQuery(database, 'SELECT * FROM taxas WHERE vehicle = ?', result[1].id), -1)
				if #result2 == 0 then 
					dbExec(database, 'INSERT INTO taxas VALUES (?, ?, ?)', result[1].id, 0, tonumber(valor))
				else
					dbExec(database, 'UPDATE taxas SET multa = ? WHERE vehicle = ?', result2[1].multa+tonumber(valor), result[1].id)
				end
				msg(player, 'Veiculo multado no valor de $'..valor, 'success')
			else
				msg(player, 'Veiculo não encontrado.', 'error')
			end
		else
			msg(player, 'Use /multar [placa] [valor]', 'error')
		end
	end
end)

function getVehiclesTable(player)
	local database = db.conce 
	local result = dbPoll(dbQuery(database, 'SELECT * FROM vehicles WHERE owner = ?', getElementData(player, 'ID')), -1)
	local vehicles = {}
	for i,v in ipairs(result) do
		local multa, imposto = getTaxa(v.id) 
		table.insert(vehicles, {nome=Config.Veiculos[v.vehicleid].name, multas=multa, imposto=imposto, id=v.id, placa = v.plate, garagem=v.garagem})
	end
	return vehicles
end

function getTaxa(id) 
	local database = db.conce 
	local result = dbPoll(dbQuery(database, 'SELECT * FROM taxas WHERE vehicle = ?', id), -1)
	local multa = 0
	local imposto = 0
	if #result > 0 then 
		multa = result[1].multa 
		imposto = result[1].imposto
	end
	return multa, imposto
end
