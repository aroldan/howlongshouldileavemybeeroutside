contentDiv = $('#content .beerresults')

timeToTemp = (startTemp, ambientTemp, targetTemp, k) ->
  Math.log((startTemp - ambientTemp)/(targetTemp - ambientTemp))/k

window.ttt = timeToTemp

positionError = (err) ->
  window.badtimes = err
  msg = "Couldn't find you. Make sure to allow geolocation."

  if err.code is err.PERMISSION_DENIED
    msg = "You have to let us know where you are!"

  contentDiv.html(msg)

BEER_MESSAGES = [
  "Crack 'em."
  "Aww yeah."
  "You'll be in sudsville in no time."
  "Beer town!"
  "I'll drink to that."
]

randomBeerMessage = -> BEER_MESSAGES[Math.floor(Math.random() * BEER_MESSAGES.length)]

weatherLookup = (lat, lon) ->
  contentDiv.html("Looking up the weather...")
    
  qProm = $.ajax "/weather",
    data:
      lat: lat
      lon: lon

  qProm.then (result) ->
    temp = result.currentTemp

    time = timeToTemp(22, temp, 2, .0007)

    if temp > 2 || isNaN(time) || time > 2 * 60 * 60
      msg = "It's too damn warm out. Put that beer in the fridge."
    else
      mins = Math.floor(time/60)
      secs = Math.floor(time % 60)
      msg = "#{mins} minutes, #{secs} seconds oughta do it. #{randomBeerMessage()}"

    contentDiv.html(msg)

if navigator.geolocation
  navigator.geolocation.getCurrentPosition (pos) ->
    weatherLookup pos.coords.latitude, pos.coords.longitude
  , positionError