"
" Global settings
"

let $BASH_ENV="~/.bash_aliases" " Make sure aliases are imported, as .bashrc is not run

set tabstop=4
set shiftwidth=4
set smartindent
set autoindent
" set cindent
set number
set showmatch
filetype plugin on " NERDCommenter needs this on

" Shortcuts

" Ctrl+S: Save
nnoremap <C-s> :w<CR>
inoremap <C-S> <Esc>:w<CR>i
" Ctrl+Q: Quit
nnoremap <C-q> :qa<CR>
nnoremap <C-S-q> :qa!<CR>
" Ctrl+Z: Undo
nnoremap <C-z> u
inoremap <C-z> <Esc>ui
" Ctrl+Y: Redo
nnoremap <C-y> <C-r>
inoremap <C-y> <Esc><C-r>i

"
" Settings for Youcompleteme
"

" let g:loaded_matchparen=1 " Prevent flickering cursor after typing parentheses

"
" Settings for NERDTree
"

" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p

"
" Settings for NERDCommenter
" 

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" If there is an uncommented line within selection, then comment all lines
let g:NERDToggleCheckAllLines = 1

" Toggle comments with Ctrl+/. Have to put <C-_> here due to Vim's quirk
nnoremap <C-_> :call nerdcommenter#Comment('n', 'toggle')<CR>
vnoremap <C-_> :call nerdcommenter#Comment('v', 'toggle')<CR>
