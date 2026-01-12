#!/usr/bin/env python
from typing import List, Dict
import sys
import argparse
import json
from pathlib import Path

SORT_CMD = "sort"
INCR_CMD = "incr"

CACHE_PATH = "/home/fincei/.cache/dmenu-hist/"

def read_input() -> List[str]:
    """read all lines from stdin"""
    lines = []
    for line in sys.stdin:
        lines.append(line.rstrip('\n'))
    return lines

def write_dict_to_file(name: str, dict: Dict[str, int]):
    Path(CACHE_PATH).mkdir(parents=True, exist_ok=True)
    with open(CACHE_PATH + name + ".json", "w") as file:
        file.write(json.dumps(dict))

def read_dict_from_file(name: str) -> Dict[str, int]:
    """tries to read dictionary from json file, if file does not exist, an empty dict is returned"""
    try:
        with open(CACHE_PATH + name + ".json", "r") as file:
            res = json.loads(file.read())
    except FileNotFoundError:
        return {}
    return res



def sort(context_name: str):
    input = read_input()
    freq_map = read_dict_from_file(context_name)
    input.sort(key=lambda k: freq_map.get(k, 0), reverse=True)
    for line in input:
        print(line)


def increment(context_name: str):
    input = read_input()
    key = input[0]
    assert(len(input) == 1)
    freq_map = read_dict_from_file(context_name)

    freq_map[key] = freq_map.get(key, 0) + 1

    write_dict_to_file(context_name, freq_map)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="dmenu-hist", description="a frequency sorting facility for dmenu"
    )
    parser.add_argument(
        "cmd",
        choices=[SORT_CMD, INCR_CMD],
        help="the command being invoked: incr or sort",
    )
    parser.add_argument("name", help="the name of sorting context")

    res = parser.parse_args()

    if res.cmd == INCR_CMD:
        increment(res.name)
    if res.cmd == SORT_CMD:
        sort(res.name)
