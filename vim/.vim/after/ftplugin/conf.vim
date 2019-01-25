" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" This command aligns all values of a configuration file into a single column
command! -buffer Format Tabularize /\v(^#.*)@<!((".*")\zs|(\S*>)\zs)

" Undo the commands defined by this plugin when the buffer changes its
" filetype
let b:undo_ftplugin = ":delcommand Format"
