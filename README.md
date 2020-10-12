# stasiek_vehiclekeys
 A new better vehicle key locksystem based on decors

- server-sync
- best optymalization
- no database interference
- only client-side script

# requirements
- es_extended

Add this line to es_extended/client/functions.lua#ESX.Game.SpawnVehicle
```
DecorSetInt(vehicle, "owner", GetPlayerServerId(PlayerId()))
```

# esx error?
Try adding below code into es_extended/client/functions.lua

```
ESX.PlayAnim = function(dict, anim, speed, time, flag)
    ESX.Streaming.RequestAnimDict(dict, function()
        TaskPlayAnim(PlayerPedId(), dict, anim, speed, speed, time, flag, 1, false, false, false)
    end)
end
```