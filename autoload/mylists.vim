
function! mylists#oldfiles()
  let l:listcopy = v:oldfiles
  call filter(l:listcopy, 'filereadable(v:val)')
  return l:listcopy
endfunction
