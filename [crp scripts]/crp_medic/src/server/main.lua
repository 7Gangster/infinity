--[[
verify_health = function (player)
    if not isGuestAccount(getPlayerAccount(player)) and getElementData(player, 'Logado') == true then 
        if getElementHealth(player) <= 20 and getElementHealth(player) > 0 then 
            if not getElementData(player, 'player >> caido') then
                triggerClientEvent(player, 'medic >> open', player)
                setElementData(player, 'player >> caido', true)
                setPedAnimation(player, 'CRACK', 'crckidle2', -1, true, true, false, false)
            end
        end
    end
end

setTimer(function()
    for i,v in ipairs(getElementsByType('player')) do 
        verify_health (v)
    end
end, 1000, 0)


addEventHandler('onPlayerWasted', root, function()
    if not getElementData(source, 'player >> caido') then 
        cancelEvent()
    else
        setElementData(source, 'player >> caido', false)
    end
end)

addEvent('medic >> reanimar', true)
addEventHandler('medic >> reanimar', root, function(player, element)
    if not isGuestAccount(getPlayerAccount(player)) then
        if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Paramedic')) then 
            if getElementData(element, 'player >> caido') then 
                setPedAnimation(player, 'MEDIC', 'CPR', -1, false, true, false)
                setTimer(function()
                    setElementHealth(element, 35)
                    setPedAnimation(player)
                    triggerClientEvent(element, 'medic >> open', element)
                    setPedAnimation(element)
                    setElementData(element, 'player >> caido', nil)
                end, 6000, 1)
            end
        end
    end
end)

addCommandHandler('god', function(player, cmd, id)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Staff')) then
        local id = tonumber(id) or getElementData(player, 'ID')
        for i,v in ipairs(getElementsByType('player')) do 
            if getElementData(v, 'ID') == id then 
                if getElementData(v, 'player >> caido') then
                    setElementHealth(v, 100)
                    triggerClientEvent(v, 'medic >> open', v)
                    setPedAnimation(v)
                    messageBox(v, 'Você foi reanimado.', 'success')
                    messageBox(player, 'Você reanimou o jogador '..getPlayerName(v), 'success')
                elseif getElementHealth(v) < 100 and getElementHealth(v) > 10 then 
                    setElementHealth(v, 100)
                    messageBox(v, 'Você recebeu um tratamento.', 'success')
                    messageBox(player, 'Você tratou o jogador '..getPlayerName(v), 'success')
                else
                    messageBox(player, 'O jogador não precisa de tratamento.', 'error')
                end
                setElementData(v, 'fome', 100)
                setElementData(v, 'sede', 100)
            end
        end
    end
end)

addEventHandler('onPlayerLogin', root, function()
    setTimer(function(player)
        if player then
            setElementData(player, 'Logado', true)
            verify_health(player)
        end
    end, 5000, 1, source)
end)

function onStealthKill(targetPlayer)
    cancelEvent() 
end
addEventHandler("onPlayerStealthKill", root, onStealthKill)

for i, player in ipairs(getElementsByType('player')) do 
    if not isGuestAccount(getPlayerAccount(player)) then 
        setElementData(player, 'Logado', true)
    end
end]]


function kill (player)
    if not isGuestAccount(getPlayerAccount(player)) then 
        if not getElementData(player, 'player >> caido') then
            local x, y, z = getElementPosition(player)
            triggerClientEvent(player, 'medic >> open', player)
            setElementData(player, 'player >> caido', true)
            setElementData(player, 'Sangrando', false)
            setCameraMatrix(player, x, y, z +5, x, y, z)
            setTimer(function()
                setPedAnimation(player, 'CRACK', 'crckidle2', -1, true, true, false, false)
            end, 5000, 1)
        end
    end
end

function save (player)
    if not isGuestAccount(getPlayerAccount(player)) then 
        if getElementData(player, 'player >> caido') then
            local x, y, z = getElementPosition(player)
            triggerClientEvent(player, 'medic >> open', player)
            spawnPlayer(player, x, y, z, 0, getElementModel(player), getElementInterior(player), getElementDimension(player))
            setPedAnimation(player)
            setCameraTarget(player)
        end
    end
end

addEventHandler('onPlayerWasted', root, function()
    kill(source)
end)

addEvent('medic >> reanimar', true)
addEventHandler('medic >> reanimar', root, function(player, element)
    if not isGuestAccount(getPlayerAccount(player)) then
        if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Paramedic')) then 
            if getElementData(element, 'player >> caido') then 
                setPedAnimation(player, 'MEDIC', 'CPR', -1, false, true, false)
                setTimer(function()
                    save(element)
                    setElementHealth(element, 1)
                end, 6000, 1)
            end
        end
    end
end)

addCommandHandler('god', function(player, cmd, id)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Staff')) then
        local id = tonumber(id) or getElementData(player, 'ID')
        for i,v in ipairs(getElementsByType('player')) do 
            if getElementData(v, 'ID') == id then 
                if getElementData(v, 'player >> caido') then
                    save(v)
                    setElementHealth(v, 100)
                    messageBox(v, 'Você foi reanimado.', 'success')
                    messageBox(player, 'Você reanimou o jogador '..getPlayerName(v), 'success')
                elseif getElementHealth(v) < 100 and getElementHealth(v) > 10 then 
                    setElementHealth(v, 100)
                    messageBox(v, 'Você recebeu um tratamento.', 'success')
                    messageBox(player, 'Você tratou o jogador '..getPlayerName(v), 'success')
                else
                    messageBox(player, 'O jogador não precisa de tratamento.', 'error')
                end
                setElementData(v, 'Sangrando', false)
                setElementData(v, 'fome', 100)
                setElementData(v, 'Stress', 0)
                setElementData(v, 'sede', 100)
            end
        end
    end
end)

function spawn (player)
    
    fadeCamera (player, false)
    setPlayerMoney(player, 0)
    if not getElementData(player, 'Preso') then
        setTimer(spawnPlayer, 2000, 1, player, 1259.2065429688,-1741.6689453125,13.609375, 0, getElementModel(player))
    else
        setTimer(spawnPlayer, 2000, 1, player, 1582.7325439453,-1650.8240966797,12.6875, 0, getElementModel(player))
    end
    setElementData(player, 'fome', 100)
    setElementData(player, 'Stress', 0)
    setElementData(player, 'sede', 100)
    setElementData(player, 'player >> caido', false)
    setCameraTarget(player)
    exports.crp_inventory:takeAllItems(player)
    exports.agatreix_custom:resetRoupas(player)
    exports.crp_dealership:leaveGarage(player)
    exports.crp_weapons:desequiparArma(player, getElementData(player, 'Arma-Equipada'), true)
    setTimer(fadeCamera, 5000, 1, player, true)
end
addEvent('medic >> spawn', true)
addEventHandler('medic >> spawn', root, spawn)

function onStealthKill(targetPlayer)
    cancelEvent() 
end
addEventHandler("onPlayerStealthKill", root, onStealthKill)

addEventHandler('onPlayerDamage', root, function(attacker, weapon, bodypart, loss)
    if weapon == 23 then cancelEvent() return end
    if weapon == 9 then cancelEvent() return end
    if getElementData(source, 'player >> caido') then 
        cancelEvent()
    end
    if ( bodypart == 9 and attacker and attacker ~= source ) then 
        setElementHealth(source, 0)
    end
    if loss >= 20 then 
        local chance = math.random(1, 2)
        if chance == 2 then 
            setElementData(source, 'Sangrando', true)
        end
    end
end)

setTimer(function()
    for i,v in ipairs(getElementsByType('player')) do 
        if getElementData(v, 'Sangrando') then 
            setElementHealth(v, getElementHealth(v)-1)
            exports.crp_notify:addBox(v, 'Você está sangrando. Vá ao hospital imediatamente.', 'error')
            local x, y, z = getElementPosition(v)
            triggerClientEvent(root, 'createBlood', root, v, x, y, z, 0)
        end
    end
end, 60000, 0)