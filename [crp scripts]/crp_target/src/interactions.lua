addEvent('getInteractions', true)
addEventHandler('getInteractions', root, 
function(player, element)

    local interactions = {}
    local account = getAccountName(getPlayerAccount(player))

    if not getElementData(player, 'Agarrado') and not getElementData(player, 'Algemado') and not getElementData(player, 'Preso') and not getElementData(player, 'player >> caido') then    
        if getElementType(element) == 'player' then 
            
            table.insert(interactions, {nome = 'Fechar', execute = false, close = true}) -- Nome da função, trigger para executar( nome do evento ou false ), fechar ao clicar (true/false)
            table.insert(interactions, {nome = 'Enviar cobrança', execute = 'interaction >> opencobranca', close = true})
            table.insert(interactions, {nome = 'Revistar', execute = 'interaction >> revistar', close = true})

            if getElementData(player, 'police >> duty') then
                if not getElementData(player, 'Agarrando') then
                    table.insert(interactions, {nome = 'Agarrar', execute = 'int>Agarrar', close = true})
                end
                table.insert(interactions, {nome = 'Conduzir à viatura', execute = 'int>Prender', close = true})
            end
            
            if getElementData(player, 'paramedic >> duty') then
                if  getElementData(element, 'Deitado') then 
                    table.insert(interactions, {nome = 'Dar tratamento', execute = 'interaction >> iniciartratamento', close = true})
                end
                if getElementData(element, 'player >> caido') then 
                    table.insert(interactions, {nome = 'Reanimar', execute = 'medic >> reanimar', close = true})
                end
            end

            local grupo = getElementData(player, 'H3:Grupo')
            if grupo then
                if getElementData(player, 'H3:Grupo >> '..grupo..'*') then 
                    table.insert(interactions, {nome = 'Convidar para o grupo', execute = 'group >> convidar', close = true})
                end
            end

            local vehicle = getNearestVehicle(player, 5)
            if vehicle then 
                if not isVehicleLocked(vehicle) then 
                    if getElementData(element, 'Algemado') == true then 
                        if getElementData(player, 'police >> duty') then
                            table.insert(interactions, {nome = 'Conduzir à viatura', execute = 'interaction >> conduzir', close = true})
                        end
                    end
                end
            end


            
        elseif getElementType(element) == 'vehicle' then 

            table.insert(interactions, {nome = 'Fechar', execute = false, close = true})

            if getElementData(element, 'dealership') then 
                table.insert(interactions, {nome = 'Comprar veiculo', execute = 'dealership >> buy', close = true})
            end
            if not isVehicleLocked(element) then
                --[[if not isPedInVehicle(player) then
                    table.insert(interactions, {nome = 'Entrar na mala', execute='interaction >> entrarmala', close=true})
                end
                if getElementData(element, 'Vehicle > ID') then 
                    table.insert(interactions, {nome = 'Abrir Porta Malas', execute = 'interaction >> portamalas', close = true})
                end--]]
                if exports.crp_inventory:getItemData(player, 'chavecarro', 'vehicle') == getElementData(element, 'Vehicle > ID') then 
                    table.insert(interactions, {nome = 'Trancar veiculo', execute = 'dealership >> lock', close = true})
                end
            else
                if exports.crp_inventory:getItemData(player, 'chavecarro', 'vehicle') == getElementData(element, 'Vehicle > ID') then 
                    table.insert(interactions, {nome = 'Destrancar veiculo', execute = 'dealership >> lock', close = true})
                end
            end

            if getElementData(player, 'police >> duty') and not getElementData(element, 'dealership') then 
                table.insert(interactions, {nome = 'Ver documentos', execute = 'interaction >> doc', close = true})
            end

            if getElementData(player, 'mecanico >> duty') then 
                if isElementWithinColShape(element, coll_mecanic) or isElementWithinColShape(element, coll_mecanic2) then 
                    if getElementHealth(element) <= 800 then 
                        table.insert(interactions, {nome = 'Reparar motor', execute = 'mecanic >> repair', close= true})
                    end
                    local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates ( element )
                    if frontLeft == 1 then 
                        table.insert(interactions, {nome = 'Trocar pneu esquerdo dianteiro', execute = 'mecanic >> wheelfrontLeft', close= true})
                    end
                    if rearLeft == 1 then 
                        table.insert(interactions, {nome = 'Trocar pneu esquerdo traseiro', execute = 'mecanic >> wheelrearLeft', close= true})
                    end
                    if frontRight == 1 then 
                        table.insert(interactions, {nome = 'Trocar pneu direito dianteiro', execute = 'mecanic >> wheelfrontRight', close= true})
                    end
                    if rearRight == 1 then 
                        table.insert(interactions, {nome = 'Trocar pneu direito traseiro', execute = 'mecanic >> wheelrearRight', close= true})
                    end
                    table.insert(interactions, {nome = 'Pintar veiculo', execute = 'interaction >> paint', close= true})
                end
            end

            if getElementData(element, 'Vehicle > ID') then 
                if getElementData(element, 'Travado') then 
                    --if getElementData(player, 'H3:Grupo') == 4 then 
                        table.insert(interactions, {nome = 'Desmanchar', execute = 'dealership >> desmanchar', close= true})
                    --end
                end
            end
            if getElementData(element, 'Job') == 'Express' then
                if getElementData(player, 'JobGroup') == getElementData(element, 'JobGroup') then 
                    table.insert(interactions, {nome = 'Pegar caixa', execute = 'express >> takebox', close= true})
                end 
            elseif getElementData(element, 'Job') == 'Trashman' then
                if getElementData(player, 'JobGroup') == getElementData(element, 'JobGroup') then 
                    if getElementData(player, 'CarregandoLixo') then 
              			if isElementWithinColShape(player, getElementData(player, "Job:shape")) then 
                        	table.insert(interactions, {nome = 'Guardar lixo', execute = 'trashman >> guardarLixo', close= true})
                  		end
                    end
                end 
            end
           
        elseif getElementType(element) == 'object' then 

            if not isPedInVehicle(player) then
                if getElementModel(element) == 2942 then 

                    
                    table.insert(interactions, {nome = 'Acessar caixa eletrônico', execute = 'interaction >> openBank', close = true})

                    if not getElementData(element, 'Roubado') then 

                        if exports.crp_inventory:getItem(player, 'makita') >= 1 then
                            table.insert(interactions, {nome = 'Roubar caixinha', execute = 'interaction >> roubarcaixinha', close= true})
                        end

                    end

                elseif getElementModel(element) == 1997 then
                    table.insert(interactions, {nome = 'Deitar', execute = 'maca >> deitar', close = true})
                end

                if getElementData(element, 'CRP-Bau') then 
                    
                    table.insert(interactions, {nome = 'Abrir bau', execute = 'openBau', close= true})
                end

                if getElementModel(element) == 2332 and getElementDimension(player) ~= 0 and getElementInterior(player) ~= 0 then 
                    
                    table.insert(interactions, {nome = 'Abrir bau', execute = 'casa >> bau', close= true})
                end

				if getElementModel(element) == 1514 then 
                    table.insert(interactions, {nome = 'Fechar', execute = false, close = true})
					if getElementData(player, 'cobranca') then
                		local price, payment, target = unpack(getElementData(player, 'cobranca'))
                    	table.insert(interactions, {nome = 'Pagar pelo produto no valor de $'..price..'', execute = 'class.buyConfirm', close = true})
					end
        			if isObjectInACLGroup( "user.".. getAccountName(getPlayerAccount(player)), aclGetGroup(getElementData(element, 'ACL') or 'Admin')) then
                    	table.insert(interactions, {nome = 'Fazer cobrança', execute = 'class.showPanel', close = true})
					end
				end

                if getElementData(element, 'Bancada') then 
                    table.insert(interactions, {nome = 'Abrir bancada', execute = 'openBancada', close= true})
                end

                if getElementData(element, 'CRP.ObjectID') then 
                    table.insert(interactions, {nome = 'Remover objeto', execute = 'CRP-DestroyObject', close= true})
                    --CRP-DestroyObject
                end

                for i,v in ipairs({1227, 1331, 1332, 1333, 1334, 1335, 1336, 1337, 1439, 1372, 1415, 1326, 1365, 910, 1359, 1344}) do 
                    if getElementModel(element) == v then 
                        
                        table.insert(interactions, {nome = 'Vasculhar lixeira', execute = 'interaction >> vasculhar', close= true})

                        if getElementData(player, 'InService') == 'Trashman' then 

                            table.insert(interactions, {nome = 'Coletar lixo', execute = 'trashman >> pegarLixo', close= true})

                        end

                    end
                end
            end

        elseif getElementType(element) == 'ped' then
            if getElementData(element, 'Aluguel') then 
                table.insert(interactions, {nome = 'Alugar veiculo por $'..(getElementData(element, 'Preco') or 0), execute = 'alugarVeiculo', close= true})
                table.insert(interactions, {nome = 'Devolver veiculo', execute = 'devolverVeiculo', close= true})
            end
            if getElementData(element, 'mission') then 
                
                table.insert(interactions, {nome = 'Iniciar missão', execute = 'startMission', close= true})
            elseif getElementData(element, 'transportadora') then 
                
                if not getElementData(player, 'transportadora >> working') then
                    table.insert(interactions, {nome = 'Iniciar serviço', execute = 'transportadora >> startService', close= true})
                else
                    table.insert(interactions, {nome = 'Finalizar serviço', execute = 'transportadora >> startService', close= true})
                end
            end
            if getElementData(element, 'pescador') then 
                
                if getElementData(element, 'pescador >> iniciarservico') then 
                    if not getElementData(player, 'pescador') then
                        table.insert(interactions, {nome = 'Iniciar serviço', execute = 'pescador >> iniciarservico', close= true})
                    else
                        table.insert(interactions, {nome = 'Finalizar serviço', execute = 'pescador >> iniciarservico', close= true})
                    end
                end
            end
            if not isPedInVehicle(player) then
                if getElementData(element, 'ped:state') then 
                    table.insert(interactions, {nome = 'Oferecer produtos ilicitos', execute = 'interaction >> selldrug', close= true})
                elseif getElementData(element, 'evento > halloween') then 
                    table.insert(interactions, {nome = 'Iniciar evento', execute = 'halloween > iniciarEvento', close= true})
                elseif getElementData(element, "shop") then 
                    table.insert(interactions, {nome = 'Abrir loja', execute = 'openShop', close= true})
                end


			if getElementData(element, 'mission') then 
                
                table.insert(interactions, {nome = 'Iniciar missão', execute = 'startMission', close= true})
            elseif getElementData(element, 'trashman') then 
                
                if not getElementData(player, 'trashman >> working') then
                    table.insert(interactions, {nome = 'Iniciar serviço', execute = 'transportadora >> startService', close= true})
                else
                    table.insert(interactions, {nome = 'Finalizar serviço', execute = 'transportadora >> startService', close= true})
                end
            end



                local job = getElementData(element, 'Job')
                if job then 
                    if not getElementData(player, 'Job') then 
                        table.insert(interactions, {nome = 'Pedir emprego', execute = 'jobmaanger >> takejob', close= true})
                    elseif getElementData(player, 'Job') == job then 
                        table.insert(interactions, {nome = 'Pedir demissão', execute = 'jobmaanger >> takejob', close= true})
                        table.insert(interactions, {nome = 'Receber salario', execute = 'jobmanager >> salario', close= true})
                        if getElementData(player, 'Job') == 'Express' then 
                            if getElementData(player, 'InService') then 
                                table.insert(interactions, {nome = 'Solicitar veiculo', execute = 'express >> takevehicle', close= true})
                            end
                        elseif getElementData(player, 'Job') == 'Los Santos Sanitary' or getElementData(player, 'Job') == 'Lixeiro' then 
                            if getElementData(player, 'InService') then 
                                table.insert(interactions, {nome = 'Solicitar veiculo', execute = 'trashman >> getVehicle', close= true})
                            end
                        end
                    end
                end

                if getElementData(element, 'bank') then 
                    
                    table.insert(interactions, {nome = 'Acessar banco', execute = 'interaction >> openBank', close = true})
                    if #exports.crp_bank:getAccounts(player) == 0 then 
                        table.insert(interactions, {nome = 'Criar conta', execute = 'interaction >> createAccount', close = true})
                    end
                end
            end
        end
    end

    if interactions then
        triggerClientEvent(player, 'updateInteractions', player, interactions)
    end

end)

function getItem(player, item)
    return (exports['crp_inventory']:getItem(player, item) or 0)
end

function giveItem(player, item, qtd, data)
    if exports['crp_inventory']:giveItem(player, item, qtd, data or {}) then 
        return true
    end
    return false
end

function takeItem(player, item, qtd, data)
    if exports['crp_inventory']:takeItem(player, item, qtd, data or false) then 
        return true
    end
    return false
end 

function getNearestVehicle(player, distance)
    local vehicle = false 
    for i,v in ipairs(getElementsByType('vehicle')) do 
        if getDistanceElements(player, v) <= distance then 
            vehicle = v
        end
    end
    return vehicle
end

getDistanceElements = function(element, elementTarget)
    local x, y, z = getElementPosition(element)
    local x2, y2, z2 = getElementPosition(elementTarget)
    local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
    return distance
end

function msg(player, msg, type)
    exports.crp_notify:addBox(player, msg, type)
end