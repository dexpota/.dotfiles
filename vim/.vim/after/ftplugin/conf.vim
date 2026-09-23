" Explicitly align configuration values with Tabular.
if exists(':Tabularize') == 2
  command! -buffer Format Tabularize /\v(^#.*)@<!((".*")\zs|(\S*>)\zs)
  let b:undo_ftplugin = get(b:, 'undo_ftplugin', '') . '|silent! delcommand -buffer Format'
endif
