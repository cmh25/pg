#include "p.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
e > t tz
t > f fz
tz > | a t tz
f > ( e ) | N
fz > | m f fz
a > + | -
m > * | /
*/

static int LL[8][16]={
{-1,-1,-1,-1,-1,-1,-1,-1,0,-1,0,-1,-1,-1,-1,-1},
{-1,-1,-1,-1,-1,-1,-1,-1,1,-1,1,-1,-1,-1,-1,-1},
{-1,-1,-1,-1,-1,-1,-1,-1,2,-1,2,-1,-1,-1,-1,-1},
{-1,-1,-1,-1,-1,-1,-1,-1,-1,3,-1,4,4,-1,-1,3},
{-1,-1,-1,-1,-1,-1,-1,-1,5,-1,6,-1,-1,-1,-1,-1},
{-1,-1,-1,-1,-1,-1,-1,-1,-1,7,-1,7,7,8,8,7},
{-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,9,10,-1,-1,-1},
{-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,11,12,-1}
};

static int RT[13][3]={
{T001},
{T002,T003},
{T004,T005},
{-1},
{T006,T002,T003},
{T008,T001,T009},
{T010},
{-1},
{T007,T004,T005},
{T011},
{T012},
{T013},
{T014}
};

static int RC[13]={1,2,2,0,3,3,1,0,3,1,1,1,1};
typedef struct { char v; int n; } pn;
static int S[1024],R[1024];
static pn V[1024];
static int si=-1,ri=-1,vi=-1;

static void r000() { /* $a > e */
  printf("%d\n",V[vi].n);
}
static void r001() { /* e > t tz */
  pn b=V[vi--];
  if(b.v=='+') V[vi].n+=b.n;
  if(b.v=='-') V[vi].n-=b.n;
}
static void r002() { /* t > f fz */
  pn b=V[vi--];
  if(b.v=='*') V[vi].n*=b.n;
  if(b.v=='/') V[vi].n/=b.n;
}
static void r003() { /* tz > */
}
static void r004() { /* tz > a t tz */
  pn c=V[vi--];
  pn b=V[vi--];
  if(c.v=='+') b.n+=c.n;
  if(c.v=='-') b.n-=c.n;
  V[vi].n=b.n;
}
static void r005() { /* f > ( e ) */
  vi-=2;
  V[vi]=V[vi+1];
}
static void r006() { /* f > N */
}
static void r007() { /* fz > */
}
static void r008() { /* fz > m f fz */
  pn c=V[vi--];
  pn b=V[vi--];
  if(c.v=='*') b.n*=c.n;
  if(c.v=='/') b.n/=c.n;
  V[vi].n=b.n;
}
static void r009() { /* a > + */
  V[vi].v='+';
}
static void r010() { /* a > - */
  V[vi].v='-';
}
static void r011() { /* m > * */
  V[vi].v='*';
}
static void r012() { /* m > / */
  V[vi].v='/';
}

static void (*F[13])()={r000,r001,r002,r003,r004,r005,r006,r007,r008,r009,r010,r011,r012};

static int t[1024],ti,tc;
static int v[1024];

void pgreset() {
  ti=0;tc=0;si=-1;ri=-1;vi=-1;
  memset(V,0,sizeof(V));
}

void pgpush(int tt, int tv) {
  t[tc]=tt;
  v[tc++]=tv;
}

void pgparse() {
  int i,j,r;
  if(tc==1) return;
  S[++si]=T015; /* $e */
  S[++si]=T000; /* $a */
  for(i=0;;i++) {
    if(S[si]==t[ti]) {
      V[++vi].n=v[ti];
      --si; ++ti;
      while(S[si]==-2) { (*F[R[ri--]])(); --si; }
      if(si<0) { --vi; break; }
    }
    else {
      r=LL[S[si--]][t[ti]];
      if(r==-1) { printf("parse\n"); break; }
      R[++ri]=r;
      S[++si]=-2; /* reduction marker */
      if(!RC[r]) V[++vi].n=0; /* empty */
      for(j=RC[r]-1;j>=0;j--)
        S[++si]=RT[r][j];
      while(S[si]==-2) { (*F[R[ri--]])(); --si; }
    }
  }
}
