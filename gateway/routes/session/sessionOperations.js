const moment = require('moment')
const crypto = require('crypto')

const users = [
  {
    id: 1,
    name: 'Willem Ellis',
    email: 'willem.ellis@gmail.com'
  }
]

let accessCodes = []

const makeAccessCode = function (email) {
  const user = users.find(u => u.email === email)

  if (!user) {
    // throw new NotFoundError('User not found.')
    return
  }

  accessCodes = accessCodes.filter(ac => ac.userId !== user.id)

  const expiresAt = moment().add(15, 'minutes').toDate()
  const accessCode = crypto.randomBytes(3).toString('hex')

  accessCodes.push({
    userId: user.id,
    code: accessCode,
    expiresAt
  })

  return accessCode
}

const authenticateUser = function (email, accessCode) {
  const user = users.find(u => u.email === email)

  if (!user) {
    // throw new NotFoundError('User not found.')
    return
  }

  const code = accessCodes.find(ac => ac.userId === user.id && ac.code.toLowerCase() === accessCode.toLowerCase())

  if (!code) {
    // throw new UnauthorizedError('Invalid access code.')
    return
  }

  accessCodes.splice(accessCodes.indexOf(code), 1)

  if (moment().isAfter(code.expiresAt)) {
    // throw new UnauthorizedError('Access code expired.')
    return
  }

  return user
}

const getUsers = function () { return users }
const getAccessCodes = function () { return accessCodes }

module.exports = { makeAccessCode, authenticateUser, getUsers, getAccessCodes }
