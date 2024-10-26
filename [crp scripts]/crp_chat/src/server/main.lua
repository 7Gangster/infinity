local delay = {}

addEvent('executeCommand', true)
addEventHandler('executeCommand', root, function(player, cmd, args)
    if args then
        executeCommandHandler(cmd, player, unpack(args))
    else
        executeCommandHandler(cmd, player)
    end
end)

addEvent('sendMessage', true)
addEventHandler('sendMessage', root, function(player, msg)
    if delay[player] then return end
    triggerClientEvent("onChatIncome", player, msg, 0)
    delay[player] = setTimer(function() delay[player] = nil end, 2000, 1)
end)

addEventHandler('onPlayerChat', root, function ( )
    cancelEvent()
end)