RegisterNetEvent("toggleText")
AddEventHandler("toggleText", function(playerId, display)
    TriggerClientEvent("toggleText", -1, playerId, display)
end)