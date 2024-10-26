class 'ClearChatCommand' {
    commandName = "clearchat",
    
    execute = function (player, cmd)
        if not (isPlayerInACL(player, config["ACLAdmin"])) then return end
        local nome = getPlayerName(player)
        for i = 1,300 do
            i = outputChatBox(" ")
        end
        outputChatBox(" ", root, 255, 255, 255, true)
        createDiscordLogs("LIMPOU O CHAT", "O(A) Staff **"..nome.."** limpou o chat.", 'https://discord.com/api/webhooks/1166409635109011516/h_Ildc64kmSsj5O4bxoJzgk3bhp7ByYy35jrjnEaIx24c1Fsk9Qwdbq9Pem8zi5WlMNw', "")

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