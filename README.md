# log-parser [![CircleCI](https://circleci.com/gh/Egeeio/gsd-log-parser.svg?style=svg)](https://circleci.com/gh/Egeeio/gsd-log-parser)

[![Maintainability](https://api.codeclimate.com/v1/badges/b609edfcef21ba4e5d1d/maintainability)](https://codeclimate.com/github/Egeeio/gsd-log-parser/maintainability)
[![Discord](https://discordapp.com/api/guilds/183740337976508416/widget.png?style=shield)](https://discord.gg/EMbcgR8)

gsd-log-parser is a micro-service that parses dedicated game server logs from journald and publishes new players to Redis.

## Built with 💖 and

- [TypeScript](https://www.typescriptlang.org/)
- [ioredis](https://github.com/luin/ioredis)

## Purpose

gsd-log-parser is designed to work with dedicated game servers created with the [gsd-cli](https://github.com/Egeeio/gsd-cli). gsd-log-parser runs as a daemon and perodically parses journald for new players joining the server. When a new player joins, the player name is published to Redis, where another gsd service publishes the players to a Discord server.
