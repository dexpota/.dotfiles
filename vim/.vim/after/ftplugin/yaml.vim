" number of columns for each tab
setlocal tabstop=2
" number of columns when you type tab or autoindent
setlocal softtabstop=2
setlocal shiftwidth=2
" expand tab to spaces
setlocal expandtab

" fold on indentation
setlocal foldmethod=indent

" keep indentation when formatting with gq
setlocal autoindent

" navigation based on indentation
" TODO check vim-indentwise is enabled
map <C-k> <Plug>(IndentWisePreviousEqualIndent)
map <C-j> <Plug>(IndentWiseNextEqualIndent)

" Undo the commands defined by this plugin when the buffer changes its
" filetype
let b:undo_ftplugin = "
\ let &l:tabstop = &g:tabstop |
\ let &l:softtabstop = &g:softtabstop |
\ let &l:shiftwidth = &g:shiftwidth |
\ let &l:expandtab = &g:expandtab |
\ let &l:foldmethod = &g:foldmethod |
\ let &l:autoindent = &g:autoindent
\"
