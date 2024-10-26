-- Dx Variables
local functions = { };
local resource = { ['Infos'] = {}, ['Teste'] = {} };
local config = getConfig();

-- Resolution
screen = {guiGetScreenSize ()}
resolution = {1920, 1076}
sx, sy = screen[1] / resolution[1], screen[2] / resolution[2]

function setScreenPosition (x, y, w, h)
    return ((x / resolution[1]) * screen[1]), ((y / resolution[2]) * screen[2]), ((w / resolution[1]) * screen[1]), ((h / resolution[2]) * screen[2])
end
function isCursorOnElement (x, y, w, h)
    if isCursorShowing () then
        local cursor = {getCursorPosition ()}
        local mx, my = cursor[1] * screen[1], cursor[2] * screen[2]
        return mx > x and mx < x + w and my > y and my < y + h
    end
    return false
end
_dxCreateFont = dxCreateFont
function dxCreateFont (path, scale, ...)
    local _, scale, _, _ = setScreenPosition (0, scale, 0, 0)

    return _dxCreateFont (path, scale, ...)
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
_isCursorOnElement = isCursorOnElement
function isCursorOnElement (x, y, w, h)
    local x, y, w, h = setScreenPosition (x, y, w, h)

    return _isCursorOnElement (x, y, w, h)
end

function math.round(num, decimals)
    if num then
        decimals = math.pow(10, decimals or 1)
        num = num * decimals
        if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
        return num / decimals
    end
end


-- Dx Render
functions.render = function()
    local alpha = interpolateBetween(resource['Animation'].AlphaTransition[1], 0, 0, resource['Animation'].AlphaTransition[2], 0, 0, (getTickCount() - resource['Animation'].TickCount) / resource['Animation'].Time, 'Linear');
    if resource['PanelConfig']['SelectWindow'] == 'index' then

        for i = 1, 3 do
            dxDrawImage(1578, (303 + ((i-1)*59)), 287, 62, resource['Textures'][1], 0, 0, 0, isCursorOnElement(1578, (303 + ((i-1)*59)), 287, 62) and tocolor(56, 73, 96, 255 * alpha) or tocolor(46, 50, 62, 255 * alpha));
            dxDrawText(resource['Infos']['Window Config'][i]['Title'], 1590, (315 + ((i-1)*59)), 196, 23, tocolor(255, 255, 255, 255 * alpha), 1, resource['Fonts'][1], 'left', 'center');
            dxDrawText(resource['Infos']['Window Config'][i]['Description'], 1590, (338 + ((i-1)*59)), 196, 18, tocolor(173, 177, 189, 255 * alpha), 1, resource['Fonts'][2], 'left', 'center');
        end

    elseif resource['PanelConfig']['SelectWindow'] == resource['Infos']['Window Config'][2]['Title'] then
        dxDrawImage(1578, 244, 287, 62, resource['Textures'][1], 0, 0, 0, tocolor(46, 50, 62, 255 * alpha));
        dxDrawText(resource['Infos']['Window Config'][2]['Title'], 1587, 258, 73, 23, tocolor(255, 255, 255, 255 * alpha), 1, resource['Fonts'][1], 'left', 'center');
        dxDrawText('Suas viaturas.', 1587, 277, 84, 18, tocolor(173, 177, 189, 255 * alpha), 1, resource['Fonts'][2], 'left', 'center');

        for i, v in ipairs(resource['Teste']) do
            dxDrawImage(1578, (303 + ((i-1)*59)), 287, 62, resource['Textures'][1], 0, 0, 0, isCursorOnElement(1578, (303 + ((i-1)*59)), 287, 62) and tocolor(56, 73, 96, 255 * alpha) or tocolor(46, 50, 62, 255 * alpha));
            dxDrawText((resource['Infos']['Vehicles'][v['indexVeh']]['Name']..' - '..v['id']..' '..v['Situacao']..''), 1587, 313 + ((i-1)*59), 218, 18, tocolor(173, 177, 189, 255 * alpha), 1, resource['Fonts'][2], 'left', 'center');
            dxDrawText('Motor: '..math.round(v['Motor'], 2)..'%', 1587, 327 + ((i-1)*59), 69, 18, tocolor(255, 255, 255, 255 * alpha), 1, resource['Fonts'][2], 'left', 'center');
            dxDrawText('Combustível: '..v['Combustivel']..'%', 1587, 341 + ((i-1)*59), 110, 18, tocolor(255, 255, 255, 255 * alpha), 1, resource['Fonts'][2], 'left', 'center');
            dxDrawImage(1831, (321 + ((i-1)*59)), 26, 26, resource['Textures'][2], 0, 0, 0, tocolor(255, 255, 255, 160 * alpha));
        end

    elseif resource['PanelConfig']['SelectWindow'] == resource['Infos']['Window Config'][3]['Title'] then
        dxDrawImage(1578, 244, 287, 62, resource['Textures'][1], 0, 0, 0, tocolor(46, 50, 62, 255 * alpha));
        dxDrawText(resource['Infos']['Window Config'][3]['Title'], 1587, 258, 73, 23, tocolor(255, 255, 255, 255 * alpha), 1, resource['Fonts'][1], 'left', 'center');
        dxDrawText('Compre viaturas.', 1587, 277, 84, 18, tocolor(173, 177, 189, 255 * alpha), 1, resource['Fonts'][2], 'left', 'center');

        for i, v in ipairs(resource['Infos']['Vehicles']) do
            dxDrawImage(1578, (303 + ((i-1)*59)), 287, 62, resource['Textures'][1], 0, 0, 0, isCursorOnElement(1578, (303 + ((i-1)*59)), 287, 62) and tocolor(56, 73, 96, 255 * alpha) or tocolor(46, 50, 62, 255 * alpha));
            dxDrawText(v['Name'], 1587, 313 + ((i-1)*59), 218, 18, tocolor(173, 177, 189, 255 * alpha), 1, resource['Fonts'][2], 'left', 'center');
            dxDrawText('$'..v['Price'], 1587, 335 + ((i-1)*59), 46, 23, getPlayerMoney() >= tonumber(v['Price']) and tocolor(149, 239, 119, 255 * alpha) or tocolor(239, 119, 119, 255 * alpha), 1, resource['Fonts'][1], 'left', 'center');
            dxDrawImage(1831, (321 + ((i-1)*59)), 26, 26, resource['Textures'][2], 0, 0, 0, tocolor(255, 255, 255, 160 * alpha));
        end

    end
end

-- Dx Binds
functions.closeBind = function()
    if resource['PanelConfig'].SelectWindow == 'index' then
        functions.managePanel('close')
    else
        resource['Animation'] = {
            Time = 500; -- Milissegundos
            AlphaTransition = { 1, 0 }; -- { 0, 1 } - Para abrir um painel e { 1, 0 } - Para fechar um painel
            TickCount = getTickCount();
        };
        unbindKey('backspace', 'down', functions.closeBind)
        setTimer(function()
            resource['Animation'] = {
                Time = 500; -- Milissegundos
                AlphaTransition = { 0, 1 }; -- { 0, 1 } - Para abrir um painel e { 1, 0 } - Para fechar um painel
                TickCount = getTickCount();
            };
            resource['PanelConfig']['SelectIndex'] = 0;
            resource['PanelConfig']['SelectWindow'] = 'index';
            bindKey('backspace', 'down', functions.closeBind)
        end, tonumber(resource['Animation'].Time), 1);
    end
end

-- Dx Click
functions.clickFunctions = function(button, state)
    if (button == 'left') and (state == 'down') then
        if resource['PanelConfig'].isEventHandlerAdded then
            if resource['PanelConfig'].SelectWindow == 'index' then
                for i = 1, 3 do
                    if isCursorOnElement(1578, (303 + ((i-1)*59)), 287, 62) then
                        if i == 1 then
                            triggerServerEvent('CLASS >> VEHICLE MANAGER', resourceRoot, localPlayer, resource['Teste'], _, resource['Infos'], _, 'destroy');
                            functions.managePanel('close');
                        elseif i == 2 or i == 3 then
                            if i == 2 and #resource['Teste'] == 0 then return config.clientNotify(config['Messages']['isNotVehicle'][1], config['Messages']['isNotVehicle'][2], config['TimeDefault']) end
                            resource['Animation'] = {
                                Time = 500; -- Milissegundos
                                AlphaTransition = { 1, 0 }; -- { 0, 1 } - Para abrir um painel e { 1, 0 } - Para fechar um painel
                                TickCount = getTickCount();
                            };
                            removeEventHandler('onClientClick', root, functions.clickFunctions);
                            unbindKey('backspace', 'down', functions.closeBind)
                            setTimer(function()
                                resource['Animation'] = {
                                    Time = 500; -- Milissegundos
                                    AlphaTransition = { 0, 1 }; -- { 0, 1 } - Para abrir um painel e { 1, 0 } - Para fechar um painel
                                    TickCount = getTickCount();
                                };
                                resource['PanelConfig']['SelectIndex'] = 0;
                                resource['PanelConfig']['SelectWindow'] = resource['Infos']['Window Config'][i]['Title'];
                                addEventHandler('onClientClick', root, functions.clickFunctions);
                                bindKey('backspace', 'down', functions.closeBind)
                            end, tonumber(resource['Animation'].Time), 1);

                        end
                    end
                end
            elseif resource['PanelConfig'].SelectWindow == resource['Infos']['Window Config'][2]['Title'] then
                for i, v in ipairs(resource['Teste']) do
                    if isCursorOnElement(1578, (303 + ((i-1)*59)), 287, 62) then
                        if v['Situacao'] == 'Em Rua' then
                            config.clientNotify(config['Messages']['vehicleSpawned'][1], config['Messages']['vehicleSpawned'][2], config['TimeDefault']);
                            return false
                        end
                        triggerServerEvent('CLASS >> VEHICLE MANAGER', resourceRoot, localPlayer, v, v['indexVeh'], resource['Infos'], i, 'garage');
                        functions.managePanel('close');
                    end
                end
            elseif resource['PanelConfig'].SelectWindow == resource['Infos']['Window Config'][3]['Title'] then
                for i, v in ipairs(resource['Infos']['Vehicles']) do
                    if isCursorOnElement(1578, (303 + ((i-1)*59)), 287, 62) then
                        if getPlayerMoney() < tonumber(v['Price']) then config.clientNotify(config['Messages']['notMoney'][1], config['Messages']['notMoney'][2], config['TimeDefault']); return false end
                        triggerServerEvent('CLASS >> VEHICLE MANAGER', resourceRoot, localPlayer, v, _, resource['Infos'], i, 'shop', resource['Infos']['index']);
                        functions.managePanel('close');
                    end
                end
            end
        end
    end
end
-- Dx Manager
functions.managePanel = function (state)
    if (state == 'close') then
        if resource['PanelConfig'].isEventHandlerAdded then
            resource['PanelConfig'].isEventHandlerAdded = false;
            resource['Animation'] = {
                Time = 500; -- Milissegundos
                AlphaTransition = { 1, 0 }; -- { 0, 1 } - Para abrir um painel e { 1, 0 } - Para fechar um painel
                TickCount = getTickCount();
            };
            unbindKey('backspace', 'down', functions.closeBind)
            removeEventHandler('onClientClick', root, functions.clickFunctions);
            setTimer(function()
                
                removeEventHandler('onClientRender', root, functions.render);
                showChat(true);
                showCursor(false);
                resource['Infos'] = { };
                resource['Teste'] = { };

            end, tonumber(resource['Animation'].Time), 1)

        end

        return;

    else
    
        resource = {
            ['PanelConfig'] = {
                isEventHandlerAdded = true;
                SelectWindow = 'index';
                SelectIndex = 0;
            };
            ['Animation'] = {
                Time = 200; -- Milissegundos
                AlphaTransition = { 0, 1 }; -- { 0, 1 } - Para abrir um painel e { 1, 0 } - Para fechar um painel
                TickCount = getTickCount();
            };
            ['Textures'] = {
                [1] = dxCreateTexture('archives/assets/imgs/select_bg.png', 'argb', false),
                [2] = dxCreateTexture('archives/assets/imgs/arrow.png', 'argb', false),
             };
            ['Fonts'] = { 
                [1] = dxCreateFont('archives/assets/fonts/regular.ttf', 14, false, 'cleartype'),
                [2] = dxCreateFont('archives/assets/fonts/regular.ttf', 11, false, 'cleartype'),
            };
        };
        addEventHandler('onClientClick', root, functions.clickFunctions);
        addEventHandler('onClientRender', root, functions.render);
        bindKey('backspace', 'down', functions.closeBind)
        showChat(false);
        showCursor(true);

    end
end

addEvent('CLASS >> GARAGE MANAGER', true);
addEventHandler('CLASS >> GARAGE MANAGER', resourceRoot, function(tableValues, sql, index)
    functions.managePanel('open');
    resource['Teste'] = sql;
    resource['Infos'] = tableValues
    resource['Infos']['index'] = index
end)