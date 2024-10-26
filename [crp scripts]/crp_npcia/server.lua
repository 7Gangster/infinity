
npc = {}
movingTO = {}
event = {}

function createNPC ( model, position, type )

    local id = #npc
    if #npc == 0 then 
        id = 1
    end

    npc[id] = createPed(model, unpack(position))
    setElementData(npc[id], 'NPC', true)
    setElementData(npc[id], 'ID', id)
    setElementData(npc[id], 'type', type)
    return npc[id]

end

function moveTo( npc, position)

    local x, y, z = unpack(position)
    local x2, y2, z2 = getElementPosition(npc)

    if isElement(npc) then 
        if getElementType(npc) == 'ped' then 

            if movingTO[npc] then 
                destroyElement(movingTO[npc])
                movingTO[npc] = nil 
            end

            movingTO[npc] = createMarker(x, y, z, 'checkpoint', 1.2, 0, 0, 0, 90)
            setElementData(npc, 'MovingTO', {x, y, z})
            setElementVisibleTo(movingTO[npc], root, false)
            setElementData(movingTO[npc], 'npc', npc)

        end
    end

end

function attack (npc, element)
    local x, y, z = getElementPosition(npc)
    local x2, y2, z2 = getElementPosition(element)

    if isElement(npc) then 
        if getElementType(npc) == 'ped' then 

            setElementData(npc, 'Attacking', element)

        end
    end
end

addEventHandler('onMarkerHit', resourceRoot, function ( npc )
    if getElementType(npc) == 'ped' then 
        if getElementData(source, 'npc') == npc then
             setElementData(npc, 'MovingTO', nil)
             destroyElement(source)
             movingTO[npc] = nil
        end
    end
end)

addEventHandler('onPedWasted', resourceRoot, function( )
    setTimer(function(ped)
        destroyElement(ped)
        npc[getElementData(ped, 'ID')] = nil
    end, 10000, 1, source)
end)

addCommandHandler('npc', function ( player )
    local ped = createNPC ( 0, {unpack({getElementPosition(player)})} )
    moveTo(ped, {2666.623, -2405.006, 13.50})
    attack (ped, player)
    giveWeapon(ped, 7)
end)

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end
