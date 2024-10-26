class 'CommandManager' {
    loadCommands = function (self)
        local Meta = XML.load(":"..getThisResource():getName().."/meta.xml")
        for _, nod in ipairs(Meta:getChildren()) do
            local nodeName = nod:getName()
            local srcAttribute = nod:getAttribute("src")

            if (srcAttribute and srcAttribute:find("assets/commands")) then
                local commandObject = srcAttribute:gsub("assets/commands/", ""):gsub(".lua", "")
                if (_G[commandObject] == nil or _G[commandObject] == false) then return end

                CommandHandler():addCommand(_G[commandObject]:getName(), _G[commandObject]:getFunction())
                if (_G[commandObject].aliases ~= nil) then
                    for _, aliase in pairs(_G[commandObject]:getAliases()) do
                        CommandHandler():addCommand(aliase, _G[commandObject]:getFunction())
                    end
                end
            end
        end
    end
}