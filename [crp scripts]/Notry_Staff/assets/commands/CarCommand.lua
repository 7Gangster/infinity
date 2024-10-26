local vehicles = { }

class 'CarCommand' {
    commandName = "car",
    aliases = { "cv" },
    
    execute = function (player, cmd, idCar)
        if not (isPlayerInACL(player, config["MasterAdmin"])) then return end
        -- if not (player:getData(config["ElementDataBase"])) then return end
        if not (idCar) then return end

        local carID = tonumber(idCar)
        if not (carID) then return end

        if not (carID >= 400 and carID <= 611) then
            config.notifyS(player, "ID de carro invalido.", "error")
            return
        end

        local position = player:getPosition()
        local x, y, z = position["x"], position["y"], position["z"]
        local nome = getPlayerName(player)
        if (isElement(vehicles[player])) then destroyElement(vehicles[player]) end
		vehicles[player] = Vehicle(carID, x + 1,y , z)
        config.notifyS(player, "Você spawnou o veiculo '"..vehicles[player]:getName().."'.", "success")
        createDiscordLogs("CRIOU UM VEICULO", "O(A) Staff **"..nome.."** spawnou o veiculo **"..vehicles[player]:getName().."**", 'https://discord.com/api/webhooks/1166409635109011516/h_Ildc64kmSsj5O4bxoJzgk3bhp7ByYy35jrjnEaIx24c1Fsk9Qwdbq9Pem8zi5WlMNw', "")

    end,

    getName = function (self)
        return self.commandName
    end,

    getAliases = function (self)
        return self.aliases
    end,

    getFunction = function (self, ...)
        return self.execute
    end,
}