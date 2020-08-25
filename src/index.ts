#!/usr/bin/env node

import childProcess from 'child_process'
import Redis from 'ioredis'

if (!process.argv[2]) throw new Error('MISSING ARGUMENT 🔌')

const game = process.argv[2]
const interval = 30000
const redis = new Redis({ host: process.env.REDIS_HOST, password: process.env.REDIS_KEY })
const publisher = new Redis({ host: process.env.REDIS_HOST, password: process.env.REDIS_KEY })

// redis.auth(process.env.REDIS_KEY!)

redis.subscribe(game, (_err, _count) => {
  setInterval(() => {
    Publish(game, publisher)
  }, interval)
})

async function Publish (game, publisher: Redis.Redis) {
  const matched = await Parse(game)
  if (matched && matched.length > 0) {
    const player = matched[0]
    await publisher.publish(game, player)
    console.log(`Published ${player} in ${game}`)
  }
}

async function Parse (game) {
  const regex = {
    '7days': /Player '.*/,
    minecraft: /(?<=\bUUID\sof\splayer\s)(\w+)/,
    rust: /^.*joined from ip/m
  }
  try {
    const log = childProcess.execSync(`journalctl --since '${interval}ms ago' --no-pager -u ${game}`).toString()
    return log.match(regex[game])
  } catch (error) {
    console.log(error.message)
    return ''
  }
}
