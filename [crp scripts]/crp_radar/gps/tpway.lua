function tpWayStaff(player, commandName)
    local accountname = getAccountName (getPlayerAccount(player))
    if isObjectInACLGroup("user." .. accountname, aclGetGroup("Staff")) then
        triggerClientEvent(player, "class:tpWay", player, player)
    end
end
addCommandHandler("tpway", tpWayStaff)