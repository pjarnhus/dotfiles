"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""                                                                             """""
"""""                                Basic settings                               """""
"""""                                                                             """""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remove compatibility with vi - probably default but let's be sure
set nocompatible

" Disable mode lines for security reasons
set nomodeline

" Activate file type recognition, along with plugins and indents
filetype plugin indent on

" Allow a buffer to go to the background with unsaved changes
set hidden

" Do not update screen while executing macro - there is no point to do it
set lazyredraw

" Enable menu of possible completions for command line
set wildmenu

" Set wildmode to only complete the longest common string, and then show menu
set wildmode=list:longest

" Set encoding to UTF-8
set encoding=utf-8

" Set line breaks to be Unix style
set fileformat=unix

" Ignore case in searches, unless upper case letters are present
set ignorecase
set smartcase

" Set leader key
let mapleader="æ"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""                                                                             """""
"""""                                  Fuzzy find                                 """""
"""""                                                                             """""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set the path to current working directory plus recursive glob
" This enables us to search for files recursively
set path=.,**

" Ignore files that are not relevant for direct editing
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=*.pdf,*.ps
set wildignore+=.git/*
set wildignore+=**/node_modules/*
set wildignore+=*.pyc,*.ipynb
set wildignore+=.ipynb_checkpoints/*

nnoremap <leader>o :find *
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""                                                                             """""
"""""                                    Plugins                                  """""
"""""                                                                             """""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin(fnamemodify(expand('$MYVIMRC'), ':p:h') . '/autoload')

" Session plugin
Plug 'tpope/vim-obsession'
Plug 'christoomey/vim-tmux-navigator'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""                                                                             """""
"""""                                Look and feel                                """""
"""""                                                                             """""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Turn on syntax highlighting
syntax on

" Use tabs instead of spaces with a fixed line width of 88 characters
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=88
set expandtab
set autoindent

" Set color column as a warning for overstepping 88 characters
let &colorcolumn="".join(range(88,999),",")
highlight ColorColumn ctermbg=235 guibg=#2c2d27

" Set line numbering to relative numbers with the absolute at the current line
set nu rnu

" Set British spell checker, but only show incorrect spelling with a curly line
set spell spelllang=en_gb
highlight clear SpellRare
highlight clear SpellLocal
highlight clear SpellBad
highlight SpellBad cterm=undercurl guisp=Red

" Toggle cursorline to show in the active buffer
" BufEnter is included to account for the first buffer opened
augroup actbuf
    autocmd!
    autocmd BufEnter,WinEnter * set cursorline
    autocmd WinLeave * set nocursorline
augroup END

" Remove background colour of window divider
highlight clear VertSplit

" Remove colours and extraneous information from status line
highlight clear StatusLine
highlight clear StatusLineNC
set noruler
set laststatus=0
set fillchars=stl:―,stlnc:⎯

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""                                                                             """""
"""""                                  Key Mapping                                """""
"""""                                                                             """""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""                                                                             """""
"""""                             Parentheses behaviour                           """""
"""""                                                                             """""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Automatically create a set of parentheses/brackets, when the open is created
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>

" Do not insert a closing parentheses/bracket if the next character is one
function! s:InsertClose(paren)
    let l:next_char = getline('.')[col('.')-1]
    if l:next_char ==# a:paren
        call feedkeys("\<Right>", 'n')
    else
        call feedkeys(a:paren, 'n')
    endif
endfunction

inoremap <silent> ) <C-\><C-O>:call <SID>InsertClose(')')<CR>
inoremap <silent> ] <C-\><C-O>:call <SID>InsertClose(']')<CR>
inoremap <silent> } <C-\><C-O>:call <SID>InsertClose('}')<CR>

" Remove both opening and closing parentheses/brackets on backspace, if no characters
" between them
function! s:IsOpenClose()
    let l:paren_set = [['(',')'], ['[',']'], ['{','}']]
    let l:current_line = getline('.')
    let l:prev_char = l:current_line[col('.')-2]
    let l:next_char = l:current_line[col('.')-1]
    let l:state = "no_pair"
    for p in l:paren_set
        if (l:prev_char ==# p[0] && l:next_char ==# p[1])
            let l:state = "pair"
        endif
    endfor
    return l:state
endfunction

function! s:DeleteParenPair()
    let l:state = s:IsOpenClose()
    if l:state ==# "pair"
        " Adding an extra backspace as feed keys append to the text
        call feedkeys("\<BS>\<Right>\<BS>\<BS>", "n")
    else
        " Adding an extra backspace as feed keys append to the text
        call feedkeys("\<BS>\<BS>", "n")
    endif
endfunction

inoremap <silent> <BS> <C-\><C-O>:call <SID>DeleteParenPair()<CR> 

" When hitting enter inside a pair of parentheses/brackets, move closing part two lines
" down and continue editing on the empty line in between
function! s:NewLineParens()
    let l:state = s:IsOpenClose()
    if l:state ==# "pair"
        " Adding an extra backspace as feed keys append to the text
        call feedkeys("\<BS>\<CR>\<C-O>O", "n")
    else
        " Adding an extra backspace as feed keys append to the text
        call feedkeys("\<BS>\<CR>", "n")
    endif
endfunction

inoremap <silent> <CR> <C-\><C-O>:call <SID>NewLineParens()<CR> 


" Break line while remaining in normal mode
nnoremap <leader>j i<CR><ESC>

" List all buffers and prepare to enter the name of one to switch to
nnoremap <leader>b :ls<CR>:buffer<space>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""                                                                             """""
"""""                                  Sessions                                   """""
"""""                                                                             """""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:sessions_dir = fnamemodify(expand('$MYVIMRC'), ':p:h') . '/sessions'

function! SetSession()
    call inputsave()
    let l:workdir = input('Set working directory for session: ', fnamemodify(expand('%'), ':p:h'), 'dir')
    call inputrestore()
    exec 'cd ' . l:workdir
    
    let l:session_name = fnamemodify(l:workdir, ':t')    
    let l:session_name = substitute(l:session_name, '^[^a-zA-Z0-9]*', '', '')
    let l:session_name = substitute(l:session_name, '[^a-zA-Z0-9]*$', '', '')
    let l:session_name = substitute(l:session_name, '[^a-zA-Z0-9]', '_', 'g')
    call inputsave()
    let l:session_file = input('Set session file name: ', g:sessions_dir . '/' . l:session_name . '.vim', 'file')
    call inputrestore()
    exec ':redraw'
    exec ':Obsession ' . l:session_file
endfunction

exec 'nnoremap <leader>sr :so ' .g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS>'
nnoremap <silent> <leader>ss :call SetSession()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""                                                                             """""
"""""                                Zettelkasten                                 """""
"""""                                                                             """""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup zettelkasten
    autocmd!
    autocmd BufRead /**/zettelkasten/**/*.md execute 'source ' . fnamemodify(expand($MYVIMRC), ':h') . '/zettelkasten.vim'
augroup END

