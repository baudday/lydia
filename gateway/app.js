const express = require('express')
const path = require('path')
const cookieParser = require('cookie-parser')
const logger = require('morgan')

const indexRouter = require('./routes/index')
const sessionRouter = require('./routes/session/sessionRoutes')

const app = express()

app.use(logger('dev'))
app.use(express.json())
app.use(express.urlencoded({ extended: false }))
app.use(cookieParser())
app.use(express.static(path.join(__dirname, 'public')))

app.use('/', indexRouter)
app.use('/session', sessionRouter)

app.use(function (req, res, next) {
  res.status(404).json({ message: 'Not found' })
  next()
})

module.exports = app
