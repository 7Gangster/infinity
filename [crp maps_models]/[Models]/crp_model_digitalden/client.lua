txd = engineLoadTXD ( "digitalden.txd" ) --Coloque o nome do TXD
engineImportTXD ( txd, 6103 ) --Coloque o ID do objeto que você quer modificar
col = engineLoadCOL ( "1.col" ) --Coloque o nome do arquivo COL
engineReplaceCOL ( col, 6103 ) --Coloque o ID do objeto que você quer modificar
dff = engineLoadDFF ( "digitalden.dff", 0 ) --Coloque o nome do DFF e não mexa nesse 0
engineReplaceModel ( dff, 6103 ) --Coloque o ID do objeto que você quer modificar
engineSetModelLODDistance(6103, 500) --ID do objeto e a distância que ele irá carregar - distancia está como 500
