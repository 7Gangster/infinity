local imageTexture = dxCreateRenderTarget(500, 900, false)
local screenSource = dxCreateScreenSource(1920, 1080)

local downloading = {}
local downloadedImages = {}
local playersImage = {}

addEvent('client:downloadImage', true)
addEventHandler('client:downloadImage', root, function ( tag, img )

    if not fileExists('cache/'..tag..'.jpeg') then 
        --local txd = cutImage ( img )
        --local img = dxConvertPixels ( dxGetTexturePixels(txd), 'jpeg')
        local file = fileCreate('cache/'..tag..'.jpeg')
        fileWrite(file, img)
        fileClose(file)

        table.insert(playersImage, {tag = 'cache/'..tag..'.jpeg', img = img})

        downloading[tag] = false
        downloadedImages[tag] = true
    end

end)

addEvent('client:deleteImage', true)
addEventHandler('client:deleteImage', root, function ( tag )

    if fileExists('cache/'..tag..'.jpeg') then 

        downloading[tag] = false
        downloadedImages[tag] = false

        fileDelete('cache/'..tag..'.jpeg')
        
    end

end)


function takePicture ( )
    dxUpdateScreenSource(screenSource)
    
    local img = dxConvertPixels ( dxGetTexturePixels(cutImage(screenSource)), 'jpeg')
    triggerServerEvent('server:uploadImage', localPlayer, localPlayer, img)
    
end

function cutImage ( img ) 

    local pictureW, pictureH = 1920, 1080
    local u, v = pictureW/2-(500/2), pictureH/2-(900/2)
    
    if type(img) == 'string' then
        local texture = dxCreateTexture(img)
        dxSetRenderTarget(imageTexture, true)
        
        dxDrawImageSection(0, 0, 667, 1100, u, v, 500, 900, texture)

        dxSetRenderTarget()

        destroyElement(texture)
    elseif isElement(img) then 

        dxSetRenderTarget(imageTexture, true)
        
        dxDrawImageSection(0, 0, 667, 1100, u, v, 500, 900, img)

        dxSetRenderTarget()

    end
    return imageTexture

end

function getPlayerPictures ()
    return playersImage
end

function downloadImage ( tag )
    if not downloading[tag] then 
        if not fileExists('cache/'..tag..'.jpeg') then 
            triggerServerEvent('server:downloadImage', localPlayer, localPlayer, tag)
            downloading[tag] = true
        end
    end
end

function isDownloadedImage ( tag )
    return downloadedImages[tag]
end

function isDownloadingImage ( tag )
    return downloading[tag]
end