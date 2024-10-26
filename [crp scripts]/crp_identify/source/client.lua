
local table = {
    handlerAdded = false,
    nomeCompleto = getPlayerName(localPlayer),
    passaport = 0,
    imagesFiles = {
        [1] = 'assets/images/base.png',
    },
    fonts = {
        [1] = dxCreateFont('assets/fonts/bold.ttf', 13),
        [2] = dxCreateFont('assets/fonts/alex.ttf', 23),
    },
}

local function open()
    local passaport = getElementData(localPlayer, 'ID') or 0
    local underscorePos = string.find(table.nomeCompleto, "_") or 0
    local primeiroNome = string.sub(table.nomeCompleto, 1, underscorePos - 1) or ""
    local segundoNome = string.sub(table.nomeCompleto, underscorePos + 1) or ""

    dxSetBlendMode('modulate_add')
    p(1120, 249, 540, 360, table.imagesFiles[1])
    t(passaport, 1395, 340, 121, 13, tocolor('B4341E', 255), 1, table.fonts[1], 'left', 'center', false)
    t(''..primeiroNome..'\n'..segundoNome..'', 1329, 393.5, 113, 21, tocolor('000000', 255), 1, table.fonts[1], 'left', 'center', false)
    t('24/08/2002', 1338, 461, 113, 21, tocolor('B4341E', 255), 1, table.fonts[1], 'left', 'center', false)
    t(''..primeiroNome..' '..segundoNome..'', 1135, 554, 170, 27, tocolor('B4341E', 255), 1, table.fonts[2], 'center', 'center', false)
    dxSetBlendMode('blend')   
end

addEvent('class.openIdentify', true)
addEventHandler('class.openIdentify', root, function(info)
    if table.handlerAdded == false then
        table.handlerAdded = true
        table.nomeCompleto = info.nome 
        table.passaport = info.rg
        addEventHandler('onClientRender', root, open, false, 'high')
        addEventHandler('onClientKey', root, keyManager)
    elseif table.handlerAdded == true then
        table.handlerAdded = false
        removeEventHandler('onClientRender', root, open)
        removeEventHandler('onClientKey', root, keyManager)
    end
end)

function keyManager ( b, s )
    if s then 
        if b == 'escape' then 
            table.handlerAdded = false
            removeEventHandler('onClientRender', root, open)
            removeEventHandler('onClientKey', root, keyManager)
            showCursor(false)
            cancelEvent()
        end
    end
end
