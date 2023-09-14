#!/bin/bash

m=$1
e=$2

for t in `cat tests.$m$e`; do
  echo -n "$t: "
  ../pg $t printstates $m $e &> $t.$m$e.out
  diff -u $t.$m$e.res $t.$m$e.out &> $t.$m$e.diff
  if [ $? -ne 0 ]; then
    echo -e "fail *****"
  else
    echo -e "pass"
    rm -f $t.$m$e.out $t.$m$e.diff
  fi
done

exit 0
