#include "pg.h"
#include "show.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define BS 1024

static char b[BS];
static rule ra[1024],*rp;
static int ri=1;

/* states */
static int S[10240]; /* state */
static int R[10240]; /* rule */
static int M[10240]; /* mark */
static int N;        /* rowcount */
static int SN;       /* states count */

/* transitions */
static int   TS[10240]; /* state */
static char *TT[10240]; /* token */
static int   TA[10240]; /* action 0=reduce 1=shift 2=goto */
static int   TG[10240]; /* goto state */
static int   TR[10240]; /* rule */
static int   TN;

/* goto markers */
static int GN;
static int GTN;

/* strings */
static char* str(char *s) {
  static int i,c;
  static char *t[256];
  for(i=0;i<c;i++) if(!strcmp(s,t[i])) return t[i];
  t[c]=strdup(s);
  return t[c++];
}

/* nonterminals and terminals */
static char *nt[256],*t[256];
static int nti,ti;
static int isnt(char *s) {
  int i;
  for(i=0;i<nti;i++) if(s==nt[i]) return 1;
  return 0;
}
static void addnt(char *s) {
  int i;
  for(i=0;i<nti;i++) if(nt[i]==s) return;
  nt[nti++]=s;
}
static void addt(char *s) {
  int i;
  for(i=0;i<nti;i++) if(nt[i]==s) return;
  for(i=0;i<ti;i++) if(t[i]==s) return;
  t[ti++]=s;
}

/* compact spaces */
static void cs(char *s) {
  char *p=s,*q=s;
  if(!s) return;
  while(*q&&isblank(*q)) q++;
  while(*q) {
    *p++ = isblank(*q) ? ' ' : *q;
    if(isblank(*q)) while(isblank(*q)) q++;
    else q++;
  }
  *p=0;
  if(p!=s&&isblank(*--p)) *p=0;
}

static char* xfgets(char *s, int n, FILE *f) {
  char *r = fgets(s,n,f);
  s[strlen(s)-1]=0;
  cs(s);
  return r;
}

/* production in state */
static int ins(int s, int r, int m) {
  int i;
  for(i=0;i<N;i++) {
    if(S[i]!=s) continue;
    if(R[i]==r&&M[i]==m) return 1;
  }
  return 0;
}

/* unique first righthand side */
int ufrhs(int s, char **u) {
  int i,j,f,c=0;
  for(i=0;i<N;i++) {
    if(S[i]!=s) continue;
    rp=&ra[R[i]];
    f=0; for(j=0;j<c;j++) if(u[j]==rp->rhs[M[i]]) f=1;
    if(!f) u[c++]=rp->rhs[M[i]];
  }
  return c;
}

static void addstate(int s, int r, int m) {
  S[N]=s;
  R[N]=r;
  M[N++]=m;
}

static void closure(int s) {
  int i,j,k,c,f;
  char *u[128];
  
  c=ufrhs(s,u);
  for(i=0;i<c;i++) {
    if(!isnt(u[i])) continue;
    for(j=0;j<ri;j++) {
      rp=&ra[j];
      if(u[i]!=rp->lhs) continue;
      if(ins(s,j,0)) continue;
      addstate(s,j,0);
      if(isnt(rp->rhs[0])) {
        f=0; for(k=0;k<c;k++) if(u[k]==rp->rhs[0]) f=1;
        if(!f) u[c++]=rp->rhs[0];
      }
    }
  }
}

static void addtrans(int s, char *t, int a, int g, int r) {
  int i;
  for(i=0;i<TN;i++) if(TS[i]==s&&TT[i]==t) return;
  TS[TN]=s;
  TT[TN]=t;
  TA[TN]=a;
  TG[TN]=g;
  TR[TN++]=r;
}

static void goto_(int s, char *p) {
  int i,j,f=0,b,c=0,f2;
  char *rs,*nta[128];
  GN=N; /* in case this state is not added */
  GTN=TN; /* in case this state is not added */
  for(i=0;i<N;i++) {
    if(S[i]!=s) continue;
    rp=&ra[R[i]];
    rs=rp->rhs[M[i]];
    if(rp->rhsi<=M[i]) { /* default reduce rule */
      addtrans(s,rs?rs:str(""),0,0,R[i]);
      continue;
    }
    else if(p==rs) {
      if(!ins(SN,R[i],M[i])) {
        f=1;
        addstate(SN,R[i],M[i]+1);
        if((b=isnt(rs))) {
          f2=0; for(j=0;j<c;j++) if(nta[j]==rs) f2=1;
          if(f2) continue;
          else nta[c++]=rs;
        }
        addtrans(s,rs?rs:str(""),b?2:1,SN,R[i]);
      }
    }
  }
  if(f) closure(SN);
}

static char* split(char *p, char c) {
    int i,n,s=0;
    static char *q=0;
    if(p) q=p;
    else p=q;
    for(;*q;q++) {
      if(s==0) {
        if(*q=='<') s=1;
        else if(*q=='\'') s=2;
        else if(*q=='"') s=3;
        else if(*q==c) { *q++=0; break; }
      }
      else if(s==1) { if(*q=='>') s=0; }  /* inside <> */
      else if(s==2) { if(*q=='\'') s=0; } /* inside '' */
      else if(s==3) { if(*q=='"') s=0; }  /* inside "" */
    }
    return p==q ? 0 : p;
}

void pgread(char *g) {
  FILE *fp;
  char p[256],q[256],r[1024],*s;
  if(!(fp=fopen(g,"r"))) { fprintf(stderr,"error: file not found\n"); exit(1); }
  while(xfgets(b,BS,fp)) {
    if(!*b) continue;
    if('#'==*b) continue;
    if('|'==*b) strcpy(r,b+1);
    else {
      strcpy(p,split(b,' '));
      strcpy(q,split(0,' '));
      strcpy(r,b+strlen(p)+strlen(q)+2);
    }
    s=split(r,'|');
    sprintf(ra[ri].r,"%s %s %s",p,q,s?s:""); 
    cs(ra[ri++].r);
    while((s=split(0,'|'))) {
      sprintf(ra[ri].r,"%s %s %s",p,q,s?s:""); 
      cs(ra[ri++].r);
    }
  }
  fclose(fp);
}

void pgparse() {
  int i;
  char *p;
  addnt(str("$e"));
  addt(str("$a"));
  for(i=1;i<ri;i++) {
    strncpy(b,ra[i].r,BS);
    p=split(b,' '); if(!p) continue; addnt(str(p));
  }
  for(i=1;i<ri;i++) {
    strncpy(b,ra[i].r,BS);
    p=split(b,' '); if(!p) continue; ra[i].lhs=str(p);
    p=split(0,' '); if(!p) continue; ra[i].op=str(p);
    p=split(0,' '); while(p) {
      ra[i].rhs[ra[i].rhsi++]=str(p);
      addt(str(p));
      p=split(0,' ');
    }
  }
  ra[0].lhs=str("$a");
  ra[0].op=ra[1].op;
  ra[0].rhs[ra[0].rhsi++]=ra[1].lhs;
  sprintf(ra[0].r,"%s %s %s",ra[0].lhs,ra[0].op,ra[0].rhs[0]);
}

static char esc[256];
static char *escape(char *s) {
  int i,j,n;
  if(!s) return 0;
  n=strlen(s);
  j=0;
  for(i=0;i<n;i++) {
    if(s[i]=='\n') { esc[j++]='\\'; esc[j++]='n'; }
    else esc[j++]=s[i];
  }
  esc[j]=0;
  return esc;
}

void pgreport() {
  int i;
  printf("n:"); for(i=0;i<nti;i++) printf(" %s",nt[i]); printf("\n");
  printf("t:"); for(i=0;i<ti;i++) printf(" %s",escape(t[i])); printf("\n");
  printf("-------------------------\n");
  for(i=0;i<ri;i++) printf("%2d. %s\n",i,escape(ra[i].r));
}

/* goto items in states */
static int gins() {
  int i,j,k,n;
  for(i=0;i<SN-1;i++) {
    n=GN;
    for(j=0;j<GN;j++) {
      if(S[j]!=i) continue;
      for(k=GN;k<N;k++) if(R[j]==R[k]&&M[j]==M[k]) ++n;
    }
    if(N!=n) continue;
    return i;
  }
  return -1;
}

void pgbuild() {
  int i,j,k,c,s;
  char *u[128];

  /* state 0 */
  N=SN=1;
  closure(0);

  for(i=0;i<SN;i++) {
    c=ufrhs(i,u);
    for(j=0;j<c;j++) {
      goto_(i,u[j]);
      if((s=gins())<0) SN++;
      else { N=GN; for(k=GTN;k<TN;k++) TG[k]=s; }
    }
  }
}

void pgprints(int i) {
  int j,k;
  printf("---------- state %d ----------\n",i);
  for(j=0;j<N;j++) {
    if(S[j]!=i) continue;
    rp=&ra[R[j]];
    printf("%s %s",rp->lhs,rp->op);
    for(k=0;k<rp->rhsi;k++) {
      if(k==M[j]) printf(" .");
      printf(" %s",escape(rp->rhs[k]));
    }
    if(M[j]==rp->rhsi) printf(" .");
    printf("\n");
  }
}

void pgprint() {
  int i;
  for(i=0;i<SN;i++) pgprints(i);
}

void pgprintst() {
  char *c[] = {"state","rule","marker"};
  int t[] = {1,1,1};
  void *v[] = {S,R,M};
  char *a = show(3,N,c,t,v);
  if(a) { printf("%s",a); free(a); }
}

void pgprintt() {
  char *c[] = {"state","token","action","goto","rule"};
  int t[] = {1,4,1,1,1};
  void *v[] = {TS,TT,TA,TG,TR};
  char *a = show(5,TN,c,t,v);
  if(a) { printf("%s",a); free(a); }
}
