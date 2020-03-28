<?php
require_once 'config.php';
session_start();
function getConn() {
    global $host;
    global $username;
    global $password;
    global $port;
    global $database;
    $conn = new mysqli($host, $username, $password, $database, $port);
    return $conn;
}
function sessionKey($key) {
    $_SESSION['key'] = $key;
}
function getKey() {
    $key = $_SESSION['key'];
    return $key;
}
function setupKey($key, $gameLicense, $steam, $lastPlayerName, $endMillis) {
    $sql = getConn();
    $stmt = $sql->prepare('INSERT INTO `AccessKeys` VALUES (0, ?, ?, ?, ?, ?, 0);');
    $stmt->bind_param("ssssi", $key, $lastPlayerName, $steam, $gameLicense, $endMillis);
    if ($stmt->execute()) {
        return true;
    }
    return false;
}
function checkKey($key) {
    $currentTime = new DateTime();
    $endMillis = strtotime($currentTime->format('Y-m-d H:i:sP'));
    $sql = getConn();
    $stmt = $sql->prepare("SELECT `timeExpires`, `expired` FROM `AccessKeys` WHERE `keyy` = ?;");
    $stmt->bind_param("s", $key);
    if ($stmt->execute()) {
        // Check timeExpires and if is expired already
        $res = $stmt->get_result();
        while ($row = $res->fetch_assoc()) {
            $expired = $row['expired'];
            $timeExpires = $row['timeExpires'];
            if ($expired === 1) {
                return false;
            }
            if ($timeExpires < $endMillis) {
                return false;
            }
        }
        if($res->num_rows > 0) {
            return true;
        }
    }
    return false;
}
function expireKey($key) {
    $sql = getConn();
    $stmt = $sql->prepare("DELETE FROM `AccessKeys` WHERE `keyy` = ?;");
    $stmt->bind_param('s', $key);
    if($stmt->execute()) {
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
        'scope' => 'identify email'
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
    //var_dump($discordCode);
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
    $jsonUser = json_decode($result, true);
    $userID = $jsonUser['id'];
    $discordID = 'discord:' . $userID;
    $lastPlayerName = '';
    $steam = '';
    $gameLicense = '';
    $discord = $discordID;
    $sql = getConn();
    $stmt = $sql->prepare('SELECT `lastPlayerName`, `steam`, `gameLicense` FROM `AccessKeys` WHERE `keyy` = ?;');
    $stmt->bind_param("s", $key);
    $stmt->execute();
    $res = $stmt->get_result();
    while ($row = $res->fetch_assoc()) {
        $lastPlayerName = $row['lastPlayerName'];
        $steam = $row['steam'];
        $gameLicense = $row['gameLicense'];
    }
    $stmt = $sql->prepare('INSERT INTO `Users` VALUES (0, ?, ?, ?, ?);');
    $stmt->bind_param("ssss", $lastPlayerName, $steam, $gameLicense, $discord);
    if($stmt->execute()) {
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
    $sql = getConn();
    $stmt = $sql->prepare("UPDATE `Users` SET `steam` = ?, `lastPlayerName` = ? WHERE `gameLicense` = ?;");
    $stmt->bind_param("sss", $steam, $lastPlayerName, $gameLicense);
    $stmt->execute();
    $stmt = $sql->prepare("SELECT `discord` FROM `Users` WHERE `gameLicense` = ?;");
    $stmt->bind_param("s", $gameLicense);
    if($stmt->execute()) {
        // It executed
        $res = $stmt->get_result();
        while($row = $res->fetch_assoc()) {
            return $row['discord'];
        }
    }
    return null;
}