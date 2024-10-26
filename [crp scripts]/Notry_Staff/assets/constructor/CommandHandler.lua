local commandsManager = { }

class 'CommandHandler' {
    addCommand = function (self, commandName, commandFunction)
        commandsManager[commandName] = { }
        commandsManager[commandName]["Function"] = commandFunction
        commandsManager[commandName]["CommandHandler"] = addCommandHandler(commandName, commandFunction)
        return true
    end,

    getCommands = function (self)
        return commandsManager
    end,
}