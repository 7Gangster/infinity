local db = dbConnect('sqlite', 'database.db')

if db then 

    dbExec(db, 'CREATE TABLE IF NOT EXISTS inventory (id, items, pesomax)')
    dbExec(db, 'CREATE TABLE IF NOT EXISTS bau (id, items)')
    dbExec(db, 'CREATE TABLE IF NOT EXISTS baus (id, position, model, pesomax)')

    inventario = {}
    bau = {}

    iprint('[CRP - Inventory] Conexão com banco de dados concluida com sucesso.')

    function update (player)
        if getElementData(player, 'ID') then 
            triggerClientEvent(player, 'updateInventory', player, 'player', inventario[player] or {}, getPesoPlayer (player), (getElementData(player, 'CRP.PesoMax') or 10))
        
            if not getElementData(player, 'CRP-Interagindo-Bau') then 
                if not getPedOccupiedVehicle(player) then
                    if getDropNearest ( player ) then 
                        local drops = fromJSON(getElementData(getDropNearest ( player ), 'Drops')) or {}
                        triggerClientEvent(player, 'updateInventory', player, 'drop', drops)
                    end
                end
            end

        end
    end
    addEvent('updateItems', true)
    addEventHandler('updateItems', root, update)

    addEvent("updateSlots", true)
    addEventHandler("updateSlots", root, 
        function(player, item, slot)
            if player and item and slot then
                inventario[player][item].slot = slot
            end
        end
    )

    function openInv (player)
        if getElementData(player, 'ID') then 
            triggerClientEvent(player, 'updateInventory', player, 'player', inventario[player] or {}, getPesoPlayer (player), (getElementData(player, 'CRP.PesoMax') or 10))
        
            if not getPedOccupiedVehicle(player) then
                if getDropNearest ( player ) then 
                    local drops = fromJSON(getElementData(getDropNearest ( player ), 'Drops')) or {}
                    triggerClientEvent(player, 'updateInventory', player, 'drop', drops)
                end
            else
                local vehicle = getPedOccupiedVehicle(player)
                if getVehicleType(vehicle) ~= 'Bike' and getVehicleType(vehicle) ~= 'QuadBike' and getVehicleType(vehicle) ~= 'BMX' then 
                    if getElementData(vehicle, 'Vehicle > ID') then
                        if getPedOccupiedVehicleSeat(player) == 0 or getPedOccupiedVehicleSeat(player) == 1 then
                            openBau(player, 'PORTA-LUVAS:'..getElementData(vehicle, 'Vehicle > ID'), 10, false, {
                                name = 'Porta-Luvas',
                                slots = 5,
                            })
                        end
                    end
                end
            end

        end
    end
    addEvent('openInv', true)
    addEventHandler('openInv', root, openInv)

    function updateItemHealth2 ( )
        for player in pairs(inventario) do 
            for i,v in ipairs(inventario[player]) do 
                local type = cfg.items[v.item].type
                if type then 
                    if cfg.health[type] then 
                        updateItemHealth ( player, v.item, v.health-cfg.health[type], v.id )
                    end
                end
            end
        end
        for b in pairs(bau) do 
            for i,v in ipairs(bau[b]) do 
                local type = cfg.items[v.item].type
                if type then 
                    if cfg.health[type] then 
                        updateItemHealth ( b, v.item, v.health-cfg.health[type], v.id )
                    end
                end
            end
        end
    end
    setTimer(updateItemHealth2, 60000, 0)

    addEvent('updateServerData', true)
    addEventHandler('updateServerData', root, function ( player, tabela )
        if tabela ~= {} then 

            local function getItemIndex ( id )
                for i,v in ipairs(inventario[player]) do 
                    if v.id == id then 
                        return i
                    end
                end
                return false
            end

            for i,v in ipairs(tabela) do 
                local index = getItemIndex(v.id)
                if index then 
                    inventario[player][index].slot = v.slot
                end
            end
            
        end
    end)

    function saveItems ( player )
        if inventario[player] then 
            local result = dbPoll(dbQuery(db, 'SELECT * FROM inventory WHERE id = ?', getElementData(player, 'ID')), -1)
            if #result == 0 then 
                dbExec(db, 'INSERT INTO inventory VALUES (?, ?, ?)', getElementData(player, 'ID'), toJSON(inventario[player]), 10)
            else 
                dbExec(db, 'UPDATE inventory SET items = ?, pesoMax = ? WHERE id = ?', toJSON(inventario[player]), getElementData(player, 'CRP.PesoMax') or 10, getElementData(player, 'ID'))
            end
        end
    end

    function loadItems ( player )
        local result = dbPoll(dbQuery(db, 'SELECT * FROM inventory WHERE id = ?', getElementData(player, 'ID')), -1)
        if #result == 1 then 
            local items = fromJSON(result[1].items)
            for _, itens in ipairs(items) do
                if not itens.desc and cfg.items[itens.item].desc then
                    itens.desc = cfg.items[itens.item].desc
                end
            end
            inventario[player] = items 
            setElementData(player, 'CRP.Inventory', toJSON(items))
            setElementData(player, 'CRP.PesoMax', (result[1].pesomax or 10))
            setElementData(player, 'ActionBar', true)
        else
            inventario[player] = {}
            setElementData(player, 'CRP.Inventory', toJSON({}))
            setElementData(player, 'CRP.PesoMax', 10)
            setElementData(player, 'ActionBar', true)
        end
    end

    function giveItem ( player, item, qtd, data)
        local qtd = tonumber(qtd)
        local qtd = math.floor(math.abs(qtd))
        if qtd <= 0 then return false end
        if not inventario[player] then 
            inventario[player] = {}
        end
        if cfg.items[item] then 
            if getPesoPlayer (player) + cfg.items[item].peso*qtd <= getElementData(player, 'CRP.PesoMax') then
                if getItem(player, item) == 0 or cfg.items[item].document or cfg.items[item].type == 'bau' then 
                    if not cfg.items[item].type or cfg.items[item].type ~= 'bau'then 
                        if getFreeSlot(player) <= 50 then 
                            local id = (#inventario[player] or 0)+1
                            inventario[player][id] = {
                                id = math.random(100000, 999999), 
                                item = item, nome = cfg.items[item].nome, 
                                qtd = qtd, 
                                peso = cfg.items[item].peso*qtd, 
                                health = 100, 
                                slot = getFreeSlot(player), 
                                desc = cfg.items[item].desc or "Descrição:",
                                model = cfg.items[item].model or false, 
                                arg = cfg.items[item].arg or false
                            }
                            if cfg.items[item].document then 
                                inventario[player][id]['owner'] = string.gsub(getPlayerName(player), '_', ' ')
                                inventario[player][id]['rg'] = getElementData(player, 'ID') or 'N/A'
                            end
                            if data then 
                                for i,v in pairs(data) do 
                                    inventario[player][id][i] = v
                                end
                            end
                            update ( player )
                            triggerClientEvent(player, 'notifyItem', player, item, qtd, 'Adicionado')
                        else
                            return false
                        end
                    elseif cfg.items[item].type == 'bau' then
                        for i=1,qtd do 
                            if getFreeSlot(player) <= 50 then 
                                local id = (#inventario[player] or 0)+1
                                inventario[player][id] = {
                                    id = math.random(100000, 999999), 
                                    item = item, nome = cfg.items[item].nome, 
                                    qtd = 1, 
                                    peso = cfg.items[item].peso*1, 
                                    health = 100, 
                                    slot = getFreeSlot(player), 
                                    desc = cfg.items[item].desc or "Descrição:",
                                    model = cfg.items[item].model or false, 
                                    arg = cfg.items[item].arg or false
                                }
                                if cfg.items[item].document then 
                                    inventario[player][id]['owner'] = string.gsub(getPlayerName(player), '_', ' ')
                                    inventario[player][id]['rg'] = getElementData(player, 'ID') or 'N/A'
                                end
                                if data then 
                                    for i,v in pairs(data) do 
                                        inventario[player][id][i] = v
                                    end
                                end
                                update ( player )
                                triggerClientEvent(player, 'notifyItem', player, item, 1, 'Adicionado')
                            else
                                return false
                            end
                        end
                    end
                    return true
                elseif getItem(player, item) > 0 then 
                    for i,v in ipairs(inventario[player]) do 
                        if data then 
                            if v.item == item then
                                if data.id == v.id or data.health == v.health then 
                                    inventario[player][i].qtd = v.qtd + qtd
                                    inventario[player][i].peso = v.peso + cfg.items[item].peso*qtd
                                    triggerClientEvent(player, 'notifyItem', player, item, qtd, 'Adicionado')
                                    break
                                else
                                    if getFreeSlot(player) <= 50 then
                                        local id = (#inventario[player] or 0)+1
                                        inventario[player][id] = {id = data.id or math.random(100000, 999999), item = item, nome = cfg.items[item].nome, qtd = qtd, peso = cfg.items[item].peso*qtd, desc = cfg.items[item].desc or "Descrição:", health = 100, slot = getFreeSlot(player)}
                                        if cfg.items[item].document then 
                                            inventario[player][id].owner = string.gsub(getPlayerName(player), '_', ' ')
                                            inventario[player][id]['rg'] = getElementData(player, 'ID') or 'N/A'
                                        end
                                        for k,vv in pairs(data) do 
                                            inventario[player][id][k] = vv
                                        end
                                        triggerClientEvent(player, 'notifyItem', player, item, qtd, 'Adicionado')
                                        break
                                    else 
                                        return false
                                    end
                                end
                                return true
                            end
                        end
                        if v.item == item then 
                            if not data then
                                if v.health == 100 then 
                                    inventario[player][i].qtd = v.qtd + qtd
                                    inventario[player][i].peso = v.peso + cfg.items[item].peso*qtd
                                    triggerClientEvent(player, 'notifyItem', player, item, qtd, 'Adicionado')
                                    break
                                elseif tonumber(v.health) < 100 and not data then
                                    if getFreeSlot(player) <= 50 then
                                        local id = (#inventario[player] or 0)+1
                                        inventario[player][id] = {id = math.random(100000, 999999), item = item, nome = cfg.items[item].nome, qtd = qtd, peso = cfg.items[item].peso*qtd, desc = cfg.items[item].desc or "Descrição:", health = 100, slot = getFreeSlot(player)}
                                        if cfg.items[item].document then 
                                            inventario[player][id].owner = string.gsub(getPlayerName(player), '_', ' ')
                                            inventario[player][id]['rg'] = getElementData(player, 'ID') or 'N/A'
                                        end
                                        triggerClientEvent(player, 'notifyItem', player, item, qtd, 'Adicionado')
                                        break
                                    end
                                end
                            return true
                            elseif data then 
                                if data.id == v.id or data.health == v.health then 
                                    inventario[player][i].qtd = v.qtd + qtd
                                    inventario[player][i].peso = v.peso + cfg.items[item].peso*qtd
                                    break
                                else
                                    if getFreeSlot(player) <= 50 then
                                        local id = (#inventario[player] or 0)+1
                                        inventario[player][id] = {id = data.id, item = item, nome = cfg.items[item].nome, qtd = qtd, peso = cfg.items[item].peso*qtd, desc = cfg.items[item].desc or "Descrição:", health = 100, slot = getFreeSlot(player)}
                                        if cfg.items[item].document then 
                                            inventario[player][id].owner = string.gsub(getPlayerName(player), '_', ' ')
                                            inventario[player][id]['rg'] = getElementData(player, 'ID') or 'N/A'
                                        end
                                        for k,vv in pairs(data) do 
                                            inventario[player][id][k] = vv
                                        end
                                        triggerClientEvent(player, 'notifyItem', player, item, qtd, 'Adicionado')
                                        break
                                    else
                                        return false
                                    end
                                end
                            return true
                            end
                        end
                    end
                    update ( player )
                end
            else 
                return false
            end
        else
            return false
        end
        return true
    end


    function takeItem ( player, item, qtd, id )
        local qtd = tonumber(qtd)
        local qtd = math.floor(math.abs(qtd))
        if qtd <= 0 then return false end
        if cfg.items[item] then 
            if inventario[player] then 
                for i,v in ipairs(inventario[player]) do 
                    if v.item == item then 
                        if not id then 
                            if v.qtd > qtd then 
                                inventario[player][i].qtd = v.qtd - qtd
                                inventario[player][i].peso = v.peso - cfg.items[item].peso*qtd
                                break
                            else
                                table.remove(inventario[player], i)
                                break
                            end
                        else
                            if v.id == id then 
                                if v.qtd > qtd then 
                                    inventario[player][i].qtd = v.qtd - qtd
                                    inventario[player][i].peso = v.peso - cfg.items[item].peso*qtd
                                    break 
                                else 
                                    table.remove(inventario[player], i)
                                    break 
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    function takeAllItems ( player )
        for i,v in ipairs(inventario[player]) do 
            if not cfg.blockedItems[v.item] then 
                table.remove(inventario[player], i)
            end
        end
    end

    function getItem (player, item)
        local qtd = 0
        for i,v in ipairs(inventario[player]) do 
            if v.item == item then 
                qtd = qtd + v.qtd
            end
        end
        return qtd
    end

    function getItemData ( player, item, data, value )
        for i,v in ipairs(inventario[player] or {}) do 
            if v.item == item then 
                if inventario[player][i][data] then 
                    if not value then 
                        return inventario[player][i][data]
                    else

                        if inventario[player][i][data] == value then 
                            return inventario[player][i][data]
                        end

                    end

                end
            end
        end
        return false
    end

    function setItemDescription(player, item, desc)
        for i, v in ipairs(inventario[player] or {}) do
            if v.item == item then
                local targetItem = inventario[player][i]
                if targetItem.desc then
                    if desc then
                        targetItem.desc = desc
                    else
                        targetItem.desc = cfg.items[targetItem.item].desc
                    end
                end
            end
        end
    end

    function getItemFromData ( player, item, data, value)
        for i,v in ipairs(inventario[player] or {}) do 
            if v.item == item then 
                if inventario[player][i][data] == value then 
                    return v.id
                end
            end
        end
        return false
    end

    function getPesoPlayer (player)
        local items = inventario[player] or {}
        local peso = 0
        for i,v in pairs(items) do 
            peso = peso + cfg.items[v.item].peso*v.qtd
        end
        return peso
    end

    function onLogin (player)
        loadItems ( player )
    end

    addEventHandler('onResourceStart', resourceRoot, function ( )
        for _, player in ipairs (getElementsByType('player')) do 
            if getElementData(player, 'ID') then 
                loadItems ( player )  
            end
        end
        setTimer(function ( )
            loadBau ( )
            loadShops()
            iprint('[CRP - BAU] - Baus carregados.')
            iprint('[CRP - Lojas] - Lojas carregadas.')
        end, 1000, 1)
    end)

    addEventHandler('onResourceStop', resourceRoot, function ( )
        for _, player in ipairs (getElementsByType('player')) do 
            if getElementData(player, 'ID') then 
                saveItems ( player )
            end
        end
        saveBau ( )
    end)

    addEventHandler('onPlayerQuit', root, function ( )
        saveItems ( source )
        inventario[source] = nil
    end)

    addCommandHandler('giveitem', function(player, cmd, id, item, qtd, health)
        local qtd = tonumber(qtd)
        if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Admin')) then
            if id and item and qtd then
                target = false
                if id == 'me' then 
                    target = player
                else
                    for i,v in ipairs(getElementsByType('player')) do 
                        if getElementData(v, 'ID') == tonumber(id) then
                            target = v 
                        end
                    end
                end
                giveItem(target, item, qtd, {health = tonumber(health) or 100})
                msg ( player, 'Você givou '..qtd..'x '..cfg.items[item].nome..' para o jogador '..getPlayerName(target)..'.', 'success')
                --createDiscordLogs('GIVEITEM - INVENTARIO', 'O staff **'..getPlayerName(player)..' ('..getElementData(player, 'ID')..')** givou '..qtd..'x **'..item..'** para o jogador **'..getPlayerName(target)..' ('..getElementData(target, 'ID')..')**', 'https://discord.com/api/webhooks/1163264326606532608/wxvDKs3qqKEvWa68ghcIyjSlaQ1v299aOS2q2MyIXaxI_9LHK-qkhZBPYWE1UgveDP16')
            else
                msg(player, 'Use /giveitem (id ou me) (item) (qtd)', 'error')
            end
        end
    end)

    addCommandHandler('clearinv', function(player, cmd, id)
        if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Admin')) then
            if id then
                target = false
                if id == 'me' then 
                    target = player
                else
                    for i,v in ipairs(getElementsByType('player')) do 
                        if getElementData(v, 'ID') == tonumber(id) then
                            target = v 
                        end
                    end
                end
                
                for i,v in ipairs(inventario[player]) do 
                    if not cfg.blockedItems[v.item] then 
                        inventario[player][i] = nil
                    end
                end

                update ( target )
                msg ( player, 'Você limpou o inventario do jogador '..getPlayerName(target)..'.', 'success')
                msg ( target, 'Seu inventario foi resetado.', 'warning')
                --createDiscordLogs('GIVEITEM - INVENTARIO', 'O staff **'..getPlayerName(player)..' ('..getElementData(player, 'ID')..')** givou '..qtd..'x **'..item..'** para o jogador **'..getPlayerName(target)..' ('..getElementData(target, 'ID')..')**', 'https://discord.com/api/webhooks/1163264326606532608/wxvDKs3qqKEvWa68ghcIyjSlaQ1v299aOS2q2MyIXaxI_9LHK-qkhZBPYWE1UgveDP16')
            else
                msg(player, 'Use /clearinv (id ou me)', 'error')
            end
        end
    end)



    -- << BAU >> 

    baus = {}
    pesoMax = {}
    slotMax = {}

    function openBau ( player, id, maxpeso, element, assets)
        if not bau[id] then 
            bau[id] = {}
        end
        if not pesoMax[id] or pesoMax[id] ~= maxpeso then 
            pesoMax[id] = maxpeso
        end
        if not slotMax[id] or slotMax[id] ~= (assets.slots or 50) then 
            slotMax[id] = (assets.slots or 50)
        end
        triggerClientEvent(player, 'openBau', player, id, bau[id], getPesoBau (id), pesoMax[id], element or false, assets or {} )
        if element then 
            setElementData(element, 'CRP-Interagindo-Bau', player)
            setElementData(player, 'CRP-Interagindo-Bau', element)
        end
        print(id, slotMax[id])
    end

    addEvent('interaction >> portamalas', true)
    addEventHandler('interaction >> portamalas', root, function ( player, element )
        if getElementData(element, 'Vehicle > ID') then 
            if not getElementData(element, 'CRP-Interagindo-Bau') then 
                openBau(player, getElementData(element, 'Vehicle > ID')..'-PM', cfg.portamalas[getElementModel(element)] or 1, element, {
                    name = 'Porta-Malas',
                })
            end
        end
    end)

    addEvent('casa >> bau', true)
    addEventHandler('casa >> bau', root, function ( player, element ) 
        if not getElementData(element, 'CRP-Interagindo-Bau') then 
            openBau(player, getElementDimension(player)..'-BAUCASA', 100, element)
        end
    end)

    addEvent('apartamento >> bau', true)
    addEventHandler('apartamento >> bau', root, function ( player, element ) 
        if not getElementData(element, 'CRP-Interagindo-Bau') then 
            local pesoMax = 15
            if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('VIP')) then 
                pesoMax = 30
            end
            openBau(player, getElementDimension(player)..'-APARTAMENTO', pesoMax, element, {
                name = 'Armario',
                slots = 15,
            })
        end
    end)


    addEvent('openBau', true)
    addEventHandler('openBau', root, function ( player, element )
        if getElementData(element, 'CRP-Bau') then 
            if not getElementData(element, 'CRP-Interagindo-Bau') then 
                local bauData = getElementData(element, 'CRP-Bau')

                --triggerClientEvent(player, 'openBau', player, bauData[1], bau[bauData[1]] or {}, getPesoBau (bauData[1]), bauData[2], element, {
                  --  name = bauData[3] or 'Bau',
                    --slots = bauData[4] or 50,
                ---})
                
                openBau ( player, bauData[1], bauData[2], element, {
                    name = bauData[3] or 'Bau',
                    slots = bauData[4] or 50,
                })

                setElementData(element, 'CRP-Interagindo-Bau', player)
                setElementData(player, 'CRP-Interagindo-Bau', element)
            else
                msg(player, 'O bau está sendo usado por outro jogador.', 'error', 'Aguarde...')
            end
        end
    end)

    addEvent('closeBau', true)
    addEventHandler('closeBau', root, function ( player, element )
        if element then 
            setElementData(player, 'CRP-Interagindo-Bau', nil)
            setElementData(element, 'CRP-Interagindo-Bau', nil)
        end
    end)

    function loadBau ( )

        for i,v in ipairs(cfg.baus) do 
            baus[i] = createObject(v.object, v.position[1], v.position[2], v.position[3], 0, 0, v.position[4])
            if v.invisible then 
                setElementAlpha(baus[i],0)
            end
            setElementData(baus[i], 'CRP-Bau', {i, v.pesoMax, v.nome, v.slots})
            local result = dbPoll(dbQuery(db, 'SELECT * FROM bau WHERE id = ?', i), -1)
            if #result > 0 then 
                bau[i] = fromJSON(result[1].items)
                pesoMax[i] = v.pesoMax
            else
                dbExec(db, 'INSERT INTO bau VALUES (?, ?)', i, toJSON({}))
                bau[i] = {}
                pesoMax[i] = v.pesoMax
            end
        end

        local result = dbPoll(dbQuery(db, 'SELECT * FROM bau'), -1)
        if result then 
            if #result > 0 then 
                for i,v in ipairs(result) do 
                    if not bau[v.id] then 
                        bau[v.id] = fromJSON(v.items)
                    end
                end
            end
        end

    end

    function saveBau ( )
        for i,v in pairs(bau) do 
            local result = dbPoll(dbQuery(db, 'SELECT * FROM bau WHERE id = ?', i), -1)
            if #result > 0 then 
                dbExec(db, 'UPDATE bau SET items = ? WHERE id = ?', toJSON(bau[i] or {}), i)
            else
                dbExec(db, 'INSERT INTO bau VALUES (?, ?)', i, toJSON(bau[i] or {}))
            end
        end
    end

    function updateBau (player, id)
        triggerClientEvent(player, 'updateInventory', player, 'bau', bau[id] or {}, getPesoBau(id))
    end

    function getPesoBau (id)
        local items = bau[id] or {}
        local peso = 0
        for i,v in pairs(items) do 
            peso = peso + cfg.items[v.item].peso*v.qtd
        end
        return peso
    end

    function getItemQuantityBau ( id, item )
        local qtd = 0
        for i,v in ipairs( bau[id] ) do 
            if v.item == item then 
                qtd = qtd + v.qtd
            end
        end
        return qtd
    end

    function addItemBau (player, id, data, qtd)
        local qtd = tonumber(qtd)
        local qtd = math.floor(math.abs(qtd))
        local type = cfg.items[data.img].arg or ''
        local stylo = cfg.items[data.img].style or 0
        local text = cfg.items[data.img].text or 0
        if getElementData(player, type..':Style') == stylo and getElementData(player, type..':Text') == text then return end
        if qtd <= 0 then return false end
        if bau[id] then 
            if data.qtd >= qtd then
                print(#bau[id], slotMax[id])
                if (#bau[id] or 0) + 1 > (slotMax[id] or 50) then return msg(player, 'O bau está com todos espaços ocupado', 'error') end
                if getPesoBau(id)+cfg.items[data.img].peso*qtd <= (pesoMax[id] or 0) then 
                    if getItemQuantityBau(id, data.img) == 0 or cfg.items[data.img].type == 'bau' or cfg.items[data.img].document then
                        local newItem = {
                            item = data.img,
                            id = data.id,
                            owner = data.owner or false,
                            nome = data.nome,
                            peso = cfg.items[data.img].peso*qtd,
                            vehicle = data.vehicle or false,
                            qtd = qtd,
                            health = data.health,
                        }
                        table.insert(bau[id], newItem)
                    elseif getItemQuantityBau(id, data.img) > 0 and not data.owner then
                        for i,v in ipairs(bau[id]) do 
                            if v.item == data.img then 
                                if v.health == data.health then 
                                    bau[id][i].qtd = v.qtd + qtd
                                    bau[id][i].peso = v.peso + cfg.items[data.img].peso*qtd
                                    break 
                                else
                                    local newItem = {
                                        item = data.img,
                                        id = data.id,
                                        owner = data.owner or false,
                                        nome = data.nome,
                                        peso = cfg.items[data.img].peso*qtd,
                                        vehicle = data.vehicle or false,
                                        qtd = qtd,
                                        health = data.health,
                                    }
                                    table.insert(bau[id], newItem)
                                    break
                                end
                            end
                        end
                    elseif getItemQuantityBau(id, data.img) > 0 and data.owner then 
                        local newItem = {
                            item = data.img,
                            id = data.id,
                            owner = data.owner or false,
                            nome = data.nome,
                            peso = cfg.items[data.img].peso*qtd,
                            vehicle = data.vehicle or false,
                            qtd = qtd,
                            health = data.health,
                        }
                        table.insert(bau[id], newItem)
                    end
                    takeItem(player, data.img, qtd, data.id)
                    triggerClientEvent(player, 'notifyItem', player, data.img, qtd, 'Guardou')
                    update(player)
                    updateBau (player, id)
                end
            else
                msg(player, 'O bau esta cheio.', 'error', 'Bau')
            end
        end
    end
    addEvent('addItemBau', true)
    addEventHandler('addItemBau', root, addItemBau)

    function takeItemBau(player, id, data, qtd)
        local qtd = tonumber(qtd)
        local qtd = math.floor(math.abs(qtd))
        if qtd <= 0 then return false end
        if bau[id] then 
            if getPesoPlayer (player) + cfg.items[data.img].peso*qtd <= getElementData(player, 'CRP.PesoMax') then
                for i,v in ipairs(bau[id]) do 
                    if v.id == data.id then 
                        if v.qtd > qtd then 
                            bau[id][i].qtd = v.qtd - qtd
                            bau[id][i].peso = v.peso - cfg.items[data.img].peso*qtd
                            local newItem = {
                                id = data.id,
                                owner = data.owner or false,
                                vehicle = data.vehicle or false,
                                health = data.health,
                            }
                            giveItem(player, data.img, qtd, newItem)
                            updateBau (player, id)
                            update(player)
                            break
                        else
                            local newItem = {
                                id = data.id,
                                owner = data.owner or false,
                                vehicle = data.vehicle or false,
                                health = data.health,
                            }
                            giveItem(player, data.img, data.qtd, newItem)
                            table.remove(bau[id], i)
                            updateBau (player, id)
                            update(player)
                            break
                        end
                    end
                end
            else
                msg(player, 'Você não possui espaço suficiente.', 'error')
            end
        end
    end
    addEvent('takeItemBau', true)
    addEventHandler('takeItemBau', root, takeItemBau)

    -- << Shop >>

    shop = {}

    loadShops = function()
        for i,v in ipairs(cfg.shops) do 
            if not shop[i] then 
                local ped = createPed(v.model, v.position[1], v.position[2], v.position[3], v.position[4])
                setElementData(ped, 'shop', i)
                shop[i] = ped
                if v.blip then 
                    createBlipAttachedTo(shop[i], v.blip)
                end
                setElementFrozen(shop[i], true)
            end
        end
        setTimer(function()
            for i,v in ipairs(getElementsByType('ped')) do 
                if getElementData(v, 'shop') then
                    setElementHealth(v, 100)
                end
            end
        end, 5000, 0)
    end

    addEvent('openShop', true)
    addEventHandler('openShop', root, function(player, element)
        if client then 
            player = client
        end
        local id = getElementData(element, 'shop')
        local v = cfg.shops[id]
        if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup((v.acl or 'Everyone'))) then
            triggerClientEvent(player, 'openShop', player, v.items, v.name, v.type)
        end
    end)

    --[[addEventHandler('onElementClicked', root, function(b, s, player)
        if getElementData(source, 'shop') then
            triggerEvent('openShop', player, player, source)
        end
    end)]]--

    addEvent('buyorsell', true)
    addEventHandler('buyorsell', root, function(player, type, item, qtd, preco, data)
        if client then 
            player = client
        end
        if tonumber(qtd) <= 0 then return end
        if type == 'buy' then 
            if getPlayerMoney(player) >= preco then
                local giveItem = giveItem(player, item, qtd)
                if giveItem then 
                    takeItem(player, 'dinheiro', preco)
                    msg(player, 'Você comprou '..qtd..'x '..cfg.items[item].nome..' por R$ '..formatNumber(preco, '.'), 'success')
                end
            end
        elseif type == 'sell' then
            if getItem(player, item) >= qtd then 
                takeItem(player, item, qtd)
                giveItem(player, 'dinheiro', preco)
                msg(player, 'Você vendeu '..qtd..'x '..cfg.items[item].nome..' por R$ '..formatNumber(preco, '.'), 'success')
            end
        end
    end)


    -- << DROPS >>

    drops = {}

    addEvent('dropItem', true)
    addEventHandler('dropItem', root, function  ( player, data, qtd )
        if data.qtd >= qtd then
            local type = cfg.items[data.img].arg or '0'
            local stylo = cfg.items[data.img].style or 0
            local text = cfg.items[data.img].text or 0
            if getElementData(player, type..':Style') == stylo and getElementData(player, type..':Text') == text then return end
            if not getDropNearest ( player ) then
                local x, y, z = getElementPosition(player) 
                local id = #drops+1
                drops[id] = createMarker(x, y, z, 'cylinder', 3, 0, 0, 0, 0)
                setElementData(drops[id], 'Drops', toJSON({}))
                setElementData(drops[id], 'ID', id)
                setTimer(function()
                    destroyElement(drops[id])
                    drops[id] = nil
                end, 60000*5, 1)
            end
            local drop = getDropNearest ( player )
            local dropsTable = fromJSON(getElementData(drop, 'Drops')) or {}
            local item = { 
                item = data.img,
                qtd = qtd,
                peso = data.peso,
                health = data.health,
                nome = data.nome, 
                owner = data.owner or false,
                vehicle = data.vehicle or false,
                rg = data.rg or false,
                id = data.id
            }
            table.insert(dropsTable, item)
            setElementData(drop, 'Drops', toJSON(dropsTable))
            setPedAnimation(player, "BOMBER", "BOM_Plant", -1, false, false, false, false)
            takeItem(player, data.img, qtd, data.id)
            triggerClientEvent(player, 'notifyItem', player, data.img, qtd, 'Descartou')
            update ( player )
            msg(player, 'Você dropou '..qtd..'x '..data.nome, 'success')
        end
    end)

    addEvent('takeDropItem', true)
    addEventHandler('takeDropItem', root, function ( player, item, qtd, data )
        local drop = getDropNearest ( player )
        if drop then 
            local dropsTable = fromJSON(getElementData(drop, 'Drops')) or {}
            local dropID = getElementData(drop, 'ID')
            for i,v in ipairs(dropsTable) do 
                if v.id == data.id then 
                    if qtd < v.qtd then 
                        dropsTable[i].qtd = v.qtd - qtd
                        dropsTable[i].peso = v.peso - cfg.items[v.item].peso*qtd
                        local newItem = {
                            owner = data.owner or false,
                            id = data.id or false,
                            health = data.health or false,
                            vehicle = data.vehicle or false,
                            rg = data.rg or false,
                        }
                        giveItem(player, v.item, qtd, newItem)
                        setElementData(drop, 'Drops', toJSON(dropsTable))
                        update ( player )
                        break 
                    else
                        table.remove(dropsTable, i)
                        local newItem = {
                            owner = data.owner or false,
                            id = data.id or false,
                            health = data.health or false,
                            vehicle = data.vehicle or false,
                            rg = data.rg or false,
                        }
                        giveItem(player, v.item, qtd, newItem)
                        setElementData(drop, 'Drops', toJSON(dropsTable))
                        update ( player )
                        if #dropsTable == 0 then 
                            destroyElement(drop)
                            drops[dropID] = nil
                        end 
                        break
                    end
                end
            end
        end
    end)

    addEvent('sendItem', true)
    addEventHandler('sendItem', root, function ( player, item, qtd )

        if qtd <= item.qtd then 

            local target = false 

            for i,v in ipairs(getElementsByType('player')) do 
                local x, y, z = getElementPosition (player)
                if getDistanceBetweenPoints3D(x, y, z, unpack({getElementPosition(v)})) <= 3 then 
                    if v ~= player then 
                        target = v
                        break
                    end
                end
            end

            if target then 

                if getPesoPlayer (target) + cfg.items[item.img].peso*qtd <= getElementData(target, 'CRP.PesoMax') then
                    local newItem = { 
                        item = item.img,
                        qtd = qtd,
                        peso = item.peso,
                        health = item.health,
                        nome = item.nome, 
                        owner = item.owner or false,
                        vehicle = item.vehicle or false,
                        id = item.id,
                        rg = item.rg or false,
                    }
                    takeItem(player, item.img, qtd, item.id)
    
                    giveItem(target, item.img, qtd, newItem)

                    triggerClientEvent(player, 'notifyItem', player, item.img, qtd, 'Enviou')
                    setPedAnimation(player, "GANGS","prtial_hndshk_biz_01",3000,true,false,false,false)
                    setPedAnimation(target, "GANGS","prtial_hndshk_biz_01",3000,true,false,false,false)

                    update ( player )
                else
                    exports.crp_notify:addBox(player, 'O mesmo não possui espaço suficiente em sua mochila.', 'error')
                end

            else
                exports.crp_notify:addBox(player, 'Nenhuma pessoa próxima.', 'error')
            end
        else
            exports.crp_notify:addBox(player, 'Insira uma quantidade válida.', 'error')
        end
    end)

    -- HEALTH MANAGER
    function getItemHealth ( player, item, id )
        local health = 100
        if not id then 
            for i,v in ipairs(inventario[player]) do 
                if v.item == item then 
                    health = v.health 
                end
            end
        else
            for i,v in ipairs(inventario[player]) do 
                if v.id == id then 
                    health = v.health 
                end
            end
        end
        return health
    end

    function updateItemHealth ( player, item, health, id )
        if isElement(player) and getElementType(player) == 'player' then 
            if not id then 
                for i,v in ipairs(inventario[player]) do 
                    if v.item == item then 
                        if inventario[player][i].health > 0 then
                            inventario[player][i].health = health
                        else
                            inventario[player][i].health = 0
                        end
                        break
                    end
                end
            else
                for i,v in ipairs(inventario[player]) do 
                    if v.id == id then 
                        if inventario[player][i].health > 0 then
                            inventario[player][i].health = health
                        else
                            inventario[player][i].health = 0
                        end
                        break
                    end
                end
            end
        elseif type(player) == 'string' then 
            if not id then 
                for i,v in ipairs(bau[player]) do 
                    if v.item == item then 
                        bau[player][i].health = health
                        if health <= 0 then 
                            table.remove(bau[player], i)
                        end
                        break
                    end
                end
            else
                for i,v in ipairs(bau[player]) do 
                    if v.id == id then 
                        bau[player][i].health = health
                        if health <= 0 then 
                            table.remove(bau[player], i)
                        end
                        break
                    end
                end
            end
        end
    end


    local delay = {}
    
    -- << REVIST >>
    addEvent('interaction >> revistar', true)
    addEventHandler('interaction >> revistar', root, function ( player, element )
        if element then
            if inventario[element] then 
                msg(player, 'Revistando ...', 'info')
                triggerClientEvent(player, 'ProgressBar', player, 5000)
                msg(element, 'Você está sendo revistado pelo jogador '..string.gsub(getPlayerName(player), '_', ' ')..' ('..getElementData(player, 'ID')..')', 'warning')
                if not delay[player] then
                    delay[player] = setTimer(function ( )
                        local x, y, z = getElementPosition(player)
                        local x2, y2, z2 = getElementPosition(element)
                        if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 3 then
                            triggerClientEvent(player, 'openRevistar', player, inventario[element], getPesoPlayer(element), getElementData(element, 'CRP.PesoMax'), element)
                        else
                            msg(player, 'O jogador esta muito distante.', 'warning')
                        end
                        delay[player] = nil
                    end, 5000, 1)
                end
            else
                msg(player, 'A mochila do jogador está vazia.', 'warning')
            end
        else
            msg(player, 'Nenhum jogador encontrado.', 'error')
        end
    end)

    addEvent('revistar >> takeItem', true)
    addEventHandler('revistar >> takeItem', root, function(player, data, qtd, target)
        local qtd = tonumber(qtd)
        local qtd = math.floor(math.abs(qtd))
        if qtd <= 0 then return false end
        if getElementData(player, 'police >> duty') then 
            if getPesoPlayer (player) + cfg.items[data.img].peso*qtd <= getElementData(player, 'CRP.PesoMax') then
                takeItem(target, data.img, qtd, data.id)
                giveItem(player, data.img, qtd, {
                    id = data.id,
                    owner = data.owner,
                    vehicle = data.vehicle,
                    rg = data['rg'],
                })
                triggerClientEvent(player, 'updateInventory2', player, inventario[target], getPesoPlayer(target), getElementData(target, 'CRP.PesoMax'), 'Revist')
            end
        end
    end)


else
    iprint('[CRP - Inventory] Erro ao se conectar ao banco de dados. Script desligando.')
    stopResource(getThisResource())
end

function getFreeSlot(player)
    local dados = inventario[player] or {}
    if #dados ~= 0 then
        Index = 0
        while true do
            Index = Index +1
            Liberado = true
            for i,v in pairs(dados) do
                if v.slot == Index then
                    Liberado = false
                end
            end
            if Liberado then
                return Index
            end
        end
    else
        return 1
    end
end

function msg ( player, msg, type, title)
    exports.crp_notify:addBox (player, msg, type)
end

function getDropNearest ( player )
    for i,v in ipairs(drops) do 
        local x, y, z = getElementPosition(player)
        local x2, y2, z2 = getElementPosition(v)
        if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 3 then 
            return v
        end
    end
    return false
end

function getPlayerMoney ( player )
    return getItem(player, 'dinheiro') or 0
end

function givePlayerMoney ( player, amount )
    return giveItem(player, 'dinheiro', amount) or false
end

function takePlayerMoney ( player, amount )
    return takeItem(player, 'dinheiro', amount) or false
end