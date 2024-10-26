config = {

    markers = {
        -- Loja de Roupas CJ
        { 2244.416, -1665.24, 15.477 -1, 'Roupas', camera = {2244.8959960938, -1662.7674560547, 16.390600204468, 2244.6831054688, -1663.7375488281, 16.27360534668, 0, 70}},
        { 2070.884, -1793.996, 13.553 -1, 'Barbeiro', camera = {2072.2067871094, -1793.8129882812, 14.380599975586, 2071.2302246094, -1793.9481201172, 14.212768554688, 0, 70}, blip = 50},
    },
    
    
    slots = {

        ['Roupas'] = {
            [7] = {
                {slotName = 'Chapéus', slotType = 'bone', valueMaxCategoria = '2', item = 'bone'},
                {slotName = 'Camisas', slotType = 'camisa', valueMaxCategoria = '9', item = 'camisa'},
                {slotName = 'Calcas', slotType = 'calca', valueMaxCategoria = '7', item = 'calca'},
                {slotName = 'Tenis', slotType = 'tenis', valueMaxCategoria = '8', item = 'tenis'},
                {slotName = 'Oculos', slotType = 'oculos', valueMaxCategoria = '2', item = 'oculos'},
                {slotName = 'Correntes', slotType = 'acessorios', valueMaxCategoria = '4', item = 'acessorios'},
                {slotName = 'Relógios', slotType = 'relogio', valueMaxCategoria = '2', item = 'relogio'},
            },
            [9] = {
                {slotName = 'Camisas', slotType = 'camisa', valueMaxCategoria = '8', item = 'camisaf'},
                {slotName = 'Calças', slotType = 'calca', valueMaxCategoria = '8', item = 'calcaf'},
                {slotName = 'Sapatos', slotType = 'tenis', valueMaxCategoria = '10', item = 'tenisf'},
                {slotName = 'Oculos', slotType = 'oculos', valueMaxCategoria = '15', item = 'oculos'},
            },
        },
        ['Barbeiro'] = {
            [7] = {
                {slotName = 'Cabelo', slotType = 'cabelo', valueMaxCategoria = '6', item = 'cabelo'},
                {slotName = 'Pelos Faciais', slotType = 'barba', valueMaxCategoria = '1', item = 'barba'}, 
                {slotName = 'Sobrancelha', slotType = 'sobrancelha', valueMaxCategoria = '1', item = 'sobrancelha'}, 
            },
        },
    },

    txds = { -- Maximo de texturas
        [7] = {
            ['bone'] = {
                [1] = 21,
                [2] = 20,
            },
            ['camisa'] = {
                [1] = 11,
                [2] = 85,
                [3] = 8,
                [4] = 22,
                [5] = 21,
                [6] = 15,
                [7] = 14,
                [8] = 17,
                [9] = 12,
            },
            ['calca'] = {
                [1] = 25,
                [2] = 16,
                [3] = 28,
                [4] = 4,
                [5] = 15,
                [6] = 28,
                [7] = 12,
            },
            ['tenis'] = {
                [1] = 19,
                [2] = 17,
                [3] = 6,
                [4] = 3,
                [5] = 19,
                [6] = 6,
                [7] = 5,
                [8] = 4,
            },
            ['oculos'] = {
                [1] = 15,
                [2] = 8,
            },
            ['acessorios'] = {
                [1] = 2,
                [2] = 2,
                [3] = 2,
                [4] = 2,
            },
            ['relogio'] = {
                [1] = 2,
                [2] = 4,
            },
            ['cabelo'] = {
                [1] = 12,
                [2] = 10,
                [3] = 10,
                [4] = 10,
                [5] = 10,
                [6] = 1,
            },
            ['barba'] = {
                [1] = 58,
            },
            ['sobrancelha'] = {
                [1] = 55,
            },
            
        },
    }

}