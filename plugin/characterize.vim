" characterize.vim - Unicode character metadata
" Maintainer:   Tim Pope
" Version:      1.1
" GetLatestVimScripts: 4410 1 :AutoInstall: characterize.vim

if exists("g:loaded_characterize") || v:version < 700 || &cp
  finish
endif
let g:loaded_characterize = 1

function! s:info(arg) abort
  let char = a:arg
  let nl_is_null = 0
  if empty(char)
    let char = getline('.')[col('.')-1:-1]
    let nl_is_null = 1
  elseif char =~# '^\\[xuU]\=0\+\x\@!'
    let char = "\n"
    let nl_is_null = 1
  elseif char =~# '^\\.'
    try
      let char = eval('"' . char . '"')
    catch
    endtry
  endif
  let char = matchstr(char, '.')
  if empty(char)
    return 'NUL'
  endif
  let charseq = char
  let outs = []
  while !empty(charseq)
    if nl_is_null && charseq =~# "^\n"
      let nr = 0
    elseif nl_is_null && charseq =~# "^\r" && &fileformat ==# 'mac'
      let nr = 10
    else
      let nr = char2nr(charseq)
    endif
    let char = nr < 32 ? '^'.nr2char(64 + nr) : nr2char(nr)
    let charseq = strpart(charseq, nr ? len(nr2char(nr)) : 1)
    let out = '<' . (empty(outs) ? '' : ' ') . char . '> ' . nr
    if nr < 256
      let out .= printf(', \%03o', nr)
    endif
    let out .= printf(', U+%04X', nr)
    let out .= ' '.characterize#description(nr, '<unknown>')
    for digraph in characterize#digraphs(nr)
      let out .= ", <C-K>".digraph
    endfor
    for emoji in characterize#emojis(nr)
      let out .= ', '.emoji
    endfor
    call add(outs, out)
  endwhile
  let str = join(outs, ' ')
  let entities = characterize#html_entities(char)
  if empty(entities)
    return str
  elseif len(outs) == 1
    return str . ', ' . entities
  else
    return str . ' | ' . entities
  endif
endfunction

command! -bar -nargs=? Characterize echo <SID>info(<q-args>)

nnoremap <silent><script> <Plug>(characterize) :<C-U>Characterize<CR>
if !hasmapto('<Plug>(characterize)', 'n') && mapcheck('ga', 'n') ==# ''
  nmap ga <Plug>(characterize)
endif

" vim:set sw=2 et:
