" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Do not include vi compatibility.
" This must be first, because it changes other options as a side effect.
set nocompatible
" This option is set by default for Vim running in nocompatible mode, but some
" notable distributions of Vim disable this option in the system vimrc for
" security reason.
" Disable modeline
set nomodeline

" Pathogen infection
execute pathogen#infect()

" Display the unprintable characters.
" set list
" set listchars=tab:>-,trail:.,extends:#,nbsp:.

" Display line number.
set nu

" You can enable loading the plugin files for specific file types with
" this command. filetype detection will be switched on too.
filetype plugin on

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  set undofile		" keep an undo file (undo changes after closing)
endif
set history=50		" keep 50 lines of command line history
" Set backup and swap directory
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//

set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

colorscheme flattown

set tabstop=4
set shiftwidth=4

" Toggle NERDTree
map <leader>d :NERDTreeToggle<CR>

" Code folding
set foldmethod=indent
set foldlevel=99
" Use space to fold code instead of za
nnoremap <space> za
" Shows the docstrings for folded code
let g:SimpylFold_docstring_preview=1

