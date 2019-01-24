" This command aligns all values of a configuration file into a single column
command! -buffer Format Tabularize /\v(^#.*)@<!((".*")\zs|(\S*>)\zs)
