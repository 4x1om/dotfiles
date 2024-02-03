"
" Global settings
"

let $BASH_ENV="~/.bash_aliases" " Make sure aliases are imported, as .bashrc is not run

set tabstop=4
set shiftwidth=4
set autoindent

" Stop vim or NERDCommenter (not sure which) from incorrectly indenting Python
" See https://unix.stackexchange.com/questions/106526/stop-vim-from-messing-up-my-indentation-on-comments
set cindent
set cinkeys-=0#
set indentkeys-=0#

set number " Line numbers
" set showmatch " Jump back and forth when entering closing bracket

filetype plugin on " NERDCommenter needs this on

" Shortcuts

" Shift+HJKL -> HJKL but faster
nnoremap H 4h
nnoremap J 4j
nnoremap K 4k
nnoremap L 4l

vnoremap H 4h
vnoremap J 4j
vnoremap K 4k
vnoremap L 4l

" Indenting
vnoremap <Tab> >
vnoremap <S-Tab> <

" Ctrl+HJKL -> Window navigation
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

" Ctrl+S: Save
nnoremap <C-s> :w<CR>
inoremap <C-S> <Esc>:w<CR>i

" Quitting
" Q -> Quit current window
" Shift+Q -> Quit current without saving
" Ctrl+Q -> Quit all windows
" Ctrl+Shift+Q -> Quit all without saving
nnoremap q :q<CR>
nnoremap Q :q!<CR>
nnoremap <C-q> :qa<CR>
nnoremap <C-S-q> :qa!<CR>

" Ctrl+Z: Undo
nnoremap <C-z> u
inoremap <C-z> <Esc>ui
" Ctrl+Y: Redo
nnoremap <C-y> <C-r>
inoremap <C-y> <Esc><C-r>i

" Resize windows
nnoremap <C-Up> <C-w>+
nnoremap <C-Down> <C-w>-
nnoremap <C-Right> <C-w>>
nnoremap <C-Left> <C-w><
" Remap in terminals as well
tnoremap <C-Up> <C-w>+
tnoremap <C-Down> <C-w>-
tnoremap <C-Right> <C-w>>
tnoremap <C-Left> <C-w><

"
" Declare plugins with vim-plug
" See https://github.com/junegunn/vim-plug/wiki/tutorial#installing-plugins
"

" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Declare the list of plugins.
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'preservim/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'ycm-core/YouCompleteMe'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

"
" Settings for YouCompleteMe
"

" Disable automatic documentation popup at cursor position
let g:ycm_auto_hover=''
" Disable splitting window and showing documentation
let g:ycm_disable_signature_help = 1
set completeopt-=preview

"
" Settings for NERDTree
"

" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p

"
" Settings for NERDCommenter
" 

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
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
