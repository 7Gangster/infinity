-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 

    txd = engineLoadTXD( 'models/crown.txd' ) 
    engineImportTXD( txd, 596 ) 
    dff = engineLoadDFF('models/crown.dff', 596) 
    engineReplaceModel( dff, 596 )

txd = engineLoadTXD( 'models/taurus.txd' ) 
engineImportTXD( txd, 598 ) 
dff = engineLoadDFF('models/taurus.dff', 598) 
engineReplaceModel( dff, 598 )

txd = engineLoadTXD( 'models/explorer.txd' ) 
engineImportTXD( txd, 490 ) 
dff = engineLoadDFF('models/explorer.dff', 490) 
engineReplaceModel( dff, 490 )

txd = engineLoadTXD( 'models/dodge.txd' ) 
engineImportTXD( txd, 597 ) 
dff = engineLoadDFF('models/dodge.dff', 597) 
engineReplaceModel( dff, 597 )

txd = engineLoadTXD( 'models/moto.txd' ) 
engineImportTXD( txd, 523 ) 
dff = engineLoadDFF('models/moto.dff', 523) 
engineReplaceModel( dff, 523 )

txd = engineLoadTXD( 'models/maverick.txd' ) 
engineImportTXD( txd, 497 ) 
dff = engineLoadDFF('models/maverick.dff', 497) 
engineReplaceModel( dff, 497 )

txd = engineLoadTXD( 'models/van.txd' ) 
engineImportTXD( txd, 427 ) 
dff = engineLoadDFF('models/van.dff', 427) 
engineReplaceModel( dff, 427 )

txd = engineLoadTXD( 'models/ambulance.txd' ) 
engineImportTXD( txd, 416 ) 
dff = engineLoadDFF('models/ambulance.dff', 416) 
engineReplaceModel( dff, 416 )

end)