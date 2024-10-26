local db = dbConnect('sqlite', 'database.db')
dbExec(db, 'CREATE TABLE IF NOT EXISTS accounts (owner, id, user, password, type, saldo)')
dbExec(db, 'CREATE TABLE IF NOT EXISTS logs (account, type, qtd, msg, data)')

local caixa = {}
local banco = {}

for i,v in ipairs(cfg.caixas) do 
    caixa[i] = createObject(2942, v[1], v[2], v[3]-0.5, 0, 0, v[4])
    createBlipAttachedTo(caixa[i], 52)
    setElementData(caixa[i], 'bank-caixa', true)
end

for i,v in ipairs(cfg.bancos) do 
    banco[i] = createPed(v[1], v[2], v[3], v[4], v[5])
    createBlipAttachedTo(banco[i], 57)
    setElementData(banco[i], 'bank', true)
end

addEvent('interaction >> createAccount', true)
addEventHandler('interaction >> createAccount', root, function(player, element)
    dbExec(db, 'INSERT INTO accounts VALUES (?, ?, ?, ?, ?, ?)', getElementData(player, 'ID'), getElementData(player, 'ID')..math.random(10000, 99999), string.gsub(getPlayerName(player), '_', ' '), base64Encode(getPlayerName(player)), 'personal', 3000)
    msg(player, 'Conta criada com sucesso', 'success')
end)

local delay = {}

addEvent('interaction >> openBank', true)
addEventHandler('interaction >> openBank', root, function(player, element)
    if getElementData(element, 'bank') then 
        local contas = getAccounts ( player )
        if #contas > 0 then 
            triggerClientEvent(player, 'bank:manager', player, 'open', contas, false, 'bank')
        else
            msg(player, 'Você não possui nenhuma conta nesse banco.', 'error')
        end
    elseif getElementData(element, 'bank-caixa') then 
        if delay[player] then return end
        triggerClientEvent(player, 'ProgressBar', player, 5000, 'Iniciando ATM')
        setPedAnimation(player, "GANGS","prtial_hndshk_biz_01",5000,true,false,false,false)
        delay[player] = setTimer(function()
            local contas = getAccounts ( player )
            if #contas > 0 then 
                triggerClientEvent(player, 'bank:manager', player, 'open', contas, false, 'atm')
            else
                msg(player, 'Você não possui nenhuma conta nesse banco.', 'error')
            end 
            delay[player] = nil
        end, 5000, 1)
    end
end)

addEvent('bank:deposito', true)
addEventHandler('bank:deposito', root, function(player, accountID, amount, msg)
    if amount then 
        local amount = tonumber(amount)
        local amount = math.floor(math.abs(amount))
        if amount <= 0 then return exports.crp_notify:addBox(player, 'Insira uma quantidade valida.', 'error') end
        if client then 
            client = player
        end
        if getBankAccount(accountID) then 
            if exports.crp_inventory:getItem(player, 'dinheiro') >= amount then 
                local valor = getSaldoAccount ( accountID ) + amount
                updateSaldo ( player, accountID, valor )
                exports.crp_inventory:takeItem(player, 'dinheiro', amount)
                sendLog ( player, accountID, {
                    type = 'Deposito',
                    amount = amount,
                    msg = msg or '',
                } )
            else
                exports.crp_notify:addBox(player, 'Você não possui dinheiro suficiente.', 'error')
            end
        else
            exports.crp_notify:addBox(player, 'Conta não encontrada.', 'error')
        end
    else
        exports.crp_notify:addBox(player, 'Insira uma quantidade valida.', 'error')
    end
end)

addEvent('bank:saque', true)
addEventHandler('bank:saque', root, function(player, accountID, amount, msg)
    if amount then 
        local amount = tonumber(amount)
        local amount = math.floor(math.abs(amount))
        if amount <= 0 then return exports.crp_notify:addBox(player, 'Insira uma quantidade valida.', 'error') end
        if client then 
            client = player
        end
        if getBankAccount(accountID) then 
            if getSaldoAccount ( accountID ) >= amount then 
                local valor = getSaldoAccount ( accountID ) - amount
                exports.crp_inventory:giveItem(player, 'dinheiro', amount)
                updateSaldo ( player, accountID, valor )
                sendLog ( player, accountID, {
                    type = 'Saque',
                    amount = amount,
                    msg = msg or '',
                } )
            else
                exports.crp_notify:addBox(player, 'Saldo insuficiente.', 'error')
            end
        else
            exports.crp_notify:addBox(player, 'Conta não encontrada.', 'error')
        end
    else
        exports.crp_notify:addBox(player, 'Insira uma quantidade valida.', 'error')
    end
end)

addEvent('bank:transferencia', true)
addEventHandler('bank:transferencia', root, function(player, accountID, amount, accountTarget, msg)
    if amount then 
        local amount = tonumber(amount)
        local amount = math.floor(math.abs(amount))
        if amount <= 0 then return exports.crp_notify:addBox(player, 'Insira uma quantidade valida.', 'error') end
        if client then 
            client = player
        end
        if accountTarget == accountID then return exports.crp_notify:addBox(player, 'Você não pode transferir dinheiro para si mesmo.', 'error') end 
        if getBankAccount(accountID) then 
            if getSaldoAccount ( accountID ) >= amount then 
                local account = getBankAccount(accountTarget)
                if account then 
                    local amountPlayer = (getSaldoAccount ( accountID ) or 0 ) - amount
                    local amountTarget = (getSaldoAccount ( accountTarget ) or 0 ) + amount
                    sendLog ( player, accountID, {
                        type = 'Transferencia',
                        amount = amount,
                        msg = msg or '',
                    } )
                    if getPlayerFromID( account.owner ) then 
                        sendLog ( getPlayerFromID( account.owner ), accountTarget, {
                            type = 'Recibo',
                            amount = amount,
                            msg = msg or '',
                        } )
                    else
                        sendLog ( false, accountTarget, {
                            type = 'Recibo',
                            amount = amount,
                            msg = msg or '',
                        } )
                    end
                    updateSaldo ( getPlayerFromID( account.owner ), accountTarget, amountTarget )
                    updateSaldo ( player, accountID, amountPlayer )
                else
                    exports.crp_notify:addBox(player, 'Conta não encontrada.', 'error')
                end
            else
                exports.crp_notify:addBox(player, 'Saldo insuficiente.', 'error')
            end
        else
            exports.crp_notify:addBox(player, 'Conta não encontrada.', 'error')
        end
    end
end)

function getAccounts ( player )
    local result = dbPoll(dbQuery(db, 'SELECT * FROM accounts WHERE owner = ?', getElementData(player, 'ID')), -1)
    local accounts = {}
    if result then 
        if #result > 0 then 
            for i,v in ipairs(result) do 
                local conta = {
                    user = v.user,
                    id = v.id,
                    type = v.type,
                    saldo = v.saldo,
                }
                accounts[i] = conta
            end
        end
    end
    return accounts
end

function getBankAccount (id) 
    local result = dbPoll(dbQuery(db, 'SELECT * FROM accounts WHERE id = ?', id), -1)
    if result then 
        if #result > 0 then 
            local v = result[1]
            local conta = {
                user = v.user,
                id = v.id,
                type = v.type,
                saldo = v.saldo,
                owner = v.owner,
            }
            return conta
        end
    end
    return false
end

function getLogs ( player, id, clientSide)
    local conta = getBankAccount(id) 
    local logs = {}
    if conta then 
        local result = dbPoll(dbQuery(db, 'SELECT * FROM logs WHERE account = ?', id), -1)
        if #result > 0 then 
            for i,v in ipairs(result) do 
                local log = {
                    conta = conta,
                    type = v.type,
                    msg = v.msg or false,
                    amount = v.qtd,
                    data = v.data
                }
                logs[i] = log
            end
            if not clientSide then 
                return logs
            else
                triggerClientEvent(player, 'bank:manager', player, 'update', false, logs)
            end
            --table.sort(ranks, function (a, b) return a[2] > b[2] end)
        end
    end
    return logs
end
addEvent('getLogs', true)
addEventHandler('getLogs', resourceRoot, getLogs)

function getMainAccount( player )
    local contas = getAccounts ( player )
    if #contas > 0 then 
        for i,v in ipairs(contas) do 
            if v.user == string.gsub(getPlayerName(player), '_', ' ') then 
                return v.id
            end
        end
        return contas[1].id
    end
    return false
end
addEvent("class:getMainAccount", true)
addEventHandler("class:getMainAccount", root, getMainAccount)

function getSaldoAccount ( account )
    local conta = getBankAccount(account)
    if conta then
        return conta.saldo 
    end
    return 0
end
addEvent("class:getSaldoAccount", true)
addEventHandler("class:getSaldoAccount", root, getSaldoAccount)

function updateSaldo ( player, account, saldo )
    if getBankAccount(account) then 
        print('novo saldo:'..saldo)
        dbExec(db, 'UPDATE accounts SET saldo = ? WHERE id = ?', saldo, account)
        if player then 
            if getMainAccount( player ) == account then 
                setElementData(player, 'Banco', saldo)
            end 
            triggerClientEvent(player, 'bank:manager', player, 'update', getAccounts(player))
        end
    end
end
addEvent("class:updateSaldo", true)
addEventHandler("class:updateSaldo", root, updateSaldo)

function sendLog ( player, account, data )
    --[[                local log = {
                    conta = conta,
                    type = v.type,
                    msg = v.msg or false,
                    amount = v.qtd,
                    data = v.data
                }]]
    if getBankAccount(account) then 
        -- account, type, qtd, msg, data
        local time = getRealTime()
        local hours = time.hour
        local minutes = time.minute
        local seconds = time.second
    
        local monthday = time.monthday
        local month = time.month
        local year = time.year
    
        local formattedTime = string.format("%02d-%02d-%04d - %02d:%02d:%02d", monthday, month + 1, year + 1900 , hours, minutes, seconds)
        dbExec(db, 'INSERT INTO logs VALUES (?, ?, ?, ?, ?)', account, data.type, data.amount, data.msg, formattedTime)

        if player then 
            triggerClientEvent(player, 'bank:manager', player, 'update', false, getLogs ( player, account ))
        end

    end
end

  


function msg(player, msg, type)
    return exports.crp_notify:addBox(player, msg, type)
end

function getPlayerFromID( id )
    for i,v in ipairs(getElementsByType('player')) do 
        if getElementData(v, 'ID') == id then 
            return v
        end
    end
    return false
end