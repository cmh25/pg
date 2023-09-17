#ifndef PG_H
#define PG_H

typedef struct {
  char r[1024];
  char *lhs;
  char *op;
  char *rhs[32];
  int rhsi;
} rule;

#define LR0 0
#define LR1 1
#define SLR 2
#define LALR 3
#define LL1 4

void pgread(char *g);
void pgparse();
void pgreport();
void pgbuild(int m);
void pgprints(int i);
void pgprint();
void pgprintst(int d);
void pgprintt(int d);
void pgprintt2();
void pgprintfirst();
void pgprintfollow();
void pgh();
void pgc();
void pgeunitr();
void pglalr();
void pgbuildll(int m);
void pghll();
void pgcll();

#endif /* PG_H */
