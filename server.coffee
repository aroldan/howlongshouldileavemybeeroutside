express = require('express')
app = express()

request = require('request')
markdown = require('markdown').markdown;
fs = require('fs')

app.set('view engine', 'jade')
app.set('views', __dirname + '/views')

# use nginx for proxy
app.enable('trust proxy')

# serve static files and log
app.use(express.logger())
app.use('/static', express.static(__dirname + '/static'))

serveMarkdownRoute = (path, mdfilename, title) ->
  mdSrc = fs.readFileSync "markdown/#{mdfilename}", 'utf8'
  mdContent = markdown.toHTML(mdSrc)

  app.get path, (req, res) ->
    res.render "markdowntemplate",
      title: title
      mdContent: mdContent

serveMarkdownRoute "/about", "about.md", 'About'

app.get '/', (req, res) ->
  res.render 'main',
    title: "Seriously though how long."

app.get "/why", (req, res) ->
  res.render "why",
    title: "Why?"

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