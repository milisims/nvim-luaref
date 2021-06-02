#!/usr/bin/env bash

prefix=https://www.lua.org/manual/5.1

wget ${prefix}/manual.html -O en.html
for lang in pt es de; do wget ${prefix}/${lang}/manual.html -O ${lang}.html; done

mkdir -p doc translations
for lang in en pt es de; do
  echo Setting ${lang}.html to utf8
  nvim -es -u NONE ${lang}.html +"set fileencoding=utf8|wq"

  echo Converting ${lang}.html to org
  pandoc ${lang}.html -o ${lang}.org

  echo Making edits and writing translations/lua_reference.${lang}x
  cat edit_org_to_help.vim | nvim -es -u NONE ${lang}.org

  echo
done

echo Generating tags
nvim -es -u NONE doc/lua_reference.txt +'helptags %:h' +q
nvim -es -u NONE translations/lua_reference.ptx +'helptags %:h' +q

echo Cleanup.
mv translations/lua_reference.enx doc/lua_reference.txt
rm *.html
rm *.org
