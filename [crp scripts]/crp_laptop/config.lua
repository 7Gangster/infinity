cfg = {
    crypto = {
        valorBase = 100,
        porcentagem = {1, 15}, -- Porcentagem que vai subir ou aumentar.
    },

    grupos = {

        [1] = {
            nome = 'Los Santos Police Department',
            lider = 'Comissario',
            cargos = {
                ['Cadete'] = {
                    rank = 1,
                    permissoes = {

                    },
                },   
                ['Oficial'] = {
                    rank = 2,
                    permissoes = {

                    },
                },   
                ['Detetive'] = {
                    rank = 3,
                    permissoes = {

                    },
                },   
                ['Sargento'] = {
                    rank = 4,
                    permissoes = {

                    },
                },   
                ['Capitão'] = {
                    rank = 5,
                    permissoes = {

                    },
                },   
                ['Comando'] = {
                    rank = 6,
                    permissoes = {
                        ['remover'] = true,
                        ['promover'] = true,
                        ['rebaixar'] = true,
                        ['convidar'] = true,
                    },
                },   
                ['Comissario'] = {
                    rank = 7,
                    permissoes = {
                        ['remover'] = true,
                        ['promover'] = true,
                        ['rebaixar'] = true,
                        ['convidar'] = true,
                    },
                },   
            },
        },
    },

}