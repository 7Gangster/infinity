local screenW, screenH = guiGetScreenSize()
local x, y = screenW/1920, screenH/1080

local interactions = {}
local painel = false
local slots = {}
local olho = nil

local font = dxCreateFont('src/assets/fonts/Poppins-Regular.ttf', y*16, false)
local font2 = dxCreateFont('src/assets/fonts/Poppins-Regular.ttf', y*14, false)

local eyeRender = function()
    if getElementHit() then
        dxSetBlendMode('add')
        dxDrawImage(x*(1920/2)+10, y*(1080/2)-15, x*30, y*30, img.eye, 0, 0, 0, tocolor(Config.Identidade.CorTemaRGB[1], Config.Identidade.CorTemaRGB[2], Config.Identidade.CorTemaRGB[3]))
        dxSetBlendMode('blend')
    else
        dxDrawImage(x*(1920/2)+10, y*(1080/2)-15, x*30, y*30, img.eye, 0, 0, 0, tocolor(255, 255, 255, 100))
    end
end

local interactionRender = function()
    dxSetBlendMode('add')
    dxDrawImage(x*(1920/2)-15, y*(1080/2)-15, x*30, y*30, img.eye, 0, 0, 0, tocolor(Config.Identidade.CorTemaRGB[1], Config.Identidade.CorTemaRGB[2], Config.Identidade.CorTemaRGB[3]))
    dxSetBlendMode('blend')

    for i,v in ipairs(interactions) do 
        if i == 1 then 
            dxDrawText(v.nome, 982, 530, (89+2), (18+2), tocolor(0, 0, 0, 225), 1, font, 'left', 'center')
            dxDrawText(v.nome, 982, 530, 89, 18, isCursorOnElement(x*982, y*530, x*200, y*18) and tocolor(200, 200, 200) or white, 1, font, 'left', 'center')
            slots[i] = 530
        else
            dxDrawText(v.nome, 982, (slots[i-1]+y*(20+15)), (89+2), (18+2), tocolor(0, 0, 0, 225), 1, font, 'left', 'center')
            dxDrawText(v.nome, 982, (slots[i-1]+y*(20+15)), 89, 18, isCursorOnElement(x*982, y*(slots[i-1]+y*(20+15)), x*200, y*18) and tocolor(200, 200, 200) or white, 1, font, 'left', 'center')
            slots[i] = (slots[i-1]+y*(20+15))
        end
    end
end

addEventHandler('onClientKey', root, function(b, s)
    if getElementData(localPlayer, 'ID') then 
        if b == Config.keyOlho then 
            if s then 
                if painel == false then
                    if not isPedInVehicle(localPlayer) then 
                        addEventHandler('onClientRender', root, eyeRender)
                        olho = true
                    end
                else
                    removeEventHandler('onClientRender', root, interactionRender)
                    painel = false
                    showCursor(false)
                end
            else
                if painel == false then
                    olho = false
                    removeEventHandler('onClientRender', root, eyeRender)
                end
            end
        elseif b == 'mouse1' then 
            if s then 
                if getElementHit() then
                    if not painel and olho then
                        interactions = {}
                        showCursor(true)
                        olho = false
                        removeEventHandler('onClientRender', root, eyeRender)
                        target = getElementHit()
                        painel = true
                        triggerServerEvent('getInteractions', localPlayer, localPlayer, target)
                        addEventHandler('onClientRender', root, interactionRender)
                    end
                end
            end
        end
    end
    
end)

addEventHandler('onClientClick', root, function(b, s)
    if b == 'left' and s == 'down' then 
        if painel then 
            for i,v in ipairs(interactions) do 
                if slots[i] then
                    if isCursorOnElement(x*982, y*slots[i], x*200, y*18) then 
                        if v.close then 
                            removeEventHandler('onClientRender', root, interactionRender)
                            showCursor(false)
                        end
                        if v.execute == 'casa >> bau' then 
                            triggerServerEvent(v.execute, root, localPlayer)
                            target = nil 
                            painel = false
                            return true
                        end
                        if v.execute then 
                            triggerServerEvent(v.execute, localPlayer, localPlayer, target)
                        end
                        target = nil 
                        painel = false
                    end
                end
            end
        end
    end
end)

addEvent('updateInteractions', true)
addEventHandler('updateInteractions', root, function(table)
    interactions = table
end)


getElementHit = function ()
    local tx, ty, tz = getWorldFromScreenPosition ( (screenW/2), (screenH/2), 50 )
    local px, py, pz = getCameraMatrix()
    local hiting, x, y, z, elementHit = processLineOfSight ( px, py, pz, tx, ty, tz, true, true, true, true, true, false, false, false, getLocalPlayer() )
    if hiting then
        if elementHit then
            for i,v in ipairs(Config.elementsTarget) do 
                if getElementType(elementHit) == v then 
                    if getElementType(elementHit) == 'object' then 
                        if not isValidObject(getElementModel(elementHit)) then 
                            return false
                        end
                    end

                    if getDistanceElements(localPlayer, elementHit) <= (Config.distance[getElementType(elementHit)] or 3) then 
                        return elementHit
                    end

                end
            end
        end
    end
    return false
end

isValidObject = function (id)
    for i,v in ipairs(Config.objectsID) do 
        if id == v then 
            return true
        end
    end
    return false
end

getDistanceElements = function(element, elementTarget)
    local x, y, z = getElementPosition(element)
    local x2, y2, z2 = getElementPosition(elementTarget)
    local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
    return distance
end

--[[
    ================================================================================
                                BARRA DE PROGRESSO
    ================================================================================
]]

barra = nil
renderBarra = function()
    if barra then 
        local progress = interpolateBetween(0, 0, 0, 100, 0, 0, (getTickCount() - barra.tick)/barra.tempo, 'Linear')
        dxDrawRoundedRectangle(x*782, y*916, x*355, y*42, tocolor(33, 33, 33), 5)
        dxDrawRectangle(x*788, y*922, x*343, y*30, tocolor(43, 43, 43))
        dxDrawRectangle(x*788, y*922, x*343/100*progress, y*30, tocolor(Config.Identidade.CorTemaRGB[1], Config.Identidade.CorTemaRGB[2], Config.Identidade.CorTemaRGB[3]))
        dxDrawText(barra.texto, 788, 922, 343, 30, white, 1, font2, 'center', 'center')

        if (getTickCount() - barra.tick)/barra.tempo >= 1 then 
            removeEventHandler('onClientRender', root, renderBarra)
            barra = nil
        end

    end
end

addEvent('interaction >> progressbar', true)
addEventHandler('interaction >> progressbar', root, function(text, time)
    if not barra then 
        addEventHandler('onClientRender', root, renderBarra)
        barra = {texto = text, tempo = time, tick = getTickCount()}
    end
end)

addEvent('getNitro', true)
addEventHandler('getNitro', root, function(vehicle)
    triggerServerEvent('getNitro', root, vehicle, getVehicleNitroCount(vehicle))
end)

_dxDrawText = dxDrawText
function dxDrawText (text, sx, sy, sw, sh, ...)
    local sx, sy, sw, sh = x * sx, y * sy, x * sw, y * sh

    return _dxDrawText (text, sx, sy, (sx + sw), (sy + sh), ...)
end

function isCursorOnElement(x, y, w, h)
    if (not isCursorShowing()) then
        return false
    end
    local mx, my = getCursorPosition()
    local fullx, fully = guiGetScreenSize()
    cursorx, cursory = mx*fullx, my*fully
    if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
        return true
    else
        return false
    end
end
