local screenW, screenH = guiGetScreenSize()
canWrite = { {'1'}, {'2'}, {'3'}, {'4'}, {'5'}, {'6'}, {'7'}, {'8'}, {'9'}, {'0'}, {'.'}}

function isCursorOnElement (x, y, w, h)
    if isCursorShowing () then
        local cursor = {getCursorPosition ()}
        local mx, my = cursor[1] * screenW, cursor[2] * screenH
        return mx > x and mx < x + w and my > y and my < y + h
    end
    return false
end

function isValueInTable(theTable,value,columnID)
    assert(theTable, "Bad argument 1 @ isValueInTable (table expected, got " .. type(theTable) .. ")")
    local checkIsTable = type(theTable)
    assert(checkIsTable == "table", "Invalid value type @ isValueInTable (table expected, got " .. checkIsTable .. ")")
    assert(value, "Bad argument 2 @ isValueInTable (value expected, got " .. type(value) .. ")")
    assert(columnID, "Bad argument 3 @ isValueInTable (number expected, got " .. type(columnID) .. ")")
    local checkIsID = type(columnID)
    assert(checkIsID == "number", "Invalid value type @ isValueInTable (number expected, got " ..checkIsID .. ")")
    for i,v in ipairs (theTable) do
        if v[columnID] == value then
            return true,i
        end
    end
    return false
end

svgsRectangle = {};
function dxDrawRoundedRectangle(x, y, w, h, radius, color, stroke, strokeColor, post, relative)
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
        if stroke then 
            path = string.format([[
                <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect opacity="1" width="%s" height="%s" rx="%s" fill="#FFFFFF" stroke-widht="%s" stroke-color="%s"/>
                </svg>
            ]], w, h, w, h, w, h, radius, stroke or 1, strokeColor or '#FFFFFF')
        end
        svgsRectangle[radius][w][h] = svgCreate(w, h, path)
    end
    if svgsRectangle[radius][w][h] then
        if relative then 
            _dxDrawImage(x, y, w, h, svgsRectangle[radius][w][h], 0, 0, 0, color, post or false)
        else
            dxDrawImage(x, y, w, h, svgsRectangle[radius][w][h], 0, 0, 0, color, post or false)
        end
    end
end