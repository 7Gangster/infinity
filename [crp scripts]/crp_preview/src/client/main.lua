local previewObject = false
local inPreview = false

local evento = false

function previewRender ()
    dxDrawRectangle(0, 0, 1920, 1080, tocolor(0, 0, 0, 30))
    dxDrawText('PRESSIONE E PARA CONFIRMAR', 0+1, -49, 1920, 1080, tocolor(0, 0, 0), 1, 'default-bold', 'center', 'bottom', false, false, false, true)
    dxDrawText('PRESSIONE #0ACB06E#ffffff PARA CONFIRMAR', 0, -50, 1920, 1080, white, 1, 'default-bold', 'center', 'bottom', false, false, false, true)
    dxDrawText('PRESSIONE H PARA CANCELAR', 0+2, -28, 1920, 1080, tocolor(0, 0, 0), 1, 'default-bold', 'center', 'bottom', false, false, false, true)
    dxDrawText('PRESSIONE #CB2906H#FFFFFF PARA CANCELAR', 0, -30, 1920, 1080, white, 1, 'default-bold', 'center', 'bottom', false, false, false, true)
end

addEvent('previewObject', true)
addEventHandler('previewObject', root, function (model, event, offset)
    if not inPreview then 
        inPreview = true
        evento = event
        local x, y, z = getElementPosition(localPlayer)
        previewObject = createObject(tonumber(model), x, y, z)
        setElementCollisionsEnabled(previewObject, false)
        setElementFrozen(previewObject, true)
        setElementAlpha(previewObject, 200)
        local offset = offset or {0, 1, 0}
        attachElements(previewObject, localPlayer, unpack(offset))
        addEventHandler('onClientRender', root, previewRender)
    end
end)

function endPreview ( )
    if inPreview then 
        destroyElement(previewObject)
        previewObject = nil 
        evento = false
        removeEventHandler('onClientRender', root, previewRender)
        inPreview = false
    end
end

bindKey('e', 'down', function ( )
    if inPreview then 

        local x, y, z = getElementPosition(previewObject)
        local rx, ry, rz = getElementRotation(previewObject)
        local position = toJSON({x, y, z, rx, ry, rz})
        local model = getElementModel(previewObject)
        print(position)
        triggerServerEvent('CRP-CreateObject', localPlayer, localPlayer, model, position, evento)

        endPreview()
    end
end)

function rotate ( b, s )
    if inPreview then 
        if b == 'mouse_wheel_up' then 
            local rx, ry, rz = getElementRotation(previewObject)
            setElementRotation(previewObject, 0, 0, (rz-5))
        elseif b == 'mouse_wheel_down' then 
            local rx, ry, rz = getElementRotation(previewObject)
            setElementRotation(previewObject, 0, 0, (rz+5))
        end
    end
end
bindKey('mouse_wheel_up', 'down', rotate)
bindKey('mouse_wheel_down', 'down', rotate)

bindKey('h', 'down', function ( )
    if inPreview then 
        endPreview()
    end
end)

bindKey('backspace', 'down', function ( )
    if inPreview then 
        endPreview()
    end
end)

addCommandHandler('preview', function(cmd, model, event)
    triggerEvent('previewObject', localPlayer, tonumber(model), event)
end)