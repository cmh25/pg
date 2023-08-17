#include "pg.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void usage(char *c) {
  printf("usage: %s <file> [pretty] [genhc]\n",c);
  printf("   <file>: grammar definition\n");
  printf(" [pretty]: pretty pring action table\n");
  printf("  [genhc]: generate p.h and p.c\n");
  printf("  [first]: print first() for each token\n");
  printf(" [follow]: print follow() for each token\n");
  printf(" [eunitr]: eliminate unit reductions\n");
  printf(" [fullst]: print the full state table\n");
  printf("  [showd]: show deleted states and transitions\n");
}

int inargv(int c, char **argv, char *a) {
  while(--c) if(!strcmp(argv[c],a)) return 1;
  return 0;
}

int main(int argc, char **argv) {
  int d=0;
  if(argc<2) { usage(argv[0]); exit(1); }
  if(inargv(argc,argv,"showd")) d=1;
  pgread(argv[1]);
  pgparse();
  pgreport();
  pgbuild();
  if(inargv(argc,argv,"eunitr")) pgeunitr();
  pgprint();
  if(inargv(argc,argv,"pretty")) pgprintt2();
  else pgprintt(d);
  if(inargv(argc,argv,"genhc")) { pgh(); pgc(); }
  if(inargv(argc,argv,"first")) pgprintfirst();
  if(inargv(argc,argv,"follow")) pgprintfollow();
  if(inargv(argc,argv,"fullst")) pgprintst(d);
  return 0;
}
