setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \ . '|setlocal tabstop< softtabstop< shiftwidth< expandtab<'
