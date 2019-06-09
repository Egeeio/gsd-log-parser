import childProcess from "child_process";
import Redis from "ioredis";

const regex = {
  minecraft: /(?<=\bUUID\sof\splayer\s)(\w+)/,
};

export default async function Parse(game: string) {
  const log = childProcess.execSync
              (`journalctl --since '${parseInt(process.env.LOOP!, 10)}ms ago' --no-pager -u ${game}`).toString();
  const found = log.match(regex[game]);
  const connString = {
    host: process.env.IP!,
    port: parseInt(process.env.PORT!, 10),
  };
  const redis = new Redis(connString);
  const pub = new Redis(connString);
  console.log(found);

  if (found) {
    const player = found[0];
    redis.subscribe("minecraft", (err, count) => {
      pub.publish("minecraft", player);
    });
    console.log(`player joined: ${player}`);
  }
}
