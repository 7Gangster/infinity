local db = dbConnect('sqlite', 'database.db')

function msg(player, msg, type)
    return exports.crp_notify:addBox(player, msg, type)
end

addEventHandler('onResourceStart', resourceRoot, function ()
    dbExec(db, 'CREATE TABLE IF NOT EXISTS gne (valor)')
    dbExec(db, 'CREATE TABLE IF NOT EXISTS player_gne (id, gne)')
    dbExec(db, 'CREATE TABLE IF NOT EXISTS player_group (id, nome, grupo, cargo, user)')
    dbExec(db, 'CREATE TABLE IF NOT EXISTS groups (id, level, xp)')
    if #(dbPoll(dbQuery(db, 'SELECT * FROM gne'), -1)) == 0 then 
        dbExec(db, 'INSERT INTO gne VALUES (?)', cfg.crypto.valorBase)
    end
    updateGNE()
    setTimer(updateGNE, 60000*60, 0)
end)

-- // LAPTOP 

addEvent('openLaptop', true)
addEventHandler('openLaptop', root, function(player)
    if exports.crp_inventory:getItem(player, 'vpn') >= 1 then 
        triggerClientEvent(player, 'laptopManager', player, 'vpn', true)
    else
        triggerClientEvent(player, 'laptopManager', player, 'vpn', false)
    end
    triggerClientEvent(player, 'laptopManager', player, 'gne', getGNEValue())
end)

-- // GNE

function updateGNE ( )
    local atualValue = getGNEValue ( )
    local chance = math.random(1, 2)
    local porcentagem = math.random(cfg.crypto.porcentagem[1], cfg.crypto.porcentagem[2])
    local newValue = atualValue/100*(porcentagem)
    if chance == 1 then 
        dbExec(db, 'UPDATE gne SET valor = ?', math.floor(atualValue+newValue))
        createDiscordLogs('🔺 GNE - VALORIZOU', 'A cryptomoeda **GNE** valorizou em **'..porcentagem..'**%. \n\nValor antigo: **$'..atualValue..'** \nValor atual: **$'..math.floor(atualValue+newValue)..'**\n')
    elseif chance == 2 then 
        dbExec(db, 'UPDATE gne SET valor = ?', math.floor(atualValue-newValue))
        createDiscordLogs('🔻 GNE - DESVALORIZOU', 'A cryptomoeda **GNE** desvalorizou em **'..porcentagem..'**%. \n\nValor antigo: **$'..atualValue..'** \nValor atual: **$'..math.floor((atualValue-newValue))..'**\n')
    end
end

function buyGNE ( )
end

function sellGNE ( )
end

function getGNEValue ( )
    local result = (dbPoll(dbQuery(db, 'SELECT * FROM gne'), -1)) or {}
    if #result > 0 then 
        return result[1].valor
    end
    return cfg.crypto.valorBase
end

function getPlayerGNE ( id )
    local result = (dbPoll(dbQuery(db, 'SELECT * FROM player_gne WHERE id = ?', id), -1))
    if #result > 0 then 
        return result[1].gne
    end
    return 0
end

addEvent('buyGNE', true)
addEventHandler('buyGNE', root, function ( player, qtd )
    if (not client) or (source ~= resourceRoot) then
        return false;
    end      
    local qtd = tonumber(qtd) or 0
    local qtd = math.abs(math.floor(qtd))
    local account = exports.crp_bank:getMainAccount(player)
    local saldo = exports.crp_bank:getSaldoAccount(account) or 0
    if qtd <= 0 then return end 
    if saldo >= qtd*getGNEValue() then 
        exports.crp_bank:updateSaldo(false, account, saldo - qtd*getGNEValue())
        setElementData(player, 'GNE', (getElementData(player, 'GNE') or 0) + qtd)
        msg(player, 'Você comprou '..qtd..' GNE por $ '..(qtd*getGNEValue()), 'success')
    else
        msg(player, 'Você não possui saldo suficiente.', 'error')
    end
end)

addEvent('sellGNE', true)
addEventHandler('sellGNE', root, function ( player, qtd )
    if (not client) or (source ~= resourceRoot) then
        return false;
    end      
    local qtd = tonumber(qtd) or 0
    local qtd = math.abs(math.floor(qtd))
    if qtd <= 0 then return end 
    if (getElementData(player, 'GNE') or 0) >= qtd then 
        givePlayerBankMoney(player, qtd*getGNEValue())
        setElementData(player, 'GNE', (getElementData(player, 'GNE') or 0) - qtd)
        msg(player, 'Você vendeu '..qtd..' GNE por $ '..(qtd*getGNEValue()), 'success')
    else
        msg(player, 'Você não possui saldo suficiente.', 'error')
    end
end)

addEvent('transferGNE', true)
addEventHandler('transferGNE', root, function ( player, qtd, id )
    if (not client) or (source ~= resourceRoot) then
        return false;
    end      
    local qtd = tonumber(qtd) or 0
    local qtd = math.abs(math.floor(qtd))
    if qtd <= 0 then return end 
    if (getElementData(player, 'GNE') or 0) >= qtd then 
        local target = getPlayerFromID(id)
        if target then 
            setElementData(player, 'GNE', (getElementData(player, 'GNE') or 0) - qtd)
            setElementData(target, 'GNE', (getElementData(target, 'GNE') or 0) + qtd)
            msg(target, 'Você recebeu '..qtd..' GNE de '..getPlayerName(player) , 'success')
            msg(player, 'Você enviou '..qtd..' GNE para '..getPlayerName(target) , 'success')
        else
            msg(player, 'Conta não encontrada.', 'error')
        end
    else
        msg(player, 'Você não possui saldo suficiente.', 'error')
    end
end)

-- // GRUPOS

addEvent('getGroups', true)
addEventHandler('getGroups', resourceRoot, function (player)
    local result = dbPoll(dbQuery(db, 'SELECT * FROM player_group WHERE id = ?', getElementData(player, 'ID')), -1)
    local grupos = {}

    if result then 
        if #result > 0 then 
            for i, v in ipairs(result) do 

                local grupo = cfg.grupos[v.grupo]

                if grupo then 
                    table.insert(grupos, {
                        nome = grupo.nome,
                        cargo = v.cargo,
                        level = 0,
                        id = v.grupo,
                        players = getPlayersInGroup (v.grupo)
                    })
                end
            end
        end
    end

    triggerClientEvent(player, 'updateBussines', player, grupos)
end)

function getPlayersInGroup (grupo)
    local result = dbPoll(dbQuery(db, 'SELECT * FROM player_group WHERE grupo = ?', grupo), -1)
    local players = {}

    if result then 
        if #result > 0 then 
            for i, v in ipairs(result) do 
                table.insert(players, {
                    nome = v.nome,
                    id = v.id,
                    player = getPlayerFromID(v.id),
                    user = v.user,
                    cargo = v.cargo
                })
            end
        end
    end

    return players or {}
end

function isPlayerInGroup ( player, grupo ) 
    local result = dbPoll(dbQuery(db, 'SELECT * FROM player_group WHERE grupo = ? AND id = ?', grupo, getElementData(player, 'ID')), -1)
    if #result > 0 then 
        return true 
    end
    return false
end

function getCargoFromRank (rank, grupo)
    local cargo = false
    for i,v in pairs(cfg.grupos[grupo].cargos) do 
        if v.rank == rank then 
            cargo = i 
        end
    end
    return cargo
end

function getCargoRank ( cargo, grupo )
    if cfg.grupos[grupo].cargos[cargo] then 
        return cfg.grupos[grupo].cargos[cargo].rank 
    end
    return false 
end

function addPlayerInGroup ( player, grupo )
    if isPlayerInGroup ( player, grupo ) then return end
    if cfg.grupos[grupo] then 
        dbExec(db, 'INSERT INTO player_group VALUES ( ?, ?, ?, ?, ? )', getElementData(player, 'ID'), getPlayerName(player), grupo, getCargoFromRank (1, grupo), getAccountName(getPlayerAccount(player)))
    
        if cfg.grupos[grupo].acl then 
            aclGroupAddObject(aclGetGroup(cfg.grupos[grupo].acl), 'user.'..getAccountName(getPlayerAccount(player)))
        end
    end
end

function removePlayerGroup(player, grupo)
    if cfg.grupos[grupo] then 
        dbExec(db, 'DELETE FROM player_group WHERE id = ? AND grupo = ?', getElementData(player, 'ID'), grupo)

        if cfg.grupos[grupo].acl then 
            aclGroupRemoveObject(aclGetGroup(cfg.grupos[grupo].acl), 'user.'..getAccountName(getPlayerAccount(player)))
        end
    end
end

addEvent('grupo:sair', true)
addEventHandler('grupo:sair', root, function ( player, grupo )

    removePlayerGroup(player, grupo.id)
    msg(player, 'Você saiu do grupo: '..grupo.nome, 'info')

end)

addEvent('grupo:remover', true)
addEventHandler('grupo:remover', root, function ( player, target, grupo )

    local grp = grupo
    local grupo = grupo.id 
    local targetPlayer = target.player 

    local atualRank = getCargoRank ( grp.cargo, grupo )
    if target.id == getElementData(player, 'ID') then return msg(player, 'Você não pode se remover do grupo.', 'error') end

    if getCargoRank(target.cargo, grupo) > atualRank then return msg(player, 'Você não pode remover um membro superior a você.', 'error') end

    if targetPlayer then 
        removePlayerGroup(targetPlayer, grupo)
        triggerEvent('getGroups', resourceRoot, targetPlayer)
    else
        dbExec(db, 'DELETE FROM player_group WHERE id = ? AND grupo = ?', target.id, grupo)

        if cfg.grupos[grupo].acl then 
            aclGroupRemoveObject(aclGetGroup(cfg.grupos[grupo].acl), 'user.'..target.user)
        end
    end

    msg(player, 'Você removeu o '..target.cargo..' '..target.nome..' do grupo.', 'error')

    triggerEvent('getGroups', resourceRoot, player)
    

end)

addEvent('grupo:promover', true)
addEventHandler('grupo:promover', root, function ( player, target, grupo )

    local grupo = grupo.id 
    local targetPlayer = target.player 

    local atualRank = getCargoRank ( target.cargo, grupo )
    local newCargo = getCargoFromRank(atualRank +1, grupo)

    if target.id == getElementData(player, 'ID') then return msg(player, 'Você não pode se promover.', 'error') end
    if getCargoRank(target.cargo, grupo) > atualRank then return msg(player, 'Você não pode rebaixar um membro superior a você.', 'error') end
    
    if newCargo then 

        print(newCargo)
        if newCargo ~= cfg.grupos[grupo].lider then 

            dbExec(db, 'UPDATE player_group SET cargo = ? WHERE id = ?', newCargo, target.id)
            msg(player, 'Você promoveu o '..target.cargo.. ' '..target.nome..' para '..newCargo, 'success')


        else

            msg(player, 'O jogador já esta no cargo maximo.', 'error')

        end

    else

        msg(player, 'O jogador já esta no cargo maximo.', 'error')

    end

    triggerEvent('getGroups', resourceRoot, player)

end)


addEvent('grupo:rebaixar', true)
addEventHandler('grupo:rebaixar', root, function ( player, target, grupo )

    local grupo = grupo.id 
    local targetPlayer = target.player 

    local atualRank = getCargoRank ( target.cargo, grupo )
    local newCargo = getCargoFromRank(atualRank -1, grupo)

    if target.id == getElementData(player, 'ID') then return msg(player, 'Você não pode se rebaixar.', 'error') end

    if newCargo then 

        if newCargo ~= cfg.grupos[grupo].lider then 

            dbExec(db, 'UPDATE player_group SET cargo = ? WHERE id = ?', newCargo, target.id)
            msg(player, 'Você rebaixou o '..target.cargo.. ' '..target.nome..' para '..newCargo, 'success')

        else

            msg(player, 'O jogador já esta no cargo minimo.', 'error')
            
        end
    else
        msg(player, 'O jogador já esta no cargo minimo.', 'error')
    end

    triggerEvent('getGroups', resourceRoot, player)

end)

delay = {}

addEvent('group:invite_player', true)
addEventHandler('group:invite_player', root, function ( player, id, grupo )

    local target = getPlayerFromID(id)

    if delay[target] then return msg(player, 'O usuario já possui um convite em andamento.', 'error') end
    if not target then return msg(player, 'Usuario não encontrado.', 'error') end
    if target == player then return msg(player, 'Você ja faz parte desse grupo.', 'error') end

    triggerClientEvent(target, 'jobmanager >> notify', target, {
        nome = grupo.nome,
        color = 'FFBF00',
        msg = 'Você recebeu um convite.',
        img = 'src/assets/notify/jobcenter.png',
        type = 'escolha',
        execute = 'group:join',
        args = {target, player, grupo}
    })

    delay[target] = setTimer(function()
        delay[target] = nil
        msg(player, 'O usuario negou o convite.', 'info')
    end, 7000, 1)

end)

addEvent('group:join', true)
addEventHandler('group:join', root, function ( player, sender, grupo )

    addPlayerInGroup ( player, grupo.id )
    killTimer(delay[player])
    delay[player] = nil
    msg(sender, 'O usuario: '..getPlayerName(player).. ' entrou no grupo.', 'success')
    msg(player, 'Você entrou no grupo: '..grupo.nome, 'success')
    triggerEvent('getGroups', resourceRoot, player)
    triggerEvent('getGroups', resourceRoot, sender)

end)

addCommandHandler('setgroup', function(player, cmd, id, grupo)
    local target = getPlayerFromID(id)
    if not target then return msg(player, 'Jogador não encontrado.', 'error') end;
    if not grupo then return msg(player, 'Insira um grupo valido.', 'error') end;
    if isPlayerInGroup ( target, grupo ) then return msg(player, 'O jogador já faz parte desse grupo', 'error') end;

    local grupo = tonumber(grupo)

    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Admin')) then 
        if cfg.grupos[grupo] then 

            dbExec(db, 'INSERT INTO player_group VALUES ( ?, ?, ?, ?, ? )', getElementData(target, 'ID'), getPlayerName(target), grupo, cfg.grupos[grupo].lider, getAccountName(getPlayerAccount(player)))
            msg(player, 'O jogador '..getPlayerName(target)..' foi setado como dono do grupo '..cfg.grupos[grupo].nome, 'info')
            msg(target, 'Você foi setado como lider do grupo '..cfg.grupos[grupo].nome, 'info')

            if cfg.grupos[grupo].acl then 
                aclGroupAddObject(aclGetGroup(cfg.grupos[grupo].acl), 'user.'..getAccountName(getPlayerAccount(target)))
            end
        else
            msg(player, 'Insira um grupo valido.', 'error')
        end
    end
end)
-- // EXPORTS

function onLogin ( player )
    local id = getElementData(player, 'ID')
    if id then 
        setElementData(player, 'GNE', getPlayerGNE(id))
    end
end

function onQuit ( player )
    if getElementData(player, 'GNE') then 
        dbExec(db, 'UPDATE player_gne SET gne = ? WHERE id = ?', getElementData(player, 'GNE') or 0, getElementData(player, 'ID'))
    end
end

