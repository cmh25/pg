#include "show.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char b[2048];

static void* xmalloc(size_t s) {  
  char *r = malloc(s);
  if(!r) { fprintf(stderr, "error: malloc failed\n"); exit(1); }
  return r;
}

static char* xstrdup(char *s) {
  char *r = strdup(s);
  if(!r) { fprintf(stderr, "error: strdup failed\n"); exit(1); }
  return r;
}

/* n: number of columns
   r: number of rows
   c: column names
   t: column types
   v: column data
    : returns string representation of table 
   caller should free result */
char* show(int n,int r,char **c,int *t,void **v) {
  int i,j,k,p=4;
  char *a;
  col *cc = xmalloc(n*sizeof(col));

  /* string representation of column data */
  for(i=0;i<n;i++) {
    cc[i] = (col){c[i],t[i],v[i],xmalloc(r*sizeof(char*)),0};
    switch(t[i]) {
    case 1: for(j=0;j<r;j++) { sprintf(b,"%d",((int*)cc[i].v)[j]); cc[i].o[j]=xstrdup(b); } break;
    case 2: for(j=0;j<r;j++) { sprintf(b,"%0.*g",15,((double*)cc[i].v)[j]); cc[i].o[j]=xstrdup(b); } break;
    case 3: for(j=0;j<r;j++) { sprintf(b,"%c",((char*)cc[i].v)[j]); cc[i].o[j]=xstrdup(b); } break;
    case 4: for(j=0;j<r;j++) { cc[i].o[j]=xstrdup(((char**)cc[i].v)[j]); } break;
    default: fprintf(stderr,"error: invalid column type [%d]\n", t[i]); return 0;
    }
  }

  /* lengths */
  for(i=0;i<n;i++) {
    cc[i].m=strlen(cc[i].c);
    for(j=0;j<r;j++) { k=strlen(cc[i].o[j]); if(cc[i].m<k) cc[i].m=k; }
    p+=(r+2)*(cc[i].m+n+1);
  }

  /* build result */
  a=xmalloc(p);
  k=0;
  for(i=0;i<n;i++) k+=sprintf(a+k,"%-*s ",cc[i].m,cc[i].c);
  k+=sprintf(a+k,"\n");
  for(i=0;i<n;i++) { for(j=0;j<cc[i].m;j++) k+=sprintf(a+k,"-"); k+=sprintf(a+k," "); }
  k+=sprintf(a+k,"\n");
  for(i=0;i<r;i++) {
    for(j=0;j<n;j++) {
      if(cc[j].t==4) k+=sprintf(a+k,"%-*s ",cc[j].m,cc[j].o[i]);
      else k+=sprintf(a+k,"%*s ",cc[j].m,cc[j].o[i]);
    }
    k+=sprintf(a+k,"\n");
  }

  for(i=0;i<n;i++) { for(j=0;j<r;j++) free(cc[i].o[j]); free(cc[i].o); }
  free(cc);

  return a;
}
