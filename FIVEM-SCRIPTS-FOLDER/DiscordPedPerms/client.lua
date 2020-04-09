-----------------------
--- DiscordPedPerms ---
-----------------------
restrictedPeds = {
{}, -- Trusted Civ (1)
{}, -- Donator (2)
{
"mickeymouse",
"deadpool",
"kermit",
"blackpanther",
"ig_bankman",
}, -- Personal (3)
{"csb_mweather",}, -- Staff (4)
{"staff_rank_tmod_565",}, -- T-Mod (5)
{"staff_rank_mod_434",}, -- Mod (6)
{"staff_rank_admin_101",}, -- Admin (7)
{"management_434",}, -- Management (8)
{"staff_rank_owner_875",}, -- Owner (9)
}
allowedPed = "xxxtentacion"
alreadyRan = false
isAllowed = {}
RegisterNetEvent('DiscordPedPerms:CheckPerms:Return')
AddEventHandler('DiscordPedPerms:CheckPerms:Return', function(hasPerms)
	isAllowed = hasPerms
end)
function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
		local ped = GetPlayerPed(-1)
		local modelhashed = GetHashKey(allowedPed)
    
        -- Request the model, and wait further triggering untill fully loaded.
	    RequestModel(modelhashed)
	    while not HasModelLoaded(modelhashed) do 
	    	RequestModel(modelhashed)
	    	Citizen.Wait(0)
	    end
		if not alreadyRan then
			TriggerServerEvent('DiscordPedPerms:CheckPerms')
			alreadyRan = true
		end
		for i = 1, #restrictedPeds do
			for j = 1, #restrictedPeds[i] do
				if IsPedModel(ped, GetHashKey(tostring(restrictedPeds[i][j]))) then
					-- They can't use that ped
					if not has_value(isAllowed, i) then
						SetPlayerModel(PlayerId(), modelhashed)
						SetModelAsNoLongerNeeded(modelHashed)
						DisplayNotification('~r~RESTRICTED PED')
					end
				end
			end
		--[[
			if IsPedModel(ped, GetHashKey(restrictedPeds[i])) then
				-- They can't use that ped
				SetPlayerModel(PlayerId(), modelhashed)
				SetModelAsNoLongerNeeded(modelHashed)
				DisplayNotification('~r~RESTRICTED PED')
			end
			--]]--
		end
	end
end)

function DisplayNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end