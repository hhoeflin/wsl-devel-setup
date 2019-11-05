call plug#begin('~/.config/nvim/plugins')

" In the following load all the plugins that I am using

" For improved code folding
Plug 'tmhedberg/SimpylFold'

" buffer explorer
Plug 'jlanzarotta/bufexplorer'

" git support
Plug 'tpope/vim-fugitive'

" Statusline support
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" have taboo tabline; enables custom tab labels
Plug 'gcmt/taboo.vim'

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

" a lot of additional color schemes
Plug 'rafi/awesome-vim-colorschemes'

" All of your Plugins must be added before the following line
call plug#end()            " required


" **************************************************************
" Settings for Python
" **************************************************************

" Set color scheme
color dracula

" leader keys
let mapleader = "\\"
let maplocalleader = "-"

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

" reduce the time to timeout
set timeoutlen=500

" Command for tabs as 2 or 4
command! Tab2 exec 'set tabstop=2 shiftwidth=2 expandtab'
command! Tab4 exec 'set tabstop=4 shiftwidth=4 expandtab'

" ========================
" Airline
" ========================
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1 
let g:airline#extensions#taboo#enabled = 1 " for taboo settings see below
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
" Taboo settings
" ========================
let g:taboo_tabline = 0
" Note that the tab number is automatically displayed by tabline
let g:taboo_tab_format = "%W %f%m"
let g:taboo_renamed_tab_format = "%W [%l]%m"

" ========================
" Window and tab switcher moving
" ========================
" moving between different windows by their number
let i = 1
while i <= 9
    execute 'nnoremap <silent> <Leader>' . i . ' :' . i . 'wincmd w<CR>'
    execute 'noremap <silent> <Leader>t' . i . ' ' . i . 'gt<CR>'
    let i = i + 1
endwhile

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

" ======================
" Coc.nvim
" ======================
"set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Change the autocompletion behaviour to not be triggered automatically
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

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
