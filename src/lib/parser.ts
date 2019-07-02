import childProcess from "child_process";
import Redis from "ioredis";
import Router from "./subscriptionRouter";

const regex = {
  minecraft: /(?<=\bUUID\sof\splayer\s)(\w+)/,
  rust: /^.*has entered the game/,
};
const connString = {
  host: process.env.IP!,
  port: parseInt(process.env.PORT!, 10),
};

export default function Subscribe(game: string) {
  const redis = new Redis(connString);
  const publisher = new Redis(connString);
  redis.subscribe(game, (err, count) => {
    setInterval(() => {
      Publish(game, publisher);
    }, parseInt(process.env.LOOP!, 10));
  });
}

export async function Publish(game: string, publisher: Redis.Redis) {
  const matched = await Parse(game);
  if (matched) {
    Router(game, matched[0], publisher);
    console.log(`Found log match: ${matched}`);
  }
}

export async function Parse(game: string) {
  const log = childProcess.execSync
    (`journalctl --since '${parseInt(process.env.LOOP!, 10)}ms ago' --no-pager -u ${game}`).toString();
  // return log.match(regex[game]);
  return ["hello world"];
}
