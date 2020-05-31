# log-parsed [![CircleCI](https://circleci.com/gh/Egeeio/gsd-log-parser.svg?style=svg)](https://circleci.com/gh/Egeeio/gsd-log-parser)

[![Maintainability](https://api.codeclimate.com/v1/badges/b609edfcef21ba4e5d1d/maintainability)](https://codeclimate.com/github/Egeeio/gsd-log-parser/maintainability)
[![Build Status](https://travis-ci.com/Egeeio/gsd-cli.svg?branch=master)](https://travis-ci.com/Egeeio/gsd-cli)

log-parsed is a micro-service that parses the systemd journal and publishes to Redis.

## Built with 💖 and

- [TypeScript](https://www.typescriptlang.org/)
- [ioredis](https://github.com/luin/ioredis)

log-parsed is designed to be run by a service manager such as systemd. A very simple unit file placed at `/etc/systemd/system` would look something like this:

```
[Unit]
Description=A service for parsing the systemd journal
After=network.target

[Install]
WantedBy=default.target

[Service]
Type=simple
ExecStart=log-parsed
```