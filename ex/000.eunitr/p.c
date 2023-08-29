#include "p.h"
#include <stdio.h>
#include <stdlib.h>

static int SR[14][11]={
{-1,-1,3,-1,4,-1,-1,-1,-1,-1,-1},
{0},
{0},
{0},
{-1,-1,18,-1,19,-1,-1,-1,-1,-1,-1},
{0},
{-1,-1,26,-1,27,-1,-1,-1,-1,-1,-1},
{-1,-1,29,-1,30,-1,-1,-1,-1,-1,-1},
{0},
{34,36,-1,35,-1,33,-1,34,34,34,34},
{39,38,-1,40,-1,37,-1,39,39,39,39},
{43,42,-1,44,-1,41,-1,43,43,43,43},
{46,47,-1,-1,-1,45,-1,46,46,46,46},
{49,50,-1,48,-1,-1,-1,49,49,49,49}
};

static int TA[51]={2,2,2,1,1,0,1,0,0,0,1,0,0,0,0,2,2,2,1,1,0,0,0,0,2,2,1,1,2,1,1,1,1,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1};
static int TG[51]={12,12,12,4,12,0,6,0,0,0,7,0,0,0,0,13,13,13,4,13,0,0,0,0,9,9,4,9,10,4,10,11,6,0,0,0,7,0,0,0,0,0,0,0,0,0,6,7,11,6,7};
static int TR[51]={0,2,4,5,6,0,1,2,2,2,3,4,4,4,4,5,2,4,5,6,6,6,6,6,1,4,5,6,3,5,6,5,1,1,1,1,3,3,3,3,3,5,5,5,5,0,1,3,5,1,3};

static int RPOP[7]={1,3,1,3,1,3,1};
static int LEFT[7]={T006,T004,T004,T004,T004,T004,T004};

int *pgta; /* tokens */
int *pgva; /* values */
int pgi;   /* tv index */
static int *vv; /* value stack */
static size_t vi=-1,vm=2; /* value stack index and max */

static void r000() { /* $a > e */
  printf("%d\n",vv[vi]);
}
static void r001() { /* e > e '+' t */
  int a,b;
  b=vv[vi--];
  vi--;
  a=vv[vi];
  vv[vi]=a+b;
}
static void r003() { /* t > t '*' f */
  int a,b;
  b=vv[vi--];
  vi--;
  a=vv[vi];
  vv[vi]=a*b;
}
static void r005() { /* f > '(' e ')' */
  --vi;
  vv[vi-1]=vv[vi];
  --vi;
}

static void (*R[7])()={r000,r001,0,r003,0,r005,0};

void pgpush(int t, int v) {
  static size_t m=256;
  if(!pgta) pgta=(int*)malloc(m*sizeof(int));
  if(!pgva) pgva=(int*)malloc(m*sizeof(int));
  if(pgi==m) {
    m<<=1;
    pgta=(int*)realloc(pgta,m*sizeof(int));
    pgva=(int*)realloc(pgva,m*sizeof(int));
  }
  pgta[pgi]=t;
  pgva[pgi++]=v;
}

void parse() {
  int i=0,j,r;
  static int *ss=0,*st=0;
  static size_t sm=2;
  size_t si=0;
  vi=-1;
  if(!vv) vv=(int*)malloc(vm*sizeof(int));
  if(!ss) ss=(int*)malloc(sm*sizeof(int));
  if(!st) st=(int*)malloc(sm*sizeof(int));
  ss[si]=0;
  while(i<pgi) {
    if(vi==vm) { vm<<=1; vv=(int*)realloc(vv,vm*sizeof(int)); }
    if(si==sm) {
      sm<<=1;
      ss=(int*)realloc(ss,sm*sizeof(int));
      st=(int*)realloc(st,sm*sizeof(int));
    }
    j=SR[ss[si]][pgta[i]];
    if(j==-1) { printf("parse\n"); return; }
    if(TA[j]) {      /* shift */
      ss[++si]=TG[j];
      st[si]=pgta[i];
      vv[++vi]=pgva[i++];
    } else {         /* reduce */
      r=TR[j];
      (*R[r])();
      if(!r) return; /* accept */
      si-=RPOP[r];
      j=SR[ss[si]][LEFT[r]];
      if(j==-1) { printf("parse2\n"); return; }
      ss[++si]=TG[j];
      st[si]=LEFT[r];
    }
  }
}
