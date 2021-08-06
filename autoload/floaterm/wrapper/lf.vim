
" TODO adjust to my liking
function! floaterm#wrapper#lf#(cmd, jobopts, ...) abort
  let lf_tmpfile = tempname()
  let lastdir_tmpfile = tempname()
  let original_dir = getcwd()
  lcd %:p:h

  let cmdlist = split(a:cmd)
  let cmd = 'lf -last-dir-path="' . lastdir_tmpfile . '" -selection-path="' . lf_tmpfile . '"'
  if len(cmdlist) > 1
    let cmd .= ' ' . join(cmdlist[1:], ' ')
  else
    let cmd .= ' "' . getcwd() . '"'
  endif

  exe "lcd " . original_dir
  let cmd = [&shell, &shellcmdflag, cmd]
  let a:jobopts.on_exit = funcref('s:lf_callback', [lf_tmpfile, lastdir_tmpfile])
  return [v:false, cmd]
endfunction

function! s:lf_callback(lf_tmpfile, lastdir_tmpfile, ...) abort
  let edit_cmd = get(s:, 'edit_cmd', 'default')
  echom 'hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii its mee'
  if (edit_cmd == 'cd' || edit_cmd == 'lcd') && filereadable(a:lastdir_tmpfile)
    let lastdir = readfile(a:lastdir_tmpfile, '', 1)[0]
    if lastdir != getcwd()
      exec edit_cmd . ' ' . lastdir
      return
    endif
  elseif filereadable(a:lf_tmpfile)
    let filenames = readfile(a:lf_tmpfile)
    if !empty(filenames)
      if has('nvim')
        call floaterm#window#hide(bufnr('%'))
      endif
      let locations = []
      let floaterm_opener = edit_cmd != 'default' ? s:edit_cmd : g:floaterm_opener
      for filename in filenames
        let dict = {'filename': fnamemodify(filename, ':p')}
        call add(locations, dict)
      endfor
      call floaterm#util#open(locations, floaterm_opener)
      unlet! s:edit_cmd
    endif
  endif
endfunction
