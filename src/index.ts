import Parse from "./lib/parser";

const game = process.argv.pop()!;

if (game) {
  setInterval(() => {
    Parse(game);
  }, parseInt(process.env.LOOP!, 10));
} else {
  console.error("Missing argument, aborting...");
  process.exit(1);
}
