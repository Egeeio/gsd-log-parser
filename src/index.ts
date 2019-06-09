import Parse from "./lib/parser";

const game = process.argv.pop()!;

if (game) {
  setInterval(() => {
    Parse(game);
  }, 60000);
} else {
  console.error("Missing argument, aborting...");
  process.exit(1);
}
