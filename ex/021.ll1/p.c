#include "p.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

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
  V[++vi].n=0;
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
  V[++vi].n=0;
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

static void push(int tt, int tv) {
  t[tc]=tt;
  v[tc++]=tv;
}

static char* gn(char *p) {
  char c,*s=p;
  if(*p=='-')p++;
  while(*p&&isdigit(*p++));
  c=*--p;
  *p=0;
  push(T010,atoi(s));
  *p=c;
  return p;
}

static int lex(char *p) {
  int s;
  while(1) {
    if(!*p) break;
    s=*p==' ';
    while(*p==' ') p++;
    if(isdigit(*p)||(s&&*p=='-'&&isdigit(p[1]))) p=gn(p);
    else if(*p=='+') { ++p; push(T011,0); }
    else if(*p=='-') { ++p; push(T012,0); }
    else if(*p=='*') { ++p; push(T013,0); }
    else if(*p=='/') { ++p; push(T014,0); }
    else if(*p=='(') { ++p; push(T008,0); }
    else if(*p==')') { ++p; push(T009,0); }
    else if(*p=='\n') { push(T015,0); break; }
    else if(*p=='\\'&&*(p+1)=='\\') exit(0);
    else { printf("lex\n"); return 0; }
  }
  return 1;
}

void pgparse(char *p) {
  int i,j,r;
  ti=0;tc=0;si=-1;ri=-1;vi=-1;
  memset(V,0,sizeof(V));
  if(!lex(p)) return;
  if(tc==1) return;
  S[++si]=T000; /* $a */
  for(i=0;;i++) {
    if(S[si]==t[ti]) {
      V[++vi].n=v[ti++];
      --si;
    }
    else {
      r=LL[S[si--]][t[ti]];
      if(r==-1) { printf("parse\n"); break; }
      R[++ri]=r;
      S[++si]=-2; /* reduction marker */
      for(j=RC[r]-1;j>=0;j--) S[++si]=RT[r][j];
    }
    while(S[si]==-2) { (*F[R[ri--]])(); --si; }
    if(si<0) { --vi; break; }
  }
}
