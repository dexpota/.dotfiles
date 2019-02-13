" This command aligns all values of a configuration file into a single column
command! -buffer Format Tabularize /\v(^#.*)@<!((".*")\zs|(\S*>)\zs)

" Undo the commands defined by this plugin when the buffer changes its
" filetype
let b:undo_ftplugin = ":delcommand Format"
