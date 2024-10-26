

txd = engineLoadTXD ( "objeto/1502.txd" ) --Coloque o nome do TXD
engineImportTXD ( txd, 1502 ) --Coloque o ID do objeto que você quer modificar
col = engineLoadCOL ( "objeto/1502.col" ) --Coloque o nome do arquivo COL
engineReplaceCOL ( col, 1502 ) --Coloque o ID do objeto que você quer modificar
dff = engineLoadDFF ( "objeto/1502.dff", 0 ) --Coloque o nome do DFF e não mexa nesse 0
engineReplaceModel ( dff, 1502, true ) --Coloque o ID do objeto que você quer modificar
engineSetModelLODDistance(1502, 500) --ID do objeto e a distância que ele irá carregar - distancia está como 500



setOcclusionsEnabled( false )

