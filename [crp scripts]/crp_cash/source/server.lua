Cobranca = {}

addEvent('class.informations', true)
addEventHandler('class.informations', root, function(player, payment, passaport, price)
    local target = getPlayerFromID(tonumber(passaport))
    local price = tonumber(price)
    if target then
        if getElementData(target, 'cobranca') then return msg(player, 'O jogador já tem uma cobrança pendente.', 'error') end
        msg(player, 'Cobrança enviada.', 'success')
        msg(target, 'Você recebeu uma cobrança de $'..price..' vá na caixa registradora para paga-lo ', 'info')
        setElementData(target, 'cobranca', {price, payment, player})
        Cobranca[player] = setTimer(function()
            msg(target, 'Cobrança expirada', 'error')
            msg(player, 'Cobrança expirada', 'error')
            setElementData(target, 'cobranca', nil)
            Cobranca[player] = nil
        end, 60000, 1)
    end
end)

function aceitar()
    for i, player in ipairs(getElementsByType('player')) do 
            if getElementData(player, 'cobranca') then 
                local price, payment, target = unpack(getElementData(player, 'cobranca'))
                iprint(price)
                if payment == 'Dinheiro' then
                    if exports.crp_inventory:getItem(player, 'dinheiro') >= price then
                        exports.crp_inventory:takeItem(player, 'dinheiro', price)
                        exports.crp_inventory:giveItem(target, 'dinheiro', price)
                        msg(player, 'Transação concluida com sucesso.', 'success')
                        msg(target, 'Transação concluida com sucesso você pagou '..price..'.', 'success')
                        setElementData(player, 'cobranca', nil)
                        killTimer(Cobranca[target])
                        Cobranca[target] = nil
                    else
                        msg(player, 'Dinheiro insuficiente.', 'error')
                        msg(target, 'O jogador não possui dinheiro suficiente.', 'error')
                        setElementData(player, 'cobranca', nil)
                        killTimer(Cobranca[target])
                        Cobranca[target] = nil
                    end
                end
                if payment == 'Cartão' then
                    if getPlayerSaldo(player) >= price then
                        takePlayerBankMoney(player, price)
                        givePlayerBankMoney(target, price)
                        msg(player, 'Transaçao concluida com sucesso.', 'success')
                        msg(target, 'Transaçao concluida com sucesso.', 'success')
                        setElementData(player, 'cobranca', nil)
                        killTimer(Cobranca[target])
                        Cobranca[target] = nil
                    else
                        msg(player, 'Dinheiro insuficiente no banco.', 'error')
                        msg(target, 'O jogador não possui dinheiro suficiente no banco.', 'error')
                        setElementData(player, 'cobranca', nil)
                        killTimer(Cobranca[target])
                        Cobranca[target] = nil
                    end
                end
            end
    end
end
addEventHandler('onResourceStart', resourceRoot, aceitar)
addEvent('class.buyConfirm', true)
addEventHandler('class.buyConfirm', root, aceitar)

addEvent('class.showPanel', true)
addEventHandler('class.showPanel', root, function()
    triggerClientEvent(source, 'class.openCash', source)      	
end)

function getPlayerFromID(id)
    for i,player in ipairs(getElementsByType('player')) do 
        if getElementData(player, 'ID') == id then 
            return player
        end
    end
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

for i,v in ipairs(config.caixas) do 

    local caixa = createObject(v.model, unpack(v.position))
    setElementData(caixa, 'ACL', v.acl)

end