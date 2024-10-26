local marker = {}
local macas = {}
local timer = {}



addEventHandler('onResourceStart', resourceRoot, function()
    for i,v in ipairs(Config.MarkerTratamento) do 
        local fakemarker = exports['crp_markers']:createMarker('marker', Vector3 {v[1], v[2], v[3]})
        marker[i] = createMarker(v[1], v[2], v[3], 'cylinder', 1.2, 0,0,0,0)
        setElementData(marker[i], 'id', i)
        setElementData(marker[i], 'hospital', v[4])
    end
end)

addEventHandler('onMarkerHit', resourceRoot, 
function(element)
    if getElementType(element) == 'player' then 
        local player = element
        if getElementData(source, 'hospital') then 
            messageBox(player, "Pressione 'E' para iniciar seu tratamento.", "info")
            bindKey(player, 'e', 'down', iniciarTratamento, source)
        end
    end
end)

addEventHandler('onMarkerLeave', resourceRoot, 
function(element)
    if getElementType(element) == 'player' then 
        if getElementData(source, 'hospital') then 
            unbindKey(element, 'e', 'down', iniciarTratamento)
        end
    end
end)

iniciarTratamento = function (player, b, s, hitMarker)
    if getMedics() == 0 then 
        local hospital = getElementData(hitMarker, 'hospital')
        if getElementHealth(player) == 100 then return messageBox(player, 'Você não precisa de tratamento', 'info') end
        if exports.crp_inventory:getItem(player, 'dinheiro') >= Config.ValorTratamento then
            for i,v in ipairs(Config.Macas[hospital]) do
                if not macas[hospital] then 
                    macas[hospital] = {}
                end
                if not macas[hospital][i] then 
    				exports.crp_inventory:takeItem(player, 'dinheiro', Config.ValorTratamento)
                    macas[hospital][i] = true
                    local x, y, z = unpack(v.position)
                    local camera = v.camera
                    setElementPosition(player, x, y, z)
                    setElementRotation(player, v.rotation[1], v.rotation[2], v.rotation[3])
                    setCameraMatrix(player, camera[1], camera[2], camera[3], camera[4], camera[5], camera[6], camera[7], camera[8])
                    setPedAnimation(player, 'CRACK', 'crckidle2', -1, true, false, false, false)
                    toggleAllControls(player, false, true, false)

                    timer[player] = setTimer(function()
                        if getElementHealth(player) < 100 then 
                            setElementHealth(player, getElementHealth(player) +5)
                        else
                            killTimer(timer[player])
                            setCameraTarget(player)
                            toggleAllControls(player, true)
                            macas[hospital][i] = nil
                            setElementData(player, 'Sangrando', false)
                        end
                    end, 1000*Config.TempoTratamento, 0)
                    break
                end 
            end
        else
            messageBox(player, 'Você precisa de R$'..Config.ValorTratamento..' para iniciar o tratamento.', 'error')
        end
    --[[
    else
        local hospital = getElementData(hitMarker, 'hospital')
        if getElementHealth(player) == 100 then return end
        for i,v in ipairs(Config.Macas[hospital]) do
            if not macas[hospital][i] then 
                local x, y, z = unpack(v.position)
                local camera = v.camera
                macas[hospital][i] = true
                setElementPosition(player, x, y, z)
                setElementRotation(player, v.rotation[1], v.rotation[2], v.rotation[3])
                setCameraMatrix(player, camera[1], camera[2], camera[3], camera[4], camera[5], camera[6], camera[7], camera[8])
                setPedAnimation(player, 'CRACK', 'crckidle2', -1, true, false, false, false)
                toggleAllControls(player, false, true, false)
                setElementData(player, 'medic >> esperando_tratamento', true)
                setElementData(player, 'hospital', hospital)
                break
            end 
        end]]
    end
end

addEvent('interaction >> iniciartratamento', true)
addEventHandler('interaction >> iniciartratamento', root, function(player, element)
    if not timer[element] then 
        messageBox(element, 'O médico iniciou seu tratamento', 'success')
        messageBox(player, 'Tratamento do paciente iniciado.', 'success')
        setElementData(element, 'Tratamento', true)
        timer[element] = setTimer(function()
            if getElementHealth(element) < 100 then 
                setElementHealth(element, getElementHealth(element) +5)
            else
                killTimer(timer[element])
                messageBox(element, 'Tratamento finalizado.', 'success')
                setElementData(player, 'Sangrando', false)
                setElementData(element, 'Tratamento', false)
            end
        end, 1000*Config.TempoTratamento, 0)
    end
end)

function pararTratamento (player)
    killTimer(timer[player])
    killTimer(timer[element])
    setCameraTarget(element)
    setCameraTarget( element, element )
    toggleAllControls(element, true)
    macas[hospital][i] = nil
    setElementData(element, 'hospital', false)
    setElementData(element, 'medic >> esperando_tratamento', false)
    unbindKey(player, 'space', 'down', pararTratamento)
end

addEventHandler("onPlayerQuit", root, function()
    if timer[source] then 
        killTimer(timer[source])
        timer[source] = nil
    end
end)