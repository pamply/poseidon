express    = require('express')
app        = express()
bodyParser = require('body-parser')
mongodb    = require('mongodb')

R          = require('ramda')
WebSocket  = require('ws')

SERVER_PORT    = 3000
WEBSOCKET_PORT = 8085

SERVER_HOST_MONGODB      = "localhost"
PORT_MONGODB             = "27017"
DATABASE_NAME_MONGODB    = "poseidon-db"
DATABASE_COLLECTION_NAME = "metrics"

URL_MONGODB = "mongodb://#{SERVER_HOST_MONGODB}:#{PORT_MONGODB}/#{DATABASE_NAME_MONGODB}"

MongoClient = mongodb.MongoClient

wss = new WebSocket.Server({port:WEBSOCKET_PORT})

app.use((req, res, next) -> 
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Headers', "Content-Type")
  next()
)

app.use(bodyParser.json())

wss.on 'connection', (ws) ->
  console.log('connection')

app.listen SERVER_PORT, ->
  console.log("Listening on port #{SERVER_PORT}")

app.post '/poseidon', (req, res) ->
  wss.clients.forEach((client) -> if client.readyState is WebSocket.OPEN then client.send(JSON.stringify(req.body)))
  console.log(req.body)
  metric = req.body
  MongoClient.connect(URL_MONGODB, R.partial(onInsertion, [metric]))
  res.contentType('application/json')
  res.status(200).json(req.body)

app.get '/metrics', (req, res) ->
  console.log("Calling metrics")
  res.header("Access-Control-Allow-Origin", "*")
  MongoClient.connect(URL_MONGODB, R.partial(onQuerying, [res, req.query.limit, req.query.overMinutes]))

onInsertion = (metric, err, db) ->
  if err
    console.log("Has been an error #{err}")
  else
    console.log("Successfully connection to db #{DATABASE_NAME_MONGODB}")
    metric.time_sent = new Date(metric.time_sent)
    db.collection(DATABASE_COLLECTION_NAME).insertOne(metric, (err, res) -> 
      if err then throw err
      console.log("1 metric inserted")
      db.close()) 

onQuerying = (res, limit, overMinutes, err, db) ->
  console.log(new Date())
  afterMinutes = new Date()
  overMinutesInMilliseconds = overMinutes*60*1000
  afterMinutes.setTime(afterMinutes.getTime() + overMinutesInMilliseconds)
  console.log(afterMinutes)
  db.collection(DATABASE_COLLECTION_NAME).find({"time_sent": {"$lt": afterMinutes, "$gt": new Date()}}, {'time_sent': true, 'id': true, 'pressure':true, 'flow':true}).limit(Number(limit)).sort(id: 1, time_sent: 1).toArray((err, result) -> compressResponse(result, res) unless err)

compressResponse = (result, res)->
  console.log(result)
  res.status(200).json(result)
