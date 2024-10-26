screenX, screenY = guiGetScreenSize()
screen = {guiGetScreenSize ()}
resolution = {1920, 1080}
sx, sy = screen[1] / resolution[1], screen[2] / resolution[2]

renderData = {
	hudVisibleNumber = 0,
	editorActive = false,

	showTrashTray = false,
	trayInterpolationInverse = 0,
	trayInterpolationStart = false,
	trayY = 99999,
	trayArrowActive = false,
	trayScrollX = 0,
	trayScrollY = 0,

	moving = {},
	resizing = false,
	selection = false,
	selectedHUD = {},
	inTrash = {},

	countedFrames = 0,
	
	lastBarValue = {},
	interpolationStartValue = {},
	barInterpolation = {},

	canEditorMusic = true,
	canEditorSoundEffects = true,

	activeDirectX = false,
	lastActiveDirectX = false,

	closeTrashColor = {255, 255, 255},

	alphaMul = 0,
	alphaInterpolationInverse = false,
	alphaInterpolationStart = false,

	showNumberPlates = false,

	chatType = 0
}

function reMap(x, in_min, in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1)

function resp(num)
	return num * responsiveMultipler
end

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

function getResponsiveMultipler()
	return responsiveMultipler
end

local moneyChangeSoundTick = 0

occupiedVehicle = false

addEventHandler("onClientVehicleEnter", getRootElement(),
	function (player)
		if player == localPlayer and occupiedVehicle ~= source then
			occupiedVehicle = source
		end
	end
)

addEventHandler("onClientVehicleExit", getRootElement(),
	function (player)
		if player == localPlayer and occupiedVehicle == source then
			occupiedVehicle = false
		end
	end
)

addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		if occupiedVehicle == source then
			occupiedVehicle = false
		end
	end
)

addEventHandler("onClientVehicleExplode", getRootElement(),
	function ()
		if occupiedVehicle == source then
			occupiedVehicle = false
		end
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if source == localPlayer then
			if dataName == "loggedIn" then
				if not getElementData(localPlayer, "loggedIn") then
					renderData.loggedIn = true
					
					renderData.currentMoney = getElementData(localPlayer, "char.Money") or 0

					checkRadioChannels()
				else
					renderData.loggedIn = false
				end
			elseif dataName == "char.Money" then
				local charMoney = getElementData(localPlayer, "char.Money")
				if charMoney then
					renderData.currentMoney = charMoney

					if oldValue then
						local changeValue = nil

						if oldValue < charMoney then
							changeValue = charMoney - oldValue
						elseif charMoney < oldValue then
							changeValue = (oldValue - charMoney) * -1
						end

						if renderData.moneyChangeTick and getTickCount() >= renderData.moneyChangeTick and getTickCount() <= renderData.moneyChangeTick + 5000 then
							renderData.moneyChangeValue = renderData.moneyChangeValue + changeValue
						else
							renderData.moneyChangeValue = changeValue
						end

						if getTickCount() - moneyChangeSoundTick >= 1000 then
							playSound("files/moneychange.ogg")
							moneyChangeSoundTick = getTickCount()
						end
					end

					renderData.moneyChangeTick = getTickCount()
				end
			elseif dataName == "char.Hunger" then
				renderData.currentHunger = getElementData(localPlayer, "char.Hunger")
			elseif dataName == "char.Thirst" then
				renderData.currentThirst = getElementData(localPlayer, "char.Thirst")
			elseif dataName == "bloodLevel" then
				renderData.bloodLevel = getElementData(localPlayer, "bloodLevel") or 100
			elseif dataName == "playerID" then
				renderData.playerID = getElementData(localPlayer, "playerID")
			elseif dataName == "char.Name" then
				renderData.characterName = getElementData(localPlayer, "char.Name")
			elseif dataName == "acc.adminLevel" then
				renderData.adminLevel = getElementData(localPlayer, "acc.adminLevel")
			end
		end
	end
)

deepcopy = function (original)
	local copy
	
	if type(original) == "table" then
		copy = {}
		
		for k, v in next, original, nil do
			copy[deepcopy(k)] = deepcopy(v)
		end
		
		setmetatable(copy, deepcopy(getmetatable(original)))
	else
		copy = original
	end
	
	return copy
end

local function spairs(t, order)
	local keys = {}

	for k in pairs(t) do
		keys[#keys + 1] = k
	end

	if order then
		table.sort(keys,
			function (a, b)
				return order(t, a, b)
			end
		)
	else
		table.sort(keys)
	end

	local i = 0
	return function ()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

local availableWidgets = {
	"clock", "fps", "ping", "actionbar", "bars", "money", "minimap", "alert", "oocchat", "radiochannel", "speedo", "videostats"
}

spairs(availableWidgets)

widgets = {
	videostats = {
		sizeX = respc(300),
		sizeY = respc(100),
		posX = 0,
		posY = 0,
		inTrash = true
	},
	speedo = {
		sizeX = respc(492),
		sizeY = respc(256),
		posX = screenX - respc(512),
		posY = screenY - respc(256) - respc(20),
		placeholder = "Painel do VEÍCULO"
	},
	radiochannel = {
		sizeX = respc(250),
		sizeY = respc(30) * 2,
		posX = 0,
		posY = 0,
		inTrash = true,
		placeholder = "RADIO INFO"
	},
	
	alert = {
		sizeX = respc(330),
		sizeY = respc(42),
		posX = resp(12),
		posY = screenY - resp(12) - respc(190) - respc(32) - respc(42) - resp(12),
		placeholder = "notificações"
	},
	minimap = {
		sizeX = respc(330),
		sizeY = respc(190) + resp(30),
		posX = resp(12),
		posY = screenY - resp(12) - respc(190) - resp(30),
		resizable = true,
		resizingLimitMin = {respc(200), respc(110)},
		resizingLimitMax = {respc(625), respc(495)}
	},
	money = {
		sizeX = respc(250),
		sizeY = respc(30),
		posX = screenX - resp(250) - respc(20),
		posY = resp(12),
		resizable = true,
		resizingLimitMin = {respc(100), respc(30)},
		resizingLimitMax = {respc(350), respc(30)},
	},
	bars = {
		sizeX = respc(150),
		sizeY = respc(12) * 4 + respc(7) * 3,
		posX = screenX - resp(150) - respc(20),
		posY = resp(12) + respc(35),
		resizable = true,
		resizingLimitMin = {respc(100), respc(12) * 4 + respc(7) * 3},
		resizingLimitMax = {respc(350), respc(12) * 4 + respc(7) * 3},
	},
	actionbar = {
		sizeX = 251,
		sizeY = 46,
		posX = screenX / 2 - 251 / 2,
		posY = screenY - 5 - 46
	},
	clock = {
		inTrash = true,
		sizeX = respc(100),
		sizeY = respc(25),
		posX = 0,
		posY = 0
	},
	fps = {
		inTrash = true,
		sizeX = respc(100),
		sizeY = respc(25),
		posX = 0,
		posY = 0
	},
	ping = {
		inTrash = true,
		sizeX = respc(150),
		sizeY = respc(25),
		posX = 0,
		posY = 0
    },
}

defaultWidgets = deepcopy(widgets)

render = {}
hudrender = {}

function resetHudElement(element, toTrash)
	renderData.moving = {}
	renderData.resizing = false

	if element == "all" then
		renderData.selectedHUD = {}
		renderData.inTrash = {}

		for k in pairs(widgets) do
			widgets[k].posX = defaultWidgets[k].posX
			widgets[k].posY = defaultWidgets[k].posY
			widgets[k].sizeX = defaultWidgets[k].sizeX
			widgets[k].sizeY = defaultWidgets[k].sizeY

			if not toTrash then
				widgets[k].inTrash = defaultWidgets[k].inTrash
			else
				widgets[k].inTrash = true
			end

			if widgets[k].inTrash then
				renderData.inTrash[k] = true
			end
		end
	else
		widgets[element].posX = defaultWidgets[element].posX
		widgets[element].posY = defaultWidgets[element].posY
		widgets[element].sizeX = defaultWidgets[element].sizeX
		widgets[element].sizeY = defaultWidgets[element].sizeY

		if not toTrash then
			widgets[element].inTrash = defaultWidgets[element].inTrash
		else
			widgets[element].inTrash = true
		end

		if widgets[element].inTrash then
			renderData.inTrash[element] = true
		end
	end
end

function resetHudElements()
	resetHudElement("all")
	savePositions()
end
--addCommandHandler("resethud", resetHudElements)

function isHudElementVisible(name)
	if widgets[name] then
		if not widgets[name].inTrash or (widgets[name].inTrash and renderData.showTrashTray) then
			return true
		end
	end
	
	return false
end

function isHudVisible()
	return not renderData.loggedIn and renderData.hudVisibleNumber < 1
end

function toggleHUD(state)
	if not state then
		renderData.hudVisibleNumber = renderData.hudVisibleNumber + 1
	elseif renderData.hudVisibleNumber > 0 then
		renderData.hudVisibleNumber = renderData.hudVisibleNumber - 1
	end

	if renderData.hudVisibleNumber <= 0 then
		processActionBarShowHide(true)
	else
		processActionBarShowHide(false)
	end
end

addCommandHandler('tghud', toggleHUD)


addEventHandler("onClientResourceStop", resourceRoot,
	function ()
		setElementData(localPlayer, "isEditingHUD", false)
	end
)

function getHudCursorPos()
	local cx, cy = getCursorPosition()
	if tonumber(cx) and tonumber(cy) then
		return cx * screenX, cy * screenY
	end
	return false, false
end

function dxDrawBorderText(text, x, y, w, h, color, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
	if not font then
		print("Font not found. Text: " .. text)
		return
	end

	local textWithoutColors = string.gsub(text, "#......", "")
	_dxDrawText(textWithoutColors, x - 1, y - 1, w - 1, h - 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
	_dxDrawText(textWithoutColors, x - 1, y + 1, w - 1, h + 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
	_dxDrawText(textWithoutColors, x + 1, y - 1, w + 1, h - 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
	_dxDrawText(textWithoutColors, x + 1, y + 1, w + 1, h + 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
	_dxDrawText(text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
end

function dxDrawImageBorder(x, y, w, h, image, r, rx, ry, color, postGUI)
	_dxDrawImage(x - 1, y - 1, w, h, image, r, rx, ry, tocolor(0, 0, 0, 200), postGUI)
	_dxDrawImage(x - 1, y + 1, w, h, image, r, rx, ry, tocolor(0, 0, 0, 200), postGUI)
	_dxDrawImage(x + 1, y - 1, w, h, image, r, rx, ry, tocolor(0, 0, 0, 200), postGUI)
	_dxDrawImage(x + 1, y + 1, w, h, image, r, rx, ry, tocolor(0, 0, 0, 200), postGUI)
	_dxDrawImage(x, y, w, h, image, r, rx, ry, color, postGUI)
end

function dxDrawImageSectionBorder(x, y, w, h, ux, uy, uw, uh, image, r, rx, ry, color, postGUI)
	_dxDrawImageSection(x - 1, y - 1, w, h, ux, uy, uw, uh, image, r, ry, rz, tocolor(0, 0, 0, 200), postGUI)
	_dxDrawImageSection(x - 1, y + 1, w, h, ux, uy, uw, uh, image, r, ry, rz, tocolor(0, 0, 0, 200), postGUI)
	_dxDrawImageSection(x + 1, y - 1, w, h, ux, uy, uw, uh, image, r, ry, rz, tocolor(0, 0, 0, 200), postGUI)
	_dxDrawImageSection(x + 1, y + 1, w, h, ux, uy, uw, uh, image, r, ry, rz, tocolor(0, 0, 0, 200), postGUI)
	_dxDrawImageSection(x, y, w, h, ux, uy, uw, uh, image, r, ry, rz, color, postGUI)
end


function dxDrawRoundedRectangle(x, y, w, h, color, radius, postGUI, subPixelPositioning)
	radius = radius or 5
	color = color or tocolor(0, 0, 0, 200)
	
	_dxDrawImage(x, y, radius, radius, corner, 0, 0, 0, color, postGUI)
	_dxDrawImage(x, y + h - radius, radius, radius, corner, 270, 0, 0, color, postGUI)
	_dxDrawImage(x + w - radius, y, radius, radius, corner, 90, 0, 0, color, postGUI)
	_dxDrawImage(x + w - radius, y + h - radius, radius, radius, corner, 180, 0, 0, color, postGUI)
	
	_dxDrawRectangle(x, y + radius, radius, h - radius * 2, color, postGUI, subPixelPositioning)
	_dxDrawRectangle(x + radius, y, w - radius * 2, h, color, postGUI, subPixelPositioning)
	_dxDrawRectangle(x + w - radius, y + radius, radius, h - radius * 2, color, postGUI, subPixelPositioning)
end

function playSoundEx(path)
	if renderData.canEditorSoundEffects then
		playSound(path)
	end
end

function dxDrawFiveBar(x, y, w, h, borderSize, activeColor, value, name, amountOfSegments, bgColor, borderColor, postGUI)
	bgColor = bgColor or tocolor(0, 0, 0, 155)
	borderColor = borderColor or tocolor(0, 0, 0, 200)
	amountOfSegments = amountOfSegments or 2

	w = math.ceil(w) - 2 * (amountOfSegments - 1)
	h = math.ceil(h)
	w = w / amountOfSegments

	if value > 100 then
		value = 100
	end

	local interpolation = false

	if name then
		if renderData.lastBarValue[name] then
			if renderData.lastBarValue[name] ~= value then
				renderData.barInterpolation[name] = getTickCount()
				renderData.interpolationStartValue[name] = renderData.lastBarValue[name]
				renderData.lastBarValue[name] = value
			end
		else
			renderData.lastBarValue[name] = value
		end

		if renderData.barInterpolation[name] then
			interpolation = interpolateBetween(renderData.interpolationStartValue[name], 0, 0, value, 0, 0, (getTickCount() - renderData.barInterpolation[name]) / 500, "OutQuad")
		end
	end

	if interpolation then
		value = interpolation
	end

	local progressPerSegment = 100 / amountOfSegments
	local remainingProgress = value % progressPerSegment
	local segmentsFull = math.floor(value / progressPerSegment)
	local segmentsInUse = math.ceil(value / progressPerSegment)

	local doubleBorder = borderSize * borderSize

	for i = 1, amountOfSegments do
		local x2 = x + (w + 2) * (i - 1)

		if borderSize ~= 0 then
			_dxDrawRectangle(x2, y, w, borderSize, borderColor, postGUI)
			_dxDrawRectangle(x2, y + h - borderSize, w, borderSize, borderColor, postGUI)
			_dxDrawRectangle(x2, y + borderSize, borderSize, h - doubleBorder, borderColor, postGUI)
			_dxDrawRectangle(x2 + w - borderSize, y + borderSize, borderSize, h - doubleBorder, borderColor, postGUI)
		end

		_dxDrawRectangle(x2 + borderSize, y + borderSize, w - doubleBorder, h - doubleBorder, bgColor, postGUI)

		if i <= segmentsFull then
			_dxDrawRectangle(x2 + borderSize, y + borderSize, w - doubleBorder, h - doubleBorder, activeColor, postGUI)
		elseif i == segmentsInUse and remainingProgress > 0 then
			_dxDrawRectangle(x2 + borderSize, y + borderSize, (w - doubleBorder) / progressPerSegment * remainingProgress, h - doubleBorder, activeColor, postGUI)
		end
	end
end

function formatNumber(amount, stepper)
	local left, center, right = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1" .. (stepper or " "))) .. right
end
local actionBarState = true

function processActionBarShowHide(state)
	if actionBarState ~= state then
		actionBarState = state
	end
end

local theX = screenX / 2
local theY = screenY / 2

local rightSideIconSize = respc(36)
local rightSideIconOffset = respc(10)

local rightSideWidth = respc(64)
local rightSideHeight = (rightSideIconSize + rightSideIconOffset) * 4 + rightSideIconOffset

local rightSideX = screenX - resp(12) - rightSideWidth
local rightSideY = (screenY - rightSideHeight) / 2

renderData.iconInterpolationInverse = {}
renderData.iconInterpolationStart = {}
renderData.sideIconColors = {}
renderData.sideIconTooltipAlphas = {}

function drawRightSideIcon(i, state, onIcon, offIcon, key, tooltip, hoverColor)
	local x = math.floor(rightSideX + (rightSideWidth - rightSideIconSize) / 2)
	local y = math.floor(rightSideY + rightSideIconOffset * i + rightSideIconSize * (i - 1))

	if not renderData.sideIconColors[key] then
		renderData.sideIconColors[key] = {255, 255, 255}
		renderData.sideIconTooltipAlphas[key] = 0
	end

	if renderData.cursorX and renderData.cursorY and renderData.cursorX >= x and renderData.cursorY >= y and renderData.cursorX <= x + rightSideIconSize and renderData.cursorY <= y + rightSideIconSize then
		renderData.activeDirectX = key

		if not renderData.iconInterpolationStart[key] then
			renderData.iconInterpolationInverse[key] = false
			renderData.iconInterpolationStart[key] = getTickCount()
		end
	else
		if renderData.iconInterpolationStart[key] then
			renderData.iconInterpolationInverse[key] = getTickCount()
			renderData.iconInterpolationStart[key] = false
		end
	end

	if renderData.iconInterpolationStart[key] then
		local progress = (getTickCount() - renderData.iconInterpolationStart[key]) / 300

		renderData.sideIconColors[key] = {interpolateBetween(
			renderData.sideIconColors[key][1], renderData.sideIconColors[key][2], renderData.sideIconColors[key][3],
			hoverColor[1], hoverColor[2], hoverColor[3],
			progress, "Linear")
		}

		renderData.sideIconTooltipAlphas[key] = interpolateBetween(
			renderData.sideIconTooltipAlphas[key], 0, 0,
			1, 0, 0, 
			progress, "Linear"
		)
	elseif renderData.iconInterpolationInverse[key] then
		local progress = (getTickCount() - renderData.iconInterpolationInverse[key]) / 300

		renderData.sideIconColors[key] = {interpolateBetween(
			renderData.sideIconColors[key][1], renderData.sideIconColors[key][2], renderData.sideIconColors[key][3],
			255, 255, 255,
			progress, "Linear")
		}

		renderData.sideIconTooltipAlphas[key] = interpolateBetween(
			renderData.sideIconTooltipAlphas[key], 0, 0,
			0, 0, 0,
			progress, "Linear"
		)
	end

	--_dxDrawImage(x, y, rightSideIconSize, rightSideIconSize, "files/icons/" .. (state and onIcon or offIcon) .. ".png", 0, 0, 0, tocolor(renderData.sideIconColors[key][1], renderData.sideIconColors[key][2], renderData.sideIconColors[key][3], 255 * renderData.trashTrayAnimToAlpha * renderData.alphaMul))

	if tooltip and renderData.sideIconTooltipAlphas[key] > 0 then
		local w = dxGetTextWidth(tooltip, 1, RobotoL) + respc(15)
		local h = RobotoLH * 1.5

		x = x - rightSideIconOffset * 2 - w
		y = rightSideY + rightSideIconOffset * i + rightSideIconSize * (i - 0.5)

		_dxDrawRectangle(x, y - h / 2, w, h, tocolor(0, 0, 0, 125 * renderData.trashTrayAnimToAlpha * renderData.sideIconTooltipAlphas[key] * renderData.alphaMul))
		_dxDrawText(tooltip, x, y - h / 2, rightSideX - rightSideIconOffset, y + h / 2, tocolor(255, 255, 255, 255 * renderData.trashTrayAnimToAlpha * renderData.sideIconTooltipAlphas[key] * renderData.alphaMul), 1, RobotoL, "center", "center")
	end

	return i + 1
end

function drawSideGUI()
	renderData.cursorX, renderData.cursorY = getHudCursorPos()

	if renderData.showTrashTray then
		if renderData.cursorX >= screenX - 12 - respc(48) and renderData.cursorY >= renderData.trayY + 12 and renderData.cursorX <= screenX - 12 and renderData.cursorY <= renderData.trayY + 12 + respc(48) then
			renderData.activeDirectX = "closeTrash"

			if not renderData.iconInterpolationStart.closeTrash then
				renderData.iconInterpolationInverse.closeTrash = false
				renderData.iconInterpolationStart.closeTrash = getTickCount()
			end
		else
			if renderData.iconInterpolationStart.closeTrash then
				renderData.iconInterpolationInverse.closeTrash = getTickCount()
				renderData.iconInterpolationStart.closeTrash = false
			end
		end

		if renderData.iconInterpolationStart.closeTrash then
			local progress = (getTickCount() - renderData.iconInterpolationStart.closeTrash) / 300

			renderData.closeTrashColor = {interpolateBetween(
				renderData.closeTrashColor[1], renderData.closeTrashColor[2], renderData.closeTrashColor[3],
				215, 89, 89,
				progress, "Linear")
			}
		elseif renderData.iconInterpolationInverse.closeTrash then
			local progress = (getTickCount() - renderData.iconInterpolationInverse.closeTrash) / 300

			renderData.closeTrashColor = {interpolateBetween(
				renderData.closeTrashColor[1], renderData.closeTrashColor[2], renderData.closeTrashColor[3],
				255, 255, 255,
				progress, "Linear")
			}
		end

		_dxDrawImage(screenX - 12 - respc(48), renderData.trayY + 10, respc(48), respc(48), "files/icons/exit.png", 0, 0, 0, tocolor(renderData.closeTrashColor[1], renderData.closeTrashColor[2], renderData.closeTrashColor[3], 255 * renderData.alphaMul))
	end

	renderData.trashTrayAnimToAlpha = reMap(renderData.trayY, 0, screenY - 10, 0, 1)

	if renderData.trashTrayAnimToAlpha > 0.1 then
		dxDrawRoundedRectangle(rightSideX, rightSideY, rightSideWidth, rightSideHeight, tocolor(0, 0, 0, 100 * renderData.trashTrayAnimToAlpha * renderData.alphaMul))

		local k = 1
		k = drawRightSideIcon(k, true, "save", "save", "saveHUD", "Salvar e sair", {95, 195, 135})
		k = drawRightSideIcon(k, true, "exit", "exit", "exitEditor", "Sair sem salvar", {215, 89, 89})
		k = drawRightSideIcon(k, renderData.canEditorMusic, "musicon", "musicoff", "togMusic", renderData.canEditorMusic and "Desativar música de fundo" or "Ativar música de fundo", {50, 179, 239})
		k = drawRightSideIcon(k, renderData.canEditorSoundEffects, "soundon", "soundoff", "togSounds", renderData.canEditorSoundEffects and "Desativar efeitos sonoros" or "Ativar efeitos sonoros", {50, 179, 239})

		if #renderData.selectedHUD > 0 and not renderData.resizing then
			rightSideHeight = (rightSideIconSize + rightSideIconOffset) * (k + 1) + rightSideIconOffset
			rightSideY = (screenY - rightSideHeight) / 2

			k = drawRightSideIcon(k, true, "reset", "reset", "resetWidget", "Resetar item(s) selecionado(s)", {50, 179, 239})
			k = drawRightSideIcon(k, true, "trash", "trash", "removeWidget", "Remover item(s) selecionado(s)", {215, 89, 89})
		else
			rightSideHeight = (rightSideIconSize + rightSideIconOffset) * (k - 1) + rightSideIconOffset
			rightSideY = (screenY - rightSideHeight) / 2
		end
	end
end

function renderTheLogoSARP()
	if not renderData.logoAnimStart then
		renderData.logoAnimStart = getTickCount()
	end

	local tickCount = getTickCount()
	local progress1 = (tickCount - (renderData.logoAnimStart + 1000)) / 500
	local progress2 = (tickCount - (renderData.logoAnimStart + 1500)) / 500
	local progress3 = (tickCount - (renderData.logoAnimStart + 2000)) / 500
	local progress4 = (tickCount - (renderData.logoAnimStart + 2500)) / 500
	local progress5 = (tickCount - (renderData.logoAnimStart + 3000)) / 500
	local progress6 = (tickCount - (renderData.logoAnimStart + 3500)) / 500

	local x, y, s = 0, 0, 1
	local r, g, b = 0, 170, 255
	local a = 0

	if progress1 > 0 then
		s = interpolateBetween(
			1, 0, 0,
			0.85, 0, 0,
			progress1, "OutQuad")
	end
	if progress2 > 0 then
		s = interpolateBetween(
			0.85, 0, 0,
			1, 0, 0,
			progress2, "OutQuad")
	end
	if progress3 > 0 then
		x, y, a = interpolateBetween(
			0, 0, 0,
			0, 24, 1,
			progress3, "OutQuad")

		r, g, b = interpolateBetween(
			0, 170, 255,
			255, 255, 255,
			progress3, "OutQuad")
	end
	if progress4 > 0 then
		x, y, a = interpolateBetween(
			0, 24, 1,
			0, 0, 0,
			progress4, "OutQuad")

		r, g, b = interpolateBetween(
			255, 255, 255,
			0, 170, 255,
			progress4, "OutQuad")
	end
	if progress5 > 0 then
		s = interpolateBetween(
			1, 0, 0,
			0.85, 0, 0,
			progress5, "OutQuad")
	end
	if progress6 > 0 then
		s = interpolateBetween(
			0.85, 0, 0,
			1, 0, 0,
			progress6, "OutQuad")
	end
	if progress6 >= 1 then
		renderData.logoAnimStart = getTickCount() + 4000
	end

	local size = respc(512) * s
	local size2 = respc(1024) * s

	--_dxDrawImage(theX - size / 2 - x * s, theY - size / 2 - y * s, size, size, "files/logo1.png", 0, 0, 0, tocolor(r, g, b, 175 * renderData.alphaMul))
	--_dxDrawImage(theX - size / 2 + x * s, theY - size / 2 + y * s, size, size, "files/logo2.png", 0, 0, 0, tocolor(r, g, b, 175 * renderData.alphaMul))

	if a > 0 then
		--_dxDrawImage(theX - size2 / 2 - x * s, theY - size2 / 2 - y * s, size2, size2, "files/logo1g.png", 0, 0, 0, tocolor(0, 170, 255, 225 * a * renderData.alphaMul))
		--_dxDrawImage(theX - size2 / 2 + x * s, theY - size2 / 2 + y * s, size2, size2, "files/logo2g.png", 0, 0, 0, tocolor(0, 170, 255, 225 * a * renderData.alphaMul))
	end
end

addCommandHandler("edithud",
	function (cmd, key)
		local visibleHUD = isHudVisible()

		if key == "@edit" then
			visibleHUD = true
		end

		if visibleHUD then
			if not renderData.editorActive then
				setElementData(localPlayer, "isEditingHUD", true)

				renderData.moving = {}
				renderData.resizing = false
				renderData.selectedHUD = {}

				showCursor(true)

				renderData.editorActive = true
				renderData.alphaInterpolationStart = getTickCount()
				renderData.alphaInterpolationInverse = false

				playSoundEx(":radar_assets/audio/interface/7.ogg")
			end
		end
	end
)

function processExitEditor(save)
	if not renderData.trayBarActive then
		if save then
			savePositions(true)
		else
			loadPositions(true)
		end

		playSoundEx(":radar_assets/audio/interface/10.ogg")

		renderData.moving = {}
		renderData.resizing = false
		renderData.selectedHUD = {}

		renderData.alphaInterpolationStart = false
		renderData.alphaInterpolationInverse = getTickCount()

		showCursor(false)

		setElementData(localPlayer, "isEditingHUD", false)
	end
end

addEventHandler("onClientPreRender", getRootElement(),
	function (timeSlice)
		if renderData.editorActive then
			if renderData.showTrashTray and not renderData.gameMinimized then
				local cx, cy = getHudCursorPos()

				renderData.trayArrowActive = false

				if cy < 1 then
					renderData.trayArrowActive = true
					renderData.trayScrollY = renderData.trayScrollY + timeSlice / 10
				elseif cy > screenY - 1 then
					renderData.trayArrowActive = true

					if renderData.trayScrollY > 0 then
						renderData.trayScrollY = renderData.trayScrollY - timeSlice / 10
					end
				end

				if cx < 1 then
					renderData.trayArrowActive = true

					if renderData.trayScrollX < 0 then
						renderData.trayScrollX = renderData.trayScrollX + timeSlice / 10
					end
				elseif cx > screenX - 1 then
					renderData.trayArrowActive = true
					renderData.trayScrollX = renderData.trayScrollX - timeSlice / 10
				end
			end
		end
	end
)

addEventHandler("onClientHUDRender", getRootElement(),
	function ()
		if isHudVisible() then
			if renderData.editorActive then
				if renderData.alphaInterpolationStart then
					local elaspedTime = getTickCount() - renderData.alphaInterpolationStart
					local duration = 500
					local progress = elaspedTime / duration

					renderData.alphaMul = interpolateBetween(
						renderData.alphaMul, 0, 0,
						1, 0, 0,
						progress, "Linear")

				elseif renderData.alphaInterpolationInverse then
					local elaspedTime = getTickCount() - renderData.alphaInterpolationInverse
					local duration = 500
					local progress = elaspedTime / duration

					renderData.alphaMul = interpolateBetween(
						renderData.alphaMul, 0, 0,
						0, 0, 0,
						progress, "Linear")

					if progress > 1 then
						renderData.editorActive = false
					end
				end

				if not renderData.screenSrc then
					renderData.screenSrc = dxCreateScreenSource(screenX, screenY)
					renderData.screenShader = dxCreateShader("files/blur.fx")
					dxSetShaderValue(renderData.screenShader, "screenSource", renderData.screenSrc)
					--dxSetShaderValue(renderData.screenShader, "colorize", 90/255, 140/255, 215/255)
					--dxSetShaderValue(renderData.screenShader, "blurring", 0.0075)
					dxSetShaderValue(renderData.screenShader, "screenSize", {screenX, screenY})
					dxSetShaderValue(renderData.screenShader, "blurStrength", 5)
					dxSetShaderValue(renderData.screenShader, "colorize", 0/255, 100/255, 150/255)

					if renderData.canEditorMusic then
						renderData.editorMusic = playSound("files/editor.mp3", true)
						setSoundPosition(renderData.editorMusic, renderData.editorMusicPosition or 0)
						setSoundVolume(renderData.editorMusic, 0.2)
					end
				elseif renderData.screenShader then
					dxSetShaderValue(renderData.screenShader, "alpha", renderData.alphaMul)
					dxUpdateScreenSource(renderData.screenSrc, true)
					_dxDrawImage(0, 0, screenX, screenY, renderData.screenShader)
				end

				if renderData.canEditorMusic then
					setSoundVolume(renderData.editorMusic, reMap(renderData.alphaMul, 0, 1, 0, 0.2))
				end

				--dxDrawRectangle(0, 0, screenX, screenY, tocolor(90, 140, 215, 50 * renderData.alphaMul))
				_dxDrawImage(0, 0, screenX, screenY, "files/vin.png", 0, 0, 0, tocolor(0, 0, 0, 180 * renderData.alphaMul))
				renderTheLogoSARP()

				if isCursorShowing() then
					local cx, cy = getHudCursorPos()

					if cx >= 0 and cy >= renderData.trayY and cx <= screenX and cy <= renderData.trayY + screenY and #renderData.moving == 0 and not renderData.selection and not renderData.resizing and not renderData.trashTrayExitingProcessStarted then
						if not renderData.trayBarActive then
							playSoundEx(":radar_assets/audio/interface/6.ogg")
							renderData.trayBarActive = true
						end
					elseif renderData.trayBarActive then
						renderData.trayBarActive = false
						playSoundEx(":radar_assets/audio/interface/4.ogg")
					end
				elseif renderData.showTrashTray then
					renderData.showTrashTray = false
				end
			else
				if renderData.showTrashTray then
					renderData.showTrashTray = false
					renderData.trayInterpolationInverse = false
					renderData.trayInterpolationStart = false
					renderData.trayY = screenY - 10
				end
				
				renderData.moving = {}
				renderData.resizing = false
				renderData.resizePosition = false
				renderData.selectedHUD = {}
				
				if renderData.screenShader then
					destroyElement(renderData.screenShader)
				end
				renderData.screenShader = nil
				
				if renderData.screenSrc then
					destroyElement(renderData.screenSrc)
				end
				renderData.screenSrc = nil
				
				if renderData.editorMusic then
					renderData.editorMusicPosition = getSoundPosition(renderData.editorMusic)
					destroyElement(renderData.editorMusic)
				end
				renderData.editorMusic = nil
			end
		end
	end
)

local function sortFunc(t, a, b)
	return widgets[b].sizeY > widgets[a].sizeY
end

addEventHandler("onClientRender", getRootElement(),
	function ()
		if isHudVisible() then
			renderData.lastActiveDirectX = renderData.activeDirectX
			renderData.activeDirectX = false


			if isHudElementVisible("fps") then
				renderData.countedFrames = renderData.countedFrames + 1
				
				if not renderData.lastFPSReset then
					renderData.lastFPSReset = getTickCount()
				end
				
				if getTickCount() - renderData.lastFPSReset >= 1000 then
					renderData.fps = renderData.countedFrames
					renderData.countedFrames = 0
					renderData.lastFPSReset = getTickCount()
				end
			end

			if renderData.editorActive then
				local cx, cy = getHudCursorPos()

				if renderData.trayBarActive then
					if not renderData.trayInterpolationStart then
						renderData.trayInterpolationInverse = false
						renderData.trayInterpolationStart = getTickCount()
						renderData.showTrashTray = true
					end
				else
					if renderData.trayInterpolationStart then
						renderData.trayInterpolationInverse = getTickCount()
						renderData.trayInterpolationStart = false
					end
				end

				if renderData.trayInterpolationStart then
					local elapsedTime = getTickCount() - renderData.trayInterpolationStart
					local duration = 500
					local progress = elapsedTime / duration

					renderData.trayY = interpolateBetween(
						renderData.trayY, 0, 0,
						0, 0, 0,
						progress, "OutQuad")

				elseif renderData.trayInterpolationInverse then
					local elapsedTime = getTickCount() - renderData.trayInterpolationInverse
					local duration = 500
					local progress = elapsedTime / duration

					renderData.trayY = interpolateBetween(
						renderData.trayY, 0, 0,
						screenY - 10, 0, 0,
						progress, "OutQuad")
					
					if progress > 1 then
						renderData.showTrashTray = false
						renderData.trashTrayExitingProcessStarted = false
					end
				end

				

				
			end

			local widgetsInTrash = 0

			for i = 1, #availableWidgets do
				local thisWidget = availableWidgets[i]
				
				if thisWidget then
					if not renderData.inTrash[thisWidget] then
						local renderedElement = render[thisWidget]

						if renderedElement then
							renderedElement = renderedElement(widgets[thisWidget].posX, widgets[thisWidget].posY)

							if thisWidget == "actionbar" then
								processActionBarShowHide(renderedElement)
							end

							if not renderedElement and widgets[thisWidget].placeholder and renderData.editorActive then
								_BorderText(widgets[thisWidget].placeholder, widgets[thisWidget].posX, widgets[thisWidget].posY, widgets[thisWidget].posX + widgets[thisWidget].sizeX, widgets[thisWidget].posY + widgets[thisWidget].sizeY, tocolor(255, 255, 255, 255 * renderData.alphaMul), tocolor(0, 0, 0, 200 * renderData.alphaMul), 1, Roboto, "center", "center")
							end
						end
					else
						widgetsInTrash = widgetsInTrash + 1

						if thisWidget == "actionbar" and not renderData.showTrashTray then
							processActionBarShowHide(false)
						end
					end
				end
			end

			if renderData.editorActive then
				_dxDrawRectangle(0, renderData.trayY, screenX, screenY, tocolor(0, 0, 0, 230 * renderData.alphaMul))
				_dxDrawImage(0 + (screenX - 16) / 2, renderData.trayY - 8, 16, 8, "files/a1.png", 180, 0, 0, tocolor(0, 0, 0, 230 * renderData.alphaMul))

				if renderData.showTrashTray then
					_dxDrawText("Widgets disponíveis: " .. widgetsInTrash .. "/" .. #availableWidgets, 12, renderData.trayY + 10, 0, 0, tocolor(255, 255, 255, 255 * renderData.alphaMul), 1, chaletcomprime, "left", "top")
					_dxDrawRectangle(12, renderData.trayY + respc(60), screenX - 24, 2, tocolor(255, 255, 255, 50 * renderData.alphaMul))

					local x = 12
					local y = respc(60) + 10
					local biggestHeight = 0

					for k, v in spairs(renderData.inTrash, sortFunc) do
						if v then
							if defaultWidgets[k].sizeInTrash then
								if defaultWidgets[k].sizeInTrash[1] then
									widgets[k].sizeX = defaultWidgets[k].sizeInTrash[1]
								end
								if defaultWidgets[k].sizeInTrash[2] then
									widgets[k].sizeY = defaultWidgets[k].sizeInTrash[2]
								end
							else
								widgets[k].sizeX = defaultWidgets[k].sizeX
								widgets[k].sizeY = defaultWidgets[k].sizeY
							end

							if screenX - 24 - x < widgets[k].sizeX then
								x = 50
								y = y + 50 + biggestHeight
							elseif biggestHeight < widgets[k].sizeY then
								biggestHeight = widgets[k].sizeY
							end

							widgets[k].posX = x + renderData.trayScrollX
							widgets[k].posY = renderData.trayY + y + renderData.trayScrollY

							dxDrawRoundedRectangle(widgets[k].posX - resp(5), widgets[k].posY - resp(5), widgets[k].sizeX + resp(10), widgets[k].sizeY + resp(10), tocolor(255, 255, 255, 10))

							local renderedElement = render[k]

							if renderedElement then
								renderedElement = renderedElement(widgets[k].posX, widgets[k].posY)

								if k == "actionbar" then
									processActionBarShowHide(renderedElement)
								end

								if not renderedElement and widgets[k].placeholder and renderData.editorActive then
									dxDrawBorderText(widgets[k].placeholder, widgets[k].posX, widgets[k].posY, widgets[k].posX + widgets[k].sizeX, widgets[k].posY + widgets[k].sizeY, tocolor(255, 255, 255, 255 * renderData.alphaMul), tocolor(0, 0, 0, 200 * renderData.alphaMul), 1, Roboto, "center", "center")
								end
							end

							x = x + widgets[k].sizeX + 50
						end
					end
				end

				drawSideGUI()

				if renderData.activeDirectX ~= renderData.lastActiveDirectX and renderData.activeDirectX then
					playSoundEx("files/highlight.ogg")
				end
			end
		end

	end
)

addEventHandler("onClientMinimize", getRootElement(),
	function ()
		renderData.gameMinimized = true
	end
)

addEventHandler("onClientRestore", getRootElement(),
	function ()
		renderData.gameMinimized = false
	end
)


local function randomBytes(count)
	local str = ""
	for i = 1, count do
		str = str .. string.char(math.random(0, 255))
	end
	return str
end

local function encrypt(str)
	local str2 = {}

	table.insert(str2, string.char(28) .. "SARP_DATA_FILE" .. randomBytes(8))
	for char in string.gmatch(str, ".") do
		table.insert(str2, string.char(math.random(0, 255)) .. string.char(string.byte(char) - 3) .. string.char(math.random(0, 255)))
	end
	table.insert(str2, randomBytes(1024))

	return table.concat(str2)
end

local function decrypt(str)
	local str2 = {}
	local index = 0
	local index2 = 0

	for char in string.gmatch(str, ".") do
		if index > 22 and index < #str - 1024 then
			if index2 % 3 == 1 then
				table.insert(str2, string.char(string.byte(char) + 3))
			end
			index2 = index2 + 1
		end
		index = index + 1
	end

	return table.concat(str2)
end

local allowedWalkingStyles = {
	[118] = true,
	[119] = true,
	[120] = true,
	[121] = true,
	[122] = true,
	[123] = true,
	[124] = true,
	[125] = true,
	[126] = true,
	[127] = true,
	[129] = true,
	[130] = true,
	[131] = true,
	[132] = true,
	[133] = true,
	[134] = true,
	[135] = true,
	[136] = true,
	[137] = true
}

local allowedFightingStyles = {
	[4] = true,
	[5] = true,
	[6] = true
}

function savePositions()
	if not renderData.loggedIn then
		if fileExists("hud.dat") then
			fileDelete("hud.dat")
		end

		local saveData = {
			widgets = {},
			settings = {}
		}

		for k,v in pairs(widgets) do
			saveData.widgets[k] = {
				posX = v.posX,
				posY = v.posY,
				sizeX = v.sizeX,
				sizeY = v.sizeY,
				inTrash = v.inTrash
			}
		end


		saveData.settings.screenResolution = screenX .. "x" .. screenY
		saveData.settings.editorMusic = renderData.canEditorMusic
		saveData.settings.editorSoundEffects = renderData.canEditorSoundEffects
		saveData.settings.showNumberPlates = renderData.showNumberPlates

		local currentWalk = nil --getPedWalkingStyle(localPlayer)
		local currentFight = nil --getElementData(localPlayer, "fightStyle") or 4

		if not allowedWalkingStyles[currentWalk] then
			currentWalk = 118
		end

		if not allowedFightingStyles[currentFight] then
			currentFight = 4
		end

		saveData.settings.walkStyle = currentWalk
		saveData.settings.fightStyle = currentFight

		local hudData = fileCreate("hud.dat")
		fileWrite(hudData, encrypt(toJSON(saveData)))
		fileClose(hudData)
	end
end

addEventHandler("onClientResourceStop", resourceRoot,
	function ()
		if not renderData.editorActive then
			savePositions()
		end
	end
)

local buttons = {}

function drawRect(id, x, y, width, height, radius, color, postGUI)
	postGUI = postGUI or false
	
    if (not buttons[id]) then
        local raw = string.format([[
            <svg width='%s' height='%s' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <rect width='%s' height='%s' rx='%s' fill='#FFFFFF'/>
            </svg>
        ]], width, height, width, height, radius)
        buttons[id] = svgCreate(width, height, raw)
    end
    if (buttons[id]) then
		dxSetBlendMode('add')
        dxDrawImage(x, y, width, height, buttons[id], 0, 0, 0, color, postGUI)
		dxSetBlendMode('blend')
    end
end
