local db = dbConnect('sqlite', 'database.db')
dbExec(db, 'CREATE TABLE IF NOT EXISTS images (owner, fileName, path)')

addEvent('server:uploadImage', true)
addEventHandler('server:uploadImage', root, function ( player, img )

    local result = dbPoll(dbQuery(db, 'SELECT * FROM images WHERE owner = ?', getElementData(player, 'ID')), -1)

    local time = getRealTime()
    local hours = time.hour
    local minutes = time.minute
    local seconds = time.second

    local monthday = time.monthday
    local month = time.month
    local year = time.year

    local formattedTime = string.format("%02d-%02d-%04d-%02d-%02d-%02d", monthday, month + 1, year + 1900 , hours, minutes, seconds)
    local tag = getPlayerName(player)..'-'..formattedTime
    --local tag = math.random(1000000, 9999999)

    local foto = fileCreate('cache/'..tag..'.jpeg')
    fileWrite(foto, img)
    fileClose(foto)

    triggerClientEvent(player, 'client:downloadImage', player, tag, img )
    dbExec(db, 'INSERT INTO images VALUES ( ?, ?, ? )', getElementData(player, 'ID'), tag, 'cache/'..tag..'.jpeg')
    triggerEvent('getPhotos', player, player)


end)

addEvent('server:downloadImage', true)
addEventHandler('server:downloadImage', root, function(player, tag)

    if fileExists('cache/'..tag..'.jpeg') then 

        local file = fileOpen('cache/'..tag..'.jpeg')

        triggerClientEvent(player, 'client:downloadImage', player, tag, fileRead(file, fileGetSize(file)) )

        fileClose(file)

    end

end)

addEvent('server:deleteImage', true)
addEventHandler('server:deleteImage', root, function(player, tag)

    dbExec(db, 'DELETE FROM images WHERE owner = ? AND fileName = ?', getElementData(player, 'ID'), tag)
    triggerClientEvent(player, 'client:deleteImage', player, tag )
    triggerEvent('getPhotos', player, player)

end)