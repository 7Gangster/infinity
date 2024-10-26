function enableHLCForNPC(npc,walkspeed,accuracy,drivespeed)
	if not isElement(npc) or getElementType(npc) ~= "ped" then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	if all_npcs[npc] then
		outputDebugString("HLC already enabled",2)
		return false
	end

	if walkspeed and not NPC_SPEED_ONFOOT[walkspeed] then
		outputDebugString("Invalid walkspeed argument",2)
		return false
	end
	if accuracy then
		accuracy = tonumber(accuracy)
		if not accuracy or accuracy < 0 or accuracy > 1 then
			outputDebugString("Invalid accuracy argument",2)
			return false
		end
	end
	if drivespeed then
		drivespeed = tonumber(drivespeed)
		if not drivespeed or drivespeed < 0 then
			outputDebugString("Invalid drivespeed argument",2)
			return false
		end
	end

	addEventHandler("onElementDataChange",npc,cleanUpDoneTasks)
	addEventHandler("onElementDestroy",npc,destroyNPCInformationOnDestroy)
	all_npcs[npc] = true
	setElementData(npc,"crp_npc",true)
	addNPCToUnsyncedList(npc)
	
	setNPCWalkSpeed(npc,walkspeed or "run")
	setNPCWeaponAccuracy(npc,accuracy or 1)
	setNPCDriveSpeed(npc,drivespeed or 40/180)

	return true
end

function disableHLCForNPC(npc)
	if not isElement(npc) or getElementType(npc) ~= "ped" then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	if not all_npcs[npc] then
		outputDebugString("HLC not enabled",2)
		return false
	end

	clearNPCTasks(npc)

	removeEventHandler("onElementDataChange",npc,cleanUpDoneTasks)
	removeEventHandler("onElementDestroy",npc,destroyNPCInformationOnDestroy)
	destroyNPCInformation(npc)
	removeElementData(npc,"crp_npc")
	
	removeElementData(npc,"crp_npc:walk_speed")
	removeElementData(npc,"crp_npc:accuracy")
	removeElementData(npc,"crp_npc:drive_speed")

	return true
end

function setNPCWalkSpeed(npc,speed)
	if not npc or not all_npcs[npc] then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	if speed ~= "walk" and speed ~= "run" and speed ~= "sprint" and speed ~= "sprintfast" then
		outputDebugString("Invalid speed argument",2)
		return false
	end
	setElementData(npc,"crp_npc:walk_speed",speed)
	return true
end

function setNPCWeaponAccuracy(npc,accuracy)
	if not npc or not all_npcs[npc] then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	accuracy = tonumber(accuracy)
	if not accuracy or accuracy < 0 or accuracy > 1 then
		outputDebugString("Invalid accuracy argument",2)
		return false
	end
	setElementData(npc,"crp_npc:accuracy",accuracy)
	return true
end

function setNPCDriveSpeed(npc,speed)
	if not npc or not all_npcs[npc] then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	speed = tonumber(speed)
	if not speed or speed < 0 then
		outputDebugString("Invalid speed argument",2)
		return false
	end
	setElementData(npc,"crp_npc:drive_speed",speed)
	return true
end

------------------------------------------------

function addNPCTask(npc,task)
	if not npc or not all_npcs[npc] then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	if not isTaskValid(task) then
		outputDebugString("Invalid task argument",2)
		return false
	end
	local lasttask = getElementData(npc,"crp_npc:lasttask")
	if not lasttask then
		lasttask = 1
		setElementData(npc,"crp_npc:thistask",1)
	else
		lasttask = lasttask+1
	end
	setElementData(npc,"crp_npc:task."..lasttask,task)
	setElementData(npc,"crp_npc:lasttask",lasttask)
	return true
end

function clearNPCTasks(npc)
	if not npc or not all_npcs[npc] then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	local thistask = getElementData(npc,"crp_npc:thistask")
	if not thistask then return end
	local lasttask = getElementData(npc,"crp_npc:lasttask")
	for task = thistask,lasttask do
		removeElementData(npc,"crp_npc:task."..task)
	end
	removeElementData(npc,"crp_npc:thistask")
	removeElementData(npc,"crp_npc:lasttask")
	return true
end

function setNPCTask(npc,task)
	if not npc or not all_npcs[npc] then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	if not isTaskValid(task) then
		outputDebugString("Invalid task argument",2)
		return false
	end
	clearNPCTasks(npc)
	setElementData(npc,"crp_npc:task.1",task)
	setElementData(npc,"crp_npc:thistask",1)
	setElementData(npc,"crp_npc:lasttask",1)
	return true
end

function isTaskValid(task)
	local taskFunc = taskValid[task[1]]
	return taskFunc and taskFunc(task) or false
end

