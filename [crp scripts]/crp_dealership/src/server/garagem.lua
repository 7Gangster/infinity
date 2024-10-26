local db = dbConnect('sqlite', 'src/assets/data.db')
local models = {}
local garagens = {}
local carros = {}

local sair_garagem = createMarker(1541.0349121094,3382.8190917969,5.0999999046326+100, 'cylinder', 1.2, 192, 24, 255, 45)

local vagas = {
    {1561.317, 3378.974, 4.806+100, 90},
    {1561.318, 3375.474, 4.806+100, 90},
    {1561.318, 3371.978, 4.806+100, 90},
    {1561.325, 3368.594, 4.809+100, 90},
    {1561.226, 3365.028, 4.806+100, 90},
    {1561.23, 3361.638, 4.806+100, 90},
    {1561.218, 3358.073, 4.806+100, 90},
}

addEventHandler('onMarkerHit', sair_garagem, function(player)
    if getElementType(player) == 'player' then
        local garagemid = tonumber(getElementData(player, 'Garagem > ID'))
        local x, y, z = unpack(Config.Garagens[garagemid].spawn)
        fadeCamera(player, false)
        destroyVehicles(getElementData(player, 'ID'), garagemid)
        setTimer(function()
            setElementPosition(player, x, y, z)
            setElementDimension(player, 0)
            fadeCamera(player, true)
            setElementData(player, 'Garagem > ID', nil)
            setAccountData(getPlayerAccount(player), 'last-position', nil)
        end, 1000, 1)
    end
end)

function loadGaragens ()
    for i,v in ipairs(Config.Garagens) do 

        garagens[i] = createMarker(v[1], v[2], v[3]-1, 'cylinder', 6, 0, 0, 0, 0)
        setElementData(garagens[i], 'Garagem > ID', i)

        local blip = createBlipAttachedTo(garagens[i], 53)
        setElementData(blip, 'blipName', 'Garagem')

    end
end

function GaragemLoadVehicles(player, garagemid)
    local garagemid = tostring(garagemid)
    print(getElementData(player, 'ID'))
    local result = dbPoll(dbQuery(db, 'SELECT * FROM vehicles WHERE owner = ? AND garagem = ?', getElementData(player, 'ID'), garagemid), -1)
    if #result > 0 then 

        fadeCamera(player, false)


        if not models[getElementData(player, 'ID')] then
            models[getElementData(player, 'ID')] = createObject(8832, 1552.8000488281, 3366.3999023438, 6.0999999046326+100)
            setElementDimension(models[getElementData(player, 'ID')], getElementData(player, 'ID'))
        end

        setTimer(function()
            for i,v in ipairs(result) do 
                local multa, imposto = getTaxa(v.id)
                --if (multa + imposto) <= 0 then
                    if carros[id] then
                        destroyElement(carros[id])
                    end
                        local id = tonumber(v.id)
                        local status = fromJSON(v.status)
                        local color = fromJSON(v.color)
                        local upgrades = fromJSON(v.upgrades)
                        carros[id] = createVehicle(v.model, vagas[i][1], vagas[i][2], vagas[i][3], 0, 0, vagas[i][4], v.plate)
                        setElementData(carros[id], 'Vehicle > ID', v.id)
                        setElementHealth(carros[id], status.motor)
                        setElementData(carros[id], 'Fuel', status.fuel)
                        setVehicleColor(carros[id], color[1], color[2], color[3])
                        setVehicleWheelStates(carros[id], status.pneus[1], status.pneus[2], status.pneus[3], status.pneus[4])
                        setElementDimension(carros[id], getElementData(player, 'ID'))
                        setElementFrozen(carros[id], true)
                        for i,v in ipairs(upgrades) do 
                            addVehicleUpgrade ( carros[id], v )
                        end
                        if v.livery ~= 0 then 
                            triggerClientEvent(player, 'setVehicleLivery', player, carros[id], v.model, v.livery)
                        end
                --end
            end
        end, 500, 1)

        setElementDimension(player, getElementData(player, 'ID'))
        setElementPosition(player, 1552.1057128906,3386.7358398438,5.0999999046326+100)
        setElementRotation(player, 0, 0, 180)
        setElementData(player, 'Garagem > ID', tonumber(garagemid))
        fadeCamera(player, true)

    else
        msg(player, 'Você nao possui nenhum veiculo nessa garagem.', 'error')
    end
end

function destroyVehicles(id, garagemid)
    local garagemid = tostring(garagemid)
    local result = dbPoll(dbQuery(db, 'SELECT * FROM vehicles WHERE owner = ? AND garagem = ?', id, garagemid), -1)
    if #result > 0 then 
        for i,v in ipairs(result) do 
            destroyElement(carros[v.id])
        end
    end
end

function leaveGarage(player)
    local garagem = getElementData(player, 'Garagem > ID') or false
    if garagem then 
        destroyVehicles(getElementData(player, 'ID'), garagem)
        setElementData(player, 'Garagem > ID', nil)
    end
end

function entrarGaragem(player, b, s, marker)
    GaragemLoadVehicles(player, getElementData(marker, 'Garagem > ID'))
    unbindKey(player, 'e', 'down', entrarGaragem)
end

function guardarVeiculo(player, b, s, marker)
    local garagemid = getElementData(marker, 'Garagem > ID')
    local result = dbPoll(dbQuery(db, 'SELECT * FROM vehicles WHERE owner = ? AND garagem = ?', getElementData(player, 'ID'), garagemid), -1)
    local carro = getPedOccupiedVehicle(player)
    if #result < 7 then 
        if getElementData(carro, 'Vehicle > ID') then
            if getElementData(carro, 'Vehicle > Owner') == getElementData(player, 'ID') then

                local x, y, z = getElementPosition(carro)
                local rx, ry, rz = getElementRotation(carro)
                local gas = getElementData(carro, 'Fuel')
                local color = toJSON({getVehicleColor(carro, true)})
                local position = toJSON({x, y, z, rz})
                local turbina = getElementData(carro, 'Turbina') or false
                local upgrades = getVehicleUpgrades(carro)
                local pneus = { getVehicleWheelStates(carro) }

                dbExec(db, 'UPDATE vehicles SET position = ?, garagem = ?, status = ?, color = ?, livery = ?, upgrades = ? WHERE id = ?', toJSON({0, 0, 0, 0}), tostring(garagemid), toJSON({motor = getElementHealth(carro), fuel = gas, pneus = pneus, locked = isVehicleLocked(carro), turbina = (getElementData(carro, 'Turbina') or false)}), color, (getElementData(carro, 'ZN-VehLivery') or 0), toJSON(upgrades), getElementData(carro, 'Vehicle > ID'))

                destroyElement(carro)

                msg(player, 'Veiculo guardado na garagem '..garagemid, 'success')

                setTimer(function()
                    GaragemLoadVehicles(player, garagemid)
                end, 500, 1)

            end
        end
    else
        msg(player, 'Essa garagem não tem espaço.', 'info')
    end
    unbindKey(player, 'e', 'down', guardarVeiculo)
end

addEventHandler('onMarkerHit', root, function(player)
    if getElementType(player) == 'player' then 
        if getElementData(source, 'Garagem > ID') then 
            if not isPedInVehicle(player) then 
                msg(player, 'Pressione "E" para entrar na garagem.', 'info')
                bindKey(player, 'e', 'down', entrarGaragem, source)
            else
                msg(player, 'Pressione "E" para guardar seu veiculo.', 'info')
                bindKey(player, 'e', 'down', guardarVeiculo, source)
            end
        end
    end
end)

addEventHandler('onMarkerLeave', root, function(player)
    if getElementType(player) == 'player' then 
        if getElementData(source, 'Garagem > ID') then 
            unbindKey(player, 'e', 'down', guardarVeiculo)
            unbindKey(player, 'e', 'down', entrarGaragem)
        end
    end
end)

addEventHandler('onVehicleEnter', resourceRoot, function(player)
    if getElementDimension(player) == getElementData(player, 'ID') then 
        if getElementData(player, 'Garagem > ID') then 
            local id = getElementData(source, 'Vehicle > ID')
            print(id)
            if id then
                local multa, imposto = getTaxa(id)
                if (multa + imposto) <= 0 then
                    local garagemid = tonumber(getElementData(player, 'Garagem > ID'))
                    dbExec(db, 'UPDATE vehicles SET garagem = ? WHERE id = ?', 0, id) 
                    fadeCamera(player, false)
                    setTimer(function()
                        removePedFromVehicle(player)
                        destroyElement(carros[id])
                        setElementDimension(player, 0)
                    end, 1000, 1)
                    local carro = DealerShipspawnVehicle(id, Config.Garagens[garagemid].spawn)
                    setTimer(function()
                        warpPedIntoVehicle(player, carro)
                        fadeCamera(player, true)
                    end, 1000, 1)
                    destroyVehicles(getElementData(player, 'ID'), garagemid)
                    setElementData(player, 'Garagem > ID', nil)
                    setAccountData(getPlayerAccount(player), 'last-position', nil)
                else
                    msg(player, 'Esse veiculo possui multas ou impostos pendentes.', 'error')
                end
            end
        end
    end
end)

function getTaxa(id) 
    local result = dbPoll(dbQuery(db, 'SELECT * FROM taxas WHERE vehicle = ?', id), -1)
    local multa = 0
    local imposto = 0
    if #result > 0 then 
        multa = result[1].multa 
        imposto = result[1].imposto
    end
    return multa, imposto
end

addEventHandler('onPlayerQuit', root, function()
    if getElementData(source, 'Garagem > ID') then 
        local x, y, z = Config.Garagens[tonumber(getElementData(source, 'Garagem > ID'))].spawn
        setAccountData(getPlayerAccount(source), 'last-position', toJSON({x, y, z}))
        destroyVehicles(getElementData(source, 'ID'), tonumber(getElementData(source, 'Garagem > ID')))
        if models[getElementData(source, 'ID')] then
            destroyElement(models[getElementData(source, 'ID')])
            models[getElementData(source, 'ID')] = nil 
        end
    end 
end)

addEventHandler('onPlayerLogin', root, function()
    local lastPosition = getAccountData(getPlayerAccount(source), 'last-position')
    if lastPosition then 
        setTimer(function()
            local lastPosition = fromJSON(lastPosition)
            setElementPosition(source, lastPosition[1], lastPosition[2], lastPosition[3])
            setElementDimension(source, 0)
            setElementInterior(source, 0)
        end, 5000, 1)
    end
end)


loadGaragens()