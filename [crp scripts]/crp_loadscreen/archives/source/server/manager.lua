addEvent('CLASS >> setVoice', true)
addEventHandler('CLASS >> setVoice', resourceRoot, function(state)
    if (state == true) then
        setPlayerVoiceIgnoreFrom(client, root)
    else
        setPlayerVoiceIgnoreFrom(client, nil)
    end
end)