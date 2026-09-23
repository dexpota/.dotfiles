let &undodir = $VIM_TEST_RUNTIME . '/undo//'
execute 'edit' fnameescape($VIM_TEST_DIRECTORY . '/sample.md')
silent undo
call assert_equal(['first line  ', 'second line' . "\t"], getline(1, '$'))
call assert_equal('', v:errmsg)
if !empty(v:errors)
  call writefile(v:errors, $VIM_TEST_DIRECTORY . '/errors')
  cquit
endif
call writefile(['passed'], $VIM_TEST_DIRECTORY . '/passed')
qa!
