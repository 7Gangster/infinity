Config = {

    TempoMorrer = 10, -- em minutos
    TempoTratamento = 5, -- em segundos (1 segundo por vida)
    ValorTratamento = 500,

    MarkerTratamento = {
        {1224.5181884766,-1765.4636230469,13.609375-0.9, 'LS'}, -- X, Y, Z, HOSPITAL
    },

    Macas = {
        ['LS'] = {
            {
                position = {1255.9449462891,-1737.3621826172,14.337911605835}, 
                rotation = {0, 0, 90},
                camera = {1255.9455566406, -1737.45703125, 16.020299911499, 1255.9451904297, -1737.3698730469, 15.024105072021, 0, 70}
            },            
            {
                position = {1259.0144042969,-1737.2315673828,14.337911605835}, 
                rotation = {0, 0, 90},
                camera = {1259.0145263672, -1737.3286132812, 16.036699295044, 1259.0147705078, -1737.2407226562, 15.040564537048, 0, 70},
            },
            {
                position = {1262.5245361328,-1737.3503417969,14.337911605835}, 
                rotation = {0, 0, 90},
                camera = {1262.5229492188, -1737.4464111328, 16.036800384521, 1262.5246582031, -1737.3592529297, 15.040605545044, 0, 70},
            },
            {
                position = {1262.6821289062,-1745.3464355469,14.337911605835}, 
                rotation = {0, 0, 270},
                camera = {1262.6811523438, -1745.2509765625, 16.032199859619, 1262.6823730469, -1745.3381347656, 15.036005020142, 0, 70},
            },
                        {
                position = {1256.1068115234,-1745.2928466797,14.337911605835}, 
                rotation = {0, 0, 270},
                camera = {1256.109375, -1745.1966552734, 16.036800384521, 1256.1072998047, -1745.2838134766, 15.040605545044, 0, 70},
            },
        },
    },
}

getMedics = function ()
    local count = 0
    for i,v in ipairs(getElementsByType('player')) do 
        if getElementData(v, 'paramedic >> duty') then 
            count = count + 1
        end
    end
    return count
end


messageBox = function(player, text, type)
    exports['crp_notify']:addBox(player, text, type)
end