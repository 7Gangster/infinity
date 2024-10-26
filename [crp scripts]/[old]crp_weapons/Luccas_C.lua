---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- M4 INV
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

smarmas = {356, 355, 335, 336, 348, 353}
for i,v in pairs(smarmas) do
    txd = engineLoadTXD("files/nill.txd", v)
    engineImportTXD(txd, v)
    dff = engineLoadDFF("files/nill.dff", v)
    engineReplaceModel(dff, v)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- LOAD ARMAS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

armas =
{
 {"ak103", 3002},
 {"g36c", 3003},
 {"imbel", 2999},
 {"scar", 2998},
 {"faca", 2997},
 {"martelo", 2996},
 {"machado", 2995},
 {"garrafa", 2994},
 {"glock", 2992},
 {"taurus", 3100},
 {"frajuta", 346},
 {"microsmg", 3101},
 {"skorpion", 3102},
 {"mp5", 3103},
 {"shotgun", 349},
 {"winchester", 357},
 {"silenciadora", 3104},
 {"mira1", 3105},
 {"coronha", 3094},
 {"revolver", 1965},
 {"makita", 341},
 {"soqueira", 331},

}

---

for i,v in pairs(armas) do
    local model, objeto = unpack(v)
    if model == "mira1" or model == "coronha" then
        txd = engineLoadTXD("files/silenciadora.txd", objeto)
        engineImportTXD(txd, objeto)
        engineSetModelLODDistance(objeto, 90000000000)
    else
        txd = engineLoadTXD("files/"..model..".txd", objeto)
        engineImportTXD(txd, objeto)
        engineSetModelLODDistance(objeto, 90000000000)
    end
    dff = engineLoadDFF("files/"..model..".dff", objeto)
    engineReplaceModel(dff, objeto)
    engineSetModelLODDistance(objeto, 90000000000)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- ANIMAÇÃO PUXAR
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

engineLoadIFP("files/anim1.ifp", "weaponswitch")
engineLoadIFP("files/anim2.ifp", "weaponswitch2")

function znanimpuxararma(ply)
    setPedAnimation(ply, "weaponswitch", "weaponswitch", 500, false, false, false, false, 550, false)
end
addEvent("ZN-AnimPuxarArma", true)
addEventHandler("ZN-AnimPuxarArma", root, znanimpuxararma)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- VERIFICAR
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function verificararmas()
    if getElementData(localPlayer, "ZN-Logado") == true and getElementData(localPlayer, "ZN-EmComa") == false then
        for i,v in ipairs(cfg.armas) do
            if getElementData(localPlayer, ""..v[1].."-Equipada") == true then
                local Municao = getPedTotalAmmo(localPlayer, v[6])
                if (Municao == 0) then
                    setElementData(localPlayer, ""..v[1].."-Equipada", false)
                    setElementData(localPlayer, "Arma-Equipada", false)
                    triggerServerEvent("ZN-DestroyArma", localPlayer, localPlayer)
                end
            end
        end
    end
end
setTimer(verificararmas, 50, 0)