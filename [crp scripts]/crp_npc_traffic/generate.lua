function initTrafficGenerator()
	traffic_density = {peds = 0.001}

	population = {peds = {}}
	element_timers = {}

	players = {}
	for plnum,player in ipairs(getElementsByType("player")) do
		players[player] = true
	end
	addEventHandler("onPlayerJoin",root,addPlayerOnJoin)
	addEventHandler("onPlayerQuit",root,removePlayerOnQuit)

	square_subtable_count = {}

	setTimer(updateTraffic,20000,0)
end

function addPlayerOnJoin()
	players[source] = true
end

function removePlayerOnQuit()
	players[source] = nil
end

function updateTraffic()
	crp_npc_coldata = getResourceFromName("crp_npc_coldata")
	crp_npc = getResourceFromName("crp_npc")

	colcheck = get("crp_npc_traffic.check_collisions")
	colcheck = colcheck == "all" and root or colcheck == "local" and resourceRoot or nil

	updateSquarePopulations()
	generateTraffic()
	removeEmptySquares()
end

function updateSquarePopulations()
	if square_population then
		for dim,square_dim in pairs(square_population) do
			for y,square_row in pairs(square_dim) do
				for x,square in pairs(square_row) do
					square.count = {peds =  0}
					square.list  = {peds = {}}
					square.gen_mode  = "despawn"
				end
			end
		end
	end

	countPopulationInSquares("peds")

	for player,exists in pairs(players) do
		local x,y = getElementPosition(player)
		local dim = getElementDimension(player)
		x,y = math.floor(x/SQUARE_SIZE),math.floor(y/SQUARE_SIZE)

		for sy = y-4,y+4 do for sx = x-4,x+4 do
			local square = getPopulationSquare(sx,sy,dim)
			if not square then
				square = createPopulationSquare(sx,sy,dim,"spawn")
			else
				if x-3 <= sx and sx <= x+3 and y-3 <= sy and sy <= y+3 then
					square.gen_mode = "nospawn"
				else
					square.gen_mode = "spawn"
				end
			end
		end end
	end

	if colcheck then call(crp_npc_coldata,"generateColData",colcheck) end
end

function removeEmptySquares()
	if square_population then
		for dim,square_dim in pairs(square_population) do
			for y,square_row in pairs(square_dim) do
				for x,square in pairs(square_row) do
					if
						square.gen_mode == "despawn" and
						square.count.peds == 0
					then
						destroyPopulationSquare(x,y,dim)
					end
				end
			end
		end
	end
end

function countPopulationInSquares(trtype)
	for element,exists in pairs(population[trtype]) do
		if getElementType(element) ~= "ped" or not isPedInVehicle(element) then
			local x,y = getElementPosition(element)
			local dim = getElementDimension(element)
			x,y = math.floor(x/SQUARE_SIZE),math.floor(y/SQUARE_SIZE)

			for sy = y-2,y+2 do for sx = x-2,x+2 do
				local square = getPopulationSquare(sx,sy,dim)
				if sx == x and sy == y then
					if not square then square = createPopulationSquare(sx,sy,dim,"despawn") end
					square.list[trtype][element] = true
				end
				if square then square.count[trtype] = square.count[trtype]+1 end
			end end
		end
	end
end

function createPopulationSquare(x,y,dim,genmode)
	if not square_population then
		square_population = {}
		square_subtable_count[square_population] = 0
	end
	local square_dim = square_population[dim]
	if not square_dim then
		square_dim = {}
		square_subtable_count[square_dim] = 0
		square_population[dim] = square_dim
		square_subtable_count[square_population] = square_subtable_count[square_population]+1
	end
	local square_row = square_dim[y]
	if not square_row then
		square_row = {}
		square_subtable_count[square_row] = 0
		square_dim[y] = square_row
		square_subtable_count[square_dim] = square_subtable_count[square_dim]+1
	end
	local square = square_row[x]
	if not square then
		square = {}
		square_subtable_count[square] = 0
		square_row[x] = square
		square_subtable_count[square_row] = square_subtable_count[square_row]+1
	end
	square.count = {peds =  0}
	square.list  = {peds = {}}
	square.gen_mode = genmode
	return square
end

function destroyPopulationSquare(x,y,dim)
	if not square_population then return end
	local square_dim = square_population[dim]
	if not square_dim then return end
	local square_row = square_dim[y]
	if not square_row then return end
	local square = square_row[x]
	if not square then return end

	square_subtable_count[square] = nil
	square_row[x] = nil
	square_subtable_count[square_row] = square_subtable_count[square_row]-1
	if square_subtable_count[square_row] ~= 0 then return end
	square_subtable_count[square_row] = nil
	square_dim[y] = nil
	square_subtable_count[square_dim] = square_subtable_count[square_dim]-1
	if square_subtable_count[square_dim] ~= 0 then return end
	square_subtable_count[square_dim] = nil
	square_population[dim] = nil
	square_subtable_count[square_population] = square_subtable_count[square_population]-1
	if square_subtable_count[square_population] ~= 0 then return end
	square_subtable_count[square_population] = nil
	square_population = nil
end

function getPopulationSquare(x,y,dim)
	if not square_population then return end
	local square_dim = square_population[dim]
	if not square_dim then return end
	local square_row = square_dim[y]
	if not square_row then return end
	return square_row[x]
end

function generateTraffic()
	if not square_population then return end
	for dim,square_dim in pairs(square_population) do
		for y,square_row in pairs(square_dim) do
			for x,square in pairs(square_row) do
				local genmode = square.gen_mode
				if genmode == "spawn" then
					spawnTrafficInSquare(x,y,dim,"peds")
				elseif genmode == "despawn" then
					despawnTrafficInSquare(x,y,dim,"peds")
				end
			end
		end
	end
end

skins = {0,11,12,13,14,15,16,17,19,20,21,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,43,44,46,47,48,49,50,53,54,55,56,57,58,59,60,61,66,67,68,69,70,71,72,73,76,77,78,79,82,83,84,88,89,91,93,94,95,96,98,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,141,142,143,147,148,150,151,153,157,158,159,160,161,162,170,173,174,175,181,182,183,184,185,186,187,188,196,197,198,199,200,201,202,206,210,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,231,232,233,234,235,236,239,240,241,242,247,248,250,253,254,255,258,259,260,261,262,263}
skincount = #skins

count_needed = 0

function spawnTrafficInSquare(x,y,dim,trtype)
	local square_tm_id = square_id[y] and square_id[y][x]
	if not square_tm_id then return end
	local square = square_population and square_population[dim] and square_population[dim][y] and square_population[dim][y][x]
	if not square then return end

	local conns = square_conns[square_tm_id][trtype]
	local cpos1 = square_cpos1[square_tm_id][trtype]
	local cpos2 = square_cpos2[square_tm_id][trtype]
	local cdens = square_cdens[square_tm_id][trtype]
	local ttden = square_ttden[square_tm_id][trtype]
	count_needed = count_needed+math.max(ttden*traffic_density[trtype]-square.count[trtype]/25,0)

	while count_needed >= 1 do
		local sqpos = ttden*math.random()
		local connpos
		local connnum = 1
		while true do
			connpos = cdens[connnum]
			if sqpos > connpos then
				sqpos = sqpos-connpos
			else
				connpos = sqpos/connpos
				break
			end
			connnum = connnum+1
		end

		local connid = conns[connnum]
		connpos = cpos1[connnum]*(1-connpos)+cpos2[connnum]*connpos
		local n1,n2,nb = conn_n1[connid],conn_n2[connid],conn_nb[connid]
		local ll,rl = conn_lanes.left[connid],conn_lanes.right[connid]
		local lanecount = ll+rl
		if lanecount == 0 and math.random(2) > 1 or lanecount ~= 0 and math.random(lanecount) > rl then
			n1,n2,ll,rl = n2,n1,rl,ll
			connpos = (nb and math.pi*0.5 or 1)-connpos
		end
		lane = rl == 0 and 0 or math.random(rl)
		local x,y,z
		local x1,y1,z1 = getNodeConnLanePos(n1,connid,lane,false)
		local x2,y2,z2 = getNodeConnLanePos(n2,connid,lane,true)
		local dx,dy,dz = x2-x1,y2-y1,z2-z1
		local rx = math.deg(math.atan2(dz,math.sqrt(dx*dx+dy*dy)))
		local rz
		if nb then
			local bx,by,bz = node_x[nb],node_y[nb],(z1+z2)*0.5
			local x1,y1,z1 = x1-bx,y1-by,z1-bz
			local x2,y2,z2 = x2-bx,y2-by,z2-bz
			local possin,poscos = math.sin(connpos),math.cos(connpos)
			x = bx+possin*x1+poscos*x2
			y = by+possin*y1+poscos*y2
			z = bz+possin*z1+poscos*z2
			local tx = -poscos
			local ty = possin
			tx,ty = x1*tx+x2*ty,y1*tx+y2*ty
			rz = -math.deg(math.atan2(tx,ty))
		else
			x = x1*(1-connpos)+x2*connpos
			y = y1*(1-connpos)+y2*connpos
			z = z1*(1-connpos)+z2*connpos
			rz = -math.deg(math.atan2(dx,dy))
		end

		local speed = conn_maxspeed[connid]/180
		local vmult = speed/math.sqrt(dx*dx+dy*dy+dz*dz)
		local vx,vy,vz = dx*vmult,dy*vmult,dz*vmult

		local model = trtype == "peds" and skins[math.random(skincount)]
		local colx,coly,colz = x,y,z+z_offset[model]

		local create = true
		if colcheck then
			local box = call(crp_npc_coldata,"createModelIntersectionBox",model,colx,coly,colz,rz)
			create = not call(crp_npc_coldata,"doesModelBoxIntersect",box,dim)
		end

		if create and trtype == "peds" then
			local ped = createPed(model,x,y,z+1,rz)
			setElementData(ped, "ZN-PedCity", true)
			local random = math.random(1, 10)
			if random == 5 then 
				setElementData(ped, "ped:state", true)
			end
			setElementDimension(ped, 0)
			element_timers[ped] = {}
			addEventHandler("onElementDestroy",ped,removePedFromListOnDestroy,false)
			addEventHandler("onPedWasted",ped,removeDeadPed,false)
			population.peds[ped] = true

			if colcheck then call(crp_npc_coldata,"updateElementColData",ped) end

			call(crp_npc,"enableHLCForNPC",ped,"walk",0.99,40/180)
			ped_lane[ped] = lane
			initPedRouteData(ped)
			addNodeToPedRoute(ped,n1)
			addNodeToPedRoute(ped,n2,nb)
			for nodenum = 1,4 do addRandomNodeToPedRoute(ped) end

		end

		square.count[trtype] = square.count[trtype]+1

		count_needed = count_needed-1
	end
end

function removePedFromListOnDestroy()
	for timer,exists in pairs(element_timers[source]) do
		killTimer(timer)
	end
	element_timers[source] = nil
	population.peds[source] = nil
end

function removeDeadPed()
	element_timers[source][setTimer(destroyElement,20000,1,source)] = true
end

function removeCarFromListOnDestroy()
	for timer,exists in pairs(element_timers[source]) do
		killTimer(timer)
	end
	element_timers[source] = nil
end

function removeDestroyedCar()
	element_timers[source][setTimer(destroyElement,60000,1,source)] = true
end

function despawnTrafficInSquare(x,y,dim,trtype)
	local square = square_population and square_population[dim] and square_population[dim][y] and square_population[dim][y][x]
	if not square then return end

	if trtype == "peds" then
		for element,exists in pairs(square.list[trtype]) do
			destroyElement(element)
		end
	else
		for element,exists in pairs(square.list[trtype]) do
			local occupants = getVehicleOccupants(element)
			local destroy = true
			for seat,ped in pairs(occupants) do
				if not population.peds[ped] then destroy = false end
			end
			if destroy then
				destroyElement(element)
				for seat,ped in pairs(occupants) do
					destroyElement(ped)
				end
			end
		end
	end
end
