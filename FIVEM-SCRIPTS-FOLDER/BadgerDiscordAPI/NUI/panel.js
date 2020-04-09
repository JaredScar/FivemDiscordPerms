/*-------------------------------------------------------------------------

    BadgerDiscordAPI
    Created by Badger
    
-------------------------------------------------------------------------*/

var resourceName = ""; 
var panelShown = false;

$( function() {
    var container = $( "#container-box" );
    var iframe = $("#frame");
    window.addEventListener( 'message', function( event ) {
        var item = event.data;
        if ( item.resourcename ) {
            resourceName = item.resourcename;
        }
        if ( item.panelShown ) {
            panelShown = item.panelShown;
            if (panelShown) {
                container.show();
            } else {
                container.hide();
            }
        }
        if (item.token) {
            $('#button').attr('onclick', 'copyText("' + item.token + '");');
            $('#input').attr('value', item.token);
        }
    } );
} )
function copyText(text) {
    var $temp = $("<input>");
    $("body").append($temp);
    $temp.val(text).select();
    document.execCommand("copy");
    $temp.remove();
    alert("Copied link to clipboard, now paste it in a browser...")
}

function sendData( name, data ) {
    $.post( "http://" + resourceName + "/" + name, JSON.stringify( data ), function( datab ) {
        if ( datab != "ok" ) {
            console.log( datab );
        }            
    } );
}