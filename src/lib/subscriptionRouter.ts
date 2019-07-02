import Redis from "ioredis";

export default async function Router(game: string, player: string, publisher: Redis.Redis) {
  switch (game) {
    case "minecraft":
      Minecraft(player, publisher);
      console.log(`Found ${player}`);
      break;

    default:
      break;
  }
}

export async function Minecraft(player: string, publisher: Redis.Redis) {
  publisher.publish("minecraft", player);
}
