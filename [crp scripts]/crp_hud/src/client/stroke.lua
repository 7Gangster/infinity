SVGCache = { };

SVGCache.__mode = 'k';
SVGCache.__index = SVGCache;

function SVGCache:new(w, h, type, color, animate, animationSpeed, stroke)
    assert(w and h, "É necessário fornecer a largura e a altura para a criação de SVG.")
    assert(type == 'polygon', "Tipo inválido fornecido para SVG. Opções válidas são 'circle', 'rect' ou 'polygon'.")

    local data = { };
    setmetatable(data, SVGCache)

    data.stroke = stroke
    data.w = w
    data.h = h

    local svgPolygon = createHexagon (w, h, stroke)

    local svg = nil
    data.dashArray = 157
    if type == 'polygon' then
        svg = svgPolygon
    end

    data.svg = svgCreate(w, h, svg)
    assert(data.svg, "Falha ao criar o objeto SVG.")

    data.xml = nil
    data.elementSVG = nil
    data.dashOffset = 0
    data.count = getTickCount()
    data.color = color or {255, 255, 255}
    data.animate = animate or false
    data.animationSpeed = animationSpeed or 0.2
    data.type = type

    data.xml = svgGetDocumentXML(data.svg)
    assert(data.xml, "Falha ao obter o XML do documento SVG.")

    data.elementSVG = xmlFindChild(data.xml, type, 0)
    assert(data.elementSVG, "Falha ao encontrar o elemento SVG.")

    return data
end

function SVGCache:update(x, y, alpha, value, rot)
    if value then
        self.dashOffset = value
    end

        local rot = rot or 0
        local newValue = (self.dashArray / 100) * (100 - self.dashOffset)

        dxSetBlendMode('add')
        dxDrawImage(x, y, self.w, self.h, self.svg, 0, 0, rot, _tocolor(self.color[1], self.color[2], self.color[3], alpha))
        dxSetBlendMode('blend')

        if self.animate then
            self.dashOffset = self.dashOffset + self.animationSpeed
            self:setSVGStrokeDashOffset(self.dashOffset)
        else
            self:setSVGStrokeDashOffset(newValue)
        end

end


function SVGCache:setSVGStrokeDashOffset(dashOffset)
    assert(self.elementSVG, "Elemento SVG não encontrado.")
    xmlNodeSetAttribute(self.elementSVG, 'stroke-dashoffset', dashOffset)
    svgSetDocumentXML(self.svg, self.xml)
end

function removeSVGCache(animation)
    for i = #animations, 1, -1 do
        if animations[i] == animation then
            table.remove(animations, i)
            break
        end
    end
end

function removeAllSVGCaches()
    animations = {}
end

local events = { };

_addEventHandler = addEventHandler
function addEventHandler(...)
    local args = {...}
    if args[1] == 'onClientRender' and type(args[3]) == 'function' then
        events[args[3]] = true
    end
    return _addEventHandler(...)
end

_removeEventHandler = removeEventHandler
function removeEventHandler(...)
    local args = {...}
    if args[1] == 'onClientRender' and type(args[3]) == 'function' then
        events[args[3]] = nil
    end
    return _removeEventHandler(...)
end

function isEventHandler(func)
    return events[func] or false
end

function string.change (s, t)
    if not s or type (s) ~= 'string' then
        return error ('Bad argument #1 got \''..type (s)..'\'.');
    end
    
    for w in s:gmatch ('${(%w+)}') do
        s = s:gsub ('${'..w..'}', tostring ((t and t[w]) or 'undefined'));
    end
    
    return s;
end

hexagons = {}

function createHexagon (width, height, stroke)
    if not hexagons[width] then 
        hexagons[width] = {}
    end
    if not hexagons[width][height] then 
        hexagons[width][height] = {}
    end
    if not hexagons[width][height][stroke] then 
        local w, h = width - stroke, height - stroke
        local a = {w / 2, 0}
        local b = {w, h / 4}
        local c = {w, h * 3 / 4}
        local d = {w / 2, h}
        local e = {0, h * 3 / 4}
        local f = {0, h / 4}
        local sideLength = math.sqrt((b[1]-a[1])^2 + (b[2]-a[2])^2)
        local perimeter = sideLength * 5.8
        local svgHexagon = string.change([[
            <svg width="${widht}" height="${height}">
                <polygon points="${1} ${2} ${3} ${4} ${5} ${6}" fill="none" stroke="#FFFFFF" stroke-width='${stroke}' stroke-dasharray='${perimeter}' stroke-dashoffset='0'/>
            </svg>
        ]], {
            ['widht'] = width,
            ['height'] = height,
            ['1'] = table.concat(a, ','),
            ['2'] = table.concat(b, ','),
            ['3'] = table.concat(c, ','),
            ['4'] = table.concat(d, ','),
            ['5'] = table.concat(e, ','),
            ['6'] = table.concat(f, ','),
            ['stroke'] = stroke,
            ['perimeter'] = tostring(math.floor(perimeter)),
        }
        )
        hexagons[width][height][stroke] = svgHexagon
        return svgHexagon
    else
        return hexagons[width][height][stroke]
    end
end