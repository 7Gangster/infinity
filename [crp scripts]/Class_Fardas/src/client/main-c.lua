local screenW, screenH, screenScale = getResponsibleValues()

-- # Class Gerenciador
local parentWidth, parentHeight = respc(638), respc(438)
local parentX, parentY = (screenW - parentWidth) / 2, (screenH - parentHeight) / 2

function respX(val)
    return parentX + respc(val)
end

function respY(val)
    return parentY + respc(val)
end

local instanceManager

local function managerRender()
    instanceManager:render()
end;

local function managerClick(button, state)
    if button == "left" and state == "down" then
        return instanceManager:click()
    end
end;

local function managerScrollbar(button)
    if (button == "mouse_wheel_up") then
        if (instanceManager.scrollbar.offset > 1) then
            instanceManager.scrollbar.offset = instanceManager.scrollbar.offset - 1
        end
    else
        if (instanceManager.scrollbar.offset < (#config.organizations[instanceManager.identify]["windows"][instanceManager.window] - instanceManager.scrollbar.maxElements + 1)) then
            instanceManager.scrollbar.offset = instanceManager.scrollbar.offset + 1
        end
    end
end;

local function managerClose()
    instanceManager:close()
end

class "Manager UI"{
    constructor = function(self)
        self.visible = false;
        self.identify = false;
        self.cooldown = 0;
        self.inServices = {};
        self.window = "personages";

        self.windows = {
            {label = "Fardamentos", window = "personages"};
            {label = "", window = ""};
            {label = "", window = ""};
        }

        self.scrollbar = {
            maxElements = 5;
            selected = 0;
            offset = 1;
        }

        animation:new("alphaMain", 0, 0, 300, "Linear")
        animation:new("alphaWindow", 0, 0, 300, "Linear")
    end;

    open = function(self, id, tbl)
        if self.visible then
            return
        end

        self.visible = true;
        self.inServices = tbl;
        self.identify = tostring(id)
        self.window = "personages"

        self.scrollbar.offset = 1;
        self.scrollbar.selected = 0;

        animation:set("alphaMain", 0, 255)
        animation:set("alphaWindow", 0, 255)

        showCursor(true)
        bindKey("backspace", "down", managerClose)
        bindKey("mouse_wheel_up", "down", managerScrollbar)
        bindKey("mouse_wheel_down", "down", managerScrollbar)
        addEventHandler("onClientClick", root, managerClick)
        addEventHandler("onClientRender", root, managerRender)
    end;

    close = function(self)
        if not self.visible then
            return
        end

        self.visible = false;
        animation:set("alphaMain", animation:get("alphaMain"), 0)
        animation:set("alphaWindow", animation:get("alphaWindow"), 0, 300)

        showCursor(false)
        unbindKey("backspace", "down", managerClose)
        unbindKey("mouse_wheel_up", "down", managerScrollbar)
        unbindKey("mouse_wheel_down", "down", managerScrollbar)
        removeEventHandler("onClientClick", root, managerClick)
        setTimer(function()
            self.identify = false;
            removeEventHandler("onClientRender", root, managerRender)
        end, 310, 1)
    end;

    click = function(self)
        if not isMouseInPosition(parentX, parentY, parentWidth, parentHeight) then
            self.scrollbar.selected = 0
            return
        end
        if (self.cooldown > os.time()) then
            return
        end

        if isMouseInPosition(respX(25), (parentY + parentHeight) - respc(49 + 25), respc(229), respc(49)) then
        elseif isMouseInPosition(respX(385), respY(369), respc(228), respc(44)) then

            if self.scrollbar.selected == 0 then
                return sendMessage("client", "Selecione uma opção para confirmar.", "info")
            end
            local dataValues = config.organizations[self.identify]["windows"][self.window][self.scrollbar.selected]
            if not dataValues then
                return sendMessage("client", "Selecione uma opção para confirmar.", "info")
            end

            return triggerServerEvent("onTargetExecute", localPlayer, self.window, dataValues)
        else
            for i = 1, 3 do
                local x = (respX(120) + (respc(133) * (i - 1)));
    
                if isMouseInPosition(x, respY(0), respc(133), respc(48)) then

                    
                    animation:set("alphaWindow", 255, 0, 300)
                    self.cooldown = os.time() + 1
                    setTimer(function()
                        self.scrollbar.selected = 0;
                        self.scrollbar.offset = 1;
                        animation:set("alphaWindow", 0, 255, 500)
                    end, 400, 1)
                    return
                end
            end
            for i = 0, (self.scrollbar.maxElements - 1) do
                local dataValues = config.organizations[self.identify]["windows"][self.window][i + self.scrollbar.offset]
                local offset = respY(97) + (respc(53) * i)
    
                if dataValues then
                    local actionElement = ((i + self.scrollbar.offset) == self.scrollbar.selected and "active" or isMouseInPosition(respX(385), offset, respc(228), respc(45)) and "hover" or "default")
                    if (actionElement == "hover") then
                        self.scrollbar.selected = (i + self.scrollbar.offset)
                        return
                    end
                end
            end
        end
    end;

    render = function(self)
        local alphaMain = animation:get("alphaMain")
        local alphaWindow = animation:get("alphaWindow")

        dxDrawImage(parentX, parentY, parentWidth, parentHeight, "backg.png", 0, 0, 0, tocolor(255, 255, 255, alphaMain))

        for i = 1, 3 do
            local x = (respX(120) + (respc(133) * (i - 1)));
        end

        dxDrawText("Painel de Fardas", respX(25), respY(52), respc(156), respc(45), tocolor(244, 244, 244, alphaMain), 1.00, dxCreateFont("RobotoCondensed-Regular.ttf", 12), "left", "center")
        dxDrawText("Selecione a farda de acordo de sua patente\npara fazer seu patrulhamento\n e caçar todos os bandidos da cidade.", respX(25), respY(88), respc(249), respc(67), tocolor(244, 244, 244, 0.47 * alphaMain), 1.00, dxCreateFont("RobotoCondensed-Regular.ttf", 11), "left", "center")
    
        for i = 0, (self.scrollbar.maxElements - 1) do
            local dataValues = config.organizations[self.identify]["windows"][self.window][i + self.scrollbar.offset]
            local offset = respY(97) + (respc(53) * i)

            if dataValues then
                local actionElement = ((i + self.scrollbar.offset) == self.scrollbar.selected and "active" or isMouseInPosition(respX(385), offset, respc(228), respc(45)) and "hover" or "default")
                
                dxDrawImage(respX(385), offset, respc(228), respc(45), "row.png", 0, 0, 0, ((actionElement == "active" or actionElement == "hover") and tocolor(59, 59, 59, alphaWindow) or tocolor(47, 47, 47, alphaWindow)))
                dxDrawImage(respX(402), offset + respc(11), respc(24), respc(24), "radius.png", 0, 0, 0, tocolor(255, 255, 255, 0.08 * alphaWindow))

                dxDrawText(tostring(i + self.scrollbar.offset), respX(402), (offset + respc(12)), respc(24), respc(24), tocolor(255, 255, 255, alphaWindow * 0.65), 1.00, dxCreateFont("RobotoCondensed-Regular.ttf", 11), "center", "center")
                dxDrawText(dataValues.label, respX(443), offset, respc(170), respc(45), tocolor(255, 255, 255, alphaWindow * 0.65), 1.00, dxCreateFont("RobotoCondensed-Regular.ttf", 11), "left", "center")

                if (actionElement == "active" or actionElement == "hover") then
                    dxDrawImage(respX(385), (offset + respc(10)), respc(3), respc(25), "line.png", 0, 0, 0, tocolor(255, 255, 255, alphaWindow))
                end
            end
        end

        dxDrawImage(respX(385), respY(369), respc(228), respc(44), "row.png", 0, 0, 0, (isMouseInPosition(respX(385), respY(369), respc(228), respc(44)) and tocolor(47, 139, 212, alphaWindow * 0.9) or tocolor(47, 47, 47, alphaWindow)))
        dxDrawText("CONFIRMAR", respX(385), respY(369), respc(228), respc(44), tocolor(222, 222, 222, alphaWindow * 0.9), 1.00, dxCreateFont("RobotoCondensed-Regular.ttf", 12), "center", "center")
    end;
}

instanceManager = new "Manager UI"()

-- # Eventos
createEventHandler("onClientOpenManager", localPlayer, function(id, tbl)
    instanceManager:open(id, tbl)
end)

createEventHandler("onClientCloseManager", localPlayer, function()
    instanceManager:close()
end)