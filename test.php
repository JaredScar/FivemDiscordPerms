<?php
require_once 'config.php';
function getConn() {
    global $host;
    global $username;
    global $password;
    global $port;
    global $database;
    $conn = new mysqli($host, $username, $password, $database, $port);
    return $conn;
}
$key = 'TestKey';
$lastPlayerName = 'BadBadBadBad';
$steam = 'steam';
$gameLicense = 'license';
$endMillis = time();
$sql = getConn()->prepare('INSERT INTO `AccessKeys` VALUES (0, ?, ?, ?, ?, ?, 0);');
$sql->bind_param("ssssi", $key, $lastPlayerName, $steam, $gameLicense, intval($endMillis));
var_dump($sql->execute());