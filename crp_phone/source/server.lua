local db = dbConnect('sqlite', 'database.db')
dbExec(db, 'CREATE TABLE IF NOT EXISTS numbers (player_id, number)')
dbExec(db, 'CREATE TABLE IF NOT EXISTS contatos (player_id, number, name)')


addEvent('getPhotos', true)
addEventHandler('getPhotos', root, function ( player )
    local result = dbPoll(dbQuery(db, 'SELECT * FROM images WHERE owner = ?', getElementData(player, 'ID')), -1)
    local photos = {}

    if result then 
        if #result > 0 then 
            for i,v in ipairs(result) do 
                table.insert(photos, {
                    owner = v.owner,
                    path = v.path,
                    fileName = v.fileName,
                })
            end
        end
    end

    triggerClientEvent(player, 'managePhone', resourceRoot, 'photos', photos)
end)

addEvent('getContatos', true)
addEventHandler('getContatos', root, function(player)
    local result = dbPoll(dbQuery(db, 'SELECT * FROM contatos WHERE player_id = ?', getElementData(player, 'ID')), -1)
    local contatos = {}

    if result then 
        if #result > 0 then 
            for i,v in ipairs(result) do 
                table.insert(contatos, {
                    nome = v.name, 
                    numero = v.number,
                })
            end
        end
    end

    triggerClientEvent(player, 'managePhone', resourceRoot, 'contatos', contatos)

end)

addEvent('addContato', true)
addEventHandler('addContato', resourceRoot, function(player, fn, ln, number)

    if number == getElementData(player, 'Numero') then return print('Você não pode se adicionar.') end;

    local result = dbPoll(dbQuery(db, 'SELECT * FROM contatos WHERE number = ? AND player_id = ?', number, getElementData(player, 'ID')), -1)
    if result then 
        if #result == 0 then 

            local result = dbPoll(dbQuery(db, 'SELECT * FROM numbers WHERE number = ?', number), -1)
            if #result > 0 then 
                dbExec(db, 'INSERT INTO contatos VALUES (?, ?, ?)', getElementData(player, 'ID'), number, fn..' '..ln)
                triggerEvent('getContatos', player, player)
                triggerClientEvent(player, 'phone:notify', player, 'Telefone', fn..' '..ln..' foi adicionado a sua lista de contatos.', 'assets/images/icons/phone.png')
            else 
                triggerClientEvent(player, 'phone:notify', player, 'Telefone', 'Numero inexistente.', 'assets/images/icons/phone.png')
            end
        
        end
    end

end)

addEvent('editContato', true)
addEventHandler('editContato', resourceRoot, function(player, fn, ln, number)

    print(player, fn, ln, number)

    dbExec(db, 'UPDATE contatos SET name = ? WHERE player_id = ? AND number = ?', fn..' '..ln, getElementData(player, 'ID'), number)
    triggerEvent('getContatos', player, player)


end)

addEvent('deleteContato', true)
addEventHandler('deleteContato', resourceRoot, function(player, number)

    print(number)
    dbExec(db, 'DELETE FROM contatos WHERE player_id = ? AND number = ?', getElementData(player, 'ID'), number)
    triggerEvent('getContatos', player, player)
    triggerClientEvent(player, 'phone:notify', player, 'Telefone', 'Contato removido de sua lista.', 'assets/images/icons/phone.png')

end)

function generateNumber(player)

    local number = math.random(100, 999)..'-'..math.random(100, 999)

    local result = dbPoll(dbQuery(db, 'SELECT * FROM numbers WHERE number = ?', number), -1)
    if #result > 0 then 
        generateNumber()
        return
    end

    dbExec(db, 'INSERT INTO numbers VALUES (?, ?)', getElementData(player, 'ID'), number)
    setElementData(player, 'Numero', number)
    return true

end

addEventHandler('onPlayerLogin', root, function()
    setTimer(function(player)
        if getElementData(player, 'ID') then 
            local result = dbPoll(dbQuery(db, 'SELECT * FROM numbers WHERE player_id = ?', getElementData(player, 'ID')), -1)
            if result then 
                if #result > 0 then 
                    setElementData(player, 'Numero', result[1].number)
                elseif #result <= 0 then 
                    generateNumber(player)
                end
            else
                generateNumber(player)
            end
        end
    end, 1000, 1, source)
end)