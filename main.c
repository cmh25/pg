#include "pg.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void usage(char *c) {
  printf("usage: %s <file> [pretty] [genhc]\n",c);
  printf("   <file>: grammar definition\n");
  printf("    [lr0]: build lr(0) parse table\n");
  printf("    [slr]: build slr(1) parse table (*default*)\n");
  printf("    [lr1]: build lr(1) parse table\n");
  printf("   [lalr]: build lalr(1) parse table\n");
  printf("    [ll1]: build ll(1) parse table\n");
  printf(" [pretty]: pretty print action table\n");
  printf("  [genhc]: generate p.h and p.c\n");
  printf("  [first]: print first() for each token\n");
  printf(" [follow]: print follow() for each token\n");
  printf(" [eunitr]: eliminate unit reductions from an LR parser\n");
  printf(" [strict]: return failure when the grammar has conflicts\n");
  printf("  [quiet]: suppress the grammar, table, and individual conflict reports\n");
  printf(" [fullst]: print the full state table\n");
  printf("  [showd]: show deleted states and transitions\n");
}

int inargv(int c, char **argv, char *a) {
  while(--c) if(!strcmp(argv[c],a)) return 1;
  return 0;
}

static int validarg(char *a) {
  static char *v[] = {
    "lr0","slr","lr1","lalr","ll1","pretty","genhc","first","follow",
    "eunitr","strict","quiet","fullst","showd","printstates"
  };
  size_t i;
  for(i=0;i<sizeof(v)/sizeof(*v);i++) if(!strcmp(a,v[i])) return 1;
  return 0;
}

int main(int argc, char **argv) {
  int d=0,m=SLR,i,modes=0,q;
  if(argc<2) { usage(argv[0]); exit(1); }
  for(i=2;i<argc;i++) {
    if(!validarg(argv[i])) {
      fprintf(stderr,"error: unknown option [%s]\n",argv[i]);
      return 1;
    }
    if(!strcmp(argv[i],"lr0")) { m=LR0; modes++; }
    if(!strcmp(argv[i],"slr")) { m=SLR; modes++; }
    if(!strcmp(argv[i],"lr1")) { m=LR1; modes++; }
    if(!strcmp(argv[i],"lalr")) { m=LALR; modes++; }
    if(!strcmp(argv[i],"ll1")) { m=LL1; modes++; }
  }
  if(modes>1) {
    fprintf(stderr,"error: select only one parser mode\n");
    return 1;
  }
  if(m==LL1&&inargv(argc,argv,"eunitr")) {
    fprintf(stderr,"error: eunitr applies only to LR parser modes\n");
    return 1;
  }
  if(inargv(argc,argv,"showd")) d=1;
  q=inargv(argc,argv,"quiet");
  pgsetquiet(q);
  pgread(argv[1]);
  pgparse();
  if(!q) pgreport();
  if(m==LL1) {
    pgbuildll();
    if(inargv(argc,argv,"genhc")) { pghll(); pgcll(); }
  }
  else {
    pgbuild(m);
    if(m==LALR) pglalr();
    if(inargv(argc,argv,"eunitr")) pgeunitr();
    if(inargv(argc,argv,"printstates")) pgprint();
    if(!q) {
      if(inargv(argc,argv,"pretty")) pgprintt2();
      else pgprintt(d);
    }
    if(inargv(argc,argv,"genhc")) { pgh(); pgc(); }
    if(inargv(argc,argv,"fullst")) pgprintst(d);
  }
  if(inargv(argc,argv,"first")) pgprintfirst();
  if(inargv(argc,argv,"follow")) pgprintfollow();
  if(q&&pgconflicts())
    fprintf(stderr,"warning: %d parser conflicts\n",pgconflicts());
  if(inargv(argc,argv,"strict")&&pgconflicts()) return 2;
  return 0;
}
