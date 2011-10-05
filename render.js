// render script

var address = "",
    output = "",
    w = 0,
    h = 0;

function renderUrlToFile(url, file, w, h, userAgent, callback) {
    var page = new WebPage();
    page.viewportSize = { width: w, height: h };
    // using the Android user agent
    page.settings.userAgent = userAgent;

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


if (phantom.args.length !== 5) {
  console.log('Usage: rasterize.js URL filename width height');
  phantom.exit();

} else {

  address = phantom.args[0];
  file = phantom.args[1];
  w = phantom.args[2];
  h = phantom.args[3];
  userAgent = phantom.args[4];

  renderUrlToFile(address, file, w, h, userAgent, function (url, file) {
    console.log(url + " -> " + file);
    phantom.exit();
  });
}
