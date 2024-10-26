---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- CFG
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

cfg = {}

cfg.veiculos =
{
 {"files/veiculos/caminhao.dff", "files/veiculos/caminhao.txd", 609},
 {"files/veiculos/gb.dff", "files/veiculos/gb.txd", 496},
 {"files/veiculos/Brioso.dff", "files/veiculos/Brioso.txd", 589},
 {"files/veiculos/panto.dff", "files/veiculos/panto.txd", 545},
 {"files/veiculos/futo.dff", "files/veiculos/futo.txd", 527},
 {"files/veiculos/sabre.dff", "files/veiculos/sabre.txd", 475},
 {"files/veiculos/glautent.dff", "files/veiculos/glautent.txd", 542},
 {"files/veiculos/burrito.dff", "files/veiculos/burrito.txd", 482},
 {"files/veiculos/baller.dff", "files/veiculos/baller.txd", 579},
 {"files/veiculos/felon.dff", "files/veiculos/felon.txd", 492},
 {"files/veiculos/voodo.dff", "files/veiculos/voodo.txd", 412},
 {"files/veiculos/faction.dff", "files/veiculos/faction.txd", 534},
 {"files/veiculos/chino.dff", "files/veiculos/chino.txd", 536},
 {"files/veiculos/moonbeam.dff", "files/veiculos/moonbeam.txd", 418},
 {"files/veiculos/buccaner.dff", "files/veiculos/buccaner.txd", 575},
 {"files/veiculos/buffalo.dff", "files/veiculos/buffalo.txd", 402},
 {"files/veiculos/comet.dff", "files/veiculos/comet.txd", 480},
 {"files/veiculos/9f.dff", "files/veiculos/9f.txd", 429},
 {"files/veiculos/jester.dff", "files/veiculos/jester.txd", 559},
 {"files/veiculos/sultan.dff", "files/veiculos/sultan.txd", 560},
 {"files/veiculos/r34.dff", "files/veiculos/r34.txd", 541},
 {"files/veiculos/r35.dff", "files/veiculos/r35.txd", 602},
 {"files/veiculos/meca.dff", "files/veiculos/meca.txd", 421},
 {"files/veiculos/supra.dff", "files/veiculos/supra.txd", 477},
 {"files/veiculos/slamvan.dff", "files/veiculos/slamvan.txd", 535},
 --{"files/veiculos/trash.dff", "files/veiculos/trash.txd", 408},
 {"files/veiculos/deluxe.dff", "files/veiculos/deluxe.txd", 498},
 
 --Motos
 {"files/veiculos/faggio.dff", "files/veiculos/faggio.txd", 462},
 {"files/veiculos/sanchez.dff", "files/veiculos/sanchez.txd", 468},
 {"files/veiculos/vader.dff", "files/veiculos/vader.txd", 581},
 {"files/veiculos/bati.dff", "files/veiculos/bati.txd", 521},
 {"files/veiculos/carbon.dff", "files/veiculos/carbon.txd", 522},
 {"files/veiculos/quad.dff", "files/veiculos/quad.txd", 471},
 {"files/veiculos/western.dff", "files/veiculos/western.txd", 463},


}

---

cfg.rodas =
{
{"files/wheels/1.dff", "files/wheels/0.txd", 1025},
{"files/wheels/2.dff", "files/wheels/0.txd", 1073},
{"files/wheels/3.dff", "files/wheels/0.txd", 1074},
{"files/wheels/4.dff", "files/wheels/0.txd", 1075},
{"files/wheels/5.dff", "files/wheels/0.txd", 1076},
{"files/wheels/6.dff", "files/wheels/0.txd", 1077},
{"files/wheels/7.dff", "files/wheels/0.txd", 1078},
{"files/wheels/8.dff", "files/wheels/0.txd", 1079},
{"files/wheels/9.dff", "files/wheels/0.txd", 1080},
{"files/wheels/10.dff", "files/wheels/0.txd", 1081},
{"files/wheels/11.dff", "files/wheels/0.txd", 1082},
{"files/wheels/12.dff", "files/wheels/0.txd", 1083},
{"files/wheels/13.dff", "files/wheels/0.txd", 1084},
{"files/wheels/14.dff", "files/wheels/0.txd", 1085},
{"files/wheels/15.dff", "files/wheels/0.txd", 1096},
{"files/wheels/16.dff", "files/wheels/0.txd", 1097},
{"files/wheels/17.dff", "files/wheels/0.txd", 1098},
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- DOWNLOAD - VEICULOS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function znstartdownload()
	for _,data in ipairs(cfg.veiculos) do
		if not fileExists(string.gsub(data[1], ".dff", "")..".fx") and not fileExists(string.gsub(data[2], ".txd", "").."2.fx") then
			downloadFile(data[1])
			downloadFile(data[2])
		else
			if not fileExists(string.gsub(data[2], ".txd", "")..".fx") then
				downloadFile(data[2])
				fileRename(data[2], string.gsub(data[2], ".txd", "")..".fx")
			end
			engineImportTXD(engineLoadTXD(string.gsub(data[2], ".txd", "")..".fx"), data[3])
			engineReplaceModel(engineLoadDFF(string.gsub(data[1], ".dff", "").."2.fx", 0), data[3])
			setTimer(function()
				fileDelete(string.gsub(data[2], ".txd", "")..".fx")
			end, 1000, 1)
		end
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), znstartdownload)

---

function zndownloadcomp(file)
	for _,data in ipairs(cfg.veiculos) do
		if file == data[1] or file == data[2] then
			if data[1] then
				fileRename(data[1], string.gsub(data[1], ".dff", "").."2.fx")
				fileRename(data[2], string.gsub(data[2], ".txd", "")..".fx")
				engineImportTXD(engineLoadTXD(string.gsub(data[2], ".txd", "")..".fx"), data[3])
				engineReplaceModel(engineLoadDFF(string.gsub(data[1], ".dff", "").."2.fx", 0), data[3])
				setTimer(function()
					fileDelete(string.gsub(data[2], ".txd", "")..".fx")
				end, 1000, 1)
			end
		end
	end
end
addEventHandler("onClientFileDownloadComplete", getResourceRootElement(getThisResource()), zndownloadcomp)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- DOWNLOAD - RODAS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[function znstartdownloadrodas()
	for _,data in ipairs(cfg.rodas) do
		print(data[1])
		if not fileExists(string.gsub(data[1], ".dff", "")..".fx") and not fileExists(string.gsub(data[2], ".txd", "").."2.fx") then
			downloadFile(data[1])
			downloadFile(data[2])
		else
			if not fileExists(string.gsub(data[2], ".txd", "")..".fx") then
				downloadFile(data[2])
				fileRename(data[2], string.gsub(data[2], ".txd", "")..".fx")
			end
			engineImportTXD(engineLoadTXD(string.gsub(data[2], ".txd", "")..".fx"), data[3])
			engineReplaceModel(engineLoadDFF(string.gsub(data[1], ".dff", "").."2.fx", 0), data[3])
		end
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), znstartdownloadrodas)

---

function zndownloadcomprodas(file)
	for _,data in ipairs(cfg.rodas) do
		if file == data[1] or file == data[2] then
			if data[1] then
				fileRename(data[1], string.gsub(data[1], ".dff", "").."2.fx")
				fileRename(data[2], string.gsub(data[2], ".txd", "")..".fx")
				engineImportTXD(engineLoadTXD(string.gsub(data[2], ".txd", "")..".fx"), data[3])
				engineReplaceModel(engineLoadDFF(string.gsub(data[1], ".dff", "").."2.fx", 0), data[3])
			end
		end
	end
end
addEventHandler("onClientFileDownloadComplete", getResourceRootElement(getThisResource()), zndownloadcomprodas)]]