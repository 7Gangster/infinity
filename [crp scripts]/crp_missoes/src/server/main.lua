peds = {}
rota = {}
markers = {}
coletando = {}

for i,v in ipairs(Config.Missoes) do 
    peds[i] = createPed(v.model, v.position[1], v.position[2], v.position[3], v.position[4])
    setElementData(peds[i], 'mission', v.type)
    for k, vv in ipairs(Config.Types[v.type].markers) do 
        if not markers[v.type] then 
            markers[v.type] = {}
        end
        markers[v.type][k] = createMarker(vv[1], vv[2], vv[3], 'cylinder', 1.2, 255, 0, 0, 45)
        setElementVisibleTo(markers[v.type][k], root, false)
        setElementData(markers[v.type][k], 'mission', v.type)
    end
end

addEvent('startMission', true)
addEventHandler('startMission', root, function(player, element)
    local type = getElementData(element, 'mission')
    if not rota[player] then
        if Config.Types[type] then 
            if type == 'Hacker' then
                if exports.crp_items:getItem(player, 'pendrive') >= 1 and exports.crp_items:getItem(player, 'celular') >= 1 then
                    local random = math.random(1, #Config.Types[type].markers)
                    local x, y = getElementPosition(markers[type][random])
                    setElementVisibleTo(markers[type][random], player, true)
                    triggerClientEvent(player, 'toggleLegenda', player, '- Preciso que você invada um sistema para mim. Marquei em seu mapa.', 4000, 'toggle', 'src/assets/hacker.wav')
                    triggerClientEvent(player, 'criarRota', player, x, y)
                    rota[player] = true
                else
                    exports.crp_notify:addBox(player, 'Você precisa de 1x pendrive e 1x celular', 'warning')
                end
            end
        else
            exports.crp_notify:addBox(player, 'Missao ainda nao disponivel.', 'error')
        end
    else
        exports.crp_notify:addBox(player, 'Você já está em uma missão.', 'error')
    end
end)

function pararColetar(player)
    if isTimer(coletando[player]) and coletando[player] then 
        killTimer(coletando[player])
        coletando[player] = nil
        unbindKey(player, 'backspace', 'down', pararColetar)
    end
end



addEvent('endMission', true)
addEventHandler('endMission', root, function(player, minigame, type)
    if minigame == 'hacker' then 
        if type == 'success' then 
            setPedAnimation(player, 'BOMBER', 'BOM_Plant', 20000, true, true, false, false)
            exports.crp_notify:addBox(player, 'Sistema invadido com sucesso. Você esta coletando o dinheiro.', 'success')
            local xp = math.random(10, 19)
            exports.crp_notify:addBox(player, 'Voce recebeu '..xp..'xp', 'info')
            coletando[player] = setTimer(function()
                exports.crp_items:giveItem(player, 'dinheirosujo', math.random(300, 500))
            end, 1000, 20)
            bindKey(player, 'backspace', 'down', pararColetar)
            setTimer(function()
                pararColetar(player)
            end, 20000, 1)
            rota[player] = nil
        else
            exports.crp_notify:addBox(player, 'Voce errou o código e a invasao falhou.', 'error')
            rota[player] = nil
        end
        exports.crp_items:takeItem(player, 'pendrive', 1)
        triggerEvent('callService', player, player, 'Possivel invasao de sistemas.', 'POLICIA', true)
    end
end)

addEventHandler('onMarkerHit', root, function(player)
    if getElementType(player) == 'player' then 
        if not isPedInVehicle(player) then 
            if getElementData(source, 'mission') then 
                if isElementVisibleTo(source, player) then 
                    setElementVisibleTo(source, player, false)
                    triggerClientEvent(player, Config.Types[getElementData(source, 'mission')].minigame, resourceRoot)
                    exports.crp_notify:addBox(player, 'Invada o sistema', 'info')
                end
            end
        end
    end
end)