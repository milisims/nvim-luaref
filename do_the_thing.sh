#!/usr/bin/env bash
# set -o errexit -o pipefail -o noclobber -o nounset

prefix=https://www.lua.org/manual/5.1

wget ${prefix}/manual.html -O en.html
for lang in pt es de; do wget ${prefix}/${lang}/manual.html -O ${lang}.html; done

mkdir -p doc
for lang in en pt es de; do
  echo Setting ${lang}.html to utf8
  echo "set fileencoding=utf8|wq" | nvim -es -u NONE ${lang}.html

  echo Converting ${lang}.html to org
  pandoc ${lang}.html -o ${lang}.org

  echo Making edits and writing doc/${lang}.txt
  cat edit_org_to_help.vim | nvim -es -u NONE ${lang}.org

  echo Renaming doc/$lang.txt to doc/lua_reference.${lang}x
  mv -f doc/$lang.txt doc/lua_reference.${lang}x

  echo
done

echo Cleanup.
mv doc/lua_reference.enx doc/lua_reference.txt
rm *.html
rm *.org
