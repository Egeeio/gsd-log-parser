import childProcess from "child_process";
import Redis from "ioredis";

const regex = {
  minecraft: /(?<=\bUUID\sof\splayer\s)(\w+)/,
};

export default async function Parse(game: string) {
  const log = childProcess.execSync
              (`journalctl --since '${parseInt(process.env.LOOP!, 10)}ms ago' --no-pager -u ${game}`).toString();
  const found = log.match(regex[game]);

  if (found) {
    const player = found[0];
    const redis = new Redis({
      host: process.env.IP!,
      port: parseInt(process.env.PORT!, 10),
    });
    redis.set(game, player);
    console.log(`player joined: ${player}`);
  }
}
