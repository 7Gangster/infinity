local screenW, screenH = guiGetScreenSize()

local radioWidth, radioHeight = 338, 1000
local radioX, radioY = (screenW / 2 - radioWidth / 2) + 500, (screenH / 2 - radioHeight / 2)
local panelShowing = false

local utils = {
    fonts = {
        roboto_m15 = dxCreateFont("public/fonts/medium.ttf", 15),
    },
    frequency_input = {"0"},
    inputSelected = false
}
local essencials = {}

local tick
local anim_time = 500
local alpha = {0, 255}

local function render()
    local Fonts = utils.fonts
    local theInput, theInputString = utils.frequency_input, table.concat(utils.frequency_input)
    progress = (getTickCount() - tick) / anim_time
    alpha[1] = interpolateBetween(alpha[1], 0, 0, alpha[2], 0, 0, progress, "Linear")
    dxDrawImage(radioX, radioY, radioWidth, radioHeight, "public/images/radio.png", 0, 0, 0, tocolor(255, 255, 255, alpha[1]))
    if getElementData(localPlayer, "Class.Frequency") then
        dxDrawRoundedRectangle(radioX + (radioWidth / 2 - 127 / 2), radioY + (radioHeight / 2 - 128 / 2) + 203, 127, 128, 7, tocolor(115, 161, 57, alpha[1]))
    else
        dxDrawRoundedRectangle(radioX + (radioWidth / 2 - 127 / 2), radioY + (radioHeight / 2 - 128 / 2) + 203, 127, 128, 7, tocolor(70, 70, 70, alpha[1]))
    end
    dxDrawText(theInputString..'Hz', radioX + (radioWidth / 2 - 127 / 2) + 80 - dxGetTextWidth(theInputString..'Hz', 1, Fonts.roboto_m15)/1.5, radioY + (radioHeight / 2 - 128 / 2) + (203) + (128 / 2 - 30 / 2), 127, 128, tocolor(0, 0, 0, alpha[1]), 1, Fonts.roboto_m15)
    
    -- BUTTONS
    if isCursorOnElement(radioX + (radioWidth / 2 - 30 / 2), radioY + (radioHeight / 2 - 15 / 2) + 300, 30, 18) and alpha[1] >= 255 then 
        dxDrawRectangle(radioX + (radioWidth / 2 - 30 / 2), radioY + (radioHeight / 2 - 15 / 2) + 300, 30, 18, tocolor(255, 255, 255, 50))
    end
    if isCursorOnElement(radioX + (radioWidth / 2 - 30 / 2), radioY + (radioHeight / 2 - 15 / 2) + 275, 30, 15) and alpha[1] >= 255 then 
        dxDrawRectangle(radioX + (radioWidth / 2 - 30 / 2), radioY + (radioHeight / 2 - 15 / 2) + 275, 30, 15, tocolor(255, 255, 255, 50))
    end
end

local function unloadEssencials()
    unbindKey("backspace", "down", essencials["deleteWrite"])
    removeEventHandler("onClientClick", root, essencials["mouseClick"])
    removeEventHandler("onClientCharacter", root, essencials["writeOnInput"])
end

function closeCommunicator()
    if panelShowing then
        alpha = {255, 0}
        tick = getTickCount()
        unloadEssencials()
        panelShowing = false
        triggerServerEvent("crp:setPedOpening", localPlayer, localPlayer, false)
        setTimer(function()
            removeEventHandler("onClientRender", root, render)
        end, anim_time + 100, 1)
        showCursor(false)
    end
end
addEvent("class:closeCommunicator", true)
addEventHandler("class:closeCommunicator", root, closeCommunicator)

local function loadEssencials()
    if getElementData(localPlayer, "Class.Frequency") then
        utils.frequency_input = {tostring(getElementData(localPlayer, "Class.Frequency"))}
    end
    essencials["mouseClick"] = function(button, state)
        if button == "left" and state == "down" then
            if isCursorOnElement(radioX + (radioWidth / 2 - 127 / 2), radioY + (radioHeight / 2 - 128 / 2) + 203, 127, 128) then
                if not utils.inputSelected then
                    utils.inputSelected = true
                    if table.concat(utils.frequency_input) == "0" then
                        utils.frequency_input = {}
                    end
                end
            else
                if utils.inputSelected then
                    utils.inputSelected = false
                    if #utils.frequency_input <= 0 then
                        utils.frequency_input = {"0"}
                    end
                end
            end
            if isCursorOnElement(radioX + (radioWidth / 2 - 30 / 2), radioY + (radioHeight / 2 - 15 / 2) + 300, 30, 18) then
                local theInput, theInputString = utils.frequency_input, table.concat(utils.frequency_input)
                if theInputString ~= "0" then
                    triggerServerEvent("crp:radinho", localPlayer, localPlayer, theInputString)
                else
                    triggerServerEvent("crp:radinho", localPlayer, localPlayer)
                end
            elseif isCursorOnElement(radioX + (radioWidth / 2 - 30 / 2), radioY + (radioHeight / 2 - 15 / 2) + 275, 30, 15) then
                if getElementData(localPlayer, "Class.Frequency") then
                    triggerServerEvent("crp:radinho", localPlayer, localPlayer)
                    utils.frequency_input = {"0"}
                end
            end
        end
    end
    addEventHandler("onClientClick", root, essencials["mouseClick"])

    essencials["writeOnInput"] = function(character)
        if isValueInTable(canWrite, character, 1) then
            local inputSelected = utils.inputSelected
            if inputSelected then
                local theInput = utils.frequency_input
                if #theInput < 7 then
                    table.insert(theInput, character)
                end
            end
        end
    end
    addEventHandler("onClientCharacter", root, essencials["writeOnInput"])

    essencials["deleteWrite"] = function()
        local inputSelected, theInput = utils.inputSelected, utils.frequency_input
        if not inputSelected then closeCommunicator() end
        if inputSelected and #theInput > 0 then
            table.remove(theInput, #theInput)
        end
    end
    bindKey("backspace", "down", essencials["deleteWrite"])
end

function openCommunicator()
    if not panelShowing then
        alpha = {0, 255}
        tick = getTickCount()
        loadEssencials()
        panelShowing = true
        triggerServerEvent("crp:setPedOpening", localPlayer, localPlayer, true)
        addEventHandler("onClientRender", root, render)
        showCursor(true)
    end
end 
addEvent("class:openCommunicator", true)
addEventHandler("class:openCommunicator", root, openCommunicator)
