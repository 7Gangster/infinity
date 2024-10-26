local db = exports.crp_mysql:getConnection()

-- VEHICLE MANAGER 

addEvent('CRP-EngineManager', true)
addEventHandler('CRP-EngineManager', root, function ( player )

    local vehicle = getPedOccupiedVehicle(player)

    if vehicle then 

        if getPedOccupiedVehicleSeat(player) == 0 then 
            if exports['crp_inventory']:getItemData(player, 'chavecarro', 'vehicle', (getElementData(vehicle, 'Vehicle > ID') or 0)) == (getElementData(vehicle, 'Vehicle > ID') or 0) then
                if getElementHealth(vehicle) >= 350 and (getElementData(vehicle, 'Fuel') or 100) > 0 then 
                    
                    setElementData(vehicle, 'motor', not getVehicleEngineState(vehicle))
                    setVehicleEngineState(vehicle, not getVehicleEngineState(vehicle))
                    for i,v in ipairs(getElementsByType('player')) do
                        if getVehicleEngineState(vehicle) then 
                            local x, y, z = getElementPosition(player)
                            triggerClientEvent(v, 'CRP-PlaySound', v, true, 'src/assets/sounds/engine.mp3', 1, 1500, {x, y, z})
                        end
                    end

                else

                    setVehicleEngineState(vehicle, false )
                    setElementData(vehicle, 'motor', false)

                end

            else 

                exports.crp_notify:addBox(player, 'Você não possui as chaves deste veículo.', 'error')

            end
        end

    end

end)

addEvent('CRP-Farol', true)
addEventHandler('CRP-Farol', root, function ( player )

    local vehicle = getPedOccupiedVehicle(player)
    if vehicle then 
        if getVehicleLightState(vehicle, 0) == 0 and getVehicleLightState(vehicle, 1) == 0 then 
            setVehicleLightState(vehicle, 0, 1)
            setVehicleLightState(vehicle, 1, 1)
        else
            setVehicleLightState(vehicle, 0, 0)
            setVehicleLightState(vehicle, 1, 0)
        end
    end

end)

setTimer(function()
    for i,v in ipairs(getElementsByType('vehicle')) do 
        if getElementHealth(v) <= 350 then 
            setVehicleEngineState(v, false)
            if not isVehicleDamageProof(v) then 
                setElementHealth(v, 350)
                setVehicleDamageProof(v, true)
            end
        else
            if isVehicleDamageProof(v) then 
                setVehicleDamageProof(v, false)
            end
        end
        if (getElementData(v, 'Fuel') or 100) <= 0 then
            setVehicleEngineState(v, false) 
        end

        local a, b, c, d = getVehicleWheelStates(v)
        if a == 1 or b == 1 or c == 1 or d == 1 then
            if getElementHealth(v) >= 350 and getVehicleOccupants(v) then 
                setElementHealth(v, getElementHealth(v)-1)
            end
        end

        if getVehicleType(v) ~= 'BMX' then 
            if getVehicleEngineState(v) == true then 
                if (getElementData(v, 'Fuel') or 100) > 0 then 
                    setElementData(v, 'Fuel', (getElementData(v, 'Fuel') or 100) -0.05)
                end
            end
        end
    end
end, 1000, 0)

-- CINTO

addEventHandler("onVehicleDamage", root, function(loss)
    player = getVehicleOccupant(source)
    if player then 
        if not getElementData(player, "Cinto") then 

            if getVehicleType(source) ~= 'Bike' and getVehicleType(source) ~= 'BMX' and getVehicleType(source) ~= 'Quad' then
                lifePlayer = getElementHealth(player)
                total = lifePlayer - loss /5
                setElementHealth(player, total)
                if loss >= 100 then
                    removePedFromVehicle(player)
                    setPedAnimation(player, 'CRACK', 'crckidle'..math.random(1, 4), 5000, true, true, false, false) 
                    fadeCamera(player, false, 1, 255, 255, 255)
                    setTimer(fadeCamera, 2000, 1, player, true)
                end
            end

        end
    end

    if loss >= 150 and loss < 200 then 
        local chance = math.random(1, 2)
        local pneus = {1, -1, -1, -1}
        if chance == 2 then 
            setVehicleWheelStates(source, pneus[math.random(1, 4)], pneus[math.random(1, 4)], pneus[math.random(1, 4)], pneus[math.random(1, 4)])
        end
    elseif loss >= 200 then 
        if player then 
            if getVehicleType(source) ~= 'Bike' and getVehicleType(source) ~= 'BMX' and getVehicleType(source) ~= 'Quad' then
                lifePlayer = getElementHealth(player)
                total = lifePlayer - loss /5
                setElementHealth(player, total)
                removePedFromVehicle(player)
                setElementData(player, 'Cinto', false)
                setPedAnimation(player, 'CRACK', 'crckidle'..math.random(1, 4), 5000, true, true, false, false) 
                fadeCamera(player, false, 1, 255, 255, 255)
                setTimer(fadeCamera, 2000, 1, player, true)
                setVehicleEngineState(source, false)
                setElementData(source, 'motor', false)
            end
        end
        local pneus = {1, -1, -1, -1}
        setVehicleWheelStates(source, pneus[math.random(1, 4)], pneus[math.random(1, 4)], pneus[math.random(1, 4)], pneus[math.random(1, 4)])
    end

end)

function vehicleEnter ( player )
    if getVehicleType(source) ~= 'Bike' and getVehicleType(source) ~= 'BMX' and getVehicleType(source) ~= 'Quad' then 
        triggerClientEvent(player, 'CRP-AlertaCinto', player, true)
    end

    setVehicleEngineState(source, getElementData(source, 'motor') or false)

    if cfg.vehicles[getElementModel(source)] then 

        if cfg.vehicles[getElementModel(source)].handling then 
            if type(cfg.vehicles[getElementModel(source)].handling) == 'table' then 
                for i,v in pairs(cfg.vehicles[getElementModel(source)].handling) do 
                    if v then 
                        if getVehicleHandling(source)[i] then 
                            setVehicleHandling(source, i, v)
                        else
                            print('Parametro: '..i..' inexistente.')
                        end
                    end
                end
            end
        end

    end
end
addEventHandler('onVehicleEnter', root, vehicleEnter)

addEventHandler('onVehicleStartExit', root, function ( player )
    if getElementData(player, 'Cinto') or isVehicleLocked(source) then 
        cancelEvent( )
        return true
    end
end)

addEventHandler('onVehicleStartEnter', root, function ( player, seat )

    if seat == 0 then 
        if getVehicleOccupant(source) ~= player then
            cancelEvent()
            return true
        end
    end

    if isVehicleLocked(source) then 
        if getVehicleType(source) == 'Bike' or getVehicleType(source) == 'BMX' then 
            cancelEvent()
            return true
        end
    end

end)

addEvent('CRP-Cinto', true)
addEventHandler('CRP-Cinto', root, function ( player )

    local vehicle = getPedOccupiedVehicle(player)
    if vehicle then 

        if getVehicleType(vehicle) ~= 'Bike' and getVehicleType(vehicle) ~= 'BMX' and getVehicleType(vehicle) ~= 'Quad' then

            setElementData(player, 'Cinto', not ( getElementData(player, 'Cinto') or false ))

            if getElementData(player, 'Cinto') then 
                triggerClientEvent(player, 'CRP-PlaySound', player, false, 'src/assets/sounds/colocandoCinto.mp3')
                triggerClientEvent(player, 'CRP-AlertaCinto', player, false)
            else
                triggerClientEvent(player, 'CRP-PlaySound', player, false, 'src/assets/sounds/tirandoCinto.mp3')
                triggerClientEvent(player, 'CRP-AlertaCinto', player, true)
            end

        end

    end
    
end)

addEventHandler('onElementSpawn', root, function ( )
    local vehicle = source 
    if getElementType(vehicle) == 'vehicle' then 
        if cfg.vehicles[getElementModel(vehicle)] then 
            setElementData(vehicle, 'Properties', toJSON({

                nome = v.nome,
                classe = v.class,

            }))
            print('O veiculo: '..v.nome..' de classe '..v.class..' foi spawnado.')
        end
    end
end)

-- [[ Drive-By ]]

if cfg.driveby then

    print('DriveBy ativado')

    allowedWeapons = {
        [22] = true,
        [23] = true,
        [24] = true,
        [25] = false,
        [26] = false,
        [27] = false,
        [28] = true,
        [29] = true,
        [30] = false,
        [31] = false,
        [32] = true,
    }

    function driveBy(playerSource, _, state)
        if isPedInVehicle(playerSource) then
            if getPedOccupiedVehicleSeat(playerSource) ~= 0 then
                if state == "down" then
                    if not isPedDoingGangDriveby(playerSource) then
                        local weapon = getPedWeapon(playerSource)
                        if allowedWeapons[weapon] then
                            setPedWeaponSlot(playerSource, 0)
                            setPedDoingGangDriveby(playerSource, true)
                            setPedWeaponSlot(playerSource, getSlotFromWeapon(weapon))
                        end
                    end
                elseif state == "up" then
                    if isPedDoingGangDriveby(playerSource) then
                        setPedDoingGangDriveby(playerSource, false)
                    end
                end
            end
        end
    end

    function onStart()
        for _, players in pairs(getElementsByType("player")) do
            bindKey(players, "mouse2", "both", driveBy)
        end
    end
    addEventHandler("onResourceStart", resourceRoot, onStart)

    function onLogin()
        if not isKeyBound(source, "mouse2", "both", driveBy) then
            bindKey(source, "mouse2", "both", driveBy)
        end
    end
    addEventHandler("onPlayerLogin", root, onLogin)

else
    print('DriveBy desativado')
end

--[[
    AUTO-START
]]

function startRes(res)
    if cfg.autoStart.start then
        if (res ~= getThisResource()) then return end

        Async:foreach(cfg.autoStart["Resources"], function(resource)
            loadResource(resource, true)
        end);
        Async:setPriority("high");

        -- Configuration
        setMapName(cfg.autoStart["MapName"])
        setGameType(cfg.autoStart["GameType"])
        setMaxPlayers(cfg.autoStart["MaxPlayers"])
        setServerConfigSetting("server_logic_fps_limit", 0, true)
        setServerConfigSetting("busy_sleep_time", 0, true)
        setServerConfigSetting("idle_sleep_time", 0, true)
        setServerConfigSetting("player_sync_interval", 200, true)
        setServerConfigSetting("lightweight_sync_interval", 1500, true)
        setServerConfigSetting("ped_sync_interval", 400, true)
        setServerConfigSetting("unoccupied_vehicle_sync_interval", 1000, true)
        setServerConfigSetting("camera_sync_interval", 500, true)
        setServerConfigSetting("keysync_mouse_sync_interval", 100, true)
        setServerConfigSetting("keysync_analog_sync_interval", 100, true)
        setServerConfigSetting("bullet_sync", 0, true)
        setServerConfigSetting("donkey_work_interval", 1000, true)
        setServerConfigSetting("vehext_percent", 50, true)
        setServerConfigSetting("fpslimit", cfg.autoStart["FPSLimit"], true)
        setServerConfigSetting("bandwidth_reduction", "maximum", true)

        for i,v in ipairs(getElementsByType('player')) do 
            kickPlayer(v, 'Class Roleplay', 'Servidor está reiniciando. Reconecte-se em 1 minuto.')
        end
    end
end
addEventHandler("onResourceStart", getRootElement(), startRes)

function loadResource(resourceName, start)
	local resource = getResourceFromName(resourceName)
	if not (resource) then return end
    if not (start) then resource:stop() return end

    resource:start()
end

-- WHITELIST

addEventHandler('onPlayerConnect', root,
    function(playerNick, playerIP, playerUsername, playerSerial)
        local result = dbPoll(dbQuery(db, 'SELECT * FROM crp_allowlist WHERE serial=?', playerSerial), -1)
        if #result == 0 then
            dbExec(db, 'INSERT INTO crp_allowlist SET serial = ?, whitelist = ?', playerSerial, 0)
            --kickPlayer(source, 'Sua whitelist não esta aprovada entre em nosso discord e realize ela')
            cancelEvent(true, 'Sua allowlist não esta aprovada entre em nosso discord e realize ela. discord.gg/classrp')
        else
            local whitelist = result[1].whitelist
            if not result[1].discord then cancelEvent(true, 'Sua allowlist não esta aprovada entre em nosso discord e realize ela. discord.gg/classrp') end
            if not result[1].whitelist then
                cancelEvent(true, 'Sua allowlist não esta aprovada entre em nosso discord e realize ela. discord.gg/classrp')
            end
        end
    end
)

iprint(db)