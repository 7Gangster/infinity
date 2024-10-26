Config = {

    Salarios = {
        ['Policial'] = 16000, -- 12000
        ['Paramedic'] = 16000, -- 12000
        ['Mecanico'] = 8000, -- 5000
    },
    Markers = {
        {1572.84375,-1686.4979248047,16.203125, 'Policial', 'archives/assets/imgs/groups/police.png', 'police >> duty', 'LS POLICE DEPARTMENT'},
        {1214.7874755859,-1781.9771728516,13.6015625, 'Paramedic', 'archives/assets/imgs/groups/medic.png', 'paramedic >> duty', 'LS MEDICAL DEPARTMENT'}, -- X, Y, Z, Acl, DIRETORY IMAGE, ElementData, Group Name
        {941.99603271484,-1555.9110107422,13.560811042786, 'Mecanico', 'archives/assets/imgs/groups/mechanic.png', 'mecanico >> duty', 'LS MECHANIC'},
    },

    server_Notification = function(player, msg, type)
        --iprint(msg)
        exports['crp_notify']:addBox(player, msg, type)
    end
}