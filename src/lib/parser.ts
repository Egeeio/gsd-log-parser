import childProcess from "child_process";

export default async function Parse(game: string) {
  const log = childProcess.execSync(`journalctl --no-pager -u ${game}`).toString();
  const regex = /(?<=\bUUID\sof\splayer\s)(\w+)/;
  const found = log.match(regex);
  if (found) {
    const player = found[0];
    childProcess.execSync(`echo ${player} >> /tmp/players`);
    console.log(`player joined: ${player}`);
  }
}
