------------------------
--- BadgerDiscordAPI ---
------------------------
-- CONFIG --
port = 30120;
sitePath = 'https://badger.store/discordapi';
prefix = '^9[^6BadgerDiscordAPI^9] ^r'



-- CODE (DO NOT TOUCH) --
function ConnectDiscord(src) 
  local ids = ExtractIdentifiers(src);
  local steam = ids.steam;
  local gameLicense = ids.license;
  local name = GetPlayerName(src);
  local encoded = 'port=' .. tostring(port) .. '&steam=' .. steam .. '&gameLicense=' .. gameLicense .. '&lastPlayerName=' .. name;
  print(encoded);
  local data = nil;
  PerformHttpRequest(sitePath .. '/getAccessKey.php', function(errorCode, resultData, resultHeaders)
    data = {data=resultData, code=errorCode, headers=resultHeaders};
  end, 'POST', encoded, {["Content-Type"] = 'application/x-www-form-urlencoded'})
  while data == nil do 
    Wait(0);
  end
  print(data.data);
  if data.data ~= nil and data.data ~= '' then 
    local url = sitePath .. '?token=' .. tostring(data.data):gsub('"', '');
    TriggerClientEvent('chatMessage', src, prefix .. '^3Visit the following link within 5 minutes to verify your discord: ^5' .. url);
  else 
    -- SOMETHING WENT WRONG 
    TriggerClientEvent('chatMessage', src, prefix .. '^1Error: Something went wrong on our end... Please try again later!');
  end
end
function GetDiscordIdentifier(src)
  local ids = ExtractIdentifiers(src);
  local steam = ids.steam;
  local gameLicense = ids.license;
  local name = GetPlayerName(src);
  local encoded = 'port=' .. port .. '&steam=' .. steam .. '&gameLicense=' .. gameLicense .. '&lastPlayerName=' .. name;
  local data = nil;
  PerformHttpRequest(sitePath .. '/getDiscord.php', function(errorCode, resultData, resultHeaders)
    data = {data=resultData, code=errorCode, headers=resultHeaders};
  end, 'POST', encoded, {["Content-Type"] = 'application/x-www-form-urlencoded'})
  while data == nil do 
    Wait(0);
  end
  local discord = '';
  if data.data ~= nil then 
    print(data.data);
    discord = tostring(data.data);
    return discord;
  end
  return nil;
end

RegisterNetEvent('BadgerDiscordAPI:Register')
AddEventHandler('BadgerDiscordAPI:Register', function()
  local src = source;
  local discord = GetDiscordIdentifier(src);
  if #discord < 10 then 
    -- Not a valid discord 
    ConnectDiscord(src);
  end
end)

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