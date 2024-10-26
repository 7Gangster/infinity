local renderTarget = {}
local veiculos = {}

local estoque = {}

local title = dxCreateFont('src/assets/Inter-SemiBold.ttf', 16, false)
local content = dxCreateFont('src/assets/Inter-Regular.ttf', 10, false)

for i,v in ipairs(Config.Veiculos) do 
    renderTarget[i] = dxCreateRenderTarget(500, 500, true)
end

addEventHandler('onClientRender', root, 
function()

    for i,v in ipairs(Config.Veiculos) do 
        local x, y, z = getElementPosition(localPlayer)
        if getDistanceBetweenPoints3D(x, y, z, v.position[1], v.position[2], v.position[3]) <= 5 then
            if getVehicleEstoque(i) == 0 then return end
            dxSetRenderTarget(renderTarget[i], true)

            dxDrawRectangle(0, 0, 500, 218, tocolor(21, 21, 21, 255))
            dxDrawText(v.name, 0, 0, 500, 54, white, 1, title, 'center', 'center')
            dxDrawRectangle(73, 53, 354, 1, tocolor(255, 255, 255))
            dxDrawText('#929292Tamanho do Porta-Malas: #FFFFFF'..(Config.porta_malas[v.model] or 10)..'kg \n \n#929292Velocidade Maxima: #FFFFFF'..v.max_velocity..' \n \n#929292Estoque: #FFFFFF'..getVehicleEstoque(i)..' \n \n#929292Preço: #FFFFFF$ '..v.preco, 24, 66, 457, 132, white, 1, content, 'left', 'top', false, true, false, true)

            dxSetRenderTarget()

            if v.name == 'BENSON' or v.name == 'YANKEE' or v.name == 'BOXVILLE' then 
                dxDrawMaterialLine3D( v.position[1], v.position[2]+3, v.position[3]+0.5 +1, v.position[1], v.position[2]+3, v.position[3], renderTarget[i], 2, tocolor( 255, 255, 255, 255 ))
            else
                dxDrawMaterialLine3D( v.position[1], v.position[2], v.position[3]+0.5 +1.5, v.position[1], v.position[2], v.position[3]+0.5, renderTarget[i], 2, tocolor( 255, 255, 255, 255 ))
            end
        end
    end

end)

addEvent('setCollision', true)
addEventHandler('setCollision', root, function(element)
    setElementCollidableWith(element, localPlayer, false)
end)

addEvent('updateEstoque', true)
addEventHandler('updateEstoque', root, function(table)
    estoque = table
end)

function getVehicleEstoque(id)
    local number = 0
    for i,v in ipairs(estoque) do 
        if v[1] == id then 
            number = v[2]
        end
    end
    return number
end