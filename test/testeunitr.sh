#!/bin/bash

for t in `cat tests.eunitr`; do
  echo -n "$t: "
  ../pg $t printstates eunitr &> $t.eunitr.out
  diff -u $t.eunitr.res $t.eunitr.out &> $t.eunitr.diff
  if [ $? -ne 0 ]; then
    echo -e "fail *****"
  else
    echo -e "pass"
    rm -f $t.eunitr.out $t.eunitr.diff
  fi
done

exit 0
