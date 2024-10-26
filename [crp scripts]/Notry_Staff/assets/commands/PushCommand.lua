class 'PushCommand' {
    commandName = "puxar",

    execute = function (player, cmd, idTarget)
        if not (isPlayerInACL(player, config["ACLAdmin"])) then return end
        --if not (player:getData(config["ElementDataBase"])) then return end
        if not (idTarget) then return end

        local targetID = tonumber(idTarget)
        if not (targetID) then return end

        local targetPlayer = IDSystem():getPlayerByID(targetID)
        if not (targetPlayer) then
            config.notifyS(player, "O jogador deste ID está offline.", "error")
            return
        end

        if (targetPlayer == player) then
            config.notifyS(player, "Você não pode se puxar.", "warning")
            return
        end

        local position = player:getPosition()
        local x, y, z = position["x"], position["y"], position["z"]
		local playerInterior = player:getInterior()
		local playerDimension = player:getDimension()
        local nome = getPlayerName(player)

        targetPlayer:setPosition(x, y, z+2)
        targetPlayer:setInterior(playerInterior)
        targetPlayer:setDimension(playerDimension)
        targetPlayer:setCameraInterior(playerInterior)

        config.notifyS(player, "Você se teleportou até o jogador '"..removeHex(targetPlayer:getName()).."'", "success")
        createDiscordLogs("PUXOU - Class Roleplay", "O(A) Staff **"..nome.."** puxou o jogador **"..removeHex(targetPlayer:getName()).."**", 'https://discord.com/api/webhooks/1166409635109011516/h_Ildc64kmSsj5O4bxoJzgk3bhp7ByYy35jrjnEaIx24c1Fsk9Qwdbq9Pem8zi5WlMNw', "")

    end,

    getName = function (self)
        return self.commandName
    end,

    getFunction = function (self, ...)
        return self.execute
    end,
}