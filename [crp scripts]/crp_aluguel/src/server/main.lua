function msg(player, msg, type)
    exports.crp_notify:addBox(player, msg, type)
end

vehicle = {}

for i,v in ipairs(cfg.peds) do 
    local ped = createPed(v.model, unpack(v.position))
    setElementData(ped, 'Aluguel', v.vehicle)
    setElementData(ped, 'Spawn', v.spawn)
    setElementData(ped, 'Preco', v.price)
    print(v.vehicle)
end

addEvent('alugarVeiculo', true)
addEventHandler('alugarVeiculo', root, function  (player, element)
    local model = getElementData(element, 'Aluguel')
    local spawn =  getElementData(element, 'Spawn') 
    local price = getElementData(element, 'Preco')
    if model then 
        if getPlayerMoney(player) >= price then 
            if not vehicle[getElementData(player, 'ID')] then 

                vehicle[getElementData(player, 'ID')] = createVehicle(model, unpack(spawn))
                local carro = vehicle[getElementData(player, 'ID')]
                
                setElementData(carro, 'Vehicle > ID', 'ALUGUEL-'..getElementData(player, 'ID'))
                setElementData(carro, 'Preco', price)

                exports['crp_inventory']:giveItem(player, 'chavecarro', 1, {
                    vehicle = 'ALUGUEL-'..getElementData(player, 'ID')
                })
                msg(player, 'Veiculo alugado com sucesso.', 'success')

                takePlayerMoney(player, price)

            else
                msg(player, 'Você ja tem um veiculo alugado em rua.', 'error')
            end
        else
            msg(player, 'Dinheiro insuficiente em mão.', 'error')
        end
    end
end)

addEvent('devolverVeiculo', true)
addEventHandler('devolverVeiculo', root, function(player, element)

    if vehicle[getElementData(player, 'ID')] then 
        local carro = vehicle[getElementData(player, 'ID')]
        local x, y, z = getElementPosition(element)

        if getDistanceBetweenPoints3D(x, y, z, unpack({getElementPosition(carro)})) <= 10 then
            
            givePlayerMoney(player, (getElementData(carro, 'Preco')/2 or 0 ))

            local chave = exports['crp_inventory']:getItemFromData ( player, 'chavecarro', 'vehicle', 'ALUGUEL-'..getElementData(player, 'ID'))
            if chave then     
                exports['crp_inventory']:takeItem(player, 'chavecarro', 1, chave)
            end

            destroyElement(vehicle[getElementData(player, 'ID')])
            vehicle[getElementData(player, 'ID')] = nil

        else

            msg(player, 'O veiculo não foi encontrado.', 'error')

        end

    end

end)