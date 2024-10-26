-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
    txd = engineLoadTXD ( "bg.txd" ) --Coloque o nome do TXD
    engineImportTXD ( txd, 321 ) --Coloque o ID do objeto que você quer modificar
    col = engineLoadCOL ( "burguer.col" ) --Coloque o nome do arquivo COL
    engineReplaceCOL ( col, 321 ) --Coloque o ID do objeto que você quer modificar
    dff = engineLoadDFF ( "burguer.dff", 0 ) --Coloque o nome do DFF e não mexa nesse 0
    engineReplaceModel ( dff, 321 ) --Coloque o ID do objeto que você quer modificar

end)
