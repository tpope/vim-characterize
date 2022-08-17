" characterize.vim - Unicode character metadata
" Maintainer:   Tim Pope
" Version:      1.1
" GetLatestVimScripts: 4410 1 :AutoInstall: characterize.vim

if exists("g:loaded_characterize") || v:version < 700 || &cp
  finish
endif
let g:loaded_characterize = 1

function! s:info(char) abort
  if empty(a:char)
    return 'NUL'
  endif
  let charseq = a:char
  let outs = []
  let entityC1 = 0
  while !empty(charseq)
    let nr = charseq ==# "\n" ? 0 : charseq ==# "\r" && &fileformat ==# 'mac' ? 10 : char2nr(charseq)
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
    " byteidxcomp({expr}, 2) tests for a composing character: where -1 is
    " returned it means there is no composing character. For the 64 HTML5 named
    " character references that are comprised of characters plus composing
    " characters, this is needed to ensure that the character *and* the
    " composing character are passed to characterize#html_entity, not just the
    " first character.  An example is <⃒ &nvlt; &#60;&#8402;.
    if byteidxcomp(matchstr(getline('.')[col('.')-1:-1],'.'), 2) == -1
      let entity = characterize#html_entity(nr)
      if !empty(entity)
        let out .= ', '.entity
      endif
    else
      if entityC1 == 0
        let entityC1 = nr
      else
        let entity = characterize#html_entity(entityC1 . '.' . nr)
        if !empty(entity)
          let out .= ', '.entity
        endif
        let entityC1 = 0
      endif
    endif
    call add(outs, out)
  endwhile
  return join(outs, ' ')
endfunction

nnoremap <silent><script> <Plug>(characterize) :<C-U>echo <SID>info(matchstr(getline('.')[col('.')-1:-1],'.'))<CR>
if !hasmapto('<Plug>(characterize)', 'n') && mapcheck('ga', 'n') ==# ''
  nmap ga <Plug>(characterize)
endif

" vim:set sw=2 et:
