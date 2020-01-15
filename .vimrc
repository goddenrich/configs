" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set viminfo='100,<1000,s100,h

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Line numbers
set nu

autocmd FileType text setlocal textwidth=76 spell spelllang=en_gb

" Don't do spell-checking on Vim help files
autocmd FileType help setlocal nospell

" Prepend ~/.backup to backupdir so that Vim will look for that directory
" before littering the current dir with backups.
" You need to do "mkdir ~/.backup" for this to work.
set backupdir^=~/.backup
set undodir^=~/.backup
" Also use ~/.backup for swap files. The trailing // tells Vim to
"    incorporate
"    " full path into swap file names.
set dir^=~/.backup//

" Ignore case when searching
" - override this setting by tacking on \c or \C to your search term to
"    make
"   your search always case-insensitive or case-sensitive, respectively.
set ignorecase

" go-vim settings
set autowrite
noremap <leader>n :cnext<CR>
noremap <leader>m :cprevious<CR>
nnoremap <leader>a :cclose<CR>
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"

" tab indentations for various file types
filetype plugin indent on

autocmd FileType html setlocal expandtab shiftwidth=2 softtabstop=2

autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4

autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd FileType markdown setlocal expandtab shiftwidth=4 softtabstop=4

autocmd FileType yaml setlocal expandtab shiftwidth=2 softtabstop=2

" automatically downloads vim-plug to your machine if not found.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let mapleader = " "

" emulate system clipboard
inoremap <C-v> <ESC>"+pa
vnoremap <C-c> "+y

" Define plugins to install
call plug#begin('~/.vim/plugged')

" tabular
Plug 'godlygeek/tabular'

" Browse the file system
Plug 'scrooloose/nerdtree'

" " Ctrlp
Plug 'kien/ctrlp.vim'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" jedi-vim
Plug 'davidhalter/jedi-vim'

" supertab tab autocompletion
Plug 'ervandew/supertab'

" syntastic
Plug 'vim-syntastic/syntastic'

" T comment
 Plug 'vim-scripts/tComment' "Comment easily with gcc

 " vim-go
 Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

 " vim-sessions
 Plug 'xolox/vim-session'
 Plug 'xolox/vim-misc' "required for above

 " fugitive (git plugin)
 Plug 'tpope/vim-fugitive'

" LSP
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" emmet-vim for html
Plug 'mattn/emmet-vim'

" All of your Plugins must be added before the following line
call plug#end()

" Airline
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename

" -----------Buffer Management---------------
set hidden " Allow buffers to be hidden if you've modified a buffer

" Move to the next buffer
nmap <leader>l :bnext<CR>

" Move to the previous buffer
nmap <leader>h :bprevious<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>q :bp <BAR> bd #<CR>

" Show all open buffers and their status
nmap <leader>bl :ls<CR>


" Use arrow keys to navigate window splits
noremap <leader><Right> :wincmd l <CR>
noremap <leader><Left> :wincmd h <CR>
noremap <leader><Up> :wincmd k <CR>
noremap <leader><Down> :wincmd j <CR>

" ctrl-p
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
	\ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
	\}

" Use the nearest .git|.svn|.hg|.bzr directory as the cwd
let g:ctrlp_working_path_mode = 'r'

nmap <leader>p :CtrlP<cr>

" Nerdtree
autocmd StdinReadPre * let s:std_in=1
let NERDTreeWinSize = 50
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <leader>f :NERDTreeFind<cr>
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeHijackNetrw=0


" jedi-vim settings
let g:jedi#use_splits_not_buffers = "left"

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_c_checkers = ['checkpatch']
let g:syntastic_python_python_exec = '/usr/bin/python3'

"if exists(':Tabularize')
	nmap <leader>a= :Tabularize /= <CR>
	vmap <leader>a= :Tabularize /= <CR>
	vmap <leader>a: :Tabularize /:\zs <CR>
	vmap <leader>a: :Tabularize /:\zs <CR>
"endif
"

" c-tags
nnoremap <C-]> g<C-]>

source ~/.vim/plugged/cscope_maps.vim

" LSP config

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['~/.local/bin/pyls'],
    \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
    \ 'plz': ['plz', 'tool', 'lps'],
    \ 'go': ['~/go/bin/go-langserver'],
    \ }

nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>


" emmet-vim config
let g:user_emmet_leader_key=','

" TM settings
autocmd BufNewFile,BufRead *.build_defs :setlocal filetype=plz syntax=python
autocmd BufNewFile,BufRead BUILD :setlocal filetype=plz syntax=python ts=8 sts=4 et sw=4
