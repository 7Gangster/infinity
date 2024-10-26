function createDiscordLogs(title, description)
    local data = {
        embeds = {
            {
                ["color"] = 2829617,
                ["title"] = title,
                
                ["description"] = description,
                
                ['thumbnail'] = {
                    ['url'] = "",
                },

                --['image'] = {
                    --['url'] = image
                --},

                ["footer"] = {
                    ["text"] = "Class Roleplay",
                    ['icon_url'] = ""
                },
            }
        },
    }

    data = toJSON(data);
    data = data:sub(2, -2);
    fetchRemote('https://discord.com/api/webhooks/1202988102998556713/eygYDDkXT81sAFqiXW5TdakjtBHwlM_UmE_yLBvW1snkvPw8htflTu2iA1RLfUSv0uCE', {["queueName"] = "logs", ["connectionAttempts"] = 5, ["connectTimeout"] = 5000, ["headers"] = {["Content-Type"] = "application/json"}, ['postData'] = data}, function() end);
end

function getPlayerSaldo(player)
    local account = exports.crp_bank:getMainAccount(player)
    local saldo = exports.crp_bank:getSaldoAccount(account) or 0
    return saldo
--exports.crp_bank:updateSaldo(false, account, saldo - qtd*getGNEValue())
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

function getPlayerFromID(id) 
    for i,v in ipairs(getElementsByType('player')) do 
        if tonumber(getElementData(v, 'ID')) == tonumber(id) then 
            return v
        end
    end
end