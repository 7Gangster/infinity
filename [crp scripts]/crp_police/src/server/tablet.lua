function msg(player, msg, type)
    exports.crp_notify:addBox(player, msg, type)
end

local db = dbConnect('sqlite', 'src/assets/database.db')
dbExec(db, 'CREATE TABLE IF NOT EXISTS players (id, nome, avatar)')
dbExec(db, 'CREATE TABLE IF NOT EXISTS prisoes (id, artigos, policial, desc, data)')
dbExec(db, 'CREATE TABLE IF NOT EXISTS preso (id, artigos, tempo)')

tablet_aberto = {}
time_preso = {}

addCommandHandler('tablet', function(ply)
    if getElementData(ply, 'police >> duty') then
        if not tablet_aberto[ply] then 
            triggerClientEvent(ply, 'police >> tablet', ply, 'open')
            triggerClientEvent(ply, 'police >> tablet', ply, 'update', {
                prisoes = getPrisoes()
            })
            tablet_aberto[ply] = true
        else
            triggerClientEvent(ply, 'police >> tablet', ply, 'close')
            tablet_aberto[ply] = nil
        end
    end
end)

addEvent('tablet >> pesquisar', true)
addEventHandler('tablet >> pesquisar', root, function(ply, id)
    local result = dbPoll(dbQuery(db, 'SELECT * FROM players WHERE id = ?', tonumber(id)), -1)
    if #result > 0 then 
        local passagens, table = getPlayerPrisoes (tonumber(id))
        triggerClientEvent(ply, 'police >> tablet', ply, 'update', {
            prisoes = getPrisoes(),
            pesquisa = {
                nome = result[1].nome,
                avatar = result[1].avatar,
                id = id,
                passagens = getPlayerPrisoes (tonumber(id)),
                prisoes = table
            },
        })
    else
        msg(ply, 'Nenhum registro encontrado.', 'error')
    end
end)

addEvent('tablet >> prender', true)
addEventHandler('tablet >> prender', root, function(ply, id, table, desc)
    local target = getPlayerFromID(tonumber(id))
    local x, y, z = getElementPosition(ply)
    local x2, y2, z2 = getElementPosition(target)
    if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 3 and getDistanceBetweenPoints3D(x, y, z, cfg.prender[1], cfg.prender[2], cfg.prender[3]) <= 10 then
        local tempo = getTimePrison(table)
        local artigos = getArtigos(table)
        local time = getRealTime()
        local monthday = time.monthday
        local month = time.month+1
        local year = time.year
        local formattedTime = string.format("%02d/%02d/%04d", monthday, month, year + 1900)
        dbExec(db, 'INSERT INTO prisoes VALUES (?, ?, ?, ?, ?)', getElementData(target, 'ID'), artigos, getPlayerName(ply), (desc or 'Não informado'), formattedTime)
        dbExec(db, 'INSERT INTO preso VALUES (?, ?, ?)', getElementData(target, 'ID'), artigos, tempo)
        local result = dbPoll(dbQuery(db, 'SELECT * FROM players WHERE id = ?', getElementData(target, 'ID')), -1)
        if #result == 0 then dbExec(db, 'INSERT INTO players VALUES (?, ?, ?)', getElementData(target, 'ID'), getPlayerName(target), 0) end
        msg(ply, 'Prisão efetuada com sucesso.', 'success')
        msg(target, 'Você foi preso por '..tempo..' pelos artigos: '..artigos, 'info')
        setElementData(target, 'Preso', tempo)
        time_preso[target] = setTimer(function()
            setElementData(target, 'Preso', getElementData(target, 'Preso') -1)
            if getElementData(target, 'Preso') <= 0 then 
                liberarPrisao(target)
            end
        end, 60000, 0)
    end
end)

addEventHandler('onPlayerLogin', root, function()
    setTimer(function(ply)
        if ply then
            local result = dbPoll(dbQuery(db, 'SELECT * FROM preso WHERE id = ?', getElementData(ply, 'ID')), -1)
            if result and #result > 0 then 
                setElementData(ply, 'Preso', result[1].tempo)
                time_preso[ply] = setTimer(function()
                    setElementData(ply, 'Preso', getElementData(ply, 'Preso') -1)
                    if getElementData(ply, 'Preso') <= 0 then 
                        liberarPrisao(ply)
                    end
                end, 60000, 0)
            end
        end
    end, 5000, 1, source)
end)

addEventHandler('onPlayerQuit', root, function()
    if getElementData(source, 'Preso') then 
        dbExec(db, 'UPDATE preso SET tempo = ? WHERE id = ?', getElementData(source, 'Preso'), getElementData(source, 'ID'))
        killTimer(time_preso[source])
        time_preso[source] = nil
    end
end)

addCommandHandler('soltarpreso', function(player, cmd, id)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Admin')) then
        local target = getPlayerFromID(tonumber(id))
        if target then 
            if getElementData(target, 'Preso') then
                liberarPrisao(target)
                msg(player, 'Jogador liberado.', 'info')
                msg(target, 'Você foi solto da cadeia.', 'success')
            end
        end
    end
end)

function liberarPrisao(ply)
    removeElementData(ply, 'Preso')
    dbExec(db, 'DELETE FROM preso WHERE id = ?', getElementData(ply, 'ID'))
    setElementPosition(ply, 1553.6062011719,-1675.5260009766,16.1953125)
    killTimer(timer_preso[ply])
    time_preso[ply] = nil
end

function getPrisoes()
    local result = dbPoll(dbQuery(db, 'SELECT * FROM prisoes'), -1)
    return #result, result
end

function getPlayerPrisoes (id)
    local result = dbPoll(dbQuery(db, 'SELECT * FROM prisoes WHERE id = ?', id), -1)
    return #result, result
end

function getTimePrison(tabela)
    local time = 0
    for i,v in ipairs(tabela) do 
        time = time + v.tempo
    end
    return time
end

function getArtigos (tabela)
    local art = {}
    for i,v in ipairs(tabela) do 
        table.insert(art, v.art)
    end
    return table.concat(art, ', ')
end

function getPlayerFromID(id)
    for i,v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'ID') == tonumber(id) then 
            return v
        end
    end
end