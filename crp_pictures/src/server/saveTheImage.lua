local theDatabase = dbConnect("sqlite", "src/server/pictures/thePaths.db")

function saveTheImage(player, texture, attributes)
    if player and texture then
        local playerName = string.gsub(getPlayerName(player), '_', '-')
        local playerID = getElementData(player, "ID") or 0
        local fileName = playerName..'-'..playerID..'-'..math.random(000001, 999999)
        local thePath = "src/server/pictures/"..fileName..".json"
        if fileExists(thePath) then return saveTheImage(player, texture) end
        local thePicture = fileCreate(thePath)
        fileWrite(thePicture, texture)
        fileClose(thePicture)

        dbExec(theDatabase ,"INSERT INTO the_images(fileName, attributes, path, player) VALUES (?,?,?,?)", fileName, toJSON(attributes), thePath, getAccountName(getPlayerAccount(player)))
        sendCache(player, thePath, fileName, toJSON(attributes))
    end
end
addEvent("class:saveImage", true)
addEventHandler("class:saveImage", root, saveTheImage)

function sendCache(player, path, fileName, attributes)
    triggerClientEvent(player, 'class:loadCachePicture', player, fileName, path, fromJSON(attributes))
end

function getTexture(player, path, attributes)
    local theFile = fileOpen(path)
    local fileSize = fileGetSize(theFile)
    local fileData = fileRead(theFile, fileSize)
    if fileData then
        triggerClientEvent(player, "class:loadTextureToClient", player, fileData, attributes)
    end
end
addEvent("class:getTexturePic", true)
addEventHandler("class:getTexturePic", root, getTexture)

function getPictures()
    local theDatas
    local result = dbPoll(dbQuery(theDatabase, 'SELECT * FROM the_images'), -1)
    for ind, row in ipairs(result) do
        theDatas = {ind, row}
    end
    return theDatas
end


local function init()
    dbExec(theDatabase,"CREATE TABLE IF NOT EXISTS the_images(fileName TEXT, attributes JSON, path TEXT, player TEXT)")
    setTimer(function()
        local result = dbPoll(dbQuery(theDatabase, 'SELECT * FROM the_images'), -1)
        for _, row in ipairs(result) do
            local player = getPlayerFromAccountName(row["player"])
            sendCache(player, row["path"], row["fileName"], row["attributes"])
        end
    end, 5000, 1)
end
addEventHandler("onResourceStart", resourceRoot, init)
