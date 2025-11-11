#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = [ "canvasapi" ]
# ///
import os
import sys
from canvasapi import Canvas
from canvasapi.user import User

ME=161979

API_URL = os.environ["CANVAS_API_URL"] 
API_KEY = os.environ["CANVAS_API_KEY"]

if (API_KEY is None or API_URL is None):
    print("CANVAS_API_URL or CANVAS_API_KEY was None")
    sys.exit(1)

api = Canvas(API_URL, API_KEY)

me: User = api.get_user(ME);

my_courses = me.get_courses(enrollment_state='active');

for course in my_courses:
    print(course)

