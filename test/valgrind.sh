#!/bin/bash

m=$1
e=$2

os=`uname -s`
if [ "$os" = "Darwin" ]; then echo "valgrind tests are linux only"; exit 0; fi

for t in `cat tests.$m$e`; do
  echo -n "$t: "
  valgrind --leak-check=full ../pg $t $m $e >/dev/null 2> v$t.$m$e
  grep -q "ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)" v$t.$m$e
  if [ $? -ne 0 ]; then
    echo -e "fail *****"
  else
    echo -e "pass"
    rm -f v$t.$m$e
  fi
done

exit 0
