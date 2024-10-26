local soundCinto = false
local stress = 0
local screen = { guiGetScreenSize() }

addEvent('CRP-PlaySound', true)
addEventHandler('CRP-PlaySound', root, function ( d3, sound, volume, time, position )

    if d3 then 
        if position then 
            local x, y, z = unpack(position)
            sound = playSound3D(sound, x, y, z, false)
        end
    else
        sound = playSound(sound, false)
    end
    if volume then 
        setSoundVolume(sound, volume)
    end
    if time then 
        setTimer(stopSound, time, 1, sound)
    end

end)

addEventHandler('onClientRender', root, function( )
    if stress ~= (getElementData(localPlayer, 'Stress') or 0) then 
        stress = (getElementData(localPlayer, 'Stress') or 0)
        setCameraDrunkLevel ( math.floor(stress*2) )
    else
        setCameraDrunkLevel( 0 )
    end

    if stress == 0 then 
        setCameraDrunkLevel ( stress )
    end

    if stress >= 25 then 
        exports['crp_blur']:dxDrawBluredRectangle (0, 0, screen[1], screen[2], tocolor(255, 255, 255, 255/100*stress))
    end
end)

--[[

addEventHandler('onClientVehicleEnter', root, function( player )
    if getVehicleType(source) ~= 'Bike' and getVehicleType(source) ~= 'BMX' and getVehicleType(source) ~= 'Quad' then
        if player == localPlayer then 
            soundCinto = playSound('src/assets/sounds/alertaCinto.mp3', true)
            setSoundVolume(soundCinto, 1.5)
        end
    end
end) ]]

addEventHandler('onClientVehicleExit', root, function (player)
    --[[
    if player == localPlayer then 
        if soundCinto then 
            stopSound(soundCinto)
            soundCinto = false
        end
    end]]
end)

addEvent('CRP-AlertaCinto', true)
addEventHandler('CRP-AlertaCinto', root, function( state )
    --[[
    if state then 
        if not getElementData(localPlayer, 'Cinto') then 
            soundCinto = playSound('src/assets/sounds/alertaCinto.mp3', true)
            setSoundVolume(soundCinto, 1.5)
        end
    else
        stopSound(soundCinto)
        soundCinto = false
    end]]
end)

addCommandHandler('Colocar/retirar cinto', function ( )
    triggerServerEvent('CRP-Cinto', localPlayer, localPlayer)
end)

addCommandHandler('Desligar/ligar motor', function ( )
    triggerServerEvent('CRP-EngineManager', localPlayer, localPlayer)
end)

addCommandHandler('Desligar/ligar farol', function ( )
    triggerServerEvent('CRP-Farol', localPlayer, localPlayer)
end)

addCommandHandler('Trancar/destrancar veiculo', function()

    local vehicle = getPedOccupiedVehicle(localPlayer)

    if not vehicle then 
        for i,v in ipairs(getElementsByType('vehicle')) do 
            local x, y, z = getElementPosition(v)
            local x2, y2, z2 = getElementPosition(localPlayer)
            if getDistanceBetweenPoints3D(x, y, z, x2,  y2, z2) <= 3 then
                vehicle = v 
            end
        end
    end

    triggerServerEvent('dealership >> lock', localPlayer, localPlayer, vehicle)
end)

bindKey(cfg.keys.vehicle.cinto, 'down', 'Colocar/retirar cinto')
bindKey(cfg.keys.vehicle.motor, 'down', 'Desligar/ligar motor')
bindKey(cfg.keys.vehicle.farol, 'down', 'Desligar/ligar farol')
bindKey(cfg.keys.vehicle.trancar, 'down', 'Trancar/destrancar veiculo')

function andar()
    setPedControlState(localPlayer, "walk", true)
end
bindKey("w","down", andar)
bindKey("space","up", andar)

function correr()
    setPedControlState(localPlayer, "walk", false)
    --setPedControlState(localPlayer, "sprint", true)
end
bindKey("space","down", correr)

function disableTargetMarkers()
	setPedTargetingMarkerEnabled(false) -- Disables target markers from being rendered after the resource is started
    setAmbientSoundEnabled( "gunfire", false )
end
addEventHandler("onClientResourceStart", resourceRoot, disableTargetMarkers)