# stasiek_vehiclekeys
 A new better vehicle key locksystem based on decors

- server-sync
- best optymalization

# Requirements
`es_extended`

Add this line to es_extended/client/functions.lua#ESX.Game.SpawnVehicle
```
DecorSetInt(vehicle, "owner", GetPlayerServerId(PlayerId()))
```
