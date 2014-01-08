console.log "yeahhhh"

contentDiv = $('#content')

timeToTemp = (startTemp, ambientTemp, targetTemp, k) ->
  Math.log((startTemp - ambientTemp)/(targetTemp - ambientTemp))/k

positionError = ->
  console.log "couldn't get location"

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