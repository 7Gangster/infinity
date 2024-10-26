local markers = {}
local playerdata = {}
local function onResourceEvents()

    for tblKey, tblValue in pairs(config.positions) do
        for key, value in ipairs(tblValue) do
            local markerColor = (tblKey == "manager" and { 103, 188, 138, 0 } or { 200, 50, 50, 255 * 0.2 })
            local markerElement = createMarker(Vector3(unpack(value)), "cylinder", (tblKey == "manager" and 2 or 4), unpack(markerColor))
            if value.interior then 
                setElementInterior(markerElement, value.interior)
            end
            if tblKey == "manager" then
                local fakemarker = exports["crp_markers"]:createMarker("marker", Vector3 { value[1], value[2], value[3] -0.9, 'cylinder', 1.5, 255, 255, 255, - 0.9 } )
                if value.interior then 
                    setElementInterior(fakemarker, value.interior)
                end
            end

            markers[markerElement] = {
                type = tblKey
            }
        end
    end
end
addEventHandler("onResourceStart", resourceRoot, onResourceEvents)

-- # Eventos do Marcador

local function getPlayerManager(target)
    if (not isElement(target)) then
        return false
    end

    for key in pairs(config.organizations) do
        if (isPlayerInACL(target, config.organizations[key]["acl"])) then
            return key
        end
    end

    return false
end;

local function onMarkerEvents(element, dimension)
    
    if (not markers[source]) then
        return false
    end
    if element and isElement(element) and getElementType(element) == "player" then
        local markerType = markers[source]["type"]
        if (not getPlayerManager(element)) then
            return markerType == "manager" and sendMessage("server", element, "Você não tem permissão para acessar este painel.", "error")
        end
        if (markerType == "manager") then
            local organization = getPlayerManager(element)
            return triggerClientEvent(element, "onClientOpenManager", element, organization, getPolicesInServiceFromGroup(organization))
        else
        end
    end
end
addEventHandler("onMarkerHit", resourceRoot, onMarkerEvents)

-- # Executar Ações

createEventHandler("onTargetExecute", root, function(window, values)
    if (not isElement(client)) then
        return false
    end

    if (window == "personages") then
        if getElementData(client, 'police >> duty') or getElementData(client, 'paramedic >> duty') then
            
            local roupas = values['roupas']
            exports['agatreix_custom']:setroupapm(client, values['model'], roupas)

            sendMessage("server", client, "Você acaba de trocar de roupa.", "success")
        else
            sendMessage("server", client, "Entre em serviço para trocar de roupa.", "error")
        end
    end
end)