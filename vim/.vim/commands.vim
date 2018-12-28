augroup conf " {
	autocmd!
	autocmd Filetype conf :command Format Tabularize /\v(^#.*)@<!((".*")\zs|(\S*>)\zs)
augroup END " }

