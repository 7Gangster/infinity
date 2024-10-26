local screen = {guiGetScreenSize()}
local resolution = {1920, 1080}
local sx, sy = screen[1]/resolution[1], screen[2]/resolution[2]
local browser = createBrowser(screen[1], screen[2], true, true)
local link = "http://mta/local/web-side/index.html"

local notify = {}

function browserRender()
    for i,v in ipairs(notify) do 
        if (getTickCount()-v.tick)/v.time >= 1 then 
            table.remove(notify, i)
        end
    end
    if #notify > 0 then 
        dxDrawImage(sx*(50), sy*50, sx*(1920-50), sy*(1080-50), browser, 0, 0, 0, tocolor(255, 255, 255, 255), true)
    end
end

addEventHandler("onClientBrowserCreated", browser, function()
	loadBrowserURL(source, link)
    outputDebugString( "CRP - Notify: Carregado")
    addEventHandler("onClientRender", root, browserRender)
end)

function addBox(message, type, time)
    local time = time or 10000 
    local type = type or 'default'
    table.insert(notify, {tick = getTickCount(), time = time or 10000})
    if message then 
        --executeBrowserJavascript(browser, "window.postMessage( { css: '"..type.."', mensagem: '"..message.."', timer: "..time..", notify: true }, '*' )")
        SendNUIMessage(browser, {css = type, mensagem = message, timer = time, notify = true})
    end
end
addEvent("addBox", true)
addEventHandler("addBox", root, addBox)

function SendNUIMessage ( browser, data )

    local execute = ''
    local index = 0
    for i,v in pairs (data) do 
        index = index + 1
        if type(v) == 'string' then
            execute = execute..' '..i..': "'..v..'",'
        elseif type(v) == 'number' or v == true or v == false then 
            execute = execute..' '..i..': '..tostring(v)..','
        end
    end

    local execute = "window.postMessage( {"..execute.."}, '*' )"
    executeBrowserJavascript(browser, execute)

end