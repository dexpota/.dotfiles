# Vim cleanup plan

## Goal

Keep Vim a fast, terminal-first editor. The configuration should improve text
editing, navigation, and writing without recreating an IDE through language
servers, project panes, continuous diagnostics, or automatic formatting.

## Baseline before cleanup

The setup uses Pathogen and 21 plugin submodules under `vim/.vim/bundle/`.
Most of their pinned revisions date from 2015--2019. The configuration itself
is relatively small, but it activates a broad IDE-oriented plugin layer:

- Completion and language tooling: YouCompleteMe, python-mode, syntastic,
  vim-flake8, SimpylFold, and vim-autoformat.
- Project-style UI: NERDTree and vim-nerdtree-tabs.
- Navigation and UI: CtrlP and vim-airline.

Vim 9.2 can open an ordinary file with the configuration, but startup produces
these non-fatal diagnostics:

- CtrlP cannot write `~/.cache/ctrlp/mru/cache.txt`.
- vim-airline looks for a `flattown` theme that is not present.

There are also configuration issues independent of the plugin set:

- Space is both the map leader and a normal-mode fold toggle. This makes every
  Space-led mapping ambiguous and subject to `timeoutlen`.
- `<leader>d` is defined twice, in `.vimrc` and `mapping.vim`.
- Several user mappings use recursive `map` instead of mode-specific,
  non-recursive mappings.
- `after/ftplugin/yaml.vim` globally maps `<C-j>` and `<C-k>` to vim-indentwise
  commands, overriding split navigation even after switching to another buffer.
  Removing vim-indentwise without cleaning up these mappings leaves dead keys.
- Trailing whitespace is removed from every buffer on every save, which can
  alter meaningful Markdown line breaks and other formats.
- Filetype plugins are enabled but built-in filetype indentation is not.
- Clipboard configuration is repeated, and terminal compatibility settings are
  legacy workarounds that should be justified by a reproducible issue.

## Desired steady state

Prefer Vim's built-in capabilities first:

- buffers, `:find`, `:oldfiles`, `:grep`, quickfix, and `:Ex` for navigation;
- built-in filetype detection, indentation, syntax, folds, persistent undo,
  splits, registers, and the clipboard;
- small filetype-specific settings in `after/ftplugin`;
- a short native `statusline` only if the default is insufficient.

Retain third-party plugins only when they provide a focused editing or writing
operation that is used regularly. Likely candidates are `vim-surround`,
`tabular`, `goyo`, `vim-pencil`, and optionally `vim-markdown` or
`NERDCommenter`.

## Cleanup sequence

1. Capture the current behavior before deleting anything: list the mappings
   that are actually used, note desired prose/Markdown behavior, and test
   common file types (Python, shell, YAML, JSON, HTML, Markdown, Ruby, and
   Jenkinsfile). Record Python indentation, folding, completion, and save
   behavior explicitly, since Python is most affected by the plugin removals.
2. Remove the IDE layer as one coherent change: YouCompleteMe, python-mode,
   syntastic, vim-flake8, SimpylFold, and vim-autoformat. Remove their
   submodules through Git rather than editing third-party plugin contents.
   In the same change, remove the Makefile's `ycm` target and the `vim` target's
   dependency on it: otherwise `make vim` will still enter the removed
   YouCompleteMe directory and run `install.py`, breaking installation. Update
   the README's Vim build requirements and the YouCompleteMe compilation entry
   in `docs/provisioning.md`.
3. Remove NERDTree and vim-nerdtree-tabs unless a tree sidebar is a consciously
   preferred workflow. Use `:Ex` when a lightweight directory browser is
   needed.
4. Remove vim-airline and CtrlP unless each has a demonstrated daily use. This
   also eliminates the observed Airline theme lookup and CtrlP cache-write
   errors.
5. Decide explicitly whether auto-pairs and vim-indentwise improve editing.
   They are conveniences, not essential parts of a minimal setup.
   Audit `after/ftplugin` for mappings and commands that depend on every plugin
   selected for removal. Remove or replace the YAML indentation mappings if
   vim-indentwise is removed; if retained, make those mappings buffer-local.
6. Simplify `.vimrc`: use `filetype plugin indent on`; reserve Space for the
   leader; consolidate mappings in `mapping.vim`; use `nnoremap`/`xnoremap`;
   place autocommands in named augroups; and make whitespace trimming opt-in or
   filetype-scoped.
7. Keep formatting and linting outside Vim. Run project formatters, linters,
   test suites, and `shellcheck` deliberately from the terminal or project
   commands, rather than at edit/save time.
8. Validate with a clean Vim launch and representative files. Confirm there
   are no messages, unwanted automatic edits, missing commands, or ambiguous
   mappings. Compare Python indentation, folding, completion, and save behavior
   with the baseline and confirm any differences are intentional. Open YAML,
   then switch to another filetype and verify `<C-j>`/`<C-k>` still navigate
   splits there. Run `make -n vim` to confirm installation no longer invokes
   YouCompleteMe compilation. Update repository setup documentation if the
   plugin inventory or required directories change.

## Boundaries

Do not upgrade old plugins as a first step: the goal is to reduce the surface
area, not modernize an IDE configuration. Do not edit plugin checkout contents;
they are Git submodules and should be added or removed by changing submodule
references. Preserve existing local work, including the modified SimpylFold and
YouCompleteMe submodules and the untracked `after/ftdetect` files, until their
owner decides how to incorporate them.

## Implementation

Implemented on `vim-cleanup-plan` with five retained packages: `vim-surround`,
`tabular`, `goyo`, `vim-pencil`, and `colorschemes` to preserve `flattown`.
The other 16 plugin registrations are removed, including auto-pairs,
vim-indentwise, the optional Markdown/commenting plugins, Kotlin syntax, and
the browser preview plugin. Vim's native filetypes provide the baseline.

The retained packages moved to `vim/.vim/pack/plugins/start/` without changing
their pinned revisions. Native package loading replaces Pathogen, so legacy
checkouts can remain under the ignored `bundle/` directory without loading.
All retired checkouts and local changes are preserved on disk, including the
modified SimpylFold and YouCompleteMe repositories. The existing local change
in `colorschemes/colors/darkblue.vim` moved with its retained checkout. The
untracked `after/ftdetect` files are untouched and remain outside this change.

`make vim` initializes only the retained Vim packages, creates state directories,
and restows Vim. It no longer pulls the main repository, compiles YouCompleteMe,
or downloads Pathogen. See the README for the required restart and relinking
steps for existing installations.

Mappings are mode-specific, Space is reserved for the leader, directory browsing
uses `:Explore`, and the YAML mappings no longer override global split movement.
Filetype overrides preserve Vim's existing cleanup hooks. The automatic vimrc
reload and whitespace autocmds are removed; trimming is explicit through
`:TrimWhitespace`. Built-in indentation is enabled. Pencil defaults to soft
wrapping with automatic reformatting disabled. External linting stays in the
terminal, including shellcheck.

The baseline check on Vim 9.2 also found a Python startup failure from an old
plugin importing the removed Python `imp` module. Python now uses built-in
indentation, indent folds, and manual completion. Regression checks in
`tests/vim` cover filetypes, cross-buffer mappings, explicit formatting,
unchanged saves, persistent undo, and the retained packages.

Validation on macOS:

- All 39 Bats tests pass, including all four Vim tests with the retained
  packages initialized, using Homebrew Vim 9.2.
- The four Vim tests also pass with macOS's bundled Vim 9.1.
- `make -n vim` confirms only native package initialization, state directory
  creation, and Stow linking. A Stow simulation reports no migration conflicts.
- Changed files pass trailing-whitespace, final-newline, and Git whitespace
  checks; the Makefile hook passes.
- The repository-wide pre-commit run remains blocked by pre-existing whitespace
  and shell-extension violations and a legacy shebang hook importing `pipes`,
  which is unavailable on Python 3.14. Its unrelated automatic edits were
  reverted. Linux execution and interactive terminal behavior still need a
  check on those environments; CI installs Vim for the core regression suite.
