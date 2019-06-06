import childProcess from "child_process";

export default async function Parse() {
  const test = childProcess.execSync("journalctl --no-pager -u docker");
  console.log(test.toString());
}
