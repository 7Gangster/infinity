addEventHandler('onClientPlayerVoiceStart', root, function()
	if getElementData(source, 'Class.Frequency') and getElementData(source, 'Class.Active') == true then
		if getElementData(localPlayer, 'Class.Frequency') == getElementData(source, 'Class.Frequency') then 
			setSoundVolume( source, 5 )
		else
			setSoundVolume( source, 2 )
		end
	else
		setSoundVolume( source, 2 )
	end

end)

BonesRotation = {
    [5] = {0, 0, -30},
    [32] = {-30, -30, 50},
    [33] = {0, -160, 0},
    [34] = {-120, 0, 0}
},

addEventHandler('onClientRender', root, function()
	for i,v in ipairs(getElementsByType('player')) do 
		if getElementData(v, 'char:falando') then 
			local x, y, z = getElementPosition(v)
			local x2, y2, z2 = getElementPosition(localPlayer)
			local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if distance <= (getElementData(v, 'char:voice') or 5) then 
				local maxVolume = 2
            	local volume = maxVolume - (distance / (getElementData(v, 'char:voice') or 5)) * maxVolume
				setSoundVolume(v, volume)
			end
		end
	end
end)

addEvent('Voice:playSound', true)
addEventHandler('Voice:playSound', root, function(player, sound)
	local x, y, z = getElementPosition(player)
	local sound = playSound3D( sound, x, y, z)
	setSoundVolume(sound, 0.2)
end)