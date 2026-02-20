#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#   "canvasapi==3.4.0",
#   "typer==0.21.1"
# ]
# ///
from canvasapi.module import Module, ModuleItem
from canvasapi.course import Course
from dataclasses import dataclass, asdict
from datetime import datetime
from typing import List, Optional
import json
import os
import sys
from pathlib import Path
import typer
from canvasapi import Canvas
from canvasapi.user import User

# Add the script's directory to sys.path for local imports
script_dir = Path(__file__).parent
sys.path.insert(0, str(script_dir))

from lib.fuzzel_utils import fuzzel  # noqa: E402 Needs above path modification

# data models
@dataclass
class MyCourse:
    """Simplified course representation for caching."""
    id: int
    name: str

# constants
APP_NAME = "canvas_test"
ME=161979
API_URL = os.environ["CANVAS_API_URL"]
API_KEY = os.environ["CANVAS_API_KEY"]

# some tool parameters
if (API_KEY is None or API_URL is None):
    print("CANVAS_API_URL or CANVAS_API_KEY was None")
    sys.exit(1)


# global instances
api = Canvas(API_URL, API_KEY)
app = typer.Typer()
me: User = api.get_user(ME)
my_courses: List[Course] = me.get_courses(enrollment_state='active')
# my_courses: List[Course] = list(me.get_courses())
courses_map = {course.name : course for course in my_courses}

def pick(items):
    names = [i.name for i in items]
    map = {i.name: i for i in items}
    choice = fuzzel(names)
    if (choice is None):
        return
    result = map[choice]
    return result

# app commands
@app.command()
def course_info():
    # Pick a course
    print("courses")
    print(my_courses)

    course = pick(my_courses)

    if not course:
        return


    modules: List[Module] = list(course.get_modules(include=["items"]))

    print("modules")

    for module in modules:
        print(module.name)
        print("items")
        items = module.items

        print(items[0])
        # for item in module.items:
        #     print(item)


    # module = pick(modules)
    # if (not module):
    #     return
    # print(module)

    # module_items: List[ModuleItem] = list(module.get_module_items())
    # print("module items")
    # for item in module_items:
    #     print(item)
    # # print(module_items)

    # # item = pick(module_items)
    # # print(item)



@app.command()
def print_courses():
    for course in my_courses:
        print(f"{course.name} {course.id}")

if __name__ == "__main__":
    app()
