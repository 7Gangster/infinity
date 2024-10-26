class 'WallCommand' {
    commandName = "wall",

    execute = function (player)
        if not (isPlayerInACL(player, config["ACLAdmin"])) then return end
        --if not (player:getData(config["ElementDataBase"])) then return end
        local nome = getPlayerName(player)
        player:setData("onPlayerStaff", not player:getData("onPlayerStaff"))
        config.notifyS(player, "Você "..(player:getData("onPlayerStaff") and "ativou" or "desativou").." o WallHack", "success")
        createDiscordLogs("WALLHACK - Class Roleplay", "O(A) Staff **"..nome.."** "..(player:getData("onPlayerStaff") and "ativou" or "desativou").." o WallHack", 'https://discord.com/api/webhooks/1166409635109011516/h_Ildc64kmSsj5O4bxoJzgk3bhp7ByYy35jrjnEaIx24c1Fsk9Qwdbq9Pem8zi5WlMNw', "")

    end,

    getName = function (self)
        return self.commandName
    end,

    getFunction = function (self, ...)
        return self.execute
    end,
}