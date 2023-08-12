#include "p.h"
#include <stdio.h>

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
static int LEFT[7]={N006,N007,N007,N008,N008,N009,N009};

int pgta[512]; /* tokens */
int pgva[512]; /* values */
int pgi=0;     /* tv index */
static int vv[512],vi=-1; /* value stack */

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

void parse() {
  int i=0,j,r,ss[1024],st[1024],si=0;
  vi=-1;
  ss[si]=0;
  for(;;) {
    j=SR[ss[si]][pgta[i]];
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
      ss[++si]=TG[j];
      st[si]=LEFT[r];
    }
  }
}
