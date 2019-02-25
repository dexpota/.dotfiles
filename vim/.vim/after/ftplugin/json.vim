" number of columns for each tab
setlocal tabstop=2
" number of columns when you type tab or autoindent
setlocal softtabstop=2
setlocal shiftwidth=2
" expand tab to spaces
setlocal expandtab

" Undo the commands defined by this plugin when the buffer changes its
" filetype
let b:undo_ftplugin = "
\ let &l:tabstop = &g:tabstop |
\ let &l:softtabstop = &g:softtabstop |
\ let &l:shiftwidth = &g:shiftwidth |
\ let &l:expandtab = &g:expandtab
\"
