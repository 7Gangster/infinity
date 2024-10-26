col = {}
ouvindo = {}
radinho = {}

if isVoiceEnabled() then
    addEventHandler('onPlayerVoiceStart', root, function()
        if not isGuestAccount(getPlayerAccount(source)) then

                if getElementData(source, "ZN-EmLigação") then return end
                falando = source
                setElementData(falando, 'char:falando', true)
                local position = {getElementPosition(falando)}
                col[falando] = createColSphere(position[1], position[2], position[3], (getElementData(source, 'char:voice') or 5))
                attachElements(col[falando], falando)
                ouvindo[falando] = getElementsWithinColShape(col[falando], "player")
                setPlayerVoiceBroadcastTo(falando, ouvindo[falando])

                addEventHandler('onColshapeHit', col[falando], function(element)
                    if getElementType(element) == 'player' then 
                        table.insert(ouvindo[falando], element)
                        setPlayerVoiceBroadcastTo(falando, ouvindo[falando])
                    end 
                end)

                addEventHandler('onColshapeLeave', col[falando], function(element)
                    if getElementType(element) == 'player' then 
                        for key, player in pairs(ouvindo[falando]) do
                            if (element == player) then
                                table.remove(ouvindo[falando], key)
                            end
                        end
                        setPlayerVoiceBroadcastTo(falando, ouvindo[falando])
                    end 
                end)

                if getElementData(source, 'Class.Frequency') and getElementData(source, 'Class.Active') == true then 
                    local freq = getElementData(source, 'Class.Frequency')
                    local escutando = {}
                    for i,v in ipairs(getElementsByType('player')) do 
                        if getElementData(v, 'Class.Frequency') == freq then 
                            table.insert(ouvindo[falando], v)
                        end
                        local x, y, z = getElementPosition(v)
                        local distance = getDistanceBetweenPoints3D(position[1], position[2], position[3], x, y, z)
                        if distance <= 5 then 
                            triggerClientEvent(v, 'Voice:playSound', v, falando, 'effects/mic_click_on.ogg')
                        end
                    end
                    triggerClientEvent(root, 'setAnimRadinho', root, source)
                    setPlayerVoiceBroadcastTo(falando, ouvindo[falando])
                end
            --end
            



        else
            cancelEvent()
        end
    end)


    function stopvoice ()
        if getElementData(source, 'char:falando') then 
            if isElement(col[source]) then 
                destroyElement(col[source])
            end
            removeElementData(source, 'char:falando')
            if getElementData(source, 'Class.Frequency') and getElementData(source, 'Class.Active') == true then
                triggerClientEvent(root, 'stopAnimationRadinho', root, source)
            end
            if getElementData(source, 'Class.Frequency') and getElementData(source, 'Class.Active') == true then 
                local position = {getElementPosition(falando)}
                local freq = getElementData(source, 'Class.Frequency')
                local escutando = {}
                for i,v in ipairs(getElementsByType('player')) do 
                    if getElementData(v, 'Class.Frequency') == freq then 
                        table.insert(ouvindo[falando], v)
                    end
                    local x, y, z = getElementPosition(v)
                    local distance = getDistanceBetweenPoints3D(position[1], position[2], position[3], x, y, z)
                    if distance <= 5 then 
                        triggerClientEvent(v, 'Voice:playSound', v, falando, 'effects/mic_click_off.ogg')
                    end
                end
            end
        end
    end
    addEventHandler('onPlayerVoiceStop', root, stopvoice)
    addEventHandler('onPlayerQuit', root, stopvoice)
    addEventHandler('onPlayerWasted', root, stopvoice)

end

