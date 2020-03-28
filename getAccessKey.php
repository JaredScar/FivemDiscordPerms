<?php
require_once 'functions.php';
$key = null;
try {
    $key = random_bytes(15);
} catch (Exception $ex) {
    echo $ex->getTraceAsString();
}
if (!is_null($key)) {
    // It's not null, we have a key
    // Implement it
    $gameLicense = $_POST['gameLicense'];
    $steam = $_POST['steam'];
    $hasSteam = false;
    $hasLicense = false;
    $hasPlayerName = false;
    $lastPlayerName = $_POST['lastPlayerName'];
    $port = $_POST['port'];
    $remoteIP = $_SERVER['REMOTE_ADDR']; // Check if it has a running fivem server
    $content = file_get_contents("http://" . $remoteIP . ":" . $port . "/players.json");
    $contentJSON = json_decode($content);
    if (is_array($contentJSON)) {
        // It's a valid server, check if it has a valid player with this data
        //var_dump($contentJSON);

        for ($i = 0; $i < sizeof($contentJSON); $i++) {
            $object = $contentJSON[$i];
            $identifiers = $object->identifiers;
            for ($j = 0; $j < sizeof($identifiers); $j++) {
                if ($identifiers[$j] == $steam) {
                    $hasSteam = true;
                } else
                    if($identifiers[$j] == $gameLicense) {
                        $hasLicense = true;
                    }
            }
            if ($object->name == $lastPlayerName) {
                $hasPlayerName = true;
            }
        }
        if ($hasSteam && $hasLicense && $hasPlayerName) {
            $currentTime = new DateTime();
            $currentTime->modify("+5 minutes");
            $endMillis = strtotime($currentTime->format('Y-m-d H:i:sP'));
            $key = str_replace('=', '', str_replace('+', '', strval(base64_encode($key))));
            if (setupKey($key, strval($gameLicense), strval($steam), strval($lastPlayerName), intval($endMillis))) {
                echo json_encode($key);
            } else {
                echo 'Something went wrong on our end... Sorry.';
            }
        } else {
            // Not a valid player
            echo 'Access denied. Not a valid player on the fivem server...';
        }
    } else {
        echo 'Access denied. Not a valid fivem server found... IP: ' . $remoteIP . ' PORT: ' . $port;
    }
} else {
    // Something went wrong
    echo 'Something went wrong on our end... Sorry. Could not generate random_bytes()';
}