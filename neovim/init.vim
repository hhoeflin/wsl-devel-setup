call plug#begin('~/.config/nvim/plugins')

" In the following load all the plugins that I am using

" For improved code folding
Plug 'tmhedberg/SimpylFold'

" git support
Plug 'tpope/vim-fugitive'

" Statusline support
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" File browsing
Plug 'scrooloose/nerdtree'

" Super searching
Plug 'kien/ctrlp.vim'

" Conquer of Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Plugin for R
Plug 'jalvesaq/Nvim-R'

" Plugin to allow deletion of buffers without closing window
" :Bdelete and :Bwipeout commands
" work like regular :bdelete and bwipeout
Plug 'moll/vim-bbye'

" Plugin for easier window resizing
Plug 'simeji/winresizer'

" Plugin for using REPL such as ipython
" Plug 'Vigemus/iron.nvim'
Plug 'hhoeflin/iron.nvim' 

" All of your Plugins must be added before the following line
call plug#end()            " required


" **************************************************************
" Settings for Python
" **************************************************************

" Set color scheme
color desert

" leader keys
let mapleader = "\\"
let maplocalleader = "\\"

" allow for buffers to be hidden, not unloaded when abandoned
set hidden

" ========================
" Tmux
" ========================
" Some settings to ensure that colors inside and outside of tmux are the same
set background=dark
set t_Co=256
set t_ut=""

" ========================
" Code folding
" ========================
" Enable folding
set foldmethod=indent
set foldlevel=99
" use spacebar for folding
nnoremap <space> za

" ========================
" Autocomplete
" ========================
" better autocomplete behavior
set wildmode=list:longest

" ========================
" Various
" ========================
" Line numbering
set nu

" Clear highlighting on escape in normal mode
nnoremap <silent> <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[ "This unsets the "last search pattern" register by hitting return

" exit terminal mode by hitting escape
tnoremap <Esc> <C-\><C-n>

" Command for tabs as 2 or 4
command! Tab2 exec 'set tabstop=2 shiftwidth=2 expandtab'
command! Tab4 exec 'set tabstop=4 shiftwidth=4 expandtab'

" ========================
" Airline
" ========================
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
" hide the encodign the file is in
let g:airline_section_y = ''

function! WindowNumber(...)
    let builder = a:1
    let context = a:2
    call builder.add_section('airline_b', '%{tabpagewinnr(tabpagenr())}')
    return 0
endfunction

call airline#add_statusline_func('WindowNumber')
call airline#add_inactive_statusline_func('WindowNumber')

" ========================
" Window moving
" ========================
" moving between different windows by their number
let i = 1
while i <= 9
    execute 'nnoremap <silent> <Leader>' . i . ' :' . i . 'wincmd w<CR>'
    let i = i + 1
endwhile

" ======================
" Coc.nvim
" ======================
" " Change the autocompletion behaviour to not be triggered automatically
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? coc#_select_confirm() :
  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()


" inoremap <silent><expr> <TAB>
"              \ pumvisible() ? "\<C-n>" :
"              \ <SID>check_back_space() ? "\<TAB>" :
"              \ coc#refresh()
let g:coc_snippet_next = '<tab>'

" =====================
" Enable window resizer
" =====================
" If you want to start window resize mode by `Ctrl+T`
let g:winresizer_start_key = '<C-T>'

" If you cancel and quit window resize mode by `z` (keycode 122)
let g:winresizer_keycode_cancel = 122



" ===============================
" Iron.nvim
" ===============================
luafile $HOME/.config/nvim/plugins.lua

" ===============================
" nvim-r
" ===============================
" Open R buffers without fixed width and have them listed
let R_buffer_opts = "nowinfixwidth buflisted"
