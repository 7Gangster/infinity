config = {
    ["Mensagem Start"] = true, --Caso esteja false ele não irá aparecer a mensagem!
    ["Icons Positions"] = { --Pos Icon, pos Arrow
        {644, 123, 77, 72},
        {464, 216, 77, 72},
        {822, 217, 77, 72},
        {426, 384, 77, 72},
        {863, 385, 77, 72},
    },
    ["Interações"] = {
        {"ESTILO DE ANDAR", "estilo"},
        {"VIPS", "vips"},
        {"INTERAÇÕES", "interacoes"},
        {"SOCIAL", "social"},
        {"DANÇAS", "dancas"},
        {"OUTROS", "Outros"},
    },
    ["ACLs VIPs"] = {
		"VIP",
    },
    ["Animations"] = {
        ["INTERAÇÕES"] = {
            {"Cruzar os braços", "cruzar", {"Ações", "Cruzar Braços", 500, false, false, true}, 'Custom'},
            {"Rendido 2", "rendido2", {"Ações", "Render 2", 500, false, false, true}, 'Custom'},
            {"Rendido 3", "rendido3", {"Ações", "Render 3", 500, false, false, true}, 'Custom'},
            {"Rendido", "rendido1", {"Ações", "Render", 500, false, false, true}, 'Custom'},
            {"Comprimentar", "comprimentar", {"GANGS", "hndshkaa", -1, true, false, false}, 'Padrao'},
            {"Comprimentar 2", "comprimentar2", {"GANGS", "hndshkba", -1, true, false, false}, 'Padrao'},
            {"Conversando", "conversando", {"GANGS", "prtial_gngtlkA", -1, true, false, false}, 'Padrao'},
            {"Conversando 2", "conversando2", {"GANGS", "prtial_gngtlkB", -1, true, false, false}, 'Padrao'},
            {"Empurrão", "empurrao", {"GANGS", "shake_cara", -1, true, false, false}, 'Padrao'},
            {"Flexão", "flexao", {"flexao", "flexao", -1, true, false, false}, 'IFP'},
            {"Abdominal", "abdominal", {"abdominal", "abdominal", -1, true, false, false}, 'IFP'},
            {"Continência", "continencia", {"continencia", "continencia", -1, true, false, false}, 'IFP'},
            {"Triste", "triste1", {"Interações", "Triste", 500, false, false, true}, 'Custom'},
            {"Pensando", "pensando1", {"Interações", "Pensativo 2", 500, false, false, true}, 'Custom'},
            {"Fumando", "fumando1", {"SMOKING", "M_smkstnd_loop", -1, true, false, false}, 'Padrao'},
            {"Fumando 2", "fumando2", {"LOWRIDER", "M_smkstnd_loop", -1, true, false, false}, 'Padrao'},
            {"Fumando 3", "fumando3", {"GANGS", "smkcig_prtl", -1, true, false, false}, 'Padrao'},
            {"Esperando", "esperando1", {"COP_AMBIENT", "Coplook_loop", -1, true, false, false}, 'Padrao'},
            {"Esperando 2", "esperando2", {"COP_AMBIENT", "Coplook_shake", -1, true, false, false}, 'Padrao'},
            {"Comemorando", "comemorando1", {"CASINO", "manwinb", -1, true, false, false}, 'Padrao'},
            {"Comemorando 2", "comemorando2", {"CASINO", "manwind", -1, true, false, false}, 'Padrao'},
            {"Cansado", "cansado", {"FAT", "idle_tired", -1, true, false, false}, 'Padrao'},
            {"Rindo", "rindo", {"RAPPING", "Laugh_01", -1, true, false, false}, 'Padrao'},
            {"Dança", "dance1", {"DANCING", "dance_loop", -1, true, false, false}, 'Padrao'},
            {"Dança 2", "dance2", {"DANCING", "DAN_Down_A", -1, true, false, false}, 'Padrao'},
            {"Dança 3", "dance3", {"DANCING", "DAN_Left_A", -1, true, false, false}, 'Padrao'},
            {"Dança 4", "dance4", {"DANCING", "DAN_Right_A", -1, true, false, false}, 'Padrao'},
            {"Dança 5", "dance5", {"DANCING", "DAN_Up_A", -1, true, false, false}, 'Padrao'},
            {"Dança 6", "dance6", {"DANCING", "dnce_M_a", -1, true, false, false}, 'Padrao'},
            {"Dança 7", "dance7", {"DANCING", "dnce_M_b", -1, true, false, false}, 'Padrao'},
            {"Dança 8", "dance8", {"DANCING", "dnce_M_c", -1, true, false, false}, 'Padrao'},
            {"Dança 9", "dance9", {"DANCING", "dnce_M_d", -1, true, false, false}, 'Padrao'},
            {"Dança 10", "dance10", {"DANCING", "dnce_M_e", -1, true, false, false}, 'Padrao'},
            {"Dança 11", "dance11", {"fortnite1", "baile 1", -1, true, false, false}, 'IFP'},
            {"Dança 12", "dance12", {"fortnite1", "baile 2", -1, true, false, false}, 'IFP'},
            {"Dança 13", "dance13", {"fortnite1", "baile 3", -1, true, false, false}, 'IFP'},
            {"Dança 14", "dance14", {"fortnite1", "baile 4", -1, true, false, false}, 'IFP'},
            {"Dança 15", "dance15", {"fortnite1", "baile 5", -1, true, false, false}, 'IFP'},
            {"Dança 16", "dance16", {"fortnite1", "baile 6", -1, true, false, false}, 'IFP'},
            {"Dança 17", "dance17", {"fortnite2", "baile 7", -1, true, false, false}, 'IFP'},
            {"Maleta", "maleta1", {"Ações", "Segurando maleta", 500, false, false, true}, 'Custom'},
            {"Deitar 2", "deitar2", {"CRACK", "crckidle4", -1, true, false, false}, 'Padrao'},
            {"Sentar 2", "sentar2", {"INT_HOUSE", "LOU_In", -1, false, false, false}, 'Padrao'},
            {"Sentar 3", "sentar3", {"ped", "SEAT_idle", -1, true, false, false}, 'Padrao'},
            {"Fumando 2", "fumando2", {"LOWRIDER", "M_smkstnd_loop", -1, true, false, false}, 'Padrao'},
            {"Fumando 3", "fumando3", {"GANGS", "smkcig_prtl", -1, true, false, false}, 'Padrao'},
            {"Caixa", "caixa1", {"Ações", "Segurando caixa", 500, false, false, true}, 'Custom'},
            {"Gang", "gang", 121},
            {"Dança 18", "dance18", {"fortnite2", "baile 8", -1, true, false, false}, 'IFP'},
            {"Dança 19", "dance19", {"fortnite3", "baile 9", -1, true, false, false}, 'IFP'},
            {"Dança 20", "dance20", {"fortnite3", "baile 10", -1, true, false, false}, 'IFP'},
            {"Dança 21", "dance21", {"fortnite3", "baile 11", -1, true, false, false}, 'IFP'},
            {"Dança 22", "dance22", {"fortnite3", "baile 12", -1, true, false, false}, 'IFP'},
            {"Dança 23", "dance23", {"fortnite3", "baile 13", -1, true, false, false}, 'IFP'},
            {"Dança 24", "dance24", {"breakdance1", "break_D", -1, true, false, false}, 'IFP'},
            {"Dança 25", "dance25", {"breakdance2", "FightA_1", -1, true, false, false}, 'IFP'},
            {"Dança 26", "dance26", {"breakdance2", "FightA_2", -1, true, false, false}, 'IFP'},
            {"Dança 27", "dance27", {"breakdance2", "FightA_3", -1, true, false, false}, 'IFP'},
            {"Dança 28", "dance28", {"newAnims", "dance1", -1, true, false, false}, 'IFP'},
            {"Dança 29", "dance29", {"newAnims", "dance2", -1, true, false, false}, 'IFP'},
            {"Dança 30", "dance30", {"newAnims", "dance3", -1, true, false, false}, 'IFP'},
            {"Dança 31", "dance31", {"newAnims", "dance4", -1, true, false, false}, 'IFP'},
            {"Dança 32", "dance32", {"newAnims", "dance5", -1, true, false, false}, 'IFP'},
            {"Dança 33", "dance33", {"newAnims", "dance6", -1, true, false, false}, 'IFP'},
            {"Dança 34", "dance34", {"newAnims", "dance7", -1, true, false, false}, 'IFP'},
            {"Dança 35", "dance35", {"newAnims", "dance8", -1, true, false, false}, 'IFP'},
            {"Santo", "santo", {"Interações", "Santo", 500, false, false, true}, 'Custom'},
            {"Assobiar", "assobiar", {"Ações", "Assobiar", 600, false, false, false}, 'Custom'},
            {"Falando radinho", "radinho", {"Ações", "Falando radinho", 500, false, false, true}, 'Custom'},
            {"Segurando arma", "arma1", {"Ações", "Segurar arma", 500, false, false, true}, 'Custom'},
            {"Segurando arma 2", "arma2", {"Ações", "Segurar arma 2", 500, false, false, true}, 'Custom'},
            {"Segurando revolver", "revolver", {"Ações", "Segurar pistola", 500, false, false, true}, 'Custom'},
            {"Meditando", "meditando", {"Interações", "Meditando", 800, false, false, true}, 'Custom'},
            {"Levantar", "levantar", {"INT_HOUSE", "wash_up", -1, true, false, false}, 'Padrao'},
            {"Sentar", "sit", {"INT_HOUSE", "LOU_Loop", -1, true, false, false}, 'Padrao'},
            --{"Sentar 2", "sentar2", {"INT_HOUSE", "LOU_In", -1, false, false, false}, 'Padrao'},
            --{"Sentar 3", "sentar3", {"ped", "SEAT_idle", -1, true, false, false}, 'Padrao'},
            {"Deitar", "deitar", {"CRACK", "crckidle2", -1, true, false, false}, 'Padrao'},
            --{"Deitar 2", "deitar2", {"CRACK", "crckidle4", -1, true, false, false}, 'Padrao'},
            {"Cartão", "cartao", {"HEIST9", "Use_SwipeCard", -1, true, false, false}, 'Padrao'},
            {"Assustado", "assustado", {"ped", "cower", -1, true, false, false}, 'Padrao'},
            {"Mijando", "mijando", {"PAULNMAC", "Piss_out", -1, true, false, false}, 'Padrao'},
            {"Caixa", "caixa", {"Ações", "Segurando caixa", 500, false, false, true}, 'Custom'},
            {"Buquê", "buque", {"Ações", "Segurar buquê", 500, false, false, true}, 'Custom'},
            {"Prancha", "prancha", {"Ações", "Segurar prancha", 500, false, false, true}, 'Custom'},
            {"Guarda-Chuvas", "guardachuva", {"Ações", "Segurar guarda chuvas", 500, false, false, true}, 'Custom'},
            {"Câmera", "camera", {"Ações", "Segurando camera", 500, false, false, true}, 'Custom'},
            {"Prancheta", "prancheta", {"Ações", "Segurando prancheta", 500, false, false, true}, 'Custom'},
            {"Maleta", "maleta", {"Ações", "Segurando maleta", 500, false, false, true}, 'Custom'},
        },
        ["ESTILO DE ANDAR"] = {
            {"Padrão", "ad1", 0},
            {"Padrão 2", "ad2", 56},
            {"Bebado", "bebado", 126},
            {"Gordo", "gordo", 55},
            {"Gordo 2", "gordo2", 124},
            --{"Gang", "gang", 121},
            {"Idoso", "idoso", 120},
            {"Idoso 2", "idoso2", 123},
            {"SWAT", "swat", 128},
            {"Feminino", "feminino1", 129},
            {"Feminino 2", "feminino2", 131},
            {"Feminino 3", "feminino3", 132},
            {"Feminino 4", "feminino4", 136}
        },
        ["SOCIAL"] = {

        },
        ["DANÇAS"] = {
 
        },
        ["VIPS"] = {
 
        },
        ["OUTROS"] = {

        },
    },
    
    CUSTOM_ANIMATIONS = {
        ['Ações'] = {
            ['Cruzar Braços'] = {
                BonesRotation = {
                    [32] = {0, -110, 25},
                    [33] = {0, -100, 0},
                    [34] = {-75, 0, -40},
                    [22] = {0, -90, -25},
                    [23] = {0, -100, 0},
                },
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
            },
            ['Falando radinho'] = {
                BonesRotation = {
                    [5] = {0, 0, -30},
                    [32] = {-30, -30, 50},
                    [33] = {0, -160, 0},
                    [34] = {-120, 0, 0}
                },

                Object = {
                    Model = 1429,
                    Offset = {34, 0.09,0.04,-0.09,-180,7.2,0},
                    Scale = 1,
                },

                blockAttack = false,
                blockJump = false,
                blockVehicle = false,
            },
            ['Render'] = {
                BonesRotation = {
                    [22] = {0, -15, 60},
                    [32] = {0, -10, -60},
                    [23] = {80, -10, 120},
                    [33] = {-80, -10, -120},
                    [5] = {0, 8, 0}
                },
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
            },
            ['Render 2'] = {
                BonesRotation = {
                    [22] = {-30, -55, 30},
                    [23] = {10, -20, 60},
                    [24] = {120, 0, 0},
                    [25] = {0, 0, 0},
                    [26] = {0, 0, 0},
                    [32] = {-30, -55, -30},
                    [33] = {-10, -80, -30},
                    [34] = {-70, 0, 0},
                    [35] = {0, 0, 0},
                    [36] = {0, 0, 0},
                    [5] = {0, 8, 0}
                },
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
            },
            ['Render 3'] = {
                BonesRotation = {
                    [22] = {0, -15, 70},
                    [32] = {0, -10, -60},
                    [23] = {80, -10, 130},
                    [33] = {-80, -10, -130},
                    [5] = {0, -20, 0}
                },
    
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
            },
            ['Segurar arma'] = {
                BonesRotation = {
                    [23] = {-10, -100, 10},
                    [24] = {120, 10, -50},
                    [32] = {0, 0, 60},
                    [33] = {0, -45, 35},
                },
                blockAttack = true,
                blockVehicle = true,
            },
            ['Segurar arma 2'] = {
                BonesRotation = {
                    [5] = {0, 0, 0},
                    [22] = {80, 0, 0},
                    [23] = {0, -160, 0},
                    [32] = {0, 0, 70},
                    [33] = {0, -10, 20},
                    [34] = {-80, 0, 0},
                },
                blockAttack = true,
                blockVehicle = true,
            },
            ['Segurar pistola'] = {
                BonesRotation = {
                    [22] = {0, -30, -35},
                    [23] = {20, -125, -10},
                    [24] = {90, 40, -10},
                    [32] = {-5, -70, 60},
                    [33] = {-70, -90, -5},
                },
                blockAttack = true,
                blockVehicle = true,
            },
            ['Equipar máscara'] = {
                BonesRotation = {
                    [22] = {0, -80, -5},
                    [23] = {0, -125, 30},
                    [24] = {160, 0, 0},
                },
                blockAttack = true,
            },
            ['Equipar óculos'] = {
                BonesRotation = {
                    [5] = {10, 5, 0},
                    [22] = {0, -80, -5},
                    [23] = {0, -155, 50},
                    [24] = {60, 0, 0},
                    [32] = {0, -80, 5},
                    [33] = {0, -155, -55},
                    [34] = {-60, 0, 0},
                },
                blockAttack = true,
            },
    
            ['Equipar bolsa'] = {
                BonesRotation = {
                    [22] = {0, -35, -30},
                    [23] = {0, -140, -10},
    
                    [32] = {0, -35, 30},
                    [33] = {0, -140, 10},
                },
                blockAttack = true,
                blockJump = true,
            },
            ['Segurar escudo'] = {
                BonesRotation = {
                    [201] = {0, 0, 0},
                    [32] = {-80, -100, 13},
                    [33] = {-10, -10, 80},
                },
                onDuck = {
                    [201] = {0, 0, 0},
                    [32] = {-100, -15, -25},
                    [33] = {35, 50, 110},
                    [34] = {-30, 0, 0},
                },
                blockVehicle = true,
            },
    
            ['Colocar capacete'] = {
                BonesRotation = {
                    [5] = {0, 20, 0},
                    [22] = {0, -90, 0},
                    [23] = {50, -170, 60},
                    [24] = {0, 0, 0},
                    [25] = {-40, 0, 0},
                    [32] = {0, -110, 0},
                    [33] = {0, -170, -55},
                    [34] = {0, 0, 0},
                    [35] = {40, 0, 0},
                },
                blockAttack = true,
                Sound = {
                    File = 'capacete',
                    MaxDistance = 10,
                    Volume = 0.2,
                },
            },
    
            ['Segurando garrafa'] = {
                BonesRotation = {
                    [32] = {30, -20, 60},
                    [33] = {0, -90, 0},
                    [34] = {-90, 0, 0},
                    [35] = {-10, 0, 0},
                },
                onDuck = {
                    [32] = {-30, 0, 60},
                    [33] = {0, -90, 0},
                    [34] = {-90, 0, 0},
                    [35] = {-10, 0, 0},
                },
                Object = {
                    Model = 1484,
                    Offset = {34, 0.07, 0.03, 0.05, 0, -180, 0},
                    Scale = 0.9,
                },
            },
            ['Segurando camera'] = {
                BonesRotation = {
                    [22] = {0, -60, 0},
                    [23] = {80, -90, 80},
                    [24] = {80, 30, 0},
    
                    [32] = {0, -85, 10},
                    [33] = {-70, -100, -20},
                },
                onDuck = {
                    [22] = {0, -80, 0},
                    [23] = {80, -70, 80},
                    [24] = {90, 30, 0},
    
                    [32] = {0, 0, 10},
                    [33] = {-70, -100, -20},
                    [34] = {-20, 0, 0},
                },
                Object = {
                    Model = 367,
                    Offset = {24, -0.04,0.08,-0.31,-10.8,54,0},
                },
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
            },
            ['Segurando prancheta'] = {
                BonesRotation = {
                    [5] = {0, 5, 0},
                    [32] = {-10, -60, 20},
                    [33] = {-30, -80, 0},
    
                    [34] = {-120, 0, 0},
                    [35] = {-40, 30, -10},
                },
                onDuck = {
                    [5] = {0, -30, 0},
                    [32] = {-10, -20, -5},
                    [33] = {-40, -90, 0},
    
                    [34] = {-140, 0, 0},
                    [35] = {-40, 30, -10},
                },
                Object = {
                    Model = 1933,
                    Offset = {35, 0.08,0.05,0.02,82.8,-180,0},
                },
                blockJump = true,
            },
            ['Segurando maleta'] = {
                BonesRotation = {},
                Object = {
                    Model = 1934,
                    Offset = {35, 0.23,-0.02,0.03,25.2,-108,0},
                    Scale = 0.7,
                }
            },
            ['Segurar buquê'] = {
                BonesRotation = {
                    [32] = {30, -20, 60},
                    [33] = {0, -90, 0},
                    [34] = {-90, 0, 0},
                    [35] = {-10, 0, 0},
                },
                
                onDuck = {
                    [32] = {-90, -30, -10},
                    [33] = {0, -90, 0},
                    [34] = {-95, 30, 0},
                    [35] = {-10, 0, 0},
                },
                Object = {
                    Model = 325,
                    Offset = {34, 0.03,0.07,-0.06,-180,3.6,-18},
                    Scale = 0.9,
                },
            },
            ['Segurar guarda chuvas'] = {
                BonesRotation = {
                    [32] = {30, -20, 60},
                    [33] = {0, -90, 0},
                    [34] = {-80, -30, 0},
                    [35] = {-30, 0, 0},
                },
                onDuck = {
                    [32] = {30, -20, 10},
                    [33] = {0, -80, -80},
                    [34] = {-90, -30, 0},
                    [35] = {-30, 0, 0},
                },
                Object = {
                    Model = 14864,
                    Offset = {34, 0.05, 0.03, 0.05, 0, -210, 30},
                    Scale = 0.9,
                },
    
                blockJump = true,
                blockVehicle = true,
            },
            ['Segurar prancha'] = {
                BonesRotation = {
                    [32] = {30, -20, 40},
                    [33] = {0, -60, 30},
                    [34] = {-130, 0, 0}
                },
                Object = {
                    Model = 2404,
                    Offset = {33, 0.19,-0.07,0.01,39.6,7.2,-3.6},
                    Scale = 0.7,
                },
                blockDuck = true,
                blockJump = true,
                blockVehicle = true,
            },
            ['Segurando caixa'] = {
                BonesRotation = {
                    [22] = {60, -30, -70},
                    [23] = {-10, -70, -50},
                    [24] = {160, 0, 0},
                    [25] = {0, -10, 0},
                    [32] = {-60, -40, 70},
                    [33] = {10, -70, 50},
                    [34] = {-160, 0, 0},
                    [35] = {0, -10, 0},
                    [201] = {0, 0, 0},
                },
    
                onDuck = {
                    [22] = {60, -30, 0},
                    [23] = {-10, -70, -50},
                    [24] = {160, 0, 0},
                    [25] = {0, -10, 0},
                    [32] = {-60, -40, 0},
                    [33] = {10, -70, 50},
                    [34] = {-160, 0, 0},
                    [35] = {0, -10, 0},
                    [201] = {0, 0, 0},
                },
                Object = {
                    Model = 2912,
                    Offset = {24, 0.13,0.34,-0.21,28.8,0,-3.6},
                    Scale = 0.5,
                },
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
            },
            ['Assobiar'] = {
                BonesRotation = {
                    [32] = {-90, -70, 0},
                    [33] = {10, 30, 125},
                },
                Sound = {
                    File = 'assobio',
                    MaxDistance = 50,
                },
            },
        },
        ['Interações'] = {
            ['Triste'] = {
                BonesRotation = {
                    [5] = {0, 20, 0}
                }
            },
            ['Pensativo 2'] = {
                BonesRotation = {
                    [5] = {0, 8, 0},
                    [32] = {0, -110, 25},
                    [33] = {0, -100, 0},
                    [22] = {60, -95, -30},
                    [23] = {8, -135, 8}
                },
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
            },
            ['Santo'] = {
                BonesRotation = {
                    [32] = {0, -60, 60},
                    [33] = {0, -60, 20},
                    [34] = {-100, 0, 0},
                    [22] = {0, -40, -60},
                    [23] = {0, -70, -30},
                },
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
                blockDuck = true,
            },
            ['Meditando'] = {
                BonesRotation = {
                    [22] = {30, -60, -45},
                    [23] = {20, -60, 40},
                    [24] = {-220, 0, 0},
                    [32] = {-30, -60, 45},
                    [33] = {20, -60, -40},
                    [34] = {-220, 0, 0},
                },
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
                blockDuck = true,
            },
        }
    },
    ifps = {
        "abdominal",
        "breakdance1",
        "breakdance2",
        "continencia",
        "flexao",
        "fortnite1",
        "fortnite2",
        "fortnite3",
        "newAnims",
        "render",
        "sex",
        "segurando",
    },
    
    Ossos = {
        0, 1, 2, 3, 4, 5, 6, 7, 8, 21,--NÃO MECHER
        22, 23, 24, 25, 26, 31, 32, 33,--NÃO MECHER
        34, 35, 36, 41, 42, 43, 44, 51, --NÃO MECHER
        52, 53, 54, 201, 301, 302 --NÃO MECHER
    },
}

formatNumber = function(number)   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
end 

notifyS = function(player, message, type)
    exports["crp_notify"]:addBox(player, message, type)
end

notifyC = function(message, type)
    triggerEvent('addBox', localPlayer, message, type)
end

function removeHex(message)
	if (type(message) == "string") then
		while (message ~= message:gsub("#%x%x%x%x%x%x", "")) do
			message = message:gsub("#%x%x%x%x%x%x", "")
		end
	end
	return message or false
end

function puxarNome(player)
    return removeHex(getPlayerName(player))
end

function puxarID(player)
    return (getElementData(player, "ID") or 0)
end