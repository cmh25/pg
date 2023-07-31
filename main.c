#include "pg.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  if(argc<2) { printf("usage: %s <file>\n", argv[0]); exit(0); }
  pgread(argv[1]);
  pgparse();
  pgreport();
  pgbuild();
  pgprint();
  //pgprintst();
  pgprintt();
  return 0;
}
