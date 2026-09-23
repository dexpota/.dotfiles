setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
setlocal foldmethod=indent autoindent

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \ . '|setlocal tabstop< softtabstop< shiftwidth< expandtab< foldmethod< autoindent<'
