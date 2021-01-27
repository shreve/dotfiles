call plug#begin()

" External tools
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'francoiscabrol/ranger.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" Editor Customization
Plug 'chriskempson/base16-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Editor feature augmentation
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'rbgrouleff/bclose.vim' " dependency of ranger
Plug 'wfxr/minimap.vim', {'do': ':!cargo install --locked code-minimap'}

" Language plugs
Plug 'dag/vim-fish'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go'
Plug 'rust-lang/rust.vim'
call plug#end()

let mapleader=","
let &colorcolumn=join(range(81,999),",") " color every column after 80

filetype indent on

colorscheme Tomorrow-Night-Bright

set autoindent
set clipboard=unnamed,unnamedplus
set number
set relativenumber
set nocompatible " stop behaving in a Vi-compatible way
set autoindent " keep indentation on a new line
set autoread " if a file updates, read it
set backspace=indent,eol,start " allow backspacing over everything in insert mode (:h fixdel if issues)
set backupdir=~/.config/nvim/tmp
set directory=~/.config/nvim/tmp " keep temporary and backup files in ~/.vim
set expandtab " explicitly enable tab->space conversion
set gdefault " use the /g flag by default for :s
set history=1000 " remember 1000 lines of history
set ignorecase " by default ignore case in search
set laststatus=2 " always display status line
set list listchars=tab:»·,trail:$,space:· " display extra whitespace
set nowrap " don't linewrap, just continue past window
set number " precede each line with file line number (only current line with relativenumber)
set relativenumber " display line numbers in relation to current line
set ruler " show line and column number of cursor
set scrolloff=3 " lines of padding when scrolling buffer
set showcmd " show command as it's being typed
set showmatch " breifly jump to matching bracket
set shiftround " >> << round to multiple of shiftwidth
set signcolumn=number " combine the sign and number columns when possible
set smartcase " when a capital letter is used, turn off ignorecase
set smartindent " indent properly in c-like languages
set splitright
set splitbelow
set tags+=.git/tags
" set termguicolors " use gui colors rather than just 16 term colors
set inccommand=split

let g:netrw_sort_sequence = "[\/]$,*"
let g:netrw_list_hide= netrw_gitignore#Hide()
let g:netrw_sort_options = "i"
let g:netrw_list_style = 3

let g:ale_set_highlights = 0
let g:ale_sign_error = '|>'
let g:ale_sign_warning = '->'

" Make ale errors red fg
highlight ALEErrorSign ctermfg=1 ctermbg=0
highlight ALEWarningSign ctermfg=4 ctermbg=0

let g:airline_theme='bubblegum'
let g:airline_powerline_fonts = 1

let g:ranger_replace_netrw = 1

let g:minimap_auto_start = 1
let g:minimap_width = 15

au BufRead,BufNewFile * setlocal tabstop=2 shiftwidth=2 expandtab

au BufRead,BufNewFile *.py setlocal tabstop=4 shiftwidth=4 expandtab
au BufRead,BufNewFile *.go
      \ setlocal tabstop=4 shiftwidth=4 noexpandtab |
      \ setlocal formatoptions+=cro

" Try to restore position
au BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

" Use C- vim nav to move windows
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Use 0 to go to the beginning of text, not necessarily the 0th column
nnoremap 0 ^ze

" Press escape to clear the highlight from a search
nnoremap <esc> :noh<cr><esc>

map <Leader>t :call fzf#run(fzf#wrap({'source': 'fd -tf --hidden -E .git/'}))<cr>
map <Leader>e :Ranger<cr>
map <Leader>r :e .<cr>
map <Leader>s :w!<cr>
map <Leader>q :call ReflowParagraph()<cr>
map <Leader>u1 :call Underline()<cr>

" Jump to definition
map <Leader>d <M-C-]>
" Jump back
map <Leader>b <M-C-T>

command! -nArgs=1 Settabs :set tabstop=<args> shiftwidth=<args>

function Underline()
  normal! YPjVr=k
endfunction

function ReflowParagraph()
  normal! mmgqap`m
endfunction
