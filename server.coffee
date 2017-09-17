express    = require('express')
app        = express()
bodyParser = require('body-parser')

R          = require('ramda')
WebSocket  = require('ws')

port = 3000

wss = new WebSocket.Server({port:8080})

wss.on 'connection', (ws) ->
  console.log('connection')
  ws.on 'message', (message) ->
    console.log('received: %s', message)
  setInterval(R.partial(sendMessage, [ws]), 1000)

sendMessage = (ws) ->
  data = 
    "id"             : 1
    "status"         : 1
    "leak_magnitude" : 1
    "level"          : 3
    "pressure"       : 100.2234
    "flow"           : 15.3256
    "lat"            : 25.111111
    "lon"            : -100.111111
    "time_sent"      : "2107-08-29T16:30:50.000"

  ws.send(JSON.stringify(data))

app.use(bodyParser.json())
app.post '/poseidon', (req, res) ->
  res.contentType('application/json')
  console.log req.body
  res.status(200).json(req.body)
  

app.listen port, ->
  console.log("Listening on port #{port}")
