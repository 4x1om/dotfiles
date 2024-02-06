" NOTE: Terminal is unable to distinguish between Ctrl+Key and Ctrl+Shift+Key 
" as they emit the same key code. Avoid those.
" See https://stackoverflow.com/questions/1506764/how-to-map-ctrla-and-ctrlshifta-differently

"
" Global settings
"

set tabstop=4
set shiftwidth=4
set autoindent

" Stop Vim or NERDCommenter (not sure which) from incorrectly indenting Python
" See https://unix.stackexchange.com/questions/106526/stop-vim-from-messing-up-my-indentation-on-comments
set cindent
set cinkeys-=0#
set indentkeys-=0#

" Show line numbers
set number
" Jump back and forth when entering closing bracket
" set showmatch

" NERDCommenter needs this on
filetype plugin on

"
" Shortcuts
"

" Ctrl+S: Save
nnoremap <C-s> :w<CR>
inoremap <C-S> <Esc>:w<CR>i

" Ctrl+Z: Undo
nnoremap <C-z> u
inoremap <C-z> <Esc>ui
" Ctrl+Y: Redo
nnoremap <C-y> <C-r>
inoremap <C-y> <Esc><C-r>i

" Quitting
"
" Q -> Quit current window, prompt when there are unsaved changes (:confirm)
" Ctrl+Q -> Quit all windows, prompt for each changed buffer
nnoremap q :confirm q<CR>
nnoremap <C-q> :confirm qa<CR>
" Also map for terminal, but only quit all. To quit just the terminal, use
" Ctrl+D.
tnoremap <C-q> <C-w>N:confirm qa<CR>

" Copy/Pasting
"
" Deleted stuff shouldn't go into the clipboard. That'd be weird.
" But Vim doesn't distinguish between delete and cut for some reason.
" My fix: use an explicit buffer.
"
" Y -> Yank into buffer c (for clipboard)
vnoremap y "cy
" X -> Cut into buffer c (mirroring Ctrl-X in other software)
" By default, X and D do the same thing in visual mode. I remap X and keep D
" untouched.
vnoremap x "cd
" P -> Paste from buffer c.
nnoremap p "cp
vnoremap p "cp
" Shift+P -> Same thing but paste before
nnoremap P "cP
vnoremap P "cP
" Ctrl+P -> Paste in insert mode and terminal mode. I'd like to define
" Ctrl+Shift+P too, but it's not recognized.
inoremap <C-P> <Esc>"cpa
tnoremap <C-P> <C-W>"c

" Ctrl+B: Enter visual block mode. In WSL, Ctrl+V is overriden by paste.
nnoremap <C-B> <C-V>

" > <: Indenting in visual mode
vnoremap <Tab> >
vnoremap <S-Tab> <

" Shift+T: Split a new terminal
nnoremap T :belowright terminal<CR>

"
" Navigation
"

" Shift+J/K: J/K but faster
nnoremap J 4j
nnoremap K 4k
vnoremap J 4j
vnoremap K 4k

" Ctrl+H/J/K/L: Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Also map for terminal
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l

" Shift+Left/Down/Up/Right: Resize windows
nnoremap <S-Left> <C-w><
nnoremap <S-Down> <C-w>-
nnoremap <S-Up> <C-w>+
nnoremap <S-Right> <C-w>>
" Also map for terminal
tnoremap <S-Left> <C-w><
tnoremap <S-Down> <C-w>-
tnoremap <S-Up> <C-w>+
tnoremap <S-Right> <C-w>>

"
" Leader key related
"

" Set leader key
let mapleader = ","

" ,r: Split window to open ~/.vimrc
nnoremap <Leader>r :vs ~/.vimrc<CR>
" ,s: Hot reload vimrc without reopening Vim
nnoremap <Leader>s :source ~/.vimrc<CR>

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

" Ctrl+/: Toggle comments. Have to put <C-_> here due to Vim's quirk
nnoremap <C-_> :call nerdcommenter#Comment('n', 'toggle')<CR>
inoremap <C-_> <Esc>:call nerdcommenter#Comment('n', 'toggle')<CR>a
vnoremap <C-_> :call nerdcommenter#Comment('v', 'toggle')<CR>
