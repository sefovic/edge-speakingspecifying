local displayText = false
local activePlayer = nil
local chatOpen = false
local displayTexts = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not chatOpen then
            local playerId = PlayerId()
            local ped = GetPlayerPed(playerId)
            local coords = GetEntityCoords(ped)
            local camCoords = GetGameplayCamCoords()
            for _, id in ipairs(GetActivePlayers()) do
                if displayTexts[id] then
                    local targetPed = GetPlayerPed(id)
                    local targetCoords = GetEntityCoords(targetPed)
                    local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, targetCoords.x, targetCoords.y, targetCoords.z, true)
                    if distance <= 50.0 then
                        DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 1.25, "[..]")
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerId = PlayerId()
        if IsControlJustReleased(0, 245) then
            displayTexts[playerId] = not displayTexts[playerId]
            TriggerServerEvent("toggleText", playerId, displayTexts[playerId])
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent("toggleText")
AddEventHandler("toggleText", function(playerId, display)
    if playerId then
        displayTexts[playerId] = display
    else
        displayTexts[1] = display
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)

    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen and distance <= 50.0 then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(1, 1, 1, 1, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 245) then
            displayText = not displayText
            TriggerServerEvent("toggleText")
            Citizen.Wait(200)
        end
    end
end)
