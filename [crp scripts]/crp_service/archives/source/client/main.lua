local screen = {guiGetScreenSize ()}
local resolution = {1920, 1080}
local sx, sy = screen[1] / resolution[1], screen[2] / resolution[2]

function setScreenPosition (x, y, w, h)
    return ((x / resolution[1]) * screen[1]), ((y / resolution[2]) * screen[2]), ((w / resolution[1]) * screen[1]), ((h / resolution[2]) * screen[2])
end
_dxDrawImage = dxDrawImage
function dxDrawImage (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    
    return _dxDrawImage (x, y, w, h, ...)
end
_dxDrawText = dxDrawText
function dxDrawText (text, x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    
    return _dxDrawText (text, x, y, (x + w), (y + h), ...)
end

local resource = {
    ['painel'] = false;
    ['time'] = {};
    ['groupDiretory'] = '';
    ['groupName'] = '';
    ['service_time'] = '00:00:00';
    ['Textures'] = {
        [1] = dxCreateTexture('archives/assets/imgs/background.png', 'argb', false);
        [2] = dxCreateTexture('archives/assets/imgs/circle.png', 'argb', false);
    };
    ['Font'] = dxCreateFont('archives/assets/fonts/Regular.ttf', sx*9)
};
local functions = {};

functions.getCurrentDateTime = function()
    local now = getRealTime();
    local day = now.monthday;
    local month = now.month + 1;
    local year = now.year + 1900;
    local hour = now.hour;
    local minute = now.minute;
    local second = now.second;
    local months = {
        "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
    };

    local formattedDateTime = string.format("%02d %s %d %02d:%02d:%02d", day, months[month], year, hour, minute, second);

    return formattedDateTime;
end


functions.render_service = function()
    local currentDate = functions.getCurrentDateTime();
    dxDrawImage(1587, 60, 298, 88, resource['Textures'][1], 0, 0, 0, tocolor(0, 0, 0, 102));
    dxDrawImage(1682, 70, 11, 11, resource['Textures'][2], 0, 0, 0, tocolor(177, 0, 0, math.abs (math.sin (getTickCount() / 420) * 255)));

    dxDrawText('REC', 1653, 69, 23, 14, tocolor(255, 255, 255, 255), 1, resource['Font'], 'right', 'center');
    dxDrawText('BODY CAM', 1710, 69, 60, 14, tocolor(255, 255, 255, 255), 1, resource['Font'], 'right', 'center');
    dxDrawText(string.upper(string.gsub(getPlayerName(localPlayer), '_', ' '))..' ['..(getElementData(localPlayer, 'ID') or 0)..']', 1616, 88, 193, 12, tocolor(255, 255, 255, 255), 1, resource['Font'], 'right', 'center');
    dxDrawText(resource['groupName'], 1602, 106, 207, 14, tocolor(255, 255, 255, 255), 1, resource['Font'], 'right', 'center');
    dxDrawText(currentDate..' |', 1609, 124, 128, 14, tocolor(255, 255, 255, 255), 1, resource['Font'], 'left', 'center');
    dxDrawImage(1816, 74, 61, 61, resource['groupDiretory'])
    dxDrawText(resource['service_time'], 1743, 124, 47, 14, tocolor(255, 255, 255, 255), 1, resource['Font'], 'left', 'center');
end

addEvent('startService', true)
addEventHandler('startService', root, function(diretory, groupName)
    if (not resource['painel']) then
        resource['service_time'] = '00:00:00';
        resource['groupDiretory'] = diretory;
        resource['groupName'] = groupName;
        local segundos = 0;
        local horas = 0;
        local minutos = 0;
        resource['time'][localPlayer] = setTimer(function()

            segundos = (segundos + 1);
            if segundos >= 60 then 
                if not minutos then 
                    minutos = 0;
                end
                minutos = (minutos + 1);
                segundos = 0;
            end
            if minutos >= 60 then 
                if not horas then 
                    horas = 0;
                end
                horas = (horas + 1);
                minutos = 0;
            end

            local string_horas = horas;
            local string_minutos = minutos;
            local string_segundos = segundos;

            if horas < 10 then 
                string_horas = '0'..horas;
            end
            if minutos < 10 then 
                string_minutos = '0'..minutos;
            end
            if segundos < 10 then 
                string_segundos = '0'..segundos;
            end

            resource['service_time'] = (string_horas or 0)..':'..(string_minutos or 0)..':'..string_segundos;

        end, 1000, 0)

        resource['painel'] = true;
        addEventHandler('onClientRender', root, functions.render_service);

    else
        killTimer(resource['time'][localPlayer]);
        resource['painel'] = false;
        removeEventHandler('onClientRender', root, functions.render_service);

    end
end)