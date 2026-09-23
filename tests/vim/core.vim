set nomore
for [s:name, s:type] in [['sample.py', 'python'], ['sample.sh', 'sh'], ['sample.yaml', 'yaml'], ['sample.json', 'json'], ['sample.html', 'html'], ['sample.md', 'markdown'], ['sample.rb', 'ruby'], ['Jenkinsfile', 'groovy']]
  execute 'edit' fnameescape($VIM_TEST_DIRECTORY . '/' . s:name)
  call assert_equal(s:type, &filetype, s:name)
  if index(['markdown', 'groovy'], s:type) < 0
    call assert_notequal('', &indentexpr, s:name . ' has built-in indentation')
  endif
endfor

edit sample.yaml
call assert_equal('<C-W>j', maparg('<C-j>', 'n'))
call assert_equal('<C-W>k', maparg('<C-k>', 'n'))
edit sample.txt
call assert_equal('<C-W>j', maparg('<C-j>', 'n'))
call assert_equal('<C-W>k', maparg('<C-k>', 'n'))
call assert_equal('', maparg(' ', 'n'))
call assert_equal(':Explore<CR>', maparg(' d', 'n'))
call assert_equal('za', maparg(' z', 'n'))
call assert_equal(1, maparg('<C-j>', 'n', 0, 1).noremap)
call assert_equal('', maparg('<C-j>', 'x'))

edit sample.py
call setline(1, ['def greet():', 'print("hello")'])
normal! gg=G
call assert_equal('    print("hello")', getline(2))
call assert_equal('indent', &foldmethod)
call assert_equal('', maparg('.', 'i'))
call assert_equal('', maparg('<Tab>', 'i'))

enew!
setfiletype markdown
call assert_equal(0, &textwidth)
call assert_notmatch('[ta]', &formatoptions)
call assert_equal(2, &shiftwidth)
set filetype=text
call assert_equal(4, &shiftwidth, 'filetype overrides cleaned up')

" silent! cleanup in built-in filetype scripts can leave v:errmsg populated.
" Check emitted diagnostics; the Bats helper also checks Vim's exit status.
call assert_equal('', execute('silent messages'), 'no diagnostics')
if !empty(v:errors)
  call writefile(v:errors, $VIM_TEST_DIRECTORY . '/errors')
  cquit
endif
call writefile(['passed'], $VIM_TEST_DIRECTORY . '/passed')
qa!
