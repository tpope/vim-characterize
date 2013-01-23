" characterize.vim - Unicode character metadata
" Maintainer:   Tim Pope
" Version:      1.0

if exists("g:loaded_characterize") || v:version < 700 || &cp
  finish
endif
let g:loaded_characterize = 1

function! s:info(char)
  if empty(a:char)
    return 'NUL'
  endif
  let nr = a:char ==# "\n" ? 0 : char2nr(a:char)
  let char = nr < 32 ? '^'.nr2char(64 + nr) : a:char
  let out = '<' . char . '> ' . nr
  if nr < 256
    let out .= printf(', \%03o', nr)
  endif
  let out .= printf(', U+%04X', nr)
  let out .= ' '.characterize#description(nr, '<unknown>')
  for digraph in characterize#digraphs(nr)
    let out .= ", \<C-K>".digraph
  endfor
  for emoji in characterize#emojis(nr)
    let out .= ', '.emoji
  endfor
  let entity = characterize#html_entity(nr)
  if !empty(entity)
    let out .= ', '.entity
  endif
  return out
endfunction

nmap <silent><script> ga :<C-U>echo <SID>info(matchstr(getline('.')[col('.')-1:-1],'.'))<CR>

" vim:set sw=2 et:
