const express = require('express')
const path = require('path')
const cookieParser = require('cookie-parser')
const logger = require('morgan')
const { expressjwt: jwt } = require('express-jwt')

const indexRouter = require('./routes/index')
const sessionRouter = require('./routes/session/sessionRoutes')

const app = express()

app.use(logger('dev'))
app.use(express.json())
app.use(express.urlencoded({ extended: false }))
app.use(cookieParser())

app.use(express.static(path.join(__dirname, 'public')))
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, './public/index.html'))
})

app.use('/', indexRouter)
app.use('/session', sessionRouter)

app.use('/api', jwt({
  secret: process.env.JWT_SECRET,
  algorithms: ['HS256']
}))

app.post('/api/protected', function (req, res, next) {
  res.json({ message: 'This is a protected route.' })
})

app.use(function (err, req, res, next) {
  if (err.name === 'UnauthorizedError') {
    return res.status(401).send({ message: 'Invalid token.' })
  }

  next(err)
})

app.use(express.static(path.join(__dirname, '../')))

app.use(function (req, res, next) {
  res.status(404).json({ message: 'Not found' })
  next()
})

module.exports = app
