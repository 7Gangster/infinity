local screenW, screenH = guiGetScreenSize(  )
local x, y = screenW/1920, screenH/1080

local title = dxCreateFont('src/assets/Inter-SemiBold.ttf', 16, false, 'default')
local content = dxCreateFont('src/assets/Inter-Regular.ttf', 10, false, 'default')

local vehicles = {}

local slots = {349, 399, 449, 499, 549, 599, 649}

function dxDrawText2 (text, x, y, w, h, ...)
    return dxDrawText (text, x, y, (x + w), (y + h), ...)
end

render = function()
	dxDrawRoundedRectangle(544, 254, 832, 571, 10, tocolor(22, 22, 22))
	dxDrawRoundedRectangle(579, 288, 8, 27, 5, tocolor(143, 86, 216))
	dxDrawText2('Seus veiculos', x*597, y*290, x*444, y*23, white, 1, title, 'left', 'center')

	-- grid 
	dxDrawRectangle(x*624, y*349, x*672, y*50, tocolor(26, 26, 26))
	dxDrawRectangle(x*624, y*399, x*672, y*50, tocolor(24, 24, 24))
	dxDrawRectangle(x*624, y*449, x*672, y*50, tocolor(26, 26, 26))
	dxDrawRectangle(x*624, y*499, x*672, y*50, tocolor(24, 24, 24))
	dxDrawRectangle(x*624, y*549, x*672, y*50, tocolor(26, 26, 26))
	dxDrawRectangle(x*624, y*599, x*672, y*50, tocolor(24, 24, 24))
	dxDrawRectangle(x*624, y*649, x*672, y*50, tocolor(26, 26, 26))

	for i,v in ipairs(vehicles) do
		if v.garagem == 0 then 
			dxDrawText(v.nome..' | EM RUA | '..v.plate, 641, slots[i], 349, 638, white, 1, content, 'left', 'center')
		elseif v.garagem == 'Detran' then 
			dxDrawText(v.nome..' | APREENDIDO | '..v.plate, 641, slots[i], 349, 638, white, 1, content, 'left', 'center')
		else
			dxDrawText(v.nome..' | GARAGEM ('..v.garagem..') | '..v.plate, 641, slots[i], 349, 638, white, 1, content, 'left', 'center')
		end
	end

	dxDrawRoundedRectangle(624, 718, 214, 69, 5, tocolor(143, 86, 216))
	dxDrawRoundedRectangle(841, 718, 281, 69, 5, tocolor(143, 86, 216))
	dxDrawRoundedRectangle(1125, 718, 171, 69, 5, tocolor(143, 86, 216))

end

svgsRectangle = {};
function dxDrawRoundedRectangle(sx, sy, w, h, radius, color, post)
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
        dxDrawImage(x*sx, y*sy, x*w, y*h, svgsRectangle[radius][w][h], 0, 0, 0, color, post or false)
    end
end

