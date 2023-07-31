#!/bin/bash

for t in `cat tests`; do
  echo -n "$t: "
  ../pg $t > $t.out 2>/dev/null
  diff -u $t.res $t.out &> $t.diff
  if [ $? -ne 0 ]; then
    echo -e "fail *****"
  else
    echo -e "pass"
    rm -f $t.out $t.diff
  fi
done

exit 0
