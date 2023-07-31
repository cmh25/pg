#!/bin/bash

for t in `cat tests`; do
  echo -n "$t: "
  ../pg $t > $t.out 2>/dev/null
  diff -u $t.res $t.out &> $t.diff
  if [ $? -ne 0 ]; then
    echo -e "\e[1m\e[31mfail *****\e[0m"
  else
    echo -e "\e[1m\e[32mpass\e[0m"
    rm -f $t.out $t.diff
  fi
done

exit 0
