function getPlayerMoney ( player )
    return exports.crp_inventory:getItem(player, 'dinheiro') or 0
end

function givePlayerMoney ( player, amount )
    return exports.crp_inventory:giveItem(player, 'dinheiro', amount) or false
end

function takePlayerMoney ( player, amount )
    return exports.crp_inventory:takeItem(player, 'dinheiro', amount) or false
end

function getPlayerSaldo(player)
    local account = exports.crp_bank:getMainAccount(player)
    local saldo = exports.crp_bank:getSaldoAccount(account) or 0
    return saldo
end

function takePlayerBankMoney(player, amount)
    local account = exports.crp_bank:getMainAccount(player)
    local saldo = exports.crp_bank:getSaldoAccount(account) or 0
    exports.crp_bank:updateSaldo(false, account, saldo-amount)
end

function givePlayerBankMoney(player, amount)
    local account = exports.crp_bank:getMainAccount(player)
    local saldo = exports.crp_bank:getSaldoAccount(account) or 0
    exports.crp_bank:updateSaldo(false, account, saldo+amount)
end

addEvent("onElementSpawn", true)

function onElementSpawnCheck(element)
	triggerEvent("onElementSpawn", element)
end
addEvent("onElementSpawnCheck", true)
addEventHandler("onElementSpawnCheck", root, onElementSpawnCheck)