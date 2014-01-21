express = require('express')
app = express()

cooling = require("./util/cooling")
request = require('request')

app.set('view engine', 'jade')
app.set('views', __dirname + '/views')
app.enable('trust proxy')

app.use(express.logger())
app.use('/static', express.static(__dirname + '/static'))

app.get '/', (req, res) ->
  res.render 'main',
    title: "home"

app.get '/weather', (req, res) ->
  if req.query.lat and req.query.lon
    request "http://api.openweathermap.org/data/2.5/weather?lat=#{req.query.lat}&lon=#{req.query.lon}&units=metric", (err, resp, body) ->
      result = JSON.parse body
      res.send
        currentTemp: result.main.temp
  else
    res.send 400,
      error: "That's no good."

app.listen(9000)