function sairmala (player, b, s, vehicle)
    setElementData(player, 'Trunk', false)
    setElementData(vehicle, 'Players-Trunk', getElementData(vehicle, 'Players-Trunk') - 1)
    detachElements(player, vehicle)
    setElementAlpha(player, 255)
    exports.crp_items:znalphamascara(player, 255)
    setElementCollisionsEnabled(player, true)
    toggleAllControls(player, true, true, false)
    setVehicleDoorOpenRatio(vehicle, 1, 1, 500)
    setTimer(setVehicleDoorOpenRatio, 500, 1, vehicle, 1, 0, 500)
    unbindKey(player, 'f', 'down', sairmala, vehicle)
end

addEvent('interaction >> entrarmala', true)
addEventHandler('interaction >> entrarmala', root, function(player, element)
    if not isPedInVehicle(player) then
        local vehicle = element
        if vehicle then 
            if getElementData(player, 'Trunk') then return end
            if not getElementData(player, "ZN-CarregandoAlguém") then
                if not isVehicleLocked(vehicle) then
                    if getVehicleType(vehicle) ~= 'Bike' and getVehicleType(vehicle) ~= 'BMX' then 
                        if (getElementData(vehicle, 'Players-Trunk') or 0) < 2 then 
                            local posvehicle = {getElementPosition(vehicle)}
                            setElementAlpha(player, 0)
                            setElementCollisionsEnabled(player, false)
                            setElementData(player, 'Trunk', true)
                            setElementData(vehicle, 'Players-Trunk', (getElementData(vehicle, 'Players-Trunk') or 0) + 1)
                            toggleAllControls(player, false, true, false)
                            exports.crp_inventory:znalphamascara(player, 0)
                            setVehicleDoorOpenRatio(vehicle, 1, 1, 500)
                            setTimer(setVehicleDoorOpenRatio, 500, 1, vehicle, 1, 0, 500)
                            attachElements(player, vehicle, 0, -2.25, 0)
                            bindKey(player, 'f', 'down', sairmala, vehicle)
                            exports.crp_notify:addBox(player, "Pressione 'F' para sair do porta-malas", 'info')
                        end
                    end
                end
            end
        end
    end
end)



function getVehicle(player)
    for _,v in ipairs(getElementsByType('vehicle')) do 
        local x, y, z = getElementPosition(v)
        local x2, y2, z2 = getElementPosition(player)
        if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 5 then 
            return v
        end
    end
end
