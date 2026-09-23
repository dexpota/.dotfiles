set nomore
let &backupdir = $VIM_TEST_RUNTIME . '/backup//'
let &directory = $VIM_TEST_RUNTIME . '/swp//'
let &undodir = $VIM_TEST_RUNTIME . '/undo//'
for s:name in ['sample.py', 'sample.md', 'sample.yaml']
  let s:path = $VIM_TEST_DIRECTORY . '/' . s:name
  call writefile(['first line  ', 'second line' . "\t"], s:path)
  execute 'edit' fnameescape(s:path)
  silent write
  call assert_equal(['first line  ', 'second line' . "\t"], readfile(s:path), s:name . ' save')
endfor
execute 'edit' fnameescape($VIM_TEST_DIRECTORY . '/sample.md')
call cursor(2, 3)
let @/ = 'previous search'
TrimWhitespace
call assert_equal(['first line', 'second line'], getline(1, '$'))
call assert_equal('previous search', @/)
call assert_equal([2, 3], [line('.'), col('.')])
silent write
call assert_true(filereadable(undofile(expand('%:p'))), 'undo file persisted')
call assert_equal('', v:errmsg)
if !empty(v:errors)
  call writefile(v:errors, $VIM_TEST_DIRECTORY . '/errors')
  cquit
endif
call writefile(['passed'], $VIM_TEST_DIRECTORY . '/passed')
qa!
