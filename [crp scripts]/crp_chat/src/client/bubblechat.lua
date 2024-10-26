local SELF_VISIBLE = true -- Want to see your own message?
local TIME_VISIBLE = 8500 -- in miliseconds
local DISTANCE_VISIBLE = 30
local ROUND = false -- Rounded rectangle(true) or not(false)
local ANIMATION_DURATION = 2000
local font = _dxCreateFont('src/assets/fonts/Roboto-Regular.ttf', 10, false, 'default')

local messages = {} -- {text, player, lastTick, alpha, yPos}
local nowTick -- Tick count cache
local x, y, z -- Local player position cache

addEvent('onChatIncome', true)
addEventHandler('onChatIncome', root,
	function(message, messagetype)
		if source ~= localPlayer or SELF_VISIBLE then
			addBubble(message, source, getTickCount())
		end
	end
)

function addBubble(text, player, tick)
	if (not messages[player]) then
		messages[player] = {}
	end

	table.insert(messages[player], {
		['text'] = text,
		['player'] = player,
		['tick'] = tick,
		['alpha'] = 0,
		['texture'] = _texture
	})
end

addEventHandler('onClientRender', root,
	function()
		nowTick = getTickCount()
		x, y, z = getElementPosition(localPlayer)

		for player, playerMessages in pairs(messages) do
			if (isElement(player)) then
				for index, message in ipairs(playerMessages) do
					if index < 4 then
						handleDrawMessage(message, index)
					end
				end
			else
				removePlayerMessages(player)
			end
		end
	end
)

function handleDrawMessage(message, index)
	if (nowTick - message.tick) > TIME_VISIBLE then
		removePlayerMessage(message.player, index)
		return
	end

	if not shouldDrawPlayerMessage(message.player) then
		return
	end

	local bx, by, bz = getPedBonePosition(message.player, 0)
	local sx, sy = getScreenFromWorldPosition(bx, by, bz)

	if not sx or not sy then
		return
	end

	message.alpha = message.alpha < 150 and message.alpha + 10 or message.alpha

	local elapsedTime = nowTick - message.tick
	local progress = elapsedTime / TIME_VISIBLE

	if not message.yPos then
		message.yPos = sy
	end

	--local yPos = interpolateBetween ( message.yPos, 0, 0, sy - 22*index, 0, 0, progress, 'OutElastic')

	local textWidth = dxGetTextWidth(message.text:gsub('#%x%x%x%x%x%x', ''), 1, font)
	--local yPos = outElastic(elapsedTime, message.yPos, (sy - 22*index) - message.yPos, ANIMATION_DURATION, 5)
	local yPos = (sy - 22*index)
	local finalContainerX, finalContainerY = sx - textWidth/2 - 10, yPos - 25
	local finalContainerWidth, finalContainerHeight = textWidth + 16, 20

	_dxDrawRectangle(finalContainerX, finalContainerY, finalContainerWidth, finalContainerHeight, _tocolor(0, 0, 0, message.alpha))

	_dxDrawText(message.text, finalContainerX, finalContainerY, finalContainerX + finalContainerWidth, finalContainerY + finalContainerHeight, _tocolor(255, 255, 255, message.alpha+50), 1, font, 'center', 'center', false, false, false, true)
end

function removePlayerMessage(player, index)
	if ROUND then
		messages[player][index].texture:destroy()
	end

	table.remove(messages[player], index)
end

function shouldDrawPlayerMessage(player)
	local px, py, pz = getElementPosition(player)

	return getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= DISTANCE_VISIBLE
		and isLineOfSightClear(x, y, z, px, py, pz, true, not isPedInVehicle(player), false, true)
end

function removePlayerMessages(player)
	if ROUND then
		for index, message in ipairs(messages[player]) do
			message.texture:destroy()
		end
	end

	messages[player] = nil
end

local pi = math.pi
function outElastic(t, b, c, d, a, p)
  if t == 0 then return b end

  t = t / d

  if t == 1 then return b + c end

  if not p then p = d * 0.3 end

  local s

  if not a or a < math.abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * pi) * math.asin(c/a)
  end

  return a * math.pow(2, -10 * t) * math.sin((t * d - s) * (2 * pi) / p) + c + b
end