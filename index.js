const childProcess = require('child_process')
const Redis = require('ioredis')

const interval = 30000
const game = process.argv

if (game[2]) {
  Subscribe(game)
} else {
  console.error('Missing argument, aborting...')
  process.exit(1)
}

const regex = {
  '7days': /Player '.*/,
  minecraft: /(?<=\bUUID\sof\splayer\s)(\w+)/,
  rust: /^.*joined from ip/m
}

const connectionStr = {
  host: 'localhost',
  port: 6379
}

function Subscribe (game) {
  const redis = new Redis(connectionStr)
  const publisher = new Redis(connectionStr)
  redis.subscribe(game, (err, count) => { // TODO: use or safely remove unused vars
    setInterval(() => {
      Publish(game, publisher)
    }, interval)
  })
}

async function Publish (game, publisher) {
  const matched = await Parse(game) // TODO: Unsure if this needs to be async
  if (matched.length > 0) {
    const player = matched[0]
    await publisher.publish(game, player)
    console.log(`Published ${player} in ${game}`)
  }
}

async function Parse (game) {
  try {
    const log = childProcess.execSync(`journalctl --user --since '${interval}ms ago' --no-pager -u ${game}`).toString()
    return log.match(regex[game])
  } catch (error) {
    console.log(error.message)
    return ''
  }
}
