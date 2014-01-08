console.log "yeahhhh"

contentDiv = $('#content')

positionError = ->
  console.log "couldn't get location"

if navigator.geolocation
  navigator.geolocation.getCurrentPosition (pos) ->
    console.log pos
    contentDiv.html("30 MINUTES")
  , positionError