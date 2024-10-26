function tabletMessage(player, msg)
    triggerClientEvent(player, 'jobmanager >> notify', player, {
        nome = 'PESCADOR',
        color = 'FFBF00',
        msg = msg,
        img = 'src/assets/notify/jobcenter.png',
    })
end

local peixe = {}

local ped = createPed(161, cfg.iniciarservico[1], cfg.iniciarservico[2], cfg.iniciarservico[3], cfg.iniciarservico[4])
setTimer ( function()
setPedAnimation(ped, "ped", "SEAT_idle", -1, true, false, false, false)
end, 1000, 1)
setElementData(ped, 'pescador >> iniciarservico', true)
setElementData(ped, 'InService', true)

for i,v in ipairs(cfg.zonas) do 
    createBlip(v[1], v[2], v[3], 17)
end

local metas = {10, 13, 15, 18, 21}
local metasValor = {
    [10] = 1000,
    [13] = 1300,
    [15] = 1500,
    [18] = 1800,
    [21] = 2100,
}

addEvent('pescador >> iniciarservico', true)
addEventHandler('pescador >> iniciarservico', root, function(player, element)
    if not getElementData(player, 'InService') then 
        local meta = metas[math.random(1, #metas)]
        for _, v in ipairs(exports.crp_jobmanager:getMembersInGroup(getElementData(player, 'JobGroup'))) do 
            setElementData(v, 'InService', 'Pescador')
            tabletMessage(v, 'Serviço de pescador iniciado. Colete '..meta..' peixes em um cardume.')
        end
        exports.crp_jobmanager:setGroupMeta(getElementData(player, 'JobGroup'), 0, meta)
        --msg(player, 'Voce iniciou o serviço de pescador. Vá até um cardume de peixes.', 'success')
    else
        setElementData(player, 'InService', false)
        msg(player, 'Voce finalizou o serviço de pescador.', 'info')
    end
end)

addEvent('comecarPescador', true)
addEventHandler('comecarPescador', root, function(player)
    if getElementData(player, 'InService') == 'Pescador' then 
        if exports.crp_inventory:getItem(player, 'isca') >= 1 then
            if getPlayerInZone(player) then 
                exports.crp_inventory:takeItem(player, 'isca', 1)
                setElementData(player, 'pescando', true)
                exports.crp_notify:addBox(player, 'Você jogou a isca, aguarde um peixe. Pressione backspace para cancelar.', 'info')
                setElementFrozen(player, true)
                setPedAnimation(player, 'SWORD', 'sword_IDLE', -1, true, false, false)
                giveWeapon(player, 7, 30, true)
                toggleControl(player, 'fire', false)
                toggleControl(player, 'action', false)
                toggleControl(player, 'previous_weapon', false)
                setTimer(function()
                    if getElementData(player, 'pescando') then
                        peixe[player] = cfg.peixes[math.random(1, #cfg.peixes)][1]
                        triggerClientEvent(player, 'class:startMinigame', player, "rewards:pescador", player, minigame[peixe[player]])
                        --triggerClientEvent(player, 'pescador:startMinigame', player)
                        --setElementFrozen(player, false)
                    end
                end, math.random(7000, 20000), 1)
            else
                exports.crp_notify:addBox(player, 'Você não está em uma zona de pesca.', 'error')
            end
        else
            msg(player, 'Você precisa de 1x Isca de Peixe.', 'error')
        end
    end
end)

addEvent('recompensaPescador', true)
addEventHandler('recompensaPescador', root, function(player, peixe)
    local valor, meta = exports.crp_jobmanager:getGroupMeta(getElementData(player, 'JobGroup'))
    local list, players = exports.crp_jobmanager:getMembersInGroup(getElementData(player, 'JobGroup'))
    exports.crp_jobmanager:updateGroupMeta(getElementData(player, 'JobGroup'), valor + 1)
    iprint(meta)
    for _, v in ipairs(exports.crp_jobmanager:getMembersInGroup(getElementData(player, 'JobGroup'))) do 
        if (meta - (valor + 1)) > 0 then
            tabletMessage(v, getPlayerName(player)..' pescou um peixe. ['..(valor+1)..'/'..meta..']')
        end
    end
    exports.crp_inventory:giveItem(player, peixe, 1)
    setPedAnimation(player)
    setElementFrozen(player, false)
    setElementData(player, 'pescando', false)
    setElementData(player, 'JobRecompensa', (getElementData(player, 'JobRecompensa') or 0) + (math.random(10, 20)*players))
    if (valor + 1) >= meta then 
        for _, v in ipairs(exports.crp_jobmanager:getMembersInGroup(getElementData(player, 'JobGroup'))) do 
            setElementData(player, 'JobRecompensa', (getElementData(player, 'JobRecompensa') or 0) + metasValor[meta])
            setElementData(v, 'InService', false)
            tabletMessage(v, 'Serviço completado, vá até a central de pesca para receber seu salario.')
        end
        exports.crp_jobmanager:setGroupMeta(getElementData(player, 'JobGroup'), 0, 0)
    end
    takeWeapon(player, 7)
    toggleControl(player, 'fire', true)
    toggleControl(player, 'action', true)
    toggleControl(player, 'previous_weapon', true)
end)

addEvent('pescador:cancelService', true)
addEventHandler('pescador:cancelService', root, function ( player )
    for _, v in ipairs(exports.crp_jobmanager:getMembersInGroup(getElementData(player, 'JobGroup'))) do 
        --setElementData(player, 'JobRecompensa', (getElementData(player, 'JobRecompensa') or 0) + metasValor[meta])
        setElementData(v, 'InService', false)
        tabletMessage(v, 'O lider do grupo cancelou o serviço.')
        takeWeapon(v, 7)
        toggleControl(v, 'fire', true)
        toggleControl(v, 'action', true)
        toggleControl(v, 'previous_weapon', true)
    end
    exports.crp_jobmanager:setGroupMeta(getElementData(player, 'JobGroup'), 0, 0)
end)

addEvent('setAnim', true)
addEventHandler('setAnim', root, function(player, anim, anim2)
    if anim and anim2 then
        setPedAnimation(player, anim, anim2, -1, true, false, false)
    else
        setPedAnimation(player)
        takeWeapon(player, 7)
    end
end)

local peixe

function receiverRewards(target, type)
    if type == "success" then
        peixe = cfg.peixes[math.random(1, #cfg.peixes)]
        triggerEvent("recompensaPescador", target, target, peixe[1])
    elseif type == "fail" then
        setElementData(target, 'pescando', false)
        triggerEvent('setAnim', target, target)
        setElementFrozen(target, false)
    end
    takeWeapon(target, 7)
    toggleAllControls(target, true)
end
addEvent("rewards:pescador", true)
addEventHandler("rewards:pescador", root, receiverRewards)

function msg (player, msg, type)
    exports.crp_notify:addBox(player, msg, type)
end

function getPlayerInZone(player) 
    local b = false
    for i,v in ipairs(cfg.zonas) do
        local x, y, z = getElementPosition(player)
        if getDistanceBetweenPoints3D(x, y, z, v[1], v[2], v[3]) <= 100 then 
            b = true
        end
    end
    return b
end