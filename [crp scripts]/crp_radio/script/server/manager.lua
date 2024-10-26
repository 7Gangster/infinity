radinho = {}

function talkRadio (thePlayer)
    if (getElementData(thePlayer, RADIOCONFIG.GeralConfig.FrequencyKey)or false) then
        if (getElementData(thePlayer, RADIOCONFIG.GeralConfig.ActiveKey)or false) then
            setElementData(thePlayer, RADIOCONFIG.GeralConfig.ActiveKey, false)
        else
            setElementData(thePlayer, RADIOCONFIG.GeralConfig.ActiveKey, true)
        end
    end
end

function activeRadio (thePlayer, frequency)
    if frequency then
        setElementData(thePlayer, RADIOCONFIG.GeralConfig.FrequencyKey, tonumber(frequency))
        bindKey(thePlayer, RADIOCONFIG.GeralConfig.keyActive, 'down', talkRadio)
        RADIOCONFIG.messageServer(thePlayer, 'Você entrou na frequência '..frequency..'Hz.', 'success')
    else
        unbindKey(thePlayer, RADIOCONFIG.GeralConfig.keyActive, 'down', talkRadio)
        setElementData(thePlayer, RADIOCONFIG.GeralConfig.FrequencyKey, false)
        setElementData(thePlayer, RADIOCONFIG.GeralConfig.ActiveKey, false)
        RADIOCONFIG.messageServer(thePlayer, 'Você saiu do rádio', 'info')
        if radinho[thePlayer] then 
            destroyElement(radinho[thePlayer])
            radinho[thePlayer] = nil
        end
    end
end
addEvent('crp:radinho', true)
addEventHandler('crp:radinho', root, activeRadio)

-- function radiof (thePlayer, theCommand, theFrequency)
--     if radinho[thePlayer] then
--         if theFrequency and tonumber(theFrequency) ~= (getElementData(thePlayer, RADIOCONFIG.GeralConfig.FrequencyKey)or false) then
--             if tonumber(theFrequency) > 0 and tonumber(theFrequency) <= RADIOCONFIG.GeralConfig.MaxFrequency then
--                 setElementData(thePlayer, RADIOCONFIG.GeralConfig.FrequencyKey, tonumber(theFrequency))
--                 activeRadio(thePlayer, theFrequency)
--                 RADIOCONFIG.messageServer(thePlayer, 'Você entrou na frequencia '..theFrequency, 'success')
--             else
--                 RADIOCONFIG.messageServer(thePlayer, 'Coloque uma frequência maior que 0 e abaixo ou igual à '..RADIOCONFIG.GeralConfig.MaxFrequency, 'success')
--             end
--         else
--             RADIOCONFIG.messageServer(thePlayer, 'Você já está nessa frequencia', 'error')
--         end
--     else
--         RADIOCONFIG.messageServer(thePlayer, 'Equipe o radio para trocar a frequencia.', 'error')
--     end
-- end
-- addCommandHandler('radiof', radiof)

--[[
function deactivateRadio (thePlayer, theCommand)
    if (getElementData(thePlayer, RADIOCONFIG.GeralConfig.FrequencyKey)or false) then
        unbindKey(thePlayer, RADIOCONFIG.GeralConfig.keyActive, 'down', talkRadio)
        setElementData(thePlayer, RADIOCONFIG.GeralConfig.FrequencyKey, false)
        setElementData(thePlayer, RADIOCONFIG.GeralConfig.ActiveKey, false)
        RADIOCONFIG.messageServer(thePlayer, 'Você saiu do rádio', 'info')
        if radinho[thePlayer] then 
            destroyElement(radinho[thePlayer])
            radinho[thePlayer] = nil
        end
    end
end
addCommandHandler('radiod', deactivateRadio)]]

function setPedOpening(player, state)
    if state then
        if not radinho[player] then
            radinho[player] = {} 
        end
        radinho[player] = createObject( 1429, unpack({getElementPosition(player)}))
        exports.pAttach:attach(radinho[player], player, 24, 0.08,0.07,0.13,180,-90,-7.2)
        setPedAnimation(player, "ped", "phone_in", 0, true, false, false)
        setTimer(setPedAnimationProgress, 100, 1, player, "phone_in", 1.16)
        setTimer(setPedAnimationSpeed, 1500, 1, player, "phone_in", 0)
    else
        setPedAnimation(player, "ped", "phone_out", 0, true, false, false)
        setTimer(setPedAnimationProgress, 100, 1, player, "phone_out", 1.16)
        setTimer(setPedAnimationSpeed, 1500, 1, player, "phone_out", 0)
        setTimer(setPedAnimation, 1600, 1, player)
        if radinho[player] then 
            setTimer(destroyElement, 1600, 1, radinho[player])
        end
    end
end
addEvent('crp:setPedOpening', true)
addEventHandler('crp:setPedOpening', root, setPedOpening)

function disconnectAll ()
    for i,v in pairs(getElementsByType('player')) do
        unbindKey(v, RADIOCONFIG.GeralConfig.keyActive, 'down', talkRadio)
        if (getElementData(v, RADIOCONFIG.GeralConfig.FrequencyKey)or false) then
            setElementData(v, RADIOCONFIG.GeralConfig.FrequencyKey, false)
        end
        if (getElementData(v, RADIOCONFIG.GeralConfig.ActiveKey)or false) then
            setElementData(v, RADIOCONFIG.GeralConfig.ActiveKey, false)
        end
    end
end
addEventHandler('onResourceStart', resourceRoot, disconnectAll)

addEventHandler('onPlayerQuit', root, function()
    if radinho[source] then 
        destroyElement(radinho[source])
        radinho[source] = nil
    end
end)