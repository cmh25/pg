#ifndef PG_H
#define PG_H

typedef struct {
  char r[256];
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
void pgprintst();
void pgprintt();

#endif /* PG_H */