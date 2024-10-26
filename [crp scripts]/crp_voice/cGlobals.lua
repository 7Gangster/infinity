SETTINGS_REFRESH = 2000 -- Interval in which team channels are refreshed, in MS.
bShowChatIcons = true

voicePlayers = {}
globalMuted = {}

range2 = {}
addEventHandler ( "onClientPlayerVoiceStart", root, 
function() 
    if (source and isElement(source) and getElementType(source) == "player") and localPlayer ~= source then 
        local sX, sY, sZ = getElementPosition(localPlayer) 
        local rX, rY, rZ = getElementPosition(source) 
		local distance = getDistanceBetweenPoints3D(sX, sY, sZ, rX, rY, rZ) 
        if getElementData(source, "AC-Logado") == true then
            if getElementData(source, "AC-EmChamada") == false then
				if getElementData(source, "AC-Range") == "5" then
					range2[source] = 5

				elseif getElementData(source, "AC-Range") == "3" then
					range2[source] = 3

				elseif getElementData(source, "AC-Range") == "15" then
					range2[source] = 15

				else
					range2[source] = 15

				end
			
				if distance <= range2[source] then 
					voicePlayers[source] = true
				else 
					cancelEvent()--This was the shit 
				end
			end
		end
    end 
end 
)

addEventHandler ( "onClientPlayerVoiceStop", root,
	function()
		voicePlayers[source] = nil
	end
)

addEventHandler ( "onClientPlayerQuit", root,
	function()
		voicePlayers[source] = nil
	end
)
---

function checkValidPlayer ( player )
	if not isElement(player) or getElementType(player) ~= "player" then
		outputDebugString ( "is/setPlayerVoiceMuted: Bad 'player' argument", 2 )
		return false
	end
	return true
end

---

setTimer ( 
	function()
		bShowChatIcons = getElementData ( resourceRoot, "show_chat_icon", show_chat_icon )
	end,
SETTINGS_REFRESH, 0 )