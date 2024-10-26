local screenW, screenH = guiGetScreenSize()
local fontMedium = dxCreateFont('public/fonts/medium.ttf', 10)
function drawFrequency ()
    if (getElementData(localPlayer, 'untoggled:hud')or false) then return end
    if (getElementData(localPlayer, RADIOCONFIG.GeralConfig.FrequencyKey)or false) then
                dxDrawText((getElementData(localPlayer, RADIOCONFIG.GeralConfig.ActiveKey)or false) and 'ATIVADO |'..' '..(getElementData(localPlayer, RADIOCONFIG.GeralConfig.FrequencyKey)or false)..'Hz' or 'DESATIVADO |'..' '..(getElementData(localPlayer, RADIOCONFIG.GeralConfig.FrequencyKey)or false)..'Hz', (screenW-140-5), screenH - 30, 175, 9, tocolor(255, 255, 255, 155), 1, fontMedium, 'left', 'top')
    end
end
addEventHandler('onClientRender', root, drawFrequency)

config = {}
config.Ossos = {
        0, 1, 2, 3, 4, 5, 6, 7, 8, 21,--NÃO MECHER
        22, 23, 24, 25, 26, 31, 32, 33,--NÃO MECHER
        34, 35, 36, 41, 42, 43, 44, 51, --NÃO MECHER
        52, 53, 54, 201, 301, 302 --NÃO MECHER
}

anim = {}
ossos = {}
indexPosition = {}
BonesRotation = {
    [5] = {0, 0, -30},
    [32] = {-30, -30, 50},
    [33] = {0, -160, 0},
    [34] = {-120, 0, 0}
},

addEventHandler('onClientPedsProcessed', root, function()
    for i,player in ipairs(anim) do 
        if player and isElement(player) then
            if isElementStreamedIn(player) then
                if ossos[player] and #ossos[player] > 0 then
                    for k, v in pairs(ossos[player]) do 
                        setElementBoneRotation(player, v[1], v[2], v[3], v[4])
                        updateElementRpHAnim(player)
                    end
                else
                    table.remove(anim, i)
                end
            end
        else
            table.remove(anim, i)
        end
    end
end)

function setAnimation(player)
    if not ossos[player] then 
        ossos[player] = {}
    end
    for i,v in pairs(BonesRotation) do 
        setElementBoneRotation(player, i, v[1], v[2], v[3])
        table.insert(ossos[player], {i, v[1], v[2], v[3], player})
        table.insert(anim, player)
        indexPosition[player] = #anim
    end
end
addEvent('setAnimRadinho', true)
addEventHandler('setAnimRadinho', root, setAnimation)

addEvent('stopAnimationRadinho', true)
addEventHandler('stopAnimationRadinho', root,
function(player)
    if ossos[player] and #ossos[player] > 0 then
        if indexPosition[player] then 
            table.remove(anim, indexPosition[player])
        end 
        ossos[player] = {}
        for i=1, #config.Ossos do 
            updateElementRpHAnim(player)
        end 
    end
end)

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        txd = engineLoadTXD ( "public/models/radio.txd" )
        engineImportTXD ( txd, 1429 )
        dff = engineLoadDFF ( "public/models/radio.dff" )
        engineReplaceModel ( dff, 1429 )
    end
)