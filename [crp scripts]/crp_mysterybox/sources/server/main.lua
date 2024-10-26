openingMysteryBox = {}

addEventHandler("onResourceStart", resourceRoot,
function()
    if config["Mensagem Start"] then
        outputDebugString("["..getResourceName(getThisResource()).."] Startado com sucesso, qualquer bug contacte zJoaoFtw_#5562!")
    end
end)

addEvent("JOAO.openMysteryBox", true)
addEventHandler("JOAO.openMysteryBox", root,
function(player, typeMystery)
    if typeMystery then
        exports.crp_items:takeItem(player, typeMystery, 1)
        if not config["Mystery's"][typeMystery] then
            notifyS(player, "Esse tipo de caixa misteriosa não existe!", "error")
            return
        end
        if openingMysteryBox[player] then
            notifyS(player, "Você já está abrindo uma caixa misteriosa!", "error")
            return
        end
        openingMysteryBox[player] = true
        triggerClientEvent(player, "JOAO.openMysteryBox", player, typeMystery, lastCollect)
    end
end)




addEvent("JOAO.collectItem", true)
addEventHandler("JOAO.collectItem", root,
function(player, tableItem)
    if tableItem then
        openingMysteryBox[player] = false
        exports["crp_items"]:giveItem(player, tableItem[2], tableItem[3])
        --outputChatBox(" ", root, 255, 255, 255, false)
        --outputChatBox("#9B6FC7[BVR] #FFFFFFO jogador(a) "..puxarNome(player).." #"..puxarID(player).." acabou de achar um(a) "..string.upper(tableItem[1]).." em uma caixa misteriosa!", root, 255, 255, 255, true)
        --outputChatBox(" ", root, 255, 255, 255, false)
        lastCollect = puxarNome(player).."#818285#"..puxarID(player).." #C6C6C7ACABOU DE ACHAR UM(A) #FFFFFF"..string.upper(tableItem[1]).." #C6C6C7EM UMA CAIXA MISTERIOSA!"
    end
    --exports['[BVR]Util']:messageDiscord('O jogador '..puxarConta(player)..'('..puxarID(player)..') abriu uma caixa misteriosa e ganhou '..tableItem[1]..' ', 'https://discord.com/api/webhooks/1117152539780075721/YMaOmXW8up0HmzzhYR8hPXiBUsEKQLxj-ugvJzdXozBWyZwZG_kA4Oaigdpiiz59xEps')
end)