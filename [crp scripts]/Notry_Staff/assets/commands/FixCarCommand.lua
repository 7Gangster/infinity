class 'FixCarCommand' {
	commandName = "fix",

    execute = function (player)
        if not (isPlayerInACL(player, config["ACLAdmin"])) then return end
        --if not (player:getData(config["ElementDataBase"])) then return end
        
        local nearestVehicle = getNearestElement(player, "vehicle", 3)
        local nome = getPlayerName(player)
        if not (nearestVehicle) then
            config.notifyS(player, "Nenhum veiculo próximo.", "error")
            return
        end

        if (nearestVehicle:getHealth() > 1000) then
            config.notifyS(player, "Este veiculo não está quebrado.", "warning")
            return
        end

        nearestVehicle:fix()
        config.notifyS(player, "Você deu FIX no veiculo '"..nearestVehicle:getName().."'.", "success")
        createDiscordLogs("REPAROU", "O(A) Staff **"..nome.."** deu Fix no veiculo **"..nearestVehicle:getName().."**", 'https://discord.com/api/webhooks/1166409635109011516/h_Ildc64kmSsj5O4bxoJzgk3bhp7ByYy35jrjnEaIx24c1Fsk9Qwdbq9Pem8zi5WlMNw', "")

    end,

	getName = function (self)
        return self.commandName
    end,

    getFunction = function (self, ...)
        return self.execute
    end,
}