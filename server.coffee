express    = require('express')
app        = express()
bodyParser = require('body-parser')

R          = require('ramda')
WebSocket  = require('ws')

port = 3000

wss = new WebSocket.Server({port:8085})
app.use(bodyParser.json())

wss.on 'connection', (ws) ->

  app.post '/poseidon', (req, res) ->
    res.contentType('application/json')
    ws.send(JSON.stringify(req.body))
    res.status(200).json(req.body)

  ws.on 'message', (message) ->
    console.log('received: %s', message)
  #setInterval(R.partial(sendMessage, [ws]), 1000)

app.listen port, ->
  console.log("Listening on port #{port}")
  console.log('connection')
###sendMessage = (ws) ->
  data = 
    id             : Math.round(Math.random()*2)+1
    status         : 1
    leak_magnitude : 1
    level          : 1
    pressure       : Math.random()*100
    flow           : 15.3256
    lat            : Math.random()*50
    lon            : -100.111111
    time_sent      : "2107-08-29T16:30:50.000"

  ws.send(JSON.stringify(data))###
