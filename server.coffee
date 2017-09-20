express    = require('express')
app        = express()
bodyParser = require('body-parser')

R          = require('ramda')
WebSocket  = require('ws')

SERVER_PORT    = 3000
WEBSOCKET_PORT = 8085

wss = new WebSocket.Server({port:WEBSOCKET_PORT})

app.use(bodyParser.json())

wss.on 'connection', (ws) ->
  console.log('connection')

app.listen SERVER_PORT, ->
  console.log("Listening on port #{SERVER_PORT}")

app.post '/poseidon', (req, res) ->
  wss.clients.forEach((client) -> if client.readyState is WebSocket.OPEN then client.send(JSON.stringify(req.body)))
  console.log(req.body)
  res.contentType('application/json')
  res.status(200).json(req.body)