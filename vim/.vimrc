" Terminal editing with Vim's native packages (Vim 8 or newer).
set nocompatible
set encoding=utf-8
set nomodeline
let mapleader = ' '

" Keep prose plugins deliberate: no automatic reflow while typing.
let g:pencil#wrapModeDefault = 'soft'
let g:pencil#autoformat = 0
let g:markdown_fenced_languages = ['rust=rust', 'latex=tex']

filetype plugin indent on
syntax enable
if !empty(globpath(&packpath, 'pack/*/start/*/colors/flattown.vim'))
  colorscheme flattown
endif

set number ruler showcmd
set colorcolumn=80
set incsearch hlsearch
set wildmode=longest,list,full
set backspace=indent,eol,start
set tabstop=4 shiftwidth=4
set foldmethod=indent foldlevel=99
set splitbelow splitright
set history=50
let &showbreak = '↳ '

" make vim creates these directories before linking the configuration.
set backup undofile
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//
set undodir=~/.vim/undo//

if has('mouse')
  set mouse=a
endif
if has('clipboard')
  if has('macunix')
    set clipboard=unnamed
  else
    set clipboard=unnamedplus
  endif
endif

" Whitespace is significant in some formats; trim only on request.
function! s:TrimWhitespace() abort
  let view = winsaveview()
  keeppatterns keepjumps %s/\s\+$//e
  call winrestview(view)
endfunction
command! TrimWhitespace call <SID>TrimWhitespace()

execute 'source' fnameescape(fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/.vim/mapping.vim')
