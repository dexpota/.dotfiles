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

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" Copy & paste with right click
set clipboard=unnamed
" In paste mode the text is pasted without modify the indentation
set pastetoggle=<F2>

" Rebind <Leader> key
" set mapleader="'"

" Pathogen infection
execute pathogen#infect()

" Display the unprintable characters.
" set list
" set listchars=tab:>-,trail:.,extends:#,nbsp:.

" Display line number.
set nu
" Highlight column 80
set colorcolumn=80

" You can enable loading the plugin files for specific file types with
" this command. filetype detection will be switched on too.
filetype plugin on

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup      " do not keep a backup file, use versions instead
else
  set backup        " keep a backup file (restore to previous version)
  set undofile      " keep an undo file (undo changes after closing)
endif
set history=50      " keep 50 lines of command line history
" Set backup, swap and undo directory
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//
set undodir=~/.vim/undo//

set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set incsearch       " do incremental searching

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

" Markdown preview for github files
let vim_markdown_preview_github=1
let vim_markdown_preview_toggle=1

let g:markdown_fenced_languages = ['rust=rust', 'latex=tex']


" Disable bracketed paste,
" This solve an issue with vim and terminator
" see @https://unix.stackexchange.com/a/400717
set t_BE=

source ~/.vim/mapping.vim

" vim hardcodes background color erase even if the terminfo file does
" not contain bce (not to mention that libvte based terminals
" incorrectly contain bce in their terminfo files). This causes
" incorrect background rendering when using a color theme with a
" background color.
let &t_ut=''

let &showbreak='↳ '

if has("clipboard")
  set clipboard=unnamedplus
endif

""Automatically deletes all trailing whitespace on save.
autocmd BufWritePre * %s/\s\+$//e
