txd = engineLoadTXD ( "digitalden.txd" ) --Coloque o nome do TXD
engineImportTXD ( txd, 6103 ) --Coloque o ID do objeto que voc� quer modificar
col = engineLoadCOL ( "1.col" ) --Coloque o nome do arquivo COL
engineReplaceCOL ( col, 6103 ) --Coloque o ID do objeto que voc� quer modificar
dff = engineLoadDFF ( "digitalden.dff", 0 ) --Coloque o nome do DFF e n�o mexa nesse 0
engineReplaceModel ( dff, 6103 ) --Coloque o ID do objeto que voc� quer modificar
engineSetModelLODDistance(6103, 500) --ID do objeto e a dist�ncia que ele ir� carregar - distancia est� como 500
