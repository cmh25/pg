#!/bin/bash -x

pushd 000; gcc -g -o p main.c p.c; popd
pushd 000.eunitr; gcc -g -o p main.c p.c; popd

exit 0