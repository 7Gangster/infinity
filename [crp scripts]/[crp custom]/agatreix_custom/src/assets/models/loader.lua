function znimportcorpo()

	dff = engineLoadDFF("src/assets/models/male.dff", 7)
	txd = engineLoadTXD("src/assets/models/male.txd")
	engineImportTXD(txd, 7)
	engineReplaceModel(dff, 7)

	dffp = engineLoadDFF("src/assets/models/pm.dff", 280)
	txdp = engineLoadTXD("src/assets/models/pm.txd")
	engineImportTXD(txdp, 280)
	engineReplaceModel(dffp, 280)


	dffft = engineLoadDFF("src/assets/models/pmft.dff", 281)
	txdft = engineLoadTXD("src/assets/models/pmft.txd")
	engineImportTXD(txdft, 281)
	engineReplaceModel(dffft, 281)


	dffrm = engineLoadDFF("src/assets/models/pmrocam.dff", 282)
	txdrm = engineLoadTXD("src/assets/models/pmrocam.txd")
	engineImportTXD(txdrm, 282)
	engineReplaceModel(dffrm, 282)


	dffpc = engineLoadDFF("src/assets/models/pmpc.dff", 283)
	txdpc = engineLoadTXD("src/assets/models/pmpc.txd")
	engineImportTXD(txdpc, 283)
	engineReplaceModel(dffpc, 283)


	dffrt = engineLoadDFF("src/assets/models/pmrota.dff", 284)
	txdrt = engineLoadTXD("src/assets/models/pmrota.txd")
	engineImportTXD(txdrt, 284)
	engineReplaceModel(dffrt, 284)


	dffmed = engineLoadDFF("src/assets/models/med.dff", 285)
	txdmed = engineLoadTXD("src/assets/models/med.txd")
	engineImportTXD(txdmed, 285)
	engineReplaceModel(dffmed, 285)


	dfffem = engineLoadDFF("src/assets/models/female.dff", 9)
	txdem = engineLoadTXD("src/assets/models/female.txd")
	engineImportTXD(txdem, 9)
	engineReplaceModel(dfffem, 9)


end
addEventHandler("onClientResourceStart", resourceRoot, znimportcorpo)