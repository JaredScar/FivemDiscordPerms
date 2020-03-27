<?php
require_once 'functions.php';
require_once 'config.php';
global $urlRedirect;
?>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <link rel="stylesheet" type="text/css" href="css/style.css" />
</head>
<body>
<div id="container-box">
    <div id="container-content">
        <button onclick=
                "window.location.href = '<?php echo $urlRedirect; ?>';">
            Connect Discord</button>
    </div>
</div>
</body>
</html>
