<?php
require_once 'functions.php';
$gameLicense = $_POST['gameLicense'];
$steam = $_POST['steam'];
$lastPlayerName = $_POST['lastPlayerName'];
$port = $_POST['port'];
$remoteIP = $_SERVER['REMOTE_ADDR']; // Check if it has a running fivem server
$content = file_get_contents("http://" . $remoteIP . ":" . $port . "/players.json");
$contentJSON = json_decode($content);
if (is_array($contentJSON)) {
    // It's a valid server
    // If so, then we want to submit this for finding their discord if they have one connected
    $discord = getDiscord($steam, $gameLicense, $lastPlayerName);
    echo $discord;
}
echo 'Access denied. Not a valid server found...';