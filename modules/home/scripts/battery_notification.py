#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.11"
# dependencies = []
# ///

import subprocess
import sys
import time


def send_notification(title: str) -> None:
    """Send a notification using notify-send.

    Args:
        title: Notification title
    """
    try:
        subprocess.run(
            ["notify-send", title ],
            check=True,
            capture_output=True,
            text=True
        )
    except subprocess.CalledProcessError as e:
        print(f"Error sending notification: {e}", file=sys.stderr)
    except FileNotFoundError:
        print("Error: notify-send not found. Please install libnotify.", file=sys.stderr)
        sys.exit(1)

BRO_MODE = False

def dismiss_notification():
    global BRO_MODE
    try:
        subprocess.run(
            ["makoctl", "dismiss"],
            check=True,
            capture_output=True,
            text=True
        )
        BRO_MODE = not BRO_MODE
    except subprocess.CalledProcessError as e:
        print(f"Error toggling broo mode :(): {e}", file=sys.stderr)
    except FileNotFoundError:
        print("Error: makoctl not found. Please install mako.", file=sys.stderr)
        sys.exit(1)

def toggle_bro_mode() -> None:
    flag = '-a' if not BRO_MODE else '-r'
    try:
        subprocess.run(
            ["makoctl", "mode", flag, "brooo"],
            check=True,
            capture_output=True,
            text=True
        )
    except subprocess.CalledProcessError as e:
        print(f"Error toggling broo mode :(): {e}", file=sys.stderr)
    except FileNotFoundError:
        print("Error: makoctl not found. Please install mako.", file=sys.stderr)
        sys.exit(1)


def main():
    toggle_bro_mode()

    # List of messages to display with delay per message (message, delay_in_seconds)
    messages = [
        ("Brooo", 1.0),
        ("for", 0.2),
        ("the", 0.2),
        ("love", 0.2),
        ("of", 0.2),
        ("GOD", 1.0),
        ("Please...", 1.0),
        ("plug", 0.3),
        ("in", 0.3),
        ("your", 0.3),
        ("charger.", 1.0),
        ("I'm", 0.2),
        ("STARVING",1.0),
    ]

    # Iterate through messages and display them
    for i, (message, delay) in enumerate(messages):
        # print(f"[{i}/{len(messages)}] Sending: {message}")
        dismiss_notification()
        send_notification(message)

        # Delay after message (except after the last one)
        if i < len(messages) and delay > 0:
            time.sleep(delay)

    print("All notifications sent!")

    dismiss_notification()
    toggle_bro_mode()

if __name__ == "__main__":
    main()
