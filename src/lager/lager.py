import os
import re
import redis
import subprocess

def lager():
    debug = os.getenv("LOGGER_DEBUG")
    redis_host = os.getenv("REDIS_HOST")
    redis_pass = os.getenv("REDIS_KEY")
    game_daemon = os.getenv("GAME")

    rdb = redis.Redis(host=redis_host, password=redis_pass)
    regex_dict = {
        'sdtd': r"Player '.*",
        'minecraft': r"(?<=\bUUID\sof\splayer\s)(\w+)",
        'rust': r"(\/.*\/)(.*)(joined)",
    }

    if debug:
        file = open(f"./src/tests/{game_daemon}.txt")
        log_slice = file.read().replace("\n", " ")
        file.close()
        log_stdout = str(log_slice)
    else:
        log_slice = subprocess.check_output(
            [
                'journalctl',
                '--since',
                f'45s ago',
                '--no-pager',
                '-u',
                game_daemon
            ],
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
    except Exception as err:
        print(f"Failed to publish!: {err}")


if __name__ == "__main__":
    lager()
