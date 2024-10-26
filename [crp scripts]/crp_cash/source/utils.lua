screen = {guiGetScreenSize ()}
resolution = {1920, 1080}
sx, sy = screen[1] / resolution[1], screen[2] / resolution[2]

function setScreenPosition (x, y, w, h)
    return ((x / resolution[1]) * screen[1]), ((y / resolution[2]) * screen[2]), ((w / resolution[1]) * screen[1]), ((h / resolution[2]) * screen[2])
end

function isCursorOnElement (x, y, w, h)
    if isCursorShowing () then
        local cursor = {getCursorPosition ()}
        local mx, my = cursor[1] * screen[1], cursor[2] * screen[2]
        return mx > x and mx < x + w and my > y and my < y + h
    end
    return false
end

_dxCreateFont = dxCreateFont
function dxCreateFont (path, scale, ...)
    local _, scale, _, _ = setScreenPosition (0, scale, 0, 0)

    return _dxCreateFont (path, scale, ...)
end

_dxDrawRectangle = dxDrawRectangle
function dxDrawRectangle (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    
    return _dxDrawRectangle (x, y, w, h, ...)
end

_dxDrawImage = dxDrawImage
function dxDrawImage (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    
    return _dxDrawImage (x, y, w, h, ...)
end

_dxDrawImageSection = dxDrawImageSection
function dxDrawImageSection (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    
    return _dxDrawImageSection (x, y, w, h, ...)
end

_dxDrawText = dxDrawText
function dxDrawText (text, x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    
    return _dxDrawText (text, x, y, (x + w), (y + h), ...)
end

_isCursorOnElement = isCursorOnElement
function isCursorOnElement (x, y, w, h)
    local x, y, w, h = setScreenPosition (x, y, w, h)

    return _isCursorOnElement (x, y, w, h)
end

local editbox = {
    actual = false;
    events = false;
    elements = { };
    selected = false;
}

createEditBox = function (identify, x, y, width, height, options, postGUI)
    local postGUI = postGUI or false

    if not editbox.elements[identify] then
        editbox.elements[identify] = {
            text = '';
            position = {x, y, width, height};
            options = {
                using = options.using;
                font = options.font or 'default';
                masked = options.masked or false;
                onlynumber = options.onlynumber or false;
                textalign = options.textalign or 'center';
                maxcharacters = options.maxcharacters or 32;
                othertext = options.othertext or 'Digite aqui';
                cache_othertext = options.othertext or 'Digite aqui';
                text = options.text; 
                selected = options.selected;
            };
            manager = {
                tick;
            };
        }

        if next (editbox.elements) and not editbox.events then
            addEventHandler ('onClientKey', root, onClientKeyEditBox)
            addEventHandler ('onClientClick', root, onClientClickEditBox)
            addEventHandler ('onClientPaste', root, onClientPasteEditBox)
            addEventHandler ('onClientCharacter', root, onClientCharacterEditBox)
            editbox.events = true
        end
    else
        local v = editbox.elements[identify]
        local x, y, width, height = unpack (v.position)

        v.text = tostring (v.text)

        local text = (#v.text ~= 0 and v.options.masked and string.gsub (v.text, '.', '*') or #v.text == 0 and v.options.othertext or v.text)
        local textWidth = dxGetTextWidth (text, 1.5, v.options.font) or 0

        dxDrawText (text, x, y, width, height, tocolor (unpack (v.options.text)), 1, v.options.font, (textWidth > width and 'right' or 'left'), v.options.textalign, (textWidth > width), false, postGUI)

        if v.options.using then
            if text ~= '' and text ~= v.options.othertext then
                dxDrawRectangle ((textWidth <= 0 and x or textWidth >= (width - 2.5) and (x + width - 2.5) or (x + textWidth)), y + 2.5, 1, height - 5, tocolor (v.options.text[1], v.options.text[2], v.options.text[3], math.abs (math.sin (getTickCount() / v.options.text[4]) * 255)), postGUI)
            else
                dxDrawRectangle (x + 1, y + 2.5, 1, height - 5, tocolor (v.options.text[1], v.options.text[2], v.options.text[3], math.abs (math.sin (getTickCount() / v.options.text[4]) * 255)), postGUI)
            end
            if editbox.selected ~= nil and editbox.selected == identify then
               dxDrawRectangle (x, y + 0.5, (textWidth > width and width or textWidth), height - 5, tocolor (unpack (v.options.selected)), postGUI)
            end
            if v.manager.tick ~= nil and (getTickCount () >= v.manager.tick + 150) then
                v.text = string.sub (v.text, 1, math.max (#v.text - 1), 0)
            end
        end
    end
end

-- editbox's function's
function dxDestroyAllEditBox ()
    if not next (editbox.elements) then
        return false
    end
    editbox.elements = { }
    editbox.actual = false
    editbox.selected = false
    if editbox.events then
        removeEventHandler ('onClientKey', root, onClientKeyEditBox)
        removeEventHandler ('onClientClick', root, onClientClickEditBox)
        removeEventHandler ('onClientPaste', root, onClientPasteEditBox)
        removeEventHandler ('onClientCharacter', root, onClientCharacterEditBox)
        editbox.events = false
    end
    return true
end

function dxDestroyEditBox (identify)
    if not editbox.elements[identify] then
        return false
    end
    editbox.elements[identify] = nil
    if editbox.actual == identify then
        editbox.actual = false
        editbox.selected = false
    end
    if not next (editbox.elements) and editbox.events then
        removeEventHandler ('onClientKey', root, onClientKeyEditBox)
        removeEventHandler ('onClientClick', root, onClientClickEditBox)
        removeEventHandler ('onClientPaste', root, onClientPasteEditBox)
        removeEventHandler ('onClientCharacter', root, onClientCharacterEditBox)
        editbox.events = false
    end
    return true
end

function dxGetEditBoxText (identify)
    if not editbox.elements[identify] then
        return false
    end
    return editbox.elements[identify].text
end

function dxGetEditBoxState( identify )
    if not editbox.elements[identify] then
        return false
    end
    return editbox.elements[identify].options.using
end

function dxSetEditBoxText (identify, text)
    if not editbox.elements[identify] then
        return false
    end
    editbox.elements[identify].text = text
    return true
end

function dxSetEditBoxOption (identify, option, value)
    if not editbox.elements[identify] then
        return false
    end
    editbox.elements[identify].options[option] = value
    return true
end

-- editbox's event's
function onClientKeyEditBox (key, press)
    if not editbox.actual then
        return false
    end
    local v = editbox.elements[editbox.actual]
    if key == 'backspace' then
        if press then
            if editbox.selected then
                if #v.text ~= 0 then
                    v.text = ''
                    editbox.selected = false
                end
            else
                v.text = tostring (v.text)
                if #v.text ~= 0 and (#v.text - 1) >= 0 then
                    v.text = string.sub (v.text, 1, #v.text - 1)
                    v.manager.tick = getTickCount ()
                else
                    if v.manager.tick ~= nil then
                        v.manager.tick = nil
                    end
                end
            end
        else
            if v.manager.tick ~= nil then
                v.manager.tick = nil
            end
        end
    end
    if key == 'v' and getKeyState ('lctrl') then
        return
    end
    if key == 'a' and getKeyState ('lctrl') and #v.text ~= 0 then
        if editbox.selected ~= false then
            return
        end
        editbox.selected = editbox.actual
        return
    end
    if key == 'c' and getKeyState ('lctrl') and #v.text ~= 0 then
        if not editbox.selected then
            return
        end
        setClipboard (v.text)
        return
    end
    cancelEvent ()
end

function onClientClickEditBox (button, state)
    if button == 'left' and state == 'down' then
        for i, v in pairs (editbox.elements) do
            if isCursorOnElement (unpack (v.position)) then
                if editbox.actual then
                    editbox.elements[editbox.actual].options.using = false
                    editbox.actual = false
                    editbox.selected = false
                end
                editbox.elements[i].options.using = true
                editbox.actual = i
                editbox.elements[editbox.actual].options.othertext = ''
            else
                if editbox.actual ~= false and editbox.actual == i then
                    editbox.elements[editbox.actual].options.othertext = editbox.elements[editbox.actual].options.cache_othertext
                    editbox.elements[i].options.using = false
                    editbox.actual = false
                    editbox.selected = false
                end
            end
        end
    end
end

function onClientPasteEditBox (textPaste)
    if not editbox.actual then
        return false
    end
    if textPaste == '' then
        return false
    end
    editbox.elements[editbox.actual].text = (editbox.selected and textPaste or editbox.elements[editbox.actual].text..''..textPaste)
    if editbox.selected ~= false then
        editbox.selected = false
    end
end

function onClientCharacterEditBox (key)
    if not editbox.actual then
        return false
    end
    local v = editbox.elements[editbox.actual]
    v.text = tostring (v.text)
    if #v.text < v.options.maxcharacters then
        if v.options.onlynumber and tonumber (key) then
            if editbox.selected ~= false then
                v.text = tonumber (key)
                editbox.selected = false
                return
            end
            v.text = tonumber (v.text..''..key)
        elseif not v.options.onlynumber and tostring (characterDetect) then
            if editbox.selected ~= false then
                v.text = key
                editbox.selected = false
                return
            end
            v.text = v.text..''..key
        end
    end
end

_tocolor = tocolor
function tocolor (hex, alpha)
    if type(hex) == 'string' then 
        local alpha = (alpha and (alpha / 100 * 255) or 255)
        if alpha < 0 then 
            alpha = 0
        end
        return _tocolor ('0x'..hex:sub (1, 2), '0x'..hex:sub (3, 4), '0x'..hex:sub (5, 6), alpha)
    end
end