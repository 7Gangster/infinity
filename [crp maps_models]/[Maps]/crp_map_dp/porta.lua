local gate = createObject(3089, 1564.0146484375, -1684.9404296875 , 16.445730209351, 0, 0, 0) 
local marker = createMarker(1564.0146484375, -1684.9404296875 , 16.445730209351, "cylinder", 2, 0, 0, 0, 0) 
  
function moveGate(thePlayer)
    if getElementType(thePlayer) == "player" then
        player = thePlayer
    elseif getElementType(thePlayer) == "vehicle" then
        player = getVehicleOccupant(thePlayer)
    end

    if isElement(player) then
        if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)) , aclGetGroup("Policial")) then 
            moveObject(gate, 1000, 1562.7454833984, -1684.9404296875 , 16.445730209351)
        end 
    end
end 
addEventHandler("onMarkerHit", marker, moveGate) 
  
function move_back_gate() 
     moveObject(gate, 1000, 1564.0146484375, -1684.9404296875 , 16.445730209351) 
end 
addEventHandler("onMarkerLeave", marker, move_back_gate)