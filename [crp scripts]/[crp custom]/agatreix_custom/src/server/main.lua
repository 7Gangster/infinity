---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- MYSQL
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Connection = dbConnect( 'sqlite', 'src/assets/database.db')
dbExec(Connection, 'CREATE TABLE IF NOT EXISTS zn_clothes (id, tipo, clothes, txd, id2)')
dbExec(Connection, 'CREATE TABLE IF NOT EXISTS zn_clothes_policia (id, tipo, clothes, txd, id2)')
dbExec(Connection, 'CREATE TABLE IF NOT EXISTS zn_clothes_hospital (id, tipo, clothes, txd, id2)')
dbExec(Connection, 'CREATE TABLE IF NOT EXISTS zn_clothes_fem (id, tipo, clothes, txd, id2)')
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- LOAD
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function getRoupas(id, tipo)
    local roupas = {}
    local pele = 1
    if tipo == 7 then 
        local sqlrp = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ?", id), -1)
        if sqlrp or #sqlrp > 0 then 
            for i,v in ipairs(sqlrp) do 
                table.insert(roupas, {v['tipo'], v['clothes'], v['txd']})
                if v['tipo'] == 'corpo' then 
                    pele = v['txd']
                end
            end
        end
    elseif tipo == 280 or tipo == 281 or tipo == 282 or tipo == 283 or tipo == 284 then 
        local sqlrp = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_policia WHERE id = ?", id), -1)
        if sqlrp or #sqlrp > 0 then 
            for i,v in ipairs(sqlrp) do 
                table.insert(roupas, {v['tipo'], v['clothes'], v['txd']})
                if v['tipo'] == 'corpo' then 
                    pele = v['txd']
                end
            end
        end
    elseif tipo == 9 then 
        local sqlrp = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_fem WHERE id = ?", id), -1)
        if sqlrp or  #sqlrp > 0 then 
            for i,v in ipairs(sqlrp) do 
                table.insert(roupas, {v['tipo'], v['clothes'], v['txd']})
                if v['tipo'] == 'corpo' then 
                    pele = v['txd']
                end
            end
        end
    elseif tipo == 285 then 
        local sqlrp = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_hospital WHERE id = ?", id), -1)
        if sqlrp or #sqlrp > 0 then 
            for i,v in ipairs(sqlrp) do 
                table.insert(roupas, {v['tipo'], v['clothes'], v['txd']})
                if v['tipo'] == 'corpo' then 
                    pele = v['txd']
                end
            end
        end
    end
    return roupas, pele
end

local tableclothes =
{
 {"calca"},
 {"camisa"},
 {"chapeu"},
 {"coldre"},
 {"colete"},
 {"embed"},
 {"boina"},
 {"bracal"},
 {"cinto"},
 {"capacete"},
 {"distintivo"},
 {"cracha"},
 {"casaco"},
 {"gravata"},
 {"acessorios"},
 {"fone"},
 {"oculos"},
 {"tenis"},
}



function setroupapm(player, skin, roupas)
    local id = getElementData(player, 'ID')
    if not id then return end
    if skin == 280 or skin == 281 or skin == 282 or skin == 283 or skin == 284 then 

        local ctable = getClothesTable()
        local result = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_policia WHERE id = ?", id), -1)
        if #result > 0 then 
            for i,v in ipairs(roupas) do 
                dbExec(Connection, 'UPDATE zn_clothes_policia SET clothes = ?, txd = ? WHERE id = ? AND tipo = ?', v[2], v[3], getElementData(player, 'ID'), v[1])
            end
        else
            for i,v in ipairs(tableclothes) do 
                dbExec(Connection, 'INSERT INTO zn_clothes_policia VALUES (?, ?, ?, ?, ?)', getElementData(player, 'ID'), v[1], 0, 0, countIDs())
            end
            for i,v in ipairs(roupas) do 
                dbExec(Connection, 'UPDATE zn_clothes_policia SET clothes = ?, txd = ? WHERE id = ? AND tipo = ?', v[2], v[3], getElementData(player, 'ID'), v[1])
            end
        end
        setElementModel(player, skin)

        for variavel, _ in pairs(ctable[getElementModel(player)])do
            triggerClientEvent(root, "clearShaderClothe", root, player, getElementModel(player), variavel)
        end

        local sqlrp = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ?", id), -1)
        local result2 = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ? AND tipo = ?", id, 'corpo'), -1)
        local pele = result2[1].txd
        if sqlrp then
            for _2, rowrps in ipairs(sqlrp) do
                if rowrps["tipo"] == "rosto" then
                    triggerClientEvent(root, "setPlayerRoupa", root, player, "rosto", rowrps["clothes"], rowrps["txd"])
                end

                if rowrps["tipo"] == "cabelo" then
                    triggerClientEvent(root, "setPlayerRoupa", root, player, "cabelo", rowrps["clothes"], rowrps["txd"])
                end

                if rowrps["tipo"] == "barba" then
                    triggerClientEvent(root, "setPlayerRoupa", root, player, "barba", rowrps["clothes"], rowrps["txd"])
                end

                if rowrps["tipo"] == "sobrancelha" then
                    triggerClientEvent(root, "setPlayerRoupa", root, player, "sobrancelha", rowrps["clothes"], rowrps["txd"])
                end

            end
        end

        triggerClientEvent(root, "setPlayerRoupa", root, player, "braco", 1, pele)

        local sqlrp2 = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_policia WHERE id = ?", id), -1)
        if sqlrp2 then
            for _2, rowrps in ipairs(sqlrp2) do
                if tonumber(rowrps["clothes"]) > 0 then
                    if rowrps['tipo'] == "boina" or rowrps['tipo'] == "chapeu" or rowrps['tipo'] == "capacete" then
                        triggerClientEvent(root, "setPlayerRoupa", root, player, "cabelo", 0, 0)
                        triggerClientEvent(root, "setPlayerRoupa", root, player, rowrps['tipo'], rowrps['clothes'], rowrps['txd'])
                    end
                    triggerClientEvent(root, "setPlayerRoupa", root, player, rowrps['tipo'], rowrps['clothes'], rowrps['txd'])
                end
            end
        end
    elseif skin == 285 then 
        local ctable = getClothesTable()
        local result = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_hospital WHERE id = ?", id), -1)
        if #result > 0 then 
            for i,v in ipairs(roupas) do 
                dbExec(Connection, 'UPDATE zn_clothes_hospital SET clothes = ?, txd = ? WHERE id = ? AND tipo = ?', v[2], v[3], getElementData(player, 'ID'), v[1])
            end
        else
            for i,v in ipairs(tableclothes) do 
                dbExec(Connection, 'INSERT INTO zn_clothes_hospital VALUES (?, ?, ?, ?, ?)', getElementData(player, 'ID'), v[1], 0, 0, countIDs3())
            end
            for i,v in ipairs(roupas) do 
                dbExec(Connection, 'UPDATE zn_clothes_hospital SET clothes = ?, txd = ? WHERE id = ? AND tipo = ?', v[2], v[3], getElementData(player, 'ID'), v[1])
            end
        end
        setElementModel(player, skin)

        for variavel, _ in pairs(ctable[getElementModel(player)])do
            triggerClientEvent(root, "clearShaderClothe", root, player, getElementModel(player), variavel)
        end

        local sqlrp = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ?", id), -1)
        local result2 = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ? AND tipo = ?", id, 'corpo'), -1)
        local pele = result2[1].txd
        if sqlrp then
            for _2, rowrps in ipairs(sqlrp) do
                if rowrps["tipo"] == "rosto" then
                    triggerClientEvent(root, "setPlayerRoupa", root, player, "rosto", rowrps["clothes"], rowrps["txd"])
                end

                if rowrps["tipo"] == "cabelo" then
                    triggerClientEvent(root, "setPlayerRoupa", root, player, "cabelo", rowrps["clothes"], rowrps["txd"])
                end

                if rowrps["tipo"] == "barba" then
                    triggerClientEvent(root, "setPlayerRoupa", root, player, "barba", rowrps["clothes"], rowrps["txd"])
                end

                if rowrps["tipo"] == "sobrancelha" then
                    triggerClientEvent(root, "setPlayerRoupa", root, player, "sobrancelha", rowrps["clothes"], rowrps["txd"])
                end

            end
        end

        triggerClientEvent(root, "setPlayerRoupa", root, player, "braco", 1, pele)

        local sqlrp2 = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_hospital WHERE id = ?", id), -1)
        if sqlrp2 then
            for _2, rowrps in ipairs(sqlrp2) do
                if tonumber(rowrps["clothes"]) > 0 then
                    if rowrps['tipo'] == "boina" or rowrps['tipo'] == "chapeu" or rowrps['tipo'] == "capacete" then
                        triggerClientEvent(root, "setPlayerRoupa", root, player, "cabelo", 0, 0)
                        triggerClientEvent(root, "setPlayerRoupa", root, player, rowrps['tipo'], rowrps['clothes'], rowrps['txd'])
                    end
                    triggerClientEvent(root, "setPlayerRoupa", root, player, rowrps['tipo'], rowrps['clothes'], rowrps['txd'])
                end
            end
        end
    end
end

function setroupa(player, skin, tipo, clothe, textura)
    local clothe, textura = tonumber(clothe), tonumber(textura)
    local id = getElementData(player, 'ID')
    if not id then return end
    if skin == 7 then 
        local result = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ? AND tipo = ?", id, tipo), -1)
        local result2 = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ? AND tipo = ?", id, 'corpo'), -1)
        local pele = result2[1].txd
        if #result > 0 then 
            dbExec(Connection, 'UPDATE zn_clothes SET clothes = ?, txd = ? WHERE id = ? AND tipo = ?', clothe, textura, id, tipo)
        else
            dbExec(Connection, 'INSERT INTO zn_clothes VALUES (?, ?, ?, ?, ?)', id, tipo, clothe, textura, countIDs2())
        end
        local txd = tipo
        if tipo == 'camisa' then 
            txd = 'camisas'
            if clothe > 1 then --[[
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'corpo', 0, pele)
                dbExec(Connection, 'UPDATE zn_clothes SET clothes = ? WHERE id = ? AND tipo = ?', 0, id, 'corpo')
                if clothe == 5 then 
                    triggerClientEvent(root, 'setPlayerRoupa', root, player, 'braco', 2, pele)
                    dbExec(Connection, 'UPDATE zn_clothes SET clothes = ? WHERE id = ? AND tipo = ?', 2, id, 'braco')
                elseif clothe == 2 then 
                    triggerClientEvent(root, 'setPlayerRoupa', root, player, 'braco', 3, pele)
                    dbExec(Connection, 'UPDATE zn_clothes SET clothes = ? WHERE id = ? AND tipo = ?', 3, id, 'braco')
                elseif clothe == 3 then 
                    triggerClientEvent(root, 'setPlayerRoupa', root, player, 'braco', 2, pele)
                    dbExec(Connection, 'UPDATE zn_clothes SET clothes = ? WHERE id = ? AND tipo = ?', 2, id, 'braco')
                elseif clothe == 7 then 
                    triggerClientEvent(root, 'setPlayerRoupa', root, player, 'braco', 3, pele)
                    dbExec(Connection, 'UPDATE zn_clothes SET clothes = ? WHERE id = ? AND tipo = ?', 3, id, 'braco')
                end]]
            else
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'corpo', 1, pele)
                dbExec(Connection, 'UPDATE zn_clothes SET clothes = ? WHERE id = ? AND tipo = ?', 1, id, 'corpo')
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'braco', 1, pele)
                dbExec(Connection, 'UPDATE zn_clothes SET clothes = ? WHERE id = ? AND tipo = ?', 1, id, 'braco')
            end
        elseif tipo == 'calca' then 
            txd = 'calcas'
            if clothe > 0 then
                if clothe ~= 6 and clothe ~= 4 and clothe ~= 3 then 
                    triggerClientEvent(root, 'setPlayerRoupa', root, player, 'pernas', 0, pele)
                    dbExec(Connection, 'UPDATE zn_clothes SET clothes = ? WHERE id = ? AND tipo = ?', 0, id, 'pernas')
                    triggerClientEvent(root, 'setPlayerRoupa', root, player, 'pe2', 1, pele)
                    dbExec(Connection, 'UPDATE zn_clothes SET clothes = ? WHERE id = ? AND tipo = ?', 1, id, 'pe2')
                else
                    triggerClientEvent(root, 'setPlayerRoupa', root, player, 'pernas', 2, pele)
                    dbExec(Connection, 'UPDATE zn_clothes SET clothes = ? WHERE id = ? AND tipo = ?', 2, id, 'pernas')
                end
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'cueca', 0, 0)
                local cueca = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ? AND tipo = ?", id, 'cueca'), -1)
                if #cueca > 0 then 
                    dbExec(Connection, 'UPDATE zn_clothes SET clothes = ? WHERE id = ? AND tipo = ?', 0, id, 'cueca')
                end
            else
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'pernas', 1, pele)
                dbExec(Connection, 'UPDATE zn_clothes SET clothes = ? WHERE id = ? AND tipo = ?', 1, id, 'pernas')
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'cueca', 1, 1)
                local cueca = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ? AND tipo = ?", id, 'cueca'), -1)
                if #cueca > 0 then 
                    dbExec(Connection, 'UPDATE zn_clothes SET clothes = ? WHERE id = ? AND tipo = ?', 1, id, 'cueca')
                else
                    dbExec(Connection, 'INSERT INTO zn_clothes VALUES (?, ?, ?, ?, ?)', id, 'cueca', 1, 1, countIDs2())
                end
            end
        elseif tipo == 'tenis' then 
            if clothe > 0 then
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'pe2', 0, pele)
                dbExec(Connection, 'UPDATE zn_clothes SET clothes = ? WHERE id = ? AND tipo = ?', 0, id, 'pe2')
            else
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'pe2', 1, pele)
                dbExec(Connection, 'UPDATE zn_clothes SET clothes = ? WHERE id = ? AND tipo = ?', 1, id, 'pe2')
            end
        elseif tipo == 'bone' then 
            if clothe > 0 then 
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'cabelo', 0, 0)
            else
                local cabelo = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ? AND tipo = ?", id, 'cabelo'), -1) 
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'cabelo', cabelo[1].clothes, cabelo[1].txd)
            end
        end
        triggerClientEvent(root, 'setPlayerRoupa', root, player, tipo, clothe, textura)
        
        --[[
        if arrumar[tonumber(getElementModel(player))][txd..'-'..clothe] then
            for i,v in pairs(arrumar[tonumber(getElementModel(player))][txd..'-'..clothe]) do 
                triggerClientEvent(root, 'setPlayerRoupa', root, player, i, v[1], pele)
                dbExec(Connection, 'UPDATE zn_clothes SET clothes = ? WHERE id = ? AND tipo = ?', v[1], id, i)
            end
        end]]
    elseif skin == 9 then 
        local result = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_fem WHERE id = ? AND tipo = ?", id, tipo), -1)
        local result2 = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_fem WHERE id = ? AND tipo = ?", id, 'corpo'), -1)
        local pele = result2[1].txd
        if #result > 0 then 
            dbExec(Connection, 'UPDATE zn_clothes_fem SET clothes = ?, txd = ? WHERE id = ? AND tipo = ?', clothe, textura, id, tipo)
        else
            dbExec(Connection, 'INSERT INTO zn_clothes_fem VALUES (?, ?, ?, ?, ?)', id, tipo, clothe, textura, countIDs2())
        end
        triggerClientEvent(root, 'setPlayerRoupa', root, player, tipo, clothe, textura)
        local txd = tipo
        if tipo == 'blusa' then 
            txd = 'camisas'
            if clothe == 3 then 
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'corpo', 0, 0)
            end
            if clothe == 0 then 
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'corpo', 1, pele)
                dbExec(Connection, 'UPDATE zn_clothes_fem SET clothes = ? WHERE id = ? AND tipo = ?', 1, id, 'corpo')
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'braco', 1, pele)
                dbExec(Connection, 'UPDATE zn_clothes_fem SET clothes = ? WHERE id = ? AND tipo = ?', 1, id, 'braco')
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'sutia', 1, 1)
                local cueca = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_fem WHERE id = ? AND tipo = ?", id, 'sutia'), -1)
                if #cueca > 0 then 
                    dbExec(Connection, 'UPDATE zn_clothes_fem SET clothes = ? WHERE id = ? AND tipo = ?', 1, id, 'sutia')
                else
                    dbExec(Connection, 'INSERT INTO zn_clothes_fem VALUES (?, ?, ?, ?, ?)', id, 'sutia', 1, 1, countIDs2())
                end
            end
        elseif tipo == 'calca' then 
            txd = 'calcas'
            if clothe == 0 then 
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'pernas', 1, pele)
                dbExec(Connection, 'UPDATE zn_clothes_fem SET clothes = ? WHERE id = ? AND tipo = ?', 1, id, 'pernas')
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'calcinha', 1, 1)
                local cueca = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_fem WHERE id = ? AND tipo = ?", id, 'calcinha'), -1)
                if #cueca > 0 then 
                    dbExec(Connection, 'UPDATE zn_clothes_fem SET clothes = ? WHERE id = ? AND tipo = ?', 1, id, 'calcinha')
                else
                    dbExec(Connection, 'INSERT INTO zn_clothes_fem VALUES (?, ?, ?, ?, ?)', id, 'calcinha', 1, 1, countIDs2())
                end
            end
        elseif tipo == 'bone' then 
            if clothe > 0 then 
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'cabelo', 0, 0)
            else
                local cabelo = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_fem WHERE id = ? AND tipo = ?", id, 'cabelo'), -1) 
                triggerClientEvent(root, 'setPlayerRoupa', root, player, 'cabelo', cabelo[1].clothes, cabelo[1].txd)
            end
        end 
        --[[
        if arrumar[tonumber(getElementModel(player))][txd..'-'..clothe] then
            for i,v in pairs(arrumar[tonumber(getElementModel(player))][txd..'-'..clothe]) do 
                triggerClientEvent(root, 'setPlayerRoupa', root, player, i, v[1], pele)
                dbExec(Connection, 'UPDATE zn_clothes_fem SET clothes = ? WHERE id = ? AND tipo = ?', v[1], id, i)
            end
        end ]]
    end
end

function loadroupasall(ply)
    for i, v in ipairs(getElementsByType("player")) do
        if getElementModel(v) == 7 then
            local sqlrp = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ?", tonumber(getElementData(v, "ID"))), -1)
            if sqlrp then
                for _2, rowrps in ipairs(sqlrp) do
                    if tonumber(rowrps["clothes"]) >= 1 then

                        if rowrps["tipo"] == "bone" then
                            if tonumber(rowrps["clothes"]) >= 1 then
                                triggerClientEvent(ply, "setPlayerRoupa", ply, v, "cabelo", "0", "0")
                            end
                        end

                        if rowrps['tipo'] == 'corpo' then 

                            setElementData(v, 'Pele', rowrps['txd'])

                        end

                        triggerClientEvent(ply, "setPlayerRoupa", ply, v, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                    end
                end
            end
        elseif getElementModel(v) == 280 or getElementModel(v) == 281 or getElementModel(v) == 282 or getElementModel(v) == 283 or getElementModel(v) == 284 then
            local sqlrp = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ?", tonumber(getElementData(v, "ID"))), -1)
            if sqlrp then
                for _2, rowrps in ipairs(sqlrp) do
                    if tonumber(rowrps["clothes"]) >= 1 then
                        if ""..rowrps["tipo"].."" == "rosto" then
                            txdccs = rowrps["txd"]
                            triggerClientEvent(ply, "setPlayerRoupa", ply, v, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                        end

                        if ""..rowrps["tipo"].."" == "cabelo" then
                            triggerClientEvent(ply, "setPlayerRoupa", ply, v, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                        end

                        if ""..rowrps["tipo"].."" == "barba" then
                            triggerClientEvent(ply, "setPlayerRoupa", ply, v, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                        end

                        if ""..rowrps["tipo"].."" == "sobrancelha" then
                            triggerClientEvent(ply, "setPlayerRoupa", ply, v, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                        end
                    end
                end
            end

            local sqlrp2 = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_policia WHERE id = ?", tonumber(getElementData(v, "ID"))), -1)
            local result2 = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ? AND tipo = ?", getElementData(v, "ID"), 'corpo'), -1)
            local pele = result2[1].txd
            if sqlrp2 then
                for _2, rowrps2 in ipairs(sqlrp2) do
                    if tonumber(rowrps2["clothes"]) >= 1 then
                        triggerClientEvent(ply, "setPlayerRoupa", ply, v, ""..rowrps2["tipo"].."", 0, 0)

                        if ""..rowrps2["tipo"].."" == "braco" then
                            triggerClientEvent(ply, "setPlayerRoupa", ply, v, ""..rowrps2["tipo"].."", ""..rowrps2["clothes"].."", ""..pele.."")
                        else
                            triggerClientEvent(ply, "setPlayerRoupa", ply, v, ""..rowrps2["tipo"].."", ""..rowrps2["clothes"].."", ""..rowrps2["txd"].."")
                        end

                        if ""..rowrps2["tipo"].."" == "chapeu" or ""..rowrps2["tipo"].."" == "boina" or ""..rowrps2["tipo"].."" == "capacete" then
                            if tonumber(rowrps2["clothes"]) >= 1 then
                                triggerClientEvent(ply, "setPlayerRoupa", ply, v, "cabelo", "0", "0")
                            end
                        end

                        if rowrps2['tipo'] == 'corpo' then 

                            setElementData(v, 'Pele', rowrps2['txd'])

                        end

                    end
                end
            end
            

        elseif getElementModel(v) == 285 then
            local sqlrp = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ?", tonumber(getElementData(v, "ID"))), -1)
            if sqlrp then
                for _2, rowrps in ipairs(sqlrp) do
                    if tonumber(rowrps["clothes"]) >= 1 then
                        if ""..rowrps["tipo"].."" == "rosto" then
                            txdccs = rowrps["txd"]
                            triggerClientEvent(ply, "setPlayerRoupa", ply, v, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                        end

                        if ""..rowrps["tipo"].."" == "cabelo" then
                            triggerClientEvent(ply, "setPlayerRoupa", ply, v, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                        end

                        if ""..rowrps["tipo"].."" == "barba" then
                            triggerClientEvent(ply, "setPlayerRoupa", ply, v, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                        end

                        if ""..rowrps["tipo"].."" == "sobrancelha" then
                            triggerClientEvent(ply, "setPlayerRoupa", ply, v, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                        end
                    end
                end
            end

            local sqlrp2 = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_hospital WHERE id = ?", tonumber(getElementData(v, "ID"))), -1)
            if sqlrp2 then
                for _2, rowrps2 in ipairs(sqlrp2) do
                    if tonumber(rowrps2["clothes"]) >= 1 then
                        triggerClientEvent(ply, "setPlayerRoupa", ply, v, ""..rowrps2["tipo"].."", 0, 0)
                        triggerClientEvent(ply, "setPlayerRoupa", ply, v, ""..rowrps2["tipo"].."", ""..rowrps2["clothes"].."", ""..rowrps2["txd"].."")
                    end

                    if rowrps2['tipo'] == 'corpo' then 

                        setElementData(v, 'Pele', rowrps2['txd'])

                    end
                end
            end

        elseif getElementModel(v) == 9 then
            local sqlrp = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_fem WHERE id = ?", tonumber(getElementData(v, "ID"))), -1)
            if sqlrp then
                for _2, rowrps in ipairs(sqlrp) do
                    if tonumber(rowrps["clothes"]) >= 1 then
                        triggerClientEvent(ply, "setPlayerRoupa", ply, v, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                        if rowrps['tipo'] == 'blusa' then 
                            if rowrps['clothes'] == 3 then 
                                triggerClientEvent(ply, 'setPlayerRoupa', ply, v, 'corpo', 0, 0)
                            end
                        end

                        if rowrps['tipo'] == 'corpo' then 

                            setElementData(v, 'Pele', rowrps['txd'])

                        end

                    end
                end
            end
        end
    end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- CLEAR
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function clearShaderClothe(ply, skin, variavel)
    triggerClientEvent(ply, "clearShaderClothe", ply, ply, skin, variavel)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- CLERAROUPAS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function clearroupas(ply, cmd)
    if ply and cmd then
        if getElementData(ply, "Admin") == true then
            for variavel, _ in pairs(roupas_categorias[getElementModel(ply)])do
                triggerClientEvent(root, "clearShaderClothe", root, ply, getElementModel(ply), variavel)
            end
        end
    end
end
addCommandHandler("clearroupas", clearroupas)

---

function clearroupase(ply)
    if ply then
        for variavel, _ in pairs(roupas_categorias[getElementModel(ply)])do
            triggerClientEvent(root, "clearShaderClothe", root, ply, getElementModel(ply), variavel)
        end
    end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- LOADROUPAS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function loadroupas(ply, cmd)
    if ply and cmd then
        if isObjectInACLGroup( 'user.'..getAccountName(getPlayerAccount(ply)), aclGetGroup( 'Admin' )) then
            if getElementModel(ply) == 7 then
                local sqlrp = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ?", getElementData(ply, "ID")), -1)
                if sqlrp then
                    for _2, rowrps in ipairs(sqlrp) do
                        if tonumber(rowrps["clothes"]) >= 1 then
                            if rowrps["tipo"] == "bone" then
                                if tonumber(rowrps["clothes"]) >= 1 then
                                    triggerClientEvent(root, "setPlayerRoupa", root, ply, "cabelo", "0", "0")
                                end
                            end

                            triggerClientEvent(root, "setPlayerRoupa", root, ply, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                        end
                    end
                end
            elseif getElementModel(ply) == 9 then
                local sqlrp = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_fem WHERE id = ?", getElementData(ply, "ID")), -1)
                if sqlrp then
                    for _2, rowrps in ipairs(sqlrp) do
                        if tonumber(rowrps["clothes"]) >= 1 then
                            triggerClientEvent(root, "setPlayerRoupa", root, ply, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                        end
                    end
                end
            end
        end
    end
end
addCommandHandler("loadroupas", loadroupas)

function onLogin(ply)
    local id = getElementData(ply, 'ID') or 0
    local result = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ?", tonumber(id)), -1)
    local result2 = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_fem WHERE id = ?", tonumber(id)), -1)
    if #result > 0 or #result2 > 0 then
        if #result > 0 then
            setElementModel(ply, 7)
        elseif #result2 > 0 then
            setElementModel(ply, 9)
        end
        setTimer(function()
            loadroupasall(ply)
            if tonumber(getElementModel(ply)) == 7 then
                local sqlrp = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ?", tonumber(id)), -1)
                if sqlrp then
                    for _2, rowrps in ipairs(sqlrp) do
                        if tonumber(rowrps["clothes"]) >= 1 then

                            if rowrps["tipo"] == "bone" then
                                triggerClientEvent(root, "setPlayerRoupa", root, ply, "cabelo", "0", "0")
                            end

                            triggerClientEvent(root, "setPlayerRoupa", root, ply, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")


                            setElementData(ply, rowrps["tipo"]..':Style', tonumber(rowrps["clothes"]))
                            setElementData(ply, rowrps["tipo"]..':Text', tonumber(rowrps["txd"]))
                        end
                    end
                end
            elseif tonumber(getElementModel(ply)) == 280 or tonumber(getElementModel(ply)) == 281 or tonumber(getElementModel(ply)) == 282 or tonumber(getElementModel(ply)) == 283 or tonumber(getElementModel(ply)) == 284 then

                local sqlrp = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ?", tonumber(id)), -1)
                if sqlrp then
                    for _2, rowrps in ipairs(sqlrp) do
                        if tonumber(rowrps["clothes"]) >= 1 then
                            if ""..rowrps["tipo"].."" == "rosto" then
                                txdccs = rowrps["txd"]
                                triggerClientEvent(root, "setPlayerRoupa", root, ply, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                            end

                            if ""..rowrps["tipo"].."" == "cabelo" then
                                triggerClientEvent(root, "setPlayerRoupa", root, ply, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                            end

                            if ""..rowrps["tipo"].."" == "barba" then
                                triggerClientEvent(root, "setPlayerRoupa", root, ply, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                            end

                            if ""..rowrps["tipo"].."" == "sobrancelha" then
                                triggerClientEvent(root, "setPlayerRoupa", root, ply, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                            end
                        end
                    end
                end

                local sqlrp2 = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_policia WHERE id = ?", tonumber(id)), -1)
                if sqlrp2 then
                    for _2, rowrps2 in ipairs(sqlrp2) do
                        if tonumber(rowrps2["clothes"]) >= 1 then

                            triggerClientEvent(root, "setPlayerRoupa", root, ply, ""..rowrps2["tipo"].."", 0, 0)

                            if ""..rowrps2["tipo"].."" == "braco" then
                                triggerClientEvent(root, "setPlayerRoupa", root, ply, ""..rowrps2["tipo"].."", ""..rowrps2["clothes"].."", ""..rowrps2["txd"].."")
                            else
                                triggerClientEvent(root, "setPlayerRoupa", root, ply, ""..rowrps2["tipo"].."", ""..rowrps2["clothes"].."", ""..rowrps2["txd"].."")
                            end

                            if ""..rowrps2["tipo"].."" == "chapeu" or ""..rowrps2["tipo"].."" == "boina" or ""..rowrps2["tipo"].."" == "capacete" then
                                if tonumber(rowrps2["clothes"]) >= 1 then
                                    triggerClientEvent(root, "setPlayerRoupa", root, ply, "cabelo", "0", "0")
                                end
                            end

                        end
                    end
                end

            elseif tonumber(getElementModel(ply)) == 285 then

                local sqlrp = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes WHERE id = ?", tonumber(id)), -1)
                if sqlrp then
                    for _2, rowrps in ipairs(sqlrp) do
                        if tonumber(rowrps["clothes"]) >= 1 then
                            if ""..rowrps["tipo"].."" == "rosto" then
                                txdccs = rowrps["txd"]
                                triggerClientEvent(root, "setPlayerRoupa", root, ply, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                            end

                            if ""..rowrps["tipo"].."" == "cabelo" then
                                triggerClientEvent(root, "setPlayerRoupa", root, ply, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                            end

                            if ""..rowrps["tipo"].."" == "barba" then
                                triggerClientEvent(root, "setPlayerRoupa", root, ply, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                            end

                            if ""..rowrps["tipo"].."" == "sobrancelha" then
                                triggerClientEvent(root, "setPlayerRoupa", root, ply, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")
                            end
                        end
                    end
                end

                local sqlrp2 = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_hospital WHERE id = ?", tonumber(id)), -1)
                if sqlrp2 then
                    for _2, rowrps2 in ipairs(sqlrp2) do
                        if tonumber(rowrps2["clothes"]) >= 1 then

                            triggerClientEvent(root, "setPlayerRoupa", root, ply, ""..rowrps2["tipo"].."", 0, 0)
                            triggerClientEvent(root, "setPlayerRoupa", root, ply, ""..rowrps2["tipo"].."", ""..rowrps2["clothes"].."", ""..rowrps2["txd"].."")

                        end
                    end
                end


            elseif tonumber(getElementModel(ply)) == 9 then
                local sqlrp = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_fem WHERE id = ?", tonumber(id)), -1)
                if sqlrp then
                    for _2, rowrps in ipairs(sqlrp) do
                        if tonumber(rowrps["clothes"]) >= 1 then
                            triggerClientEvent(root, "setPlayerRoupa", root, ply, ""..rowrps["tipo"].."", ""..rowrps["clothes"].."", ""..rowrps["txd"].."")

                            setElementData(ply, rowrps["tipo"]..':Style', tonumber(rowrps["clothes"]))
                            setElementData(ply, rowrps["tipo"]..':Text', tonumber(rowrps["txd"]))
                        end
                    end
                end
            end
        end, 500, 1)
    else
        triggerClientEvent(ply, 'openCreatePersonage', ply, getElementModel(ply))
    end
end

--[[
addEventHandler('onPlayerLogin', root, function()
    setTimer(function(player)
        onLogin(player)
    end, 500, 1, source)
end)]]

function resetRoupas(player)
    local roupas = {'camisa', 'calca', 'tenis', 'oculos', 'acessorios', 'bone', 'blusa', 'sandalia'}
    setTimer(function(player)
        for i,v in ipairs(roupas) do 
            setroupa(player, getElementModel(player), v, '0', '0')
        end
    end, 500, 1)
end

addEvent('SpawnPlayer', true)
addEventHandler('SpawnPlayer', root, function(player, gender, roupas, pele)
    for i,v in ipairs(roupas) do 
        if gender == 7 then
            dbExec(Connection, 'INSERT INTO zn_clothes VALUES (?, ?, ?, ?, ?)', getElementData(player, 'ID'), v[1], v[2], v[3], countIDs2())
        elseif gender == 9 then 
            dbExec(Connection, 'INSERT INTO zn_clothes_fem VALUES (?, ?, ?, ?, ?)', getElementData(player, 'ID'), v[1], v[2], v[3], countIDs2())
        end
    end
    exports.crp_inventory:giveItem(player, 'dinheiro', 1000)
    setElementData(player, 'Banco', 3000)
    if getElementData(player, 'ID') <= 30 then 
    	exports.crp_inventory:giveItem(player, 'dinheiro', 3000)
        exports.crp_notify:addBox(player, 'Seu personagem foi premiado com $3000', 'success', 'Parabéns!')
    end
    setElementModel(player, gender)
    exports.crp_inventory:giveItem(player, 'identidade', 1)
    onLogin(player)
    setAccountData(getPlayerAccount( player ), 'skin', gender)
    triggerClientEvent(player, 'animation', player)
end)

addEventHandler('onResourceStart', resourceRoot, function()
    for i,v in ipairs(getElementsByType('player')) do 
        if not isGuestAccount(getPlayerAccount(v)) then
            setTimer(onLogin, 15000, 1, v)
        end
    end
end)

function countIDs2()
    local result2 = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes"), -1)
    newid2 = false
    for i2, id2 in pairs (result2) do
        if id2["id2"] ~= i2 then
            newid2 = i2
            break
        end
    end
    if newid2 then return newid2 else return #result2 + 1 end
end

function countIDs3()
    local result2 = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_hospital"), -1)
    newid2 = false
    for i2, id2 in pairs (result2) do
        if id2["id2"] ~= i2 then
            newid2 = i2
            break
        end
    end
    if newid2 then return newid2 else return #result2 + 1 end
end

function countIDs()
    local result2 = dbPoll(dbQuery(Connection, "SELECT * FROM zn_clothes_policia"), -1)
    newid2 = false
    for i2, id2 in pairs (result2) do
        if id2["id2"] ~= i2 then
            newid2 = i2
            break
        end
    end
    if newid2 then return newid2 else return #result2 + 1 end
end
