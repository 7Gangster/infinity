local screenW, screenH = guiGetScreenSize()
local screenSource
local renderTarget = dxCreateRenderTarget(300, 600, false)
local pictureW, pictureH

local pictures = {}

function takePicture(width, height)
    pictureW = width
    pictureH = height
    screenSource = dxCreateScreenSource(width, height)
    setTimer(function()
        dxUpdateScreenSource(screenSource)
        local theImage = dxConvertPixels(dxGetTexturePixels(screenSource), 'jpeg')
        local attributes = {
            width = width,
            height = height
        }
        if theImage and attributes then
            triggerServerEvent('class:saveImage', localPlayer, localPlayer, theImage, attributes)
        end
    end, 1000, 1)
end

function setCache(fileName, path, attributes)
    if path then
        if not pictures then pictures = {} end
        table.insert(pictures, {name = fileName, path = path, theAttr = attributes})
        iprint('Cache pictures loaded')
    end
end
addEvent("class:loadCachePicture", true)
addEventHandler("class:loadCachePicture", root, setCache)

function loadTextureToClient(theTexture, attributes)
    cutImage(theTexture, attributes)
end
addEvent("class:loadTextureToClient", true)
addEventHandler("class:loadTextureToClient", root, loadTextureToClient)    

function getPictures()
    return pictures
end

-- TO DEV

addCommandHandler('foto', function ( cmd, width, height)
    takePicture(width, height)
end)

addCommandHandler("GET", function(cmd, index)
    index = tonumber(index) or 1
    iprint(pictures[index])
    triggerServerEvent('class:getTexturePic', localPlayer, localPlayer, pictures[index].path, pictures[index].theAttr)
end)

-- RENDERS

function cutImage(theTexture, attributes) 
    local pictureW, pictureH = attributes.width, attributes.height
    local texture = dxCreateTexture(theTexture)
    local x, y = pictureW/2-(300/2), pictureH/2-(600/2)
    dxSetRenderTarget(renderTarget, true)
        dxDrawImageSection(0, 0, 300, 600, x, y, 300, 600, texture)
    dxSetRenderTarget()
    destroyElement(texture)
    return renderTarget
end

local function render()
    dxDrawImage(screenW / 2 - 300 / 2, screenH / 2 - 600 / 2, 300, 600, renderTarget)
end
addEventHandler('onClientRender', root, render)