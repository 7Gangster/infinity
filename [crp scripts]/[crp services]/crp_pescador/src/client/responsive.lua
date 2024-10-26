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
function dxDrawRoundedRectangle(x, y, w, h, color, radius, post, relative)
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
        if relative == true then
            _dxDrawImage(x, y, w, h, svgsRectangle[radius][w][h], 0, 0, 0, color, post or false)
        else
            dxDrawImage(x, y, w, h, svgsRectangle[radius][w][h], 0, 0, 0, color, post or false)
        end
    end
end

svgsCircle = {};
function dxDrawCircle(x, y, w, h, color, radius)
    if not svgsCircle[radius] then
        svgsCircle[radius] = {}
    end
    if not svgsCircle[radius][w] then
        svgsCircle[radius][w] = {}
    end
    if not svgsCircle[radius][w][h] then
        local path = string.format([[
            <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="%s" height="%s" rx="500" fill="#FFFFFF"/>
            </svg>
        ]], w, h, w, h, w, h)
        svgsCircle[radius][w][h] = svgCreate(w, h, path)
    end
    if svgsCircle[radius][w][h] then
        dxDrawImage(x, y, w, h, svgsCircle[radius][w][h], 0, 0, 0, color, post or false)
    end
end

button = {};
function dxDrawButton(x, y, w, h, radius, post)
    if not button[radius] then
        button[radius] = {}
    end
    if not button[radius][w] then
        button[radius][w] = {}
    end
    if not button[radius][w][h] then
        local path = string.format([[
            <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="%s" height="%s" rx="10" fill="#363636" fill-opacity="0.33"/>
            <rect x="0.5" y="0.5" width="%s" height="%s" rx="9.5" stroke="#414141" stroke-opacity="0.8"/>
            </svg>            
        ]], w, h, w, h, w, h, w-1, h-1)
        button[radius][w][h] = svgCreate(w, h, path)
    end
    if button[radius][w][h] then
        dxDrawImage(x, y, w, h, button[radius][w][h], 0, 0, 0, tocolor(255, 255, 255), post or false)
    end
end

function formatNumber(number, sep)
	assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
	assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end