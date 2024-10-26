local MARKER_COLLISION_RADIUS = 5
local markerTypes = {
	business = {
		radius = 1.3,
	},
	ammunation = {
		radius = 1.3,
	},
	
	anonymous = {
		radius = 1.3,
	},
	
	astronaut = {
		radius = 1.3,
	},
	
	bank = {
		radius = 1.3,
	},

	desmanche = {
		radius = 2.3,
	},
	
	bus = {
		radius = 1.3,
	},
	
	business = {
		radius = 1.3,
	},
	
	carshop = {
		radius = 1.3,
	},
	
	clothes = {
		radius = 1.3,
	},
	
	club = {
		radius = 1.3,
	},
	
	crips = {
		radius = 1.3,
	},
	
	cybernet = {
		radius = 1.3,
	},
	
	document = {
		radius = 1.3,
	},
	
	door = {
		radius = 1.3,
	},
	
	food = {
		radius = 1.0,
	},
	
	food_market = {
		radius = 1.3,
	},
	
	gas_station = {
		radius = 1.3,
	},
	
	get_car = {
		radius = 1.3,
	},
	
	get_carpolice = {
		radius = 4.0,
	},
	
	get_service = {
		radius = 1.3,
	},
	
	hairstyle = {
		radius = 1.3,
	},
	
	house = {
		radius = 1.3,
	},
	
	padrao = {
		radius = 1.3,
	},
	
	jobs = {
		radius = 1.3,
	},
	
	lavanderia = {
		radius = 1.3,
	},
	
	lowriders = {
		radius = 1.3,
	},
	
	padrao2 = {
		radius = 1.3,
	},
	
	market = {
		radius = 1.3,
	},

	marker = {
		radius = 1.0,
	},

	office = {
		radius = 1.0,
	},
	
	office = {
		radius = 1.3,
	},
	
	police = {
		radius = 1.3,
	},
	
	porte = {
		radius = 1.3,
	},
	
	prisioneiro = {
		radius = 1.3,
	},
	
	repair = {
		radius = 1.3,
	},
	
	roadside = {
		radius = 1.3,
	},
	
	rotation = {
		radius = 1.3,
	},
	
	satelite = {
		radius = 1.3,
	},
	
	scrap = {
		radius = 1.3,
	},
	
	store_boat = {
		radius = 1.3,
	},
	
	store_car = {
		radius = 1.3,
	},
	
	taxi = {
		radius = 1.3,
	},
	
	truck = {
		radius = 1.3,
	},
	
	varal = {
		radius = 1.3,
	},
	
	weights = {
		radius = 1.3,
	},

	pmesp = {
		radius = 1.3,
	},

	arrow = {
		radius = 1.3,
	},

	rota = {
		radius = 1.3,
	},

	forca_tatica = {
		radius = 1.3,
	},
}
local markersByResource = {}

function createMarker(markerType, position, direction)
	if type(markerType) ~= "string" or not position then
		return false
	end
	if type(direction) ~= "number" then
		direction = 0
	end
	local radius = MARKER_COLLISION_RADIUS
	if markerTypes[markerType] then
		if markerTypes[markerType].radius then
			radius = markerTypes[markerType].radius
		end
	end
	local marker = Marker(position, "cylinder", radius, 0, 0, 0, 0)
	marker:setData("dpMarkers.type", markerType)
	if isElement(sourceResourceRoot) then
		if not markersByResource[sourceResourceRoot] then
			markersByResource[sourceResourceRoot] = {}
		end
		markersByResource[sourceResourceRoot][marker] = true
	end
	marker:setData("dpMarkers.direction", math.rad(direction))
	return marker
end

addEventHandler("onResourceStop", root, function ()
	if markersByResource[source] then
		for marker in pairs(markersByResource[source]) do
			if isElement(marker) then
				destroyElement(marker)
			end
			markersByResource[source][marker] = nil
		end
	end
	markersByResource[source] = nil
end)