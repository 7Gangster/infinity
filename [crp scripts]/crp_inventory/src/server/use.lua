delay = {}
object = {}


function useItem  (player, item, qtd, data)
    if not delay[player] then 
        if getItemHealth ( player, item, data.id ) <= 10 then return end 
        if getItem(player, item) < (qtd or 1) then return end 
        -- << COMIDAS E BEBIDA >>
        if cfg.items[item].type == 'bebida' then 
            local obj = createBoneObject(player, item)
            local tempo = math.random(7500, 20000)
            setPedAnimation(player, "vending", "vend_drink2_p", 0, true, true, true)
            setTimer(setPedAnimationProgress, 100, 1, player, "vend_drink2_p", 1.16)
            setTimer(setPedAnimationSpeed, tempo, 1, player, "vend_drink2_p", 0)    
            triggerClientEvent(player, 'ProgressBar', player, tempo)
            for _, v in ipairs({'fire', 'action', 'crouch', 'jump', 'enter_exit', 'aim_weapon'}) do 
                toggleControl(player, v, false)
            end
            takeItem(player, item, 1, data.id)
            delay[player] = setTimer(function ( )
                local sede = getElementData(player, 'sede') or 0
                if sede + (cfg.alimentos[item] or 5) <= 100 then 
                    setElementData(player, 'sede', sede + (cfg.alimentos[item] or 5) )
                else
                    setElementData(player, 'sede', 100)
                end
                if obj then
                    destroyElement(obj)
                end
                for _, v in ipairs({'fire', 'action', 'crouch', 'jump', 'enter_exit', 'aim_weapon'}) do 
                    toggleControl(player, v, true)
                end
                setPedAnimation(player)
                triggerClientEvent(player, 'notifyItem', player, item, 1, 'Bebeu')
                if item == 'agua' then 
                    giveItem(player, 'garrafavazia', 1)
                end
                delay[player] = nil
            end, tempo, 1) 
        elseif cfg.items[item].type == 'comida' then 
            if getItemHealth ( player, item, data.id ) <= 30 then return msg(player, 'A comida esta estragada.', 'error', 'Xii..') end
            local obj = createBoneObject(player, item)
            local tempo = math.random(7500, 20000)
            setPedAnimation(player, "food", "eat_burger", 0, true, true, true)
            setTimer(setPedAnimationProgress, 100, 1, player, "eat_burger", 1.16)
            setTimer(setPedAnimationSpeed, tempo, 1, player, "eat_burger", 0) 
            triggerClientEvent(player, 'ProgressBar', player, tempo)
            for _, v in ipairs({'fire', 'action', 'crouch', 'jump', 'enter_exit', 'aim_weapon'}) do 
                toggleControl(player, v, false)
            end
            takeItem(player, item, 1, data.id)
            delay[player] = setTimer(function ( )
                local fome = getElementData(player, 'fome') or 0
                if fome + (cfg.alimentos[item] or 5) <= 100 then 
                    setElementData(player, 'fome', fome + (cfg.alimentos[item] or 5) )
                else
                    setElementData(player, 'fome', 100)
                end
                if obj then
                    destroyElement(obj)
                end
                for _, v in ipairs({'fire', 'action', 'crouch', 'jump', 'enter_exit', 'aim_weapon'}) do 
                    toggleControl(player, v, true)
                end
                setPedAnimation(player)
                triggerClientEvent(player, 'notifyItem', player, item, 1, 'Comeu')
                delay[player] = nil
            end, tempo, 1) 
            if (getElementData(player, 'Stress') or 0) - 8 > 0 then 
                setElementData(player, 'Stress', (getElementData(player, 'Stress') or 0) -8)
            else
                setElementData(player, 'Stress', 0)
            end
        end

        -- << ROUPAS >>
        if cfg.items[item].arg then 
            setPedAnimation(player, 'CLOTHES', 'CLO_Pose_Torso', 2000, true, true, false, false)
            local type = cfg.items[item].arg 
            local stylo = cfg.items[item].style 
            local text = cfg.items[item].text 
            if type == 'mascara' then
                if not getElementData(player, "ZN-ComMáscara") then
                    colocarmascara(player, item)
                else
                    tirarmascara(player)
                end
                exports.agatreix_custom:setroupa(player, getElementModel(player), 'bone', '0', '0')
            else
                if getElementData(player, type..':Style') == stylo and getElementData(player, type..':Text') == text then
                    exports.agatreix_custom:setroupa(player, getElementModel(player), type, '0', '0')
                    setElementData(player, type..':Style', 0)
                    setElementData(player, type..':Text', 0)
                else
                    exports.agatreix_custom:setroupa(player, getElementModel(player), type, stylo, text)
                    setElementData(player, type..':Style', stylo)
                    setElementData(player, type..':Text', text)
                end
            end
        end

        if cfg.items[item].type == 'weapon' then 
            if cfg.items[item].muni then
                local municao = cfg.items[item].muni
                if getElementData(player, "Arma-Equipada") == false then
                    if getElementData(player, ""..item.."-Equipada") == true then
                        exports.crp_weapons:ZNEquiparArma(player, item)
                        triggerClientEvent(player, 'notifyItem', player, item, 1, 'Equipou')
                    else
                        exports.crp_weapons:ZNEquiparArma(player, item)
                        triggerClientEvent(player, 'notifyItem', player, item, 1, 'Equipou')
                        if getItem(player, municao) >= 1 then
                            local ammo = tonumber(getItem(player, municao)) or 0
                            takeItem(player, municao, getItem(player, municao))
                            triggerClientEvent(player, 'notifyItem', player, municao, ammo, 'Usou')
                        end
                    end
                    updateItemHealth(player, item, getItemHealth ( player, item, data.id )-0.1, data.id)
                    if getItemHealth ( player, item, data.id ) <= 0 then 
                        exports.crp_weapons:ZNGuardarArma(player)
                        triggerClientEvent(player, 'notifyItem', player, item, 1, 'Quebrou')
                    end
                else
                    if getElementData(player, ""..item.."-Equipada") == true then
                        exports.crp_weapons:ZNGuardarArma(player)
                        triggerClientEvent(player, 'notifyItem', player, item, 1, 'Guardou')
                    end
                end
            else
               if getElementData(player, "Arma-Equipada") == false then
                    if getElementData(player, ""..item.."-Equipada") == true then
                        exports.crp_weapons:ZNEquiparArma(player, item)
                        triggerClientEvent(player, 'notifyItem', player, item, 1, 'Equipou')
                    else
                        exports.crp_weapons:ZNEquiparArma(player, item)
                        triggerClientEvent(player, 'notifyItem', player, item, 1, 'Equipou')
                    end
                    updateItemHealth(player, item, getItemHealth ( player, item, data.id )-0.1, data.id)
                    if getItemHealth ( player, item, data.id ) <= 0 then 
                        exports.crp_weapons:ZNGuardarArma(player)
                        triggerClientEvent(player, 'notifyItem', player, item, 1, 'Quebrou')
                    end
                else
                    if getElementData(player, ""..item.."-Equipada") == true then
                        exports.crp_weapons:ZNGuardarArma(player)
                        triggerClientEvent(player, 'notifyItem', player, item, 1, 'Guardou')
                    end
                end
            end
            delay[player] = setTimer(function()
                delay[player] = nil
            end, 3000, 1)
        end
 
        -- << ITEMS >>
        if item == 'garrafavazia' then
            local object = false
            for i,v in ipairs(getElementsByType('object')) do 
                if getElementModel(v) == 1808 then 
                    local x, y, z = getElementPosition(player)
                    local x2, y2, z2 = getElementPosition(v)
                    if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 2 then 
                        object = v
                    end
                end
            end

            if object then
                if getElementModel(object) == 1808 then 
                    takeItem(player, 'garrafavazia', 1, data.id)
                    triggerClientEvent(player, 'fecharInventario', player)
                    triggerClientEvent(player, 'ProgressBar', player, 5000)
                    setPedAnimation(player, "int_shop", "shop_loop")
                    delay[player] = setTimer(function()
                        delay[player] = nil
                        giveItem(player, 'agua', 1)
                        setPedAnimation(player)
                    end, 5000, 1)
                else
                    msg(player, 'Nenhum bebedor por perto.', 'error')
                end 
            else
                msg(player, 'Nenhum bebedor por perto.', 'error')
            end
        elseif item == 'adrenalina' then 
            local element = getNearestPlayer ( player, 3 )
            if element then

                if getElementData(element, 'player >> caido') then
                    takeItem(player, item, 1)
                    setPedAnimation(player, 'MEDIC', 'CPR', -1, false, true, false)
                    setTimer(function()
                        exports.crp_medic:save(element)
                        setElementHealth(element, 1)
                    end, 6000, 1)
                end

            end
        elseif item == 'desfibrilador' then 
            local element = getNearestPlayer ( player, 3 )
            if element then

                if getElementData(element, 'player >> caido') and getElementData(player, 'paramedic >> duty') then
                    setPedAnimation(player, 'MEDIC', 'CPR', -1, false, true, false)
                    setTimer(function()
                        exports.crp_medic:save(element)
                        setElementHealth(element, 1)
                    end, 6000, 1)
                end

            end
        elseif item == 'cbpacote' then 
            --[[
            takeItem(player, item, 1)
            setTimer(giveItem, 100, 1, player, 'cbnuggets', 1)
            setTimer(giveItem, 500, 1, player, 'cbfritas', 1)
            setTimer(giveItem, 1000, 1, player, 'cbcebola', 1)
            setTimer(giveItem, 1500, 1, player, 'cbrefri', 1)]]
            openBau ( player, data.id, 5, false, {
                name = 'Sacola',
                slots = 5,
            })
        elseif item == 'caixacigarro' then 
            takeItem(player, item, 1)
            setTimer(giveItem, 1000, 1, player, 'cigarro', 10)
        elseif item  == 'hbox' then 
            triggerEvent('JOAO.openMysteryBox', player, player, item)
        elseif item == 'gasolina' then 
            local veh = getNearestVehicle (player, 3)
            if veh then 
                if getVehicleEngineState(veh) == false then 
                    if not isPedInVehicle(player) then 
                        triggerClientEvent(player, "ProgressBar", player, 15000)
                        exports.crp_notify:addBox(player, 'Enchendo tanque ...', 'info')

                        setPedAnimation(player, "CASINO", "Slot_Plyr")
                        triggerClientEvent(player, 'fecharInventario', player)
                        setTimer(function()
                            setElementData(veh, 'Fuel', 100)
                            takeItem(player, item, 1, data.id)

                            setPedAnimation(player, "rapping", "laugh_01", -1, true, false, false)
                            setTimer(setPedAnimation, 50, 1, player, nil)

                        end, 15000, 1)
                    else
                        exports.crp_notify:addBox(player, 'Saia do veiculo.', 'warning')
                    end
                else
                    exports.crp_notify:addBox(player, 'Desligue o motor do veiculo.', 'warning')
                end
            end
        elseif item == 'turbina' then 
            local veh = getNearestVehicle (player, 3)
            local ply = player
            if veh then
                if not getElementData(veh, 'Turbina') then
                    if not isVehicleBlown(veh) and not getPedOccupiedVehicle(ply) then
                        --local tveh = exports.zn_mecanica:zngettabelaveh()
                        --if tveh[getElementModel(veh)].motor == "motora" then
                            --if tonumber(getmecanicoon()) == 0 then
                                triggerClientEvent(ply, "ProgressBar", ply, 15000)

                                setPedAnimation(ply, "cop_ambient", "copbrowse_loop")

                                timerusando[ply] = setTimer(function()
                                    setElementData(veh, 'Turbina', true)
                                    exports.crp_items:takeItem(ply, item, 1)

                                    setPedAnimation(ply, "rapping", "laugh_01", -1, true, false, false)
                                    setTimer(setPedAnimation, 50, 1, ply, nil)

                                end, 15000, 1)
                            --end
                        --
                    end
                else
                    exports.crp_notify:addBox(ply, 'O veiculo já possui turbina.', 'error')
                end
            end
        elseif item == 'kitreparo' then 
            local veh = getNearetVehicle(player, 3)
            local ply = player
            if veh then
                if not isVehicleBlown(veh) and not getPedOccupiedVehicle(ply) then
                    --local tveh = exports.zn_mecanica:zngettabelaveh()
                    --if tveh[getElementModel(veh)].motor == "motora" then
                        if tonumber(getmecanicoon()) == 0 then
                            triggerClientEvent(ply, "ProgressBar", ply, 15000)

                            setPedAnimation(ply, "cop_ambient", "copbrowse_loop")

                            timerusando[ply] = setTimer(function()
                                setElementHealth(veh, getElementHealth(veh) + 300)
                                exports.crp_items:takeItem(ply, item, 1)

                                setPedAnimation(ply, "rapping", "laugh_01", -1, true, false, false)
                                setTimer(setPedAnimation, 50, 1, ply, nil)

                            end, 15000, 1)
                        end
                    --
                end
            end
        elseif item == 'radio' then 
            triggerClientEvent(player, 'fecharInventario', player)
            triggerClientEvent(player, "class:openCommunicator", player)
        elseif item == 'seda' then 
            if getItem(player, 'maconha') >= 1 then 
                takeItem(player, 'maconha', 1)
                takeItem(player, 'seda', 1)
                setTimer(function()
                    giveItem(player, 'baseado', 1)
                end, 1000, 1)
            end
        elseif item == 'lockpick' then 
            if not isPedInVehicle(player) then 
                local vehicle = getNearestVehicle(player, 3)
                if vehicle then 
                    if getItemHealth( player, 'lockpick', data.id) > 0 then
                        if isVehicleLocked(vehicle) then
                            setPedAnimation(player, "INT_HOUSE", "wash_up")
                            toggleAllControls(player, false, true, false)
                            updateItemHealth( player, 'lockpick', getItemHealth( player, 'lockpick', data.id) -10, data.id)
                            triggerClientEvent(player, 'class:startMinigame', player, 'class:unlockByLockPick', vehicle, {2, 5, 6})
                            triggerClientEvent(player, 'fecharInventario', player)

                        else
                            exports.crp_notify:addBox(player, 'O veiculo já está aberto.', 'info')
                        end
                    end
                end
            else
                local vehicle = getPedOccupiedVehicle(player)
                if not getVehicleEngineState(vehicle) then 
                    toggleAllControls(player, false, true, false)
                    triggerClientEvent(player, 'class:startMinigame', player, 'class:startVehicle', vehicle, {2, 5, 6})
                    triggerClientEvent(player, 'fecharInventario', player)
                    updateItemHealth( player, 'lockpick', getItemHealth( player, 'lockpick', data.id) -10, data.id)
                end
            end
        elseif item == 'mochila' then 
            if (getElementData(player, 'CRP.PesoMax') or 0) < cfg.pesoMax then 
                setElementData(player, 'CRP.PesoMax', (getElementData(player, 'CRP.PesoMax') or 0) +10)
                triggerClientEvent(player, 'notifyItem', player, item, 1, 'Equipou')
                takeItem(player, item, 1, data.id)
            else
                msg(player, 'Você já bateu o limite de peso.', 'error')
            end
        elseif item == 'tablet' then 
            triggerClientEvent(player, 'openTablet', player)
        elseif item == 'laptop' then 
            triggerClientEvent(player, 'openLaptop', player)
        elseif item == 'identidade' then 
            triggerClientEvent(player, 'class.openIdentify', player, {
                nome = string.gsub(data.owner, ' ', '_') or 'Desconhecido_Desconhecido',
                rg = data.rg,
            })
        end

        if not cfg.items[item].type == 'weapon' then
            triggerClientEvent(player, 'notifyItem', player, item, qtd, 'Usou')
        end

    end
end
addEvent('useItem', true)
addEventHandler('useItem', root, useItem)

function unlockByLockpick(target, type, theElement)
    if type == "success" then
	    setVehicleLocked(theElement, false)
        setTimer(setVehicleOverrideLights, 100, 2, theElement, 2)
        setTimer(setVehicleOverrideLights, 300, 2, theElement, 1)
    elseif type == "fail" then
    end
    toggleAllControls(target, true)
    setPedAnimation(target)
end
addEvent("class:unlockByLockPick", true)
addEventHandler("class:unlockByLockPick", root, unlockByLockpick)

function startVehicle(target, type, theElement)
    if type == "success" then
	    setVehicleEngineState(theElement, true)
        setTimer(setVehicleOverrideLights, 100, 2, theElement, 2)
        setTimer(setVehicleOverrideLights, 300, 2, theElement, 1)
    elseif type == "fail" then
    end
    toggleAllControls(target, true)
    setPedAnimation(target)
end
addEvent("class:startVehicle", true)
addEventHandler("class:startVehicle", root, startVehicle)

function createBoneObject(player, item)
    if cfg.objects[item] then 
        local assets = cfg.objects[item]
        if object[player] and isElement(object[player]) then 
            destroyElement(object[player])
            object[player] = nil
        end 
        local x, y, z = getElementPosition(player)
        object[player] = createObject(assets.model, x, y, z)
        setElementCollisionsEnabled(object[player], false)
        if assets.scale then
            setObjectScale(object[player], assets.scale)
        end
        exports['pAttach']:attach(object[player], player, assets.bone, unpack(assets.position))
        return object[player]
    end
end

function getNearestPlayer ( player, distance )
    local element = false
    for i,v in ipairs(getElementsByType('player')) do 
        if v ~= player then
            local x, y, z = getElementPosition(player)
            local x2, y2, z2 = getElementPosition(v)
            if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= distance then 
                element = v
            end
        end
    end
    return element
end

function getNearestVehicle ( player, distance )
    local element = false
    for i,v in ipairs(getElementsByType('vehicle')) do 
        local x, y, z = getElementPosition(player)
        local x2, y2, z2 = getElementPosition(v)
        if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= distance then 
            element = v
        end
    end
    return element
end