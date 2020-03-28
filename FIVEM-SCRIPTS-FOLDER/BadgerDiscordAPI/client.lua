------------------------
--- BadgerDiscordAPI ---
------------------------

triggeredAlready = false;
AddEventHandler('playerSpawned', function() 
	if not triggeredAlready then 
		TriggerServerEvent('BadgerDiscordAPI:Register')
		triggeredAlready = true;
	end
end)