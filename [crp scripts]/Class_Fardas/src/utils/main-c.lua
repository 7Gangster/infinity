-- Resolução
local screenW, screenH = guiGetScreenSize()
local screenScale = 1.2

function getResponsibleValues()
    return screenW, screenH, screenScale
end

function respc(value)
    return (value * screenScale)
end

_dxDrawText = dxDrawText
function dxDrawText(label, x, y, width, height, ...)
    return _dxDrawText(label, x, y, width + x, height + y, ...)
end

local fonts = {}
local texs = {}

_dxCreateFont = dxCreateFont
function dxCreateFont(path, size, ...)
    if (not fonts[path]) then
        fonts[path] = {}
    end
    if (not fonts[path][size]) then
        fonts[path][size] = _dxCreateFont("assets/fonts/"..path, respc(size), ...)
    end
    return fonts[path][size]
end

_dxDrawImage = dxDrawImage
function dxDrawImage(x, y, width, height, path, ...)
    if (type(path) ~= "string") then
        return _dxDrawImage(x, y, width, height, path, ...)
    end
    if (not texs[path]) then
        texs[path] = dxCreateTexture("assets/images/" .. path)
    end
    return _dxDrawImage(x, y, width, height, texs[path], ...)
end

function isMouseInPosition(x, y, width, height)
    if not isCursorShowing() then
        return false
    end

    local cx, cy = getCursorPosition()
    local cx, cy = (cx * screenW), (cy * screenH)

    return ((cx >= x and cx <= x + width) and (cy >= y and cy <= y + height))
end

-- # Classes

-- Animações
animation = nil

class 'Animation'{
    constructor = function(self)
        self.cache = { }
    end;

    new = function(self, name, initial, finish, duration, easing)
        if self.cache[name] then
            return error 'Animation already exists'
        end

        self.cache[name] = {
            initial = initial;
            finish = finish;
            duration = duration;
            easing = easing;
            tick = 0;
        }
    end;

    set = function(self, name, initial, finish, duration, easing)
        if not self.cache[name] then
            return error 'Animation does not exist'
        end

        self.cache[name].initial = initial
        self.cache[name].finish = finish
        self.cache[name].duration = (duration and duration or self.cache[name].duration)
        self.cache[name].easing = (easing and easing or self.cache[name].easing)
        self.cache[name].tick = getTickCount()
    end;

    get = function(self, name)
        if not self.cache[name] then
            return error 'Animation does not exist'
        end

        local animation = self.cache[name]
        local progress = (getTickCount() - animation.tick) / animation.duration

        if progress >= 1 then
            return animation.finish
        end

        return interpolateBetween(
            animation.initial, 0, 0,
            animation.finish, 0, 0,
            progress, animation.easing
        )
    end;
}

animation = new "Animation"()