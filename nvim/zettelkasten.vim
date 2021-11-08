function! LinkComplete(A, L, P)
    let l:zk_path = "/home/phigit/Documents/Misc_Projects/Zettelkasten/content/"
    return system("ls  " . l:zk_path . "new/2* " . l:zk_path . "top_pages/2* " . l:zk_path . "linked_pages/2*")
endfunction
function! LinkInsert()
   call inputsave()
   let l:file = input('Insert link to file: ', '*', 'custom,LinkComplete')
   call inputrestore()
   let l:filename = fnamemodify(l:file, ':t')
   let l:filedir = fnamemodify(l:file, ':h:t')
   exec ':redraw'
   if len(l:filename) > 0
       if l:filedir ==# "new" || l:filedir ==# "top_pages"
           exec ':!git mv ' l:file . ' ' . fnamemodify(l:file, ':h:h') . '/linked_pages/' . l:filename
       endif
       exec 'normal! a' . '{{< ref "../linked_pages/' . l:filename . '">}}'
   endif
endfunction

inoremap <C-L> <ESC>:call LinkInsert()<CR>a


