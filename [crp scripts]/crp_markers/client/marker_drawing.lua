local screenSize = Vector2(guiGetScreenSize())

local MARKER_ANIMATION_SPEED = 0.008

local MARKER_ICON_SIZE = 6
local MARKER_ANIMATION_SIZE = 0.3

local MARKER_TEXT_SIZE = 5
local MARKER_TEXT_ANIMATION_SIZE = 0.1
local MARKER_TEXT_OFFSET = Vector3(0, 0, 3)

local markersToDraw = {}

local screenTextFont
local screenTextBottomOffset = 60

local currentMarker
local markerKey = "g"

local markerTypes = {}

markerTypes.ammunation = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/ammunation.png",
	string = ""
}

markerTypes.anonymous = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/anonymous.png",
	string = ""
}

markerTypes.office = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 1.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/office.png",
	string = ""
}

markerTypes.marker = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 1.5,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/marker.png",
	string = ""
}

markerTypes.astronaut = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/astronaut.png",
	string = ""
}

markerTypes.bank = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/bank.png",
	string = ""
}

markerTypes.bus = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/bus.png",
	string = ""
}

markerTypes.business = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/business.png",
	string = ""
}

markerTypes.carshop = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/carshop.png",
	string = ""
}

markerTypes.clothes = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 1.5,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/clothes.png",
	string = ""
}

markerTypes.club = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/club.png",
	string = ""
}

markerTypes.crips = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/crips.png",
	string = ""
}

markerTypes.cybernet = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/cybernet.png",
	string = ""
}

markerTypes.document = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/document.png",
	string = ""
}

markerTypes.door = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/door.png",
	string = ""
}

markerTypes.food = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 1.0,
	textSize = 1.0,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/food.png",
	string = ""
}

markerTypes.food_market = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/food_market.png",
	string = ""
}

markerTypes.gas_station = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/gas_station.png",
	string = ""
}

markerTypes.get_car = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/get_car.png",
	string = ""
}

markerTypes.get_carpolice = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/get_carpolice.png",
	string = ""
}

markerTypes.get_service = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 1.0,
	textSize = 1.0,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/get_service.png",
	string = ""
}

markerTypes.hairstyle = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 1.5,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/hairstyle.png",
	string = ""
}

markerTypes.house = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/house.png",
	string = ""
}

markerTypes.padrao = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/invisible.png",
	string = ""
}

markerTypes.desmanche = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 4.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/invisible.png",
	string = ""
}

markerTypes.jobs = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/jobs.png",
	string = ""
}

markerTypes.lavanderia = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/lavanderia.png",
	string = ""
}

markerTypes.lowriders = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/lowriders.png",
	string = ""
}

markerTypes.padrao2 = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/marker.png",
	string = ""
}

markerTypes.market = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/market.png",
	string = ""
}

markerTypes.office = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/office.png",
	string = ""
}

markerTypes.police = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/police.png",
	string = ""
}

markerTypes.porte = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/porte.png",
	string = ""
}

markerTypes.prisioneiro = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/prisioneiro.png",
	string = ""
}

markerTypes.repair = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/repair.png",
	string = ""
}

markerTypes.roadside = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/roadside.png",
	string = ""
}

markerTypes.rotation = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/rotation.png",
	string = ""
}

markerTypes.satelite = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/satelite.png",
	string = ""
}

markerTypes.scrap = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/scrap.png",
	string = ""
}

markerTypes.store_boat = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/store_boat.png",
	string = ""
}

markerTypes.store_car = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/store_car.png",
	string = ""
}

markerTypes.taxi = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/taxi.png",
	string = ""
}

markerTypes.truck = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/truck.png",
	string = ""
}

markerTypes.varal = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/varal.png",
	string = ""
}

markerTypes.weights = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 2.0,
	textSize = 1.5,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/weights.png",
	string = ""
}

markerTypes.pmesp = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 1.5,
	textSize = 1,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/pmesp.png",
	string = ""
}

markerTypes.rota = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 1.5,
	textSize = 1,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/rota.png",
	string = ""
}

markerTypes.forca_tatica = {
	color = {255, 255, 255},
	noPaint = true,
	iconSize = 1.5,
	textSize = 1,
	textOffset = Vector3(0, 0, 2),
	icon = "assets/ring.png",
	text = "assets/icons/forca_tatica.png",
	string = ""
}



function getMarkerProperties(type)
	return markerTypes[type]
end

local function dxDrawShadowText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
end

local function drawScreenText(text)
	text = string.format((text), string.upper(markerKey))
	local yOffset = math.sin(getTickCount() * MARKER_ANIMATION_SPEED) * 5
	-- dxDrawText(
	-- 	text, 
	-- 	10, 
	-- 	10 + yOffset, 
	-- 	screenSize.x, 
	-- 	screenSize.y - screenTextBottomOffset + 2 + yOffset, 
	-- 	tocolor(0, 0, 0, 150), 
	-- 	1, 
	-- 	screenTextFont, 
	-- 	"center", 
	-- 	"bottom"
	-- )
	dxDrawShadowText(
		text, 
		0, 
		0 + yOffset, 
		screenSize.x, 
		screenSize.y - screenTextBottomOffset + yOffset, 
		tocolor(255, 255, 255), 
		1, 
		screenTextFont, 
		"center", 
		"bottom"
	)	
end

local function drawMarker(marker)
	local markerType = marker:getData("dpMarkers.type")
	local markerProperties = markerTypes[markerType]
	if not markerProperties then
		return
	end

	local t = getTickCount()

	local color = {
		markerProperties.color[1], 
		markerProperties.color[2], 
		markerProperties.color[3], 
		200 + math.sin(t * MARKER_ANIMATION_SPEED / 3) * 35
	}

	local restrictElement = marker:getData("dpMarkers.restrictElement")
	local canEnter = false
	if restrictElement then
		if restrictElement == "vehicle" and localPlayer.vehicle then
			canEnter = true
		elseif restrictElement == "player" and not localPlayer.vehicle then
			canEnter = true
		end
	else
		canEnter = true
	end
	if (localPlayer:isWithinMarker(marker) or 
		(localPlayer.vehicle and localPlayer.vehicle:isWithinMarker(marker))) and canEnter
	then
		if not markerProperties.noPaint then
			color = {
				232 + math.sin(t * MARKER_ANIMATION_SPEED) * 23, 
				20 + math.sin(t * MARKER_ANIMATION_SPEED) * 20,
				60 + math.sin(t * MARKER_ANIMATION_SPEED) * 30,
				255
			}
		end
		local markerText = marker:getData("dpMarkers.text")
		if not markerText then
			markerText = markerProperties.string
		end
		drawScreenText(markerText)
		if currentMarker ~= marker then
			triggerEvent("dpMarkers.enter", marker)
			currentMarker = marker
		end
	end	

	local mx, my, mz = getElementPosition(marker)
	if markerProperties.icon then
		local markerIconSize = MARKER_ICON_SIZE
		local animationSize = MARKER_ANIMATION_SIZE
		if markerProperties.iconSize then
			markerIconSize = markerProperties.iconSize
			animationSize = markerIconSize / MARKER_ICON_SIZE * MARKER_ANIMATION_SIZE
		end
		local iconSize = markerIconSize - math.sin(t * MARKER_ANIMATION_SPEED) * animationSize		

		local direction = marker:getData("dpMarkers.direction")
		local ox = math.cos(direction) * iconSize / 2
		local oy =  math.sin(direction) * iconSize / 2
		dxDrawMaterialLine3D(
			mx + ox,
			my + oy,
			mz,
			mx - ox,
			my - oy,
			mz,
			markerProperties.icon, 
			iconSize,
			tocolor(255, 255, 255, color[4]),
			mx,
			my,
			mz + 1
		)
	end

	if not markerProperties.text then
		return
	end

	local textSize = false
	if (markerProperties.textSize) then
		textSize = markerProperties.textSize
	else
		textSize = MARKER_TEXT_SIZE
	end

	markerOffset = false
	if (markerProperties.textOffset) then
		markerOffset = markerProperties.textOffset
	else
		markerOffset = MARKER_TEXT_OFFSET
	end

	local textAnimationOffset = math.sin(t * MARKER_ANIMATION_SPEED) * MARKER_TEXT_ANIMATION_SIZE
	dxDrawMaterialLine3D(
		mx, 
		my,
		mz + textSize / 4 + markerOffset.z + textAnimationOffset,
		mx,
		my,
		mz - textSize / 2 + markerOffset.z + textAnimationOffset,
		markerProperties.text,
		textSize,
		tocolor(unpack(color))
	)
end

function addMarkerToDraw(marker)
	if isElementStreamedIn(marker) then
		markersToDraw[marker] = true
	end
end

addEventHandler("onClientRender", root, function ()
	if localPlayer:getData("dpCore.state") then
		return
	end
	for marker in pairs(markersToDraw) do
		drawMarker(marker)
	end
end)

addEventHandler("onClientElementStreamIn", root, function ()
	if source:getData("dpMarkers.type") then
		addMarkerToDraw(source)
	end
end)

addEventHandler("onClientElementStreamOut", root, function ()
	if markersToDraw[source] then
		markersToDraw[source] = nil
	end
end)

addEventHandler("onClientElementDestroy", root, function ()
	if markersToDraw[source] then
		markersToDraw[source] = nil
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	for name, markerProperties in pairs(markerTypes) do
		if markerProperties.icon then
			markerProperties.icon = dxCreateTexture(markerProperties.icon, "dxt5")
		end
		if markerProperties.text then
			markerProperties.text = dxCreateTexture(markerProperties.text, "dxt5")
		end
	end

	screenTextFont = dxCreateFont("assets/font.otf", 22)
end)

addEventHandler("onClientKey", root, function (key, state)
	if key == markerKey and state then
		if (isMTAWindowActive()) then
			return false
		end
		if not isElement(currentMarker) then
			return
		end
		if localPlayer:getData("dpCore.state") or localPlayer:getData("activeUI") then
			return
		end	
		if localPlayer:isWithinMarker(currentMarker) or 
			(localPlayer.vehicle and localPlayer.vehicle:isWithinMarker(currentMarker))
		then
			triggerEvent("dpMarkers.use", currentMarker)
			cancelEvent()
		end		
	end
end)

addEventHandler("onClientMarkerLeave", resourceRoot, function (player)
	if (player ~= localPlayer) then
		return
	end
	if (source == currentMarker) then
		currentMarker = nil
	end
end)