local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('tnj-weedpicking:serverget:WetBud', function(source, cb)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local wetbud = Ply.Functions.GetItemByName("weed_wet")
    if wetbud ~= nil then
        cb(true)
    else
        cb(false)
    end
end)