(function() {
  var BEER_MESSAGES, contentDiv, lat, lon, positionError, randomBeerMessage, timeToTemp, weatherLookup, _ref;

  contentDiv = $('#content .beerresults');

  timeToTemp = function(startTemp, ambientTemp, targetTemp, k) {
    return Math.log((startTemp - ambientTemp) / (targetTemp - ambientTemp)) / k;
  };

  window.ttt = timeToTemp;

  positionError = function(err) {
    var msg;
    window.badtimes = err;
    msg = "Couldn't find you. Make sure to allow geolocation.";
    if (err.code === err.PERMISSION_DENIED) {
      msg = "You have to let us know where you are!";
    }
    return contentDiv.html(msg);
  };

  BEER_MESSAGES = ["Crack 'em.", "Aww yeah.", "You'll be in sudsville in no time.", "Beer town!", "I'll drink to that."];

  randomBeerMessage = function() {
    return BEER_MESSAGES[Math.floor(Math.random() * BEER_MESSAGES.length)];
  };

  weatherLookup = function(lat, lon) {
    var qProm;
    contentDiv.html("Looking up the weather...");
    qProm = $.ajax("/weather", {
      data: {
        lat: lat,
        lon: lon
      }
    });
    return qProm.then(function(result) {
      var mins, msg, secs, temp, time;
      temp = result.currentTemp;
      time = timeToTemp(22, temp, 2, .0007);
      if (temp > 2 || isNaN(time) || time > 2 * 60 * 60) {
        msg = "It's too damn warm out. Put that beer in the fridge.";
      } else {
        mins = Math.floor(time / 60);
        secs = Math.floor(time % 60);
        msg = "" + mins + " minutes, " + secs + " seconds oughta do it. " + (randomBeerMessage());
      }
      return contentDiv.html(msg);
    });
  };

  if (location.search.indexOf("ll=") !== -1) {
    _ref = location.search.split("ll=")[1].split(","), lat = _ref[0], lon = _ref[1];
    weatherLookup(lat, lon);
  } else if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(pos) {
      return weatherLookup(pos.coords.latitude, pos.coords.longitude);
    }, positionError);
  }

}).call(this);
