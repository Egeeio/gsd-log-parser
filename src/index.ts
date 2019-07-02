import Subscribe from "./lib/parser";

const game = process.argv.pop()!;

if (game) {
  Subscribe(game);
} else {
  console.error("Missing argument, aborting...");
  process.exit(1);
}
