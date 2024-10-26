---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- MSG
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function msgBox(player, text, type, time)
    triggerClientEvent(player, "addBox", root, text, type, time)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- GERAR PORTAS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

objportas = {}
colportas = {}
function zncreateportas()
    for k,v in pairs(cfg.portas) do

        if v["tamanho"] then
            tamc = v["tamanho"]
        else
            tamc = 1
        end

        objportas[k] = createObject(tonumber(v["model"]), v["posicao"][1], v["posicao"][2], v["posicao"][3])

        setElementRotation(objportas[k], 0, 0, v["rot"][1])

        setElementFrozen(objportas[k], true)
        setElementData(objportas[k], "ZN-PortasStatus", true)

        setElementData(objportas[k], "ZN-PortasObj", true)
        setElementData(objportas[k], "ZN-PortasObj-Rot", v["rot"][1])
        setElementData(objportas[k], "ZN-PortasObj-Tag", v["tag"])
        setElementData(objportas[k], "ZN-PortasObj-ID", k)

        if v["tipo"] == "portão" then
            setElementData(objportas[k], "ZN-PortasObj", true)
            setElementData(objportas[k], "ZN-PortasObj-Pos", toJSON({v["posicao"][1], v["posicao"][2], v["posicao"][3], v["posicao"][4], v["posicao"][5], v["posicao"][6]}))
            setElementData(objportas[k], "ZN-PortasObj-Portão", true)
            setElementData(objportas[k], "ZN-PortasObj-PortãoFechado", true)
        else
            setElementData(objportas[k], "ZN-PortasObj-Pos", toJSON({v["posicao"][1], v["posicao"][2], v["posicao"][3]}))
        end

    end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), zncreateportas)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- DESTRANCAR PORTA
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

timers = {}
function zndestrancarporta(ply, ido)
    if ply and ido then
        obj = objportas[ido]
        local acl = getElementData(obj, "ZN-PortasObj-Tag")
        if not isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(ply)), aclGetGroup(acl)) then return end
        if getElementData(obj, "ZN-PortasObj-Portão") == true then
            local ppos1 = fromJSON(getElementData(obj, "ZN-PortasObj-Pos"))
            if not isTimer(timers[obj]) then
                if getElementData(obj, "ZN-PortasObj-PortãoFechado") == true then
                    setElementData(obj, "EmTransicao", true)
                    if tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 16 or tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 43 or tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 44 or tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 49 or tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 50 then
                        if tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 16 then
                            moveObject(obj, 2500, ppos1[4], ppos1[5], ppos1[6], 90, 0, 0)
                        elseif tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 43 then
                            moveObject(obj, 2500, ppos1[4], ppos1[5], ppos1[6], 0, 0, -90)
                        elseif tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 44 then
                            moveObject(obj, 2500, ppos1[4], ppos1[5], ppos1[6], 0, 0, 90)
                        elseif tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 49 or tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 50 then
                            moveObject(obj, 2500, ppos1[4], ppos1[5], ppos1[6], 90, 0, 0)
                        end
                    else
                        moveObject(obj, 2500, ppos1[4], ppos1[5], ppos1[6])
                    end
                    setElementData(obj, "ZN-PortasObj-PortãoFechado", false)
                    setElementData(obj, "ZN-PortasStatus", false)

                    timers[obj] = setTimer(function()
                        if isTimer(timers[obj]) then
                            killTimer(timers[obj])
                            timers[obj] = nil
                        end
                        setElementData(obj, "EmTransicao", false)
                    end, 2500, 1)

                else
                    setElementData(obj, "EmTransicao", true)
                    if tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 16 or tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 43 or tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 44 or tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 49 or tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 50 then
                        if tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 16 then
                            moveObject(obj, 2500, ppos1[1], ppos1[2], ppos1[3], -90, 0, 0)
                        elseif tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 43 then
                            moveObject(obj, 2500, ppos1[1], ppos1[2], ppos1[3], 0, 0, 90)
                        elseif tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 44 then
                            moveObject(obj, 2500, ppos1[1], ppos1[2], ppos1[3], 0, 0, -90)
                        elseif tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 49 or tonumber(getElementData(obj, "ZN-PortasObj-ID")) == 50 then
                            moveObject(obj, 2500, ppos1[1], ppos1[2], ppos1[3], -90, 0, 0)
                        end
                    else
                        moveObject(obj, 2500, ppos1[1], ppos1[2], ppos1[3])
                    end
                    setElementData(obj, "ZN-PortasObj-PortãoFechado", true)
                    setElementData(obj, "ZN-PortasStatus", true)

                    timers[obj] = setTimer(function()
                        if isTimer(timers[obj]) then
                            killTimer(timers[obj])
                            timers[obj] = nil
                        end
                        setElementData(obj, "EmTransicao", false)
                        timers[obj] = nil
                    end, 2500, 1)
                end
            end
        else
            if isElementFrozen(obj) then
                setElementFrozen(obj, false)
                setElementData(obj, "ZN-PortasStatus", false)
                triggerEvent("ZN-EnviarLogDiscord", ply, ply, "**➥  ID "..getElementData(ply, "ID").."** - abriu a porta **("..getElementData(obj, "ZN-PortasObj-ID")..")**.", "Portas")
            else
                setElementFrozen(obj, true)
                if getElementData(obj, 'ZN-PortasObj-Rot') then
                    setElementRotation(obj, getElementData(obj, 'ZN-PortasObj-Rot'))
                end
                setElementData(obj, "ZN-PortasStatus", true)
                triggerEvent("ZN-EnviarLogDiscord", ply, ply, "**➥  ID "..getElementData(ply, "ID").."** - fechou a porta **("..getElementData(obj, "ZN-PortasObj-ID")..")**.", "Portas")
            end
        end
    end
end
addEvent("ZN-DestrancarPortas", true)
addEventHandler("ZN-DestrancarPortas", root, zndestrancarporta)