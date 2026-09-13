# Provisioning inventory

The retained package inventory is in `tasks/packages.yml`, with explicit macOS
(Homebrew), Ubuntu, and Arch Linux branches. Ansible remains the provisioning
entry point for now; Make and GNU Stow own dotfile installation.

## Retained

- Shell/editor essentials: Git, Git LFS, Stow, Vim, Neovim, curl.
- Terminal utilities: sdcv, cmus, parallel, ranger, highlight, jq, unzip, Taskwarrior.
- Build dependencies: CMake, Python 3, Linux compiler/build packages.
- Linux filesystem watching: inotify-tools; existing Arch-only timew and cronie.
- User setup: LS_COLORS and Git LFS initialization.
- Existing Python CLI inventory: flake8, cheat, grip, pipenv, pipenv-pipes,
  virtualenvwrapper, coala-bears.
- Rust toolchain setup and Make-based YouCompleteMe compilation.

## Removed

- Mendeley, Calibre, Blender, GIMP, KiCad.
- Vagrant, VirtualBox, Syncthing, and their installation/repository tasks.
- JetBrains IDEs, Android Studio, Snap, and the IDE plugin installation helper.
- Jekyll, Bundler, and Ruby packages used by that setup.
- Graphical Linux utilities: gpick, zathura, feh, and the compton compositor.
- Neofetch and the old PPA inventory, including KiCad 4 and OpenJDK.
- Autofs tasks and example mounts; the unused sky2 suspend workaround.
- Python 2 packages and duplicate Vim/Pathogen/YouCompleteMe Ansible tasks.
- The standalone Blender compilation helper and Vagrant testing instructions.

These changes remove installation recipes, not installed software, repositories,
mounts, or configuration on any existing machine. Removed tracked files remain
recoverable from Git history. Existing Make and shell configuration are preserved.

## Remaining migration work

The `pip` and `rust` task files retain their legacy installers. An unfiltered
playbook run still includes them. They have not been validated on current macOS,
Ubuntu, or Arch: global pip installation can conflict with managed Python
environments, and the Rust task uses an old installer URL. Use the README's
`--tags packages,bash,git-lfs` commands for the pruned base setup while these
installers are reviewed. Retaining a tool here does not establish current package
availability or compatibility on every OS version.

Future replacement of Ansible should reuse this inventory. No package-manager
migration or automatic uninstallation is part of this pruning pass.
