cache = {
    ['velocimetro'] = {false, 0, getTickCount()},
    ['velocimetro_bg'] = {false, 0, getTickCount()},
    ['gas_bg'] = {false, 0, getTickCount()},
    ['gas'] = {false, 0, getTickCount()},
}

print('stroke')
local vectors = {}

function createVector(width, height, rawData)
    local svgElm = svgCreate(width, height, rawData)
    local svgXML = svgGetDocumentXML(svgElm)
    local rect = xmlFindChild(svgXML, "rect", 0)

    return {
        svg = svgElm,
        xml = svgXML,
        rect = rect
    }
end

function createCircleStroke(id, width, height, sizeStroke, rot)
    if (not id) then return end 
    if (not (width or height)) then return end

    if (not vectors[id]) then
        sizeStroke = sizeStroke or 2
        
        local radius = math.min(width, height) / 2
        local radiusLength = (2 * math.pi) * radius
        local newWidth, newHeight = width + (sizeStroke * 2), height + (sizeStroke * 2)

        local dashOffset = radiusLength - (radiusLength / 100) * 0

        -- stroke-linecap='round' stroke-linejoin='round'
        local raw = string.format([[
            <svg width='%s' height='%s'>
                <rect x='%s' y='%s' rx='%s' width='%s' height='%s' fill='#FFFFFF' fill-opacity='0' stroke='#FFFFFF'
                stroke-width='%s' stroke-dasharray='%s' stroke-dashoffset='%s'  />
            </svg>
        ]], newWidth, newHeight, sizeStroke, sizeStroke, radius, width, height, sizeStroke, radiusLength, dashOffset)
        local svg = createVector(width, height, raw)

        local attributes = {
            type = 'circle-stroke',
            svgDetails = svg,
            width = width,
            height = height,
            radius = radius,
            rot = rot,
            radiusLength = radiusLength
        }

        vectors[id] = attributes
    end
    return vectors[id]
end 

function createRoundedRectangle(id, width, height, radius)
    if (not id) then return end 
    if (not (width or height)) then return end

    if (not vectors[id]) then 
        width = width or 1
        height = height or 1
        radius = radius or 1


        local area = width * height
        local length = area / width
        local perimeter = (width + length) * 2
        local bottom = height - radius
        local raw = string.format([[ 
            <svg width='%s' height='%s'>
                <rect rx='%s' width='%s' height='%s'  fill='#FFFFFF'/>
            </svg>
        ]], width, height, radius, width, height)
        local svg = createVector(width, height, raw)

        local attributes = {
            type = 'rounded-rectangle',
            svgDetails = svg,
            width = width,
            height = height,
            radius = radius,
            radiusLength = length,
            perimeter = perimeter,
            area = area,
            length = length
        }
        vectors[id] = attributes
    end
    return vectors[id]
end




function createCircle(id, width, height)
    if (not id) then return end 
    if (not (width or height)) then return end

    if (not vectors[id]) then 
        width = width or 1
        height = height or 1
        
        local radius = math.min(width, height) / 2
        local raw = string.format([[
            <svg width='%s' height='%s'>
                <rect rx='%s' width='%s' height='%s' fill='#FFFFFF'/>
            </svg>
        ]], width, height, radius, width, height)
        local svg = createVector(width, height, raw)

        local attributes = {
            type = 'circle',
            svgDetails = svg,
            width = width,
            height = height,
        }
        vectors[id] = attributes
    end
    return vectors[id]
end



function setSVGOffset(id, value)
    if (not vectors[id]) then return end 
    local svg = vectors[id]
   
    if (cache[id][2] ~= value) then 
        if (not cache[id][1]) then
            cache[id][3] = getTickCount()
            cache[id][1] = true
        end
        
        local progress = (getTickCount() - cache[id][3]) / 2500
        cache[id][2] = interpolateBetween(cache[id][2], 0, 0, value, 0, 0, progress, 'OutQuad')
        
        if (progress > 1) then 
            cache[id][3] = nil
            cache[id][1] = false
        end

        if (svg.type == 'rounded-rectangle' ) then 
            local rect = svg.svgDetails.rect
            

            local newValue = (svg.length / 100) * cache[id][2]
            local reverseWidth = svg.width - newValue

            xmlNodeSetAttribute(rect, 'height', reverseWidth)
            svgSetDocumentXML(svg.svgDetails.svg, svg.svgDetails.xml)
        end

        local rect = svg.svgDetails.rect
        local newValue = svg.radiusLength - (svg.radiusLength / 100) * cache[id][2]

        xmlNodeSetAttribute(rect, 'stroke-dashoffset', newValue)
        svgSetDocumentXML(svg.svgDetails.svg, svg.svgDetails.xml)
    elseif cache[id][1] then
        cache[id][1] = false
    end
end      

function drawItem(id, x, y, color, postGUI)
    if (not vectors[id]) then return end
    if (not (x or y)) then return end
    local svg = vectors[id]

    postGUI = postGUI or false
    color = color or 0xFFFFFFFF

    local width, height = svg.width, svg.height
    local rot = svg.rot

    dxSetBlendMode('modulate_add')
    --dxDrawImage(offsetX + x * scale, offsetY + y * scale, width * scale, height * scale, svg.svgDetails.svg, -87, 0, 0, color, postGUI)
    dxDrawImage(x, y, width, height, svg.svgDetails.svg, rot, 0, 0, color, postGUI)
    dxSetBlendMode('blend')
end

function drawItem2(id, x, y, color, postGUI)
    if (not vectors[id]) then return end
    if (not (x or y)) then return end
    local svg = vectors[id]

    postGUI = postGUI or false
    color = color or 0xFFFFFFFF

    local width, height = svg.width, svg.height

    dxSetBlendMode('add')
    --dxDrawImage(offsetX + x * scale, offsetY + y * scale, width * scale, height * scale, svg.svgDetails.svg, 0, 0, 0, color, postGUI)
    dxDrawImage(x, y, widht, height, svg.svgDetails.svg, 0, 0, 0, color, postGUI)
    dxSetBlendMode('blend')
end
