import childProcess from "child_process";
import Redis from "ioredis";

const regex = {
  "7days": /Player '.*/,
  "minecraft": /(?<=\bUUID\sof\splayer\s)(\w+)/,
  "rust": /^.*has entered the game/m,
};
const connString = {
  host: process.env.IP!,
  port: parseInt(process.env.PORT!, 10),
};

export default function Subscribe(game: string) {
  const redis = new Redis(connString);
  const publisher = new Redis(connString);
  redis.subscribe(game, (err, count) => { // TODO: use or safely remove unused vars
    setInterval(() => {
      Publish(game, publisher);
    }, parseInt(process.env.LOOP!, 10));
  });
}

export async function Publish(game: string, publisher: Redis.Redis) {
  const matched = await Parse(game); // TODO: Unsure if this needs to be async
  if (matched) {
    const player = matched[0];
    await publisher.publish(game, player);
    console.log(`Published ${player} in ${game}`);
  }
}

export async function Parse(game: string) {
  const log = childProcess.execSync
    (`journalctl --since '${parseInt(process.env.LOOP!, 10)}ms ago' --no-pager -u ${game}`).toString();
  return log.match(regex[game]);
}
