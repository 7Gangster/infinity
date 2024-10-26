clothes = {}

local db = dbConnect('sqlite', 'src/assets/data.db')
dbExec(db, 'CREATE TABLE IF NOT EXISTS clothes (id, skin, clothes)')


function setPlayerClothe ( player, variavel, stylo, text )
    if roupas_categorias[getElementModel(player)][variavel][stylo] or stylo < 1 then 
        triggerClientEvent(root, 'setPlayerRoupa', root, player, variavel, stylo, text)
        if not clothes[player] then 
            clothes[player] = {}
        end
        clothes[player][variavel] = {stylo, text}
        print('roupa setada')
    else
        print('Roupa inexistente')
    end
end
addEvent('setPlayerClothe', true)
addEventHandler('setPlayerClothe', root, setPlayerClothe)

function loadPlayerClothes ( player , clth )
    if clth then 
        triggerClientEvent(root, 'setPlayerClothe', root, player, clth)
    end
end

function saveClothes ( player )
    if clothes[player] then 
        local roupas = dbPoll(dbQuery(db, 'SELECT * FROM clothes WHERE id = ?', getElementData(player, 'ID')), -1)
        if #roupas == 0 then 
            dbExec(db, 'INSERT INTO clothes VALUES (?, ?, ?)', tonumber(getElementData(player, 'ID')), getElementModel(player), toJSON(clothes[player]))
        else
            if getElementModel(player) == tonumber(roupas[1].skin) then
                dbExec(db, 'UPDATE clothes SET clothes = ? WHERE id = ?', toJSON(clothes[player]), tonumber(getElementData(player, 'ID')))
            end
        end
    end
end

function onQuit ( player )
	if clothes[player] then 
        saveClothes ( player )
		clothes[player] = nil
	end
end

function onLogin ( player )
    local roupas = dbPoll(dbQuery(db, 'SELECT * FROM clothes WHERE id = ?', getElementData(player, 'ID')), -1)
    if #roupas > 0 then 
        local playerClothes = fromJSON(roupas[1].clothes)
        clothes[player] = playerClothes
        setElementModel(player, tonumber(roupas[1].skin)) 
        local roupa = fromJSON(getAccountData(getPlayerAccount(player), 'roupas:antigas'))
        if roupa then
            clothes[player] = roupa
            loadPlayerClothes ( player, roupa )
            setAccountData(getPlayerAccount(player), 'roupas:antigas', nil)
        end
        setTimer(function()
            loadPlayerClothes ( player, playerClothes )
            for i,v in ipairs(getElementsByType('player')) do
                if v ~= player then
                    loadPlayerClothes ( v, getClothes(v) )
                end
            end
        end, 1000, 1)
    else
        setTimer(function()
            triggerClientEvent(player, 'openCreatePersonage', player)
            for i,v in ipairs(getElementsByType('player')) do
                if v ~= player then
                    loadPlayerClothes ( v, clothes[v] )
                end
            end
        end, 1000, 1)
    end
end

function setClothes(element, table)
    triggerClientEvent(root, 'setPlayerClothe', root, element, table)
    clothes[element] = table
end

addEvent('SpawnPlayer', true)
addEventHandler('SpawnPlayer', root, function(player, skin, clothes, cor)
    local roupas = dbPoll(dbQuery(db, 'SELECT * FROM clothes WHERE id = ?', getElementData(player, 'ID')), -1)
    if #roupas == 0 then 
        dbExec(db, 'INSERT INTO clothes VALUES (?, ?, ?)', getElementData(player, 'ID'), skin, toJSON(clothes))
        setAccountData(getPlayerAccount(player), 'tomdepele', cor)
    end
        fadeCamera(player, false)
        setTimer(function()
            setElementPosition(player, 824.72222900391,-1354.3980712891,13.538647651672)
            setElementModel(player, skin)
            setCameraTarget(player)
            triggerClientEvent(root, 'setPlayerClothe', root, player, clothes)
            clothes[player] = clothes
            fadeCamera(player, true)
        end, 1000, 1)
end)

function getClothes (player)
    return clothes[player]
end

addEventHandler('onPlayerQuit', root, 
function()
    onQuit ( source )
end)

addEventHandler('onPlayerLogin', root, 
function()
    onLogin ( source )
end)