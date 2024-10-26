config = {
    notificationEvent = "addBox"; -- Evento da notificação.

    positions = { -- Posições.
        manager = { -- Posição {X, Y, Z} do Gerenciador.
            {1568.2840576172,-1686.3958740234,16.203125};
            {253.44236755371,76.559143066406,1003.640625, interior = 6}; -- Manager Complexo Militar
            {1208.9211425781,-1779.7945556641,13.6015625};
        };
    };


    organizations = { -- Organizações.

        ["Policial"] = { -- Policial Militar Estado de São Paulo
            acl = "Policial"; -- ACL da organização.

            windows = { -- Janelas.
                personages = { -- Fardamentos.
                    {
                        label = "Fardamento S/ Colete"; -- Nome do fardamento.
                        model = 280; -- Modelo do fardamento.
                        roupas = {
                            {'camisa', 2, 1},
                            {'calca', 1, 1},
                            {'coldre', 1, 1},
                            {'capacete', 0, 0},
                            {'colete', 0, 1},
                            {'tenis', 1, 1},
                            {'embed', 2, 1}
                        };
                    };
                    {
                        label = "Fardamento C/ Colete"; -- Nome do fardamento.
                        model = 280; -- Modelo do fardamento.
                        roupas = {
                            {'camisa', 2, 1},
                            {'calca', 1, 1},
                            {'capacete', 0, 0},
                            {'coldre', 1, 1},
                            {'colete', 1, 1},
                            {'tenis', 1, 1},
                            {'embed', 2, 1}
                        };
                    };
                    {
                        label = "Fardamento Teste"; -- Nome do fardamento.
                        model = 283; -- Modelo do fardamento.
                        roupas = {
                            {'camisa', 1, 1},
                            {'calca', 1, 1},
                            {'coldre', 1, 1},
                            {'distintivo', 1, 1},
                            {'tenis', 1, 1},
                            {'fone', 1, 1},
                            {'oculos', 1, 1}
                        };
                    };
                    {
                        label = "Fardamento GTM"; -- Nome do fardamento.
                        model = 282; -- Modelo do fardamento.
                        roupas = {
                            {'capacete', 1, 1},
                            {'camisa', 1, 1},
                            {'calca', 1, 1},
                            {'coldre', 1, 1},
                            --{'colete', 1, 1},
                            {'tenis', 1, 1},
                            {'embed', 1, 1},
                            {'bracal', 0, 0},
                        };
                    };
                };
            };
        };
        ["Paramedico"] = { -- Policial Militar Estado de São Paulo
            acl = "Paramedic"; -- ACL da organização.

            windows = { -- Janelas.
                personages = { -- Fardamentos.
                    {
                        label = "Paramedico"; -- Nome do fardamento.
                        model = 285; -- Modelo do fardamento.
                        roupas = {
                            {'camisa', 4, 1},
                            {'casaco', 0, 1},
                            {'calca', 1, 1},
                            {'acessorios', 1, 1},
                            {'tenis', 1, 1},
                        };
                    };
                    {
                        label = "Medico"; -- Nome do fardamento.
                        model = 285; -- Modelo do fardamento.
                        roupas = {
                            {'camisa', 1, 1},
                            {'casaco', 1, 1},
                            {'calca', 3, 1},
                            {'cracha', 1, 1},
                            {'acessorios', 1, 1},
                            {'tenis', 2, 1},
                        };
                    };
                    {
                        label = "Enfermeiro"; -- Nome do fardamento.
                        model = 285; -- Modelo do fardamento.
                        roupas = {
                            {'camisa', 3, 1},
                            {'casaco', 0, 1},
                            {'calca', 2, 1},
                            {'cracha', 2, 2},
                            {'acessorios', 1, 1},
                            {'tenis', 2, 1},
                        };
                    };
                };
            };
        };
    };
}