import os
import re
import time
import redis
import subprocess

debug = os.getenv("LOGGER_DEBUG")
interval = os.getenv("INTERVAL")
redis_host = os.getenv("REDIS_HOST")
redis_pass = os.getenv("REDIS_KEY")
game_daemon = os.getenv("GAME")

rdb = redis.Redis(host=redis_host, password=redis_pass)
regex_dict = {
    'sdtd': r"Player '.*",
    'minecraft': r"(?<=\bUUID\sof\splayer\s)(\w+)",
    'rust': r"(\/.*\/)(.*)(joined)",
}

while True:
    if debug:
        file = open(f"./src/tests/{game_daemon}.log")
        log_slice = file.read().replace("\n", " ")
        file.close()
    else:
        log_slice = subprocess.run(
            [
                'journalctl',
                '--since',
                f'{interval}s ago',
                '--no-pager',
                '-u',
                game_daemon
            ],
            check=True
        )
    try:
        regex = regex_dict[game_daemon]
        yeet = str(log_slice)

        if game_daemon == "rust":
            match = re.search(regex, yeet).group(2).strip()
        else:
            match = re.search(regex, yeet).group().strip()
        # print(match)
        rdb.publish(game_daemon, match)
    except Exception as err:
        print(f"Failed to publish!: {err}")
    time.sleep(int(interval))
