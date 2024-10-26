local markers = {}
local delay = {}

loadMarkers = function()
	for i,v in ipairs(Config.Corp) do
		if not markers['entrada'] then markers['entrada'] = {} end 
		if not markers['saida'] then markers['saida'] = {} end 
		markers['entrada'][i] = exports['crp_markers']:createMarker(v.icon, Vector3 {v.entrada[1], v.entrada[2], v.entrada[3]})
		markers['saida'][i] = exports['crp_markers']:createMarker('door', Vector3 {v.saida[1], v.saida[2], v.saida[3]})
		setElementInterior(markers['saida'][i], v.interior)
		setElementDimension(markers['saida'][i], v.dimensao)
		if v.blip then 
			local blip = createBlipAttachedTo(markers['entrada'][i], v.blip)
		end
	end
end
loadMarkers()

addEventHandler('onPlayerMarkerHit', root, function(marker, dim)
	if delay[source] then return print('com delay') end
	for i=1,#markers['entrada'] do 
		if marker == markers['entrada'][i] then
			if dim then 
				if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(source)), aclGetGroup(Config.Corp[i].acl)) then
					local x, y, z = getElementPosition(markers['saida'][i])
					setElementPosition(source, x, y, z+0.9)
					setElementInterior(source, Config.Corp[i].interior)
					setElementDimension(source, Config.Corp[i].dimensao)
					delay[source] = setTimer(function(player)
						delay[player] = nil
					end, 2000, 1, source)
				end
			end
		end
	end
	for i=1,#markers['saida'] do 
		if marker == markers['saida'][i] then
			if dim then 
				local x, y, z = getElementPosition(markers['entrada'][i])
				setElementPosition(source, x, y, z+0.9)
				setElementInterior(source, 0)
				setElementDimension(source, 0)
				delay[source] = setTimer(function(player)
					delay[player] = nil
				end, 2000, 1, source)
			end
		end
	end
end)