express = require('express')
app = express()
bodyParser = require('body-parser')
port = 3000

app.use(bodyParser.json())
app.post '/poseidon', (req, res) ->
  console.log req.body
  res.sendStatus(200)

app.listen port, ->
  console.log("Listening on port #{port}")
