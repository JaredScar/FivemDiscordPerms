------------------------------------------------
--- Discord Vehicle Whitelist, Made by FAXES ---
------------------------------------------------

--- Config ---

--[[
	REPLACE THE '1's WITH YOUR DISCORD ROLES' IDs
]]
-- THESE NEED TO BE THE RESPECTIVE ROLE IDs OF YOUR DISCORD ROLES:
roleList = {
1, -- Civ
577968852852539392, -- Trusted Civ
581159405022609409, -- FAA Heli
581159505325457418, -- FAA Comm
577662071865344040, -- Donator Vehicles
506211283771719690, -- Player
506213297389830162, -- Staff
597419626183524353, -- Personal [Shared]
577662226182176776, -- Personal
506212543749029900, -- Admin
506212786481922058, -- Owner
633732085722513417, -- Donor Vehs 2
585590676188561408, -- Nitro Boosters
600800070618841098, -- Elite Supporters
}


--- Code ---

RegisterServerEvent("FaxDisVeh:CheckPermission")
AddEventHandler("FaxDisVeh:CheckPermission", function(_source)
    local src = source
	local allowedVehicles = {}
    local discordID = exports.BadgerDiscordAPI:GetDiscordIdentifier(src);
    identifierDiscord = discordID;
	-- TriggerClientEvent("FaxDisVeh:CheckPermission:Return", src, true, false)
    if identifierDiscord then
		local roles = exports.discord_perms:GetRoles(src, identifierDiscord)
		if not (roles == false) then
			for i = 1, #roles do
				for j = 1, #roleList do
					--print("roles[i] " .. tostring(roles[i]) .. " equal to roleList[j] " .. tostring(roleList[j]) .. " ? ")
					if tonumber(roles[i]) == tonumber(roleList[j]) then
						-- Return the index back to the Client script
						table.insert(allowedVehicles, j)
					end
				end
			end
		else
			print(GetPlayerName(src) .. " did not receive permissions because roles == false")
		end
    elseif identifierDiscord == nil then
		print("identifierDiscord == nil")
    end
	-- Trigger client event
	TriggerClientEvent("FaxDisVeh:CheckPermission:Return", src, allowedVehicles, true)
end)