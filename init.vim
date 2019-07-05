set nocompatible              " Remove Vi compatibility

" Disable modelines for security reason
set nomodeline

if has('unix')
	call plug#begin('~/.config/nvim/autoload')
endif
if has('win32')
	call plug#begin('C:\Users\bb9946\AppData\Local\nvim\autoload')
	let g:python3_host_prog = 'C:\Users\bb9946\AppData\Local\Continuum\anaconda3\python.exe'
end
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-jedi'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'

" Make sure that we get the corrent indentation with indentpython plugin
Plug 'vim-scripts/indentpython.vim'

" Enable proper folding for python
set foldmethod=indent
set foldlevel=99
Plug 'tmhedberg/SimpylFold'

" Enable folding with spacebar
nnoremap <space> za

" Linting with flake8
Plug 'nvie/vim-flake8'

" Jedi-vim
Plug 'davidhalter/jedi-vim'

" Zenburn colour scheme only works on Linux
Plug 'jnurmine/Zenburn'

" Fugitive - Git support
Plug 'tpope/vim-fugitive'

" Unimpaired
Plug 'tpope/vim-unimpaired'

call plug#end()

autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=menuone,noselect,noinsert
set shortmess+=c
let ncm2#popup_delay = 5
let ncm2#complete_length = [[1, 1]]
let g:ncm2#matcher = 'substrfuzzy'

" Set encoding to UTF-8
set encoding=utf-8

" Set relative line numbering with absolute number at current line
set nu rnu

" Set color column with a warning and danger columns
let &colorcolumn="".join(range(80,999),",")
highlight ColorColumn ctermbg=235 guibg=#2c2d27

" Make Vim adhere to PEP-8 standards
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ softtabstop=4
    \ shiftwidth=4
    \ textwidth=79
    \ expandtab
    \ autoindent
    \ fileformat=unix

" Investigate what this does!
let python_highlight_all = 1
syntax on

" Do not show docstring popup until called for
autocmd FileType python setlocal completeopt-=preview
" Do not start autocompletion on . - Requires that it is called
let g:jedi#popup_on_dot = 0

" Set colour scheme on exists on Linux
colorscheme zenburn


let g:jedi#auto_initialization = 1
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#completions_command = ""
let g:jedi#show_call_signatures = 1

" Ignore case in searches, except when upper case letters are provided
set ignorecase
set smartcase

" Save when switching to another window
au FocusLost * :wa

" Remap movement between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>

" Set up leader key maps
let mapleader="æ"

" Break line while remaining in normal mode
nnoremap <leader>j i<CR><ESC>

" Create easy switching between buffers
nnoremap <leader>l :bnext<CR>
nnoremap <leader>h :bprevious<CR>

" Create dash line below current line
nnoremap <leader>- Yp<C-V>$r-

" Create custom statusline
" Generic function for the statusline
function! StatusLine(state)
    let statusline=""
 
    " Add buffer number
    let statusline.="%(%{&buflisted?bufnr('%'):''}"

    " Add a >> for the active buffer statusline
    if a:state == "Active"
        let statusline.="\ >>\ "
    else
        let statusline.="\ \ \ \ "
    endif
    let statusline.="%)"
    let statusline.="%<"

    " Add square brackets around readonly files
    let statusline.="%{&readonly?'[':''}"
    let statusline.="%t"
    let statusline.="%{&readonly?']':''}"

    " Add an asterix after the filename for changed files
    let statusline.="%{&modified?'*':''}"
    let statusline.="\ "

    " Show Git branch names on the right
    let statusline.="%=\ %{fugitive#head()!=''?'('.fugitive#head().')':''}"
    return statusline
endfunction

" Initialise the statusline
set statusline=%!StatusLine('Active')

" Change the statusline between active and inactive
augroup status
    autocmd!
    autocmd WinEnter * setlocal statusline=%!StatusLine('Active')
    autocmd WinLeave * setlocal statusline=%!StatusLine('Inactive')
augroup END

" Set British spell checker
set spell spelllang=en_gb
