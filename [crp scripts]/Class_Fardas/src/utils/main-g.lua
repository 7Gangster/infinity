-- Eventos
function createEventHandler(event, ...)
    addEvent(event, true)
    addEventHandler(event, ...)
end

-- Mensagens
function sendMessage(srctype, ...)
    if not srctype then
        return error("sendMessage: srctype is not defined")
    end
    if srctype == "server" then
        local element = ...;
        return triggerClientEvent(element, config.notificationEvent, ...)
    elseif srctype == "client" then
        return triggerEvent(config.notificationEvent, localPlayer, ...)
    else
        return error("sendMessage: srctype is invalid")
    end
end

-- Verificar se o jogador está na ACL
function isPlayerInACL(target, acl)
    if (not isElement(target) or not acl or not aclGetGroup(acl)) then
        return false
    end

    return isObjectInACLGroup("user." .. getAccountName(getPlayerAccount(target)), aclGetGroup(acl))
end

-- Em serviço
function getPolicesInServiceFromGroup(id)
    local polices = {}
    local acl = config.organizations[id]["acl"]



    return polices
end;

local classes = {}
local interfaces = {}

local function tblCopy(t, mt)
    local t2 = {}
    for i, v in pairs(t) do
        if (not t2[i]) then
            t2[i] = v
        end
    end
    if (mt) then
        t2.super = mt
        setmetatable(t2, { __index = t2.super.array })
    end
    return t2
end

function class(className)
    return function(tbl, super)
        local class = classes[className]
        if (not class) then
            if (super) then
                super._name = super.name
            end
            tbl._name = className
            classes[className] = { name = className, array = tbl, super = super }
        end
        return tbl
    end
end

function new(className)
    return function(...)
        local classe = classes[className]
        if (not classe) then error('Class ' .. className .. ' not found') end

        local super = (classe.super and classe.super or false)
        local obj = tblCopy(classe.array, (super and super or false))

        obj.overload = function(tbl, ...)
            local args = {...}
            local func = tbl[#args]
            func(obj, ...)
        end

        if (obj.constructor) then
            obj:constructor(...)
        end
        return obj
    end
end

function extends(superObjName)
    return function(tbl)
        local super

        if (classes[superObjName]) then 
            super = classes[superObjName]
            setmetatable(tbl, {__index = super.array})
        elseif (interfaces[superObjName]) then
            super = interfaces[superObjName]
            for i, v in pairs(super) do
                tbl[i] = v
            end
        end

        return tbl, super
    end
end

function interface(interfaceName)
    return function(tbl)
        if (not interfaces[interfaceName]) then
            interfaces[interfaceName] = {}
        end

        for i, v in pairs(tbl) do
            interfaces[interfaceName][v] = v
        end

        return tbl
    end
end

function implements(interfaceName)
    return function(tbl)
        if (not interfaces[interfaceName]) then error('Interface ' .. interfaceName .. ' not found') end

        for i, v in pairs(interfaces[interfaceName]) do
            if (not tbl[v]) then
                error('Interface ' .. interfaceName .. ' not implemented, method ' .. v .. ' not found')
            end
        end

        return tbl
    end
end

function instanceOf(instance, className)
    local classe = classes[className]
    if (not classe) then error('Class ' .. className .. ' not found', 2) end

    if (instance._name == className) then
        return true
    end

    if (instance.super) then
        return instanceOf(instance.super, className)
    end

    return false
end