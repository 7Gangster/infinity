function startRes(res)
    if (res ~= getThisResource()) then return end

    setTimer(function()
        CommandManager():loadCommands()
    end, 1000, 1)
end
addEventHandler("onResourceStart", getRootElement(), startRes)

function createDiscordLogs(title, description, link, image)
    local data = {
        embeds = {
            {
                ["color"] = 2829617,
                ["title"] = title,
                
                ["description"] = description,
                
                ['thumbnail'] = {
                    ['url'] = "",
                },

                ['image'] = {
                    ['url'] = image
                },

                ["footer"] = {
                    ["text"] = "Class Roleplay",
                    ['icon_url'] = ""
                },
            }
        },
    }

    data = toJSON(data);
    data = data:sub(2, -2);
    fetchRemote(link, {["queueName"] = "logs", ["connectionAttempts"] = 5, ["connectTimeout"] = 5000, ["headers"] = {["Content-Type"] = "application/json"}, ['postData'] = data}, function() end);
end

