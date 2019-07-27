import Subscribe from "./lib/parser";

// TODO: 0) Support parsing multiple
// TODO: 1) Run as Docker container instead of Daemon
// TODO: 2) Rewrite in Ruby maybe

const game = process.argv.pop()!;

if (game) {
  Subscribe(game);
} else {
  console.error("Missing argument, aborting...");
  process.exit(1);
}
