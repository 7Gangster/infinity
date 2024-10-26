function openGasStation(player)
    triggerClientEvent(player, "class:openGasStation", player)
end
addEvent("class:openGasStationS", true)
addEventHandler("class:openGasStationS", root, openGasStation)

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

function paymentNow(player, vehicle, price, quantity, card, blow)
    if player and vehicle then
        if blow then return blowVehicle(vehicle, true) end
        if card then
            if getPlayerSaldo(player) >= price then
                takePlayerBankMoney(player, price)
                msg(player, "Você está abastecendo "..quantity.." litros por $"..price, "success")
                triggerClientEvent(player, "class:setFueling", player, player, vehicle, quantity, card)
            else
                return msg(player, "Você não possui dinheiro sufienciente", "error")
            end
        else
            if exports.crp_inventory:getPlayerMoney(player) >= price then
                msg(player, "Você está abastecendo "..quantity.." litros por $"..price, "success")
                exports.crp_inventory:takePlayerMoney(player, price)
                triggerClientEvent(player, "class:setFueling", player, player, vehicle, quantity, card)
            else
                return msg(player, "Você não possui dinheiro sufienciente", "error")
            end
        end
    end
end
addEvent("class:paymentGas", true)
addEventHandler("class:paymentGas", root, paymentNow)