call plug#begin()
Plug 'SirVer/ultisnips'
Plug 'easymotion/vim-easymotion'
Plug 'NLKNguyen/papercolor-theme'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'KabbAmine/vCoolor.vim'
Plug 'ap/vim-css-color'
Plug 'vifm/vifm.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'sirver/ultisnips'
Plug 'lifepillar/vim-solarized8'
    let g:UltiSnipsExpandTrigger = '<tab>'
    let g:UltiSnipsJumpForwardTrigger = '<tab>'
    let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

Plug 'lervag/vimtex'
    let g:tex_flavor='latex'
    let g:vimtex_view_method='zathura'
    let g:vimtex_quickfix_mode=0

call plug#end()

" GENERAL SETTINGS 

set nocompatible
filetype plugin on
syntax on
source $VIMRUNTIME/defaults.vim
syntax on
set termguicolors
set title
set titlestring=vim~%t
colorscheme breezy 
filetype plugin indent on 
filetype plugin on 
set et ai si
set hidden
"set background=dark
set nu rnu
set autoread
set mouse=a
set autochdir
set wildmenu
set foldmethod=indent
"set foldcolumn=1
set t_Co=256
set wildmode=longest:full,full
set wildoptions=pum,fuzzy
set so=0
set clipboard=unnamedplus
set viminfo='70
set nowrap
set tabstop=4
set shiftwidth=4
set expandtab
set ignorecase
"set scrolloff=30
"set list lcs=tab:\│\ 
"set list 
set smartcase
let mapleader = " "
"autocmd InsertEnter * set cursorline
"autocmd InsertLeave * set nocursorline
" transparent bg
" autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
"highlight Comment ctermfg=245 guifg=#909090

" ----------------------------------------------------------------------------------------------
let g:go_metalinter_autosave=1

" Plugins Config 
" Snippets

" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<CR>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Polygot
" fix python red color
"let g:python_highlight_space_errors = 0

" ----------------------------------------------------------------------------------------------

"
" Keymaps 
" Select all the text
nnoremap <leader>a ggVG
nnoremap  <leader>td :call ToggleBackground()<CR>


" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
noremap <c-up> <c-w>+
noremap <c-down> <c-w>-
noremap <c-left> <c-w>>
noremap <c-right> <c-w><
" Surround word with a wanted character
nnoremap <leader>sw <cmd>echo "Press a character: " \| let c = nr2ch
nnoremap <leader>sc z= 1<CR>

" Replace all occurrences of a word
nnoremap <leader>rw :%s/\<<c-r><c-w>\>//g<left><left>

" Opening a terminal window
map <c-t> :below terminal<CR>
" Closing the terminal window
tnoremap <c-t> exit<CR>
" CTRL+I OR Esc to make the terminal scrollable and I to input mode
tnoremap jj  <C-\><C-n>

let g:EasyMotion_do_mapping = 0 " Disable default mappings
" For local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>
" For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>
nmap <leader><leader> :
nmap <leader>nn :noh<CR>
nmap <Esc> :noh<CR>
nmap <leader>fe :EditVifm<CR>
nmap <leader>cd ::cd %:p:h<CR>
nmap <C-j> <C-w>j
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
nmap <C-h> <C-w>h
imap <A-Space> <BS>
nmap <leader>wq :wq<CR>
nmap <leader>ww :w<CR>
nmap <leader>qq :q!<CR>
nmap <leader>wh :sp<CR>
nmap <leader>wv :vs<CR>
nmap <leader>bd :bd<CR>
nmap <leader>bq :bd!<CR>
nmap <leader>ff :Files<CR>
nmap <leader>tb :hi Normal guibg=NONE ctermbg=NONE<CR>
nmap <leader>fo :History<CR>
nmap <leader>fg :Rg<CR>
nmap <leader>fn :new<CR>
nmap <leader>tn :tabnew<CR>
nmap <leader>bn :bnext<CR>
nmap <leader>bp :bprevious<CR>
nmap <leader>ty :tabnext<CR>
nmap <leader>tr :tabprevious<CR>
nmap <leader>ht :Colors<CR>
nmap <leader>bb :Buffers<CR>
nmap <leader>br :b#<CR>
nmap <leader>tl :set invnumber invrelativenumber<CR>
nmap <leader>gg gg
nmap <leader>gh $
nmap <leader>gf _
nmap <leader>gb G
nmap gc <leader>c<leader>
command! -nargs=0 FzfInsertPath call fzf#run({'source': 'find . -type f', 'sink': {x -> execute("normal! i" . x)}, 'options': '--height 40%'})
nnoremap <leader>pc :FzfInsertPath<CR>
vmap gc <leader>c<leader>
nmap <leader>gb G
vmap <leader>y "+y
vnoremap <leader>re "hy:%s/<C-r>h//gc<left><left><left>
nmap <leader>tf :sh<CR>
nmap <leader>ko :!kwrite "%" &<CR>
"nmap <leader>ko :VCoolor<CR>
imap jj <Esc>
nmap <leader>f <Plug>(easymotion-bd-wl)
 nmap s <Plug>(easymotion-overwin-f2)
" For local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>

" For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1
" Gif config
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )

autocmd BufReadPost * normal zR

autocmd BufNewFile,BufRead /run/media/linux/13a93a6e-66f8-4032-a13b-ad277c59708c/backup/zz23/stories/* set viminfo+=n~/.viminfo-projA
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

function! RemoveLeadingSpaces()
    %s/^\s\+//g
endfunction

command! RemoveLeadingSpaces call RemoveLeadingSpaces()
autocmd CursorHold,CursorHoldI * checktime
set updatetime=5000  " Check every 5 seconds


function! ToggleBackground()
    if &background == "dark"
        set background=light
    else
        set background=dark
    endif
endfunction


