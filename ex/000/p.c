#include "p.h"
#include <stdio.h>
#include <stdlib.h>

static int SR[12][10]={
{-1,-1,3,-1,4,-1,-1,0,1,2},
{6,-1,-1,-1,-1,5,-1,-1,-1,-1},
{8,10,-1,9,-1,7,-1,-1,-1,-1},
{13,12,-1,14,-1,11,-1,-1,-1,-1},
{-1,-1,18,-1,19,-1,-1,15,16,17},
{22,21,-1,23,-1,20,-1,-1,-1,-1},
{-1,-1,26,-1,27,-1,-1,-1,24,25},
{-1,-1,29,-1,30,-1,-1,-1,-1,28},
{32,-1,-1,31,-1,-1,-1,-1,-1,-1},
{34,36,-1,35,-1,33,-1,-1,-1,-1},
{39,38,-1,40,-1,37,-1,-1,-1,-1},
{43,42,-1,44,-1,41,-1,-1,-1,-1}
};

static int TA[45]={2,2,2,1,1,0,1,0,0,0,1,0,0,0,0,2,2,2,1,1,0,0,0,0,2,2,1,1,2,1,1,1,1,0,0,0,1,0,0,0,0,0,0,0,0};
static int TG[45]={1,2,3,4,5,0,6,0,0,0,7,0,0,0,0,8,2,3,4,5,0,0,0,0,9,3,4,5,10,4,5,11,6,0,0,0,7,0,0,0,0,0,0,0,0};
static int TR[45]={0,2,4,5,6,0,1,2,2,2,3,4,4,4,4,5,2,4,5,6,6,6,6,6,1,4,5,6,3,5,6,5,1,1,1,1,3,3,3,3,3,5,5,5,5};

static int RPOP[7]={1,3,1,3,1,3,1};
static int LEFT[7]={T006,T007,T007,T008,T008,T009,T009};

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
static void r002() { /* e > t */
}
static void r003() { /* t > t '*' f */
  int a,b;
  b=vv[vi--];
  vi--;
  a=vv[vi];
  vv[vi]=a*b;
}
static void r004() { /* t > f */
}
static void r005() { /* f > '(' e ')' */
  --vi;
  vv[vi-1]=vv[vi];
  --vi;
}
static void r006() { /* f > n */
}

static void (*R[7])()={r000,r001,r002,r003,r004,r005,r006};

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
