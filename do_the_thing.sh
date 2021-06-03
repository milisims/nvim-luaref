#!/usr/bin/env bash

prefix=https://www.lua.org/manual/5.1

mkdir -p doc translations html org

if [ ! -f html/en.html ]; then
  wget ${prefix}/manual.html -O html/en.html
  for lang in pt es de; do wget ${prefix}/${lang}/manual.html -O html/${lang}.html; done
  for lang in en pt es de; do nvim -es -u NONE html/${lang}.html +"set fileencoding=utf8|wq"; done
fi

for lang in en pt es de; do
  echo Converting html/${lang}.html to org/${lang}.org
  pandoc html/${lang}.html -o org/${lang}.org

  echo Making edits and writing translations/lua_reference.${lang}x
  cat edit_org_to_help.vim | nvim -es -u NONE org/${lang}.org

  echo
done

mv translations/lua_reference.enx doc/lua_reference.txt
