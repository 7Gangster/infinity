---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- RESOLUÇÃO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local screenW, screenH = guiGetScreenSize()
local resW, resH = 1366,768
local x, y = (screenW/resW), (screenH/resH)
local xlk, ylk = (screenW/screenW), (screenH/screenH)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- DX
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

tag = false
function zndxportas()
    tag = true
    for i,v in pairs(cfg.portas) do
        if v["tamanho"] then
            dist = v["tamanho"]
        else
            dist = 10
        end
        if (getDistanceBetweenPoints3D(v["tranca"][1], v["tranca"][2], v["tranca"][3], getElementPosition(getLocalPlayer()))) < dist then

            if tag == true then
                local objbb = getproxply(dist, "object")
                if objbb then
                    if getElementModel(objbb) == tonumber(v["model"]) then
                        local rx = {getScreenFromWorldPosition(v["tranca"][1], v["tranca"][2], v["tranca"][3]+1)}
                        if rx[1] and rx[2] and rx[3] then
                            if getElementData(objbb, "ZN-PortasStatus") == true then
                                dxDrawImage(rx[1], rx[2], x*30, y*30, "files/locked.png", 0, 0, 0, tocolor(255, 255, 255))
                            else
                                dxDrawImage(rx[1], rx[2], x*30, y*30, "files/unlocked.png", 0, 0, 0, tocolor(255, 255, 255))
                            end
                        end
                    end
                end
            end
        end
    end
end
addEventHandler("onClientRender", root, zndxportas)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- ABRIR
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function znabrirportas()
    tag = true
    for i,v in pairs(cfg.portas) do
        if v["tamanho"] then
            dist = v["tamanho"]
        else
            dist = 1.5
        end
 
            if (getDistanceBetweenPoints3D(v["tranca"][1], v["tranca"][2], v["tranca"][3], getElementPosition(getLocalPlayer()))) <= dist then


                if tag == true then
                    triggerServerEvent("ZN-DestrancarPortas", localPlayer, localPlayer, i)
                end
            end
    end
end
bindKey("e", "down", znabrirportas)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEL
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function math.percent(percent, maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        return (maxvalue*percent)/100
    end
    return false
end

---

function convertNumber (number)
    local formatted = number
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

---

function isCursorOnElement(posX, posY, width, height)
    if isCursorShowing() then
      local mouseX, mouseY = getCursorPosition()
      local clientW, clientH = guiGetScreenSize()
      local mouseX, mouseY = mouseX * clientW, mouseY * clientH
      if (mouseX > posX and mouseX < (posX + width) and mouseY > posY and mouseY < (posY + height)) then
        return true
      end
    end
    return false
end

---

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
    if
        type(sEventName) == 'string' and
        isElement(pElementAttachedTo) and
        type(func) == 'function'
    then
        local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)
        if type(aAttachedFunctions) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs(aAttachedFunctions) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

---

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 255, 0, 200);
		end

		if (not bgColor) then
			bgColor = borderColor;
		end

		--> Background
		dxDrawRectangle(x, y, w, h, bgColor);

		--> Border
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor); -- top
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor); -- bottom
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor); -- left
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor); -- right
	end
end

---

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

---

function convert(number)
    return string.sub(number, 1, 4)
end

---

function getproxply(distance, tipo)
	local x, y, z = getElementPosition(localPlayer)
	local dist = distance
	local id = false
    local players = getElementsByType(""..tipo.."")
    for i, v in ipairs (players) do
        if localPlayer ~= v then
            local pX, pY, pZ = getElementPosition (v)
            if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ) < dist then
                dist = getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)
                id = v
            end
        end
    end
    if id then
        return id
    else
        return false
    end
end