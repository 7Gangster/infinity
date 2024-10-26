class 'StaffCommand' {
    commandName = "nc",
    aliases = { "NC", "noclip", "NOCLIP"},

    execute = function (player)
        if not (isPlayerInACL(player, config["ACLAdmin"])) then return end
        if (player:getOccupiedVehicle()) then return end

        takeAllWeapons(player)
        player:setData(config["ElementDataBase"], not player:getData(config["ElementDataBase"]))
        player:triggerEvent("Notry:flyToggle", player)
        local nome = getPlayerName(player)

        if not (player:getData(config["ElementDataBase"])) then
            player:setAlpha(255)
            exports[config.pAttach]:invisibleAll(player, false)
            config.notifyS(player, "Você desativou o Noclip.", "success")
            createDiscordLogs("STAFF - Class Roleplay", "O(A) Staff **"..nome.."** desativou o Noclip", 'https://discord.com/api/webhooks/1166409635109011516/h_Ildc64kmSsj5O4bxoJzgk3bhp7ByYy35jrjnEaIx24c1Fsk9Qwdbq9Pem8zi5WlMNw', "")
            return
        end
        
        player:setAlpha(0)
        player:setHealth(100)
        exports[config.pAttach]:invisibleAll(player, true)
        config.notifyS(player, "Você ativou o Noclip.", "success")
        createDiscordLogs("STAFF - Class Roleplay", "O(A) Staff **"..nome.."** ativou o Noclip", 'https://discord.com/api/webhooks/1166409635109011516/h_Ildc64kmSsj5O4bxoJzgk3bhp7ByYy35jrjnEaIx24c1Fsk9Qwdbq9Pem8zi5WlMNw', "")

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