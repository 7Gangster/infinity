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

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
    if type(sEventName) == "string" and isElement(pElementAttachedTo) and type(func) == "function" then
        local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)

        if type(aAttachedFunctions) == "table" and #aAttachedFunctions > 0 then
            for i, v in ipairs(aAttachedFunctions) do
                if v == func then
                    return true
                end
            end
        end
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

svgsRectangle = {};
function dxDrawRoundedRectangle(x, y, w, h, radius, color, post)
    if not svgsRectangle[radius] then
        svgsRectangle[radius] = {}
    end
    if not svgsRectangle[radius][w] then
        svgsRectangle[radius][w] = {}
    end
    if not svgsRectangle[radius][w][h] then
        local path = string.format([[
        <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect opacity="1" width="%s" height="%s" rx="%s" fill="#FFFFFF"/>
        </svg>
        ]], w, h, w, h, w, h, radius)
        svgsRectangle[radius][w][h] = svgCreate(w, h, path)
    end
    if svgsRectangle[radius][w][h] then
        return dxDrawImage(x, y, w, h, svgsRectangle[radius][w][h], 0, 0, 0, color, post or false)
    end
end

polygons = {}
function dxDrawPolygon ( x, y, w, h, color, post )
    if not polygons[w] then
        polygons[w] = {} 
    end
    if not polygons[w][h] then
        polygons[w][h] = svgCreate(w, h, string.format([[
            <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M0 87L50 0.397461H150L200 87L150 173.603H50L0 87Z" fill="#FFFFFF"/>
            </svg>
        ]], w, h, w, h))
    end
    if polygons[w][h] then 
        return dxDrawImage(x, y, w, h, polygons[w][h], 0, 0, 0, color, post or false)
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

font = {
    ['Roboto'] = {
        ['regular'] = {
            [9] = dxCreateFont('src/assets/fonts/Roboto-Regular.ttf', 9),
            [10] = dxCreateFont('src/assets/fonts/Roboto-Regular.ttf', 10),
            [12] = dxCreateFont('src/assets/fonts/Roboto-Regular.ttf', 12),
            [14] = dxCreateFont('src/assets/fonts/Roboto-Regular.ttf', 14),
            [16] = dxCreateFont('src/assets/fonts/Roboto-Regular.ttf', 16),
            [20] = dxCreateFont('src/assets/fonts/Roboto-Regular.ttf', 20),
        },
        ['medium'] = {
            [10] = dxCreateFont('src/assets/fonts/Roboto-Medium.ttf', 10),
            [12] = dxCreateFont('src/assets/fonts/Roboto-Medium.ttf', 12),
            [14] = dxCreateFont('src/assets/fonts/Roboto-Medium.ttf', 14),
            [16] = dxCreateFont('src/assets/fonts/Roboto-Medium.ttf', 16),
            [20] = dxCreateFont('src/assets/fonts/Roboto-Medium.ttf', 20),
        },
        ['bold'] = {
            [10] = dxCreateFont('src/assets/fonts/Roboto-Bold.ttf', 10),
            [12] = dxCreateFont('src/assets/fonts/Roboto-Bold.ttf', 12),
            [14] = dxCreateFont('src/assets/fonts/Roboto-Bold.ttf', 14),
            [16] = dxCreateFont('src/assets/fonts/Roboto-Bold.ttf', 16),
            [20] = dxCreateFont('src/assets/fonts/Roboto-Bold.ttf', 20),
        },
    },
}