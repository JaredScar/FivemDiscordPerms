------------------------
--- BadgerDiscordAPI ---
------------------------

triggeredAlready = false;
Citizen.CreateThread(function()
	-- This is the thread for sending resource name 
	Citizen.Wait( 0 )
	local rname = GetCurrentResourceName();
	SendNUIMessage({
		resourcename = rname;
	});
end)
showPanel = false;
RegisterNetEvent('BadgerDiscordAPI:PassToken')
AddEventHandler('BadgerDiscordAPI:PassToken', function(token)
	-- Give token 
	SendNUIMessage({
		token = token;
	});
end)
RegisterNetEvent('BadgerDiscordAPI:TogglePanel')
AddEventHandler('BadgerDiscordAPI:TogglePanel', function()
	-- TogglePanel event 
	showPanel = not showPanel;
	SetNuiFocus(showPanel, showPanel);
	SendNUIMessage({
		panelShown = showPanel;
	});
end)
RegisterNetEvent('BadgerDiscordAPI:SetPanel')
AddEventHandler('BadgerDiscordAPI:SetPanel', function(val)
	showPanel = val;
	SetNuiFocus(val, val);
	SendNUIMessage({
		panelShown = val;
	});
end)
Citizen.CreateThread(function()
	while true do 
		Wait(0);
		if showPanel then 
			DisableAllControlActions(0);
		end
	end
end)
AddEventHandler('playerSpawned', function() 
	if not triggeredAlready then 
		TriggerServerEvent('BadgerDiscordAPI:Register')
		triggeredAlready = true;
	end
end)