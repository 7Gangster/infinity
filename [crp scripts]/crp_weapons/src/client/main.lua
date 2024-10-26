local shader = {}
local myShader_raw_data = [[
	texture tex;
	technique replace {
		pass P0 {
			Texture[0] = tex;
		}
	}
]]

function clearShader ( weapon, texture )
    if shader[weapon][texture] then 
        if isElement(shader[weapon][texture]) then 
            destroyElement(shader[weapon][texture])
        end
        shader[weapon][texture] = nil
    end
end 
addEvent('weapon:clearShader', true)
addEventHandler('weapon:clearShader', resourceRoot, clearShader)

function applyTexture ( weapon, texture, image )

    print(weapon, texture, image)
    if not shader[weapon] then
         shader[weapon] = {} 
    end 
    if not shader[weapon][texture] then 
        shader[weapon][texture] = dxCreateShader(myShader_raw_data, 0, 20, false, 'object')
        engineApplyShaderToWorldTexture(shader[weapon][texture], texture, weapon)
    end

    if shader[weapon][texture] then 
        local txd = dxCreateTexture(image)
        dxSetShaderValue(shader[weapon][texture], 'tex', txd)
        destroyElement(txd)
    end

end
addEvent('weapon:applyTexture', true)
addEventHandler('weapon:applyTexture', resourceRoot, applyTexture)