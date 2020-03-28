-----------------------------------
--- Discord ACE Perms by Badger ---
-----------------------------------

--- Code ---

roleList = {
{577968852852539392, "group.tc"}, --[[ Trusted-Civ --- 577968852852539392 ]] 
{581159762138497027, "group.faa"}, --[[ FAA --- 581159762138497027 ]]
{577661583497363456, "group.donator"}, --[[ Donator --- 577661583497363456 ]]
{600800070618841098, 'group.elite'}, -- Elite 
{577631197987995678, "group.trialModerator"}, --[[ T-Mod --- 577631197987995678 ]] 
{506211787214159872, "group.moderator"}, --[[ Moderator --- 506211787214159872 ]]
{506212543749029900, "group.admin"}, --[[ Admin --- 506212543749029900 ]]
{577966729981067305, "group.admin"}, --[[ Management --- 577966729981067305 ]]
{506212786481922058, "group.owner"}, --[[ Owner --- 506212786481922058]]
}
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end
function PlayerIdentifier(type, id)
    local identifiers = {}
    local numIdentifiers = GetNumPlayerIdentifiers(id)

    for a = 0, numIdentifiers do
        table.insert(identifiers, GetPlayerIdentifier(id, a))
    end

    for b = 1, #identifiers do
        if string.find(identifiers[b], type, 1) then
            return identifiers[b]
        end
    end
    return false
end
function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

hasPermsAlready = {}
discordDetector = {}

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
	deferrals.defer();
	local src = source; 
	local discordID = exports.BadgerDiscordAPI:GetDiscordIdentifier(src);
	if not has_value(hasPermsAlready, PlayerIdentifier('steam', src)) then
		local hex = string.sub(tostring(PlayerIdentifier("steam", src)), 7)
		permAdd = "add_principal identifier.steam:" .. hex .. " "
		local identifierDiscord = discordID;
		if identifierDiscord then
			if not has_value(hasPermsAlready, PlayerIdentifier('steam', src)) then
				local roleIDs = exports.discord_perms:GetRoles(src, identifierDiscord)
				if not (roleIDs == false) then
					for i = 1, #roleList do
						for j = 1, #roleIDs do
							if (tostring(roleList[i][1]) == tostring(roleIDs[j])) then
								print("[DiscordAcePerms] Added " .. GetPlayerName(src) .. " to role group " .. roleList[i][2] .. " with discordRole ID: " .. roleIDs[j])
								ExecuteCommand(permAdd .. roleList[i][2])
							end
						end
					end
					table.insert(hasPermsAlready, PlayerIdentifier('steam', src))
				else
					print("[DiscordAcePerms] " .. GetPlayerName(src) .. " has not gotten their permissions cause roleIDs == false")
				end
			end
		else 
			if not has_value(discordDetector, PlayerIdentifier('steam', src)) then 
				-- Kick with we couldn't find their discord, try to restart it whilst fivem is closed 
				deferrals.done('[DiscordAcePerms] Discord not found... Try restarting Discord application whilst Fivem is closed!')
				table.insert(discordDetector, PlayerIdentifier('steam', src));
				print('[DiscordAcePerms] Discord was not found for player ' .. GetPlayerName(src) .. "...")
			end
		end
	end
	deferrals.done();
end)

RegisterServerEvent("DiscordAcePerms:GivePerms")
AddEventHandler("DiscordAcePerms:GivePerms", function()
	local src = source
	if not has_value(hasPermsAlready, PlayerIdentifier('steam', src)) then
		local hex = string.sub(tostring(PlayerIdentifier("steam", src)), 7)
		permAdd = "add_principal identifier.steam:" .. hex .. " "
		for k, v in ipairs(GetPlayerIdentifiers(src)) do
				if string.sub(v, 1, string.len("discord:")) == "discord:" then
					identifierDiscord = v
				end
		end
		if identifierDiscord then
			if not has_value(hasPermsAlready, PlayerIdentifier('steam', src)) then
				local roleIDs = exports.discord_perms:GetRoles(src)
				if not (roleIDs == false) then
					for i = 1, #roleList do
						for j = 1, #roleIDs do
							if (tostring(roleList[i][1]) == tostring(roleIDs[j])) then
								print("[DiscordAcePerms] Added " .. GetPlayerName(src) .. " to role group " .. roleList[i][2] .. " with discordRole ID: " .. roleIDs[j])
								ExecuteCommand(permAdd .. roleList[i][2])
							end
						end
					end
					table.insert(hasPermsAlready, PlayerIdentifier('steam', src))
				else
					print("[DiscordAcePerms] " .. GetPlayerName(src) .. " has not gotten their permissions cause roleIDs == false")
				end
			end
		end
	end
end)
			