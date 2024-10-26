UPDATE_COUNT = 16
UPDATE_INTERVAL_MS = 200

function initNPCControl()
	addEventHandler("onClientPreRender",root,cycleNPCs)
end

function cycleNPCs()
	local streamed_npcs = {}
	for pednum,ped in ipairs(getElementsByType("ped",root,true)) do
		if getElementData(ped,"crp_npc") then
			streamed_npcs[ped] = true
		end
	end
	for npc,streamedin in pairs(streamed_npcs) do
		if getElementHealth(getPedOccupiedVehicle(npc) or npc) >= 1 then
			while true do
				local thistask = getElementData(npc,"crp_npc:thistask")
				if thistask then
					local task = getElementData(npc,"crp_npc:task."..thistask)
					if task then
						if performTask[task[1]](npc,task) then
							setNPCTaskToNext(npc)
						else
							break
						end
					else
						stopAllNPCActions(npc)
						break
					end
				else
					stopAllNPCActions(npc)
					break
				end
			end
		else
			stopAllNPCActions(npc)
		end
	end
end

function setNPCTaskToNext(npc)
	setElementData(
		npc,"crp_npc:thistask",
		getElementData(npc,"crp_npc:thistask")+1,
		true
	)
end

