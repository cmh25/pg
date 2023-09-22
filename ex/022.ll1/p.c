#include "p.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/*
# no operator precedence
e > o ez
ez > | V e
o > N
o > ( e )
*/

static int LL[4][9]={
{-1,-1,-1,-1,-1,0,0,-1,-1},
{-1,-1,-1,-1,-1,1,1,-1,-1},
{-1,-1,-1,-1,3,-1,-1,2,2},
{-1,-1,-1,-1,-1,4,5,-1,-1}
};

static int RT[6][3]={
{T001},
{T003,T002},
{-1},
{T004,T001},
{T005},
{T006,T001,T007}
};

static int RC[6]={1,2,0,2,1,3};
typedef struct { char v; int n; } pn;
static int S[1024],R[1024];
static pn V[1024];
static int si=-1,ri=-1,vi=-1;

static void r000() { /* $a > e */
  printf("%d\n",V[vi].n);
}
static void r001() { /* e > o ez */
  pn b=V[vi--];
  if(b.v=='+') V[vi].n+=b.n;
  else if(b.v=='-') V[vi].n-=b.n;
  else if(b.v=='*') V[vi].n*=b.n;
  else if(b.v=='/') V[vi].n/=b.n;
}
static void r002() { /* ez > */
}
static void r003() { /* ez > V e */
  pn b;
  b=V[vi--];
  V[vi].v=V[vi].n;
  V[vi].n=b.n;
}
static void r004() { /* o > N */
}
static void r005() { /* o > ( e ) */
  vi-=2;
  V[vi]=V[vi+1];
}

static void (*F[6])()={r000,r001,r002,r003,r004,r005};

static int t[1024],ti,tc;
static int v[1024];

static void push(int tt, int tv) {
  t[tc]=tt;
  v[tc++]=tv;
}

static char* gn(char *p) {
  char c,*s=p;
  if(*p=='-')p++;
  while(*p&&isdigit(*p)) p++;
  c=*p; *p=0;
  push(T005,atoi(s));
  *p=c;
  return p;
}

static int lex(char *p) {
  int s;
  while(1) {
    if(!*p) break;
    s=*p==' ';
    while(*p==' ') ++p;
    if(isdigit(*p)||(s&&*p=='-'&&isdigit(p[1]))) p=gn(p);
    else if(*p=='+'||*p=='-'||*p=='*'||*p=='/') { push(T004,*p); ++p; }
    else if(*p=='(') { ++p; push(T006,0); }
    else if(*p==')') { ++p; push(T007,0); }
    else if(*p=='\n') { push(T008,0); break; }
    else if(*p=='\\'&&*(p+1)=='\\') exit(0);
    else { printf("lex\n"); return 0; }
  }
  return 1;
}

void pgparse(char *p) {
  int i,j,r;
  ti=0;tc=0;si=-1;ri=-1;vi=-1;
  memset(V,1024,sizeof(pn));
  if(!lex(p)) return;
  if(tc==1) return;
  S[++si]=T008; /* $e */
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
      if(!RC[r]) V[++vi].n=0; /* empty */
      for(j=RC[r]-1;j>=0;j--) S[++si]=RT[r][j];
    }
    while(S[si]==-2) { (*F[R[ri--]])(); --si; }
    if(si<0) { --vi; break; }
  }
}
