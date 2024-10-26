function getPlayerFromAccountName(name) 
    local acc = getAccount(name)
    if (not acc) or (isGuestAccount(acc)) then
        return false
    end
    return getAccountPlayer(acc)
end