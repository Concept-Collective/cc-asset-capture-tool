RegisterNetEvent('asset-capture-cl')
AddEventHandler('asset-capture-cl', function(list, config)
    -- SETUP CAM 
    local cam = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", config.campos.x, config.campos.y, config.campos.z, 0, 0, 0, 0, false, 2)
    SetCamFov(cam, 40.0)
    PointCamAtCoord(cam, config.carpos.x, config.carpos.y, config.carpos.z+1)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 5000, true, true)
    Citizen.Wait(500)
    print('cam setup done\n--------')

    for vehicle in EnumerateVehicles() do
        if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then
            SetVehicleHasBeenOwnedByPlayer(vehicle, false)
            SetEntityAsMissionEntity(vehicle, false, false)
            DeleteVehicle(vehicle)
            if (DoesEntityExist(vehicle)) then
                DeleteVehicle(vehicle)
            end
        end
    end

    --Weather
    SetOverrideWeather(config.weather)
    -- Clock
    NetworkOverrideClockTime(config.time,0,0)
    PauseClock(true)
    Citizen.Wait(1000)
    for k,v in pairs(list) do
        if v.cam then
            SetCamFov(cam, v.cam.fov)
            print('FOV')
        end
        -- Load Vehicle
        local vehiclehash = GetHashKey(k)
        RequestModel(vehiclehash)

        local waiting = 0
        while not HasModelLoaded(vehiclehash) do
            waiting = waiting + 100
            Citizen.Wait(100)
            if waiting > 5000 then
                print("Could not load the vehicle model in time")
                break
            end
        end
        CreateVehicle(vehiclehash, config.carpos.x, config.carpos.y, config.carpos.z, config.carpos.h, true, true)
        print(k..' loaded')

        -- Take Screenshot
        print('waiting for screenshot')
        local sstime = 0
        TriggerServerEvent('takess', k)
        while sstime <= config.screenshotTime do
            HideHudAndRadarThisFrame()
            Citizen.Wait(1)
            sstime = sstime+1
        end
        print('took screenshot of '..k)

        SetCamFov(cam, 40.0)

        -- Delete vehicle
        for vehicle in EnumerateVehicles() do
            if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then
                SetVehicleHasBeenOwnedByPlayer(vehicle, false)
                SetEntityAsMissionEntity(vehicle, false, false)
                DeleteVehicle(vehicle)
                if (DoesEntityExist(vehicle)) then
                    DeleteVehicle(vehicle)
                end
            end
        end
        print('Deleted '..k..'\n--------')
    end
    -- Cams del
    SetCamActive(cam, false)
    RenderScriptCams(false, false, 5000, true, true)
    DestroyAllCams(true)
    print('Removed cams')

    PauseClock(false)
end)