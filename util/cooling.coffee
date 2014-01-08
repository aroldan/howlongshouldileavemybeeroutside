timeToTemp = (startTemp, ambientTemp, targetTemp, k) ->
  Math.log((startTemp - ambientTemp)/(targetTemp - ambientTemp))/k

exports.tempAtTime = timeToTemp