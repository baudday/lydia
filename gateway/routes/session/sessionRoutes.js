const express = require('express')
const router = express.Router()
const sessionOperations = require('./sessionOperations')
const jwt = require('jsonwebtoken')
const jwtSecret = process.env.JWT_SECRET

router.post('/new', function (req, res, next) {
  const { email } = req.body

  console.log('body', req.body)

  const accessCode = sessionOperations.makeAccessCode(email)

  console.log('code', accessCode)

  res.status(204).send()
})

router.post('/create', function (req, res, next) {
  const { email, accessCode } = req.body
  const user = sessionOperations.authenticateUser(email, accessCode)

  if (!user) {
    return res.status(401).json({ error: 'Invalid access code.' })
  }

  res.json({ token: jwt.sign(user, jwtSecret, { expiresIn: '1h' }) })
})

router.post('/update', function (req, res, next) {
  const { token } = req.body

  try {
    const user = jwt.verify(token, jwtSecret)
    const payload = {
      id: user.id,
      name: user.name,
      email: user.email
    }

    res.json({ token: jwt.sign(payload, jwtSecret, { expiresIn: '1h' }) })
  } catch (err) {
    res.status(401).json({ error: 'Invalid token.' })
    console.log(err)
  }
})

router.get('/', function (req, res, next) {
  res.json(
    sessionOperations.getUsers().map(user => ({
      ...user,
      accessCodes: sessionOperations.getAccessCodes().filter(ac => ac.userId === user.id)
    }))
  )
})

module.exports = router
