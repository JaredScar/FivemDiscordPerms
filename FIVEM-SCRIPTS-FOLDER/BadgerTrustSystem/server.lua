-------------------------
--- BadgerTrustSystem ---
-------------------------

--- CONFIG ---
serverKey = 'XFFS56da';
prefix = '^9[^6BadgerTrustSystem^9] ^r';

--- CODE ---
function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

sitePath = 'https://badger.store/bts';

function GetUserID(src)
  -- Gets the user's ID 
  local discordID = exports.BadgerDiscordAPI:GetDiscordIdentifier(src);
  local data = 'discord=' .. discordID .. '&serverKey=' .. serverKey;
  local dataa = nil;
  PerformHttpRequest(sitePath .. '/HTTP/get_user.php', function(errorCode, resultData, resultHeaders)
    dataa = {data=resultData, code=errorCode, headers=resultHeaders};
  end, 'POST', data, {["Content-Type"] = 'application/x-www-form-urlencoded'})
  
  while dataa == nil do
      Citizen.Wait(0)
  end
  print("[BadgerTrustSystem Debug] GetUserID(src) returns: " .. dataa.data) -- DEBUG // GET RID OF
  return dataa.data;
end

local TrustedVehicles = {}
local OwnedVehicles = {}
local TrustedPeds = {}
local OwnedPeds = {}
local ExistingVehicles = {}
local ExistingPeds = {}
function GetTrustedVehicles(userID)
  local dataa = nil;
  local data = 'UID=' .. userID .. '&serverKey=' .. serverKey;
  PerformHttpRequest(sitePath .. '/HTTP/get_vehicle_data.php', function(errorCode, resultData, resultHeaders)
    dataa = {data=resultData, code=errorCode, headers=resultHeaders};
  end, 'POST', data, {["Content-Type"] = 'application/x-www-form-urlencoded'})

  while dataa == nil do
      Citizen.Wait(0)
  end
  print("[BadgerTrustSystem Debug] GetTrustedVehicles(userID) returns: " .. dataa.data) -- DEBUG // GET RID OF
  if dataa.data ~= nil then 
    return json.decode(dataa.data)['Trusted'];
  else 
    return nil;
  end
end
function GetOwnedVehicles(userID)
  local dataa = nil;
  local data = 'UID=' .. userID .. '&serverKey=' .. serverKey;
  PerformHttpRequest(sitePath .. '/HTTP/get_vehicle_data.php', function(errorCode, resultData, resultHeaders)
    dataa = {data=resultData, code=errorCode, headers=resultHeaders};
  end, 'POST', data, {["Content-Type"] = 'application/x-www-form-urlencoded'})

  while dataa == nil do
      Citizen.Wait(0)
  end
  print("[BadgerTrustSystem Debug] GetOwnedVehicles(userID) returns: " .. dataa.data) -- DEBUG // GET RID OF
  if dataa.data ~= nil then 
    return json.decode(dataa.data)['Owned'];
  else 
    return nil;
  end
end
function GetTrustedPeds(userID)
  local dataa = nil;
  local data = 'UID=' .. userID .. '&serverKey=' .. serverKey;
  PerformHttpRequest(sitePath .. '/HTTP/get_ped_data.php', function(errorCode, resultData, resultHeaders)
    dataa = {data=resultData, code=errorCode, headers=resultHeaders};
  end, 'POST', data, {["Content-Type"] = 'application/x-www-form-urlencoded'})

  while dataa == nil do
      Citizen.Wait(0)
  end
  print("[BadgerTrustSystem Debug] GetTrustedPeds(userID) returns: " .. dataa.data) -- DEBUG // GET RID OF
  if dataa.data ~= nil then 
    return json.decode(dataa.data)['Trusted'];
  else 
    return nil;
  end
end
function GetOwnedPeds(userID)
  local dataa = nil;
  local data = 'UID=' .. userID .. '&serverKey=' .. serverKey;
  PerformHttpRequest(sitePath .. '/HTTP/get_ped_data.php', function(errorCode, resultData, resultHeaders)
    dataa = {data=resultData, code=errorCode, headers=resultHeaders};
  end, 'POST', data, {["Content-Type"] = 'application/x-www-form-urlencoded'})

  while dataa == nil do
      Citizen.Wait(0)
  end
  if dataa.data ~= nil then 
    print("[BadgerTrustSystem Debug] GetOwnedPeds(userID) returns: " .. dataa.data) -- DEBUG // GET RID OF
    return json.decode(dataa.data)['Owned'];
  else 
    return nil;
  end
end

function GetAllPeds()
  local data = nil;
  local encoded = 'serverKey=' .. serverKey .. '&isVehicle=' .. tostring(0);
  PerformHttpRequest(sitePath .. '/HTTP/get_existing.php', function(errorCode, resultData, resultHeaders)
    data = {data=resultData, code=errorCode, headers=resultHeaders};
  end, 'POST', encoded, {["Content-Type"] = 'application/x-www-form-urlencoded'}) 
  while data == nil do 
    Citizen.Wait(0);
  end
  if data.data ~= nil then 
    return json.decode(data.data);
  else 
    return nil;
  end
end
function GetAllVehs()
  local data = nil;
  local encoded = 'serverKey=' .. serverKey .. '&isVehicle=' .. tostring(1);
  PerformHttpRequest(sitePath .. '/HTTP/get_existing.php', function(errorCode, resultData, resultHeaders)
    data = {data=resultData, code=errorCode, headers=resultHeaders};
  end, 'POST', encoded, {["Content-Type"] = 'application/x-www-form-urlencoded'}) 
  while data == nil do 
    Citizen.Wait(0);
  end
  if data.data ~= nil then 
    return json.decode(data.data);
  else 
    return nil;
  end
end
-- ExistingVehicles, ExistingPeds every 5 minutes 
Citizen.CreateThread(function()
  while true do 
    -- Set up ExistingPeds and ExisitingVehicles list using above functions 
    update();
    Citizen.Wait((1000 * 60 * 2));
  end
end)
function update()
  ExistingVehicles = GetAllVehs();
  ExistingPeds = GetAllPeds();
end

function PostTrusted(src, trustedSrc, spawncode, isVehicle)
  local dataa = nil;
  local userID = GetUserID(src);
  local trustedID = GetUserID(trustedSrc);
  local data = 'userData=' .. trustedID .. '&serverKey=' .. serverKey .. '&spawncode=' .. spawncode .. '&isVehicle=' .. tostring(isVehicle)
  .. '&isTrustData=' .. tostring(true);
  PerformHttpRequest(sitePath .. '/HTTP/post_data.php', function(errorCode, resultData, resultHeaders)
    dataa = {data=resultData, code=errorCode, headers=resultHeaders};
  end, 'POST', data, {["Content-Type"] = 'application/x-www-form-urlencoded'})

  print("[BadgerTrustSystem Debug] Post should of been made for PostTrusted()") -- DEBUG // GET RID OF
end 
function PostOwner(src, spawncode, isVehicle)
  local dataa = nil;
  local userID = GetUserID(src);
  local data = 'userData=' .. userID .. '&serverKey=' .. serverKey .. '&spawncode=' .. spawncode .. '&isVehicle=' .. tostring(isVehicle)
  .. '&isTrustData=' .. tostring(0);
  PerformHttpRequest(sitePath .. '/HTTP/post_data.php', function(errorCode, resultData, resultHeaders)
    dataa = {data=resultData, code=errorCode, headers=resultHeaders};
  end, 'POST', data, {["Content-Type"] = 'application/x-www-form-urlencoded'})

  print("[BadgerTrustSystem Debug] Post should of been made for PostOwner()") -- DEBUG // GET RID OF
end
function PostUser(src)
  local dataa = nil;
  local discordd = exports.BadgerDiscordAPI:GetDiscordIdentifier(src);
  local steamm = ExtractIdentifiers(src).steam;
  local name = GetPlayerName(src);
  local gameLicensee = ExtractIdentifiers(src).license;
  local serverKeyy = serverKey;
  local data = 'discord=' .. discordd .. '&' .. 'steam=' .. steamm .. '&' .. 'lastPlayerName=' .. name
  .. '&' .. 'gameLicense=' .. gameLicensee .. '&' .. 'serverKey=' .. serverKeyy;
  PerformHttpRequest(sitePath .. '/HTTP/post_user.php', function(errorCode, resultData, resultHeaders) end,
   'POST', data, {['Content-Type'] = 'application/x-www-form-urlencoded'})
end
function RemoveTrust(src, trustedSrc, spawncode, isVehicle)
  local discord = ExtractIdentifiers(trustedSrc);
  local userID = GetUserID(trustedSrc);
  local encode = 'serverKey=' .. serverKey .. '&spawncode=' .. spawncode .. '&isVehicle=' .. tostring(isVehicle)
  .. '&isTrustData=' .. tostring(1) .. '&UID=' .. userID;
  PerformHttpRequest(sitePath .. '/HTTP/delete_data.php', function(errorCode, resultData, resultHeaders) 
  end, 'POST', encode, {['Content-Type'] = 'application/x-www-form-urlencoded'});
end
function ClearObjectt(spawncode, isVehicle)
  local encode = 'serverKey=' .. serverKey .. '&spawncode=' .. spawncode .. '&isVehicle=' .. tostring(isVehicle)
  .. '&isTrustData=' .. tostring(0) .. '&UID=' .. tostring(0);
  PerformHttpRequest(sitePath .. '/HTTP/delete_data.php', function(errorCode, resultData, resultHeaders) 
  end, 'POST', encode, {['Content-Type'] = 'application/x-www-form-urlencoded'});
end

-- START COMMANDS --
RegisterCommand('trustPed', function(source, args, rawCommand)
  -- /trustPed <id> <spawncode>
  local src = source;
  if #args < 2 then 
    TriggerClientEvent('chatMessage', src, prefix .. '^1Invalid usage. Proper usage: /trustPed <id> <spawncode>');
    return;
  end
  local id = args[1];
  if GetPlayerName(args[1]) == nil then 
    TriggerClientEvent('chatMessage', src, prefix .. '^1Error: A player with that ID is not online...');
    return;
  end
  id = tonumber(args[1])
  local spawncode = args[2];
  local ownedPeds = OwnedPeds[src];
  local ownsPed = false;
  for i = 1, #ownedPeds do 
    if ownedPeds[i] == spawncode then 
      ownsPed = true;
    end
  end
  local discord = exports.BadgerDiscordAPI:GetDiscordIdentifier(src);
  if ownsPed then 
    if (id == src) then 
      TriggerClientEvent('chatMessage', src, prefix .. '^1Error: You already own this ped...');
      return;
    end
    -- They own it, give trust perms
    local trusted = TrustedPeds[id];
    local alreadyTrusted = false;
    for i = 1, #trusted do 
      if trusted[i] == spawncode then 
        alreadyTrusted = true;
      end
    end
    if not alreadyTrusted then 
      if discord ~= nil and discord ~= "" then 
        PostTrusted(src, id, spawncode, 0)
      else 
        TriggerClientEvent('chatMessage', id, prefix ..'^1Your discord is not connected, so this trust is only for until a server restart or you get untrusted.')
      end
      table.insert(TrustedPeds[id], spawncode);
      TriggerClientEvent('chatMessage', id, prefix .. '^5You have been entrusted to utilize the personal ped ^6' .. spawncode 
       .. ' ^5by ^6' .. GetPlayerName(src))
      TriggerClientEvent('chatMessage', src, prefix.. '^5You have entrusted ^6' .. GetPlayerName(id) .. ' ^5to use your personal ped ^6' .. spawncode)
    else 
      -- They already trusted this person 
      TriggerClientEvent('chatMessage', src, prefix .. '^1You have already entrusted this person to this vehicle...');
    end
  else 
    -- They do not own it 
      TriggerClientEvent('chatMessage', src, prefix .. '^1Error: You do not own this personal ped...');
  end
end)
RegisterCommand('trustVeh', function(source, args, rawCommand)
  -- /trustVeh <id> <spawncode>
  local src = source;
  if #args < 2 then 
    TriggerClientEvent('chatMessage', src, prefix .. '^1Invalid usage. Proper usage: /trustVeh <id> <spawncode>');
    return;
  end
  local id = tonumber(args[1]);
  if GetPlayerName(args[1]) == nil then 
    TriggerClientEvent('chatMessage', src, prefix .. '^1Error: A player with that ID is not online...');
    return;
  end
  id = tonumber(args[1]);
  local spawncode = args[2];
  local ownedVehs = OwnedVehicles[src];
  local ownsVeh = false;
  for i = 1, #ownedVehs do 
    if ownedVehs[i] == spawncode then 
      ownsVeh = true;
    end
  end
  local discord = exports.BadgerDiscordAPI:GetDiscordIdentifier(src);
  if ownsVeh then 
    -- They own it, give trust perms
    if (id == src) then 
      TriggerClientEvent('chatMessage', src, prefix .. '^1Error: You already own this vehicle...');
      return;
    end
    -- They own it, give trust perms
    local trusted = TrustedVehicles[id];
    local alreadyTrusted = false;
    for i = 1, #trusted do 
      if trusted[i] == spawncode then 
        alreadyTrusted = true;
      end
    end
    if not alreadyTrusted then
      if discord ~= nil and discord ~= "" then 
        PostTrusted(src, id, spawncode, 1)
      else 
        TriggerClientEvent('chatMessage', id, prefix ..'^1Your discord is not connected, so this trust is only for until a server restart or you get untrusted.')
      end
      table.insert(TrustedVehicles[id], spawncode);
      TriggerClientEvent('chatMessage', id, prefix .. '^5You have been entrusted to utilize the personal vehicle ^6' .. spawncode 
       .. ' ^5by ^6' .. GetPlayerName(src))
      TriggerClientEvent('chatMessage', src, prefix .. '^5You have entrusted ^6' .. GetPlayerName(id) .. ' ^5to use your personal vehicle ^6' .. spawncode)
    else 
      -- Already trusted this person 
      TriggerClientEvent('chatMessage', src, prefix .. '^1You have already entrusted this person to this vehicle...');
    end
  else 
    -- They do not own it 
      TriggerClientEvent('chatMessage', src, prefix .. '^1Error: You do not own this personal vehicle...');
  end
end)
RegisterCommand('untrustPed', function(source, args, rawCommand)
  -- /untrustPed <id> <spawncode>
  local src = source;
  if #args < 2 then 
    TriggerClientEvent('chatMessage', src, prefix .. '^1Invalid usage. Proper usage: /untrustPed <id> <spawncode>');
    return;
  end
  local id = args[1]; 
  if GetPlayerName(args[1]) == nil then 
    TriggerClientEvent('chatMessage', src, prefix .. '^1Error: A player with that ID is not online...');
    return;
  end
  id = tonumber(args[1]);
  local spawncode = args[2];
  local ownedPeds = OwnedPeds[src];
  local ownsPed = false;
  for i = 1, #ownedPeds do 
    if ownedPeds[i] == spawncode then 
      ownsPed = true;
    end
  end
  local discord = exports.BadgerDiscordAPI:GetDiscordIdentifier(src);
  if ownsPed then 
    -- They do own the ped
    local trusted = TrustedPeds[id];
    local isTrusted = false;
    for i = 1, #trusted do 
      if trusted[i] == spawncode then
        isTrusted = true;
      end
    end 
    if isTrusted then 
      if discord ~= nil and discord ~= "" then 
        RemoveTrust(src, id, spawncode, 0);
      end 
      for i = 1, #TrustedPeds[id] do 
        if TrustedPeds[id][i] ~= spawncode then 
          table.insert(remadeList, TrustedPeds[id][i]);
        end
      end
      TrustedPeds[id] = remadeList;
      TriggerClientEvent('chatMessage', id, '^5Your trust to utilize the personal ped ^6' .. spawncode 
         .. ' ^5has been revoked by ^6' .. GetPlayerName(src))
      TriggerClientEvent('chatMessage', src, '^5You have revoked trust of ^6' .. GetPlayerName(id) .. ' ^5to use your personal ped ^6' .. spawncode)
  else 
    -- Was never trusted anyhow
    TriggerClientEvent('chatMessage', src, prefix .. '^1This person is not trusted to this personal ped...');
  end
  else 
    -- You don't own this ped 
    TriggerClientEvent('chatMessage', src, prefix .. '^1Error: You do not own this personal ped...');
  end
end)
RegisterCommand('untrustVeh', function(source, args, rawCommand)
  -- /untrustVeh <id> <spawncode>
  local src = source;
  if #args < 2 then 
    TriggerClientEvent('chatMessage', src, prefix .. '^1Invalid usage. Proper usage: /untrustVeh <id> <spawncode>');
    return;
  end
  local id = args[1]; 
  if GetPlayerName(args[1]) == nil then 
    TriggerClientEvent('chatMessage', src, prefix .. '^1Error: A player with that ID is not online...');
    return;
  end
  id = tonumber(args[1]);
  local ownedVehs = OwnedVehicles[src];
  local ownsVeh = false;
  local spawncode = args[2];
  for i = 1, #ownedVehs do 
    if ownedVehs[i] == spawncode then 
      ownsVeh = true;
    end
  end
  local discord = exports.BadgerDiscordAPI:GetDiscordIdentifier(src);
  if ownsVeh then 
    -- They do own the ped
    local trusted = TrustedVehicles[id];
    local isTrusted = false;
    for i = 1, #trusted do 
      if trusted[i] == spawncode then
        isTrusted = true;
      end
    end 
    if isTrusted then 
      if discord ~= nil and discord ~= "" then 
        RemoveTrust(src, id, spawncode, 1);
      end 
      local remadeList = {}
      for i = 1, #TrustedVehicles[id] do 
        if TrustedVehicles[id][i] ~= spawncode then 
          table.insert(remadeList, TrustedVehicles[id][i]);
        end
      end
      TrustedVehicles[id] = remadeList;
      TriggerClientEvent('chatMessage', id, '^5Your trust to utilize the personal vehicle ^6' .. spawncode 
         .. ' ^5has been revoked by ^6' .. GetPlayerName(src))
      TriggerClientEvent('chatMessage', src, '^5You have revoked trust of ^6' .. GetPlayerName(id) .. ' ^5to use your personal vehicle ^6' .. spawncode)
    else 
      -- Was never trusted anyhow
      TriggerClientEvent('chatMessage', src, prefix .. '^1This person is not trusted to this personal vehicle...');
    end
  else 
    -- You don't own this ped 
    TriggerClientEvent('chatMessage', src, prefix .. '^1Error: You do not own this personal vehicle...');
  end
end)
RegisterCommand('setVehOwner', function(source, args, rawCommand)
  -- /setVehOwner <id> <spawncode>
  local src = source;
  if IsPlayerAceAllowed(src, 'BadgerTrustSystem.SetOwnerships') then
    if #args < 2 then 
      TriggerClientEvent('chatMessage', src, prefix .. '^1Invalid usage. Proper usage: /setVehOwner <id> <spawncode>');
      return;
    end
    local id = args[1]; 
    if GetPlayerName(args[1]) == nil then 
      TriggerClientEvent('chatMessage', src, prefix .. '^1Error: A player with that ID is not online...');
      return;
    end
    id = tonumber(args[1]);
    local spawncode = args[2];
    local allVehs = GetAllVehs();
    local existsAlready = false;
    for i = 1, #allVehs do 
      local code = allVehs[i];
      if code == spawncode then 
        existsAlready = true;
      end
    end 
    local discord = exports.BadgerDiscordAPI:GetDiscordIdentifier(src);
    if not existsAlready then 
      -- Does not exist already, set them owner 
      if discord ~= nil and discord ~= "" then 
        PostOwner(id, spawncode, 1)
      else 
        TriggerClientEvent('chatMessage', id, prefix ..'^1Your discord is not connected, so this ownership is only for until a server restart.')
      end
      table.insert(OwnedVehicles[id], spawncode);
      update();
      TriggerClientEvent('chatMessage', id, prefix .. '^5You have been set owner to vehicle ^6' .. spawncode 
      .. ' ^5by ^6' .. GetPlayerName(src));
     TriggerClientEvent('chatMessage', src, prefix .. '^5You have set ^6' .. GetPlayerName(id) .. ' ^5as owner of the personal vehicle ^6' .. spawncode);
    else 
      -- Exists already, can't do it
        TriggerClientEvent('chatMessage', src, prefix .. '^1Error: This vehicle is already owned by someone... Clear it first with /clearVeh <spawncode>')
    end
  end
end)
RegisterCommand('setPedOwner', function(source, args, rawCommand)
  -- /setPedOwner <id> <spawncode>
  local src = source;
  if IsPlayerAceAllowed(src, 'BadgerTrustSystem.SetOwnerships') then 
    if #args < 2 then 
      TriggerClientEvent('chatMessage', src, prefix .. '^1Invalid usage. Proper usage: /setPedOwner <id> <spawncode>');
      return;
    end
    local id = args[1];
    if GetPlayerName(args[1]) == nil then 
      TriggerClientEvent('chatMessage', src, prefix .. '^1Error: A player with that ID is not online...');
      return;
    end
    id = tonumber(args[1]);
    local spawncode = args[2];
    local allPeds = GetAllPeds();
    local existsAlready = false;
    for i = 1, #allPeds do 
      local code = allPeds[i];
      if code == spawncode then 
        existsAlready = true;
      end
    end
    local discord = exports.BadgerDiscordAPI:GetDiscordIdentifier(src);
    if not existsAlready then 
      -- Does not exist already, set them owner 
      if discord ~= nil and discord ~= "" then 
        PostOwner(id, spawncode, 0)
      else 
        TriggerClientEvent('chatMessage', id, prefix ..'^1Your discord is not connected, so this ownership is only for until a server restart.')
      end
      table.insert(OwnedPeds[id], spawncode);
      update();
      TriggerClientEvent('chatMessage', id, prefix .. '^5You have been set owner to ped ^6' .. spawncode 
      .. ' ^5by ^6' .. GetPlayerName(src));
     TriggerClientEvent('chatMessage', src, prefix .. '^5You have set ^6' .. GetPlayerName(id) .. ' ^5as owner of the personal ped ^6' .. spawncode);
    else 
      -- Exists already, can't do it
        TriggerClientEvent('chatMessage', src, prefix .. '^1Error: This ped is already owned by someone... Clear it first with /clearPed <spawncode>')
    end
  end
end)
RegisterCommand('clearVeh', function(source, args, rawCommand)
  -- /clearVeh <spawncode>
  local src = source;
  if IsPlayerAceAllowed(src, 'BadgerTrustSystem.Clear') then
    if #args < 1 then 
      TriggerClientEvent('chatMessage', src, prefix .. '^1Invalid usage. Proper usage: /clearVeh <spawncode>');
      return;
    end
    local spawncode = args[1];
    local all = GetAllVehs();
    local existsAlready = false;
    for i = 1, #all do 
      local code = all[i];
      if code == spawncode then 
        existsAlready = true;
      end
    end
    if existsAlready then 
      -- Delete it 
      ClearObjectt(spawncode, 1);
      update();
      local players = GetPlayers();
      for i = 1, #players do 
        local id = players[i];
        TriggerEvent('BadgerTrustSystem:Server:RegisterID', id);
      end
      TriggerClientEvent('chatMessage', src, prefix .. '^5The personal vehicle has been cleared successfully...');
    else 
      -- Doesn't exist 
      TriggerClientEvent('chatMessage', src, prefix .. '^1Error: That is not a valid personal vehicle. Maybe you meant to /clearPed ?');
    end
  end
end)
RegisterCommand('clearPed', function(source, args, rawCommand)
  -- /clearPed <spawncode>
  local src = source;
  if IsPlayerAceAllowed(src, 'BadgerTrustSystem.Clear') then
    if #args < 1 then 
      TriggerClientEvent('chatMessage', src, prefix .. '^1Invalid usage. Proper usage: /clearPed <spawncode>');
      return;
    end
    local spawncode = args[1];
    local all = GetAllPeds();
    local existsAlready = false;
    for i = 1, #all do 
      local code = all[i];
      if code == spawncode then 
        existsAlready = true;
      end
    end
    if existsAlready then 
      -- Delete it 
      ClearObjectt(spawncode, 0);
      update();
      local players = GetPlayers();
      for i = 1, #players do 
        local id = players[i];
        TriggerEvent('BadgerTrustSystem:Server:RegisterID', id);
      end
      TriggerClientEvent('chatMessage', src, prefix .. '^5The personal ped has been cleared successfully...');
    else 
      -- Doesn't exist 
      TriggerClientEvent('chatMessage', src, prefix .. '^1Error: That is not a valid personal ped. Maybe you meant to /clearVeh ?');
    end
  end
end)
RegisterCommand('vehicles', function(source, args, rawCommand) 
  -- /vehicles 
  local src = source;
  local owned = OwnedVehicles[src];
  local trusted = TrustedVehicles[src];
  TriggerClientEvent('chatMessage', src, prefix .. '^5Owned Vehicles: ^0' .. table.concat(owned, ", "));
  TriggerClientEvent('chatMessage', src, prefix .. '^3Trusted Vehicles: ^0' .. table.concat(trusted, ", "));
end)
RegisterCommand('peds', function(source, args, rawCommand)
  -- /peds 
  local src = source;
  local owned = OwnedPeds[src];
  local trusted = TrustedPeds[src];
  TriggerClientEvent('chatMessage', src, prefix .. '^5Owned Peds: ^0' .. table.concat(owned, ", "));
  TriggerClientEvent('chatMessage', src, prefix .. '^3Trusted Peds: ^0' .. table.concat(trusted, ", "));
end)
-- END COMMANDS --
AddEventHandler('onResourceStart', function(resourceName) 
  if (GetCurrentResourceName() == resourceName) then 
    -- Loop through players 
    local players = GetPlayers();
    for i = 1, #players do 
      local id = players[i];
      TriggerEvent('BadgerTrustSystem:Server:RegisterID', id);
    end
  end
end)
RegisterNetEvent('BadgerTrustSystem:Server:RegisterID')
AddEventHandler('BadgerTrustSystem:Server:RegisterID', function(id)
  local src = tonumber(id);
  local discord = exports.BadgerDiscordAPI:GetDiscordIdentifier(src);
  if discord ~= nil and discord ~= "" then 
    PostUser(src);
    local uid = GetUserID(src);
    local trustedPeds = GetTrustedPeds(uid);
    local trustedVehs = GetTrustedVehicles(uid);
    local ownedPeds = GetOwnedPeds(uid);
    local ownedVehs = GetOwnedVehicles(uid);
    TrustedPeds[src] = ternary(type(trustedPeds) == 'table', trustedPeds, {});
    TrustedVehicles[src] = ternary(type(trustedVehs) == 'table', trustedVehs, {});
    OwnedPeds[src] = ternary(type(ownedPeds) == 'table', ownedPeds, {});
    OwnedVehicles[src] = ternary(type(ownedVehs) == 'table', ownedVehs, {});
    print("[BadgerTrustSystem Debug] BadgerTrustSystem:Server:RegisterID successfully ran...") -- DEBUG // GET RID OF
  else 
    print("[BadgerTrustSystem Debug] BadgerTrustSystem:Server:RegisterID did not run. They do not have a discord!...")
    TrustedPeds[src] = {};
    TrustedVehicles[src] = {};
    OwnedPeds[src] = {};
    OwnedVehicles[src] = {};
    TriggerClientEvent('chatMessage', src, prefix .. '^1You do not have a discord connected to your account. Therefore you '
      .. 'cannot take full advantage of BadgerTrustSystem perks.');
  end
end)
RegisterNetEvent('BadgerTrustSystem:Server:Register')
AddEventHandler('BadgerTrustSystem:Server:Register', function()
  local src = source;
  local discord = exports.BadgerDiscordAPI:GetDiscordIdentifier(src);
  if discord ~= nil and discord ~= "" then 
    PostUser(src);
    local uid = GetUserID(src);
    local trustedPeds = GetTrustedPeds(uid);
    local trustedVehs = GetTrustedVehicles(uid);
    local ownedPeds = GetOwnedPeds(uid);
    local ownedVehs = GetOwnedVehicles(uid);
    TrustedPeds[src] = ternary(type(trustedPeds) == 'table', trustedPeds, {});
    TrustedVehicles[src] = ternary(type(trustedVehs) == 'table', trustedVehs, {});
    OwnedPeds[src] = ternary(type(ownedPeds) == 'table', ownedPeds, {});
    OwnedVehicles[src] = ternary(type(ownedVehs) == 'table', ownedVehs, {});
    print("[BadgerTrustSystem Debug] BadgerTrustSystem:Server:RegisterID successfully ran...") -- DEBUG // GET RID OF
  else 
    print("[BadgerTrustSystem Debug] BadgerTrustSystem:Server:RegisterID did not run. They do not have a discord!...")
    TrustedPeds[src] = {};
    TrustedVehicles[src] = {};
    OwnedPeds[src] = {};
    OwnedVehicles[src] = {};
    TriggerClientEvent('chatMessage', src, prefix .. '^1You do not have a discord connected to your account. Therefore you '
      .. 'cannot take full advantage of BadgerTrustSystem perks.');
  end
end)
function ternary ( cond , T , F )
    if cond then return T else return F end
end
AddEventHandler('playerDropped', function (reason) 
  -- Clear their lists 
  local src = source;
  TrustedPeds[src] = nil;
  TrustedVehicles[src] = nil;
  OwnedPeds[src] = nil;
  OwnedVehicles[src] = nil;
end)

RegisterNetEvent('BadgerTrustSystem:Server:HasAccess')
AddEventHandler('BadgerTrustSystem:Server:HasAccess', function(hashkey, isVehicle)
  -- Check if has access 
  local src = source;
  local hasAccess = false;
  local exists = false;
  if isVehicle then 
    -- Do vehicles 
    for i = 1, #ExistingVehicles do 
      if GetHashKey(ExistingVehicles[i]) == hashkey then 
        exists = true;
      end
    end
    if exists then 
      for i = 1, #TrustedVehicles[src] do 
        if GetHashKey(TrustedVehicles[src][i]) == hashkey then 
          hasAccess = true;
        end
      end
      for i = 1, #OwnedVehicles[src] do 
        if GetHashKey(OwnedVehicles[src][i]) == hashkey then 
          hasAccess = true; 
        end
      end
      if not hasAccess then 
        TriggerClientEvent('chatMessage', src, prefix .. '^1Invalid: You do not have access to this personal vehicle...')
      end
      TriggerClientEvent('BadgerTrustSystem:Client:VehicleAccessReturn', src, hasAccess)
    end
  else
    -- Not vehicle, do peds 
      for i = 1, #ExistingPeds do 
        if GetHashKey(ExistingPeds[i]) == hashkey then 
          exists = true;
        end
      end
    if exists then 
      for i = 1, #TrustedPeds[src] do 
        if GetHashKey(TrustedPeds[src][i]) == hashkey then 
          hasAccess = true;
        end
      end
      for i = 1, #OwnedPeds[src] do 
        if GetHashKey(OwnedPeds[src][i]) == hashkey then 
          hasAccess = true; 
        end
      end
      if not hasAccess then 
        TriggerClientEvent('chatMessage', src, prefix .. '^1Invalid: You do not have access to this personal ped...')
      end
      TriggerClientEvent('BadgerTrustSystem:Client:PedAccessReturn', src, hasAccess)
    end
  end
end)