function getPlayerMoney ( player )
    return exports.crp_inventory:getItem(player, 'dinheiro') or 0
end

function givePlayerMoney ( player, amount )
    return exports.crp_inventory:giveItem(player, 'dinheiro', amount) or false
end

function takePlayerMoney ( player, amount )
    return exports.crp_inventory:takeItem(player, 'dinheiro', amount) or false
end