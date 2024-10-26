local functions = { };
local resource = { };
local screen = {guiGetScreenSize ()};
local resolution = {1920, 1080};
local sx, sy = screen[1] / resolution[1], screen[2] / resolution[2];
resource['Font'] = dxCreateFont('archives/assets/font/font.ttf', sy * 15)
resource.Position = 0
function setScreenPosition (x, y, w, h)
    return ((x / resolution[1]) * screen[1]), ((y / resolution[2]) * screen[2]), ((w / resolution[1]) * screen[1]), ((h / resolution[2]) * screen[2])
end

_dxDrawText = dxDrawText
function dxDrawText (text, x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    
    return _dxDrawText (text, x, y, (x + w), (y + h), ...)
end

_dxDrawImage = dxDrawImage
function dxDrawImage (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    
    return _dxDrawImage (x, y, w, h, ...)
end

functions.renderLoadscreen = function()
    _dxDrawImage(0, 0, sx * resolution[1], sy * resolution [2], 'archives/assets/imgs/background.png', 0, 0, 0, tocolor(255, 255, 255, 255), true);
    if resource.Porcentage then
        dxDrawText('Loading game ('.. math.floor(math.ceil(resource.Porcentage)) .. '%)', 879, 1035, 161.63, 18, tocolor(255, 255, 255, 240), 1, resource['Font'], 'center', 'center', false, false, true);
    else
        dxDrawText('Loading game...', 879, 1035, 161.63, 18, tocolor(255, 255, 255, 240), 1, resource['Font'], 'center', 'center', false, false, true);
    end
    if (resource.Position + 1) == 360 then
        resource.Position = 0;
    end
    resource.Position = resource.Position + 2;
    dxDrawImage(947, 1004, 25, 25, 'archives/assets/imgs/loading.png', resource.Position, 0, 0, tocolor(255, 255, 255, 255), true);
end

function iLoadScreen ()
    if (not resource['isEventHandlerAdded']) then
        if not isElement(resource['Sound']) then
            setTransferBoxVisible (false)
            resource['Sound'] = playSound('https://cdn.discordapp.com/attachments/1175831728833712138/1194506148401909831/song.mp3?ex=65b0998a&is=659e248a&hm=fd083989c30b7c467b7e8d3eddb81a57c3d59fbd3efc21a5a7b3f347a5c6710a&')
            setSoundVolume(resource['Sound'], 0.6)
            triggerServerEvent('CLASS >> setVoice', resourceRoot, true)
            resource['tickCount'] = getTickCount();
            resource['isEventHandlerAdded'] = true;
            showChat(false)
            addEventHandler('onClientRender', root, functions.renderLoadscreen, true, 'low-5');
            resource.Position = 0
        end
    end
end
addEventHandler('onClientResourceStart', resourceRoot, iLoadScreen)
function fLoandScreen ()
    if (isTransferBoxActive() == true) then
        setTimer(fLoandScreen, (20 * 1000), 1)
    else 
        resource['isEventHandlerAdded'] = false
        if isElement(resource['Sound']) then
            stopSound(resource['Sound'])
        end
        triggerServerEvent('CLASS >> setVoice', resourceRoot, false)
        showChat(true)
        removeEventHandler('onClientRender', root, functions.renderLoadscreen)
    end
end
setTimer(fLoandScreen, (20 * 1000), 1)

addEventHandler("onClientTransferBoxProgressChange", root, function(downloadedSize, totalSize)
    resource.Porcentage = math.min((downloadedSize / totalSize) * 100, 100)
end)