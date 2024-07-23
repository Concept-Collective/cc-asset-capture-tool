local config = json.decode(LoadResourceFile(GetCurrentResourceName(), "./config.json"))
local list = json.decode(LoadResourceFile(GetCurrentResourceName(), "./list.json"))

RegisterCommand('ccact', function(source, args, rawCommand)
    local v = string.sub(rawCommand, 7, -1)
    if v == 'setcampos' then
        local coords = GetEntityCoords(GetPlayerPed(source))
        local heading = GetEntityHeading(GetPlayerPed(source))
        config.campos.x = coords[1]
        config.campos.y = coords[2]
        config.campos.z = coords[3]
        config.campos.h =  heading
        SaveResourceFile(GetCurrentResourceName(), "./config.json", json.encode(config), -1)
        config = json.decode(LoadResourceFile(GetCurrentResourceName(), "./config.json"))
    elseif v == 'setvehpos' then
        local coords = GetEntityCoords(GetPlayerPed(source))
        local heading = GetEntityHeading(GetPlayerPed(source))
        config.carpos.x = coords[1]
        config.carpos.y = coords[2]
        config.carpos.z = coords[3]
        config.carpos.h =  heading
        SaveResourceFile(GetCurrentResourceName(), "./config.json", json.encode(config), -1)
        config = json.decode(LoadResourceFile(GetCurrentResourceName(), "./config.json"))
    elseif v == 'capture list' then
        TriggerClientEvent('asset-capture-cl', source, list, config)
    elseif string.sub(v, 0, 11) == 'capture veh' then
        local name = string.sub(v, 13, -1)
        local veh = {}
        veh[name] = {}
        TriggerClientEvent('asset-capture-cl', source, veh, config)
    else
        print('\"'..v..'\" is invalid')
    end
end, false)

RegisterServerEvent('takess')
AddEventHandler('takess', function (name)
    exports['screenshot-basic']:requestClientScreenshot(GetPlayers()[source], {
        encoding = config.encoding,
        fileName = '' .. GetResourcePath(GetCurrentResourceName()) .. '/output/'.. name .. '.' .. config.encoding .. '',
        quality = config.quality
    }, function(err, data)
        if err then
            print('err', err)
            print('data', data)
        end
    end)
end)