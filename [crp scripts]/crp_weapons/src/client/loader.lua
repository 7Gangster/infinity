

addEventHandler('onClientResourceStart', resourceRoot, function ( )

    for i,v in pairs(cfg.weapons) do 
        txd = engineLoadTXD("src/weapons/"..i..".txd", v.model)
        engineImportTXD(txd, v.model)
        dff = engineLoadDFF("src/weapons/"..i..".dff", v.model)
        engineReplaceModel(dff, v.model)
        engineSetModelLODDistance(v.model, 90000000000)
    end

end)