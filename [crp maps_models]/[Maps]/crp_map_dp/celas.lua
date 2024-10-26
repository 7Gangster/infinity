local gate = createObject(2930, 1584.3795166016, -1648.7646484375 , 14.324356079102, 0, 0, 270) --------------------------------------> CELA 01
local marker = createMarker(1584.3795166016, -1648.7646484375 , 14.324356079102, "cylinder", 2, 0, 0, 0, 0) 
  
function moveGate(thePlayer)
    if getElementType(thePlayer) == "player" then
        player = thePlayer
    elseif getElementType(thePlayer) == "vehicle" then
        player = getVehicleOccupant(thePlayer)
    end

    if isElement(player) then
        if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)) , aclGetGroup("Policial")) then 
            moveObject(gate, 1000, 1585.3635253906, -1648.7646484375 , 14.324356079102)
        end 
    end
end 
addEventHandler("onMarkerHit", marker, moveGate) 
  
function move_back_gate() 
     moveObject(gate, 1000, 1584.3795166016, -1648.7646484375 , 14.324356079102) 
end 
addEventHandler("onMarkerLeave", marker, move_back_gate)





local gate = createObject(2930, 1588.8890380859, -1648.7646484375 , 14.324356079102, 0, 0, 270) --------------------------------------> CELA 02
local marker = createMarker(1588.8890380859, -1648.7646484375 , 14.324356079102, "cylinder", 2, 0, 0, 0, 0) 
  
function moveGate(thePlayer)
    if getElementType(thePlayer) == "player" then
        player = thePlayer
    elseif getElementType(thePlayer) == "vehicle" then
        player = getVehicleOccupant(thePlayer)
    end

    if isElement(player) then
        if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)) , aclGetGroup("Policial")) then 
            moveObject(gate, 1000, 1589.8795166016, -1648.7646484375 , 14.324356079102)
        end 
    end
end 
addEventHandler("onMarkerHit", marker, moveGate) 
  
function move_back_gate() 
     moveObject(gate, 1000, 1588.8890380859, -1648.7646484375 , 14.324356079102) 
end 
addEventHandler("onMarkerLeave", marker, move_back_gate)





local gate = createObject(2930, 1593.3800048828, -1648.7646484375 , 14.324356079102, 0, 0, 270) --------------------------------------> CELA 03
local marker = createMarker(1593.3800048828, -1648.7646484375 , 14.324356079102, "cylinder", 2, 0, 0, 0, 0) 
  
function moveGate(thePlayer)
    if getElementType(thePlayer) == "player" then
        player = thePlayer
    elseif getElementType(thePlayer) == "vehicle" then
        player = getVehicleOccupant(thePlayer)
    end

    if isElement(player) then
        if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)) , aclGetGroup("Policial")) then 
            moveObject(gate, 1000, 1594.3831787109, -1648.7646484375 , 14.324356079102)
        end 
    end
end 
addEventHandler("onMarkerHit", marker, moveGate) 
  
function move_back_gate() 
     moveObject(gate, 1000, 1593.3800048828, -1648.7646484375 , 14.324356079102) 
end 
addEventHandler("onMarkerLeave", marker, move_back_gate)