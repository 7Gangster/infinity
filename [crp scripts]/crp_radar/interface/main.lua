min, max, cos, sin, rad, deg, atan2 = math.min, math.max, math.cos, math.sin, math.rad, math.deg, math.atan2
sqrt, abs, floor, ceil, random = math.sqrt, math.abs, math.floor, math.ceil, math.random
gsub = string.gsub

createBlip(0, 0, 0, 25)

local screenW,  screenH = guiGetScreenSize()
local sx, sy = screenW/1920, screenH/1080
local Shader = dxCreateShader("files/hud_mask.fx")
local TextureMask = dxCreateTexture("files/mask.png")

if getElementData(localPlayer, "gpsDestination") then
	setElementData(localPlayer, "gpsDestination", false)
end

reMap = function(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

responsiveMultiplier = math.min(1, reMap(screenW, 1024, 1920, 0.75, 1))

resp = function(value)
	return value * responsiveMultiplier
end

respc = function(value)
	return ceil(value * responsiveMultiplier)
end


local function rotateAround(angle, x, y)
	angle = math.rad(angle)
	local cosinus, sinus = math.cos(angle), math.sin(angle)
	return x * cosinus - y * sinus, x * sinus + y * cosinus
end


local BlipsSelect = {}

local mapTextureSize = 3072
local mapRatio = 6000 / mapTextureSize

local minimapPosX = 0
local minimapPosY = 0
local minimapWidth = respc(320)
local minimapHeight = respc(225)
local minimapCenterX = minimapPosX + minimapWidth / 2
local minimapCenterY = minimapPosY + minimapHeight / 2
local minimapRenderSize = 175
local minimapRenderHalfSize = minimapRenderSize * 0.5
local minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize)
dxSetShaderValue(Shader, "sPicTexture", minimapRender)
dxSetShaderValue(Shader, "sMaskTexture", TextureMask)

local playerMinimapZoom = 0.5
local minimapZoom = playerMinimapZoom
local minimapIsVisible = true

local bigmapPosX = 0
local bigmapPosY = 0
local bigmapWidth = screenW
local bigmapHeight = screenH
local bigmapCenterX = bigmapPosX + bigmapWidth / 2
local bigmapCenterY = bigmapPosY + bigmapHeight / 2
local bigmapZoom = 0.5
local bigmapIsVisible = false

local lastCursorPos = false
local mapDifferencePos = false
local mapMovedPos = false
local lastDifferencePos = false
local mapIsMoving = false
local lastMapPosX, lastMapPosY = 0, 0
local mapPlayerPosX, mapPlayerPosY = 0, 0

local zoneLineHeight = respc(30)
local screenSource = dxCreateScreenSource(screenW, screenH)

local gpsLineWidth = respc(60)
local gpsLineIconSize = respc(40)
local gpsLineIconHalfSize = gpsLineIconSize / 2
local createdTextures = {}

createdFonts = {}




local visibleBlipTooltip = false
local hoveredWaypointBlip = false

local farshowBlips = {}
local farshowBlipsData = {}

local gpsHello = false
local gpsLines = {}
local gpsRouteImage = false
local gpsRouteImageData = {}


local playerCanSeePlayers = false

local getZoneNameEx = getZoneName
function getZoneName(x, y, z, citiesonly)
	local zoneName = getZoneNameEx(x, y, z, citiesonly)
	if zoneName == "Greenglass College" then
		return "Las Venturas City Hall"
	else
		return zoneName
	end
end

function getTexture(name)
	if createdTextures[name] then
		return createdTextures[name]
	end

	return false
end



local textura = dxCreateTexture("files/radar.png", "argb", false, "clamp")

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		showPlayerHudComponent ("radar", false )
    	createdTextures = {
			minimapMap = textura,
			bigmapMap = textura,
		}

		initFont("Roboto", "Roboto.ttf", 14)
		initFont("Bold", "SFProDisplayBold.otf", 13)
		initFont("Medium", "SFProDisplayMedium.otf", 12)
		if getTexture("minimapMap") then
			dxSetTextureEdge(getTexture("minimapMap"), "border", tocolor(125, 168, 210))
		end
		if getTexture("bigmapMap") then
			dxSetTextureEdge(getTexture("bigmapMap"), "border", tocolor(0, 0, 0, 0))
		end

	end
)


addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if source == localPlayer then
			if dataName == "gpsDestination" then
				local dataValue = getElementData(source, dataName) or false
				if dataValue then
					gpsThread = coroutine.create(makeRoute)
					coroutine.resume(gpsThread, unpack(dataValue))
					waypointInterpolation = false
				else
					endRoute()
				end
			end
		end
	end
)


addEventHandler("onClientPlayerJoin", getRootElement(),
	function ()
		showPlayerHudComponent ("radar", false )
	end
)

addEventHandler("onClientRender", getRootElement(),
	function ()
		if (getPedOccupiedVehicle(localPlayer) or getElementData(localPlayer, "gpsDestination")) then
			renderMinimap(POSITION, screenH - ALTURA, LARGURA, COMPRIMENTO)
		end
	end
)

function renderMap(x, y, w, h, pX, pY)
	_dxDrawImageSection(x, y, w, h, remapTheSecondWay(pX) - w / minimapZoom / 2, remapTheFirstWay(pY) - h / minimapZoom / 2, w / minimapZoom, h / minimapZoom, textura)
	local PosX = (x + (w/2)) - (14/2)
	local PosY = (y + (h/2)) - (14/2)
	_dxDrawImage(PosX - 15, PosY - 15, 16 + 30, 16 + 30, "files/effectWaypoint.png")
	_dxDrawImage(PosX, PosY, 16, 16, "files/waypoint.png")
end

addEventHandler("onClientRender", getRootElement(),
function()
	renderTheBigmap()
end
)




function renderMinimap(x, y, w, h)
	if bigmapIsVisible or not minimapIsVisible then 
		return
	end

	minimapWidth = w
	minimapHeight = h



	if minimapPosX ~= x or minimapPosY ~= y then
		minimapPosX = x
		minimapPosY = y
	end

	minimapCenterX = minimapPosX + minimapWidth / 2
	minimapCenterY = minimapPosY + minimapHeight / 2

	dxUpdateScreenSource(screenSource, true)

	if getKeyState("num_add") and playerMinimapZoom < 1.2 then
		playerMinimapZoom = playerMinimapZoom + 0.01
	elseif getKeyState("num_sub") and playerMinimapZoom > 0.31 then
		playerMinimapZoom = playerMinimapZoom - 0.01
	end

	minimapZoom = playerMinimapZoom

	local Vehicle = getPedOccupiedVehicle(localPlayer)
	if Vehicle then
		local vehicleZoom = getVehicleSpeed(Vehicle) / 1300
		if vehicleZoom >= 0.4 then
			vehicleZoom = 0.4
		end
		minimapZoom = minimapZoom - vehicleZoom
	end

	local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
	local playerDimension = getElementDimension(localPlayer)
	local cameraX, cameraY, _, faceTowardX, faceTowardY = getCameraMatrix()
	local cameraRotation = deg(atan2(faceTowardY - cameraY, faceTowardX - cameraX)) + 360 + 90

	local minimapRenderSizeOffset = respc(minimapRenderSize * 0.75)

	farshowBlips = {}
	farshowBlipsData = {}

	if playerDimension == 0 or playerDimension == 65000 or playerDimension == 33333 then
		local remapPlayerPosX, remapPlayerPosY = remapTheFirstWay(playerPosX), remapTheFirstWay(playerPosY)
		local farBlips = {}
		local farBlipsCount = 10000
		local manualBlipsCount = 1
		local defaultBlipsCount = 1

		dxSetRenderTarget(minimapRender, true)
		_dxDrawRectangle(0, 0, minimapRenderSize, minimapRenderSize, tocolor(125, 168, 210, 255))
		_dxDrawImageSection(0, 0, minimapRenderSize, minimapRenderSize, remapTheSecondWay(playerPosX) - minimapRenderSize / minimapZoom / 2, remapTheFirstWay(playerPosY) - minimapRenderSize / minimapZoom / 2, minimapRenderSize / minimapZoom, minimapRenderSize / minimapZoom, textura)

		if gpsRouteImage then
			_dxDrawImage(minimapRenderSize / 2 + (remapTheFirstWay(playerPosX) - (gpsRouteImageData[1] + gpsRouteImageData[3] / 2)) * minimapZoom - gpsRouteImageData[3] * minimapZoom / 2, minimapRenderSize / 2 - (remapTheFirstWay(playerPosY) - (gpsRouteImageData[2] + gpsRouteImageData[4] / 2)) * minimapZoom + gpsRouteImageData[4] * minimapZoom / 2, gpsRouteImageData[3] * minimapZoom, -(gpsRouteImageData[4] * minimapZoom), gpsRouteImage, 180, 0, 0, tocolor(R, G, B, A))
		end


		local defaultBlips = getElementsByType("blip")
		for i = 1, #defaultBlips do
			if defaultBlips[i] then
				local tableId = farBlipsCount + manualBlipsCount + defaultBlipsCount
				local blipPosX, blipPosY = getElementPosition(defaultBlips[i])
				local blipIcon = getBlipIcon(defaultBlips[i])
				local blipImage = BlipsConfig[blipIcon] and BlipsConfig[blipIcon][2]..".png" or "0.png"
				farBlips[tableId] = blipImage
				local Tamanho = BlipsConfig[blipIcon] and {BlipsConfig[blipIcon][3], BlipsConfig[blipIcon][4]} or {16, 16}
				local cor = BlipsConfig[blipIcon] and BlipsConfig[blipIcon].cor or {255, 255, 255}
				renderBlip("blips/"..blipImage.."", blipPosX, blipPosY, remapPlayerPosX, remapPlayerPosY, Tamanho[1], Tamanho[2], tocolor(cor[1], cor[2], cor[3], 255), cameraRotation, true, tableId)
				defaultBlipsCount = defaultBlipsCount + 1
			end
		end

		local Posicoes = getElementData(localPlayer, "gpsDestination")
		if Posicoes then
			local tableId = farBlipsCount + manualBlipsCount + defaultBlipsCount
			renderBlip("blips/41.png", Posicoes[1], Posicoes[2], remapPlayerPosX, remapPlayerPosY, 16, 16, tocolor(255, 255, 255, 255), cameraRotation, true, tableId)
			farBlips[41] = "41.png"
			defaultBlipsCount = defaultBlipsCount + 1
		end

		dxSetRenderTarget()
		
		--_dxDrawImage(minimapPosX - minimapRenderSize / 2 + minimapWidth / 2 - 6, minimapPosY - minimapRenderSize / 2 + minimapHeight / 2 - 6, minimapRenderSize + 12, minimapRenderSize + 12, "files/mask2.png")
		_dxDrawImage(minimapPosX - minimapRenderSize / 2 + minimapWidth / 2, minimapPosY - minimapRenderSize / 2 + minimapHeight / 2, minimapRenderSize, minimapRenderSize, Shader, cameraRotation - 180, 0, 0, tocolor(255, 255, 255, 0.9*255))



	end


	if playerDimension == 0 then
		local playerArrowSize = 60 / (4 - minimapZoom) + 3
		local playerArrowHalfSize = playerArrowSize / 2
		local _, _, playerRotation = getElementRotation(localPlayer)

		_dxDrawImage(minimapCenterX - playerArrowHalfSize, minimapCenterY - playerArrowHalfSize, playerArrowSize, playerArrowSize, "files/arrow.png", abs(360 - playerRotation) + (cameraRotation - 180))
		

		if gpsRoute or (not gpsRoute and waypointEndInterpolation) then
			local naviX = minimapPosX + minimapWidth - gpsLineWidth
			local naviCenterY = minimapPosY + (minimapHeight - zoneLineHeight) / 2

			if waypointEndInterpolation then
				local interpolationProgress = (getTickCount() - waypointEndInterpolation) / 500
				local interpolateAlpha = interpolateBetween(1, 0, 0, 0, 0, 0, interpolationProgress, "Linear")


				if interpolationProgress > 1 then
					waypointEndInterpolation = false
				end
			end
		end


	end

	
end

local Filtro = {
	["Comércio"] = true,
	["Empregos"] = true,
	["Governamentais"] = true,
	["Garagens"] = true,
	["Lixeiras"] = true,
	["ATM"] = true,
	["Zonas"] = true,
	["Outros"] = true,
}

local Filter = nil

local FiltrosFormat = {"Comércio", "Empregos", "Governamentais", "Garagens", "Lixeiras", "ATM", "Zonas", "Outros"}

function renderTheBigmap()
	if not bigmapIsVisible then
		return
	end

	if hoveredWaypointBlip then
		hoveredWaypointBlip = false
	end



	if getElementDimension(localPlayer) == 0 then
		local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)

		cursorX, cursorY = getHudCursorPos()
		if cursorX and cursorY then
			cursorX, cursorY = cursorX * screenW, cursorY * screenH

			if getKeyState("mouse1") then
				if not lastCursorPos then
					lastCursorPos = {cursorX, cursorY}
				end

				if not mapDifferencePos then
					mapDifferencePos = {0, 0}
				end

				if not lastDifferencePos then
					if not mapMovedPos then
						lastDifferencePos = {0, 0}
					else
						lastDifferencePos = {mapMovedPos[1], mapMovedPos[2]}
					end
				end
				
				mapDifferencePos = {mapDifferencePos[1] + cursorX - lastCursorPos[1], mapDifferencePos[2] + cursorY - lastCursorPos[2]}

				if not mapMovedPos then
					if abs(mapDifferencePos[1]) >= 3 or abs(mapDifferencePos[2]) >= 3 then
						mapMovedPos = {lastDifferencePos[1] - mapDifferencePos[1] / bigmapZoom, lastDifferencePos[2] + mapDifferencePos[2] / bigmapZoom}
						mapIsMoving = true
					end
				elseif mapDifferencePos[1] ~= 0 or mapDifferencePos[2] ~= 0 then
					mapMovedPos = {lastDifferencePos[1] - mapDifferencePos[1] / bigmapZoom, lastDifferencePos[2] + mapDifferencePos[2] / bigmapZoom}
					mapIsMoving = true
				end

				lastCursorPos = {cursorX, cursorY}
			else
				if mapMovedPos then
					lastDifferencePos = {mapMovedPos[1], mapMovedPos[2]}
				end

				lastCursorPos = false
				mapDifferencePos = false
			end
		end

		mapPlayerPosX, mapPlayerPosY = lastMapPosX, lastMapPosY

		if mapMovedPos then
			mapPlayerPosX = mapPlayerPosX + mapMovedPos[1]
			mapPlayerPosY = mapPlayerPosY + mapMovedPos[2]
		else
			mapPlayerPosX, mapPlayerPosY = playerPosX, playerPosY
			lastMapPosX, lastMapPosY = mapPlayerPosX, mapPlayerPosY
		end
		
		_dxDrawRectangle(bigmapPosX-50, bigmapPosY-50, bigmapWidth+120, bigmapHeight+120, tocolor(125, 168, 210, 255))
		_dxDrawImageSection(bigmapPosX, bigmapPosY, bigmapWidth, bigmapHeight, remapTheSecondWay(mapPlayerPosX) - bigmapWidth / bigmapZoom / 2, remapTheFirstWay(mapPlayerPosY) - bigmapHeight / bigmapZoom / 2, bigmapWidth / bigmapZoom, bigmapHeight / bigmapZoom, getTexture("bigmapMap"))

		if gpsRouteImage then
			dxUpdateScreenSource(screenSource, true)
			_dxDrawImage(bigmapCenterX + (remapTheFirstWay(mapPlayerPosX) - (gpsRouteImageData[1] + gpsRouteImageData[3] / 2)) * bigmapZoom - gpsRouteImageData[3] * bigmapZoom / 2, bigmapCenterY - (remapTheFirstWay(mapPlayerPosY) - (gpsRouteImageData[2] + gpsRouteImageData[4] / 2)) * bigmapZoom + gpsRouteImageData[4] * bigmapZoom / 2, gpsRouteImageData[3] * bigmapZoom, -(gpsRouteImageData[4] * bigmapZoom), gpsRouteImage, 180, 0, 0, tocolor(R, G, B, E))
			_dxDrawImageSection(0, 0, bigmapPosX, screenH, 0, 0, bigmapPosX, screenH, screenSource)
			_dxDrawImageSection(screenW - bigmapPosX, 0, bigmapPosX, screenH, screenW - bigmapPosX, 0, bigmapPosX, screenH, screenSource)
			_dxDrawImageSection(bigmapPosX, 0, screenW - 2 * bigmapPosX, bigmapPosY, bigmapPosX, 0, screenW - 2 * bigmapPosX, bigmapPosY, screenSource)
			_dxDrawImageSection(bigmapPosX, screenH - bigmapPosY, screenW - 2 * bigmapPosX, bigmapPosY, bigmapPosX, screenH - bigmapPosY, screenW - 2 * bigmapPosX, bigmapPosY, screenSource)
		end
		
		local Blips = getElementsByType("blip")
		for i = 1,#Blips do
			local v = Blips[i]
			if getElementAttachedTo(v) ~= localPlayer then
				local blipPosX, blipPosY = getElementPosition(v)
				local blipIcon = getBlipIcon(v)
				local blipImage = BlipsConfig[blipIcon] and BlipsConfig[blipIcon][2]..".png" or "0.png"
				local Tamanho = BlipsConfig[blipIcon] and {BlipsConfig[blipIcon][3], BlipsConfig[blipIcon][4]} or {16, 16}
				local cor = BlipsConfig[blipIcon] and BlipsConfig[blipIcon].cor or {255, 255, 255}

				if (not BlipsConfig[blipIcon]) then
					renderBigBlip("blips/"..blipImage.."", blipPosX, blipPosY, mapPlayerPosX, mapPlayerPosY, 0, Tamanho[1], Tamanho[2], tocolor(cor[1], cor[2], cor[3], 255), v, k)
				else
					local FiltroBlip = BlipsConfig[blipIcon][5] or "Outros"
					if BlipsConfig[blipIcon][1] == "Destino" or Filtro[FiltroBlip] then
						renderBigBlip("blips/"..blipImage.."", blipPosX, blipPosY, mapPlayerPosX, mapPlayerPosY, 0, Tamanho[1], Tamanho[2], tocolor(cor[1], cor[2], cor[3], 255), v, k)
					end
				end
			end
		end
		local Posicoes = getElementData(localPlayer, "gpsDestination")
		if Posicoes then
			renderBigBlip("blips/41.png", Posicoes[1], Posicoes[2], mapPlayerPosX, mapPlayerPosY, 0, 16, 16, tocolor(255, 255, 255, 255))
		end


		renderBigBlip("arrow.png", playerPosX, playerPosY, mapPlayerPosX, mapPlayerPosY, false, 20, 20)

		if mapMovedPos then
			renderBigBlip("cross.png", mapPlayerPosX, mapPlayerPosY, mapPlayerPosX, mapPlayerPosY, false, 128, 128)
		end



		if cursorX and cursorY then
			local zoneX = reMap((cursorX - bigmapPosX) / bigmapZoom + (remapTheSecondWay(mapPlayerPosX) - bigmapWidth / bigmapZoom / 2), 0, mapTextureSize, -3000, 3000)
			local zoneY = reMap((cursorY - bigmapPosY) / bigmapZoom + (remapTheFirstWay(mapPlayerPosY) - bigmapHeight / bigmapZoom / 2), 0, mapTextureSize, 3000, -3000)


			if visibleBlipTooltip then
				_dxDrawRectangle(cursorX + respc(12.5), cursorY, dxGetTextWidth(visibleBlipTooltip, 0.75, getFont("Roboto")) + respc(10), respc(25), tocolor(0, 0, 0, 150))
				_dxDrawText(visibleBlipTooltip, cursorX + respc(12.5), cursorY, cursorX + (dxGetTextWidth(visibleBlipTooltip, 0.75, getFont("Roboto")) + respc(10)) + respc(12.5), cursorY + respc(25), 0xFFFFFFFF, 0.75, getFont("Roboto"), "center", "center")
			end
	
		end


	

		if visibleBlipTooltip then
			visibleBlipTooltip = false
		end

		if mapMovedPos then
			_dxDrawText("Pressione #8800EEESPAÇO#FFFFFF para voltar a sua posição atual", bigmapPosX, bigmapPosY + bigmapHeight - zoneLineHeight, bigmapPosX + bigmapWidth, bigmapPosY + bigmapHeight, 0xFFFFFFFF, 1, getFont("Medium"), "center", "center", false, false, false, true)

			if getKeyState("space") then
				mapMovedPos = false
				lastDifferencePos = false
			end
		end
		

		dxDrawBordRectangle(50, 50, 111, 51, 9, isCursorOnElement(50, 50, 111, 51) and tocolor(116, 121, 125, 64) or tocolor(71, 75, 79, 64))
		_dxDrawImage(71, 66, 19, 19, "files/filter.png")
		_dxDrawText("Filtro", 99, 50, 40, 51 + 50, tocolor(255, 255, 255, 255), 1, getFont("Bold"), "left", "center")
		if Filter then
			for i = 1,#FiltrosFormat do
				local v = FiltrosFormat[i]
				local Width = dxGetTextWidth(v, 1, getFont("Medium"))
				dxDrawBordRectangle(50, 108 - 43 + (43 * i), 55 + Width, 40, 9, isCursorOnElement(50, 108 - 43 + (43 * i), 55 + Width, 40) and tocolor(116, 121, 125, 64) or tocolor(71, 75, 79, 64))
				_dxDrawImage(64, 121 - 43 + (43 * i), 14, 14, Filtro[v] and "files/circle2.png" or "files/circle.png")
				_dxDrawText(v, 92, 108 - 43 + (43 * i), 64, 40 + (108 - 43 + (43 * i)), tocolor(255, 255, 255, 255), 1, getFont("Medium"), "left", "center")
			end
		end
		for i = 1,8 do
			local Index = BlipsSelect.Scroll[i]
			if #BlipsSelect.Blips >= Index then
				local Name = BlipsConfig[ BlipsSelect.Blips[Index].Blip ][1].." <"..BlipsSelect.Blips[Index].Select.."/"..#BlipsSelect.Blips[Index].Blips..">"
				local Width = dxGetTextWidth(Name, 1, getFont("Medium"))
				local cor = BlipsConfig[ BlipsSelect.Blips[Index].Blip ] and BlipsConfig[ BlipsSelect.Blips[Index].Blip ].cor or {255, 255, 255}

				dxDrawBordRectangle(screenW - 103 - Width, 50 - 50 + (50 * i), 53 + Width, 43, 9, (isCursorOnElement(screenW - 103 - Width, 50 - 50 + (50 * i), 53 + Width, 43) or BlipsSelect.Pressed == Index) and tocolor(116, 121, 125, 64) or tocolor(71, 75, 79, 64))
				_dxDrawText(Name, screenW - 103 - Width + 9, 50 - 50 + (50 * i), 0, 43 + (50 - 50 + (50 * i)), tocolor(255, 255, 255, 255), 1, getFont("Medium"), "left", "center")
				_dxDrawImage(screenW - 82, 63 - 50 + (50 * i), 16, 16, "files/blips/"..BlipsConfig[ BlipsSelect.Blips[Index].Blip ][2]..".png", 0, 0, 0, tocolor(cor[1], cor[2], cor[3], 255))
			end
		end
		
	end
end

function FormatBlips()
	local TabelaBlips = {}
	local Index = {}
	local Blips = getElementsByType("blip")
	for i = 1,#Blips do
		local v = Blips[i]
		if getElementAttachedTo(v) ~= localPlayer then
			local blipPosX, blipPosY = getElementPosition(v)
			local blipIcon = getBlipIcon(v)
			local FiltroBlip = BlipsConfig[blipIcon] and BlipsConfig[blipIcon][5] or "Outros"
			if BlipsConfig[blipIcon] and (BlipsConfig[blipIcon][1] == "Destino" or Filtro[FiltroBlip]) then
				if not Index[blipIcon] then
					TabelaBlips[#TabelaBlips + 1] = {Blip = blipIcon, Select = 1, Blips = {{blipIcon, blipPosX, blipPosY, v}}}
					Index[blipIcon] = #TabelaBlips
				else
					TabelaBlips[ Index[blipIcon] ].Blips[#TabelaBlips[ Index[blipIcon] ].Blips + 1] = {blipIcon, blipPosX, blipPosY, v}
				end
			end
		end
	end
	return TabelaBlips
end

function isCursorOnElement(x, y, w, h)
	if (not isCursorShowing()) then
		return false
	end
	local mx, my = getCursorPosition()
	local fullx, fully = guiGetScreenSize()
	cursorx, cursory = mx*fullx, my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end

local SvgsRectangle = {}

function dxDrawBordRectangle(x, y, w, h, radius, color, post)
    if not SvgsRectangle[radius] then
        SvgsRectangle[radius] = {}
    end
    if not SvgsRectangle[radius][w] then
        SvgsRectangle[radius][w] = {}
    end
    if not SvgsRectangle[radius][w][h] then
        local Path = string.format([[
            <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect opacity="1" width="%s" height="%s" rx="%s" fill="#FFFFFF"/>
            </svg>
        ]], w, h, w, h, w, h, radius)
        SvgsRectangle[radius][w][h] = svgCreate(w, h, Path)
    end
    if SvgsRectangle[radius][w][h] then
        _dxDrawImage(x, y, w, h, SvgsRectangle[radius][w][h], 0, 0, 0, color, post)
    end
end

function clearSvgs()
    for radius, wTable in pairs(SvgsRectangle) do
        for w, hTable in pairs(wTable) do
            for h, svg in pairs(hTable) do
                destroyElement(svg)
                SvgsRectangle[radius][w][h] = nil
            end
        end
    end
end

function getRadarOpen()
	return bigmapIsVisible
end

addEventHandler("onClientKey", getRootElement(),
	function (key, pressDown)
		if key == "F11" and pressDown and getElementDimension(localPlayer) == 0 then
			if bigmapIsVisible and true or not bigmapIsVisible then
				if getElementData(localPlayer, "ID") then
					bigmapIsVisible = not bigmapIsVisible
					if bigmapIsVisible then
						-- showCursor(true)
						BlipsSelect.Pressed = false
						BlipsSelect.Blips = FormatBlips()
						BlipsSelect.Scroll = {}
						exports.crp_hud:setVisible(false)
						showCursor(true)
						for i = 1,8 do
							BlipsSelect.Scroll[i] = i
						end
						--exports.bca_person:setOpenRender("Radar")
						exports.crp_hud:setVisible(false)
					else
						if gpsHello and isElement(gpsHello) then
							destroyElement(gpsHello)
						end
						gpsHello = false
						showCursor(false)
						clearSvgs()
						exports.crp_hud:setVisible(true)
						--exports.bca_person:setOpenRender(nil)
						-- showCursor(false)
					end
				end
			end

			cancelEvent()
		elseif key == "mouse_wheel_up" then
			if isCursorOnElement(screenW - 272, 50, 222, 393) then
				if BlipsSelect.Scroll[1] ~= 1 then
					for i = 1,8 do
						BlipsSelect.Scroll[i] = BlipsSelect.Scroll[i] - 1
					end
				end
			else
				if pressDown then
					if bigmapIsVisible and bigmapZoom + 0.1 <= 2.1 then
						bigmapZoom = bigmapZoom + 0.1
					end
				end
			end
		elseif key == "mouse_wheel_down" then
			if isCursorOnElement(screenW - 272, 50, 222, 393) then
				local Index = BlipsSelect.Scroll[#BlipsSelect.Scroll] + 1
				if #BlipsSelect.Blips >= Index then
					for i = 1,8 do
						BlipsSelect.Scroll[i] = BlipsSelect.Scroll[i] + 1
					end
				end
			else
				if pressDown then
					if bigmapIsVisible and bigmapZoom - 0.1 >= 0.4 then
						bigmapZoom = bigmapZoom - 0.1
					end
				end
			end
		end
	end
)

addEventHandler("onClientClick", getRootElement(),
	function (button, state, cursorX, cursorY)
		if not bigmapIsVisible then
			return
		end
		if state == "down" then
			if isCursorOnElement(50, 50, 111, 51) then
				Filter = not Filter
				return
			end
			if Filter then
				for i = 1,#FiltrosFormat do
					local v = FiltrosFormat[i]
					local Width = dxGetTextWidth(v, 1, getFont("Medium"))
					if isCursorOnElement(50, 108 - 43 + (43 * i), 55 + Width, 40) then
						Filtro[v] = not Filtro[v]
						return
					end
				end
			end
			for i = 1,8 do
				local Index = BlipsSelect.Scroll[i]
				if #BlipsSelect.Blips >= Index then
					local Name = BlipsConfig[ BlipsSelect.Blips[Index].Blip ][1].." <"..BlipsSelect.Blips[Index].Select.."/"..#BlipsSelect.Blips[Index].Blips..">"
					local Width = dxGetTextWidth(Name, 1, getFont("Medium"))
					if isCursorOnElement(screenW - 103 - Width, 50 - 50 + (50 * i), 53 + Width, 43) then
						if BlipsSelect.Pressed == Index then
							BlipsSelect.Pressed = nil
						else
							BlipsSelect.Pressed = Index
							mapDifferencePos = {0, 0}
							lastDifferencePos = {0, 0}
							mapMovedPos = {0, 0}
							mapPlayerPosX, mapPlayerPosY = BlipsSelect.Blips[Index].Blips[ BlipsSelect.Blips[Index].Select ][2], BlipsSelect.Blips[Index].Blips[ BlipsSelect.Blips[Index].Select ][3]
							lastMapPosX, lastMapPosY = mapPlayerPosX, mapPlayerPosY
						end
						return
					end
				end
			end
		end
		if state == "up" and mapIsMoving then
			mapIsMoving = false
			return
		end

		local gpsRouteProcess = false
		if button == "right" and state == "up" then
			if getElementData(localPlayer, "gpsDestination") then
				setElementData(localPlayer, "gpsDestination", false)
			else
                if isPedInVehicle(localPlayer) then
                    for i,v in pairs(getVehicleOccupants( getPedOccupiedVehicle(localPlayer) )) do
        				setElementData(v, "gpsDestination", {
        					reMap((cursorX - bigmapPosX) / bigmapZoom + (remapTheSecondWay(mapPlayerPosX) - bigmapWidth / bigmapZoom / 2), 0, mapTextureSize, -3000, 3000),
        					reMap((cursorY - bigmapPosY) / bigmapZoom + (remapTheFirstWay(mapPlayerPosY) - bigmapHeight / bigmapZoom / 2), 0, mapTextureSize, 3000, -3000)
        				})
                    end
                else
                    setElementData(localPlayer, "gpsDestination", {
                            reMap((cursorX - bigmapPosX) / bigmapZoom + (remapTheSecondWay(mapPlayerPosX) - bigmapWidth / bigmapZoom / 2), 0, mapTextureSize, -3000, 3000),
                            reMap((cursorY - bigmapPosY) / bigmapZoom + (remapTheFirstWay(mapPlayerPosY) - bigmapHeight / bigmapZoom / 2), 0, mapTextureSize, 3000, -3000)
                        })
                end
			end
			gpsRouteProcess = true
		end


	end
)

function moveKey(b)
	if bigmapIsVisible and BlipsSelect.Pressed then
		if b == "arrow_r" and BlipsSelect.Blips[ BlipsSelect.Pressed ].Select ~= #BlipsSelect.Blips[ BlipsSelect.Pressed ].Blips then
			BlipsSelect.Blips[ BlipsSelect.Pressed ].Select = BlipsSelect.Blips[ BlipsSelect.Pressed ].Select + 1
		elseif b == "arrow_l" and BlipsSelect.Blips[ BlipsSelect.Pressed ].Select ~= 1  then
			BlipsSelect.Blips[ BlipsSelect.Pressed ].Select = BlipsSelect.Blips[ BlipsSelect.Pressed ].Select - 1
		end
		mapDifferencePos = {0, 0}
		lastDifferencePos = {0, 0}
		mapMovedPos = {0, 0}
		mapPlayerPosX, mapPlayerPosY = BlipsSelect.Blips[ BlipsSelect.Pressed ].Blips[ BlipsSelect.Blips[ BlipsSelect.Pressed ].Select ][2], BlipsSelect.Blips[ BlipsSelect.Pressed ].Blips[ BlipsSelect.Blips[ BlipsSelect.Pressed ].Select ][3]
		lastMapPosX, lastMapPosY = mapPlayerPosX, mapPlayerPosY
	end
end
bindKey("arrow_r", "down", moveKey)
bindKey("arrow_l", "down", moveKey)

addEventHandler("onClientRestore", getRootElement(),
	function ()
		if gpsRoute then
			processGPSLines()
		end
	end
)

function renderBlip(icon, blipX, blipY, playerPosX, playerPosY, blipWidth, blipHeight, blipColor, cameraRotation, farShow, blipTableId)
	local blipPosX = minimapRenderHalfSize + (playerPosX - remapTheFirstWay(blipX)) * minimapZoom
	local blipPosY = minimapRenderHalfSize - (playerPosY - remapTheFirstWay(blipY)) * minimapZoom

	if not farShow and (blipPosX > minimapRenderSize or 0 > blipPosX or blipPosY > minimapRenderSize or 0 > blipPosY) then
		return
	end

	local blipIsVisible = true
	if farShow then
		if blipPosX > minimapRenderSize then
			blipPosX = minimapRenderSize
		end
		if blipPosX < 0 then
			blipPosX = 0
		end
		if blipPosY > minimapRenderSize then
			blipPosY = minimapRenderSize
		end
		if blipPosY < 0 then
			blipPosY = 0
		end

		local angle = rad((cameraRotation - 270) + 90)
		local cosinus, sinus = cos(angle), sin(angle)

		local blipScreenPosX = minimapPosX - minimapRenderHalfSize + minimapWidth / 2 + (minimapRenderHalfSize + cosinus * (blipPosX - minimapRenderHalfSize) - sinus * (blipPosY - minimapRenderHalfSize) - blipWidth / 2)
		local blipScreenPosY = minimapPosY - minimapRenderHalfSize + minimapHeight / 2 + (minimapRenderHalfSize + sinus * (blipPosX - minimapRenderHalfSize) + cosinus * (blipPosY - minimapRenderHalfSize) - blipHeight / 2)

		farshowBlips[blipTableId] = nil

		if blipScreenPosX < minimapPosX or blipScreenPosX > minimapPosX + minimapWidth - blipWidth then
			farshowBlips[blipTableId] = true
			blipIsVisible = false
		end

		if blipScreenPosY < minimapPosY or blipScreenPosY > minimapPosY + minimapHeight - zoneLineHeight - blipHeight then
			farshowBlips[blipTableId] = true
			blipIsVisible = false
		end

		if farshowBlips[blipTableId] then
			farshowBlipsData[blipTableId] = {
				posX = max(minimapPosX, min(minimapPosX + minimapWidth - blipWidth, blipScreenPosX)),
				posY = max(minimapPosY, min(minimapPosY + minimapHeight - zoneLineHeight - blipHeight, blipScreenPosY)),
				icon = icon,
				iconWidth = blipWidth,
				iconHeight = blipHeight,
				color = blipColor
			}
		end
	end

	if blipIsVisible then
		_dxDrawImage(blipPosX - blipWidth / 2, blipPosY - blipHeight / 2, blipWidth, blipHeight, "files/"..icon.."", 180 - cameraRotation, 0, 0, blipColor)
	end
end

function renderBigBlip(icon, blipX, blipY, playerPosX, playerPosY, renderDistance, blipWidth, blipHeight, blipColor, blipElement, blipId)

	local bw, bh = blipWidht, blipHeight
	local bx, by = blipX, blipY
	blipWidth = (blipWidth / (4 - bigmapZoom) + 3) * 2.25
	blipHeight = (blipHeight / (4 - bigmapZoom) + 3) * 2.25

	local blipHalfWidth = blipWidth / 2
	local blipHalfHeight = blipHeight / 2

	blipX = max(bigmapPosX + blipHalfWidth, min(bigmapPosX + bigmapWidth - blipHalfWidth, bigmapCenterX + (remapTheFirstWay(playerPosX) - remapTheFirstWay(blipX)) * bigmapZoom))
	blipY = max(bigmapPosY + blipHalfHeight, min(bigmapPosY + bigmapHeight - blipHalfHeight - zoneLineHeight, bigmapCenterY - (remapTheFirstWay(playerPosY) - remapTheFirstWay(blipY)) * bigmapZoom))

	if icon == "arrow.png" then
		local _, _, playerRotation = getElementRotation(localPlayer)
		_dxDrawImage(blipX - blipHalfWidth, blipY - blipHalfHeight, blipWidth, blipHeight, "files/" .. icon, abs(360 - playerRotation))
	else
		_dxDrawImage(blipX - blipHalfWidth, blipY - blipHalfHeight, blipWidth, blipHeight, "files/" .. icon, 0, 0, 0, blipColor)
	end

	if cursorX and cursorY then
		if isElement(blipElement) then
			if isCursorWithinArea(cursorX, cursorY, blipX - blipHalfWidth, blipY - blipHalfHeight, blipWidth, blipHeight) then
				local BlipIcon = getBlipIcon(blipElement)
				if BlipsConfig[BlipIcon] then
					visibleBlipTooltip = BlipsConfig[BlipIcon][1]
				end
			end
		end
	end
end

function remapTheFirstWay(coord)
	return (-coord + 3000) / mapRatio
end

function remapTheSecondWay(coord)
	return (coord + 3000) / mapRatio
end

function addGPSLine(x, y)
	table.insert(gpsLines, {remapTheFirstWay(x), remapTheFirstWay(y)})
end

function processGPSLines()
	local routeStartPosX, routeStartPosY = 99999, 99999
	local routeEndPosX, routeEndPosY = -99999, -99999

	for i = 1, #gpsLines do
		if gpsLines[i][1] < routeStartPosX then
			routeStartPosX = gpsLines[i][1]
		end

		if gpsLines[i][2] < routeStartPosY then
			routeStartPosY = gpsLines[i][2]
		end

		if gpsLines[i][1] > routeEndPosX then
			routeEndPosX = gpsLines[i][1]
		end

		if gpsLines[i][2] > routeEndPosY then
			routeEndPosY = gpsLines[i][2]
		end
	end

	local routeWidth = (routeEndPosX - routeStartPosX) + 16
	local routeHeight = (routeEndPosY - routeStartPosY) + 16

	if isElement(gpsRouteImage) then
		destroyElement(gpsRouteImage)
	end

	gpsRouteImage = dxCreateRenderTarget(routeWidth, routeHeight, true)
	gpsRouteImageData = {routeStartPosX - 8, routeStartPosY - 8, routeWidth, routeHeight}

	dxSetRenderTarget(gpsRouteImage)
	dxSetBlendMode("modulate_add")

	if gpsLines then
		_dxDrawImage(gpsLines[1][1] - routeStartPosX + 8 - 4, gpsLines[1][2] - routeStartPosY + 8 - 4, 8, 8, "gps/images/dot.png")
	end

	for i = 2, #gpsLines do
		if gpsLines[i - 1] then
			local startX = gpsLines[i][1] - routeStartPosX + 8
			local startY = gpsLines[i][2] - routeStartPosY + 8
			local endX = gpsLines[i - 1][1] - routeStartPosX + 8
			local endY = gpsLines[i - 1][2] - routeStartPosY + 8

			_dxDrawImage(startX - 4, startY - 4, 8, 8, "gps/images/dot.png")
			dxDrawLine(startX, startY, endX, endY, tocolor(255, 255, 255), 9)
		end
	end

	dxSetBlendMode("blend")
	dxSetRenderTarget()
end

function clearGPSRoute()
	gpsLines = {}

	if isElement(gpsRouteImage) then
		destroyElement(gpsRouteImage)
	end
	gpsRouteImage = false
end

function getHudCursorPos()
	if isCursorShowing() then
		return getCursorPosition()
	end
	return false
end

function getFont(name)
	if createdFonts[name] then
		return createdFonts[name]
	end
	return "default"
end

function initFont(name, path, size)
	if not createdFonts[name] then
		createdFonts[name] = dxCreateFont("files/" .. path, resp(size), false, "antialiased")
	else
		return createdFonts[name]
	end
end

function isCursorWithinArea(cx, cy, x, y, w, h)
	if isCursorShowing() then
		if cx >= x and cx <= x + w and cy >= y and cy <= y + h then
			return true
		end
	end

	return false
end


function getVehicleSpeed(vehicle)
	local velocityX, velocityY, velocityZ = getElementVelocity(vehicle)
	return ((velocityX * velocityX + velocityY * velocityY + velocityZ * velocityZ) ^ 0.5) * 187.5
end

function setVisible ( state )
	minimapIsVisible = not state
end