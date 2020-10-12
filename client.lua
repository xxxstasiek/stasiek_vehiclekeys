ESX = nil
DecorRegister("owner", 0)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
    ESX.Streaming.RequestStreamedTextureDict('CHAR_MP_STRIPCLUB_PR')

    ESX.PlayAnim = function(dict, anim, speed, time, flag)
        ESX.Streaming.RequestAnimDict(dict, function()
            TaskPlayAnim(PlayerPedId(), dict, anim, speed, speed, time, flag, 1, false, false, false)
        end)
    end
end)

CreateThread(function()
    while true do
        Wait(1300)
        if IsPedTryingToEnterALockedVehicle(PlayerPedId()) then
            vehicle = GetVehiclePedIsTryingToEnter(PlayerPedId())
            SetVehicleAlarmTimeLeft(vehicle, 1000 * 60 * 5)
            if DecorExistOn(vehicle, "owner") then
                ClearPedTasks(PlayerPedId())
            end
        end
    end
end)

RegisterCommand(Config.commands.keys.command, function()
    vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    
    if vehicle == 0 then
        vehicle = ESX.Game.GetVehicleInDirection()
    end

    if vehicle == 0 then
        ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.no_vehicle, '', 'CHAR_MP_STRIPCLUB_PR', 4, true, true)
        return
    end

    owner = DecorGetInt(vehicle, "owner")
    if owner ~= GetPlayerServerId(PlayerId()) then
        ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.no_keys, '', 'CHAR_MP_STRIPCLUB_PR', 4, true, true)
        return
    end

    ESX.PlayAnim("anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, -1, 48)

    locktime = 1
    
    if GetVehicleDoorLockStatus(vehicle) > 1 then
        SetVehicleDoorsLocked(vehicle, 1)
        PlayVehicleDoorOpenSound(vehicle, 0)
        SetVehicleAlarmTimeLeft(vehicle, 0)
        locktime = 2
        if Config.use_interact_sound then
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'unlock', 0.2)
        end
        ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.vehicle_unlocked, '', 'CHAR_MP_STRIPCLUB_PR', 4, true, true)
    else
        SetVehicleDoorsLocked(vehicle, 4)
        PlayVehicleDoorCloseSound(vehicle, 0)
        if Config.use_interact_sound then
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'lock', 0.2)
        end
        ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.vehicle_locked, '', 'CHAR_MP_STRIPCLUB_PR', 4, true, true)
    end
    
    for i = 1, locktime do
        StartVehicleHorn(vehicle, 100, "HELDDOWN", false)
        SetVehicleLights(vehicle, 2)
        Wait(500)
        SetVehicleLights(vehicle, 1)
    end
end, false)

RegisterCommand(Config.commands.givekeys.command, function(source, args, rawcommand)
    if args[1] == nil then
        ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.error, Config.notify.argument_1, 'CHAR_MP_STRIPCLUB_PR', 4, true, true)
        return
    end

    vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    if vehicle == 0 then
        ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.no_vehicle, Config.notify.enter_vehicle, 'CHAR_MP_STRIPCLUB_PR', 4, true, true)
        return
    end

    owner = DecorGetInt(vehicle, "owner")
    if owner ~= GetPlayerServerId(PlayerId()) then
        ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.no_keys, Config.notify.this_vehicle_is_not_your, 'CHAR_MP_STRIPCLUB_PR', 4, true, true)
        return
    end

    DecorSetInt(vehicle, "owner", tonumber(args[1]))
    ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.success, Config.notify.keys_gived_to .. args[1], 'CHAR_MP_STRIPCLUB_PR', 4, true, true)
end, false)

RegisterKeyMapping(Config.commands.keys.command, Config.notify.lock_unlock, 'keyboard', Config.commands.keys.input)