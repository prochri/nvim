
if g:use_builtin_lsp
  let s:last_session = g:prosession_dir . 'last_session.vim'

  " TODO only load if started without file
  function! s:load_existent_session()
    for l:pwd in prosession#ListSessions()
      if l:pwd ==# getcwd()
        execute "Prosession " .. l:pwd
        return
      endif
    endfor
  endfunction

  augroup ProjectProsession
    au! ProjectProsession
    autocmd VimEnter * nested call s:load_existent_session()
    autocmd VimLeave * call mksession! s:last_session
  augroup END
else
  " coc-session implementation: load on startup
endif

