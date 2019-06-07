import childProcess from "child_process";

export default async function Parse(game: string = "minecraft") {
  const log = childProcess.execSync(`journalctl --since '15 seconds ago' --no-pager -u ${game}`).toString();
  const regex = /(?<=\bUUID\sof\splayer\s)(\w+)/;
  const found = log.match(regex);
  console.log(found);
}
