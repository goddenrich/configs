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

" tab indentations for various file types
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4

autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd FileType markdown setlocal expandtab shiftwidth=4 softtabstop=4

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

" YCM
Plug 'Valloric/YouCompleteMe'

" syntastic
Plug 'vim-syntastic/syntastic'

" Nerd commenter
Plug 'scrooloose/nerdcommenter'

" T comment
 Plug 'vim-scripts/tComment' "Comment easily with gcc

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
" autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
let NERDTreeWinSize = 50
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-n> :NERDTreeToggle<CR>
nmap <leader>n :NERDTreeFind<CR>
let g:NERDTreeHijackNetrw=0


" YCM
" Modify below if you want less invasive autocomplete
let g:ycm_semantic_triggers =  {
 \   'c' : ['->', '.'],
 \   'objc' : ['->', '.'],
 \   'cpp,objcpp' : ['->', '.', '::'],
 \   'perl' : ['->'],
 \   'php' : ['->', '::'],
 \   'cs,java,javascript,d,vim,ruby,python,perl6,scala,vb,elixir,go' : ['.'],
 \   'lua' : ['.', ':'],
 \   'erlang' : [':'],
 \ }

let g:ycm_show_diagnostics_ui = 0
let g:ycm_complete_in_comments_and_strings=1
let g:ycm_key_list_select_completion=['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']
let g:ycm_autoclose_preview_window_after_completion = 1

set completeopt-=preview

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_c_checkers = ['checkpatch']

"if exists(':Tabularize')
	nmap <leader>a= :Tabularize /= <CR>
	vmap <leader>a= :Tabularize /= <CR>
	"nmap <leader>a| :Tabularize /| <CR>
	"vmap <leader>a| :Tabularize /| <CR>
	vmap <leader>a: :Tabularize /:\zs <CR>
	vmap <leader>a: :Tabularize /:\zs <CR>
"endif
"

" c-tags
nnoremap <C-]> g<C-]>

source ~/.vim/plugged/cscope_maps.vim

