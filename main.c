#include "pg.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv) {
  if(argc<2) { printf("usage: %s <file> [pretty]\n", argv[0]); exit(0); }
  pgread(argv[1]);
  pgparse();
  pgreport();
  pgbuild();
  pgprint();
  //pgprintst();
  if(argc<3) pgprintt();
  else if(!strcmp(argv[2],"pretty")) pgprintt2();
  //pgprintfirst();
  //pgprintfollow();
  //pgh();
  //pgc();
  return 0;
}
