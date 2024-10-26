local config = {
    ['Garages'] = { 
        ['Policia'] = { -- Polícia LS
            ['Data Permissions'] = 'police >> duty', -- ElementData para poder abrir a garagem da polícia.
            ['Position'] = Vector3(1580.263671875,-1636.1313476562,13.55916595459),
            ['SpawnPosition'] = {1588.5532226562,-1635.4013671875,13.390879631042},
            ['SpawnRotation'] = {0, 0, 0},
            ['Window Config'] = { -- Textos que vão aparacer na 1° aba.
                [1] = {
                    ['Title'] = 'Guardar'; -- Título, máximo 13 caracteres.
                    ['Description'] = 'Guardar a viatura mais próxima.'; -- Descrição, máximo 20 caracteres.
                };
                [2] = {
                    ['Title'] = 'Garagem';
                    ['Description'] = 'Gerencie suas viaturas.';
                };
                [3] = {
                    ['Title'] = 'Shop';
                    ['Description'] = 'Compre viaturas.';
                };
            };
            ['Vehicles'] = {
                [1] = {
                    ['Name'] = 'Victoria Crown L.S.P.D', -- Nome da viatura .
                    ['ID'] = 596, -- ID da viatura.
                    ['Price'] = 1000; -- Preço que o player vai pagar.
                }; 
                [2] = {
                    ['Name'] = 'Explorer L.S.P.D',
                    ['ID'] = 490,
                    ['Price'] = 1000;
                };
                [3] = {
                    ['Name'] = 'Moto L.S.P.D',
                    ['ID'] = 598,
                    ['Price'] = 1000;
                };
                [4] = {
                    ['Name'] = 'Maverick L.S.P.D',
                    ['ID'] = 599,
                    ['Price'] = 1000;
                };
            };
        };
    };
    ['DistanceGarage'] = 50; -- Distância do player e do veículo para poder destruir.
    ['ElementData Gasoline'] = 'Fuel'; -- ElementData da gasolina.
    ['TimeDefault'] = 1; -- Tempo em segundos para aparecer a mensagem na infobox.
    ['Messages'] = { -- Mensagem, tipo da mensagem.
    
        ['notPermission'] = {'Você não possui permissão para abrir a garagem.', 'error'};
        ['isNotVehicle'] = {'Você não possui um veículo na garagem.', 'error'};
        ['vehicleSpawned'] = {'Seu veículo já está spawnado.', 'error'};
        ['vehicleSpawned2'] = {'Você já tem algum veículo spawnado.', 'error'};
        ['notVehicleSpawnedDestroy'] = {'Você não possuí veículos fora da garagem.', 'info'};
        ['notMoney'] = {'Você não possui dinheiro suficiente.', 'error'};
        ['takeVehicle'] = {'Você pegou o veículo.', 'success'};
        ['destroyVehicle'] = {'Você guardou seu veículo.', 'success'};
        ['vehicleExists'] = {'Você já possui esse veículo.', 'error'};
        ['buyVehicle'] = {'Você comprou o veículo.', 'success'};
        ['vehicleDistance'] = {'Seu veículo está muito longe de você.', 'info'}

    };

    serverNotify = function(player, msg, type)
        exports['crp_notify']:addBox(player, msg, type)
    end;
    clientNotify = function(msg, type)
        triggerEvent('addBox', localPlayer, msg, type)
    end;
};

function getConfig ()
    return config;
end