Config = {

    maxVehicles = 2,
    aclVip = 'VIP',

    Elements = {
        Gasolina = {
            Gas = 'fuel',
            Diesel = 'fuel:diesel',
            Premium = 'fuel:premium'
        },
    },

    Veiculos = { -- Siga sempre a baixo do ultimo, se não, vai dar erro.
        -- Conce LUXO (SF)
        
        {name = 'TRACER MERCURY', position = {2147.8481445312,-1161.30859375,23.490966796875, 0, 0, 270}, model = 547, preco = 12000, type_gas = 'Premium', max_velocity = 'N/A', estoque = 3, spawn = {2118.7106933594,-1154.8975830078,23.619140625, 0}},
        {name = 'CUTLASS', position = {2161.2497558594,-1158.5639648438,23.613489151001, 0, 0, 90}, model = 566, preco = 21000, type_gas = 'Premium', max_velocity = 'N/A', estoque = 3, spawn = {2118.7106933594,-1154.8975830078,23.619140625, 0}},
        {name = 'PLYMOUTH', position = {2148.1457519531,-1170.4575195312,23.511775970459, 0, 0, 270}, model = 404, preco = 8500, type_gas = 'Premium', max_velocity = 'N/A', estoque = 3, spawn = {2118.7106933594,-1154.8975830078,23.619140625, 0}},
        {name = 'GLENDALE', position = {2161.4892578125,-1168.4445800781,23.395277023315, 0, 0, 90}, model = 466, preco = 14000, type_gas = 'Premium', max_velocity = 'N/A', estoque = 3, spawn = {2118.7106933594,-1154.8975830078,23.619140625, 0}},
        --[[
        {name = 'PFISTER COMET', position = {-1944.7276611328,258.06799316406,41.047080993652, 0, 0, 87}, model = 480, preco = 520000, type_gas = 'Premium', max_velocity = 225, estoque = 3, spawn = {-1928.8286132812,274.03524780273,41.046875, 180}},
        {name = 'OBEY 9F', position = {-1946.1520996094,273.16928100586,35.473926544189, 0, 0, 90}, model = 429, preco = 620000, type_gas = 'Premium', max_velocity = 240, estoque = 5, spawn = {-1928.8286132812,274.03524780273,41.046875, 180}},
        {name = 'DINKA JESTER', position = {-1945.8488769531,265.02996826172,35.421531677246, 0, 0, 90}, model = 559, preco = 500000, type_gas = 'Premium', max_velocity = 219, estoque = 5, spawn = {-1928.8286132812,274.03524780273,41.046875, 180}},
        {name = 'SULTAN RS', position = {-1946.4049072266,259.05950927734,35.20548248291, 0, 0, 90}, model = 560, preco = 420000, type_gas = 'Premium', max_velocity = 212, estoque = 5, spawn = {-1928.8286132812,274.03524780273,41.046875, 180}},
        
        -- Conce Popular
        {name='BENEFECTOR PANTO', position = { 2161.683, -1143.652, 24.85, 0, 0, 91}, model = 545, preco=15000, type_gas='Gas', max_velocity=100, estoque=10, spawn= {2119.2143554688,-1154.0299072266,24.065757751465, 0}},
        {name='GROTTI BRIOSO', position = {2162.071, -1148.355, 24.37 -0.6, 0, 0,90}, model = 589, preco=30000, type_gas='Gas', max_velocity=121, estoque=5, spawn= {2119.2143554688,-1154.0299072266,24.065757751465, 0}},
        {name='KARIN FUTO', position = {2161.648, -1152.982, 23.9 -0.4, 0, 0, 90}, model = 527, preco=50000, type_gas='Gas', max_velocity=120, estoque=5, spawn= {2119.2143554688,-1154.0299072266,24.065757751465, 0}},
        {name='DECLASSE SABRE TURBO', position = {2148.757, -1152.956, 23.899, 0, 0, 270}, model = 475, preco=60000, type_gas='Gas', max_velocity=135, estoque=5, spawn= {2119.2143554688,-1154.0299072266,24.065757751465, 0}},
        {name='BRAVADO GLAUTENT', position = {2147.865, -1148.339, 24.404 -0.4, 0, 0, 270}, model = 542, preco=80000, type_gas='Gas', max_velocity=151, estoque=5, spawn= {2119.2143554688,-1154.0299072266,24.065757751465, 0}},
        {name='LAMPADATI FELON', position = {2148.647, -1157.363, 23.845, 0, 0, 270}, model = 492, preco=80000, type_gas='Gas', max_velocity=154, estoque=5, spawn= {2119.2143554688,-1154.0299072266,24.065757751465, 0}},
        {name='GALLIVANTER BALLER', position = {2161.613, -1158.105, 23.839, 0, 0, 90}, model = 579, preco=135000, type_gas='Gas', max_velocity=163, estoque=7, spawn= {2119.2143554688,-1154.0299072266,24.065757751465, 0}},
        {name='VAPID GB200', position={2161.332, -1163.273, 23.816 -0.6, 0, 0, 90}, model = 496, preco=200000, type_gas='Gas', max_velocity=170, estoque=2, spawn={2119.2143554688,-1154.0299072266,24.065757751465, 0}},        
        {name='DECLASSE VOODOO', position={2802.852, -1540.154, 10.922 -0.2, 0, 0, 180}, model = 412, preco=78000, type_gas='Gas', max_velocity=164, estoque=5, spawn={2804.112, -1554.492, 10.922, 177}},
        {name='DECLASSE MOONBEAM', position={2816.141, -1539.121, 10.922 -0.4, 0, 0, 180}, model = 418, preco=100000, type_gas='Gas', max_velocity=146, estoque=5, spawn={2804.112, -1554.492, 10.922, 177}},
        
        -- 

        -- Conce MOTOS
        {name = 'SHITZU VADER', position = {2100.87890625,1399.3977050781,11.014964103699, 0, 0, 180}, model = 581, preco = 50000, type_gas = 'Premium', max_velocity = 130, estoque = 5, spawn = {2193.8408203125,1386.9661865234,10.8203125, 270}},
        {name = 'MAIBATSU SANCHEZ', position = {2107.1928710938,1399.0979003906,10.778649330139, 0, 0, 180}, model = 468, preco = 40000, type_gas = 'Premium', max_velocity = 123, estoque = 5, spawn = {2193.8408203125,1386.9661865234,10.8203125, 270}},
        {name = 'NAGASAKI CARBON RS', position = {2114.0263671875,1399.0467529297,10.825800895691, 0, 0, 180}, model = 522, preco = 200000, type_gas = 'Premium', max_velocity = 165, estoque = 2, spawn = {2193.8408203125,1386.9661865234,10.8203125, 270}},
        {name = 'NAGASAKI BLAZER', position = {2120.8461914062,1399.083984375,10.958258628845, 0, 0, 180}, model = 471, preco = 35000, type_gas = 'Premium', max_velocity = 94, estoque = 5, spawn = {2193.8408203125,1386.9661865234,10.8203125, 270}},
        {name = 'WESTERN DEAMON', position = {2126.6901855469,1399.4565429688,10.618511199951, 0, 0, 180}, model = 463, preco = 75000, type_gas = 'Premium', max_velocity = 145, estoque = 2, spawn = {2193.8408203125,1386.9661865234,10.8203125, 270}},
        {name = 'FAGGIO', position = {2133.005859375,1399.466796875,10.816873550415, 0, 0, 180}, model = 462, preco = 7000, type_gas = 'Premium', max_velocity = 70, estoque = 15, spawn = {2193.8408203125,1386.9661865234,10.8203125, 270}},

        -- Conce caminhões
        {name = 'BENSON', position = {-62.075, -324.481, 5.414, 0, 0, 270}, model = 499, preco = 300000, type_gas = 'Premium', max_velocity = 110, estoque = 3, spawn = {-23.378, -274.871, 5.43, 180}},
         {name = 'YANKEE', position = {-59.907, -310.863, 5.825, 0, 0, 270}, model = 456, preco = 1500000, type_gas = 'Premium', max_velocity = 110, estoque = 2, spawn = {-23.378, -274.871, 5.43, 180}},
        {name = 'BURRITO', position = {-62.572, -303.628, 5.413, 0, 0, 270}, model = 482, preco = 150000, type_gas = 'Premium', max_velocity = 112, estoque = 3, spawn = {-23.378, -274.871, 5.43, 180}},
    
        --Conce Lowrriders
        {name='ALBANY BUCCANER', position={2811.708, -1539.754, 10.922 -0.6, 0, 0, 180}, model = 575, preco=85000, type_gas='Gas', max_velocity=159, estoque=7, spawn={2804.112, -1554.492, 10.922, 177}},
        --{name='VAPID CHINO', position={2811.508, -1539.905, 10.922 -0.4, 0, 0, 180}, model = 536, preco=82000, type_gas='Gas', max_velocity=167, estoque=7, spawn={2804.112, -1554.492, 10.922, 177}},
        {name='WILLARD FACTION', position={2807.533, -1539.86, 10.922 -0.4, 0, 0, 180}, model = 534, preco=80000, type_gas='Gas', max_velocity=163, estoque=7, spawn={2804.112, -1554.492, 10.922, 177}},

        --IMPORTADOS
        {name='Skyline R34 Nismo', position={1545.049, -1358.467, 329.465 -0.4, 0, 0, 90}, model = 541, preco=800000, type_gas='Gas', max_velocity=223, estoque=3, spawn={1536.764, -1358.747, 329.463, 177}},
        {name='Skyline R35', position={1545.255, -1355.235, 329.471 -0.4, 0, 0, 90}, model = 602, preco=800000, type_gas='Gas', max_velocity=223, estoque=3, spawn={1536.764, -1358.747, 329.463, 177}},
        {name='Mercedes AMG Gt 63', position={1545.792, -1351.979, 329.473 -0.4, 0, 0, 90}, model = 421, preco=800000, type_gas='Gas', max_velocity=223, estoque=3, spawn={1536.764, -1358.747, 329.463, 177}},
]]
    },


    Garagens = {
        -- Garagem lixão
        {2165.5808105469,-1885.3480224609,13.546875, spawn = {2165.737, -1890.564, 13.311, 180}},
        -- Garagem cemitério
        {853.14868164062,-1060.8031005859,25.106796264648, spawn = {862.61383056641,-1061.3134765625,25.1015625, 304}},
        -- Garagem praia 
        {691.36413574219,-1568.0383300781,14.2421875, spawn = {691.09466552734,-1573.3070068359,14.2421875, 180}},
        -- Garagem mecânica
        {990.10491943359,-1522.0579833984,13.553113937378, spawn = {989.79864501953,-1528.2133789062,13.565139770508, 180}},
        -- Garagem DP
        {1702.7030029297,-1471.185546875,13.546875, spawn = {1702.4565429688,-1477.8029785156,13.3828125, 180}},
        -- Praia CJ
        {2767.6279296875,-1606.2449951172,10.921875, spawn = {2774.646484375,-1606.8625488281,10.921875, 270}},
        -- Dillmore
        {637.64892578125,-499.77197265625,16.3359375, spawn = {642.92993164062,-501.78744506836,16.3359375, 270}},
        -- Blueberry
        {252.79991149902,29.535457611084,2.4565200805664, spawn = {245.71337890625,30.268335342407,2.5467565059662, 90}},
        -- Posto LV 1
        {2117.091796875,956.27325439453,10.8203125, spawn = {2126.1723632812,956.29217529297,10.8203125, 270}},
        -- Posto LV 2
        {2638.5944824219,1070.2904052734,10.8203125, spawn = {2629.7124023438,1070.3487548828,10.8203125, 90}},
        -- Posto LV 3
        {2203.7717285156,2493.7199707031,10.8203125, spawn = {2204.0112304688,2487.7321777344,10.8203125, 180}},

        -- Mecanica SF
        {-2026.6409912109,132.06909179688,28.842931747437, spawn = {-2027.0808105469,139.72483825684,28.8359375, 0}},
        -- Posto SF
        {-2425.779296875,1030.8276367188,50.390625, spawn = {-2424.2990722656,1037.4067382812,50.390625, 270}},

        -- Próxima a conce popular
        {2311.89, -1232.573, 24.07, spawn = {2306.865, -1235.002, 23.849, 358}},
        {2033.088, -963.239, 41.468, spawn = {2029.965, -965.164, 40.66, 192}},
    },

    Desmanche = {
        Porcentagem = 75,
        Markers = {
            --{1823.9226074219,-2021.0675048828,13.3828125},
        },
    },

    porta_malas = {
        [547] = 20,
        [566] = 30,
        [466] = 15,
        [404] = 30,
    }
}

function msg (player, msg, type, time)
    exports['crp_notify']:addBox(player, msg, type, (time or 7000))
end

function getConfig ()
    return Config
end