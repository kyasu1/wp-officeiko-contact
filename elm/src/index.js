// pull in desired CSS/SASS files
require( './styles/main.scss' );

/* get an itemID from referrer if it exists */
var maybeItemID = document.referrer.split('/').slice(-1)[0].split('?').slice(0)[0];
var itemID = maybeItemID === '' ? null : maybeItemID;

/* inject bundled Elm app into div#main */
var Elm = require( './elm/Main' );
var root = document.getElementById('wp-auction-inquiry');
Elm.Main.embed(root, { itemID: itemID, currentTime: Date.now()});
