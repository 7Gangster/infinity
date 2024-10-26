--[[

██╗░░░░░██╗░░░██╗░█████╗░░█████╗░░██████╗  ░██████╗████████╗
██║░░░░░██║░░░██║██╔══██╗██╔══██╗██╔════╝  ██╔════╝╚══██╔══╝
██║░░░░░██║░░░██║██║░░╚═╝███████║╚█████╗░  ╚█████╗░░░░██║░░░
██║░░░░░██║░░░██║██║░░██╗██╔══██║░╚═══██╗  ░╚═══██╗░░░██║░░░
███████╗╚██████╔╝╚█████╔╝██║░░██║██████╔╝  ██████╔╝░░░██║░░░
╚══════╝░╚═════╝░░╚════╝░╚═╝░░╚═╝╚═════╝░  ╚═════╝░░░░╚═╝░░░

]]--

-- Resolution

local screen = { guiGetScreenSize() }
local resW, resH = 1920, 1080

function cX(pos)
    local Diferenca = resW - pos
    return screen[1] - Diferenca
end

function cY(pos, height)
    local Divisao = resH / 2
    local Total = Divisao - height
    local Convertido = pos - Total
    return (screen[2] / 2) - height + Convertido
end

_dxDrawText = dxDrawText
function dxDrawText(text, x, y, w, h, color, scale, font, alignX, alignY, clip, wbreak, post, colorcode, sPP, fR, fRCX, fRCY)
    local x, y = cX(x), cY(y, h)
    return _dxDrawText(text, x, y, (w + x), (h + y) , color, scale, font, alignX, alignY, clip, wbreak, post, colorcode, sPP, fR, fRCX, fRCY)
end

_guiCreateWindow = guiCreateWindow
function guiCreateWindow(x, y, w, h, ...)
    local x, y = cX(x), cY(y, h)
    return _guiCreateWindow(x, y, w, h, ...)
end

--

local Components = {
    button = {},
    window = {},
    scrollbar = {},
    edit = {}
}

guiSetInputMode("no_binds_when_editing")

local Preview = false
local Object = nil

addCommandHandler("preview", function(cmd, id)
    if Preview then
        Preview = false
        toggleCursor("mouse2", "down", true)
        if Components.window[1] and isElement(Components.window[1]) then
            destroyElement(Components.window[1])
            Components.window[1] = nil
        end
        destroyElement(Object)
    else
        if id and tonumber(id) then
            Object = createObject(tonumber(id), 0, 0, 0)
            if Object then
                Preview = true
                exports.pAttach:attach(Object, localPlayer, 1, 0, 0, 0, 0, 0, 0)
                showCursor(true)
                
                Components.window[1] = guiCreateWindow(1420, 362, 353, 333, "Preview pAttach By : ST", false)
                guiWindowSetSizable(Components.window[1], false)
                guiWindowSetMovable ( Components.window[1], false )
                Components.scrollbar[1] = guiCreateScrollBar(10, 249, 185, 26, true, false, Components.window[1])
                Components.scrollbar[2] = guiCreateScrollBar(10, 285, 185, 26, true, false, Components.window[1])
                Components.scrollbar[3] = guiCreateScrollBar(10, 213, 185, 26, true, false, Components.window[1])
                Components.scrollbar[4] = guiCreateScrollBar(10, 177, 185, 26, true, false, Components.window[1])
                Components.scrollbar[5] = guiCreateScrollBar(10, 141, 185, 26, true, false, Components.window[1])
                Components.scrollbar[6] = guiCreateScrollBar(10, 105, 185, 26, true, false, Components.window[1])
                for i = 1,6 do
                    guiScrollBarSetScrollPosition(Components.scrollbar[i], 50)
                end
                Components.edit[1] = guiCreateEdit(23, 42, 111, 33, "1", false, Components.window[1])
                Components.button[1] = guiCreateButton(225, 42, 88, 36, "Copiar", false, Components.window[1])
                guiSetProperty(Components.button[1], "NormalTextColour", "FFAAAAAA")

            end
        end
    end
end)

addEventHandler("onClientGUIChanged", guiRoot, function(element) 
    if element == Components.edit[1] then
        local Text = guiGetText(Components.edit[1])
        if tonumber(Text) and VALID_BONES[tonumber(Text)] then
            exports.pAttach:detach(Object)
            exports.pAttach:attach(Object, localPlayer, tonumber(Text), 0, 0, 0, 0, 0, 0)
            attPositionsAttach()
        end
    end
end)

addEventHandler("onClientGUIClick", root, function(button) 
    if source == Components.button[1] then
        local xPosOffset, yPosOffset, zPosOffset = (guiScrollBarGetScrollPosition(Components.scrollbar[6]) - 50) / 100, (guiScrollBarGetScrollPosition(Components.scrollbar[5]) - 50) / 100, (guiScrollBarGetScrollPosition(Components.scrollbar[4]) - 50) / 100
        local xRotOffset, yRotOffset, zRotOffset = (guiScrollBarGetScrollPosition(Components.scrollbar[3]) - 50) * 360 / 100, (guiScrollBarGetScrollPosition(Components.scrollbar[1]) - 50) * 360 / 100, (guiScrollBarGetScrollPosition(Components.scrollbar[2]) - 50) * 360 / 100
        setClipboard(table.concat({xPosOffset, yPosOffset, zPosOffset, xRotOffset, yRotOffset, zRotOffset}, ","))
        outputChatBox("Posições Copiadas com Sucesso !")
    end
end)


addEventHandler("onClientGUIScroll", root, function(element) 
    attPositionsAttach()
end)

function attPositionsAttach()
    local xPosOffset, yPosOffset, zPosOffset = guiScrollBarGetScrollPosition(Components.scrollbar[6]) - 50, guiScrollBarGetScrollPosition(Components.scrollbar[5]) - 50, guiScrollBarGetScrollPosition(Components.scrollbar[4]) - 50
    local xRotOffset, yRotOffset, zRotOffset = (guiScrollBarGetScrollPosition(Components.scrollbar[3]) - 50) * 360 / 100, (guiScrollBarGetScrollPosition(Components.scrollbar[1]) - 50) * 360 / 100, (guiScrollBarGetScrollPosition(Components.scrollbar[2]) - 50) * 360 / 100
    exports.pAttach:setPositionOffset(Object, xPosOffset / 100, yPosOffset / 100, zPosOffset / 100)
    exports.pAttach:setRotationOffset(Object, xRotOffset, yRotOffset, zRotOffset)
end

addEventHandler("onClientRender", root, function()
    if Preview then
        dxDrawText("xPosOffset - "..guiScrollBarGetScrollPosition(Components.scrollbar[6]).."%", 1619, 468, 1753, 22, isCursorShowing() and isCursorShowing() and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 51) or tocolor(255, 255, 255, 51), 1.00, "default-bold", "left", "center", false, false, true, false, false)
        dxDrawText("yPosOffset - "..guiScrollBarGetScrollPosition(Components.scrollbar[5]).."%", 1619, 505, 1753, 22, isCursorShowing() and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 51), 1.00, "default-bold", "left", "center", false, false, true, false, false)
        dxDrawText("zPosOffset - "..guiScrollBarGetScrollPosition(Components.scrollbar[4]).."%", 1619, 541, 1753, 22, isCursorShowing() and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 51), 1.00, "default-bold", "left", "center", false, false, true, false, false)
        dxDrawText("xRotOffset - "..guiScrollBarGetScrollPosition(Components.scrollbar[3]).."%", 1619, 577, 1753, 22, isCursorShowing() and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 51), 1.00, "default-bold", "left", "center", false, false, true, false, false)
        dxDrawText("yRotOffset - "..guiScrollBarGetScrollPosition(Components.scrollbar[1]).."%", 1619, 613, 1753, 22, isCursorShowing() and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 51), 1.00, "default-bold", "left", "center", false, false, true, false, false)
        dxDrawText("zRotOffset - "..guiScrollBarGetScrollPosition(Components.scrollbar[2]).."%", 1619, 649, 1753, 22, isCursorShowing() and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 51), 1.00, "default-bold", "left", "center", false, false, true, false, false)
        dxDrawText("Bone ID", 1444, 384, 1578, 22, isCursorShowing() and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 51), 1.00, "default-bold", "left", "center", false, false, true, false, false)
    end
end)

function toggleCursor(button, state, manual)
    if Preview or manual then
        if state == "down" then
            guiSetAlpha(Components.window[1], 0.2)
            showCursor(false)
        else
            guiSetAlpha(Components.window[1], 1)
            showCursor(true)
        end
    end
end
bindKey("mouse2", "both", toggleCursor)



VALID_BONES = {
    [0] = "BONE_ROOT",
    [1] = "BONE_PELVIS1",
    [2] = "BONE_PELVIS",
    [3] = "BONE_SPINE1",
    [4] = "BONE_UPPERTORSO",
    [5] = "BONE_NECK",
    [6] = "BONE_HEAD2",
    [7] = "BONE_HEAD1",
    [8] = "BONE_HEAD",
    [22] = "BONE_RIGHTSHOULDER",
    [23] = "BONE_RIGHTELBOW",
    [24] = "BONE_RIGHTWRIST",
    [25] = "BONE_RIGHTHAND",
    [26] = "BONE_RIGHTTHUMB",
    [31] = "BONE_LEFTUPPERTORSO",
    [32] = "BONE_LEFTSHOULDER",
    [33] = "BONE_LEFTELBOW",
    [34] = "BONE_LEFTWRIST",
    [35] = "BONE_LEFTHAND",
    [36] = "BONE_LEFTTHUMB",
    [41] = "BONE_LEFTHIP",
    [42] = "BONE_LEFTKNEE",
    [43] = "BONE_LEFTANKLE",
    [44] = "BONE_LEFTFOOT",
    [51] = "BONE_RIGHTHIP",
    [52] = "BONE_RIGHTKNEE",
    [53] = "BONE_RIGHTANKLE",
    [54] = "BONE_RIGHTFOOT",
    [201] = "BONE_BELLY",
    [301] = "BONE_RIGHTBREAST",
    [302] = "BONE_LEFTBREAST",
}


