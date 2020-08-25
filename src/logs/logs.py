import os
import re
import sys
import time
import redis
import subprocess

debug = True
interval = os.getenv("INTERVAL")
redis_host = os.getenv("REDIS_HOST")
redis_pass = os.getenv("REDIS_KEY")
game_daemon = os.getenv("GAME")

regex_dict = {
    'sdtd': r"Player '.*",
    'minecraft': r"(?<=\bUUID\sof\splayer\s)(\w+)",
    'rust': r"^.*joined from ip",
}

rdb = redis.Redis(
    host=redis_host,
    password=redis_pass)


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
    
    regex = regex_dict[game_daemon]
    yeet = str(log_slice)
    match = re.search(regex, yeet).group()
    print(match)
    # rdb.publish("minecraft", "yeeterism")
    time.sleep(int(interval))
