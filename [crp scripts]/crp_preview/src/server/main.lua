local db = dbConnect('sqlite', 'src/server/database.db')

if db then 

    dbExec(db, 'CREATE TABLE IF NOT EXISTS objects (id, owner, model, position, event)')

    local objects = {}

    function loadObjects()
        local result = dbPoll(dbQuery(db, 'SELECT * FROM objects'), -1)
        if result then
            if #result > 0 then 
                for i,v in ipairs(result) do
                    if not objects[v.id] then 
                        local position = fromJSON(v.position)
                        objects[v.id] = createObject(v.model, position[1], position[2], position[3], position[4], position[5], position[6])
                        setElementData(objects[v.id], 'CRP.ObjectOwner', v.owner)
                        setElementData(objects[v.id], 'CRP.ObjectID', v.id)
                        if v.event then 
                            triggerEvent(v.event, root, objects[v.id])
                        end
                    end
                end
            end
        end
    end

    
    addEvent('CRP-CreateObject', true)
    addEventHandler('CRP-CreateObject', root, function(player, model, position, event)
        local position = fromJSON(position)
        local result = dbPoll(dbQuery(db, 'SELECT * FROM objects'), -1)
        if result then 
            if #result > 0 then 
                dbExec(db, 'INSERT INTO objects VALUES (?, ?, ?, ?, ?)', (result[#result].id+1), getElementData(player, 'ID'), model, toJSON(position), event)
            else 
                dbExec(db, 'INSERT INTO objects VALUES (?, ?, ?, ?, ?)', 1, getElementData(player, 'ID'), model, toJSON(position), event)
            end
            loadObjects()
        else
            dbExec(db, 'INSERT INTO objects VALUES (?, ?, ?, ?)', 1, getElementData(player, 'ID'), model, toJSON(position), event)
            loadObjects()
        end
--        triggerEvent(event, player, )
        exports.crp_notify:addBox(player, 'Objeto adicionado com sucesso.', 'success')
    end)
    
    addEvent('CRP-DestroyObject', true)
    addEventHandler('CRP-DestroyObject', root, function(player, element)
        --local position = fromJSON(position)
        local id = getElementData(element, 'CRP.ObjectID')
        if id then
            local result = dbPoll(dbQuery(db, 'SELECT * FROM objects WHERE id = ?', id), -1)
            if result then 
                if #result > 0 then 
                    dbExec(db, 'DELETE FROM objects WHERE id = ?', id)
                    destroyElement(objects[id])
                    objects[id] = nil
                    exports.crp_notify:addBox(player, 'Objeto removido com sucesso.', 'success')
                end
            end
        end
    end)

    iprint('[OBJECTS-PREVIEW] - Conectado ao banco de dados com sucesso.')

    setTimer(function()
        loadObjects()
        iprint('[OBJECTS-PREVIEW] - Objetos carregados. ')
    end, 1000, 1)

end
