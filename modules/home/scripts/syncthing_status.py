#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#   "requests>=2.31.0",
# ]
# ///
"""Syncthing status monitor for Waybar custom module."""

import json
import os
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

import requests

BASE_URL = "http://localhost:8384"
TIMEOUT = 5
ICON = "󰴋"

def get_api_key() -> str | None:
    key = os.environ.get("SYNCTHING_API_KEY")
    if key:
        return key

    config_path = Path.home() / ".config" / "syncthing" / "config.xml"
    if not config_path.exists():
        return None

    try:
        tree = ET.parse(config_path)
        gui = tree.find(".//gui")
        if gui is not None:
            apikey = gui.find("apikey")
            if apikey is not None and apikey.text:
                return apikey.text.strip()
    except ET.ParseError:
        pass

    return None


def api_get(session: requests.Session, endpoint: str, **params) -> dict | list | None:
    try:
        resp = session.get(f"{BASE_URL}{endpoint}", params=params, timeout=TIMEOUT)
        resp.raise_for_status()
        return resp.json()
    except (requests.RequestException, ValueError):
        return None


def format_bytes(b: int) -> str:
    for unit in ("B", "KiB", "MiB", "GiB", "TiB"):
        if abs(b) < 1024:
            return f"{b:.1f} {unit}" if unit != "B" else f"{b} {unit}"
        b = int(b / 1024)
    return f"{b:.1f} PiB"


def output(text: str, alt: str, css_class: str, tooltip: str = "", percentage: int = 0):
    print(
        json.dumps(
            {
                "text": text,
                "alt": alt,
                "class": css_class,
                "tooltip": tooltip,
                "percentage": percentage,
            }
        )
    )


def main():
    api_key = get_api_key()
    if not api_key:
        output(f"{ICON} ?", "no-api-key", "error", tooltip="API key not found")
        return

    session = requests.Session()
    session.headers["X-API-Key"] = api_key

    # Fetch top-level data
    folders = api_get(session, "/rest/config/folders")
    devices = api_get(session, "/rest/config/devices")
    connections = api_get(session, "/rest/system/connections")
    completion = api_get(session, "/rest/db/completion")

    if folders is None:
        output(ICON, "offline", "offline", tooltip="Syncthing unreachable")
        return

    # Build device name map
    device_names: dict[str, str] = {}
    if devices:
        for d in devices:
            device_names[d["deviceID"]] = d.get("name") or d["deviceID"][:8]

    # Overall completion percentage
    overall_pct = 100
    if isinstance(completion, dict) and "completion" in completion:
        overall_pct = int(completion["completion"])

    # Per-folder status
    total_errors = 0
    any_syncing = False
    folder_lines: list[str] = []

    for f in folders:
        fid = f["folderID"] if "folderID" in f else f.get("id", "unknown")
        label = f.get("label") or fid

        status = api_get(session, "/rest/db/status", folder=fid)
        if not isinstance(status, dict):
            folder_lines.append(f"  {label}: unavailable")
            continue

        state = status.get("state", "unknown")
        need_files = status.get("needFiles", 0)
        need_bytes = status.get("needBytes", 0)
        pull_errors = status.get("pullErrors", 0)

        total_errors += pull_errors

        if state not in ("idle",):
            any_syncing = True

        line = f"  {label}: {state}"
        if need_files > 0:
            line += f" ({need_files} files, {format_bytes(need_bytes)})"
        if pull_errors > 0:
            line += f" [{pull_errors} errors]"
        folder_lines.append(line)

    # Device connection lines
    device_lines: list[str] = []
    if isinstance(connections, dict) and "connections" in connections:
        for dev_id, info in connections["connections"].items():
            name = device_names.get(dev_id, dev_id[:8])
            connected = info.get("connected", False)
            status_str = "connected" if connected else "disconnected"
            device_lines.append(f"  {name}: {status_str}")

    # Determine state
    if total_errors > 0:
        state = "error"
        text = f"{ICON} !"
    elif any_syncing or overall_pct < 100:
        state = "syncing"
        text = f"{ICON} {overall_pct}%"
    else:
        state = "synced"
        text = ICON

    # Build tooltip
    tooltip_parts = [f"Syncthing: {state}"]
    if folder_lines:
        tooltip_parts.append(f"\nFolders:")
        tooltip_parts.extend(folder_lines)
    if device_lines:
        tooltip_parts.append(f"\nDevices:")
        tooltip_parts.extend(device_lines)

    tooltip = "\n".join(tooltip_parts)

    output(text, state, state, tooltip=tooltip, percentage=overall_pct)


if __name__ == "__main__":
    try:
        main()
    except Exception:
        output(ICON, "offline", "offline", tooltip="Unexpected error")
        sys.exit(0)
