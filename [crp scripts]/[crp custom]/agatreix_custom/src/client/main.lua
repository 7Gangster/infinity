local texture = {}
local txd = {}
local myShader = {}
local mycharacter = {}

local myShader_raw_data = [[
	texture tex;
	technique replace {
		pass P0 {
			Texture[0] = tex;
		}
	}
]]

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- EVENTOS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

createEvent = function(eventname, ...)
	addEvent(eventname, true)
	addEventHandler(eventname, ...)
end

function applyTexture(element, shader, dir, type, txd)
	texture[element] = dxCreateTexture(dir)
	dxSetShaderValue(shader, "tex", texture[element])
	destroyElement(texture[element])
	texture[element] = {}
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- LIMPAR SHADERS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function clearShaderClothe(element, skin, variavel, stylo)
	if not myShader[element] then
		myShader[element] = {}
		texture[element] = {}
	end
	if not myShader[element][variavel] then
		myShader[element][variavel] = {}
	end

	if not myShader[element][variavel]then
		myShader[element][variavel] = {}
	end

	if not isElement(myShader[element][variavel]) then
		myShader[element][variavel] = {}
	end

	if isElement(myShader[element][variavel]) then
		destroyElement(myShader[element][variavel])
		myShader[element][variavel] = {}
	end

	if stylo then
		myShader[element][variavel] = dxCreateShader(myShader_raw_data, 0, 0, false, "ped")
		engineApplyShaderToWorldTexture(myShader[element][variavel], roupas_categorias[skin][variavel][stylo], element)
	end
end
addEvent("clearShaderClothe", true)
addEventHandler("clearShaderClothe", root, clearShaderClothe)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- SETROUPA
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function setRoupa(ply, skin, variavel, stylo, text)
	stylo = tonumber(stylo)
	text = tonumber(text)
	if roupas_categorias[skin][variavel][stylo] and text > 0 then
		clearShaderClothe(ply, skin, variavel, stylo)
		if skin == 7 then
			if variavel == "rosto" or variavel == "mao" or variavel == "pe2" or variavel == 'calca' or variavel == 'bone' then
				if variavel == "rosto" then
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/rosto/1/"..text..".png")
				elseif variavel == "mao" then
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/braco/1/"..text..".png")
				elseif variavel == "pe2" then
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/pe/1/"..text..".png")
				elseif variavel == 'calca' then 
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/"..variavel.."/"..stylo.."/"..text..".png")
					clearShaderClothe(ply, skin, 'cueca')
				elseif variavel == 'bone' then 
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/"..variavel.."/"..stylo.."/"..text..".png")
					clearShaderClothe(ply, skin, 'cabelo')
                end
			else
				applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/"..variavel.."/"..stylo.."/"..text..".png")
			end
		elseif skin == 280 then
			if variavel == "braco" or variavel == "rosto" or variavel == "cabelo" or variavel == "barba" or variavel == "sobrancelha" then
				if variavel == "rosto" then
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/"..variavel.."/1/"..text..".png")
				else
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/"..variavel.."/"..stylo.."/"..text..".png")
				end
			else
				applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/policia1/"..variavel.."/"..stylo.."/"..text..".png")
			end
		elseif skin == 281 then
			if variavel == "braco" or variavel == "rosto" or variavel == "cabelo" or variavel == "barba" or variavel == "sobrancelha" then
				if variavel == "rosto" then
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/"..variavel.."/1/"..text..".png")
				else
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/"..variavel.."/"..stylo.."/"..text..".png")
				end
			else
				applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/policia2/"..variavel.."/"..stylo.."/"..text..".png")
			end
		elseif skin == 282 then
			if variavel == "braco" or variavel == "rosto" or variavel == "cabelo" or variavel == "barba" or variavel == "sobrancelha" then
				if variavel == "rosto" then
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/"..variavel.."/1/"..text..".png")
				else
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/"..variavel.."/"..stylo.."/"..text..".png")
				end
			else
				applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/policia3/"..variavel.."/"..stylo.."/"..text..".png")
			end
		elseif skin == 283 then
			if variavel == "braco" or variavel == "rosto" or variavel == "cabelo" or variavel == "barba" or variavel == "sobrancelha" then
				if variavel == "rosto" then
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/"..variavel.."/1/"..text..".png")
				else
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/"..variavel.."/"..stylo.."/"..text..".png")
				end
			else
				applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/policia4/"..variavel.."/"..stylo.."/"..text..".png")
			end
		elseif skin == 284 then
			if variavel == "braco" or variavel == "rosto" or variavel == "cabelo" or variavel == "barba" or variavel == "sobrancelha" then
				if variavel == "rosto" then
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/"..variavel.."/1/"..text..".png")
				else
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/"..variavel.."/"..stylo.."/"..text..".png")
				end
			else
				applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/policia5/"..variavel.."/"..stylo.."/"..text..".png")
			end
		elseif skin == 285 then
			if variavel == "rosto" or variavel == "cabelo" or variavel == "barba" or variavel == "sobrancelha" then
				if variavel == "rosto" then
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/"..variavel.."/1/"..text..".png")
				else
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/"..variavel.."/"..stylo.."/"..text..".png")
				end
			else
				applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/medico/"..variavel.."/"..stylo.."/"..text..".png")
			end
		elseif skin == 9 then
			if variavel == "corpo" or variavel == "pe" or variavel == "pernas" or variavel == "braco" or variavel == "tenis" or variavel == "oculos" or variavel == "calca" or variavel == "pe2" or variavel == "mao" or variavel == "sobrancelha" then
				if variavel == "corpo" or variavel == "braco" or variavel == "mao" then
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/fem/corpo/1/"..text..".png")
				elseif variavel == "pe" or variavel == "pe2" then
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/fem/pe/1/"..text..".png")
				elseif variavel == "pernas" then
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/fem/pernas/1/"..text..".png")
				elseif variavel == "tenis" then
					if ""..stylo.."" == "1" or ""..stylo.."" == "2" then
						applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/tenis/"..stylo.."/"..text..".png")
					else
						applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/fem/tenis/"..stylo.."/"..text..".png")
					end
				elseif variavel == "oculos" then
					if ""..stylo.."" == "1" then
						applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/oculos/1/"..text..".png")
					else
						applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/fem/oculos/"..stylo.."/"..text..".png")
					end
				elseif variavel == "calca" then
					if ""..stylo.."" == "3" then
						applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/calca/7/"..text..".png")
						clearShaderClothe(ply, skin, 'calcinha')
					else
						applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/fem/calca/"..stylo.."/"..text..".png")
						clearShaderClothe(ply, skin, 'calcinha')
					end
				elseif variavel == "sobrancelha" then
					applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/roupas/sobrancelha/1/"..text..".png")
				end
			else
				applyTexture(ply, myShader[ply][variavel], "src/assets/clothes/fem/"..variavel.."/"..stylo.."/"..text..".png")
			end
		end
	elseif variavel and stylo < 1 then
		clearShaderClothe(ply, skin, variavel)
	end
end

function setPlayerRoupa(ply, nome1, nome2, nome3)
	if getElementModel(ply) == 7 or getElementModel(ply) == 280 or getElementModel(ply) == 281 or getElementModel(ply) == 282 or getElementModel(ply) == 283 or getElementModel(ply) == 284 or getElementModel(ply) == 285 or getElementModel(ply) == 9 then
		setRoupa(ply, getElementModel(ply), ""..nome1.."", ""..nome2.."", ""..nome3.."")
		if arrumar[tonumber(getElementModel(ply))][nome1..'-'..nome2] then
            for i,v in pairs(arrumar[tonumber(getElementModel(ply))][nome1..'-'..nome2]) do 
                --triggerClientEvent(root, 'setPlayerRoupa', root, player, i, v[1], pele)
				setRoupa(ply, getElementModel(ply), i, v[1], (getElementData(ply, 'Pele') or 1))
				print('trocou '..i..' '..v[1])
            end
			print('arrumou')
        end
	end
end
addEvent("setPlayerRoupa", true)
addEventHandler("setPlayerRoupa", root, setPlayerRoupa)

function setPlayerClothe(element, clothes)
	for i, _ in pairs(clothes) do
		setPlayerRoupa(element, i, clothes[i][1], clothes[i][2])
	end
end
createEvent("setPlayerClothe", getRootElement(),setPlayerClothe)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- VARIÁVEL
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function znquitcustom()
	if roupas_categorias[getElementModel(source)] then
		for variavel, _ in pairs(roupas_categorias[getElementModel(source)])do
			clearShaderClothe(source, getElementModel(source), variavel)
		end
		myShader[source] = nil
	end
end
addEventHandler("onClientPlayerQuit", getRootElement(), znquitcustom)