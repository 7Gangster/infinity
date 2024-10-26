db = exports.crp_mysql:getConnection()

function banir (player, cmd, id, time, ...)
    cancelEvent()
    local reason = table.concat ( { ... }, " " )
    if id and time and reason then
        local id = tonumber(id)
        local target = IDSystem():getPlayerByID(id)
        if ( hasObjectPermissionTo ( player, "function.banPlayer" ) ) then
            print(reason)
            if target then 
                banPlayer ( target, true, false, true, 'Class Roleplay', (reason or 'Você foi banido'), ((time or 1)*86400) )
                exports.crp_notify:addBox(player, 'Você baniu o jogador de id '..id..' com sucesso.', 'success')
            else
                dbExec(db, 'INSERT INTO crp_bans VALUES (?, ?, ?)', id, (reason or 'Você foi banido'), ((time or 1)*86400))
                exports.crp_notify:addBox(player, 'Você baniu o jogador de id '..id..' com sucesso.', 'success')
            end
        end
    end
end
addCommandHandler('ban', banir)
addCommandHandler('banir', banir)


function checkBan (player)
    local result = dbPoll(dbQuery(db, 'SELECT * FROM crp_bans'), -1)
    if result and #result > 0 then 
        for i,v in ipairs(result) do 
            if v.id == getElementData(player, 'ID') then
                banPlayer ( player, true, false, true, 'Class Roleplay', (v.reason or 'Você foi banido'), v.time )
                dbExec(db, 'DELETE FROM crp_bans WHERE id = ?', getElementData(player, 'ID'))
            end
        end
    end
end

addEventHandler('onPlayerLogin', root, function()
    checkBan(source)
end)