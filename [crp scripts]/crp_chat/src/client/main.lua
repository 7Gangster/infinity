local historic = {}
local historicIndex = 0

local isChatBoxOpen = false
local chatBox = false
local tick = 0

local widht = 450

function renderChatBox ( )
    local text = guiGetText(chatBox) or 'Insira a mensagem'
    local alpha = interpolateBetween(0, 0, 0, 100, 0, 0, (getTickCount()-tick)/500, 'Linear')
    local alpha2 = interpolateBetween(0, 0, 0, 60, 0, 0, (getTickCount()-tick)/500, 'Linear')
    if text == '' then 
        text = 'Insira a mensagem'
    end

    local lenght = dxGetTextWidth(guiGetText(chatBox), 1, font['Roboto']['regular'][10])

    dxDrawRoundedRectangle(11, 305, widht, 48, 5, tocolor('000000', alpha2))
    dxDrawText(text, 26, 305, (widht - 15), 48, tocolor('FFFFFF', alpha), 1, font['Roboto']['regular'][10], 'left', 'center')

    --355 - 368
    dxDrawImage((11 + widht + 5), 305, 50, 48, icons.button, 0, 0, 0, tocolor('FFFFFF', alpha))
    dxDrawImage((11 + widht + 5 +13), 317, 24, 24, icons.send, 0, 0, 0, tocolor('FFFFFF', alpha))

    if string.find(guiGetText(chatBox), '/') == 1 then 
        local i = 0
        local list = #getCommands(guiGetText(chatBox))
        local height = ((40*list))
        if list == 1 then height = 57 end
        if height > 0 then 
            dxDrawRoundedRectangle(11, 360, widht, height, 10, tocolor('000000', alpha2))
            for _, v in ipairs(cfg.commands) do
                if string.find(v, guiGetText(chatBox)) then 
                    i = i+1
                    if i <= 5 then 
                        local x, y, w, h = 31, (376 + (-30 + (30*i))), 322, 14
                        dxDrawText(v, x, y, w, h, tocolor('FFFFFF', alpha), 1, font['Roboto']['medium'][10] )
                        dxDrawText(cfg.info[v] or '', x, (390 + (-30 + (30*i))), w, h, tocolor('C7C7C7', alpha), 1, font['Roboto']['regular'][9] )
                    end
                end
            end
        end
    end
end

bindKey('t', 'down', function ( )
    if not isChatBoxOpen then 
        addEventHandler('onClientRender', root, renderChatBox)
        isChatBoxOpen = true
        chatBox = guiCreateEdit(-1, -1, 0, 0, '')
        guiEditSetMaxLength(chatBox, 50)
        guiFocus(chatBox)
        tick = getTickCount()
        showCursor(true)
        showChat(false)
        addEventHandler('onClientClick', root, click)
        setTimer(function()
            guiSetText(chatBox, '')
        end, 10, 1)
    end
end)

addEventHandler('onClientKey', root, function(b, s)
    if b == 'escape' and s then   
        if isChatBoxOpen then 
            cancelEvent()
            removeEventHandler('onClientRender', root, renderChatBox)
            removeEventHandler('onClientClick', root, click)
            isChatBoxOpen = false
            destroyElement(chatBox)
            chatBox = false
            showCursor(false)
            historicIndex = 0
        end
    elseif b == 'enter' and s then 
        if isChatBoxOpen then 
            local text = guiGetText(chatBox)
            cancelEvent()
            removeEventHandler('onClientRender', root, renderChatBox)
            removeEventHandler('onClientClick', root, click)
            isChatBoxOpen = false
            destroyElement(chatBox)
            chatBox = false
            showCursor(false)
            historicIndex = 0
            if #text > 0 then 
                sendMessage (text)
            end
        end
    elseif b == 'arrow_u' and s then 
        if isChatBoxOpen then 
            if #historic > 0 then 
                if historicIndex == 0 then 
                    historicIndex = #historic
                    guiSetText(chatBox, historic[historicIndex])
                else
                    if historicIndex > 1 then
                        historicIndex = historicIndex -1
                        guiSetText(chatBox, historic[historicIndex])
                    end
                end
            end
        end
    elseif b == 'arrow_d' and s then 
        if isChatBoxOpen then 
            if #historic > 0 then 
                if historicIndex > 0 then 
                    if historicIndex < #historic then
                        historicIndex = historicIndex +1
                        guiSetText(chatBox, historic[historicIndex])
                    end
                end
            end
        end
    end
end)

function click ( b, s )
    if b == 'left' and s == 'down' then 
        if isCursorOnElement(11, 305, widht, 48) then 
            guiFocus(chatBox)
        elseif isCursorOnElement((11 + widht + 5), 305, 50, 48) then 
            local text = guiGetText(chatBox)
            cancelEvent()
            removeEventHandler('onClientRender', root, renderChatBox)
            removeEventHandler('onClientClick', root, click)
            isChatBoxOpen = false
            destroyElement(chatBox)
            chatBox = false
            showCursor(false)
            historicIndex = 0
            if #text > 0 then 
                sendMessage (text)
            end
        end
    end
end

function sendMessage (text)
    local args = split(text, ' ')
    local a = string.find(args[1], '/')
    if a == 1 then 
        local cmd = string.gsub(args[1], '/', '')
        table.remove(args, 1)
        if #args > 0 then
            triggerServerEvent('executeCommand', localPlayer, localPlayer, cmd, args)
        else
            triggerServerEvent('executeCommand', localPlayer, localPlayer, cmd)
        end
    else
        triggerServerEvent('sendMessage', localPlayer, localPlayer, text)
    end
    if historic[#historic] ~= text then 
        table.insert(historic, text)
    end
end

function transformNumber(args)
    local newArgs = {}
    for i,v in ipairs(args) do 
        if tonumber(v) then 
            table.insert(newArgs, v)
        elseif tostring(v) then 
            table.insert(newArgs, v)
        end
    end
    return newArgs
end

function getCommands(text)
    local i = 0
    local commands = {}
    for _, v in ipairs(cfg.commands) do
        if string.find(v, text) then 
            i = i+1
            if i <= 5 then
                table.insert(commands, v)
            end
        end
    end
    return commands
end

--[[
function string.split(text, sep)
    local words = {}
    local i = 0
    for w in string.gmatch(text, sep) do 
        i = i +1
        words[i] = w
    end
    return words
end]]

setTimer(showChat, 1000, 0, false)

icons = {
    button = svgCreate(50, 48, [[
        <svg width="50" height="48" viewBox="0 0 50 48" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect width="50" height="48" rx="5" fill="url(#paint0_linear_32_9)"/>
        <defs>
        <linearGradient id="paint0_linear_32_9" x1="25.0804" y1="85.5" x2="61.7533" y2="-27.4302" gradientUnits="userSpaceOnUse">
        <stop stop-color="#00D256"/>
        <stop offset="1" stop-color="#7ACC9C"/>
        </linearGradient>
        </defs>
        </svg>
    ]]),
    send = svgCreate(24, 24, [[
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <mask id="mask0_32_28" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="0" y="0" width="24" height="24">
        <rect width="24" height="24" fill="#FFFFFF"/>
        </mask>
        <g mask="url(#mask0_32_28)">
        <path d="M3 20V14L11 12L3 10V4L22 12L3 20Z" fill="white"/>
        </g>
        </svg>

    ]])
}