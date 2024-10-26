modelObject = {}
boneAnimation = {}

 addEventHandler("onResourceStart", resourceRoot,
 function()
     db = dbConnect("sqlite", "dados.db")
     dbExec(db, "CREATE TABLE IF NOT EXISTS AnimFav(account, animName, animData, animImage)")
     if config["Mensagem Start"] then
         outputDebugString("["..getResourceName(getThisResource()).."] Startado com sucesso!")
     end
 end)

addEvent('JOAO.stopAnimation', true)
addEventHandler('JOAO.stopAnimation', root,
function(player)
    if player and isElement(player) then
        if isElement(modelObject[player]) then
            destroyElement(modelObject[player])
        end
        toggleControl(player, 'fire', true)
        toggleControl(player, 'jump', true)
        toggleControl(player, 'enter_passenger', true)
        setPedAnimation(player, nil)
        triggerClientEvent(root, 'JOAO.stopAnimationsClient', player, player)
    end
end)

function setAnim(player, nome, anim, tipo, int)
    if not getPedOccupiedVehicle(player) then
        if tipo == 'ESTILO DE ANDAR' then
            if not isPedInVehicle(player) then
                setPedWalkingStyle(player, tonumber(anim))
                notifyS(player, 'Você mudou seu estilo de andar para '..nome..'.', 'info')
            end
        elseif tipo ~= 'ESTILO DE ANDAR' then 
            if int == 'IFP' then 
                triggerClientEvent(root, 'JOAO.setarAnimacao', player, player, anim)
                notifyS(player, 'Você ativou a animação '..nome..'.', 'info')
            elseif int == 'Custom' then
                local table = config["CUSTOM_ANIMATIONS"][anim[1]][anim[2]]
                if table then
                    if table.blockAttack then
                        toggleControl(player, 'fire', false)
                    end
                    if table.blockJump then
                        toggleControl(player, 'jump', false)
                    end
                    if table.blockVehicle then
                        toggleControl(player, 'enter_passenger', false)
                    end
                    if table.BonesRotation then
                        if boneAnimation[player] then
                            triggerClientEvent(root, 'JOAO.stopAnimationsClient', player, player)
                            boneAnimation[player] = false
                        end
                        boneAnimation[player] = true
                        triggerClientEvent(root, 'JOAO.setAttachPosition', player, player, table.BonesRotation)
                        if not table.Object then notifyS(player, 'Você ativou a animação '..nome..'.', 'info') end

                    end
                    if table.Object then
                        if isElement(modelObject[player]) then
                            destroyElement(modelObject[player])
                        end
                        modelObject[player] = createObject(table.Object.Model, getElementPosition(player))
                        if table.Object.Scale then
                            setObjectScale(modelObject[player], table.Object.Scale)
                        end
                        setElementCollisionsEnabled(modelObject[player], false)
                        exports['pAttach']:attach(modelObject[player], player, unpack(table.Object.Offset))
                        notifyS(player, 'Você pegou o objeto '..nome..'.', 'info')
                    end
                end
            elseif int == 'Padrao' then
                setPedAnimation(player, unpack(anim))
                notifyS(player, 'Você ativou a animação '..nome..'.', 'info')
            end
        end
    end
end
addEvent('JOAO.setAnimation', true)
addEventHandler('JOAO.setAnimation', root, setAnim)

--[[
for i,v in pairs(config['Animations']['INTERAÇÕES']) do 
    addCommandHandler(v[2], 
        function(player)
            setAnim(player, v[1], v[3], v[4], v[4])
        end
    )
end]]

addCommandHandler('e', function(player, cmd, anim)
    for i,v in pairs(config['Animations']['INTERAÇÕES']) do 
        if v[2] == anim then
            setAnim(player, v[1], v[3], v[4], v[4])
            break
        end
    end
end)

addEventHandler('onPlayerWasted', root, function ()
    if isElement(modelObject[source]) then
        destroyElement(modelObject[source])
    end
    toggleControl(source, 'fire', true)
    toggleControl(source, 'jump', true)
    toggleControl(source, 'enter_passenger', true)
    setPedAnimation(source, nil)
    triggerClientEvent(root, 'JOAO.stopAnimationsClient', root, source)
end)

addEventHandler('onPlayerQuit', root, function ()
    if isElement(modelObject[source]) then
        destroyElement(modelObject[source])
    end
    toggleControl(source, 'fire', true)
    toggleControl(source, 'jump', true)
    toggleControl(source, 'enter_passenger', true)
    setPedAnimation(source, nil)
    triggerClientEvent(root, 'JOAO.stopAnimationsClient', root, source)
end)

addEvent("JOAO.verifyACLVips", true)
addEventHandler("JOAO.verifyACLVips", root,
function(player, index, nameCategory)
    if isPlayerInACL(player) then
        triggerClientEvent(player, "JOAO.changeWindowAnimation", player, index, nameCategory)
    else
        notifyS(player, "Você não tem VIP!", "error")
    end
end)

 addEvent("JOAO.favoriteAnimation", true)
 addEventHandler("JOAO.favoriteAnimation", root,
 function(player, animTable, typeA, selectK, categorya)
     if typeA == "colocar" then
         local result = dbPoll(dbQuery(db, "SELECT * FROM AnimFav WHERE account = ? AND animName = ?", getAccountName(getPlayerAccount(player)), animTable[1]), -1)
         local result2 = dbPoll(dbQuery(db, "SELECT * FROM AnimFav WHERE account = ?", getAccountName(getPlayerAccount(player))), -1)
         if #result >= 1 then
             dbExec(db, 'DELETE FROM AnimFav WHERE account = ? AND animName = ?', getAccountName(getPlayerAccount(player)), animTable[1])
             notifyS(player, "Você retirou a animação "..animTable[1].." dos favoritos!", "success")
         else
             if #result2 >= 5 then
                 notifyS(player, "Retire alguma animação para favoritar outra!", "error")
             else
                 animTable.category = categorya
                 dbExec(db, 'INSERT INTO AnimFav(account, animName, animData, animImage) VALUES(?, ?, ?, ?)', getAccountName(getPlayerAccount(player)), animTable[1], toJSON(animTable), selectK)
                 notifyS(player, "Você favoritou essa animação com sucesso!", "success")
             end
         end
     else
         local result = dbPoll(dbQuery(db, "SELECT * FROM AnimFav WHERE account = ? AND animName = ?", getAccountName(getPlayerAccount(player)), animTable[1]), -1)
         if #result >= 1 then
             dbExec(db, 'DELETE FROM AnimFav WHERE account = ? AND animName = ?', getAccountName(getPlayerAccount(player)), animTable[1])
             notifyS(player, "Você retirou a animação "..animTable[1].." dos favoritos!", "success")
         end
     end
     consultFavorites(player)
 end)

 function consultFavorites(player)
     local result = dbPoll(dbQuery(db, "SELECT * FROM AnimFav WHERE account = ?", getAccountName(getPlayerAccount(player))), -1)
     triggerClientEvent(player, "JOAO.sendFavorites", player, result)
 end
 addEvent("JOAO.consultFavorites", true)
 addEventHandler("JOAO.consultFavorites", root, consultFavorites)

function isPlayerInACL(player)
    for i, v in ipairs(config["ACLs VIPs"]) do
        if aclGetGroup(v) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup(v)) then
            return true
        end
    end
    return false
end

function getPlayerFromID(id)
    if tonumber(id) then
        for _, player in ipairs(getElementsByType('player')) do
            if getElementData(player, 'ID') and (getElementData(player, 'ID') == tonumber(id)) then
                return player
            end
        end
    end
    return false
end