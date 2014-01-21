(function() {
  var contentDiv, positionError, timeToTemp, weatherLookup;

  contentDiv = $('#content');

  timeToTemp = function(startTemp, ambientTemp, targetTemp, k) {
    return Math.log((startTemp - ambientTemp) / (targetTemp - ambientTemp)) / k;
  };

  positionError = function(err) {
    var msg;
    window.badtimes = err;
    msg = "Couldn't find you. Make sure to allow geolocation.";
    if (err.code === err.PERMISSION_DENIED) {
      msg = "You have to let us know where you are!";
    }
    return contentDiv.html(msg);
  };

  weatherLookup = function(lat, long) {
    var qProm;
    contentDiv.html("Looking up the weather...");
    qProm = $.ajax("/weather", {
      data: {
        lat: pos.coords.latitude,
        lon: pos.coords.longitude
      }
    });
    return qProm.then(function(result) {
      var mins, msg, secs, temp, time;
      temp = result.currentTemp;
      time = timeToTemp(22, temp, 2, .0007);
      if (isNaN(time) || time > 2 * 60 * 60) {
        msg = "It's too damn warm out. Put that beer in the fridge.";
      } else {
        mins = Math.floor(time / 60);
        secs = Math.floor(time % 60);
        msg = "About " + mins + " minutes, " + secs + " seconds oughta do it.";
      }
      return contentDiv.html(msg);
    });
  };

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(pos) {
      return weatherLookup(pos.coords.latitude, pos.coords.longitude);
    }, positionError);
  }

}).call(this);
