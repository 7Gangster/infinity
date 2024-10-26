addEventHandler('onClientResourceStart', resourceRoot,
function()
local txd = engineLoadTXD('0.txd',true)
engineImportTXD(txd, 3976)
local dff = engineLoadDFF('0.dff', 0)
engineReplaceModel(dff, 3976)
local col = engineLoadCOL('0.col')
engineReplaceCOL(col, 3976)
engineSetModelLODDistance(3976, 99999)
end)

createBlip(1558.2991943359,-1676.0236816406,20.390434265137, 62)


function apagarScript()
    if fileExists("0.dff") then
        fileDelete("0.dff")
    end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), apagarScript)
addEventHandler("onClientPlayerQuit", getRootElement(), apagarScript)
addEventHandler("onClientPlayerJoin", getRootElement(), apagarScript)

function apagarScript()
    if fileExists("0.txd") then
        fileDelete("0.txd")
    end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), apagarScript)
addEventHandler("onClientPlayerQuit", getRootElement(), apagarScript)
addEventHandler("onClientPlayerJoin", getRootElement(), apagarScript)

function apagarScript()
    if fileExists("0.col") then
        fileDelete("0.col")
    end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), apagarScript)
addEventHandler("onClientPlayerQuit", getRootElement(), apagarScript)
addEventHandler("onClientPlayerJoin", getRootElement(), apagarScript)
