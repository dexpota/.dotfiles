" Tab navigation.
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>

" Keep the selection after indenting in Visual mode.
xnoremap < <gv
xnoremap > >gv

" Directory browsing and folds use Vim's built-in commands.
nnoremap <leader>d :Explore<CR>
nnoremap <leader>z za

" Explicit formatting; no automatic reflow on save.
nnoremap Q gq
xnoremap Q gq

" Break undo before deleting an Insert-mode line.
inoremap <C-U> <C-G>u<C-U>

" Split navigation is global and independent of the current filetype.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
