local screen = {guiGetScreenSize()}
local sx, sy = (screen[1]/1366), (screen[2]/768)

local select = 'ESTILO DE ANDAR'
selectCategory = 1
proxPag = 0
playersAnim = {}
selectFav = {}

function isMouseInPosition(x,y,w,h)
    if isCursorShowing() then
        local sx,sy = guiGetScreenSize()
        local cx,cy = getCursorPosition()
        local cx,cy = (cx*sx),(cy*sy)
        if (cx >= x and cx <= x+w) and (cy >= y and cy <= y+h) then
            return true
        end
    end
end

_dxDrawImage = dxDrawImage
function dxDrawImage (x, y, w, h, ...)
    local x, y, w, h = sx * x, sy * y, sx * w, sy * h
    return _dxDrawImage (x, y, w, h, ...)
end

_isMouseInPosition = isMouseInPosition
function isMouseInPosition (x, y, w, h)
    local x, y, w, h = sx * x, sy * y, sx * w, sy * h
    return _isMouseInPosition (x, y, w, h)
end

_dxCreateFont = dxCreateFont
function dxCreateFont (file, tamanho)
    local tamanho = sx * tamanho
    return _dxCreateFont (file, tamanho)
end

_dxDrawRectangle = dxDrawRectangle
function dxDrawRectangle (x, y, w, h, ...)
    local x, y, w, h = sx * x, sy * y, sx * w, sy * h
    return _dxDrawRectangle (x, y, w, h, ...)
end

_dxDrawText = dxDrawText
function dxDrawText (text, x, y, w, h, ...)
    local x, y, w, h = sx * x, sy * y, sx * w, sy * h
    return _dxDrawText (text, x, y, w, h, ...)
end

ifp = {}

addEventHandler("onClientResourceStart", resourceRoot,
function()
	setTimer(function()
		for i, v in ipairs(config.ifps) do
			ifp[i] = engineLoadIFP('files/ifp/'..v..'.ifp', v)
		end
	end, 1000, 1)
end)

tableFavorites = {}

Cores = {
	"files/imgs/cage.png",
	"files/imgs/cage_2.png",
	"files/imgs/cage.png",
	"files/imgs/cage_2.png",
	"files/imgs/cage.png",
	"files/imgs/cage_2.png",
}

local font = dxCreateFont("files/fonts/OpenSans-Bold.ttf", 11)
local font2 = dxCreateFont("files/fonts/OpenSans-SemiBold.ttf", 11)
local font3 = dxCreateFont("files/fonts/OpenSans-Medium.ttf", 11)
local font4 = dxCreateFont("files/fonts/OpenSans-SemiBold.ttf", 13)

function dx()
	if window == "index" then
		dxDrawImage(49, 224, 535, 311, "files/imgs/base.png")
		linha = 0
        for i, v in pairs(config["Interações"]) do
            if (i > proxPage and linha < 6) then
                linha = linha + 1
				if isMouseInPosition(61, (201 + 41 * linha), 158, 27) or select == v[1] then
					dxDrawImage(59, (203 + 41 * linha), 25, 24, "files/imgs/icons/"..(v[2])..".png", 0, 0, 0, tocolor(155, 111, 199))
					dxDrawImage(86, (207 + 41 * linha), 1, 16, "files/imgs/bar.png", 0, 0, 0, tocolor(155, 111, 199, 89))
					dxDrawText(v[1], 95, (201 + 41 * linha), 226, (226 + 41 * linha), tocolor(155, 111, 199, 255), 1.00, font, "left", "center", false, false, true, false, false)
				else
					dxDrawImage(59, (203 + 41 * linha), 25, 24, "files/imgs/icons/"..(v[2])..".png", 0, 0, 0, tocolor(196, 200, 206))
					dxDrawImage(86, (207 + 41 * linha), 1, 16, "files/imgs/bar.png", 0, 0, 0, tocolor(241, 241, 241, 63))
					dxDrawText(v[1], 95, (201 + 41 * linha), 226, (226 + 41 * linha), tocolor(223, 228, 235, 216), 1.00, font2, "left", "center", false, false, true, false, false)
				end
            end
        end
		linha2 = 0
        for i, v in pairs(config["Animations"][select]) do
            if (i > proxPage2 and linha2 < 6) then
                linha2 = linha2 + 1
				if isMouseInPosition(252, (197 + 39 * linha2), 307, 36) and not isMouseInPosition(260, (207 + 39 * linha2), 16, 16) then
					dxDrawImage(252, (197 + 39 * linha2), 307, 36, "files/imgs/cage_select.png")
				else
					dxDrawImage(252, (197 + 39 * linha2), 307, 36, Cores[linha2])
				end
				 if isMouseInPosition(260, (207 + 39 * linha2), 16, 16) or selectFav[v[1]] then
					 dxDrawImage(260, (207 + 39 * linha2), 16, 16, "files/imgs/star_select.png")
				 else
					dxDrawImage(260, (207 + 39 * linha2), 16, 16, "files/imgs/star.png")
				 end
				dxDrawText(v[1], 284, (199 + 39 * linha2), 499, (233 + 39 * linha2), tocolor(255, 255, 255, 255), 1.00, font3, "left", "center", false, false, true, false, false)
				dxDrawText("/"..v[2], 331, (199 + 39 * linha2), 546, (233 + 39 * linha2), tocolor(255, 255, 255, 114), 1.00, font3, "right", "center", false, false, true, false, false)
            end
        end
		if getKeyState("mouse1") and isCursorShowing() and (isMouseInPosition(571, cursorY, 2, 45) or rolandobarra) and (#config["Animations"][select] > 6) then
			cursorY,proxPage2 = BarraUtilExata(#config["Animations"][select], 6, 236, 425, "y")
			rolandobarra = true
		end
		dxDrawImage(571, cursorY, 2, 45, "files/imgs/scroll.png")
	elseif window == "roleta" then
		dxDrawRectangle(0, 0, 1366, 768, tocolor(0, 0, 0, 51))
		dxDrawImage(419, 120, 527, 433, "files/imgs/roleta.png")
	 	if tableFavorites then
			linha = 0
	 		for i, v in ipairs(tableFavorites) do
				if isMouseInPosition(config["Icons Positions"][i][1], config["Icons Positions"][i][2], config["Icons Positions"][i][3], config["Icons Positions"][i][4]) then
	 				dxDrawImage(config["Icons Positions"][i][1], config["Icons Positions"][i][2], config["Icons Positions"][i][3], config["Icons Positions"][i][4], "files/imgs/icons_favorite/"..(v.animImage).."_select.png")
					dxDrawText(v.animName, 516, 317, 848, 451, tocolor(255, 255, 255, 255), 1.00, font4, "center", "center", false, false, false, false, false)
	 			else
	 				dxDrawImage(config["Icons Positions"][i][1], config["Icons Positions"][i][2], config["Icons Positions"][i][3], config["Icons Positions"][i][4], "files/imgs/icons_favorite/"..(v.animImage)..".png")
	 			end
	 		end
	 	end
	end
end

addEventHandler('onClientClick', root,
function (button, state)
	if isEventHandlerAdded('onClientRender', root, dx) and button ==  'left' and state == 'down' then
		if window == "index" then
			linha = 0
			for i, v in pairs(config["Interações"]) do
				if (i > proxPage and linha < 6) then
					linha = linha + 1
					if isMouseInPosition(61, (201 + 41 * linha), 158, 27) then
						if v[1] == "VIPS" then
							triggerServerEvent("JOAO.verifyACLVips", localPlayer, localPlayer, i, v[1])
						else
							selectCategory = i
							select = v[1]
						end
					end
				end
			end
			linha2 = 0
			for i, v in pairs(config["Animations"][select]) do
				if (i > proxPage2 and linha2 < 6) then
					linha2 = linha2 + 1
					if isMouseInPosition(252, (197 + 39 * linha2), 307, 36) and not isMouseInPosition(260, (207 + 39 * linha2), 16, 16) then
						triggerServerEvent('JOAO.setAnimation', localPlayer, localPlayer, v[1], v[3], select, v[4])
					 elseif isMouseInPosition(260, (207 + 39 * linha2), 16, 16) then
					 	if selectFav[v[1]] then
					 		triggerServerEvent("JOAO.favoriteAnimation", localPlayer, localPlayer, v, "retirar", config["Interações"][selectCategory][2], select)
					 	else
					 		triggerServerEvent("JOAO.favoriteAnimation", localPlayer, localPlayer, v, "colocar", config["Interações"][selectCategory][2], select)
					 	end
					end
				end
			end
		 elseif window == "roleta" then
		 	linha = 0
		 	for i, v in ipairs(tableFavorites) do
		 		if isMouseInPosition(config["Icons Positions"][i][1], config["Icons Positions"][i][2], config["Icons Positions"][i][3], config["Icons Positions"][i][4]) then
		 			local removeJSON = fromJSON(v.animData)
		 			triggerServerEvent('JOAO.setAnimation', localPlayer, localPlayer, removeJSON["1"], removeJSON["3"], removeJSON.category, removeJSON["4"])
		 		end
		 	end
		end
	end
end)

addEventHandler('onClientKey', root,
function (button, press)
	if button == 'space' and press then
		triggerServerEvent('JOAO.stopAnimation', localPlayer, localPlayer)
	elseif button == 'lshift' and press then
		triggerServerEvent('JOAO.stopAnimation', localPlayer, localPlayer)
	elseif button == 'f6' and press then
		triggerServerEvent('JOAO.stopAnimation', localPlayer, localPlayer)
	end
	if isEventHandlerAdded('onClientRender', root, dx) then
		if button == 'backspace' and press then
			closeMenu()
			--send
		elseif button == 'mouse_wheel_up' and press then
			if window == "index" then
            	if (proxPage2 > 0) then
            	    proxPage2 = proxPage2 - 1
            	end
                if #config["Animations"][select] > 6 then
                    cursorY = MoveBarraUtil(#config["Animations"][select], 6, 236, 425, "y", proxPage2)
                end
			end
		elseif button == 'mouse_wheel_down' and press then
			if window == "index" then
            	proxPage2 = proxPage2 + 1
            	if (proxPage2 > #config["Animations"][select] - 6) then
            	    proxPage2 = #config["Animations"][select] - 6
            	end
                if #config["Animations"][select] > 6 then
                    cursorY = MoveBarraUtil(#config["Animations"][select], 6, 236, 425, "y", proxPage2)
                end
			end
		end 
	end
end)

addEvent("JOAO.changeWindowAnimation", true)
addEventHandler("JOAO.changeWindowAnimation", root,
function(index_, nameWindow_)
	selectCategory = index_
	select = nameWindow_
end)

--[[
bindKey('f2', 'down',
function()
	if not (getElementData(localPlayer, "JOAO.algemado") or false) then
		if not (getElementData(localPlayer, "JOAO.playerPortaMalas") or false) then
			if not isEventHandlerAdded('onClientRender', root, dx) then
				addEventHandler('onClientRender', root, dx)
				showCursor(true)
				window = "index"
				proxPage2 = 0
    		    cursorY = ((236)/screen[1]) * screen[1]
				proxPage = 0
				 triggerServerEvent("JOAO.consultFavorites", localPlayer, localPlayer)
			else
				closeMenu()
			end
		end
	end
end)

 bindKey("tab", "both",
 function(button, state)
 	if not (getElementData(localPlayer, "JOAO.algemado") or false) then
 		if not (getElementData(localPlayer, "JOAO.playerPortaMalas") or false) then
 			if getPedOccupiedVehicle(localPlayer) then
 				if not (getVehicleType(getPedOccupiedVehicle(localPlayer)) == "Helicopter") then
 					if not (getVehicleType(getPedOccupiedVehicle(localPlayer)) == "Plane") then
 						if state == "up" then
 							showChat(true)
 							setElementData(localPlayer, "BloqHud", false)
 							closeMenu()
 						else
 							if not isEventHandlerAdded("onClientRender", root, dx) then
 								triggerServerEvent("JOAO.consultFavorites", localPlayer, localPlayer)
 								addEventHandler('onClientRender', root, dx)
 								showChat(false)
 								setElementData(localPlayer, "BloqHud", true)
 								showCursor(true)
 								window = "roleta"
 							end
 						end
 					end
 				end
 			else
 				if state == "up" then
 					showChat(true)
 					setElementData(localPlayer, "BloqHud", false)
 					closeMenu()
 				else
 					if not isEventHandlerAdded("onClientRender", root, dx) then
 						triggerServerEvent("JOAO.consultFavorites", localPlayer, localPlayer)
 						addEventHandler('onClientRender', root, dx)
 						showChat(false)
 						setElementData(localPlayer, "BloqHud", true)
 						showCursor(true)
 						window = "roleta"
 					end
 				end
 			end
 		end
 	end
 end)
]]

 addEvent("JOAO.sendFavorites", true)
 addEventHandler("JOAO.sendFavorites", root,
 function(tableFavoritesA)
 	tableFavorites = {}
 	selectFav = {}
 	if tableFavoritesA then
 		tableFavorites = tableFavoritesA
 		for i, v in ipairs(tableFavoritesA) do
 			selectFav[v.animName] = true
 		end
 	end
 end)


ossos = {}
posNaTabela = {}

addEvent('JOAO.stopAnimationsClient', true)
addEventHandler('JOAO.stopAnimationsClient', root,
function(player)
	if ossos[player] and #ossos[player] > 0 then
		if posNaTabela[player] then 
			table.remove(playersAnim, posNaTabela[player])
		end 
		ossos[player] = {}
		for i=1, #config.Ossos do 
			updateElementRpHAnim(player)
		end 
	end
end)


addEventHandler('onClientPedsProcessed', root,
function()
	for indx,thePlayersAnim in ipairs(playersAnim) do 
		if thePlayersAnim and isElement(thePlayersAnim) then 
			if isElementStreamedIn(thePlayersAnim) then 
				if ossos[thePlayersAnim] and #ossos[thePlayersAnim] > 0 then
					for i, v in pairs(ossos[thePlayersAnim]) do 
						setElementBoneRotation(thePlayersAnim, v[1], v[2], v[3], v[4])		
						updateElementRpHAnim(thePlayersAnim)
					end
				else 
					table.remove(playersAnim, indx)
				end
			end 
		else 
			table.remove(playersAnim, indx)
		end 
	end 
end)

function BarraUtilExata(TotalConteudos, MaxLinhas, posInicial, posFinal, type)
    if string.lower(type) == "x" then 
        Tela = guiGetScreenSize()
        cy = getCursorPosition()
        posInicial = (posInicial*(Tela/1366)) / Tela
        posFinal = (posFinal*(Tela/1366)) / Tela 
    elseif string.lower(type) == "y" then 
        _,Tela = guiGetScreenSize()
        _,cy = getCursorPosition()
        posInicial = (posInicial*(Tela/768)) / Tela
        posFinal = (posFinal*(Tela/768)) / Tela 
    end  
    if cy >= (posFinal) then 
        cy = (posFinal)
    elseif cy <= (posInicial) then 
        cy = (posInicial)
    end             
    DeltaG = (Tela *  (posFinal)) - (Tela * (posInicial))   
    DeltaA = (Tela *  cy) - (Tela * (posInicial))
    cursorYProgress = Tela * (cy / (Tela/768)) 
    proximaPaginaProgress = (TotalConteudos-MaxLinhas)/DeltaG*(DeltaA)
    return cursorYProgress, proximaPaginaProgress
end 

function MoveBarraUtil(TotalConteudos, MaxLinhas, posInicial, posFinal, type, proximaPaginaNovo)
    if string.lower(type) == "x" then 
        Tela = guiGetScreenSize()
        posInicial = (posInicial*(Tela/1366)) / Tela
        posFinal = (posFinal*(Tela/1366)) / Tela 
    elseif string.lower(type) == "y" then 
        _,Tela = guiGetScreenSize()
        posInicial = (posInicial*(Tela/768)) / Tela
        posFinal = (posFinal*(Tela/768)) / Tela 
    end     
    cy = (((posFinal-posInicial)/(TotalConteudos-MaxLinhas))*proximaPaginaNovo)+posInicial
    DeltaG = math.floor((Tela *  (posFinal)) - (Tela * (posInicial)))    
    DeltaA = math.floor((Tela *  cy) - (Tela * (posInicial)))
    cursorYProgress = Tela * (cy / (Tela/768)) 
    return cursorYProgress
end

function closeMenu()
    if isEventHandlerAdded("onClientRender", root, dx) then
        removeEventHandler("onClientRender", root, dx)
        showCursor(false)
    end
end
addEvent("JOAO.closeMenuAnimacao", true)
addEventHandler("JOAO.closeMenuAnimacao", root, closeMenu)

addEvent('JOAO.setAttachPosition', true)
addEventHandler('JOAO.setAttachPosition', root, function (player, position)
	if not ossos[player] then 
		ossos[player] = {}
	end 
	for i, v in pairs(position) do
		setElementBoneRotation(player, i, v[1], v[2], v[3])
		table.insert(ossos[player], {i, v[1], v[2], v[3], player})
		table.insert(playersAnim, player)
		posNaTabela[player] = #playersAnim
	end
end)

addEvent('JOAO.setarAnimacao', true)
addEventHandler('JOAO.setarAnimacao', root,
function(player, animation)
	setPedAnimation(player, unpack(animation))
end)

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

engineImportTXD(engineLoadTXD("files/object/prancheta.txd", 1933), 1933)
engineReplaceModel(engineLoadDFF("files/object/prancheta.dff", 1933), 1933)
engineImportTXD(engineLoadTXD("files/object/maleta.txd", 1934), 1934)
engineReplaceModel(engineLoadDFF("files/object/maleta.dff", 1934), 1934)
engineImportTXD(engineLoadTXD("files/object/umbrella.txd", 14864), 14864)
engineReplaceModel(engineLoadDFF("files/object/umbrella.dff", 14864), 14864)
engineImportTXD(engineLoadTXD("files/object/camera.txd", 367), 367)
engineReplaceModel(engineLoadDFF("files/object/camera.dff", 367), 367)
engineImportTXD(engineLoadTXD("files/object/radinho.txd", 1429), 1429)
engineReplaceModel(engineLoadDFF("files/object/radinho.dff", 1429), 1429)