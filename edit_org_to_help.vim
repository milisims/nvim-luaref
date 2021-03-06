" ======== Do some easy edits
set ignorecase
normal! ggd4j
%s/\[\[[^]]\+\/license.html\]\[\([^]]*\)\]\]/\1: https:\/\/www.lua.org\/license.html/
normal! 2jdap
/^\* 3 --/,/^\* 5 --/-d
/^\* 6 --/,/^\* 8 --/-d
/^\*\+ 2.10.1 --/,/^\*\+ 2.10.2 --/-d
%s/ / /g
%s/\n\s*#+begin_example/>/
%s/^\s*#+end_example\n/</
%s/^\ze\*\+ \d/\=repeat('=', 78)."\n"/
g/^\s*:PROPERTIES:$/,+2d
silent! %s/^\s\+$//g

" ======== Handle markup first

" Special cases:
%s/=%=\/x\//`%x`/
%s/\*\/\(\S*\)\/:\*/`\1`:/
%s/\*=\(\S*\)=:\*/`\1`:/
%s/\*"\(\S*\)":\*/`\1`:/
%s/\*=\*/`=`/
%s/^\*\*\*\* \(.*\):/\1\~/
%s/=www.lua.org=/www.lua.org/
%s/=\(\([\][]\)=\+\2\)=/`\1`/g
%s/[^=]\zs=\([~=]=\)=\ze[^=\]]/`\1`/g
" big sweeps:
%s/\*\(\w\%([^*]*\w\)\?\)\*/`\1`/g
%s/\%(\s\|^\)\zs\/\(\w\%([^/]*\w\)\?\)\//`\1`/g
%s/\%([[{]\|\s\|^\)\zs\/\(\w\%([^/]*\S\)\?\)\//`\1`/g
" verbatim used a lot in links, do later

" Add target for metamethod/metatable
0/^- `add`/-call append('.', '                                      *lua_metamethods* *lua_metatable_events*')
" ======== Set up columns/sections

" insert table of contents
execute '0/1 --/-2read toc/' . expand('%:t:r') . '.txt'
" Change section headers to proper format and insert link targets
0/lua_reference_toc/;/===/g/^\d/execute printf('%%s/^\*\+ %s -- \(.*\)/\=toupper(submatch(1))..repeat(" ", 78-strwidth(submatch(1).."%s")).."*%s*"', expand('<cWORD>'), split(getline('.'))[-1], split(getline('.'))[-1][1:-2])

" ======== Set up columns/sections

" Link removed sections to online docs
if expand('%:t:r') == 'en'
  %s/\[\[#\([3467][0-9.]*\)\]\[§[0-9.]*\]\]/https:\/\/www.lua.org\/manual\/5.1\/manual.html#\1/g
else
  execute '%s/\[\[#\([3467][0-9.]*\)\]\[§[0-9.]*\]\]/https:\/\/www.lua.org\/manual\/5.1\/' . expand('%:t:r') . '\/manual.html#\1/g'
endif
" Set up function links
%s/\[\[[^]]\+\]\[=\([^=]\+\)=\]\]/|\1|/g

" Note: type duplicates helptag.
" Set up section links, some have no links, so `silent!`:
0/lua_reference_toc/;/===/g/^\d/execute printf('silent! %%s/\[\[#\V%s\m\]\[[^]]*\]\]/%s/g', expand('<cWORD>'), split(getline('.'))[-1])

setlocal shiftwidth=4
" reformat and set up builtin function, option/variable targets
g/--------------\n\n\*\{3}/,+2s/--------------\n\n\*\{3} =\([^(]\+\)\( (.*)\)\?=\n/\=submatch(1).submatch(2).repeat(' ', 74-strwidth(submatch(1).submatch(1).submatch(2))).'*'.submatch(1).'()*'/|silent +1,/^---\|^===/->
" Fix the variables (remove parens)
%s/^\(\S*\)[^(]*\1()\*$/\=submatch(1)..repeat(' ', 76-strwidth(submatch(1))*2)..'*'..submatch(1)..'*'

" Finish verbatim
%s/\%([\t ("']\|^\)\zs=\([^= \t]\%([^=]*[^= \t]\)\?\)=/`\1`/g

write! translations/lua_reference.%:t:rx
quit!
