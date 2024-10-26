addEventHandler('onClientRender', root, function ( )
    for i, npc in ipairs(getElementsByType('ped')) do 
        if getElementData(npc, 'NPC') then 
            local movingTO = getElementData(npc, 'MovingTO')
            if movingTO then 

                local x, y, z = getElementPosition(npc)
                local x2, y2, z2 = unpack(movingTO)
                local rotation = findRotation(x, y, x2, y2)
                
                setPedRotation(npc, rotation)
                setPedLookAt(npc, x2, y2, z2)

                setPedControlState(npc, 'forwards', true)

            else
                setPedControlState(npc, 'forwards', false)
            end

            local attacking = getElementData(npc, 'Attacking')
            if attacking then 
                if isElement(attacking) then 
                    if getElementData(npc, 'type') == 'mp5' then 
                        setPedAttack(npc, attacking, 29, 9999, 4)
                    elseif getElementData(npc, 'type') == 'pistol' then 
                        setPedAttack(npc, attacking, 24, 9999, 2)
                    elseif getElementData(npc, 'type') == 'm4' then 
                        setPedAttack(npc, attacking, 31, 9999, 5)
                    else
                        setPedAttack(npc, attacking, 0, 9999, 0)
                    end
                end
            else
                setPedControlState(npc, "fire", false)
            end
            

        end
    end
end)

function setPedAttack(theElement, theTarget, theWeapon, theAmmo, thePedSlot)
    if theElement then
       local x, y, z = getElementPosition(theTarget)
       local ex, ey, ez = getElementPosition(theElement)
       local distance = getDistanceBetweenPoints3D(x, y, z, ex, ey, ez)
       local rotation = findRotation(ex, ey, x, y)
       setPedRotation(theElement, rotation)
       setPedAimTarget(theElement, x, y, z)
       givePedWeapon(theElement, theWeapon, 99999, true)
       if distance > 10 then
          setPedControlState(theElement, "forwards", true)
          setPedControlState(theElement, "fire", false)
          setPedWeaponSlot(theElement, 0)
       elseif distance > 1 and theWeapon == 0 then 
            setPedControlState(theElement, "forwards", true)
            setPedControlState(theElement, "fire", false)
            setPedWeaponSlot(theElement, 0)
       else
          setPedControlState(theElement, "fire", true)
          setPedControlState(theElement, "forwards", false)
          setPedWeaponSlot(theElement, thePedSlot)
       end
       if getPedControlState(theTarget, "forwards") or getPedControlState(theTarget, "sprint") or getPedControlState(theTarget, "backwards") then
          setPedControlState(theElement, "fire", false)
          setPedWeaponSlot(theElement, 0)
       else
          setPedControlState(theElement, "fire", true)
          setPedWeaponSlot(theElement, thePedSlot)
       end
    end
 end
 

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end
