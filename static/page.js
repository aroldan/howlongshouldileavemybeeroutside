(function() {
  var contentDiv, positionError;

  console.log("yeahhhh");

  contentDiv = $('#content');

  positionError = function() {
    return console.log("couldn't get location");
  };

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(pos) {
      console.log(pos);
      return contentDiv.html("30 MINUTES");
    }, positionError);
  }

}).call(this);
