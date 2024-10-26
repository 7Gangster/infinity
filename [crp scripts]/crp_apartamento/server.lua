local entrar_ap = exports.crp_markers:createMarker('marker', Vector3(1654.1278076172,-1655.0198974609,22.515625-0.9))
local sair_ap = exports.crp_markers:createMarker('marker', Vector3(223.13, 1287.352, 1082.141))
local bau = createMarker(229.109, 1287.078, 1082.141, 'cylinder', 1.2, 0, 0, 0, 0)
createBlipAttachedTo(entrar_ap, 61)
setElementInterior(bau, 1)
setElementInterior(sair_ap, 1)



function msg(player, msg, type)
    exports.crp_notify:addBox(player, msg, type)
end

addEventHandler('onMarkerHit', root, function(player)
    if getElementType(player) == 'player' then 
        if not isPedInVehicle(player) then 
            if source == entrar_ap then
                bindKey(player, 'e', 'down', entrar)
                exports.crp_notify:addBox(player, 'Pressione E para entrar em seu apartamento.', 'info')
            elseif source == sair_ap then
                bindKey(player, 'e', 'down', sair)
                exports.crp_notify:addBox(player, 'Pressione E para sair de seu apartamento.', 'info')
            elseif source == bau then 
                bindKey(player, 'e', 'down', abrir_bau, source)
                exports.crp_notify:addBox(player, 'Pressione E para abrir seu armario.', 'info')
            end
        end
    end
end)

addEventHandler('onMarkerLeave', root, function(player)
    if getElementType(player) == 'player' then 
        if source == entrar_ap then
            unbindKey(player, 'e', 'down', entrar)
        end
        if source == sair_ap then
            unbindKey(player, 'e', 'down', sair)
        end
        if source == bau then
            unbindKey(player, 'e', 'down', abrir_bau)
        end
    end
end)

function entrar (player)
    unbindKey(player, 'e', 'down', entrar)
    fadeCamera(player, false)
    setTimer(fadeCamera, 2000, 1, player, true)
    setTimer(function()
        setElementInterior(player, 1)
        setElementPosition(player, 223.051, 1288.001, 1082.141)
        setElementDimension(player, getElementData(player, 'ID'))
    end, 1000, 1)
    createDiscordLogs('ENTROU', 'O jogador **'..getPlayerName(player)..' ('..getElementData(player, 'ID')..')** entrou em seu apartmaneto.', 'https://discord.com/api/webhooks/1163524719086153829/bloMPDFhYhvI1K3mq30pVynhi5rsZeWQ2A6ENXfNffbLyfAoNGEpEZJld2ojcIqMff7l')
end

function sair (player)
    unbindKey(player, 'e', 'down', sair)
    fadeCamera(player, false)
    setTimer(fadeCamera, 2000, 1, player, true)
    setTimer(function()
        setElementInterior(player, 0)
        setElementPosition(player, 1654.1278076172,-1655.0198974609,22.515625)
        setElementDimension(player, 0)
    end, 1000, 1)
    createDiscordLogs('SAIU', 'O jogador **'..getPlayerName(player)..' ('..getElementData(player, 'ID')..')** saiu de seu apartmaneto.', 'https://discord.com/api/webhooks/1163524719086153829/bloMPDFhYhvI1K3mq30pVynhi5rsZeWQ2A6ENXfNffbLyfAoNGEpEZJld2ojcIqMff7l')
end

function abrir_bau (player, b, s, element)
    triggerEvent('apartamento >> bau', player, player, element)
end

function createDiscordLogs(title, description, link, image)
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
    fetchRemote(link, {["queueName"] = "logs", ["connectionAttempts"] = 5, ["connectTimeout"] = 5000, ["headers"] = {["Content-Type"] = "application/json"}, ['postData'] = data}, function() end);
end



function getPlayerItems(player)
    local result = exports.crp_items:getAllItems(player) or {}
    local items = {}
    for i,v in pairs(result) do 
        table.insert(items, {item=i, peso=v.peso, qtd=v.qtd})
    end
    return items
end