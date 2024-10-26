function msg(player, msg, type)
    return exports.crp_notify:addBox(player, msg, type)
end


arma = {}

function equiparArma ( player, weapon, ammo )

    if not arma[player] then 
        if cfg.weapons[weapon] then 
            local wp = weapon
            local weapon = cfg.weapons[weapon]

            if weapon.weapon then 
                giveWeapon(player, weapon.weapon, ammo or 1, true)
            end

            local x, y, z = getElementPosition(player)

            arma[player] = createObject(weapon.model, x, y, z)
            exports.bone_attach:attachElementToBone(arma[player], player, 12, 0, 0.01, 0, 0, 270, 0)

            setElementCollisionsEnabled(arma[player], false)

            if weapon.textures then 
                if weapon.textures['body'] then 
                    triggerClientEvent(root, 'weapon:applyTexture', resourceRoot, arma[player], weapon.textures['body'], 'src/textures/'..wp..'/body.png')
                end
            end

            setElementData(player, 'Arma-Equipada', wp)
            toggleControl(player, 'previous_weapon', false)
            toggleControl(player, 'next_weapon', false)

        end
    else
        
        desequiparArma ( player, weapon )

    end

end

function desequiparArma ( player, weapon, morte)
    local wp = getElementData(player, 'Arma-Equipada')

    if arma[player] then
        if wp then 
            if weapon == wp then 

                local weapon = cfg.weapons[weapon]
                local ammo = getPedTotalAmmo(player)
                takeWeapon(player, weapon.weapon, ammo)
                if ammo > 1 and not morte then 
                    exports.crp_inventory:giveItem(player, weapon.municao, ammo)
                end

                for i,v in pairs(weapon.textures) do 
                    triggerClientEvent(root, 'weapon:clearShader', resourceRoot, arma[player], weapon.textures[i])
                    setElementData(arma[player], i, false)
                    setElementData(player, i, false)
                end

                destroyElement(arma[player])
                arma[player] = nil

                toggleControl(player, 'previous_weapon', true)
                toggleControl(player, 'next_weapon', true)
                
            end
        end
    end
end

function equiparAttach (player, attach)

    local weapon = getElementData(player, 'Arma-Equipada')

    if arma[player] then
        if weapon then 
            if cfg.weapons[weapon] then 
                local wp = weapon 
                local weapon = cfg.weapons[weapon]
                if weapon.textures[attach] then 
                    if not getElementData(arma[player], attach) then  
                        triggerClientEvent(root, 'weapon:applyTexture', resourceRoot, arma[player], weapon.textures[attach], 'src/textures/'..wp..'/'..attach..'.png')
                        setElementData(arma[player], attach, true)
                        setElementData(player, attach, true)
                    else
                        triggerClientEvent(root, 'weapon:clearShader', resourceRoot, arma[player], weapon.textures[attach])
                        setElementData(arma[player], attach, false)
                        setElementData(player, attach, false)
                    end
                end
            end
        end
    end

end

function getWeapon ( player )
    if arma[player] then return arma[player] end 
    return false
end

addEventHandler('onPlayerQuit', root, function()
    if getElementData(source, 'Arma-Equipada') then 
        desequiparArma ( player, getElementData(source, 'Arma-Equipada'))
    end
end)

addCommandHandler('arma', function(player, cmd, arma)
    equiparArma ( player, arma )
end)

addCommandHandler('attach', function(player, cmd, attach)
    equiparAttach ( player, attach )
end)