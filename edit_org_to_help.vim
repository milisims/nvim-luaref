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
%s/^\s\+$//g

" ======== Handle markup first

" Special cases:
%s/=%=\/x\//`%x`/
%s/\*\/\(\S*\)\/:\*/`\1`:/
%s/\*=\(\S*\)=:\*/`\1`:/
%s/\*"\(\S*\)":\*/`\1`:/
%s/\*=\*/`=`/
%s/^\*\*\*\* \(.*\):/\1\~/
%s/=www.lua.org=/www.lua.org/
" big sweeps:
%s/\*\(\w\%([^*]*\w\)\?\)\*/`\1`/g
%s/\%(\s\|^\)\zs\/\(\w\%([^/]*\w\)\?\)\//`\1`/g
%s/\%([[{]\|\s\|^\)\zs\/\(\w\%([^/]*\S\)\?\)\//`\1`/g
" verbatim used a lot in links, do later

" ======== Set up columns/sections

" insert table of contents
execute '0/1 --/-2read toc/' . expand('%:t:r') . '.txt'
" Change section headers to proper format and insert link targets
g/^\*\+ \d/execute "normal! d2f-xms\"aYgg/\<C-r>a   \<Cr>f|\"byf|'sA\<C-r>=repeat(' ', 79-strwidth(@a.@b))\<Cr>\<C-r>b\<Esc>0gUt|$r*F|r*"

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
silent! %s/\[\[#1\]\[[^]]*\]\]/|lua_introduction|/g
silent! %s/\[\[#2\]\[[^]]*\]\]/|lua_language|/g
silent! %s/\[\[#2.1\]\[[^]]*\]\]/|lua_conventions|/g
silent! %s/\[\[#2.2\]\[[^]]*\]\]/|lua_types|/g
silent! %s/\[\[#2.2\]\[[^]]*\]\]/|lua_type_coercion|/g
silent! %s/\[\[#2.3\]\[[^]]*\]\]/|lua_variables|/g
silent! %s/\[\[#2.4\]\[[^]]*\]\]/|lua_statements|/g
silent! %s/\[\[#2.4.1\]\[[^]]*\]\]/|lua_chunks|/g
silent! %s/\[\[#2.4.2\]\[[^]]*\]\]/|lua_blocks|/g
silent! %s/\[\[#2.4.3\]\[[^]]*\]\]/|lua_assignment|/g
silent! %s/\[\[#2.4.4\]\[[^]]*\]\]/|lua_control|/g
silent! %s/\[\[#2.4.5\]\[[^]]*\]\]/|lua_for|/g
silent! %s/\[\[#2.4.6\]\[[^]]*\]\]/|lua_func_statement|/g
silent! %s/\[\[#2.4.7\]\[[^]]*\]\]/|lua_local|/g
silent! %s/\[\[#2.5\]\[[^]]*\]\]/|lua_expressions|/g
silent! %s/\[\[#2.5.1\]\[[^]]*\]\]/|lua_arithmetic_ops|/g
silent! %s/\[\[#2.5.2\]\[[^]]*\]\]/|lua_relational_ops|/g
silent! %s/\[\[#2.5.3\]\[[^]]*\]\]/|lua_logical_ops|/g
silent! %s/\[\[#2.5.4\]\[[^]]*\]\]/|lua_concatenation|/g
silent! %s/\[\[#2.5.5\]\[[^]]*\]\]/|lua_len|/g
silent! %s/\[\[#2.5.6\]\[[^]]*\]\]/|lua_precedence|/g
silent! %s/\[\[#2.5.7\]\[[^]]*\]\]/|lua_table_constructors|/g
silent! %s/\[\[#2.5.8\]\[[^]]*\]\]/|lua_function_calls|/g
silent! %s/\[\[#2.5.9\]\[[^]]*\]\]/|lua_function_defs|/g
silent! %s/\[\[#2.6\]\[[^]]*\]\]/|lua_scope|/g
silent! %s/\[\[#2.7\]\[[^]]*\]\]/|lua_errors|/g
silent! %s/\[\[#2.8\]\[[^]]*\]\]/|lua_metatables|/g
silent! %s/\[\[#2.9\]\[[^]]*\]\]/|lua_environments|/g
silent! %s/\[\[#2.10\]\[[^]]*\]\]/|lua_gc|/g
silent! %s/\[\[#2.10.2\]\[[^]]*\]\]/|lua_weak|/g
silent! %s/\[\[#2.11\]\[[^]]*\]\]/|lua_coroutines|/g
silent! %s/\[\[#5\]\[[^]]*\]\]/|lua_stdlib|/g
silent! %s/\[\[#5.1\]\[[^]]*\]\]/|lua_builtins|/g
silent! %s/\[\[#5.2\]\[[^]]*\]\]/|lua_module_coroutines|/g
silent! %s/\[\[#5.3\]\[[^]]*\]\]/|lua_modules|/g
silent! %s/\[\[#5.4\]\[[^]]*\]\]/|lua_module_string|/g
silent! %s/\[\[#5.4.1\]\[[^]]*\]\]/|lua_patterns|/g
silent! %s/\[\[#5.5\]\[[^]]*\]\]/|lua_module_table|/g
silent! %s/\[\[#5.6\]\[[^]]*\]\]/|lua_module_math|/g
silent! %s/\[\[#5.7\]\[[^]]*\]\]/|lua_module_io|/g
silent! %s/\[\[#5.8\]\[[^]]*\]\]/|lua_module_os|/g
silent! %s/\[\[#5.9\]\[[^]]*\]\]/|lua_debug|/g
silent! %s/\[\[#8\]\[[^]]*\]\]/|lua_syntax|/g

setlocal shiftwidth=4
" reformat and set up builtin function, option/variable targets
g/--------------\n\n\*\{3}/,+2s/--------------\n\n\*\{3} =\([^(]\+\)\( (.*)\)\?=\n/\=submatch(1).submatch(2).repeat(' ', 76-strwidth(submatch(1).submatch(1).submatch(2))).'*'.submatch(1).'*'/|silent +1,/^---\|^===/->

" Finish verbatim
%s/\%([\t ("']\|^\)\zs=\([^= \t]\%([^=]*[^= \t]\)\?\)=/`\1`/g

write translations/lua_reference.%:rx
quit!
