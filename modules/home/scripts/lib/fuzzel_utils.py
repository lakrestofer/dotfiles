import subprocess
import sys

def fuzzel(options, prompt=None, placeholder=None) -> str | None:
    """Display options in fuzzel and return the selected option.

    Args:
        options: List of strings to display in fuzzel
        prompt: Optional prompt to display
        placeholder: Optional placeholder text

    Returns:
        The selected option as a string, or None if canceled
    """
    if not options:
        return None

    # Build fuzzel command
    cmd = ['fuzzel', '--dmenu']
    if prompt:
        cmd.extend(['--prompt', prompt])
    if placeholder:
        cmd.extend(['--placeholder', placeholder])

    # Join options with newlines
    options_str = '\n'.join(str(opt) for opt in options)

    try:
        result = subprocess.run(
            cmd,
            input=options_str,
            text=True,
            capture_output=True,
            check=False
        )

        # Return the selected option (stripped of whitespace)
        # Return None if nothing was selected (user canceled)
        return result.stdout.strip() if result.returncode == 0 else None
    except FileNotFoundError:
        print("Error: fuzzel not found. Please install fuzzel.")
        sys.exit(1)

