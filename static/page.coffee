contentDiv = $('#content')

timeToTemp = (startTemp, ambientTemp, targetTemp, k) ->
  Math.log((startTemp - ambientTemp)/(targetTemp - ambientTemp))/k

positionError = (err) ->
  window.badtimes = err
  msg = "Couldn't find you. Make sure to allow geolocation."

  if err.code is err.PERMISSION_DENIED
    msg = "You have to let us know where you are!"

  contentDiv.html(msg)

if navigator.geolocation
  navigator.geolocation.getCurrentPosition (pos) ->
    window.p = pos
    contentDiv.html("Looking up the weather...")
    
    qProm = $.ajax "/weather",
      data:
        lat: pos.coords.latitude
        lon: pos.coords.longitude

    qProm.then (result) ->
      temp = result.currentTemp

      time = timeToTemp(22, temp, 2, .0007)

      mins = Math.floor(time/60)
      secs = Math.floor(time % 60)

      contentDiv.html("#{mins} minutes, #{secs} seconds")
  , positionError