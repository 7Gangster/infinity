local db = exports.crp_mysql:getConnection()

if db then 

    iprint('[CRP - CHARACTERS] Conectado ao banco de dados com sucesso.')

    addEvent('getCharacters', true)
    addEventHandler('getCharacters', root, function(player)
        local result = dbPoll(dbQuery(db, 'SELECT * FROM crp_characters WHERE serial = ?', getPlayerSerial(player)), -1)
        if #result > 0 then 
            local characters = {}
            for i, v in ipairs(result) do 
                local clothes, pele = exports.agatreix_custom:getRoupas(v.id, v.gender)
                table.insert(characters, {
                    nome = v.nome,
                    id = v.id, 
                    skin = v.gender, 
                    clothes = clothes, 
                    pele = pele,
                })
            end
            triggerClientEvent(player, 'loadCharacters', player, characters)
        end
    end)

    
    addEvent('createCharacter', true)
    addEventHandler('createCharacter', root, function(player, nome, sobrenome, idade, gender)

        local nome = nome..'_'..sobrenome
        local user = generateRandomString ( 12 )
        
        logOut(player)
        local account = addAccount(user, '@classrppassword1238594')
        dbExec(db, 'INSERT INTO crp_characters VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', nil, nome, tonumber(gender), 1000, toJSON({1433.861328125,2640.0048828125,11.392612457275, 0, 0, 0}), 100, 0, 100, 100, 'false', 'false', toJSON({}), user, getPlayerSerial(player))
        

        setTimer(function()
            local result = dbPoll(dbQuery(db, 'SELECT * FROM crp_characters WHERE user = ?', user), -1)
            if #result > 0 then
                login(player, result[1].id)
            end
        end, 5000, 1)

    end)

    addEvent('deleteCharacter', true)
    addEventHandler('deleteCharacter', root, function(player, id)

        dbExec(db, 'DELETE FROM crp_characters WHERE id = ?', id)
        exports.crp_notify:addBox(player, 'Você deletou o personagem com sucesso.', 'success')

    end)



    function login (player, id)
        local result = dbPoll(dbQuery(db, 'SELECT * FROM crp_characters WHERE id = ?', id), -1)
        if #result > 0 then 
            local x, y, z, rz, interior, dimensao = unpack(fromJSON(result[1].position))
            local health, armor, money, fome, sede = result[1].health, result[1].armor, tonumber(result[1].money), tonumber(result[1].fome), tonumber(result[1].sede)
            
            print(result[1].user)

            logIn(player, getAccount(result[1].user), '@classrppassword1238594')

            setCameraTarget(player)
            spawnPlayer(player, x, y, z, rz, result[1].gender, (interior or 0), (dimensao or 0))
            setPlayerName(player, result[1].nome)
            givePlayerMoney(player, money)
            setElementHealth(player, health)
            setPedArmor(player, armor)

            local nome = tostring(result[1].nome):gsub ('_', ' ')
            print(nome)
            setElementData(player, 'Nome', nome)
            setElementData(player, 'fome', fome)
            setElementData(player, 'sede', sede)
            setElementData(player, 'ID', result[1].id)

            exports.agatreix_custom:onLogin(player)
            exports.crp_inventory:loadItems(player)

            setPlayerBlurLevel ( player, 0 )
            setPlayerNametagShowing(player, false)

            exports.crp_laptop:onLogin(player)

            exports.crp_hud:setVisible(player, true)
            triggerEvent('updateItems', player, player)

        end
    end
    addEvent('loginCharacter', true)
    addEventHandler('loginCharacter', root, login)

    addEventHandler('onPlayerQuit', root, function()
        if not isGuestAccount(getPlayerAccount(source)) then 
            if getElementData(source, 'ID') then 
                local id = getElementData(source, 'ID')
                local x, y, z = getElementPosition(source)
                local rx, ry, rz = getElementRotation(source)
                local int, dim = getElementDimension(source)
                local fome = getElementData(source, 'fome') or 100
                local sede = getElementData(source, 'sede') or 100
                local position = toJSON({x, y, z, rz, int, dim})
                dbExec(db, 'UPDATE crp_characters SET position = ?, money = ?, fome = ?, sede = ?, health = ?, armor = ? WHERE id = ?', position, getPlayerMoney(source), fome, sede, getElementHealth(source), getPedArmor(source), id)
            
                exports.crp_laptop:onQuit(source)
            end
        end
    end)

    addEventHandler('onPlayerChangeNick', root, function ( )
        cancelEvent ()
    end)

end

setTimer(function()
    for i, player in ipairs(getElementsByType('player')) do 
        if not getElementData(player, 'Preso') and not getElementData(player, 'player >> caido') then 
            if not isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('VIP')) then
                local fome = (getElementData(player, 'fome') or 100)
                if (fome - 2) > 10 then 
                    setElementData(player, 'fome', fome - 2)
                else
                    setElementData(player, 'fome', fome - 2)
                    exports['crp_notify']:addBox(player, 'Você está passando mal.', 'warning')
                    setElementHealth( player, getElementHealth( player ) -2 )
                    setElementData(player, 'Stress', (getElementData(player, 'Stress') or 0) +5)
                end

                local sede = (getElementData(player, 'sede') or 100)
                if (sede - 1.5) > 10 then 
                    setElementData(player, 'sede', sede - 1.5)
                else
                    setElementData(player, 'sede', sede - 1.5)
                    exports['crp_notify']:addBox(player, 'Você está passando mal.', 'warning')
                    setElementHealth( player, getElementHealth( player ) -2 )
                    setElementData(player, 'Stress', (getElementData(player, 'Stress') or 0) +5)
                end
            else
                local fome = (getElementData(player, 'fome') or 100)
                if (fome - 2) > 10 then 
                    setElementData(player, 'fome', fome - 1)
                else
                    setElementData(player, 'fome', fome - 1)
                    exports['crp_notify']:addBox(player, 'Você está passando mal.', 'warning')
                    setElementHealth( player, getElementHealth( player ) -2 )
                    setElementData(player, 'Stress', (getElementData(player, 'Stress') or 0) +5)
                end

                local sede = (getElementData(player, 'sede') or 100)
                if (sede - 1.5) > 10 then 
                    setElementData(player, 'sede', sede - 0.75)
                else
                    setElementData(player, 'sede', sede - 0.75)
                    exports['crp_notify']:addBox(player, 'Você está passando mal.', 'warning')
                    setElementHealth( player, getElementHealth( player ) -2 )
                    setElementData(player, 'Stress', (getElementData(player, 'Stress') or 0) +5)
                end
            end
        end
    end
end, 60000*2, 0)

function generateRandomString ( max )
  local str = ''
  local letters = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'}
  for key = 1, max do 
    local random =  math.random(1, max)
    str = str..letters[random]
  end
  return str
end