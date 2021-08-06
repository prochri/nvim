" cmd map:
" - same command all listers: true
" - using generic list interface: list of arguments
" - different name: table with key for each lister
let s:cmd_map = {
  \ "buffers": v:true,
  \ "files": { "coclist": v:true, "telescope": 'find_files'},
  \ "grep": { "coclist": v:true, "telescope": 'live_grep'},
  \ "lines": { "coclist": v:true, "telscope": 'current_buffer_fuzzy_find' },
  \ "lists": { "coclist": v:true, "telescope": 'builtin'},
  \ "commands": v:true,
  \ "vimcommands": {"coclist": v:true, "telescope": 'commands'},
  \ "keymaps": { "coclist": 'maps', "telescope": v:true},
  \ "helptags": { "coclist": v:true, "telescope": 'help_tags'},
  \ "projects": {"coclist": 'sessions', "telescope": ['prosession#ListSessions', 'Prosession']},
  \ "oldfiles": {"coclist": ['mylists#oldfiles', 'edit'], "telescope": v:true }
\ }
if g:use_builtin_lsp
  let g:used_lister = 'telescope'
else
  let g:used_lister = 'coclist'
end

function! s:executeSimple(...) abort
  let l:cmd = a:1
  " check if the default command should be used
  if type(l:cmd) == type(v:true)
    let l:cmd = a:2
  endif
  if g:used_lister ==# 'coclist'
    execute 'CocList ' . l:cmd
  else
    execute 'Telescope ' . l:cmd
    " call luaeval('require"telescope.builtin"[_A]()', a:cmd)
  endif
endfunction

function! s:executeGeneric(cmd) abort
  " echomsg 'generic lister'
  if g:used_lister ==# 'coclist'
    execute 'CocList generic ' . join(a:cmd)
  else
    call luaeval('require"telescope.builtin".generic(_A)', a:cmd)
  endif
endfunction

function! s:executeCommand(entry, cmd) abort
  if type(a:entry) == type(v:true)
    call s:executeSimple(a:cmd)
  elseif type(a:entry) == type("")
    call s:executeSimple(a:entry)
  elseif type(a:entry) == type([])
    call s:executeGeneric(a:entry)
  endif
endfunction

function! EasyLister(cmd) abort
  if !has_key(s:cmd_map, a:cmd)
    echoerr 'Lister command not found: ' . a:cmd
    return
  endif
  let l:entry = s:cmd_map[a:cmd]
  if type(l:entry) == type({})
    if has_key(l:entry, g:used_lister)
      call s:executeCommand(l:entry[g:used_lister], a:cmd)
    else
      echoerr 'Lister ' . g:used_lister . ' not supported for command ' . a:cmd
    endif
  else
    call s:executeCommand(l:entry, a:cmd)
  endif
endfunction
