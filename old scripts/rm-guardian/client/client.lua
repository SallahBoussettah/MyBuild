VORPcore = {}

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

-- Initialize the anticheat system when a character is selected
RegisterNetEvent("vorp:SelectedCharacter")
AddEventHandler("vorp:SelectedCharacter", function(charid)
    if Config.Idle.active then
        StartIdleMonitoring()
    end

    if Config.InputLimit.active then
        StartInputMonitoring()
    end
    
    -- Send initial resource list to server for verification
    if Config.ResourceProtection.active then
        Citizen.CreateThread(function()
            Wait(5000) -- Allow time for all resources to start
            local resources = {}
            for i = 0, GetNumResources() - 1 do
                table.insert(resources, GetResourceByFindIndex(i))
            end
            TriggerServerEvent("rmg:validateResources", resources)
        end)
    end
end) 