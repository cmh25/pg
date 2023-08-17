#ifndef PG_H
#define PG_H

typedef struct {
  char r[1024];
  char *lhs;
  char *op;
  char *rhs[32];
  int rhsi;
} rule;

void pgread(char *g);
void pgparse();
void pgreport();
void pgbuild();
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

#endif /* PG_H */
