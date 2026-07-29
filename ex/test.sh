#!/bin/bash

set -e

failed=0

check() {
  directory=$1
  input=$2
  expected=$3
  actual=$(printf "%b" "$input" |
    "$directory/p" |
    grep -oE -- '-?[0-9]+|parse|lex' || true)
  if [ "$actual" = "$expected" ]; then
    printf "%s: pass\n" "$directory"
  else
    printf "%s: fail\nexpected:\n%s\nactual:\n%s\n" \
      "$directory" "$expected" "$actual"
    failed=1
  fi
}

lr_input='2\n2+3\n2*3+4\n2+3*4\n(2+3)*4\n((2))\n'
lr_expected='2
5
10
14
20
2'

ll1_input='2+3*4\n2*3+4\n(2+3)*4\n8-2\n8/2\n-3+5\n8-2-1\n20/5/2\n'
ll1_expected='14
10
20
6
4
2
7
10'

ll1_flat_expected='14
14
20
6
4
2
7
10'

check 000 "$lr_input" "$lr_expected"
check 000.eunitr "$lr_input" "$lr_expected"
check 021.ll1 "$ll1_input" "$ll1_expected"
check 022.ll1 "$ll1_input" "$ll1_flat_expected"

exit "$failed"
