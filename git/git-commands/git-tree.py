#!/usr/bin/env python3
"""A compact, terminal-width-aware Git history viewer (standard library only)."""

import os
import re
import shutil
import subprocess
import sys
import unicodedata


ANSI = re.compile(r"\x1b\[[0-9;]*m")
RESET = "\x1b[0m"
# Font Awesome glyphs included in Nerd Fonts (use a Nerd Font Mono face).
ICONS = {"head": "\uf024", "branch": "\uf126", "remote": "\uf0c2", "tag": "\uf02b"}
LEFT_CAP, RIGHT_CAP = "\ue0b6", "\ue0b4"
HELP = """Usage: git tree [--icons] [--color=auto|always|never] [--width=N] [--no-pager] [git log arguments]

Show all branches with a colored graph, hashes beside the graph, and ref labels.
Examples: git tree -20; git tree --since='2 weeks ago'; git tree main -- README.md
History filters and revision/path arguments are passed to git log. Output-format
options (such as --pretty, --oneline, --stat, and -p) are not supported.
Color defaults to auto; NO_COLOR disables automatic color. COLUMNS sets width.
Interactive output uses Git's configured pager. Piped output is plain by default.
--icons adds Nerd Font ref icons and rounded colored labels.
--no-icons restores text-only labels. Rounded caps are omitted without color.
Select a Nerd Font Mono in your terminal for single-cell icon rendering.
Requires Python 3 and Git.
"""


def cell_width(char):
    if unicodedata.combining(char) or unicodedata.category(char) in ("Cf", "Cc"):
        return 0
    return 2 if unicodedata.east_asian_width(char) in ("W", "F") else 1


def width(value):
    return sum(cell_width(char) for char in ANSI.sub("", value))


def crop(value, limit):
    if width(value) <= limit:
        return value
    result = []
    used = 0
    for token in re.findall(r"\x1b\[[0-9;]*m|[^\x1b]", value):
        if ANSI.fullmatch(token):
            result.append(token)
        elif used + cell_width(token) <= max(0, limit - 1):
            result.append(token)
            used += cell_width(token)
        else:
            break
    return "".join(result) + "…"


def clean(value):
    return "".join(char if unicodedata.category(char) != "Cc" else " " for char in value)


def paint(value, color, enabled):
    return f"\x1b[{color}m{value}{RESET}" if enabled else value


def labels(refs, color, icons=False):
    def badge(name, style, kind):
        prefix = ICONS[kind] + " " if icons and kind in ICONS else ""
        body = paint(f" {prefix}{clean(name)} ", style, color)
        if icons and color:
            # Paint the caps with the badge background as their foreground.
            cap_style = "38;5;" + style.split(";")[2]
            return paint(LEFT_CAP, cap_style, True) + body + paint(RIGHT_CAP, cap_style, True)
        return body

    result = []
    for ref in refs.split(", ") if refs else []:
        if ref.startswith("HEAD -> "):
            result.append(badge("HEAD", "48;5;211;38;5;235", "head"))
            ref = ref[8:]
        if ref == "HEAD":
            name, style, kind = ref, "48;5;211;38;5;235", "head"
        elif ref.startswith("tag: refs/tags/"):
            name, style, kind = ref[15:], "48;5;216;38;5;235", "tag"
        elif ref.startswith("refs/heads/"):
            name, style, kind = ref[11:], "48;5;150;38;5;235", "branch"
        elif ref.startswith("refs/remotes/"):
            name, style, kind = ref[13:], "48;5;111;38;5;235", "remote"
        else:
            name, style, kind = ref, "48;5;111;38;5;235", None
        result.append(badge(name, style, kind))
    return " ".join(result)


def main():
    columns = shutil.get_terminal_size((100, 24)).columns
    mode = "auto"
    icons = False
    use_pager = sys.stdout.isatty()
    arguments = []
    paths = []
    iterator = iter(sys.argv[1:])
    for arg in iterator:
        if arg == "--":
            paths = [arg, *iterator]
            break
        if arg in ("--help", "-h"):
            print(HELP, end="")
            return 0
        if arg == "--no-pager":
            use_pager = False
        elif arg in ("--icons", "--no-icons"):
            icons = arg == "--icons"
        elif arg == "--no-color":
            mode = "never"
        elif arg == "--color" or arg.startswith("--color="):
            mode = arg.partition("=")[2] or "always"
        elif arg.startswith("--width="):
            try:
                columns = int(arg.partition("=")[2])
            except ValueError:
                columns = 0
            if columns < 20:
                print("git tree: --width must be an integer of at least 20", file=sys.stderr)
                return 2
        elif arg.split("=")[0] in (
            "--pretty", "--format", "--oneline", "--stat", "--numstat",
            "--shortstat", "--raw", "--patch", "--patch-with-stat",
            "--patch-with-raw", "--name-only", "--name-status", "--check",
            "--summary", "--no-walk", "--walk-reflogs", "--graph", "-g", "-p", "-z",
        ):
            print(f"git tree: unsupported output option: {arg}", file=sys.stderr)
            return 2
        else:
            arguments.append(arg)
    if mode not in ("auto", "always", "never"):
        print("git tree: color must be auto, always, or never", file=sys.stderr)
        return 2
    color = mode == "always" or (mode == "auto" and sys.stdout.isatty() and "NO_COLOR" not in os.environ)
    command = [
        "git", "--no-pager", "log", "--all", "--full-history", *arguments,
        "--graph", "--no-patch", "--decorate=full",
        "--color=" + ("always" if color else "never"),
        "--format=%x1f%h%x1f%D%x1f%s", *paths,
    ]
    process = subprocess.Popen(command, stdout=subprocess.PIPE, text=True, errors="replace")
    pager = None
    output = sys.stdout
    if use_pager:
        setting = subprocess.run(["git", "var", "GIT_PAGER"], capture_output=True, text=True)
        pager_command = setting.stdout.strip() if setting.returncode == 0 else ""
        if pager_command and pager_command != "cat":
            env = dict(os.environ)
            env.setdefault("LESS", "FRX")
            if icons:
                # less needs ascending code points to recognize every entry.
                env.setdefault("LESSUTFCHARDEF", ",".join(
                    f"{ord(glyph):x}:p" for glyph in sorted([*ICONS.values(), LEFT_CAP, RIGHT_CAP])
                ))
            pager = subprocess.Popen(pager_command, shell=True, stdin=subprocess.PIPE, text=True, env=env)
            output = pager.stdin
    try:
        for line in process.stdout:
            fields = line.rstrip("\n").split("\x1f", 3)
            if len(fields) != 4:
                print(crop(line.rstrip("\n").replace("|", "│"), columns) + (RESET if color else ""), file=output)
                continue
            graph, commit, refs, subject = fields
            graph = graph.replace("*", "•").replace("|", "│")
            badges = labels(refs, color, icons)
            commit = ANSI.sub("", commit)
            row = graph + paint(commit, "38;5;222", color) + " "
            row += (badges + " " if badges else "") + clean(subject)
            print(crop(row, columns) + (RESET if color else ""), file=output)
    except BrokenPipeError:
        process.terminate()
    finally:
        process.stdout.close()
        status = process.wait()
        if pager:
            try:
                output.close()
            except BrokenPipeError:
                pass
            pager.wait()
    return status if status >= 0 else 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(130)
