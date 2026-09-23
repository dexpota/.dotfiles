setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
" Preserve physical lines unless formatting is explicitly requested with gq.
setlocal textwidth=0
setlocal formatoptions-=t formatoptions-=a

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \ . '|setlocal tabstop< softtabstop< shiftwidth< expandtab< textwidth< formatoptions<'
if exists(':Goyo') == 2
  nnoremap <buffer> <leader>f :Goyo<CR>
  let b:undo_ftplugin .= '|silent! nunmap <buffer> <leader>f'
endif
