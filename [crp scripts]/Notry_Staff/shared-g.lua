apiName = "Notry_assets"

config = {
    pAttach = "crp_attach",
    
    ACLAdmin = "Staff",
    MasterAdmin = "Console",
    ElementDataBase = "Notry:staffMode",

    -- Wall
    HexColor = "#08ff31",
    WallDistance = 10000,
    WallColor = { 8, 255, 49, 175 },

    -- Infobox
    notifyS = function (player, text, type)
        exports["crp_notify"]:addBox(player, text, type)
    end,
    
    notifyC = function (text, type)
        triggerEvent('addBox', localPlayer, text, type)
    end
}