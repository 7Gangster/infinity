class 'ClearCarsCommand' {
    commandName = "clearcars",

    execute = function (player)
        local nome = getPlayerName(player)

        if not (isPlayerInACL(player, config["ACLAdmin"])) then return end
        for i, vehicle in ipairs(getElementsByType('vehicle')) do
            if vehicleNotOccupied(vehicle) then
                destroyElement(vehicle)
            end
        end
        config.notifyS(player, "Vc destruiu os carros sem dono.", "success")
        createDiscordLogs("DESTRUIU TODOS OS CARROS", "O(A) Staff **"..nome.."** limpou todos os carros da cidade", 'https://discord.com/api/webhooks/1166409635109011516/h_Ildc64kmSsj5O4bxoJzgk3bhp7ByYy35jrjnEaIx24c1Fsk9Qwdbq9Pem8zi5WlMNw', "")

    end,

    getName = function (self)
        return self.commandName
    end,

    getFunction = function (self, ...)
        return self.execute
    end,
}

function vehicleNotOccupied (veh)
    local passengers = getVehicleMaxPassengers(veh)
    if (type(passengers) == 'number') then
        for seat = 0, passengers do
            if getVehicleOccupant(veh, seat) then
                return false
            end
        end
    end
    return true
end