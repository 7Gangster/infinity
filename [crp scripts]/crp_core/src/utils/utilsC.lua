font = {}

function getFont( type, size, relative )
    --if fileExists('src/assets/fonts/'..type..'.ttf') then 
        if not font[type] then 
            font[type] = {}
        end
        if not font[type][size] then 
            if not relative then 
                font[type][size] = dxCreateFont('src/assets/fonts/'..type..'.ttf', size, false, 'default')
            else
                font[type][size] = _dxCreateFont('src/assets/fonts/'..type..'.ttf', size, false, 'default')
            end
        else
            return font[type][size]
        end
    --end
    return false
end

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "vehicle" then
		triggerServerEvent("onElementSpawnCheck", localPlayer, source)
	end
end)