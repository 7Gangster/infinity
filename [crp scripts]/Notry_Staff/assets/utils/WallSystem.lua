--[[
 ______     ______     ______   __  __     ______     __     ______     __  __     ______      ______     __  __       
/\  ___\   /\  __ \   /\  == \ /\ \_\ \   /\  == \   /\ \   /\  ___\   /\ \_\ \   /\__  _\    /\  == \   /\ \_\ \      
\ \ \____  \ \ \/\ \  \ \  _-/ \ \____ \  \ \  __<   \ \ \  \ \ \__ \  \ \  __ \  \/_/\ \/    \ \  __<   \ \____ \     
 \ \_____\  \ \_____\  \ \_\    \/\_____\  \ \_\ \_\  \ \_\  \ \_____\  \ \_\ \_\    \ \_\     \ \_____\  \/\_____\    
  \/_____/   \/_____/   \/_/     \/_____/   \/_/ /_/   \/_/   \/_____/   \/_/\/_/     \/_/      \/_____/   \/_____/    
                                                                                                                       
 ______   __  __     __     ______     ______     ______        ______     ______     ______                           
/\__  _\ /\ \_\ \   /\ \   /\  ___\   /\  __ \   /\  ___\      /\  ___\   /\  ___\   /\  == \                          
\/_/\ \/ \ \  __ \  \ \ \  \ \ \__ \  \ \  __ \  \ \___  \     \ \___  \  \ \ \____  \ \  __<                          
   \ \_\  \ \_\ \_\  \ \_\  \ \_____\  \ \_\ \_\  \/\_____\     \/\_____\  \ \_____\  \ \_\ \_\                        
    \/_/   \/_/\/_/   \/_/   \/_____/   \/_/\/_/   \/_____/      \/_____/   \/_____/   \/_/ /_/                                                                                                                                    
--]]

---------------/CONFIG UTTL\---------------
function convertNumber ( number )   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
end

function dxDrawTextOnElement(TheElement, text, height, distance, R, G, B, alpha, size, font, ...)
	local x, y, z = getElementPosition (TheElement)
	local x2, y2, z2 = getCameraMatrix()
	local distance = distance or 20
	local height = height or 1

	if (isLineOfSightClear(x, y, z+2, x2, y2, z2, ...)) then
		local sx, sy = getScreenFromWorldPosition(x, y, z+height)
		if(sx) and (sy) then
			local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if(distanceBetweenPoints < distance) then
				dxDrawText(text, sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1) - (distanceBetweenPoints / distance), font or "arial", "center", "center", false, false, false, true, false)
			end
		end
    end
end
---------------/CONFIG UTTL\---------------

---------------/CONFIG RENDER\---------------
addEventHandler ("onClientRender", getRootElement (), function ()
    if not getElementData(localPlayer, "onPlayerStaff") then return end
    if not getElementData(localPlayer, config["ElementDataBase"]) then return end
    local result = getElementsByType("player")
    if result and #result ~= 0 then
        for i = 1, #result do
            local other = result[i]
            if isElement (other) then
                if other ~= localPlayer then
                    local x, y, z = getElementPosition (localPlayer)
                    local ax, ay, az = getElementPosition (other)
                    if getDistanceBetweenPoints3D (x, y, z, ax, ay, az) <= config["WallDistance"] and getElementHealth (other) > 0 then
                        dxDrawLine3D (x, y, z, ax, ay, az, tocolor (unpack (config["WallColor"])), 0.5, true)
                        if config["ElementType"] ~= "player" then
                            dxDrawTextOnElement (other, "[ "..config["HexColor"]..""..math.floor (getDistanceBetweenPoints3D (x, y, z, ax, ay, az)).."#FFFFFF M ] \nVida : "..math.floor (getElementHealth (other)).."% Colete : "..math.floor (getPedArmor (other)).."% \nID : "..IDSystem():getPlayerID(other).. " \nArma : "..getWeaponNameFromID (getPedWeapon (other)).." ( "..getPedWeapon (other).." )", 1, config["WallDistance"], 255, 255, 255, 255, 1, "arial")
                        else
                            dxDrawTextOnElement (other, "[ "..config["HexColor"]..""..math.floor (getDistanceBetweenPoints3D (x, y, z, ax, ay, az)).."#FFFFFF M ] \nVida : "..math.floor (getElementHealth (other)).."% | Colete : "..math.floor (getPedArmor (other)).."% \nID : "..IDSystem():getPlayerID(other).. " | "..getPlayerName (other).."#FFFFFF \nArma : "..getWeaponNameFromID (getPedWeapon (other)).." ( "..getPedWeapon (other).." )", 1, config["WallDistance"], 255, 255, 255, 255, 1, "arial")
                        end
                    end
                end
            else
                table.remove (result, i)
            end
        end
    end
end)
---------------/CONFIG RENDER\---------------