call assert_equal('', v:errmsg, 'package startup')
call assert_equal('flattown', get(g:, 'colors_name', ''))
for s:command in ['Goyo', 'Tabularize', 'Pencil', 'Explore']
  call assert_equal(2, exists(':' . s:command), s:command)
endfor
for s:command in ['YcmCompleter', 'NERDTreeToggle', 'CtrlP', 'SyntasticCheck', 'Autoformat']
  call assert_equal(0, exists(':' . s:command), s:command . ' removed')
endfor
call assert_notmatch('/bundle/', &runtimepath)
call assert_equal(0, exists('g:loaded_pathogen'))

call setline(1, 'hello')
execute "normal ysiw)"
call assert_equal('(hello)', getline(1), 'Surround')
call setline(1, ['a=1', 'long=2'])
Tabularize /=
call assert_equal(['a    = 1', 'long = 2'], getline(1, '$'))

enew!
setfiletype markdown
call assert_equal(':Goyo<CR>', maparg(' f', 'n'))
Pencil
call assert_equal(0, g:pencil#autoformat)
call assert_equal('soft', g:pencil#wrapModeDefault)
call assert_notmatch('a', &formatoptions)
NoPencil
set filetype=text
call assert_equal('', maparg(' f', 'n'), 'Markdown mapping cleaned up')
set filetype=conf
call assert_equal(2, exists(':Format'))
set filetype=text
call assert_equal(0, exists(':Format'), 'conf command cleaned up')
" These old plugins silently probe optional APIs (such as repeat#set).
" Check emitted diagnostics as well as command behavior above.
call assert_equal('', execute('silent messages'))
if !empty(v:errors)
  call writefile(v:errors, $VIM_TEST_DIRECTORY . '/errors')
  cquit
endif
call writefile(['passed'], $VIM_TEST_DIRECTORY . '/passed')
qa!
