express = require('express')
app = express()
bodyParser = require('body-parser')
port = 3000

app.use(bodyParser.json())
app.post '/poseidon', (req, res) ->
  res.contentType('application/json')
  console.log req.body
  res.status(200).json(req.body)
  

app.listen port, ->
  console.log("Listening on port #{port}")
