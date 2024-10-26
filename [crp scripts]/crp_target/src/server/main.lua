

local motors = {
    ['Automobile'] = 'motorb',
    ['Bike'] = 'motora',
}

addEvent('interaction >> opencobranca', true)
addEventHandler('interaction >> opencobranca', root, function(player, element)
    triggerClientEvent(player, 'interaction >> sendmoney:openpanel', player, element)
end)

addEvent('interaction >> sendcobranca', true)
addEventHandler('interaction >> sendcobranca', root, function(player, target, valor)
    local valor = math.floor(math.abs(valor))
    msg(player, 'Cobrança enviada. Aguarde a resposta.', 'info')
    triggerClientEvent(target, 'openInfoCobranca', target, player, valor)
end)

addEvent('accept >> cobranca', true)
addEventHandler('accept >> cobranca', root, function(target, sender, valor)
    local valor = math.floor(math.abs(valor))
    if getPlayerMoney(target) >= tonumber(valor) then
         msg(sender, 'O jogador pagou a cobrança e você recebeu R$'..valor, 'success')
         msg(target, 'Você pagou a cobrança de R$'..valor, 'info')
         takePlayerMoney(target, valor)
         givePlayerMoney(sender, valor)
    else
        msg(target, 'Você não possui dinheiro suficiente.', 'error')
        msg(sender, 'O jogador não possui dinheiro suficiente', 'error')
    end
end)

addEvent('interaction >> doc', true)
addEventHandler('interaction >> doc', root, function(player, element)
    exports['crp_notify']:addBox(player, 'Placa do Veiculo: '..getVehiclePlateText(element), 'info')
    exports['crp_notify']:addBox(player, 'Dono do Veiculo: '..(getElementData(element, 'Vehicle > Owner') or 'Sem registro'), 'info')
end)

addEvent('mecanic >> repair', true)
addEventHandler('mecanic >> repair', root, function(player, element)
    if inv:getItem(player, motors[getVehicleType(element)]) >= 1 and inv:getItem(player, 'kitreparo') >= 1 then 
        --if getVehicleDoorOpenRatio ( element, 0 ) == 1 or getVehicleDoorState(element, 0) == 4 then
            setPedAnimation(player, 'BOMBER', 'BOM_Plant', -1, true, false, false, false)
            exports['crp_notify']:addBox(player, 'Arrumando o motor...', 'info')
            setElementFrozen(element, true)
            inv:takeItem(player, motors[getVehicleType(element)], 1)
            triggerClientEvent(player, 'ProgressBar', player, 10000)
            setTimer(function()
                setElementHealth(element, 999)
                setPedAnimation(player)
                setElementFrozen(element, false)
            end, 10000, 1)
        --else
            --exports['crp_notify']:addBox(player, 'Abra o capô para concertar o motor.', 'error')
        --end
    else
        exports['crp_notify']:addBox(player, 'Você precisa de um motor ('..motors[getVehicleType(element)]..') e um kit de ferramentas', 'error')
    end
end)

-- trocar pneuss

addEvent('mecanic >> wheelfrontLeft', true)
addEventHandler('mecanic >> wheelfrontLeft', root, function(player, element)
    if inv:getItem(player, 'pneub') >= 1 and inv:getItem(player, 'kitreparo') >= 1 then 
        setPedAnimation(player, 'BOMBER', 'BOM_Plant', -1, true, false, false, false)
        exports['crp_notify']:addBox(player, 'Trocando o pneu...', 'info')
        setElementFrozen(element, true)
        inv:takeItem(player, 'pneub', 1)
        triggerClientEvent(player, 'ProgressBar', player, 10000)
        setTimer(function()
            setVehicleWheelStates ( element, 0)
            setPedAnimation(player)
            setElementFrozen(element, false)
        end, 10000, 1)
    else
        exports['crp_notify']:addBox(player, 'Você precisa de um pneus e um kit de ferramentas', 'error')
    end
end)

addEvent('mecanic >> wheelrearLeft', true)
addEventHandler('mecanic >> wheelrearLeft', root, function(player, element)
    if inv:getItem(player, 'pneub') >= 1 and inv:getItem(player, 'kitreparo') >= 1 then 
        setPedAnimation(player, 'BOMBER', 'BOM_Plant', -1, true, false, false, false)
        exports['crp_notify']:addBox(player, 'Trocando o pneu...', 'info')
        setElementFrozen(element, true)
        inv:takeItem(player, 'pneub', 1)
        triggerClientEvent(player, 'ProgressBar', player, 10000)
        setTimer(function()
            setVehicleWheelStates ( element, -1, 0)
            setPedAnimation(player)
            setElementFrozen(element, false)
        end, 10000, 1)
    else
        exports['crp_notify']:addBox(player, 'Você precisa de um pneus e um kit de ferramentas', 'error')
    end
end)

addEvent('mecanic >> wheelfrontRight', true)
addEventHandler('mecanic >> wheelfrontRight', root, function(player, element)
    if inv:getItem(player, 'pneub') >= 1 and inv:getItem(player, 'kitreparo') >= 1 then 
        setPedAnimation(player, 'BOMBER', 'BOM_Plant', -1, true, false, false, false)
        exports['crp_notify']:addBox(player, 'Trocando o pneu...', 'info')
        setElementFrozen(element, true)
        inv:takeItem(player, 'pneub', 1)
        triggerClientEvent(player, 'ProgressBar', player, 10000)
        setTimer(function()
            setVehicleWheelStates ( element, -1, -1, 0)
            setPedAnimation(player)
            setElementFrozen(element, false)
        end, 10000, 1)
    else
        exports['crp_notify']:addBox(player, 'Você precisa de um pneus e um kit de ferramentas', 'error')
    end
end)

addEvent('mecanic >> wheelrearRight', true)
addEventHandler('mecanic >> wheelrearRight', root, function(player, element)
    if inv:getItem(player, 'pneub') >= 1 and inv:getItem(player, 'kitreparo') >= 1 then 
        setPedAnimation(player, 'BOMBER', 'BOM_Plant', -1, true, false, false, false)
        exports['crp_notify']:addBox(player, 'Trocando o pneu...', 'info')
        setElementFrozen(element, true)
        inv:takeItem(player, 'pneub', 1)
        triggerClientEvent(player, 'ProgressBar', player, 10000)
        setTimer(function()
            setVehicleWheelStates ( element, -1, -1, -1, 0)
            setPedAnimation(player)
            setElementFrozen(element, false)
        end, 10000, 1)
    else
        exports['crp_notify']:addBox(player, 'Você precisa de um pneus e um kit de ferramentas', 'error')
    end
end)

--[[
============================================
                POLICIAL
============================================
]]
local agarrado = {}
local preso = {}
local prendeu = {}

function agarrar(playerSource, alvo)
    local x, y, z = getElementPosition(playerSource)
    local ex, ey, ez = getElementPosition(alvo)
    if getDistanceBetweenPoints3D(x, y, z, ex, ey, ez) <= 2 then
        if not getElementData(playerSource, "Agarrando") then
            toggleControl(playerSource, "sprint", false)
            toggleControl(playerSource, "jump", false)
            toggleAllControls(alvo, false, true, false)
            setElementData(alvo, 'Agarrado', true)
            agarrado[alvo] = true
            setElementData(playerSource, "Agarrando", alvo)
            local x, y, z = getElementRotation(playerSource)
            setElementRotation(alvo, x, y, z)
            attachElements(alvo, playerSource, 0, 0.5, 0)
            exports.crp_notify:addBox(playerSource, 'Use /soltar para soltar o jogador.', 'info')
        else
            if agarrado[alvo] and getElementData(playerSource, "Agarrando") == alvo then
                setElementData(alvo, 'Agarrado', nil)
                toggleControl(playerSource, "sprint", true)
                toggleControl(playerSource, "jump", true)
                toggleAllControls(alvo, true)
                detachElements(alvo, playerSource)
                agarrado[alvo] = nil
                removeElementData(playerSource, "Agarrando")
            end
        end
    else
        exports.crp_notify:addBox(playerSource, "Você está muito distante do jogador", "error")
    end
end
addEvent("int>Agarrar", true)
addEventHandler("int>Agarrar", root, agarrar)

local emergencyVeh = {579, 596, 597, 490}

function prender(playerSource, alvo)
    local x, y, z = getElementPosition(playerSource)
    local ex, ey, ez = getElementPosition(alvo)
    if getDistanceBetweenPoints3D(x, y, z, ex, ey, ez) <= 2 then
        local counter = 0
        if not preso[alvo] then
            for _, veiculos in pairs(getElementsByType("vehicle")) do
                local x, y, z = getElementPosition(playerSource)
                local ex, ey, ez = getElementPosition(veiculos)
                if getDistanceBetweenPoints3D(x, y, z, ex, ey, ez) <= 5 then
                    for i, v in pairs(emergencyVeh) do
                        if v == getElementModel(veiculos) then
                            exports.crp_notify:addBox(playerSource, "Você prendeu o criminoso "..getPlayerName(alvo), "success")
                            exports.crp_notify:addBox(alvo, "Você preso pelo policial "..getPlayerName(playerSource), "warning")
                            counter = counter + 1
                            preso[alvo] = true
                            prendeu[playerSource] = alvo
                            setPedAnimation(alvo, "ped", "cower", -1, true)
                            attachElements(alvo, veiculos, 0, -1.85, 0.6)
                            exports.crp_notify:addBox(playerSource, 'Use /soltar para retirar o jogador da viatura.', 'info')
                            break
                        end
                    end
                end
            end
        end
        if counter < 1 then
            exports.crp_notify:addBox(playerSource, "Você precisa estar próximo de um veículo policial", "error")
        end
    else
        exports.crp_notify:addBox(playerSource, "Você está muito distante do jogador", "error")
    end
end
addEvent("int>Prender", true)
addEventHandler("int>Prender", root, prender)

function Soltar(playerSource)
    if prendeu[playerSource] then
        local alvo = prendeu[playerSource]
        local x, y, z = getElementPosition(playerSource)
        local ex, ey, ez = getElementPosition(alvo)
        if getDistanceBetweenPoints3D(x, y, z, ex, ey, ez) <= 5 then
            exports.crp_notify:addBox(playerSource, "Você soltou o criminoso "..getPlayerName(alvo), "success")
            exports.crp_notify:addBox(alvo, "Você foi solto pelo policial "..getPlayerName(playerSource), "info")
            detachElements(alvo, veiculo)
            setPedAnimation(alvo, nil)
            setElementData(alvo, 'Agarrado', false)
            local x, y, z = getElementPosition(playerSource)
            setElementPosition(alvo, x + 0.7, y + 0.7, z + 1)
            preso[alvo] = nil
            prendeu[playerSource] = nil
        else
            exports.crp_notify:addBox(playerSource, "Você está muito distante do jogador", "error")
        end
    end
    if getElementData(playerSource, "Agarrando") then
        local alvo = getElementData(playerSource, "Agarrando")
        local x, y, z = getElementPosition(playerSource)
        local ex, ey, ez = getElementPosition(alvo)
        if getDistanceBetweenPoints3D(x, y, z, ex, ey, ez) <= 5 then
            toggleControl(playerSource, "sprint", true)
            toggleControl(playerSource, "jump", true)
            toggleAllControls(alvo, true)
            detachElements(alvo, playerSource)
            setElementData(playerSource, "Agarrando", false)
            agarrado[alvo] = nil
        else
            exports.crp_notify:addBox(playerSource, "Você está muito distante do jogador", "error")
        end
    end
end
addCommandHandler("soltar", Soltar)

addEvent('interaction >> assault', true)
addEventHandler('interaction >> assault', root, function(player, element)
    if not getElementData(element, 'Assaltado') then 
        setElementFrozen(element, true)
        setElementFrozen(player, true)
        setPedAnimation(player, 'ped', 'gang_gunstand', -1, false, true, false, false)
        setPedAnimation( element, 'ped', 'handsup', -1, false, false, false, true )
        setElementData(element, 'Assaltado', true)
        setTimer(function()
            setElementFrozen(element, false)
            setElementFrozen(player, false)
            setPedAnimation(element, 'GANGS', 'prtial_hndshk_biz_01', 2000)
            local randomItems = {
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-2-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                --{'pendrive'},
                {'acessorios-1-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'faca'},
                
                
                --{'pendrive'},
                {'acessorios-2-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-2-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                --{'pendrive'},
                {'acessorios-1-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'faca'},
                
                
                --{'pendrive'},
                {'acessorios-2-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-2-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                --{'pendrive'},
                {'acessorios-1-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'faca'},
                
                
                --{'pendrive'},
                {'acessorios-2-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-2-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                --{'pendrive'},
                {'acessorios-1-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'faca'},
                
                
                --{'pendrive'},
                {'acessorios-2-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-2-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                --{'pendrive'},
                {'acessorios-1-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'faca'},
                
                
                --{'pendrive'},
                {'acessorios-2-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-2-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                --{'pendrive'},
                {'acessorios-1-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'faca'},
                
                
                --{'pendrive'},
                {'acessorios-2-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-2-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                --{'pendrive'},
                {'acessorios-1-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'faca'},
                
                
                --{'pendrive'},
                {'acessorios-2-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-2-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                --{'pendrive'},
                {'acessorios-1-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'faca'},
                
                
                --{'pendrive'},
                {'acessorios-2-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-2-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                --{'pendrive'},
                {'acessorios-1-2'},
                {'corrente'},
                {'hkp7m'},
                {'celular'},
                {'radio'},
                {'faca'},
                
                
                --{'pendrive'},
                {'acessorios-2-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-2-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                --{'pendrive'},
                {'acessorios-1-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'faca'},
                
                
                --{'pendrive'},
                {'acessorios-2-2'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
                {'pendrive'},
                {'acessorios-1-1'},
                {'corrente'},
                {'celular'},
                {'radio'},
            }
            local random = math.random(1, #randomItems)
            local item = randomItems[random][1]
            if item then
                exports.crp_inventory:giveItem(player, item, 1)
            end
            givePlayerMoney(player, math.random(20, 170))
            exports.crp_notify:addBox(player, 'Pegue tudo que eu tenho!', 'info')
            setTimer(function()
                setPedAnimation(element)
                setPedAnimation(player)
            end, 2000, 1)
        end, 5000, 1)
    end
end)

vasculhando = {}
timerlixo = {}

addEvent('interaction >> vasculhar', true)
addEventHandler('interaction >> vasculhar', root, function(player, element)
    if timerlixo[element] then return exports.crp_notify:addBox(player, 'Lixeira vazia. Aguarde '..math.floor(getTimerDetails(timerlixo[element])/1000)..' segundos.', 'error') end
    if not vasculhando[player] then 
        local items = {
            {false},
            {false},
            {false},
            {false},
            {false},
            {false},
            {false},
            {'metal', 1},
            {'aluminio', 1},
            {'titanium', 1},
            {'elastico', 2},
            {'ziplock', 1},
            {'garrafaq', 1},
            {'capsula', 3},
            {'tecido', 3},
            {'pano', 3},
            {'kevlar', 2},
            {'metal', 1},
            {'aluminio', 1},
            {'titanium', 1},
            {'aluminio', 1},
            {'titanium', 1},
            {'aluminio', 1},
            {'titanium', 1},
            {'aluminio', 1},
            {'titanium', 1},
            {'titanium', 1},
            {'aluminio', 1},
            {'titanium', 1},
            {'elastico', 2},
            {'ziplock', 1},
            {'polvoraa', 3},
            {'polvoraa', 3},
            {'garrafaq', 1},
            {'capsula', 3},
            {'tecido', 3},
            {'pano', 3},
            {'kevlar', 1},
            {'metal', 1},
            {'titanium', 1},
            {'elastico', 2},
            {'ziplock', 1},
            {'aluminio', 1},
            {'garrafaq', 1},
            {'capsula', 3},
            {'tecido', 3},
            {'pano', 3},
            {'polvoraa', 3},
            {'polvoraa', 3},
            {'polvoraa', 3},
            {'polvoraa', 3},
            {'polvoraa', 3},
            {'polvorab', 3},
            {'polvorab', 3},
            {'polvorab', 3},
            {'polvorac', 3},
            {'polvorac', 3},
            {'polvorad', 3},
        }
        exports.crp_notify:addBox(player, 'Vasculhando lixeira...', 'info')
        triggerClientEvent(player, 'ProgressBar', player, 5000, 'Vasculhando')
        setPedAnimation(player, 'INT_SHOP', 'shop_loop', -1, false, false, false)
        vasculhando[player] = setTimer(function()
            local i = math.random(1, #items)
            if items[i][1] then 
                local health = {30, 60, 100}
                exports.crp_inventory:giveItem(player, items[i][1], items[i][2], {
                    health = health[math.random(1, #health)]
                })
            else
                exports.crp_notify:addBox(player, 'Você não encontrou nada.', 'error')
            end
            setPedAnimation(player)
            vasculhando[player] = nil
        end, 5000, 1)
        timerlixo[element] = setTimer(function()
            timerlixo[element] = nil
        end, 60000*7, 1)
    end
end)

function sairMaca (player, b, s, element)
    if getElementData(player, 'Tratamento') then return end
    setElementData(player, 'Deitado', false)
    setElementData(element, 'Ocupada', false)
    setPedAnimation(player)
    setElementFrozen(player, false)
    toggleAllControls(player, true)
    exports.crp_notify:addBox(player, 'Você saiu da maca', 'info')
    unbindKey(player, 'space', 'down', sairMaca)
end

addEvent('maca >> deitar', true)
addEventHandler('maca >> deitar', root, function(player, element)
    if not getElementData(player, 'Deitado') and not getElementData(element, 'Ocupada') then 
        local x, y, z = getElementPosition(element)
        setElementPosition(player, x, y, z+0.3)
        setElementData(player, 'Deitado', true)
        setElementData(element, 'Ocupada', true)
        setElementFrozen(player, true)
        setPedAnimation(player, 'CRACK', 'crckidle2', -1, true, false, false, false)
        toggleAllControls(player, false, true, false)
        exports.crp_notify:addBox(player, 'Você deitou na maca, pressione "SPACE" para sair.', 'info')
        bindKey(player, 'space', 'down', sairMaca, element)
    else
        exports.crp_notify:addBox(player, 'Essa maca está ocupada', 'error')
    end
end)

function getPlayerMoney ( player )
    return exports.crp_inventory:getItem(player, 'dinheiro') or 0
end

function givePlayerMoney ( player, amount )
    return exports.crp_inventory:giveItem(player, 'dinheiro', amount) or false
end

function takePlayerMoney ( player, amount )
    return exports.crp_inventory:takeItem(player, 'dinheiro', amount) or false
end

