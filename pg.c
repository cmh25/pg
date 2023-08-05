#include "pg.h"
#include "show.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

static rule RA[1024];
static int RN=1;

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
static char *NT[256],*T[256];
static int NTC,TC;
static int ist(char *s) { int i; for(i=0;i<TC;i++) if(s==T[i]) return 1; return 0; }
static int isnt(char *s) { int i; for(i=0;i<NTC;i++) if(s==NT[i]) return 1; return 0; }
static void addnt(char *s) { if(isnt(s)) return; NT[NTC++]=s; }
static void addt(char *s) { if(isnt(s)) return; if(ist(s)) return; T[TC++]=s; }

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
  rule *rp;
  for(i=0;i<N;i++) {
    if(S[i]!=s) continue;
    rp=&RA[R[i]];
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
  rule *rp;

  c=ufrhs(s,u);
  for(i=0;i<c;i++) {
    if(!isnt(u[i])) continue;
    for(j=0;j<RN;j++) {
      rp=&RA[j];
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
  rule *rp;
  GN=N; /* in case this state is not added */
  GTN=TN; /* in case this state is not added */
  for(i=0;i<N;i++) {
    if(S[i]!=s) continue;
    rp=&RA[R[i]];
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
    int s=0;
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
  char b[1024],p[256],q[256],r[1024],*s;
  if(!(fp=fopen(g,"r"))) { fprintf(stderr,"error: file not found\n"); exit(1); }
  while(xfgets(b,1024,fp)) {
    if(!*b) continue;
    if('#'==*b) continue;
    if('|'==*b) strcpy(r,b+1);
    else {
      strcpy(p,split(b,' '));
      strcpy(q,split(0,' '));
      strcpy(r,b+strlen(p)+strlen(q)+2);
    }
    s=split(r,'|');
    sprintf(RA[RN].r,"%s %s %s",p,q,s?s:"");
    cs(RA[RN++].r);
    while((s=split(0,'|'))) {
      sprintf(RA[RN].r,"%s %s %s",p,q,s?s:"");
      cs(RA[RN++].r);
    }
  }
  fclose(fp);
}

static char *FK[256];
static char *FV[256][32];
static int FC[256];
static int FN;
static char *F[256];
static int firsti(char *p) {
  int i;
  for(i=0;i<FN;i++) if(p==FK[i]) return i;
  return -1;
}
static int infirst(char *p, char *q) {
  int i,j;
  i=firsti(p);
  for(j=0;j<FC[i];j++) if(q==FV[i][j]) return 1;
  return 0;
}
static void firstgen() {
  int i,j,k,f=1,n,m,s;
  char *p,*q;
  for(i=0;i<TC;i++) { FK[FN]=T[i]; FV[FN][FC[FN]++]=T[i]; FN++; }
  for(i=0;i<NTC;i++) {
    FK[FN]=NT[i];
    for(j=0;j<RN;j++) if(NT[i]==RA[j].lhs && !RA[j].rhsi) FV[FN][FC[FN]++]=0;
    ++FN;
  }
  while(f) {
    f=0;
    for(i=0;i<NTC;i++) {
      p=NT[i];
      for(j=0;j<RN;j++) {
        if(p!=RA[j].lhs) continue;
        n=firsti(p);
        for(k=0;k<RA[j].rhsi;k++) {
          q=RA[j].rhs[k];
          m=firsti(q);
          for(s=0;s<FC[m];s++) if(!infirst(p,FV[m][s])) { FV[n][FC[n]++]=FV[m][s]; f=1; }
          if(!infirst(q,0)) break;
        }
      }
    }
  }
}
static int first(char **p, int c) {
  int i,j,n,k=0,b=0,m,f;
  for(i=0;i<c;i++) {
    n=firsti(p[i]);
    for(j=0;j<FC[n];j++) {
      if(!FV[n][j]) {
        F[k++]=FV[n][j];
        b=1;
      }
      else {
        f=0; for(m=0;m<k;m++) if(F[m]==FV[n][j]) f=1;
        if(!f) F[k++]=FV[n][j];
      }
    }
    if(b) break;
  }
  return k;
}
void pgprintfirst() {
  int i,j;
  for(i=0;i<FN;i++) {
    if(ist(FK[i])) continue;
    if(FK[i]==str("$a")) continue;
    printf("first(%s) =",FK[i]);
    for(j=0;j<FC[i];j++) printf(" %s",FV[i][j]);
    printf("\n");
  }
}

/* follow */
static char *AK[256];
static char *AV[256][32];
static int AC[256];
static int followi(char *p) {
  int i;
  for(i=0;i<NTC;i++) if(p==AK[i]) return i;
  return -1;
}
static int infollow(char *p, char *q) {
  int i,j;
  i=followi(p);
  for(j=0;j<AC[i];j++) if(q==AV[i][j]) return 1;
  return 0;
}
static void followgen() {
  int i,j,k,n,s,m,f=1,b;
  char *p;
  for(i=1;i<NTC;i++) AK[i]=NT[i];
  AV[1][0]=str("$e");
  AC[1]=1;
  for(i=1;i<NTC;i++) {
    p=NT[i];
    for(j=0;j<RN;j++) {
      for(k=0;k<RA[j].rhsi;k++) {
        if(p!=RA[j].rhs[k]) continue;
        if(k==RA[j].rhsi-1) continue;
        /* A > aBb : add first(b) to follow(B) */
        n=first(&RA[j].rhs[k+1],RA[j].rhsi-k-1);
        m=followi(p);
        for(s=0;s<n;s++) if(F[s] && !infollow(p,F[s])) AV[m][AC[m]++]=F[s];
      }
    }
  }
  while(f) {
    f=0;
    for(i=1;i<NTC;i++) {
      p=NT[i];
      for(j=0;j<RN;j++) {
        for(k=0;k<RA[j].rhsi;k++) {
          if(p!=RA[j].rhs[k]) continue;

          if(k==RA[j].rhsi-1); /* A > aB */
          else { /* A > aBb */
            n=first(&RA[j].rhs[k+1],RA[j].rhsi-k-1);
            b=0; for(s=0;s<n;s++) if(!F[s]) b=1;
            if(!b) continue;
          }
          /* add follow(A) to follow(B) */
          n=followi(RA[j].lhs);
          m=followi(p);
          for(s=0;s<AC[n];s++) {
            if(!infollow(p,AV[n][s])) {
              AV[m][AC[m]++]=AV[n][s];
              f=1;
            }
          }
        }

      }
    }
  }
}
void pgprintfollow() {
  int i,j;
  for(i=1;i<NTC;i++) {
    printf("follow(%s) =",AK[i]);
    for(j=0;j<AC[i];j++) printf(" %s",AV[i][j]);
    printf("\n");
  }
  printf("\n");
}

void pgparse() {
  int i;
  char *p,b[1024];
  addt(str("$e"));
  addnt(str("$a"));
  for(i=1;i<RN;i++) {
    strncpy(b,RA[i].r,1024);
    p=split(b,' '); if(!p) continue; addnt(str(p));
  }
  for(i=1;i<RN;i++) {
    strncpy(b,RA[i].r,1024);
    p=split(b,' '); if(!p) continue; RA[i].lhs=str(p);
    p=split(0,' '); if(!p) continue; RA[i].op=str(p);
    p=split(0,' '); while(p) {
      RA[i].rhs[RA[i].rhsi++]=str(p);
      addt(str(p));
      p=split(0,' ');
    }
  }
  RA[0].lhs=str("$a");
  RA[0].op=RA[1].op;
  RA[0].rhs[RA[0].rhsi++]=RA[1].lhs;
  sprintf(RA[0].r,"%s %s %s",RA[0].lhs,RA[0].op,RA[0].rhs[0]);
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
  printf("n:"); for(i=0;i<NTC;i++) printf(" %s",NT[i]); printf("\n");
  printf("t:"); for(i=0;i<TC;i++) printf(" %s",escape(T[i])); printf("\n");
  printf("-------------------------\n");
  for(i=0;i<RN;i++) printf("%2d. %s\n",i,escape(RA[i].r));
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

  firstgen();
  followgen();
}

void pgprints(int i) {
  int j,k;
  rule *rp;
  printf("---------- state %d ----------\n",i);
  for(j=0;j<N;j++) {
    if(S[j]!=i) continue;
    rp=&RA[R[j]];
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
