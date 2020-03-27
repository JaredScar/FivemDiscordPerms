<?php
require_once 'config.php';
session_start();
function getConnection() {
    global $host;
    global $username;
    global $password;
    global $port;
    global $database;
    $conn = new mysqli($host, $username, $password, $database, $port);
    return $conn;
}
function getConn() {
    return getConnection();
}
function sessionKey($key) {
    $_SESSION['key'] = $key;
}
function getKey() {
    return $_SESSION['key'];
}
function destroySession() {
    session_destroy();
}
function setupKey($key, $gameLicense, $steam, $lastPlayerName, $endMillis) {
    $sql = getConn()->prepare('INSERT INTO `AccessKeys` VALUES (0, ?, ?, ?, ?, ?, 0);');
    $sql->bind_param("ssssi", $key, $lastPlayerName, $steam, $gameLicense, $endMillis);
    if ($sql->execute()) { 
        return true;
    }
    return false;
}
function checkKey($key) {
    $currentTime = new DateTime();
    $endMillis = strtotime($currentTime->format('Y-m-d H:i:sP'));
    $sql = getConn()->prepare("SELECT `timeExpires`, `expired` FROM `AccessKeys` WHERE `key` = ?;");
    $sql->bind_param("s", $key);
    if ($sql->execute()) {
        // Check timeExpires and if is expired already
        $res = $sql->get_result();
        while ($row = $res->fetch_assoc()) {
            $expired = $row['expired'];
            $timeExpires = $row['timeExpires'];
            if ($expired === 1) {
                return false;
            }
            if ($timeExpires > $endMillis) {
                return false;
            }
        }
        return true;
    }
    return false;
}
function expireKey($key) {
    $sql = getConn()->prepare("DELETE FROM `AccessKeys` WHERE `key` = ?;");
    $sql->bind_param('s', $key);
    if($sql->execute()) {
        return true;
    }
    return false;
}
function uploadData($key, $discordCode) {
    global $clientID;
    global $clientSecret;
    global $redirect_URI;
    $data = [
        'client_id' => $clientID,
        'client_secret' => $clientSecret,
        'grant_type' => 'authorization_code',
        'code' => $discordCode,
        'redirect_uri' => $redirect_URI,
        'scope' => 'identify email guilds guilds.join'
    ];
    $options =  [
        'https' => [
            'header' => 'Content-Type: application/x-www-form-urlencoded',
            'method' => 'POST',
            'content' => http_build_query($data)
        ],
        'http' => [
            'header' => 'Content-Type: application/x-www-form-urlencoded',
            'method' => 'POST',
            'content' => http_build_query($data)
        ],
    ];
    $context = stream_context_create($options);
    $result = file_get_contents('https://discordapp.com/api/oauth2/token', false, $context);
    $jsonTokens = json_decode($result, true);
    $accessToken = $jsonTokens['access_token'];
    $refreshToken = $jsonTokens['refresh_token'];

    //var_dump($result);
    //var_dump('Access Token: ' . $accessToken);
    //var_dump('Refresh Token: ' . $refreshToken);

    $options['https']['header'] = 'Authorization: Bearer ' . $accessToken;
    $options['http']['header'] = 'Authorization: Bearer ' . $accessToken;
    $options['http']['content'] = null;
    $options['https']['content'] = null;
    $options['https']['method'] = 'GET';
    $options['http']['method'] = 'GET';

    $context = stream_context_create($options);

    $result = file_get_contents('https://discordapp.com/api/users/@me', false, $context);
    //var_dump($result);
    $jsonUser = json_decode($result, true);
    $userID = $jsonUser['id'];
    $discordID = 'discord:' . $userID;
    $lastPlayerName = '';
    $steam = '';
    $gameLicense = '';
    $discord = $discordID;
    $sql = getConn()->prepare('SELECT `lastPlayerName`, `steam`, `gameLicense` FROM `AccessKeys` WHERE `key` = ?;');
    $sql->bind_param("s", $key);
    $sql->execute();
    $res = $sql->get_result();
    while ($row = $res->fetch_assoc()) {
        $lastPlayerName = $row['lastPlayerName'];
        $steam = $row['steam'];
        $gameLicense = $row['gameLicense'];
    }
    $sql = getConn()->prepare('INSERT INTO `Users` VALUES (0, ?, ?, ?, ?);');
    $sql->bind_param("ssss", $lastPlayerName, $steam, $gameLicense, $discord);
    if($sql->execute()) {
        return true;
    }
    return false;
}
function getSteam() {
    return $_SESSION['steam'];
}
function getLicense() {
    return $_SESSION['gameLicense'];
}
function getDiscord($steam, $gameLicense, $lastPlayerName) {
    // Find their discord using gameLicense
    $sql = getConn()->prepare("UPDATE `Users` SET `steam` = ?, `lastPlayerName` = ? WHERE `gameLicense` = ?;");
    $sql->bind_param("sss", $steam, $lastPlayerName, $gameLicense);
    $sql->execute();
    $sql = getConn()->prepare("SELECT `discord` FROM `Users` WHERE `gameLicense` = ?;");
    $sql->bind_param("s", $gameLicense);
    if($sql->execute()) {
        // It executed
        $res = $sql->get_result();
        while($row = $res->fetch_assoc()) {
            return $row['discord'];
        }
    }
    return null;
}