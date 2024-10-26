

txd = engineLoadTXD ( "Banco.txd" ) --Coloque o nome do TXD
engineImportTXD ( txd, 6364 ) --Coloque o ID do objeto que você quer modificar
col = engineLoadCOL ( "Banco.col" ) --Coloque o nome do arquivo COL
engineReplaceCOL ( col, 6364 ) --Coloque o ID do objeto que você quer modificar
dff = engineLoadDFF ( "Banco.dff", 0 ) --Coloque o nome do DFF e não mexa nesse 0
engineReplaceModel ( dff, 6364,true ) --Coloque o ID do objeto que você quer modificar
engineSetModelLODDistance(6364, 5000) --ID do objeto e a distância que ele irá carregar - distancia está como 300
setOcclusionsEnabled( false )