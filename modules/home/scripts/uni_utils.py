#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#   "canvasapi==3.4.0",
#   "typer==0.21.1"
# ]
# ///
from canvasapi.module import Module
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

# cache
CACHE_DIR = (Path("~/.cache").expanduser() / APP_NAME)
COURSES_CACHE_PATH = CACHE_DIR / "courses.json"

# courses root directory
COURSES_ROOT = Path("~/vault/uni").expanduser()
GLOBAL_COURSES_MAP_PATH = COURSES_ROOT / "courses.json"

if (API_KEY is None or API_URL is None):
    print("CANVAS_API_URL or CANVAS_API_KEY was None")
    sys.exit(1)

if (not CACHE_DIR.exists()):
    CACHE_DIR.mkdir(parents=True, exist_ok=True)


# global instances
api = Canvas(API_URL, API_KEY)
app = typer.Typer()
me: User = api.get_user(ME)

# some data that we read from cache or fetch

# my_courses = me.get_courses(enrollment_state='active')
my_courses: List[MyCourse] = []

# cache utilities
def save_courses_to_cache(courses: List[MyCourse], path: Path):
    """Save courses to cache file as JSON."""
    courses_data = [asdict(course) for course in courses]
    with path.open('w') as f:
        json.dump(courses_data, f, indent=2)

def load_courses_from_cache(path: Path) -> List[MyCourse]:
    """Load courses from cache file."""
    with path.open('r') as f:
        courses_data = json.load(f)

    return [MyCourse(**course_data) for course_data in courses_data]

def load_global_courses_map(path: Path) -> dict:
    """Load the global courses mapping from courses.json."""
    if not path.exists():
        return {}
    with path.open('r') as f:
        return json.load(f)

def save_global_courses_map(courses_map: dict, path: Path):
    """Save the global courses mapping to courses.json."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open('w') as f:
        json.dump(courses_map, f, indent=2)

def load_sync_metadata(path: Path) -> dict:
    """Load sync metadata from .canvas_sync.json."""
    if not path.exists():
        return {"course_id": None, "last_sync": None, "modules": {}}
    with path.open('r') as f:
        return json.load(f)

def save_sync_metadata(metadata: dict, path: Path):
    """Save sync metadata to .canvas_sync.json."""
    with path.open('w') as f:
        json.dump(metadata, f, indent=2)

if COURSES_CACHE_PATH.exists():
    # Load from cache
    my_courses = load_courses_from_cache(COURSES_CACHE_PATH)
else:
    # Fetch from API and cache
    canvas_courses = list(me.get_courses())
    my_courses = [MyCourse(id=course.id, name=course.name) for course in canvas_courses]
    save_courses_to_cache(my_courses, COURSES_CACHE_PATH)

courses_map = {course.name : course for course in my_courses}

def sanitize_module_name(name: str) -> str:
    """Convert module name to lowercase with spaces replaced by hyphens."""
    return name.lower().replace(' ', '-')

def pick_course():
    """pick a course from the list of courses"""
    course_names = [c.name for c in my_courses]
    choice = fuzzel(course_names)
    if (choice is None):
        return None
    course = courses_map[choice]
    return course

# app commands

@app.command()
def clear_cache():
    """clear the cache of this script"""
    if COURSES_CACHE_PATH.exists():
        COURSES_CACHE_PATH.unlink(missing_ok=True)
        print(f"Cache cleared: {COURSES_CACHE_PATH}")
    else:
        print("No cache to clear")

@app.command()
def course_info():
    course = pick_course()
    print(course)

@app.command()
def init_course(path: str):
    """given the supplied path (resolved from the cwd), prompt the user for a
       course, and create a course.json"""
    # Pick a course
    course = pick_course()
    if course is None:
        print("No course selected")
        return

    # Resolve the path
    course_dir = Path(path).resolve()
    course_dir.mkdir(parents=True, exist_ok=True)

    # Create course.json in the directory
    course_json_path = course_dir / "course.json"
    course_data = {
        "id": course.id,
        "name": course.name
    }
    with course_json_path.open('w') as f:
        json.dump(course_data, f, indent=2)

    print(f"Created {course_json_path}")

    # Update global courses.json
    global_map = load_global_courses_map(GLOBAL_COURSES_MAP_PATH)
    global_map[str(course.id)] = str(course_dir)
    save_global_courses_map(global_map, GLOBAL_COURSES_MAP_PATH)

    print(f"Updated {GLOBAL_COURSES_MAP_PATH}")
    print(f"Course '{course.name}' initialized at {course_dir}")

@app.command()
def print_courses():
    for course in my_courses:
        print(f"{course.name} {course.id}")

@app.command()
def sync():
    """Sync course content from Canvas to the local directory.
       Detects course from course.json in the current directory."""
    # Look for course.json in current directory
    cwd = Path.cwd()
    course_json_path = cwd / "course.json"

    if not course_json_path.exists():
        print(f"Error: No course.json found in {cwd}")
        print("Run 'init_course' first to initialize a course directory")
        return

    # Load course info
    with course_json_path.open('r') as f:
        course_data = json.load(f)

    course_id = course_data['id']
    print(f"Syncing course: {course_data['name']} (ID: {course_id})")

    # Get the course from Canvas API
    course = api.get_course(course_id)

    # Load sync metadata
    sync_metadata_path = cwd / ".canvas_sync.json"
    metadata = load_sync_metadata(sync_metadata_path)
    metadata['course_id'] = course_id

    # Get all modules
    modules: List[Module] = list(course.get_modules())

    for module in modules:
        module_name = sanitize_module_name(module.name)
        module_dir = cwd / module_name
        module_dir.mkdir(exist_ok=True)

        print(f"\nProcessing module: {module.name}")

        # Check if module needs updating
        module_updated_at = getattr(module, 'updated_at', None)
        module_id = str(module.id)

        if module_id not in metadata['modules']:
            metadata['modules'][module_id] = {
                'name': module.name,
                'updated_at': module_updated_at,
                'items': {}
            }

        # Get module items
        try:
            items = module.get_module_items()
            for item in items:
                item_id = str(item.id)
                item_updated_at = getattr(item, 'updated_at', None)

                # Check if item is a file and needs downloading
                if item.type == 'File':
                    # Get the file object
                    file_obj = course.get_file(item.content_id)
                    filename = file_obj.filename
                    file_path = module_dir / filename

                    # Check if we need to download
                    should_download = False
                    if item_id not in metadata['modules'][module_id]['items']:
                        should_download = True
                    elif item_updated_at and metadata['modules'][module_id]['items'][item_id].get('updated_at') != item_updated_at:
                        should_download = True

                    if should_download:
                        print(f"  Downloading: {filename}")
                        # Download using canvasapi
                        file_obj.download(file_path)

                        # Update metadata
                        metadata['modules'][module_id]['items'][item_id] = {
                            'title': item.title,
                            'updated_at': item_updated_at,
                            'file_path': str(file_path.relative_to(cwd))
                        }
                    else:
                        print(f"  Skipping (up to date): {filename}")

        except Exception as e:
            print(f"  Error processing module items: {e}")

    # Update last sync time
    metadata['last_sync'] = datetime.now().isoformat()
    save_sync_metadata(metadata, sync_metadata_path)

    print(f"\nSync complete! Metadata saved to {sync_metadata_path}")


if __name__ == "__main__":
    app()
