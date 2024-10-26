-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD ( "tvmenu.txd" ) --Coloque o nome do TXD
engineImportTXD ( txd, 1781 ) --Coloque o ID do objeto que você quer modificar
col = engineLoadCOL ( "tvmenu.col" ) --Coloque o nome do arquivo COL
engineReplaceCOL ( col, 1781) --Coloque o ID do objeto que você quer modificar
dff = engineLoadDFF ( "tvmenu.dff", 0 ) --Coloque o nome do DFF e não mexa nesse 0
engineReplaceModel ( dff, 1781 ) --Coloque o ID do objeto que você quer modificar
engineSetModelLODDistance(1781, 1000) --ID do objeto e a distância que ele irá carregar - distancia está como 500
end)
