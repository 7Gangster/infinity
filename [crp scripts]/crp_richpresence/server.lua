local application = {
    id = "1167119078612279378", -- Application ID
    state = "Jogadores Online",
    max_slots = tonumber(getServerConfigSetting("maxplayers")),
    logo = "newlogo",
    logo_name = "Class Roleplay - CLOSED BETA",
    details = "Um universo de possibilidades.",

    buttons = {
        [1] = {
            use = true,
            name = "Discord",
            link = "https://discord.gg/classrp"
        },
        [2] = {
            use = true,
            name = "Discord",
            link = "https://discord.gg/classrp"
        },

    }
};

addEventHandler("onResourceStart", resourceRoot,
    function()
        setTimer(function()
            for index, player in ipairs(getElementsByType("player")) do
                triggerClientEvent(player, "addPlayerRichPresence", player, application);
            end
        end, 5000, 1)
    end
)

addEventHandler("onPlayerJoin", root,
    function()
        setTimer(function(player)
            --if (theResource == resource) then
                triggerClientEvent(player, "addPlayerRichPresence", player, application);
            --end
        end, 1000, 1, source)
    end
);

addEventHandler("onPlayerLogin", root,
    function()
        setTimer(function(player)
            --if (theResource == resource) then
                triggerClientEvent(player, "addPlayerRichPresence", player, application);
            --end
        end, 1000, 1, source)
    end
);