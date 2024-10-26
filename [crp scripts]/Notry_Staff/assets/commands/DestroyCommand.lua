class 'DestroyCommand' {
    commandName = "dv",
    aliases = { "destroycar", "DV", "destruir", "Destruir" },
    
    execute = function (player, cmd, idCar)
        if not (isPlayerInACL(player, config["ACLAdmin"])) then return end
        local nome = getPlayerName(player)
        local nearestVehicle = getNearestElement(player, "vehicle", 3)
        if not (nearestVehicle) then
            config.notifyS(player, "Nenhum veiculo próximo.", "error")
            return
        end

        config.notifyS(player, "Você removeu o veiculo '"..nearestVehicle:getName().."'.", "success")
        createDiscordLogs("DESTRUIU", "O(A) Staff **"..nome.."** removeu o veiculo"..nearestVehicle:getName().."", 'https://discord.com/api/webhooks/1166409635109011516/h_Ildc64kmSsj5O4bxoJzgk3bhp7ByYy35jrjnEaIx24c1Fsk9Qwdbq9Pem8zi5WlMNw', "")

        nearestVehicle:destroy()
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