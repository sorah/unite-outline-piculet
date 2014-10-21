let s:save_cpo = &cpo
set cpo&vim

let s:util = unite#sources#outline#import('Util')

let s:super = unite#sources#outline#get_outline_info('ruby', 1, 1)
let s:outline_info = deepcopy(s:super)
call extend(s:outline_info, {
  \ 'super': s:super,
  \ })

let s:piculet_directive = ['ec2', 'security_group',]
let s:piculet_directive_pat = '\v^\s*(ec2|security_group|description)\s*'
let s:piculet_directive_rules = [
    \ {'name': 'ec2', 'pattern': '/\<ec2\>.*/', 
    \ 'highlight': unite#sources#outline#get_highlight('piculet_ec2', 'level_1')},
    \ {'name': 'security_group', 'pattern': '/\v<security_group>.{-}( --|)/', 
    \ 'highlight': unite#sources#outline#get_highlight('piculet_sg', 'level_2')},
    \ {'name': 'description', 'pattern': '/\v -- .+$/', 
    \ 'highlight': unite#sources#outline#get_highlight('piculet_desc', 'comment')},
  \ ]

function! s:outline_info.initialize()
  let self.highlight_rules += s:piculet_directive_rules
  let self.heading_keywords += s:piculet_directive

  call call(self.super.initialize, [], self)
endfunction


function! s:outline_info.create_heading(which, heading_line, matched_line, context)
  let l:heading = {'level': 0, 'type': 'piculet'}

  if a:which == 'heading' && a:heading_line =~ s:piculet_directive_pat
    let l:lnum = a:context.heading_lnum

    let l:heading.level = s:util.get_indent_level(a:context, l:lnum) + 3
    let l:heading.word = substitute(a:heading_line, '\v\s*(do|\{)(\s*|[^|]*)\s*$', '', '')

    if match(l:heading.word, '\v^\s*security_group\s*') > -1
      let s:indent = matchlist(a:context.lines[l:lnum], '\v^(\s*)')[1]
      let s:str = s:util.join_to(a:context, l:lnum, '\v' . s:indent . '(end>|})')

      let s:descmatch = matchlist(s:str, '\v(\n|^)\s*description\s*(.{-})(\n|$)')

      if !empty(s:descmatch)
        let l:heading.word .= " -- " . s:descmatch[2]
      endif
    endif
  endif

  if l:heading.level > 0
    return l:heading
  endif

  return call(self.super.create_heading, [a:which, a:heading_line, a:matched_line, a:context], self.super)
endfunction

function! unite#sources#outline#defaults#ruby#piculet#outline_info()
  return s:outline_info
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
