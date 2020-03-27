<?php
require_once 'functions.php';
require_once 'config.php';
global $urlRedirect;
$key = $_GET['token'];
if (!is_null($key) and !isset($key) and checkKey($key)) {
    sessionKey($key);
    ?>
    <!DOCTYPE html>
    <html>
    <head>
        <title></title>
        <link rel="stylesheet" type="text/css" href="css/style.css"/>
    </head>
    <body>
    <div id="container-box">
        <div id="container-content">
            <img src="css/img/Badger_Discord_API.png"/>
            <p>DISCLAIMER: The Fivem collective is not associated with FivemDiscordPerms</p>
            <button onclick=
                    "window.location.href = '<?php echo $urlRedirect; ?>';">
                Connect Discord
            </button>
        </div>
    </div>
    </body>
    </html>
    <?php
}
    ?>