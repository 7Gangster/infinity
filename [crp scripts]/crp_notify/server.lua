function addBox (player, msg, type, timer)
    triggerClientEvent(player, 'addBox', player, msg, type, timer or false)
end