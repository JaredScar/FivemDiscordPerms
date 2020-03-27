<?php
$key = null;
try {
    $key = random_bytes(253);
} catch (Exception $ex) {
    echo $ex->getTraceAsString();
}
if (!is_null($key)) {
    // It's not null, we have a key
    // Implement it
    $gameLicense = $_POST['gameLicense'];
    $steam = $_POST['steam'];
    $lastPlayerName = $_POST['lastPlayerName'];
    $port = $_POST['port'];
    $remoteIP = $_SERVER['REMOTE_ADDR']; // Check if it has a running fivem server
    $content = file_get_contents("http://" . $remoteIP . ":" . $port . "/players.json");
    $contentJSON = json_decode($content);
    if (is_array($contentJSON)) {
        // It's a valid server, check if it has a valid player with this data
        // TODO
    }
}