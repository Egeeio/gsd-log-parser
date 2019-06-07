import Parse from "./lib/parser";

const game = process.argv.pop()!;

if (game)
  Parse(game);
else
  console.error("Missing argument, aborting...");
