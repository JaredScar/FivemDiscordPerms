<?php
require_once 'config.php';
session_start();
function sessionKey($key) {
    $_SESSION['key'] = $key;
}
function setupKey($key, $gameLicense, $steam, $lastPlayerName) {}
function checkKey($key) {}
function uploadData($key, $discord) {}
function getSteam() {
    return $_SESSION['steam'];
}
function getLicense() {
    return $_SESSION['gameLicense'];
}
function getDiscord($steam, $gameLicense) {}