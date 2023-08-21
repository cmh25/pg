#ifndef P_H
#define P_H

#define T000   0 /* '+' */
#define T001   1 /* '*' */
#define T002   2 /* '(' */
#define T003   3 /* ')' */
#define T004   4 /* n */
#define T005   5 /* $e */
#define T006   6 /* $a */

extern int pgta[512]; /* tokens */
extern int pgva[512]; /* values */
extern int pgi;       /* tv index */
void parse();

#endif /* P_H */