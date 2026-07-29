#!/bin/bash

m=$1
e=${2-}
failed=0
list="tests.$m$e"

if [ ! -r "$list" ]; then
  echo "error: test list not found: $list" >&2
  exit 1
fi

os=`uname -s`
if [ "$os" = "Darwin" ]; then echo "valgrind tests are linux only"; exit 0; fi

while IFS= read -r t; do
  [ -n "$t" ] || continue
  printf "%s: " "$t"
  if ! valgrind --error-exitcode=99 --leak-check=full \
      --errors-for-leak-kinds=definite,indirect,possible \
      ../pg "$t" "$m" ${e:+"$e"} \
      >/dev/null 2>"v$t.$m$e"; then
    echo -e "fail *****"
    failed=1
  else
    echo -e "pass"
    rm -f "v$t.$m$e"
  fi
done < "$list"

exit "$failed"
