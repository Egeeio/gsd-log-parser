import os
import re
import click
import redis
import subprocess

@click.command()
@click.option("--name")
@click.option("--host")
@click.option("--debug")
def lager(game_daemon, redis_host, debug):
    redis_pass = os.getenv("REDIS_KEY")
    redis_port = os.getenv("REDIS_PORT")

    rdb = redis.Redis(host=redis_host, password=redis_pass, port=redis_port)
    regex_dict = {
        'sdtd': r"Player '.*",
        'minecraft': r"(?<=\bUUID\sof\splayer\s)(\w+)",
        'rust': r"(.*]:)(.*)(with steamid)(.*joined\s)",
        'rust-alt': r"(.*]:)(.*)(with)",
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
        print(f"Found match: {match} using: {regex}")
    except Exception as err:
        print(f"Failed to publish!: {err}")


if __name__ == "__main__":
    lager()
