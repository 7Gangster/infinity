function msg ( player, msg, type, time )
    exports.crp_notify:addBox(player, msg, type, time)
end

local groups = {}
local groupMeta = {}
local peds = {}


local blip = {}
-- JOB MANAGER 

addEvent('getVPN', true)
addEventHandler('getVPN', root, function ( player )
    if exports.crp_inventory:getItem(player, 'vpn') >= 0 then 
        triggerClientEvent(player, 'updateVPN', player, true)
    end
end)

addEvent('jobmanager >> marcarjob', true)
addEventHandler('jobmanager >> marcarjob', root, function(player, job)
        print(job)
        local assets = getJobAssets ( job )
        if assets then 
            print(assets)
            --blip[player] = createBlip(assets.position[1], assets.position[2], assets.position[3], 41)
            setElementData(player, 'gpsDestination', {assets.position[1], assets.position[2]})
            msg(player, 'Emprego marcado em seu gps.', 'success')
        end
end)

addEvent('jobmaanger >> takejob', true)
addEventHandler('jobmaanger >> takejob', root, function(player, element, job)
    if element then 
        local job = getElementData(element, 'Job')
        triggerClientEvent(player, 'ProgressBar', player, 5000, 'Conversando')
        setTimer(function()
            if not getElementData(player, 'Job') then 
                setElementData(player, 'Job', job)
                msg(player, 'Bem vindo(a) à empresa. Abra seu tablet e vá até a aba de grupos para criar ou entrar em um grupo e iniciar seu serviços.', 'success', 15000)
            elseif getElementData(player, 'Job') == job then 
                if not getElementData(player, 'JobGroup') then 
                    setElementData(player, 'Job', false)
                    msg(player, 'Você foi demitido.', 'error')
                else
                    msg(player, 'Saia do grupo para pedir demissão.', 'error')
                end
            else
                msg(player, 'Você não trabalha aqui.', 'error')
            end
        end, 5000, 1)
    else
        if not getElementData(player, 'JobGroup') then 
            setElementData(player, 'Job', false)
            msg(player, 'Você foi demitido.', 'error')
        else
            msg(player, 'Saia do grupo para pedir demissão.', 'error')
        end
    end
end)

addEvent('jobmanager >> getgroups', true)
addEventHandler('jobmanager >> getgroups', root, function(player)
    if getElementData(player, 'Job') then 
        local grouplist = getGroupsInJob(getElementData(player, 'Job'))
        if #grouplist > 0 then 
            triggerClientEvent(player, 'updateGroups', player, grouplist)
        end
    end
end)

addEvent('jobmanager >> creategroup', true)
addEventHandler('jobmanager >> creategroup', root, function(player)
    if getElementData(player, 'JobGroup') then return msg(player, 'Você já faz parte de um grupo.', 'error') end
    local job = getElementData(player, 'Job')
    if job then 
        local newGroup = {
            id = getElementData(player, 'ID'),
            name = string.gsub(getPlayerName(player), '_', ' '),
            job = job,
            maxMembers = getJobAssets ( job ).maxMembers 
        }
        table.insert(groups, newGroup)
        setElementData(player, 'JobGroup', getElementData(player, 'ID'))
        triggerClientEvent(player, 'jobmanager >> notify', player, {
            nome = 'JOBCENTER',
            color = 'FFBF00',
            msg = 'Grupo criado com sucesso.',
            img = 'src/assets/notify/jobcenter.png',
        })
        --msg(player, 'Grupo criado com sucesso. ID do grupo: '..getElementData(player, 'ID'), 'success')
    end
end)

addEvent('jobmanager >> destroygroup', true)
addEventHandler('jobmanager >> destroygroup', root, function(player)
    local group = getElementData(player, 'JobGroup') 
    if getElementData(player, 'InService') then return msg(player, 'Você não pode apagar o grupo em serviço', 'error') end
    if group then
        local players = getMembersInGroup(group) 
        for i,v in ipairs(players) do 
            setElementData(v, 'JobGroup', false)
        end
        for i,v in ipairs(groups) do 
            if v.id == group then 
                table.remove(groups, i)
            end
        end
        triggerClientEvent(player, 'jobmanager >> notify', player, {
            nome = 'JOBCENTER',
            color = 'FFBF00',
            msg = 'Grupo apagado com sucesso.',
            img = 'src/assets/notify/jobcenter.png',
        })
        --msg(player, 'Grupo apagado com sucesso.', 'success')
    end
end)

addEvent('jobmanager >> quitgroup', true)
addEventHandler('jobmanager >> quitgroup', root, function(player)
    local group = getElementData(player, 'JobGroup') 
    if getElementData(player, 'InService') then return msg(player, 'Você não pode sair do grupo em serviço', 'error') end
    if group then
        setElementData(player, 'JobGroup', false)
    end
end)

addEvent('jobmanager >> kick', true)
addEventHandler('jobmanager >> kick', root, function(player, target)
    local group = getElementData(player, 'JobGroup') 
    if getElementData(player, 'InService') then return msg(player, 'Você não pode fazer isso em serviço.', 'error') end
    if group then
        setElementData(target, 'JobGroup', false)
        msg(target, 'Você foi expulso do grupo.', 'info')
        msg(player, 'Você expulsou o(a) '..getPlayerName(target), 'info')
    end
end)

local delay = {}

addEvent('jobmanager >> requestjoin', true)
addEventHandler('jobmanager >> requestjoin', root, function(player, grupo)
    local list, members = getMembersInGroup(grupo.id)
    if delay[player] then return end
    if members < grupo.maxMembers then 
        local lider = getGroupLider ( grupo.id ) 

        if lider then 
            local playerName = string.gsub(getPlayerName(player), '_', ' ')
            triggerClientEvent(lider, 'jobmanager >> notify', lider, {
                nome = 'JOBCENTER',
                color = 'FFBF00',
                msg = playerName..' pediu para entrar no grupo.',
                img = 'src/assets/notify/jobcenter.png',
                type = 'escolha',
                execute = 'jobmanager >> joingroup',
                args = {player, grupo}
            })
            msg(player, 'Pedido enviado com sucesso.', 'success')

            delay[player] = setTimer(function()
                if not getElementData(player, 'JobGroup') == grupo.id then 
                    msg(player, 'Seu pedido foi rejeitado.', 'error')
                end 
                delay[player] = nil
            end, 7000, 1)
        end

    else
        msg(player, 'O grupo está cheio.', 'error')
    end
end)

addEvent('jobmanager >> salario', true)
addEventHandler('jobmanager >> salario', root, function(player, element)
    local salario = getElementData(player, 'JobRecompensa') or 0
    if salario > 0 then 
        exports.crp_inventory:giveItem(player, 'dinheiro', salario)
        msg(player, 'Você recebeu seu salario.', 'success')
        setElementData(player, 'JobRecompensa', 0)
    else
        msg(player, 'Você não tem nada á receber.', 'error')
    end
end)

addEvent('jobmanager >> startservice', true)
addEventHandler('jobmanager >> startservice', root, function(player, job)
    print(job)
    if not getElementData(player, 'InService') then 
        if job == 'Pescador' then 
            triggerEvent('pescador >> iniciarservico', player, player)
        elseif job == 'Deluxe Express' or job == 'Express' then 
            triggerEvent('express >> startService', player, player)
        elseif job == 'Los Santos Sanitary' or job == 'Lixeiro' then 
            triggerEvent('trashman >> startService', player, player)
        end
    else
        print('ja em serviço')
    end
end)

addEvent('jobmanager >> cancelservice', true)
addEventHandler('jobmanager >> cancelservice', root, function(player, job)
    if getElementData(player, 'InService') then 
        if job == 'Pescador' then 
            triggerEvent('pescador:cancelService', player, player)
        elseif job == 'Deluxe Express' or job == 'Express' then 
            triggerEvent('express >> stopService', player, player)
        elseif job == 'Los Santos Sanitary' then 
            triggerEvent('trashman >> stopService', player, player)
        end
    end
end)

addEvent('jobmanager >> joingroup', true)
addEventHandler('jobmanager >> joingroup', root, function(player, grupo)
    local list, members = getMembersInGroup(grupo.id)
    if members < grupo.maxMembers then 
        if not getElementData(player, 'JobGroup') then 
            setElementData(player, 'JobGroup', grupo.id)
            for i, v in ipairs(list) do 
                triggerClientEvent(v, 'jobmanager >> notify', v, {
                    nome = 'JOBCENTER',
                    color = 'FFBF00',
                    msg = string.gsub(getPlayerName(player), '_', ' ')..' entrou no grupo.',
                    img = 'src/assets/notify/jobcenter.png',
                })
            end
        end
    end
end)

-- UTILS 

function getGroupsInJob ( job )
    local newGroups = {}
    for i,v in ipairs(groups) do 
        if v.job == job then 
            local list, members = getMembersInGroup(v.id) 
            table.insert(newGroups, {
                id = v.id,
                name = v.name,
                job = job,
                members = members,
                membersList = list,
                maxMembers = v.maxMembers
            })
        end
    end
    return newGroups
end

function getMembersInGroup(id) 
    local members = {}
    for i,v in ipairs(getElementsByType('player')) do 
        if getElementData(v, 'JobGroup') == id then 
            table.insert(members, v)
        end
    end
    return members, #members
end

function getJobAssets ( job )
    for i,v in ipairs(cfg.jobs) do 
        if v.element == job then 
            return cfg.jobs[i]
        end
    end
    return false
end

function getGroupLider ( id )
    local lider = false 
    local list = getMembersInGroup(id)

    for i,v in ipairs(list) do 
        if getElementData(v, 'ID') == id then 
            lider = v
            break
        end
    end

    return lider
end

function getGroupMeta (group)
    if not groupMeta[group] then 
        groupMeta[group] = {0, 0}
    end
    return groupMeta[group][1], groupMeta[group][2] 
end

function setGroupMeta (group, value, meta) 
    groupMeta[group] = {value, meta}
end

function updateGroupMeta(group, value)
    if groupMeta[group] then 
        groupMeta[group][1] = value
    end
end

function loadPeds ( )
    for i,v in ipairs(cfg.jobs) do 
        local x, y, z = unpack(v.position)
        peds[i] = createPed(v.model, unpack(v.position))
        setElementData(peds[i], 'Job', v.element)
        if v.blip then 
            createBlip(x, y, z, v.blip)
        end
    end
end

-- EVENTS 
function quitGroup ( )
    if getElementData(source, 'JobGroup') then 
        local group = getElementData(source, 'JobGroup')
        local list, members = getMembersInGroup(id) 
        if members - 1 <= 0 then 
            for i,v in ipairs(list) do 
                setElementData(v, 'JobGroup', false)
            end
            for i,v in ipairs(groups) do 
                if v.id == group then 
                    table.remove(groups, i)
                end
            end
        else
            setElementData(source, 'JobGroup', false)
        end
    end
end
addEventHandler('onPlayerQuit', root, quitGroup)
addEventHandler('onPlayerLogout', root, quitGroup)    


loadPeds ( )
