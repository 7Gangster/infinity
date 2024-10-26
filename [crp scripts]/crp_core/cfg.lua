cfg = {

    autoStart = {
        MaxPlayers = 200,
        
        start = true,
        MapName = "Developing",
        GameType = "discord.gg/classrp",
        FPSLimit = 100,

        Resources = {
            -- Utils
            "fantasy_anticheat",
            "crp_loadscreen",
            "crp_characters",
            "crp_blur",
            "crp_inventory",
            "crp_voice",
            "crp_laptop",
            "crp_notify",
            "crp_preview",
            "crp_radialmenu",
            "crp_target",

            
            -- Attachs
            "crp_attach",
            "PAttach",
            "Preview_pAttach",
            "bone_attach",
            
            -- InteractionSystem
            "crp_radio",
            "crp_apartamento",
            "crp_bank",
            "crp_chat",
            "crp_hud",
            "crp_radar",
            "crp_craft",
            "crp_dealership",
            "crp_garage",
            "crp_identify",
            "crp_interiores",
            "crp_markers",
            "crp_medic",
            "crp_minigame",
            "crp_missoes",
            "crp_mysterybox",
            "crp_nhtsa",
            "crp_pegarpos",
            "crp_police",
            "crp_portas",
            "crp_service",
            "crp_Somarmas",
            "crp_trunk",
            "crp_trunk",
            "crp_waypoint",
            "crp_anims",

            -- Houses
            "[FANTASY]Buildings",
            "[FANTASY]SystemHouse",
            "[FANTASY]SystemInterior",
            
            -- NPC
            "crp_npc",
            "crp_npc_coldata",
            "crp_npc_traffic",
            "crp_npcia",
            
            -- Jobs
            "crp_jobmanager",
            "crp_express",
            "crp_pescador",
            "crp_trashman",

            -- Custom
            "agatreix_custom",
            "crp_lojaderoupas",
            
            -- Maps
            "crp_map_cacador",
            "crp_mapmc",
            "crp_map_conce",
            "crp_map_dp",
            "crp_map_lixao",
            "crp_map_metro",
            "crp_map_pescador",
            "crp_map_principal",
            "crp_map_restaurantes",
            "crp_map_tunel",

            -- Models
            "crp_model_clukinbell",
            "crp_model_digitalden",
            "crp_model_dp",
            "crp_model_mecanica",
            "crp_model_pizzaria",
            "crp_model_rodas",
            "crp_model_ryderhouse",
            "crp_model_thelost",
            "crp_model_vagos",
            "crp_model_viaturas",
            "crp_model_xoomer",
            "crp_removedoors",
        },
    },

    som_armas = {
        isSoundEnable = true,
        sounds = {
            [22] = {"src/assets/sfx_armas/five.wav", 20, 120, 0.4},
            [23] = {"src/assets/sfx_armas/m1911.wav", 20, 120, 0.4},
            [26] = {"src/assets/sfx_armas/taser.mp3", 5, 15, 0.8},
            [24] = {"src/assets/sfx_armas/deagle.wav", 20, 160, 0.3},
            [25] = {"src/assets/sfx_armas/escopeta.mp3", 20, 150, 1.75},
            [29] = {"src/assets/sfx_armas/mp5.wav", 20, 150, 0.7},
            [32] = {"src/assets/sfx_armas/tec9.wav", 20, 80, 0.8},
            [30] = {"src/assets/sfx_armas/ak.wav", 20, 160, 0.3},
            [31] = {"src/assets/sfx_armas/m4.wav", 20, 160, 0.4},
            [34] = {"src/assets/sfx_armas/sniper.wav", 40, 230, 1.75},
        ----[ID DA ARMA ]------------ distanceMIN, /  DistanceMAX, / volume
        },
    },

    driveby = true,

    keys = {
        vehicle = {
            motor = 'j',
            farol = 'k',
            cinto = 'b',
            trancar = 'l',
        },
    },

    vehicles = {

        [429] = {
            nome = 'Banshee',
            class = 'A',
            handling = false,
        },
        [542] = {
            handling = {
                ['maxVelocity'] = 70,
                ['engineAcceleration'] = 5.5,
            }
        },

    },

    loader = {

        vehicles = {

            
            {"src/assets/vehicles/ambulan.dff", "src/assets/vehicles/ambulan.txd", 416},
            {"src/assets/vehicles/zr350.dff", "src/assets/vehicles/zr350.txd", 477},
            {"src/assets/vehicles/clover.dff", "src/assets/vehicles/clover.txd", 542},
            {"src/assets/vehicles/willardfaction.dff", "src/assets/vehicles/willardfaction.txd", 529},
            {"src/assets/vehicles/alpha.dff", "src/assets/vehicles/alpha.txd", 602},
            {"src/assets/vehicles/blade.dff", "src/assets/vehicles/blade.txd", 536},
            --{"src/assets/vehicles/willard.dff", "src/assets/vehicles/willard.txd", 540},
            {"src/assets/vehicles/tornado.dff", "src/assets/vehicles/tornado.txd", 576},
            {"src/assets/vehicles/sabre.dff", "src/assets/vehicles/sabre.txd", 475},
            {"src/assets/vehicles/impaler.dff", "src/assets/vehicles/impaler.txd", 603},
            {"src/assets/vehicles/rancher.dff", "src/assets/vehicles/rancher.txd", 489},
            {"src/assets/vehicles/voodoo.dff", "src/assets/vehicles/voodoo.txd", 412},
            {"src/assets/vehicles/topfun.dff", "src/assets/vehicles/topfun.txd", 482},
            --{"src/assets/vehicles/emperor.dff", "src/assets/vehicles/emperor.txd", 585},
            {"src/assets/vehicles/huntley.dff", "src/assets/vehicles/huntley.txd", 579},
            {"src/assets/vehicles/glendale.dff", "src/assets/vehicles/glendale.txd", 466},
            {"src/assets/vehicles/primo.dff", "src/assets/vehicles/primo.txd", 547},
            {"src/assets/vehicles/manana.dff", "src/assets/vehicles/manana.txd", 410},
            --{"src/assets/vehicles/greenwoo.dff", "src/assets/vehicles/greenwoo.txd", 492},
            {"src/assets/vehicles/buccanee.dff", "src/assets/vehicles/buccanee.txd", 518},
            {"src/assets/vehicles/elegant.dff", "src/assets/vehicles/elegant.txd", 507},
            {"src/assets/vehicles/peren.dff", "src/assets/vehicles/peren.txd", 404},
            {"src/assets/vehicles/landstal.dff", "src/assets/vehicles/landstal.txd", 400},
            {"src/assets/vehicles/admiral.dff", "src/assets/vehicles/admiral.txd", 445},

            --[[ 
            {"src/assets/vehicles/banshee.dff", "src/assets/vehicles/banshee.txd", 429},
            {"src/assets/vehicles/cheetah.dff", "src/assets/vehicles/cheetah.txd", 415},
            {"src/assets/vehicles/flash.dff", "src/assets/vehicles/flash.txd", 565},
            {"src/assets/vehicles/glendale.dff", "src/assets/vehicles/glendale.txd", 466},
            {"src/assets/vehicles/huntley.dff", "src/assets/vehicles/huntley.txd", 579},
            {"src/assets/vehicles/supergt.dff", "src/assets/vehicles/supergt.txd", 506},]]
        },

        objects = {
            {"src/assets/objetos/vaper.dff", "src/assets/objetos/vaper.txd", 1853},
            {"src/assets/objetos/hotdog.dff", "src/assets/objetos/hotdog.txd", 1854},
            {"src/assets/objetos/cafe.dff", "src/assets/objetos/cafe.txd", 1855},
            {"src/assets/objetos/agua.dff", "src/assets/objetos/agua.txd", 1856},
            {"src/assets/objetos/bandagem.dff", "src/assets/objetos/bandagem.txd", 1857},
            {"src/assets/objetos/kit.dff", "src/assets/objetos/kit.txd", 1858},
            {"src/assets/objetos/analgesico.dff", "src/assets/objetos/analgesico.txd", 1859},
            {"src/assets/objetos/agua.dff", "src/assets/objetos/energetico.txd", 1860},
            {"src/assets/objetos/donut.dff", "src/assets/objetos/donut.txd", 1861},
            {"src/assets/objetos/cilindro.dff", "src/assets/objetos/cilindro.txd", 2324},
            {"src/assets/objetos/oculos.dff", "src/assets/objetos/oculos.txd", 3000},
            {"src/assets/objetos/respirador.dff", "src/assets/objetos/respirador.txd", 3001},
            {"src/assets/objetos/vara.dff", "src/assets/objetos/vara.txd", 338},
            {"src/assets/objetos/celular.dff", "src/assets/objetos/celular.txd", 330},
            {"src/assets/objetos/bag-ifood.dff", "src/assets/objetos/bag-ifood.txd", 1957},
            {"src/assets/objetos/tablet.dff", "src/assets/objetos/tablet.txd", 1946},
            {"src/assets/objetos/algema.dff", "src/assets/objetos/algema.txd", 321},
            {"src/assets/objetos/vassoura.dff", "src/assets/objetos/vassoura.txd", 2237},
            {"src/assets/objetos/prancheta.dff", "src/assets/objetos/prancheta.txd", 2967},
            {"src/assets/objetos/agua.dff", "src/assets/objetos/aguasuja.txd", 2530},
            {"src/assets/objetos/suco.dff", "src/assets/objetos/suco.txd", 1964},
            {"src/assets/objetos/308.dff", "src/assets/objetos/308.txd", 308},
            {"src/assets/objetos/kid.dff", "src/assets/objetos/kid.txd", 10},
            {"src/assets/objetos/skin.dff", "src/assets/objetos/skin.txd", 22},
            {"src/assets/objetos/baldeh.dff", "src/assets/objetos/baldeh.txd", 2718},
        }

    },


}