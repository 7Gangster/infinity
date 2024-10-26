RADIOCONFIG = {
    ['GeralConfig'] = {
        ['FrequencyKey'] = 'Class.Frequency', -- ElementData da frequencia
        ['ActiveKey'] = 'Class.Active', -- ElementData que retorna se a rádio está ativa ou não
        ['keyActive'] = 'x',
        ['MaxFrequency'] = 1000
    };
    messageServer = function (player, message, typeinfo)
        exports['crp_notify']:addBox(player, message, typeinfo)
    end;
    messageClient = function (message, typeinfo)
        exports['crp_notify']:addBox(message, typeinfo)
    end;
};