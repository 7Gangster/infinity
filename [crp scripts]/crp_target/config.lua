Config = {

    keyOlho = 'lalt', -- Key para aparecer o olho
    elementsTarget = {'vehicle', 'player', 'object', 'ped'},
    objectsID = {1345, 1808, 1997, 2332, 1227, 1331, 1332, 1333, 1334, 1335, 1336, 1337, 1439, 1372, 1415, 1326, 1365, 910, 1359, 1344, 2942, 1514},
    Viaturas = {596}, -- bote o id dos veiculos que sao viaturars

    Identidade = {
        NomeCidade = 'CLASS RESOURCES',
        CorTemaRGB = {66, 212, 126},
        CorTemaHTML = '#42d47e',
    },

    ACL = {
        Policial = 'Policial',
        Medic = 'SAMU',
        Mecanic = 'Mecanico',
    },

    Infobox = {

        Server = function(player, msg, type)
            outputChatBox(msg, player, 255, 255, 255, true)
        end,

        Client = function(msg, type)
            outputChatBox(msg, 255, 255, 255, true)
        end

    },

    distance = { --- Distancia para interação 
        ['player'] = 1.5,
        ['ped'] = 1.5,
        ['object'] = 2,
        ['vehicle'] = 5,
    }, 

    Lixeira = { -- Items que a lixeira vai dar
        items = {
            {'plastico', 'Plastico'}, 
            {'plastico', 'Plastico'}, 
            {'plastico', 'Plastico'}, 
            {'plastico', 'Plastico'}, 
            {'plastico', 'Plastico'}, 
            {'plastico', 'Plastico'}, 
            {'plastico', 'Plastico'}, 
            {'plastico', 'Plastico'}, 
            {'plastico', 'Plastico'}, 
            {'plastico', 'Plastico'}, 
            {'plastico', 'Plastico'}, 
            {'plastico', 'Plastico'}, 
            {'plastico', 'Plastico'}, 
            {'cobre', 'Cobre'}, 
            {'cobre', 'Cobre'}, 
            {'cobre', 'Cobre'}, 
            {'cobre', 'Cobre'}, 
            {'cobre', 'Cobre'}, 
            {'cobre', 'Cobre'}, 
            {'cobre', 'Cobre'}, 
            {'aluminio', 'Aluminio'}, 
            {'aluminio', 'Aluminio'}, 
            {'aluminio', 'Aluminio'}, 
            {'aluminio', 'Aluminio'}, 
            {'aluminio', 'Aluminio'}, 
            {'aluminio', 'Aluminio'}, 
            {'aluminio', 'Aluminio'}, 
            {false},
            {false},
            {false},
            {false},
            {false},
            {false},
            {false},
            {false},
            {false},
            {false},
            {false},
            {false},
            {false},
            {false},
            {false},
            {false},
            {false},
            {false},
            {false},
            {false},
        },
    },

}