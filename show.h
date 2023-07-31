#ifndef SHOW_H
#define SHOW_H

typedef struct {
  char *c;  /* title */
  int t;    /* type 1=int,2=double,3=char,4=char* */
  void *v;  /* data */
  char **o; /* strings */
  int m;    /* max */
} col;

/* n: number of columns
   r: number of rows
   c: column names
   t: column types
   v: column data
    : returns string representation of table 

   caller should free result */
char* show(int n,int r,char **c,int *t,void **v);

#endif /* SHOW_H */
