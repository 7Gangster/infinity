addEventHandler('onClientResourceStart', resourceRoot, function ( )
    local vehicles = cfg.loader.vehicles
    Async:foreach(vehicles, function(data, i)
        if fileExists(data[1]) and fileExists(data[2]) then 
            engineImportTXD(engineLoadTXD(data[2]), data[3])
            engineReplaceModel(engineLoadDFF(data[1]), data[3])
            print(data[1]..' - Veiculo carregado.')
        end
    end);

    local objects = cfg.loader.objects
    Async:foreach(objects, function(data, i)
        if fileExists(data[1]) and fileExists(data[2]) then 
            engineImportTXD(engineLoadTXD(data[2]), data[3])
            engineReplaceModel(engineLoadDFF(data[1]), data[3])
            print(data[1]..' - Objeto carregado.')
        end
    end);
    Async:setPriority("low");
end)

--[[
    SOM ARMAS
]]

function onShoot(weapon)
	if (cfg["som_armas"]["isSoundEnable"]) then
		if cfg["som_armas"].sounds[weapon] then
			local x1, y1, z1 = getElementPosition(localPlayer)
			local x2, y2, z2 = getElementPosition(source)
			if getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= cfg["som_armas"].sounds[weapon][3] then
				local int = getElementInterior(localPlayer)
				local dim = getElementDimension(localPlayer)
				local x3, y3, z3 = getPedWeaponMuzzlePosition(source)
				local sound = playSound3D(cfg["som_armas"].sounds[weapon][1], x3, y3, z3)
                if not getElementData(localPlayer, 'silenciador') then 
				    setSoundVolume(sound, cfg["som_armas"].sounds[weapon][4])
                else
                    setSoundVolume(sound, 0.2)
                end
                if not getElementData(localPlayer, 'silenciador') then 
                    setSoundMinDistance(sound, cfg["som_armas"].sounds[weapon][2])
                    setSoundMaxDistance(sound, cfg["som_armas"].sounds[weapon][3])
                else
                    setSoundMinDistance(sound, 0)
                    setSoundMaxDistance(sound, 10)
                end
				setElementDimension(sound, dim)
				setElementInterior(sound, int)
			end
		end
	end
end
addEventHandler("onClientPlayerWeaponFire", root, onShoot)

--[[function toggleSound()
	isSoundEnable = not (isSoundEnable)
end
addEvent("toggleCustomWeaponSound", true)
addEventHandler("toggleCustomWeaponSound", root, toggleSound) ]]