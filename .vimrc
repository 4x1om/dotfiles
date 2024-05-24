" NOTE: Terminal is unable to distinguish between Ctrl+Key and Ctrl+Shift+Key 
" as they emit the same key code. Avoid those.
" See https://stackoverflow.com/questions/1506764/how-to-map-ctrla-and-ctrlshifta-differently

" NOTE: At least on WSL, Terminal is unable to receive <A-Key>'s, and they will
" be received as <Esc><Key>, which is indistinguishable from typing <Esc> and
" then <Key>. To check what is sent when you press a hotkey, run `cat -n` and
" use the interactive prompt.
" For this reason, do NOT map <Esc> in any mode to anything lest it interfere
" with other hotkeys using the escape sequence \e.
" See https://vi.stackexchange.com/a/2363

"
" Startup Commands
"

" Start NERDTree and put the cursor back in the other window.
" See https://github.com/preservim/nerdtree?tab=readme-ov-file#how-do-i-open-nerdtree-automatically-when-vim-starts
autocmd VimEnter * NERDTree | wincmd p

"
" Global Settings
"

" Allow mouse, 'cause... why not?
set mouse=a
" See https://vimdoc.sourceforge.net/htmldoc/options.html#'ttymouse'
set ttymouse=sgr

set tabstop=3
set shiftwidth=3
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

" Highlight search results
set hlsearch
" Ignore case
set ignorecase

" When splitting new windows, put them to the right and bottom.
set splitright
set splitbelow

" Remove the delay when pressing <Esc> to exit visual mode etc.
" May conflict with shortcuts that use the escape sequence.
" See https://stackoverflow.com/a/15550847
set timeoutlen=1000 ttimeoutlen=0

" 
" Cursor Appearance
"

" Reference chart of values:
"	Ps = 0  -> blinking block.
"	Ps = 1  -> blinking block (default).
"	Ps = 2  -> steady block.
"	Ps = 3  -> blinking underline.
"	Ps = 4  -> steady underline.
"	Ps = 5  -> blinking bar (xterm).
"	Ps = 6  -> steady bar (xterm).
" Change the number after the escape sequence to change the cursor.
" See https://stackoverflow.com/a/42118416
"
" t_SI is for starting insert mode, and t_EI for ending insert mode.
" See https://vimdoc.sourceforge.net/htmldoc/term.html
let &t_SI = "\e[5 q"
let &t_EI = "\e[1 q"

"
" Navigation
"

" Shift+J/K: J/K but faster
nnoremap J 4j
nnoremap K 4k
vnoremap J 4j
vnoremap K 4k
" Shift+H/L: J/K but even faster.
" The original uses of Shift+H/L felt pointless to me, because you couldn't
" fast travel.
nnoremap H <C-D>
nnoremap L <C-U>
vnoremap H <C-D>
vnoremap L <C-U>

" Ctrl+H/J/K/L: Window navigation
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

tnoremap <C-H> <C-W>h
tnoremap <C-J> <C-W>j
tnoremap <C-K> <C-W>k
tnoremap <C-L> <C-W>l

inoremap <C-H> <Esc><C-W>h
inoremap <C-J> <Esc><C-W>j
inoremap <C-K> <Esc><C-W>k
inoremap <C-L> <Esc><C-W>l

" Tabs
nnoremap <C-PageUp> gT
nnoremap <C-PageDown> gt
inoremap <C-PageUp> <Esc>gT
inoremap <C-PageDown> <Esc>gt
tnoremap <C-PageUp> <C-W>NgT
tnoremap <C-PageDown> <C-W>Ngt

" <Number><Tab> to go to tab
nnoremap t :<C-U>execute "tabn " . v:count<CR>

" Shift+Left/Down/Up/Right -> Resize windows
nnoremap <S-Left> <C-W><
nnoremap <S-Down> <C-W>-
nnoremap <S-Up> <C-W>+
nnoremap <S-Right> <C-W>>

tnoremap <S-Left> <C-W><
tnoremap <S-Down> <C-W>-
tnoremap <S-Up> <C-W>+
tnoremap <S-Right> <C-W>>

inoremap <S-Left> <Esc><C-W><a
inoremap <S-Down> <Esc><C-W>-a
inoremap <S-Up> <Esc><C-W>+a
inoremap <S-Right> <Esc><C-W>>a

"
" Shortcuts
"

" Ctrl+S -> Save
nnoremap <C-S> :w<CR>
" inoremap <C-S> <Esc>:w<CR>i

" Ctrl+Z -> Undo
nnoremap <C-Z> u
inoremap <C-Z> <Esc>u
" Ctrl+Y -> Redo
nnoremap <C-Y> <C-R>
inoremap <C-Y> <Esc><C-R>

" Ctrl+A -> Select all
" See https://vi.stackexchange.com/a/9033
nnoremap <C-A> ggVG
vnoremap <C-A> <Esc>ggVG

" Ctrl+F -> Search
nnoremap <C-F> /

"
" Quitting
"

" Q -> Quit current window, prompt when there are unsaved changes (:confirm)
" Ctrl+Q -> Quit all windows, prompt for each changed buffer
nnoremap q :confirm q<CR>
nnoremap <C-Q> :confirm qa<CR>
" Also map for terminal, but only quit all. To quit just the terminal, use
" Ctrl+D.
tnoremap <C-Q> <C-W>N:confirm qa<CR>

"
" Copy/pasting
"

" Deleted stuff shouldn't go into the clipboard. That'd be weird.
" But Vim doesn't distinguish between delete and cut for some reason.
" My fix: use an explicit buffer c (that stands for clipboard).

" Y -> Yank in normal/visual mode
vnoremap y "cy

nnoremap yw "cyw
nnoremap yy "cyy
nnoremap y$ "cy$

" X -> Cut in visual mode (mirroring Ctrl-X in other software)
" By default, X and D do the same thing in visual mode. I remap X and keep D
" untouched.
vnoremap x "cd

nnoremap x <Nop>
nnoremap xw "cdw
nnoremap xx "cdd
nnoremap x$ "cd$

" Use Shift+X to delete character
nnoremap X <Del>

" P/Shift+P -> Paste in normal/visual mode
nnoremap p "cp
vnoremap p "cp
nnoremap P "cP
vnoremap P "cP
" Ctrl+P -> Paste in insert/terminal mode
inoremap <C-P> <Esc>"cpa
tnoremap <C-P> <C-W>"c

" Ctrl+C -> Copy to clipboard when on WSL.
" This command is glitchy and appears that it can only operate on full lines.
" See https://stackoverflow.com/a/68317739
" vnoremap <C-C> :w !clip.exe<CR>
vnoremap <C-C> :<C-U>silent'<,'>w !clip.exe<CR>

" Other stuff

" Ctrl+Backspace -> Delete previous word in insert mode. Wait, why is it C-H?
" That's just how it works, I have zero idea!
inoremap <C-H> <C-W>

" Ctrl+B -> Enter visual block mode. In WSL, Ctrl+V is overriden by paste.
nnoremap <C-B> <C-V>

" Tab/Shift+Tab -> Indent
nnoremap <Tab> >>
nnoremap <S-Tab> <<
" When indenting in visual mode, you lose your selection by default.
" Here we use `gv` to select previous area and move our cursor. See `:h gv`
vnoremap <Tab> >gvl
vnoremap <S-Tab> <gvh

" Open line above in insert mode (basically like opposite of Enter)
inoremap <C-O> <C-O>O

" Open in current window
nnoremap <C-O> :edit 
" Open a new window
nnoremap <C-R> :vnew 
" New window below
nnoremap <C-D> :new 

" Open two terminals below the file, put the cursor back up
" `++rows` sets height. See `:help winheight`.
" `++kill=kill` makes it so that `:q` kills any running jobs in terminal
" See `:help ++close` for help on options.
" See https://vi.stackexchange.com/a/14062
function! OpenTwoTerminals()
	exec "ter ++kill=kill ++rows=" . winheight(0)/3 | exec "vert ter ++kill=kill" | wincmd k
endfunction

nnoremap T :exec "ter ++kill=kill ++rows=" . winheight(0)/3<CR>

" 
" Terminal Commands
"

" Ctrl+W: Delete previous word. For consistency.
tnoremap <C-W> <C-W>.
" Go to normal mode
tnoremap <C-N> <C-W>N

"
" Leader Key Related
"

" Set leader key
let mapleader = ","

" ,v -> Split window to open ~/.vimrc
nnoremap <Leader>v :vs ~/.vimrc<CR>
" ,s -> Hot re-source vimrc without reopening Vim
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
Plug 'kien/ctrlp.vim'
" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install --frozen-lockfile --production',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

"
" Color schemes
"

colorscheme catppuccin-mocha

"
" Settings for YouCompleteMe
"

" Disable automatic documentation popup at cursor position
" let g:ycm_auto_hover=''
" Disable splitting window and showing documentation
" let g:ycm_disable_signature_help = 1
set completeopt-=preview

"
" Settings for NERDTree
"

let NERDTreeShowHidden = 1
let g:NERDTreeWinSize = winwidth(0)/8

" Close the tab if NERDTree is the only window remaining in it.
" See https://github.com/preservim/nerdtree?tab=readme-ov-file#how-can-i-close-vim-or-a-tab-automatically-when-nerdtree-is-the-last-window
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Open the existing NERDTree on each new tab.
" See https://github.com/preservim/nerdtree?tab=readme-ov-file#can-i-have-the-same-nerdtree-on-every-tab-automatically
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif

let NERDTreeMapOpenVSplit = '<C-R>'
let NERDTreeMapOpenSplit = '<C-D>'
let NERDTreeMapRefresh = v:null
let NERDTreeMapRefreshRoot = 'r'
" Unmap J/K
let NERDTreeMapJumpLastChild = v:null
let NERDTreeMapJumpFirstChild = v:null
" Unmap Ctrl+J/K
let NERDTreeMapJumpNextSibling = v:null
let NERDTreeMapJumpPrevSibling = v:null
" Unmap CD to remove lag after pressing C
let NERDTreeMapCWD = v:null
" a to toggle hidden (all)
let NERDTreeMapToggleHidden = 'a'
" Unmap A
let NERDTreeMapToggleZoom = v:null

"
" Settings for NERDCommenter
" 

" NERDCommenter needs this on
filetype plugin on

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

"
" Settings for CtrlP
"

let g:ctrlp_prompt_mappings = {
	\ 'PrtSelectMove("t")':   [],
	\ 'PrtSelectMove("b")':   [],
	\ 'AcceptSelection("h")': ['<c-d>'],
	\ 'AcceptSelection("v")': ['<c-r>', '<RightMouse>'],
	\ 'ToggleByFname': [],
	\ 'ToggleRegex()': [],
	\ }

"
" Settings for prettier
"

" Automatically format JS etc files on save.
" See: https://github.com/prettier/vim-prettier?tab=readme-ov-file#configuration
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
