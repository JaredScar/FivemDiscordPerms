-------------------------
--- BadgerTrustSystem ---
-------------------------
allowedPed = 'a_m_y_skater_01'
Citizen.CreateThread(function()
	while true do 
		Wait(1000);
	    local currentModel = GetEntityModel(PlayerPedId())
	    TriggerServerEvent('BadgerTrustSystem:Server:HasAccess', currentModel, false);
	end
end)
Citizen.CreateThread(function()
	while true do 
		Wait(1000);
		local ped = GetPlayerPed(-1)
	    local inVeh = IsPedInAnyVehicle(ped, false)
	    local veh = GetVehiclePedIsUsing(ped)
	    local driver = GetPedInVehicleSeat(veh, -1)
	    local spawncode = GetEntityModel(veh)
	    if (inVeh) and (driver == ped) then
	    	TriggerServerEvent('BadgerTrustSystem:Server:HasAccess', spawncode, true);
	    end
	end
end)
triggeredAlready = false;
AddEventHandler('playerSpawned', function() 
	if not triggeredAlready then 
		TriggerServerEvent('BadgerTrustSystem:Server:Register')
		triggeredAlready = true;
	end
end)
RegisterNetEvent('BadgerTrustSystem:Client:VehicleAccessReturn')
AddEventHandler('BadgerTrustSystem:Client:VehicleAccessReturn', function(hasAccess)
	local inVeh = IsPedInAnyVehicle(ped, false)
    local veh = GetVehiclePedIsUsing(ped)
    local driver = GetPedInVehicleSeat(veh, -1)
    local ped = GetPlayerPed(-1)
    if not hasAccess then 
    	DeleteEntity(veh)
        ClearPedTasksImmediately(ped)
    end
end)

RegisterNetEvent('BadgerTrustSystem:Client:PedAccessReturn')
AddEventHandler('BadgerTrustSystem:Client:PedAccessReturn', function(hasAccess)
	local ped = GetPlayerPed(-1)
	local hashAllowedSkin = GetHashKey(allowedPed)
	RequestModel(hashAllowedSkin)
    while not HasModelLoaded(hashAllowedSkin) do 
        RequestModel(hashAllowedSkin)
        Citizen.Wait(0)
    end
    if not hasAccess then 
    	SetPlayerModel(PlayerId(), hashAllowedSkin)
        SetModelAsNoLongerNeeded(hashAllowedSkin)
    end
end)