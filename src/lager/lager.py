import os
import re
import redis
import subprocess

redis_host = os.getenv("REDIS_HOST")
redis_port = os.getenv("REDIS_PORT")
game_daemon = os.getenv("GAME")

rdb = redis.Redis(host=redis_host, port=redis_port)
regex_dict = {
    'sdtd': r"Player '.*",
    'minecraft': r"(?<=\bUUID\sof\splayer\s)(\w+)",
    'rust': r"(\/.*?\/)(.*\s)(joined)", #r"(.*]:)(.*)(with steamid)(.*joined\s)",
}

log_slice = subprocess.check_output(
    [ 'docker', 'logs', '--since', '60s', game_daemon ],
    universal_newlines=True
)
log_stdout = log_slice

try:
    regex = regex_dict[game_daemon]
    match = re.search(regex, log_stdout)
    if match is not None:
        if game_daemon == "rust":
            match = re.search(regex, log_stdout).group(2).strip()
        else:
            match = re.search(regex, log_stdout).group().strip()
        print(f"PUBLISHING: {match} TO: {game_daemon}")
        rdb.publish(game_daemon, match)
    else:
        print(f"No matches found.")
except Exception as err:
    print(f"Failed to publish!: {err}")
