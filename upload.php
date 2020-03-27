<?php
require_once 'functions.php';
$key = getKey();
$discordCode = $_GET['code'];
if (checkKey($key)) {
    if (uploadData($key, $discordCode)) {
// AT END:
        expireKey($key);
        destroySession();
    } else {
        echo 'Something went wrong... Sorry.';
    }
} else {
    echo 'You did not respond in time... Token has expired...!';
}