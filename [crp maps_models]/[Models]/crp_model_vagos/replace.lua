txd = engineLoadTXD("gueto4.txd", 4850 )
engineImportTXD(txd, 4850)
dff = engineLoadDFF("gueto4.dff", 4850 )
engineReplaceModel(dff, 4850)
col = engineLoadCOL ( "gueto4.col" )
engineReplaceCOL ( col, 4850 )
engineSetModelLODDistance(4850, 5000) --ID do objeto e a distância que ele irá carregar - distancia está como 500
