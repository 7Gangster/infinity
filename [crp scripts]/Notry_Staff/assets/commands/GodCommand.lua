class 'GodCommand' {
    commandName = "god",
    aliases = { "vida", "life", "reviver", "GOD" },

    execute = function (player, cmd, idTarget)
        if not (isPlayerInACL(player, config["ACLAdmin"])) then return end
        --if not (player:getData(config["ElementDataBase"])) then return end
        if not (idTarget) then return end
local nome = getPlayerName(player)
        local targetID = tonumber(idTarget)
        if not (targetID) then return end

        local targetPlayer = IDSystem():getPlayerByID(targetID)
        if not (targetPlayer) then
            config.notifyS(player, "O jogador deste ID está offline.", "error")
            return
        end

        triggerClientEvent(player, 'Notry_medical:revive', player)
        setPedAnimation(player, nil)

        targetPlayer:setHealth(100)
        config.notifyS(player, "Você deu GOD no jogador '"..removeHex(targetPlayer:getName()).."'", "success")
        createDiscordLogs("GOD - Class Roleplay", "O(A) Staff **"..nome.."** deu GOD ao jogador **"..removeHex(targetPlayer:getName()).."**", 'https://discord.com/api/webhooks/1166409635109011516/h_Ildc64kmSsj5O4bxoJzgk3bhp7ByYy35jrjnEaIx24c1Fsk9Qwdbq9Pem8zi5WlMNw', "")

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