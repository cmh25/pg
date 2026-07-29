#!/bin/bash

m=$1
e=${2-}
failed=0
list="tests.$m$e"

if [ ! -r "$list" ]; then
  echo "error: test list not found: $list" >&2
  exit 1
fi

while IFS= read -r t; do
  [ -n "$t" ] || continue
  printf "%s: " "$t"
  if ! ../pg "$t" printstates "$m" ${e:+"$e"} >"$t.$m$e.out" 2>&1; then
    echo "fail ***** (generator)"
    failed=1
  elif ! diff -u "$t.$m$e.res" "$t.$m$e.out" >"$t.$m$e.diff"; then
    echo -e "fail *****"
    failed=1
  else
    echo -e "pass"
    rm -f "$t.$m$e.out" "$t.$m$e.diff"
  fi
done < "$list"

exit "$failed"
