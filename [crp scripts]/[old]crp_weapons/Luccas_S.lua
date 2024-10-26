---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- MSG
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function msgBox(player, text, type, time)
    triggerClientEvent(player, "ZN-MsgBox", root, text, type, time)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- MYSQL
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- EQUIPAR ARMA
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

marmas = {}
mattachs1 = {}
mattachs2 = {}
mattachs3 = {}
mattachs4 = {}
mattachs5 = {}
function ZNEquiparArma(ply, arma)
    if ply and arma then
        if getElementData(ply, "Arma-Equipada") == false then
            for i,v in ipairs(cfg.armas) do
                if getElementData(ply, ""..v[1].."-Equipada") == false then
                    if v[1] == ""..arma.."" then
                        if getElementData(ply, ""..v[1].."-Equipada") == false and getElementData(ply, "Arma-Equipada") == false then
                            local x, y, z = getElementPosition(ply)

                            triggerClientEvent(root, "ZN-AnimPuxarArma", root, ply)

                            if v[3] == 0 then
                            else

                                marmas[ply] = createObject(v[3], x, y, z)
                                setElementCollisionsEnabled(marmas[ply], false)

                                setElementDimension(marmas[ply], getElementDimension(ply))
                                setElementInterior(marmas[ply], getElementInterior(ply))

                                exports.bone_attach:attachElementToBone(marmas[ply], ply, 12, 0, 0.01, 0, 0, 270, 0)

                                if v[1] == "HK G36c" or v[1] == "AK-103" or v[1] == "Imbel IA2" or v[1] == "FN Scar-H" or v[1] == "Machado de Guerra" or v[1] == "Garrafa Quebrada" then
                                    setObjectScale(marmas[ply], 0.855)
                                end

                            end

                            setElementData(ply, ""..v[1].."-Equipada", true)
                            setElementData(ply, "Arma-Equipada", true)
                            setElementData(ply, "ZN-ArmaEquipada", v[1])

                            takeAllWeapons(ply)

                            if v[2] == "mfuzil" or v[2] == "mpistola" or v[2] == "msmg" or v[2] == "mshotgun" or v[2] == "mrifle" then
                                local ammo = tonumber(exports.crp_inventory:getItem(ply, v[2]))
                                if ammo > 0 then
                                    giveWeapon(ply, v[4], tonumber(exports.crp_inventory:getItem(ply, v[2]))+1, true)
                                else
                                    giveWeapon(ply, v[4], 1, true)
                                end
                            else
                                giveWeapon(ply, v[4], 1, true)
                            end

                            updateFakeWeapon(ply)

                        end
                    end
                else
                    msgBox(ply, "Você já tem uma arma equipada.", "erro")
                end
            end
        end
    end
end
addEvent("ZN-EquiparArma", true)
addEventHandler("ZN-EquiparArma", root, ZNEquiparArma)

---

function zndestroyarma(ply)
    exports.bone_attach:detachElementFromBone(marmas[ply])
    if isElement(marmas[ply]) then
        destroyElement(marmas[ply])
    end

    exports.bone_attach:detachElementFromBone(mattachs1[ply])
    if isElement(mattachs1[ply]) then
        destroyElement(mattachs1[ply])
        setElementData(ply, "ZN-Attachs1", false)
        exports.zn_saves:ZNGiveItem(ply, "Silenciador A", 1, "Recebido", false)
    end

    exports.bone_attach:detachElementFromBone(mattachs2[ply])
    if isElement(mattachs2[ply]) then
        destroyElement(mattachs2[ply])
        setElementData(ply, "ZN-Attachs2", false)
        exports.zn_saves:ZNGiveItem(ply, "Silenciador B", 1, "Recebido", false)
    end

    exports.bone_attach:detachElementFromBone(mattachs3[ply])
    if isElement(mattachs3[ply]) then
        destroyElement(mattachs3[ply])
        setElementData(ply, "ZN-Attachs3", false)
        exports.zn_saves:ZNGiveItem(ply, "Silenciador C", 1, "Recebido", false)
    end

    exports.bone_attach:detachElementFromBone(mattachs4[ply])
    if isElement(mattachs4[ply]) then
        destroyElement(mattachs4[ply])
        setElementData(ply, "ZN-Attachs4", false)
        exports.zn_saves:ZNGiveItem(ply, "Mira A", 1, "Recebido", false)
    end

    exports.bone_attach:detachElementFromBone(mattachs5[ply])
    if isElement(mattachs5[ply]) then
        destroyElement(mattachs5[ply])
        setElementData(ply, "ZN-Attachs5", false)
        exports.zn_saves:ZNGiveItem(ply, "Aderência", 1, "Recebido", false)
    end

    marmas[ply] = nil
    mattachs1[ply] = nil
    mattachs2[ply] = nil
    mattachs3[ply] = nil
    mattachs4[ply] = nil
    mattachs5[ply] = nil
end
addEvent("ZN-DestroyArma", true)
addEventHandler("ZN-DestroyArma", root, zndestroyarma)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- ATTACHS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function ZNEquiparAttachs(ply, attach)
    for i,v in ipairs(cfg.armas) do
        if getElementData(ply, ""..v[1].."-Equipada") == true then

            if attach == "Silenciador A" then
                if getElementData(ply, "item:silenciadora") >= 1 then
                    if getElementData(ply, "ZN-Attachs1") == false then
                        local x, y, z = getElementPosition(ply)

                        if v[1] == "AK-103" then
                            mattachs1[ply] = createObject(3104, x, y, z)
                            exports.bone_attach:attachElementToBone(mattachs1[ply], ply, 12, -0.15, -0.033, 0.70, 0, 265, 0)
                            setElementCollisionsEnabled(mattachs1[ply], false)

                            setObjectScale(mattachs1[ply], 0.855)
                            exports.zn_saves:ZNGiveItem(ply, "Silenciador A", 1, "Removido", false)
                            setElementData(ply, "ZN-Attachs1", true)

                        elseif v[1] == "HK G36c" then
                            mattachs1[ply] = createObject(3104, x, y, z)
                            exports.bone_attach:attachElementToBone(mattachs1[ply], ply, 12, -0.10, -0.013, 0.57, 2, 275, 0)
                            setElementCollisionsEnabled(mattachs1[ply], false)

                            setObjectScale(mattachs1[ply], 0.855)
                            exports.zn_saves:ZNGiveItem(ply, "Silenciador A", 1, "Removido", false)
                            setElementData(ply, "ZN-Attachs1", true)

                        elseif v[1] == "Imbel IA2" then
                            mattachs1[ply] = createObject(3104, x, y, z)
                            exports.bone_attach:attachElementToBone(mattachs1[ply], ply, 12, -0.07, -0.02, 0.60, 2, 275, 0)
                            setElementCollisionsEnabled(mattachs1[ply], false)

                            setObjectScale(mattachs1[ply], 0.855)
                            exports.zn_saves:ZNGiveItem(ply, "Silenciador A", 1, "Removido", false)
                            setElementData(ply, "ZN-Attachs1", true)

                        elseif v[1] == "FN Scar-H" then
                            mattachs1[ply] = createObject(3104, x, y, z)
                            exports.bone_attach:attachElementToBone(mattachs1[ply], ply, 12, -0.15, -0.020, 0.63, 2, 265, 0)
                            setElementCollisionsEnabled(mattachs1[ply], false)

                            setObjectScale(mattachs1[ply], 0.855)
                            exports.zn_saves:ZNGiveItem(ply, "Silenciador A", 1, "Removido", false)
                            setElementData(ply, "ZN-Attachs1", true)

                        end

                    else

                        exports.bone_attach:detachElementFromBone(mattachs1[ply])
                        if isElement(mattachs1[ply]) then
                            destroyElement(mattachs1[ply])
                            setElementData(ply, "ZN-Attachs1", false)
                            exports.zn_saves:ZNGiveItem(ply, "Silenciador A", 1, "Recebido", false)
                        end

                    end
                end

            elseif attach == "Silenciador B" then
                if getElementData(ply, "item:silenciadorb") >= 1 then
                    if getElementData(ply, "ZN-Attachs2") == false then

                        if v[1] == "Glock" then
                            local x, y, z = getElementPosition(ply)

                            mattachs2[ply] = createObject(3104, x, y, z)
                            exports.bone_attach:attachElementToBone(mattachs2[ply], ply, 12, -0.06, 0.025, 0.28, 0, 280, 0)
                            setElementCollisionsEnabled(mattachs2[ply], false)

                            setObjectScale(mattachs2[ply], 0.855)
                            exports.zn_saves:ZNGiveItem(ply, "Silenciador B", 1, "Removido", false)
                            setElementData(ply, "ZN-Attachs2", true)

                        elseif v[1] == "PT Taurus 24/7" then
                            local x, y, z = getElementPosition(ply)

                            mattachs2[ply] = createObject(3104, x, y, z)
                            exports.bone_attach:attachElementToBone(mattachs2[ply], ply, 12, -0.09, 0.030, 0.28, -5, 275, 0)
                            setElementCollisionsEnabled(mattachs2[ply], false)

                            setObjectScale(mattachs2[ply], 0.855)
                            exports.zn_saves:ZNGiveItem(ply, "Silenciador B", 1, "Removido", false)
                            setElementData(ply, "ZN-Attachs2", true)

                        end

                    else

                        exports.bone_attach:detachElementFromBone(mattachs2[ply])
                        if isElement(mattachs2[ply]) then
                            destroyElement(mattachs2[ply])
                            setElementData(ply, "ZN-Attachs2", false)
                            exports.zn_saves:ZNGiveItem(ply, "Silenciador B", 1, "Recebido", false)
                        end

                    end
                end

            elseif attach == "Silenciador C" then
                if getElementData(ply, "item:silenciadorc") >= 1 then
                    if getElementData(ply, "ZN-Attachs3") == false then

                        if v[1] == "Micro SMG" then
                            local x, y, z = getElementPosition(ply)

                            mattachs3[ply] = createObject(3104, x, y, z)
                            exports.bone_attach:attachElementToBone(mattachs3[ply], ply, 12, -0.085, 0.030, 0.25, -5, 275, 0)
                            setElementCollisionsEnabled(mattachs3[ply], false)

                            setObjectScale(mattachs3[ply], 0.855)
                            exports.zn_saves:ZNGiveItem(ply, "Silenciador C", 1, "Removido", false)
                            setElementData(ply, "ZN-Attachs3", true)

                        elseif v[1] == "Mini SMG" then
                            local x, y, z = getElementPosition(ply)

                            mattachs3[ply] = createObject(3104, x, y, z)
                            exports.bone_attach:attachElementToBone(mattachs3[ply], ply, 12, -0.105, 0.016, 0.40, 0, 275, 0)
                            setElementCollisionsEnabled(mattachs3[ply], false)

                            setObjectScale(mattachs3[ply], 0.855)
                            exports.zn_saves:ZNGiveItem(ply, "Silenciador C", 1, "Removido", false)
                            setElementData(ply, "ZN-Attachs3", true)

                        elseif v[1] == "SMT-40" or v[1] == "MP5" then
                            local x, y, z = getElementPosition(ply)

                            mattachs3[ply] = createObject(3104, x, y, z)
                            exports.bone_attach:attachElementToBone(mattachs3[ply], ply, 12, -0.13, 0.006, 0.52, 0, 273, 0)
                            setElementCollisionsEnabled(mattachs3[ply], false)

                            setObjectScale(mattachs3[ply], 0.855)
                            exports.zn_saves:ZNGiveItem(ply, "Silenciador C", 1, "Removido", false)
                            setElementData(ply, "ZN-Attachs3", true)

                        end

                    else

                        exports.bone_attach:detachElementFromBone(mattachs3[ply])
                        if isElement(mattachs3[ply]) then
                            destroyElement(mattachs3[ply])
                            setElementData(ply, "ZN-Attachs3", false)
                            exports.zn_saves:ZNGiveItem(ply, "Silenciador C", 1, "Recebido", false)
                        end

                    end
                end

            elseif attach == "Mira A" then
                if getElementData(ply, "item:miraa") >= 1 then
                    if getElementData(ply, "ZN-Attachs4") == false then
                        local x, y, z = getElementPosition(ply)

                        if v[1] == "AK-103" then
                            mattachs4[ply] = createObject(3105, x, y, z)
                            exports.bone_attach:attachElementToBone(mattachs4[ply], ply, 12, -0.168, 0.008, 0.32, 2, 265, 0)
                            setElementCollisionsEnabled(mattachs4[ply], false)

                            setObjectScale(mattachs4[ply], 0.855)
                            exports.zn_saves:ZNGiveItem(ply, "Mira A", 1, "Removido", false)
                            setElementData(ply, "ZN-Attachs4", true)

                        elseif v[1] == "HK G36c" then
                            mattachs4[ply] = createObject(3105, x, y, z)
                            exports.bone_attach:attachElementToBone(mattachs4[ply], ply, 12, -0.176, 0.023, 0.15, 0, 275, 0)
                            setElementCollisionsEnabled(mattachs4[ply], false)

                            setObjectScale(mattachs4[ply], 0.855)
                            exports.zn_saves:ZNGiveItem(ply, "Mira A", 1, "Removido", false)
                            setElementData(ply, "ZN-Attachs4", true)

                        elseif v[1] == "Imbel IA2" then
                            mattachs4[ply] = createObject(3105, x, y, z)
                            exports.bone_attach:attachElementToBone(mattachs4[ply], ply, 12, -0.132, 0.023, 0.15, 0, 275, 0)
                            setElementCollisionsEnabled(mattachs4[ply], false)

                            setObjectScale(mattachs4[ply], 0.855)
                            exports.zn_saves:ZNGiveItem(ply, "Mira A", 1, "Removido", false)
                            setElementData(ply, "ZN-Attachs4", true)

                        elseif v[1] == "FN Scar-H" then
                            mattachs4[ply] = createObject(3105, x, y, z)
                            exports.bone_attach:attachElementToBone(mattachs4[ply], ply, 12, -0.152, 0.025, 0.15, 0, 265, 0)
                            setElementCollisionsEnabled(mattachs4[ply], false)

                            setObjectScale(mattachs4[ply], 0.855)
                            exports.zn_saves:ZNGiveItem(ply, "Mira A", 1, "Removido", false)
                            setElementData(ply, "ZN-Attachs4", true)

                        end

                    else

                        exports.bone_attach:detachElementFromBone(mattachs4[ply])
                        if isElement(mattachs4[ply]) then
                            destroyElement(mattachs4[ply])
                            setElementData(ply, "ZN-Attachs4", false)
                            exports.zn_saves:ZNGiveItem(ply, "Mira A", 1, "Recebido", false)
                        end

                    end
                end

            elseif attach == "Aderência" then
                if getElementData(ply, "item:aderencia") >= 1 then
                    if getElementData(ply, "ZN-Attachs5") == false then
                        local x, y, z = getElementPosition(ply)

                        if v[1] == "AK-103" then
                            mattachs5[ply] = createObject(3094, x, y, z)
                            exports.bone_attach:attachElementToBone(mattachs5[ply], ply, 12, -0.025, 0.008, 0.32, 2, 265, 0)
                            setElementCollisionsEnabled(mattachs5[ply], false)
                            exports.zn_saves:ZNGiveItem(ply, "Aderência", 1, "Removido", false)
                            setElementData(ply, "ZN-Attachs5", true)

                        elseif v[1] == "HK G36c" then
                            mattachs5[ply] = createObject(3094, x, y, z)
                            exports.bone_attach:attachElementToBone(mattachs5[ply], ply, 12, -0.025, 0.008, 0.32, 2, 265, 0)
                            setElementCollisionsEnabled(mattachs5[ply], false)
                            exports.zn_saves:ZNGiveItem(ply, "Aderência", 1, "Removido", false)
                            setElementData(ply, "ZN-Attachs5", true)

                        elseif v[1] == "Imbel IA2" then
                            mattachs5[ply] = createObject(3094, x, y, z)
                            exports.bone_attach:attachElementToBone(mattachs5[ply], ply, 12, -0.005, 0.003, 0.35, 2, 270, 0)
                            setElementCollisionsEnabled(mattachs5[ply], false)
                            exports.zn_saves:ZNGiveItem(ply, "Aderência", 1, "Removido", false)
                            setElementData(ply, "ZN-Attachs5", true)

                        elseif v[1] == "FN Scar-H" then
                            mattachs5[ply] = createObject(3094, x, y, z)
                            exports.bone_attach:attachElementToBone(mattachs5[ply], ply, 12, -0.025, 0.013, 0.30, 2, 265, 0)
                            setElementCollisionsEnabled(mattachs5[ply], false)
                            exports.zn_saves:ZNGiveItem(ply, "Aderência", 1, "Removido", false)
                            setElementData(ply, "ZN-Attachs5", true)

                        end

                    else

                        exports.bone_attach:detachElementFromBone(mattachs5[ply])
                        if isElement(mattachs5[ply]) then
                            destroyElement(mattachs5[ply])
                            setElementData(ply, "ZN-Attachs5", false)
                            exports.zn_saves:ZNGiveItem(ply, "Aderência", 1, "Recebido", false)
                        end

                    end
                end
            end

        end
    end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- DEBUG
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function quit()
    ply = source

    ZNGuardarArma(ply)

    exports.bone_attach:detachElementFromBone(marmas[ply])
    if isElement(marmas[ply]) then
        destroyElement(marmas[ply])
    end

    exports.bone_attach:detachElementFromBone(mattachs1[ply])
    if isElement(mattachs1[ply]) then
        destroyElement(mattachs1[ply])
        setElementData(ply, "ZN-Attachs1", false)
        exports.zn_saves:ZNGiveItem(ply, "Silenciador A", 1, "Recebido", false)
    end

    exports.bone_attach:detachElementFromBone(mattachs2[ply])
    if isElement(mattachs2[ply]) then
        destroyElement(mattachs2[ply])
        setElementData(ply, "ZN-Attachs2", false)
        exports.zn_saves:ZNGiveItem(ply, "Silenciador B", 1, "Recebido", false)
    end

    exports.bone_attach:detachElementFromBone(mattachs3[ply])
    if isElement(mattachs3[ply]) then
        destroyElement(mattachs3[ply])
        setElementData(ply, "ZN-Attachs3", false)
        exports.zn_saves:ZNGiveItem(ply, "Silenciador C", 1, "Recebido", false)
    end

    exports.bone_attach:detachElementFromBone(mattachs4[ply])
    if isElement(mattachs4[ply]) then
        destroyElement(mattachs4[ply])
        setElementData(ply, "ZN-Attachs4", false)
        exports.zn_saves:ZNGiveItem(ply, "Mira A", 1, "Recebido", false)
    end

    exports.bone_attach:detachElementFromBone(mattachs5[ply])
    if isElement(mattachs5[ply]) then
        destroyElement(mattachs5[ply])
        setElementData(ply, "ZN-Attachs5", false)
        exports.zn_saves:ZNGiveItem(ply, "Aderência", 1, "Recebido", false)
    end

    marmas[ply] = nil
    mattachs1[ply] = nil
    mattachs2[ply] = nil
    mattachs3[ply] = nil
    mattachs4[ply] = nil
    mattachs5[ply] = nil

end
addEventHandler("onPlayerQuit", root, quit)

---

function zndesveh(vehicle, seat, jacked)
    if getElementData(source, "Arma-Equipada") == true then
        for i,v in ipairs(cfg.armas) do
            if v[1] == getElementData(source, ""..v[1].."-Equipada") then
                local pedSlot = getPedWeapon(source)
                if not pedSlot then
                    ZNGuardarArma(source)
                    ZNEquiparArma(source, v[1])
                end
            end
        end
    end
end
addEventHandler("onPlayerVehicleExit", root, zndesveh)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- GUARDAR ARMA
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function ZNGuardarArma(ply, type)
    for i,v in ipairs(cfg.armas) do
        if getElementData(ply, ""..v[1].."-Equipada") == true then

            local Balas = getPedTotalAmmo(ply, tonumber(v[5]))

            zndestroyarma(ply)

            if v[2] == 'mfuzil' or v[2] == 'mpistola' or v[2] == 'msmg' or v[2] == 'mshotgun' or v[2] == 'mrifle' then
                if Balas > 1 and not type then
                    exports.crp_inventory:giveItem(ply, v[2], Balas-1)
                end
            end

            takeAllWeapons(ply)

            setElementData(ply, ""..v[1].."-Equipada", false)
            setElementData(ply, "Arma-Equipada", false)
            setElementData(ply, "ZN-ArmaEquipada", nil)

            updateFakeWeapon(ply)

        end
    end
end
addEvent("ZN-GuardarArma", true)
addEventHandler("ZN-GuardarArma", root, ZNGuardarArma)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- TIRO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function zntiropm()
    if getElementData(source, "ZN-TiroPM") == false then
        if getPedWeapon(source) == 23 then return end
        if getElementData(source, "Admin") == false then
            if getElementData(source, "police >> duty") == true then
                cancelEvent()
            else
                print(source)
                setElementData(source, "ZN-TiroPM", true)
                triggerEvent("ZN-SetarElementTiro", source, source)

                triggerEvent('callService', source, source, 'Ocorrência de disparo.', 'POLICIA', true)
            end
        end
    end
end
addEventHandler("onPlayerWeaponFire", root, zntiropm)

addEventHandler('onPlayerWasted', root, function()
    ZNGuardarArma(source)
end)

addEventHandler('onPlayerQuit', root, function()
    ZNGuardarArma(source)
    if getElementData(source, 'ID') then 
        for i,v in pairs(fakeWeapon[source]) do 
            destroyElement(fakeWeapon[source][i])
        end
        fakeWeapon[source] = nil
    end
end)

addEventHandler('onPlayerDamage', root, function(player, weapon, bodypart, loss)
    if weapon == 23 then 
        setElementFrozen(source, true)
        fadeCamera(source, false, 0.5, 255, 255, 255)
        setTimer(function(target)
            setElementFrozen(target, false)
            fadeCamera(target, true, 0.5, 255, 255, 255)
        end, 5000, 1, source)
    end
end)

---

function znsetarelementtiro(ply)
    setTimer(setElementData, 5000, 1, ply, "ZN-TiroPM", false)
end
addEvent("ZN-SetarElementTiro", true)
addEventHandler("ZN-SetarElementTiro", root, znsetarelementtiro)


setWeaponProperty ( 24, "pro", "damage", 60 ) -- TAURUS E GLOCK
setWeaponProperty ( 22, "pro", "damage", 30 ) -- HK
setWeaponProperty ( 9, "pro", "damage", 1 ) -- HK

fakeWeapon = {}

function updateFakeWeapon(player)
    local x, y, z = getElementPosition(player)
    if not fakeWeapon[player] then 
        fakeWeapon[player] = {} 
    end
    for k,v in ipairs(cfg.armas) do
        if not getElementData(player, ""..v[1].."-Equipada") then
            if exports.crp_inventory:getItem(player, v[1]) >= 1 then 
                if v[2] == 'mfuzil' or v[2] == 'mshotgun' or v[2] == 'mrifle' then 
                    if not fakeWeapon[player]['back'] then 
                        fakeWeapon[player]['back'] = createObject(v[3], x, y, z)
                        exports['pAttach']:attach(fakeWeapon[player]['back'], player, 0, -0.43,-0.12,-0.08,0,-100.8,97.2)
                        setElementData(fakeWeapon[player]['back'], 'weapon', v[1])
                        print('criou '..v[1])
                    end
                elseif v[2] ~= '0' then
                    if not fakeWeapon[player]['coldre'] then 
                        fakeWeapon[player]['coldre'] = createObject(v[3], x, y, z)
                        exports['pAttach']:attach(fakeWeapon[player]['coldre'], player, 0, -0.03,-0.26,0,97.2,0,0)
                        setElementData(fakeWeapon[player]['coldre'], 'weapon', v[1])
                    end
                end
            else
                if v[2] == 'mfuzil' or v[2] == 'mshotgun' or v[2] == 'mrifle' then 
                    if fakeWeapon[player]['back'] then 
                        if getElementData(fakeWeapon[player]['back'], 'weapon') == v[1] then 
                            destroyElement(fakeWeapon[player]['back'])
                            fakeWeapon[player]['back'] = nil
                        end
                    end
                elseif v[2] ~= '0' then
                    if fakeWeapon[player]['coldre'] then 
                        if getElementData(fakeWeapon[player]['coldre'], 'weapon') == v[1] then 
                            destroyElement(fakeWeapon[player]['coldre'])
                            fakeWeapon[player]['coldre'] = nil
                        end
                    end
                end
            end
        else
            if v[2] == 'mfuzil' or v[2] == 'mshotgun' or v[2] == 'mrifle' then 
                if fakeWeapon[player]['back'] then 
                    if getElementData(fakeWeapon[player]['back'], 'weapon') == v[1] then 
                        destroyElement(fakeWeapon[player]['back'])
                        fakeWeapon[player]['back'] = nil
                    end
                end
            elseif v[2] ~= '0' then
                if fakeWeapon[player]['coldre'] then 
                    if getElementData(fakeWeapon[player]['coldre'], 'weapon') == v[1] then 
                        destroyElement(fakeWeapon[player]['coldre'])
                        fakeWeapon[player]['coldre'] = nil
                    end
                end
            end
        end
    end
end

setTimer(function()
    for i,player in ipairs(getElementsByType('player')) do 
        
        if getElementData(player, 'ID') then 
            updateFakeWeapon(player)
        end
    end
end, 5000, 0)