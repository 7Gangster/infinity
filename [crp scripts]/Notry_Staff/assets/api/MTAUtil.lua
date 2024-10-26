local _Events = {}
_addEventHandler = addEventHandler
_removeEventHandler = removeEventHandler

function formatNumber(number, sep)
	assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
	assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end

function addEventHandler(eventName, attachedTo, theFunction, propagate, priority)
	local stt = _addEventHandler(eventName, attachedTo, theFunction, propagate, priority)
	if stt then
		table.insert(_Events, {eventName = eventName, attachedTo = attachedTo, theFunction = theFunction})
		return true
	else
		error('HOUVE UM IMPREVISTO AO EXECUTAR A FUNÇÃO, CHEQUE A LINHA ACIMA', 2)
	end
	return false
end

function removeEventHandler(eventName, attachedTo, theFunction)
	local stt = _removeEventHandler(eventName, attachedTo, theFunction)
	if (stt) then
		for i, evento in ipairs(_Events) do
			if (evento.eventName == eventName and evento.attachedTo == attachedTo and evento.theFunction == theFunction) then
				table.remove(_Events, i)
				return true
			end
		end
	else
		error('HOUVE UM IMPREVISTO AO EXECUTAR A FUNÇÃO, CHEQUE A LINHA ACIMA', 2)
	end
	return false
end

function isEventHandlerAdded(eventName, attachedTo, theFunction)
	for i, evento in ipairs(_Events) do
		if (evento.eventName == eventName and evento.attachedTo == attachedTo and evento.theFunction == theFunction) then
			return true
		end
	end
	return false
end

function isPlayerInACL(player, acl)
	if isElement(player) and getElementType(player) == "player" and aclGetGroup(acl or "") and not isGuestAccount(getPlayerAccount(player)) then
		local account = getPlayerAccount(player)
		
		return isObjectInACLGroup( "user.".. getAccountName(account), aclGetGroup(acl) )
	end
	return false
end

function getNearestElement(thePlayer, elementType, distance)
	local lastMinDis = distance-0.0001
	local nearestElement = false
	local px,py,pz = getElementPosition(thePlayer)
	local pInt = getElementInterior(thePlayer)
	local pDim = getElementDimension(thePlayer)
    
	for _,e in pairs(getElementsByType(elementType)) do
		local eInt,eDim = getElementInterior(e),getElementDimension(e)
		if eInt == pInt and eDim == pDim and e ~= thePlayer then
			local ex,ey,ez = getElementPosition(e)
			local dis = getDistanceBetweenPoints3D(px,py,pz,ex,ey,ez)
			if dis < distance then
				if dis < lastMinDis then
					lastMinDis = dis
					nearestElement = e
				end
			end
		end
	end
	return nearestElement
end

function removeHex(s)
    return s:gsub("#%x%x%x%x%x%x", "") or false
end

function getPlayerFromAccountName(name) 
    local acc = getAccount(name)
    if not acc or isGuestAccount(acc) then
        return false
    end
    return getAccountPlayer(acc)
end

function table.size(tab)
    local length = 0
    for _ in pairs(tab) do length = length + 1 end
    return length
end