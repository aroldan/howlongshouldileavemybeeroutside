(function() {
  var contentDiv, positionError, timeToTemp;

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

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(pos) {
      var qProm;
      window.p = pos;
      contentDiv.html("Looking up the weather...");
      qProm = $.ajax("/weather", {
        data: {
          lat: pos.coords.latitude,
          lon: pos.coords.longitude
        }
      });
      return qProm.then(function(result) {
        var mins, secs, temp, time;
        temp = result.currentTemp;
        time = timeToTemp(22, temp, 2, .0007);
        mins = Math.floor(time / 60);
        secs = Math.floor(time % 60);
        return contentDiv.html("" + mins + " minutes, " + secs + " seconds");
      });
    }, positionError);
  }

}).call(this);
