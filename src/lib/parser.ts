import childProcess from "child_process";
import Redis from "ioredis";

export default async function Parse(game: string) {
  const log = childProcess.execSync(`journalctl --since '60 seconds ago' --no-pager -u ${game}`).toString();
  const regex = /(?<=\bUUID\sof\splayer\s)(\w+)/;
  const found = log.match(regex);

  if (found) {
    const player = found[0];
    const redis = new Redis({
      host: process.env.IP!,
      port: parseInt(process.env.PORT!, 10),
    });
    redis.set("minecraft", player);
    childProcess.execSync(`echo ${player} >> /tmp/players`);
    const fromRedis = await redis.get("minecraft");
    console.log(`player joined: ${fromRedis}`);
  }
}
