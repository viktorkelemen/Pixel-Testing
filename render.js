// render script

var address = "",
    output = "",
    w = 0,
    h = 0;

function renderUrlToFile(url, file, callback) {
    var page = new WebPage();
    page.viewportSize = { width: 320 , height: "2000" };
    // using the Android user agent
    page.settings.userAgent = "Mozilla/5.0 (Linux; U; Android 2.2; en-us; Nexus One Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1";

    page.open(url, function(status){
       if ( status !== "success") {
           console.log("Unable to render '" + url + "'");
       } else {
           page.render(file);
       }
       delete page;
       callback(url, file);
    });
}


if (phantom.args.length !== 4) {

  console.log('Usage: rasterize.js URL filename width height');
  phantom.exit();

} else {

  address = phantom.args[0];
  file = phantom.args[1];
  w = phantom.args[2];
  h = phantom.args[3];

  renderUrlToFile(address, file, function (url, file) {
    console.log(url + " -> " + file);
    phantom.exit();
  });
}
