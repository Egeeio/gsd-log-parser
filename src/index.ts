import childProcess from 'child_process'
import Redis from 'ioredis'

const interval = 30000
const game = process.argv[2]

if (game) {
  Subscribe()
} else {
  console.error('Missing argument, aborting...')
  process.exit(1)
}

function Subscribe () {
  const connectionStr = {
    host: 'localhost',
    port: 6379
  }
  const redis = new Redis(connectionStr)
  const publisher = new Redis(connectionStr)
  redis.subscribe(game, (_err, _count) => {
    setInterval(() => {
      Publish(game, publisher)
    }, interval)
  })
}

async function Publish (game, publisher: Redis.Redis) {
  const matched = await Parse(game)
  if (matched) {
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
  const test = `journalctl --user --since '${interval}ms ago' --no-pager -u ${game}`
  console.log(test)
  try {
    const log = childProcess.execSync(`journalctl --user --since '${interval}ms ago' --no-pager -u ${game}`).toString()
    return log.match(regex[game])
  } catch (error) {
    console.log(`Error retrieving player from journalctl: ${error.message}`)
  }
}
