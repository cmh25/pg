#include "pg.h"
#include "show.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

static int gmode;

static rule RA[1024];
static int RN=1;

/* states */
static int S[10240]; /* state */
static int R[10240]; /* rule */
static int M[10240]; /* mark */
static int D[10240]; /* deleted */
static int N;        /* rowcount */
static int SN;       /* states count */
static char *C[10240][32]; /* context=first(C) first(0)=$e */
static int CN[10240];

/* transitions */
static int   TS[10240]; /* state */
static char *TT[10240]; /* token */
static int   TA[10240]; /* action 0=reduce 1=shift 2=goto */
static int   TG[10240]; /* goto state */
static int   TR[10240]; /* rule */
static int   TM[10240]; /* mark */
static int   TD[10240]; /* deleted */
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

/* leaf for eunitr */
static char *LF[256];
static int LFN;

static int conflicts;
static int eunitr;

static int derives(char *a, char *b);

/* compact space */
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
//static int pins(int s, int r, int m) {
//  int i;
//  for(i=0;i<N;i++) if(S[i]==s&&R[i]==r&&M[i]==m) return 1;
//  return 0;
//}
/* production in state */
static int pins(int s, int r, int m, char **c, int cn) {
  int i,j;
  for(i=0;i<N;i++) {
    if(S[i]==s&&R[i]==r&&M[i]==m&&CN[i]==cn) {
      for(j=0;j<cn;j++)
        if(C[i][j]!=c[j]) break;
      if(j==cn) return 1;
    }
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
    for(f=0,j=0;j<c;j++) if(u[j]==rp->rhs[M[i]]) f=1;
    if(!f) u[c++]=rp->rhs[M[i]];
  }
  return c;
}

/* first() */
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
  int i,j,n,k=0,b=0,m;
  for(i=0;i<c;i++) {
    if(ist(p[i])) { F[k++]=p[i]; return k; }
    n=firsti(p[i]);
    for(j=0;j<FC[n];j++) {
      if(!FV[n][j]) { F[k++]=0; b=1; }
      else {
        for(m=0;m<k;m++) if(F[m]==FV[n][j]) break;
        if(m==k) F[k++]=FV[n][j];
      }
    }
    if(!b) break;
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

/* follow() */
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
  int i,j,k,n,s,m,f=1;
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
            for(s=0;s<n;s++) if(!F[s]) break;
            if(s==n) continue;
          }
          /* add follow(A) to follow(B) */
          n=followi(RA[j].lhs);
          m=followi(p);
          for(s=0;s<AC[n];s++)
            if(!infollow(p,AV[n][s])) { AV[m][AC[m]++]=AV[n][s]; f=1; }
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

static void propagatectx(int s, int r, int m) {
  int i,j,k,u=0;
  char *n=RA[r].rhs[m];
  for(i=0;i<N;i++) {
    if(S[i]!=s) continue;
    if(R[i]==r&&M[i]==m) {
      for(j=i+1;j<N;j++) {
        if(S[j]!=s) continue;
        if(n==RA[R[j]].lhs) {
          for(k=0;k<CN[i];k++) {
            for(m=0;m<CN[j];m++) if(C[i][k]==C[j][m]) break;
            if(m==CN[j]) { C[j][CN[j]++]=C[i][k]; u=1; }
          }
          if(u) { propagatectx(s,R[j],0); u=0; }
        }
      }
    }
  }
}

static void add2state0(int s, int r, int m) {
  int i;
  for(i=0;i<N;i++) if(S[i]==s&&R[i]==r&&M[i]==m) break;
  if(i!=N) return;
  S[N]=s;
  R[N]=r;
  M[N++]=m;
}

static void add2state1(int s, int r, int m, char **c, int cn) {
  int i=0,j,k,u=0;
  for(i=0;i<N;i++) {
    if(S[i]!=s) continue;
    if(R[i]==r&&M[i]==m) {
      for(j=0;j<cn;j++) {
        for(k=0;k<CN[i];k++) if(C[i][k]==c[j]) break;
        if(k==CN[i]) { C[i][CN[i]++]=c[j]; u=1; }
      }
      if(u) { propagatectx(s,r,m); u=0; }
      return;
    }
  }
  S[N]=s;
  R[N]=r;
  M[N]=m;
  for(i=0;i<cn;i++) C[N][i]=c[i];
  CN[N]=cn;
  N++;
}

static void closure0(int s) {
  int i,j,k,c;
  char *u[128];
  rule *rp;
  c=ufrhs(s,u);
  for(i=0;i<c;i++) {
    if(ist(u[i])) continue;
    for(j=0;j<RN;j++) {
      rp=&RA[j];
      if(u[i]!=rp->lhs) continue;
      if(pins(s,j,0,0,0)) continue;
      add2state0(s,j,0);
      if(isnt(rp->rhs[0])) {
        for(k=0;k<c;k++) if(u[k]==rp->rhs[0]) break;
        if(k==c) u[c++]=rp->rhs[0];
      }
    }
  }
}

static void closure1(int s) {
  int i,j,k,c,p;
  rule *r0,*r1;
  char *ctx[32],*n;
  int ctn=0;
  for(i=0;i<N;i++) {
    ctn=0;
    if(S[i]!=s) continue;
    r0=&RA[R[i]];
    if(r0->rhsi==M[i]) continue;
    if(ist(r0->rhs[M[i]])) continue;
    for(j=M[i]+1;j<r0->rhsi;j++)
      ctx[ctn++]=r0->rhs[j];
    for(j=0;j<CN[i];j++)
      ctx[ctn++]=C[i][j];
    n=RA[R[i]].rhs[M[i]];
    if(M[i]+1!=r0->rhsi) {
      k=first(ctx,ctn);
      for(j=0;j<RN;j++) {
        r1=&RA[j];
        if(r1->lhs!=n) continue;
        add2state1(s,j,0,F,k);
      }
    }
    else {
      for(j=0;j<RN;j++) {
        r1=&RA[j];
        if(r1->lhs!=n) continue;
        add2state1(s,j,0,ctx,ctn);
      }
    }
  }
}

static void closure(int s) {
  if(gmode==LR1||gmode==LALR) closure1(s);
  else closure0(s);
}

static char esc[256];
static char* escape(char *s) {
  int i,j=0,n;
  if(!s) return 0;
  n=strlen(s);
  for(i=0;i<n;i++) {
    if(s[i]=='\n') { esc[j++]='\\'; esc[j++]='n'; }
    else esc[j++]=s[i];
  }
  esc[j]=0;
  return esc;
}

//static void printmp(int r, int m) {
//  int k;
//  rule *rp=&RA[r];
//  printf("%s %s",rp->lhs,rp->op);
//  for(k=0;k<rp->rhsi;k++) {
//    if(k==m) printf(" .");
//    printf(" %s",escape(rp->rhs[k]));
//  }
//  if(m==rp->rhsi) printf(" .");
//}

static void printmp(int r, int m, char **c, int cn) {
  int i,j,k;
  char *u[32];
  rule *rp=&RA[r];
  printf("%s %s",rp->lhs,rp->op);
  for(k=0;k<rp->rhsi;k++) {
    if(k==m) printf(" .");
    printf(" %s",escape(rp->rhs[k]));
  }
  if(m==rp->rhsi) printf(" .");
  if(gmode==LR1||gmode==LALR) {
    printf(" ,");
    for(i=0;i<cn;i++) printf(" %s",c[i]);
  }
}

static void addtrans(int s, char *t, int a, int g, int r, int m) {
  int i;
  for(i=0;i<TN;i++) {
    if(TS[i]!=s||TT[i]!=t) continue;
    if(a==0&&TA[i]==0&&TR[i]&&TR[i]!=r) {
      printf("warning: reduce/reduce conflict state[%d] token[%s]\n",s,t);
      printf("         %d. ",TR[i]); printmp(TR[i],TM[i],0,0); printf("\n");
      printf("         %d. ",r); printmp(r,m,0,0); printf("\n");
      conflicts++;
      return;
    }
    else if(a==0&&TA[i]==1) {
      printf("warning: shift/reduce conflict state[%d] token[%s]\n",s,t);
      printf("         %d. ",TR[i]); printmp(TR[i],TM[i],0,0); printf("\n");
      printf("         %d. ",r); printmp(r,m,0,0); printf("\n");
      conflicts++;
      return;
    }
    else if(a==1&&TA[i]==0) ; /* overwrite default reduce follow() entries */
    else if(a==1&&TA[i]==1) return; /* just leave first shift rule. TODO?*/
    else ; /* a==2 */
    TA[i]=a;
    TG[i]=g;
    TR[i]=r;
    TM[i]=m;
    return;
  }
  for(i=0;i<TN;i++) if(TS[i]==s&&TT[i]==t) return;
  TS[TN]=s;
  TT[TN]=t;
  TA[TN]=a;
  TG[TN]=g;
  TR[TN]=r;
  TM[TN++]=m;
}

static void goto0(int s, char *p) {
  int i,j,k,f=0,b,c=0;
  char *rs,*nta[128];
  rule *rp;
  GN=N; /* in case this state is not added */
  GTN=TN; /* in case this state is not added */
  for(i=0;i<N;i++) {
    if(S[i]!=s) continue;
    rp=&RA[R[i]];
    rs=rp->rhs[M[i]];
    if(rp->rhsi==M[i]) { /* default reduce rule */
      if(gmode==SLR) {
        addtrans(s,rs?rs:str("$e"),0,0,R[i],M[i]);
        j=followi(rp->lhs);
        if(j!=-1) for(k=0;k<AC[j];k++) addtrans(s,AV[j][k],0,0,R[i],M[i]);
      }
      continue;
    }
    else if(p==rs) {
      if(!pins(SN,R[i],M[i],0,0)) {
        f=1;
        add2state0(SN,R[i],M[i]+1);
        if((b=isnt(rs))) {
          for(j=0;j<c;j++) if(nta[j]==rs) break;
          if(j!=c) continue;
          else nta[c++]=rs;
        }
        addtrans(s,rs?rs:str(""),b?2:1,SN,R[i],M[i]);
      }
    }
  }
  if(f) closure(SN);
}

static void goto1(int s, char *p) {
  int i,j,k,f=0,b,c=0,m;
  char *rs,*nta[128];
  rule *rp;
  GN=N; /* in case this state is not added */
  GTN=TN; /* in case this state is not added */
  for(i=0;i<N;i++) {
    if(S[i]!=s) continue;
    rp=&RA[R[i]];
    rs=rp->rhs[M[i]];
    if(rp->rhsi==M[i]) { /* default reduce rule */
      /* for any lookahead */
      for(j=0;j<CN[i];j++) {
        k=firsti(C[i][j]);
        for(m=0;m<FC[k];m++)
          addtrans(s,FV[k][m],0,0,R[i],M[i]);
      }
    }
    else if(p==rs) {
      if(!pins(SN,R[i],M[i]+1,C[i],CN[i])) {
        f=1;
        add2state1(SN,R[i],M[i]+1,C[i],CN[i]);
        if((b=isnt(rs))) {
          for(j=0;j<c;j++) if(nta[j]==rs) break;
          if(j!=c) continue;
          else nta[c++]=rs;
        }
        addtrans(s,rs?rs:str(""),b?2:1,SN,R[i],M[i]);
      }
    }
  }
  if(f) closure(SN);
}

static char* split(char *p, char c, char **q) {
    int i,n,s=0;
    if(!p) p=*q;
    if(!p) return 0;
    n=strlen(p);
    for(i=0;i<n;i++) {
      if(s==0) {
        if(p[i]=='<') s=1;
        else if(p[i]=='\'') s=2;
        else if(p[i]=='"') s=3;
        else if(p[i]==c) break;
      }
      else if(s==1) { if(p[i]=='>') s=0; }  /* inside <> */
      else if(s==2) { if(p[i]=='\'') s=0; } /* inside '' */
      else if(s==3) { if(p[i]=='"') s=0; }  /* inside "" */
    }
    if(i==n) *q=0;
    else { *q=p+i; *(*q)++=0; }
    return p;
}

/* star plus question cond */
static void spqc(char *q, char *s, char m) {
  char *t,*z,*u,*v;
  if(!s) return;
  t=strdup(s);
  u=split(t,' ',&z);
  while(u) {
    if(1<strlen(u) && u[strlen(u)-1]==m) {
      v=strdup(u);
      v[strlen(v)-1]=0;
      switch(m) {
      case '*':
        sprintf(RA[RN++].r,"%s %s",u,q);
        sprintf(RA[RN++].r,"%s %s %s %s",u,q,u,v);
        break;
      case '+':
        sprintf(RA[RN++].r,"%s %s %s",u,q,v);
        sprintf(RA[RN++].r,"%s %s %s %s",u,q,u,v);
        break;
      case '?':
        sprintf(RA[RN++].r,"%s %s",u,q);
        sprintf(RA[RN++].r,"%s %s %s",u,q,v);
        break;
      case ']':
        sprintf(RA[RN++].r,"%s %s",u,q);
        sprintf(RA[RN++].r,"%s %s %s",u,q,v+1);
        break;
      }
      cs(RA[RN-2].r);
      cs(RA[RN-1].r);
      free(v);
    }
    u=split(0,' ',&z);
  }
  free(t);
}
void pgread(char *g) {
  FILE *fp;
  char b[1024],p[256],q[256],r[1024],*s,*z;
  if(!(fp=fopen(g,"r"))) { fprintf(stderr,"error: file not found\n"); exit(1); }
  while(xfgets(b,1024,fp)) {
    if(!*b) continue;
    if('#'==*b) continue;
    split(b,'#',&z);
    cs(b);
    if('|'==*b) strcpy(r,b+1);
    else {
      strcpy(p,split(b,' ',&z));
      strcpy(q,split(0,' ',&z));
      strcpy(r,b+strlen(p)+strlen(q)+2);
    }
    s=split(r,'|',&z);
    while(s) {
      snprintf(RA[RN].r,1024,"%s %s %s",p,q,s?s:"");
      cs(RA[RN++].r);
      spqc(q,s,'*');
      spqc(q,s,'+');
      spqc(q,s,'?');
      spqc(q,s,']');
      s=split(0,'|',&z);
    }
  }
  fclose(fp);
}

void pgparse() {
  int i;
  char *p,b[1024],*z;
  addnt(str("$a"));
  for(i=1;i<RN;i++) {
    strcpy(b,RA[i].r);
    p=split(b,' ',&z); if(!p) continue; addnt(str(p));
  }
  for(i=0;i<RN;i++) {
    strcpy(b,RA[i].r);
    p=split(b,' ',&z); if(!p) continue; RA[i].lhs=str(p);
    p=split(0,' ',&z); if(!p) continue; RA[i].op=str(p);
    p=split(0,' ',&z); while(p) {
      RA[i].rhs[RA[i].rhsi++]=str(p);
      addt(str(p));
      p=split(0,' ',&z);
    }
  }
  addt(str("$e"));
  RA[0].lhs=str("$a");
  RA[0].op=RA[1].op;
  RA[0].rhs[RA[0].rhsi++]=RA[1].lhs;
  sprintf(RA[0].r,"%s %s %s",RA[0].lhs,RA[0].op,RA[0].rhs[0]);
  firstgen();
  followgen();
}

void pgreport() {
  int i;
  printf("n:"); for(i=0;i<NTC;i++) printf(" %s",NT[i]); printf("\n");
  printf("t:"); for(i=0;i<TC;i++) printf(" %s",escape(T[i])); printf("\n");
  printf("-------------------------\n");
  for(i=0;i<RN;i++) printf("%2d. %s\n",i,escape(RA[i].r));
}

/* goto items in states */
//static int gins() {
//  int i,j,k,n;
//  for(i=0;i<SN;i++) {
//    n=GN;
//    for(j=0;j<GN;j++) {
//      if(S[j]!=i) continue;
//      for(k=GN;k<N;k++) if(R[j]==R[k]&&M[j]==M[k]) ++n;
//    }
//    if(N!=n) continue;
//    return i;
//  }
//  return -1;
//}
static int gins() {
  int i,j,k,n,m;
  for(i=0;i<SN;i++) {
    n=GN;
    for(j=0;j<GN;j++) {
      if(S[j]!=i) continue;
      for(k=GN;k<N;k++) {
        if(R[j]==R[k]&&M[j]==M[k]&&CN[j]==CN[k]) {
          for(m=0;m<CN[j];m++) {
            if(C[j][m]!=C[k][m]) break;
          }
          if(m==CN[j]) ++n;
        }
      }
    }
    if(N!=n) continue;
    return i;
  }
  return -1;
}

/* find the first state that is a combination of the current potential state.
   state s0 is a combination of s1 if s0 has an action A for a symbol P iff
   s1 has an action A for P and A is not a unit reduction. */
static int getcomb() {
  int i,j,k,n;
  for(i=0;i<SN;i++) {
    n=GTN;
    for(j=0;j<GTN;j++) {
      if(TS[j]!=i) continue;
      for(k=GTN;k<TN;k++) if(TT[j]==TT[k]&&TA[j]==TA[k]&&TR[j]==TR[k]) ++n;
    }
    if(n==TN) return i;
  }
  return -1;
}

void pgbuild(int m) {
  int i,j,k,c,s;
  char *u[128];
  gmode=m;
  N=SN=1;
  if(gmode==LR1||gmode==LALR) C[0][0]=str("$e"); CN[0]++;
  closure(0);
  for(i=0;i<SN;i++) {
    c=ufrhs(i,u);
    for(j=0;j<c;j++) {
      if(gmode==LR1||gmode==LALR) goto1(i,u[j]);
      else goto0(i,u[j]);
      s=gins();
      if(s<0) SN++;
      else { N=GN; for(k=0;k<TN;k++) if(TG[k]==SN) TG[k]=s; }
    }
  }
}

void pgprints(int i) {
  int j;
  printf("---------- state %d ----------\n",i);
  for(j=0;j<N;j++) {
    if(S[j]!=i) continue;
    if(!D[j]) { printmp(R[j],M[j],0,0); printf("\n"); }
  }
}

static int sdeleted(int s) {
  int i;
  for(i=0;i<N;i++) if(S[i]==s&&!D[i]) break;
  return i==N;
}

void pgprint() {
  int i;
  for(i=0;i<SN;i++) if(!sdeleted(i)) pgprints(i);
}

static void printstd() {
  char *c[] = {"state","rule","marker","deleted"};
  int t[] = {1,1,1,1};
  void *v[] = {S,R,M,D};
  char *a = show(4,N,c,t,v,0);
  if(a) { printf("%s",a); free(a); }
}

void pgprintst(int d) {
  if(d) { printstd(); return; }
  char *c[] = {"state","rule","marker"};
  int t[] = {1,1,1};
  void *v[] = {S,R,M};
  char *a = show(3,N,c,t,v,D);
  if(a) { printf("%s",a); free(a); }
}

static void printttd() {
  char *c[] = {"state","token","action","goto","rule","deleted"};
  int t[] = {1,4,1,1,1,1};
  void *v[] = {TS,TT,TA,TG,TR,TD};
  char *a = show(6,TN,c,t,v,0);
  if(a) { printf("%s",a); free(a); }
}

void pgprintt(int d) {
  if(d) { printttd(); return; }
  char *c[] = {"state","token","action","goto","rule"};
  int t[] = {1,4,1,1,1};
  void *v[] = {TS,TT,TA,TG,TR};
  char *a = show(5,TN,c,t,v,TD);
  if(a) { printf("%s",a); free(a); }
}

static char* getaction(int s, char *t, int a) {
  int i;
  char *r;
  for(i=0;i<TN;i++) {
    if(TS[i]!=s) continue;
    if(TD[i]) continue;
    if(a==1 && TA[i]>1) continue;
    if(a==2 && TA[i]!=2) continue;
    if(TT[i]==t) break;
  }
  r=malloc(8);
  if(i==TN) r[0]=0;
  else if(TA[i]==0) {
    if(TR[i]) sprintf(r,"r%d",TR[i]);
    else if(TA[i]==0 && TG[i]==0) sprintf(r,"r0");
    else r[0]=0;
  }
  else if(TA[i]==1) sprintf(r,"s%d",TG[i]);
  else if(TA[i]==2) sprintf(r,"%2d",TG[i]);
  return r;
}

void pgprintt2() {
  int i,j,k,*s,*t,cn,*d;
  char *a,**c;
  void **v;
  cn=TC+NTC+LFN+1;
  for(i=0;i<LFN;i++) if(isnt(LF[i])) --cn;
  v=malloc(sizeof(void*)*cn);
  t=(int*)malloc(sizeof(int)*cn);
  s=(int*)malloc(sizeof(int)*SN);
  c=(char**)malloc(sizeof(char*)*cn);
  d=(int*)malloc(sizeof(int)*SN);
  for(i=0;i<SN;i++) d[i]=sdeleted(i)?1:0;
  for(i=0;i<SN;i++) s[i]=i;
  t[0]=1; for(i=1;i<cn;i++) t[i]=4;
  c[0]="state";
  for(j=1,i=0;i<TC;i++) c[j++]=T[i];
  for(i=0;i<NTC;i++) c[j++]=NT[i];
  for(i=0;i<LFN;i++) if(!isnt(LF[i])) c[j++]=LF[i];
  v[0]=s;
  i=1;
  for(j=0;j<TC;j++,i++) {
    v[i]=(char**)malloc(sizeof(char*)*SN);
    for(k=0;k<SN;k++) ((char**)v[i])[k]=getaction(k,c[i],1); /* reduce shift */
  }
  for(j=0;j<NTC;j++,i++) {
    v[i]=(char**)malloc(sizeof(char*)*SN);
    for(k=0;k<SN;k++) ((char**)v[i])[k]=getaction(k,c[i],2); /* goto */
  }
  for(j=0;j<LFN;j++) {
    if(isnt(LF[j])) continue;
    v[i]=(char**)malloc(sizeof(char*)*SN);
    for(k=0;k<SN;k++) ((char**)v[i])[k]=getaction(k,c[i],2); /* goto */
    i++;
  }
  a=show(cn,SN,c,t,v,d);
  if(a) { printf("\n%s",a); free(a); }
  for(i=1;i<cn;i++) {
    for(k=0;k<SN;k++) free(((char**)v[i])[k]);
    free(v[i]);
  }
  free(t);
  free(s);
  free(c);
  free(v);
  free(d);
}

static char TL[256][256];
static int TLE[256];
void pgh() {
  int i,j,k,n=0;
  FILE *fp;
  char *ta[1024];
  if(!(fp=fopen("p.h","w+"))) { fprintf(stderr,"error: failed to create p.h\n"); exit(1); }
  fprintf(fp,"#ifndef P_H\n#define P_H\n\n");
  for(i=0;i<TC;i++) ta[n++]=T[i];
  for(i=0;i<NTC;i++) ta[n++]=NT[i];
  for(i=0;i<n;i++) {
    k=i;
    for(j=0;j<LFN;j++)
      if(ta[i]!=str("$a")&&derives(ta[i],LF[j])) 
        for(k=0;k<n;k++)
          if(ta[k]==LF[j]) break;
    TLE[k]=i;
    sprintf(TL[i],"T%03d",k);
    if(k!=i) continue; /* don't define eliminated tokens */
    fprintf(fp,"#define T%03d %3d /* %s */\n",k,k,ta[i]);
  }
  fprintf(fp,"\n");
  fprintf(fp,"extern int *pgta; /* tokens */\n");
  fprintf(fp,"extern int *pgva; /* values */\n");
  fprintf(fp,"extern int pgi;   /* tv index */\n");
  fprintf(fp,"void pgpush(int t, int v);\n");
  fprintf(fp,"void parse();\n");
  fprintf(fp,"\n#endif /* P_H */\n");
  fclose(fp);
}

static void a2c(FILE *fp, char *k, int *v, int n) {
  int i;
  fprintf(fp,"static int %s[%d]={",k,n);
  for(i=0;i<n;i++) fprintf(fp,"%d%s",v[i],i==n-1?"":",");
  fprintf(fp,"};\n");
}

void pgc() {
  int i,j,k,*t,n,b=0;
  FILE *fp;
  if(!(fp=fopen("p.c","w+"))) { fprintf(stderr,"error: failed to create p.c\n"); exit(1); }
  fprintf(fp,"#include \"p.h\"\n");
  fprintf(fp,"#include <stdio.h>\n");
  fprintf(fp,"#include <stdlib.h>\n\n");

  j=TC+NTC+LFN;
  for(k=0;k<LFN;k++) if(isnt(LF[k])) --j;
  t=malloc(sizeof(int)*j);
  fprintf(fp,"static int SR[%d][%d]={\n",SN,j);
  for(i=0;i<SN;i++) {
    if(sdeleted(i)) { fprintf(fp,"{0},\n"); continue; }
    fprintf(fp,"{");
    memset(t,-1,j*sizeof(int));
    for(k=0;k<TN;k++) {
      if(TD[k]) continue;
      if(TS[k]!=i) continue;
      if(ist(TT[k])) {
        for(n=0;n<TC;n++) if(T[n]==TT[k]) break;
        t[TLE[n]]=k;
      }
      else {
        for(n=0;n<NTC;n++) if(NT[n]==TT[k]) break;
        t[TLE[TC+n]]=k;
      }
    }
    for(k=0;k<j;k++) fprintf(fp,"%d%s",t[TLE[k]],k==j-1?"":",");
    fprintf(fp,"}%s\n",i==SN-1?"":",");
  }
  fprintf(fp,"};\n\n");
  free(t);

  a2c(fp,"TA",TA,TN);
  a2c(fp,"TG",TG,TN);
  a2c(fp,"TR",TR,TN);

  fprintf(fp,"\nstatic int RPOP[%d]={",RN);
  for(i=0;i<RN;i++) fprintf(fp,"%d%s",RA[i].rhsi,i==RN-1?"":",");
  fprintf(fp,"};\n");
  fprintf(fp,"static int LEFT[%d]={",RN);
  for(i=0;i<RN;i++) {
    for(j=0;j<NTC;j++) if(NT[j]==RA[i].lhs) break;
    fprintf(fp,"%s%s",TL[j+TC],i==RN-1?"":",");
  }
  fprintf(fp,"};\n");

  fprintf(fp,"\n"
"int *pgta; /* tokens */\n"
"int *pgva; /* values */\n"
"int pgi;   /* tv index */\n"
"static int *vv; /* value stack */\n"
"static size_t vi=-1,vm=2; /* value stack index and max */\n\n");

  if(eunitr) {
    for(i=0;i<RN;i++)
      if(RA[i].lhs==str("$a")||RA[i].rhsi!=1)
        fprintf(fp,"static void r%03d() { /* %s */\n}\n",i,RA[i].r);
    fprintf(fp,"\nstatic void (*R[%d])()={",RN);
    for(i=0;i<RN;i++)
      if(RA[i].lhs==str("$a")||RA[i].rhsi!=1) fprintf(fp,"%sr%03d",b++?",":"",i);
      else fprintf(fp,"%s%d",b++?",":"",0);
  } else {
    for(i=0;i<RN;i++) fprintf(fp,"static void r%03d() { /* %s */\n}\n",i,RA[i].r);
    fprintf(fp,"\nstatic void (*R[%d])()={",RN);
    for(i=0;i<RN;i++) fprintf(fp,"%sr%03d",b++?",":"",i);
  }
  fprintf(fp,"};\n");

  fprintf(fp,"\n"
"void pgpush(int t, int v) {\n"
"  static size_t m=256;\n"
"  if(!pgta) pgta=(int*)malloc(m*sizeof(int));\n"
"  if(!pgva) pgva=(int*)malloc(m*sizeof(int));\n"
"  if(pgi==m) {\n"
"    m<<=1;\n"
"    pgta=(int*)realloc(pgta,m*sizeof(int));\n"
"    pgva=(int*)realloc(pgva,m*sizeof(int));\n"
"  }\n"
"  pgta[pgi]=t;\n"
"  pgva[pgi++]=v;\n"
"}\n"
"\n"
"void parse() {\n"
"  int i=0,j,r;\n"
"  static int *ss=0,*st=0;\n"
"  static size_t sm=2;\n"
"  size_t si=0;\n"
"  vi=-1;\n"
"  if(!vv) vv=(int*)malloc(vm*sizeof(int));\n"
"  if(!ss) ss=(int*)malloc(sm*sizeof(int));\n"
"  if(!st) st=(int*)malloc(sm*sizeof(int));\n"
"  ss[si]=0;\n"
"  while(i<pgi) {\n"
"    if(vi==vm-1) { vm<<=1; vv=(int*)realloc(vv,vm*sizeof(int)); }\n"
"    if(si==sm-2) {\n"
"      sm<<=1;\n"
"      ss=(int*)realloc(ss,sm*sizeof(int));\n"
"      st=(int*)realloc(st,sm*sizeof(int));\n"
"    }\n"
"    j=SR[ss[si]][pgta[i]];\n"
"    if(j==-1) { printf(\"parse\\n\"); return; }\n"
"    if(TA[j]) {      /* shift */\n"
"      ss[++si]=TG[j];\n"
"      st[si]=pgta[i];\n"
"      vv[++vi]=pgva[i++];\n"
"    } else {         /* reduce */\n"
"      r=TR[j];\n"
"      (*R[r])();\n"
"      if(!r) return; /* accept */\n"
"      si-=RPOP[r];\n"
"      j=SR[ss[si]][LEFT[r]];\n"
"      if(j==-1) { printf(\"parse2\\n\"); return; }\n"
"      ss[++si]=TG[j];\n"
"      st[si]=LEFT[r];\n"
"    }\n"
"  }\n"
"}\n");

  fclose(fp);
}

static int inleaf(char *s) {
  int i;
  for(i=0;i<LFN;i++) if(s==LF[i]) return 1;
  return 0;
}
static void leaf() {
  int i,j,b;
  for(i=1;i<RN;i++) {
    if(RA[i].rhsi==1) {
      b=1;
      for(j=1;j<RN;j++) if(RA[j].rhsi==1&&RA[j].lhs==RA[i].rhs[0]) b=0;
      if(b&&!inleaf(RA[i].rhs[0])) LF[LFN++]=RA[i].rhs[0];
    }
  }
}
static char *DR[256];
static int DRN;
static int indr(char *s) {
  int i;
  for(i=0;i<DRN;i++) if(s==DR[i]) return 1;
  return 0;
}
static int derives(char *a, char *b) {
  int i;
  if(a==b) return 1;
  if(ist(a)) return 0;
  for(i=0;i<RN;i++) {
    if(a!=RA[i].lhs) continue;
    if(!RA[i].rhsi) continue;
    if(b==RA[i].rhs[0]) return 1;
    if(a==RA[i].rhs[0]) continue;
    if(derives(RA[i].rhs[0],b)) return 1;
  }
  return 0;
}
static int copytrans(int a, int b) {
  int i,j,r=0;
  for(i=0;i<TN;i++) {
    if(a!=TS[i]) continue;
    if(RA[TR[i]].rhsi==1&&RA[TR[i]].lhs!=str("$a")) continue;
    for(j=0;j<TN;j++)
      if(TS[j]==b && TT[j]==TT[i] && TA[j]==TA[i] && TG[j]==TG[i] && TR[j]==TR[i] && TM[j]==TM[i])
        break;
    if(j!=TN) continue;
    TS[TN]=b;
    TT[TN]=TT[i];
    TA[TN]=TA[i];
    TG[TN]=TG[i];
    TR[TN]=TR[i];
    TM[TN++]=TM[i];
    r++;
  }
  return r;
}
/* x-successor has unit reduction */
static int xshur(int s, char *x) {
  int i,xs;
  for(i=0;i<TN;i++) {
    if(s!=TS[i]) continue;
    if(x==TT[i]) break;
  }
  xs=TG[i]; /* x-successor */
  for(i=0;i<N;i++) {
    if(xs!=S[i]) continue;
    if(RA[R[i]].rhsi!=1) continue;
    if(RA[R[i]].lhs==str("$a")) continue;
    return 1;
  }
  return 0;
}
/* Based on Pager,D. (1977) Eliminating Unit Productions from LR Parsers. Acta Informatica. */
void pgeunitr() {
  int i,j,k,c,p,q,s,b;
  char *u[128];
  eunitr=1;
  if(conflicts) { fprintf(stderr,"error: cannot eliminate unit reductions when there are conflicts.\n"); exit(1); }
  leaf();
  /* 1. for each state, do step 2 for each leaf */
  for(i=0;i<SN;i++) {
    c=ufrhs(i,u); /* successors */
    DRN=0;
    for(j=0;j<LFN;j++) {
      /* 2. combine states */
      if(!xshur(i,LF[j])) continue; /* if x-successor has no unit reduction */
      for(k=0;k<c;k++) if(derives(u[k],LF[j])) if(!indr(u[k])) DR[DRN++]=u[k];
      GN=N; GTN=TN;
      for(k=0;k<DRN;k++) {
        for(b=0,p=0;p<TN;p++) {
          if(i!=TS[p]) continue;
          if(DR[k]!=TT[p]) continue;
          for(q=0;q<N;q++) {
            if(TG[p]!=S[q]) continue;
            add2state0(SN,R[q],M[q]);
            b=1;
          }
          if(b) copytrans(TG[p],SN);
        }
      }
      if(N==GN) continue; /* no new state added */
      s=getcomb(); /* T or R */
      if(s<0) s=SN++;
      else { N=GN; TN=GTN; }
      for(k=0;k<TN;k++) {
        if(i!=TS[k]) continue;
        if(derives(TT[k],LF[j])) TG[k]=s; /* if derives leaf, update successor */
      }
    }
  }
  /* 3. delete all transitions with respect to left-hand sides of unit productions */
  for(i=1;i<RN;i++) { /* don't delete accept */
    if(RA[i].rhsi!=1) continue; /* not a unit production */
    for(j=0;j<TN;j++) if(TR[j]==i&&TA[j]==0&&TM[j]==1) TD[j]=1;
  }
  /* 4. delete all states which at this stage are not reachable from state 0 */
  for(i=0;i<SN;i++) {
    for(j=0;j<TN;j++) { /* does it have a goto? */
      if(i!=TG[j]) continue;
      if(!TD[j]) break;
    }
    if(j!=TN) continue;
    /* delete all references to this state */
    for(j=0;j<N;j++) if(i==S[j]) D[j]=1;
    for(j=0;j<TN;j++) if(i==TS[j]) TD[j]=1;
  }
  /* 5. replace every reduce action y>w with x>w where x is a leaf and y derives x */
  for(i=0;i<TN;i++) {
    if(TD[i]) continue;
    if(TA[i]!=2) continue;
    if(TT[i]==str("$a")) continue;
    for(j=0;j<LFN;j++) if(derives(TT[i],LF[j])) { TT[i]=LF[j]; break; }
  }
}

static int cmpcore(int p, int q) {
  int i,j,k,pn=0,qn=0;
  for(i=0;i<N;i++) if(S[i]==p) pn++;
  for(j=0;j<N;j++) if(S[j]==q) qn++;
  if(pn!=qn) return 0;
  for(i=0;i<N;i++) if(S[i]==p) break;
  for(j=0;j<N;j++) if(S[j]==q) break;
  for(k=0;k<pn;k++,i++,j++) if(R[i]!=R[j]||M[i]!=M[j]) break;
  return k==pn;
}

static void mergectx(int p, int q) {
  int i=0,j=0,k,m;
  while(S[i]!=p)i++;
  while(S[j]!=q)j++;
  while(S[i]==p) {
    for(k=0;k<CN[j];k++,i++,j++) {
      for(m=0;m<CN[i];m++) if(C[i][m]==C[j][k]) break;
      if(m==CN[i]) C[i][CN[i]++]=C[j][k];
    }
  }
}

static void updatetrans(int p, int q) {
  int i;
  for(i=0;i<TN;i++) {
    if(TS[i]==q) TS[i]=p;
    if(TG[i]==q) TG[i]=p;
  }
}

static void sorttrans() {
  int *ts=(int*)malloc(sizeof(int)*TN);
  char **tt=(char**)malloc(sizeof(char*)*TN);
  int *ta=(int*)malloc(sizeof(int)*TN);
  int *tg=(int*)malloc(sizeof(int)*TN);
  int *tr=(int*)malloc(sizeof(int)*TN);
  int *tm=(int*)malloc(sizeof(int)*TN);
  int *td=(int*)malloc(sizeof(int)*TN);
  memcpy(ts,TS,sizeof(int)*TN);
  memcpy(tt,TT,sizeof(char*)*TN);
  memcpy(ta,TA,sizeof(int)*TN);
  memcpy(tg,TG,sizeof(int)*TN);
  memcpy(tr,TR,sizeof(int)*TN);
  memcpy(tm,TM,sizeof(int)*TN);
  memcpy(td,TD,sizeof(int)*TN);
  int i,j,k=0;
  for(i=0;i<SN;i++) {
    for(j=0;j<TN;j++) {
      if(ts[j]!=i) continue;
      TS[k]=ts[j];
      TT[k]=tt[j];
      TA[k]=ta[j];
      TG[k]=tg[j];
      TR[k]=tr[j];
      TM[k]=tm[j];
      TD[k]=td[j];
      k++;
    }
  }

  free(ts); free(tt); free(ta); free(tg); free(tr); free(tm); free(td);
}

static void purgeds() {
  int i,j=0;
  int *s=(int*)malloc(sizeof(int)*N);
  int *r=(int*)malloc(sizeof(int)*N);
  int *m=(int*)malloc(sizeof(int)*N);
  int *d=(int*)malloc(sizeof(int)*N);
  char *c[N][32];
  int *cn=(int*)malloc(sizeof(int)*N);
  memcpy(s,S,sizeof(int)*N);
  memcpy(r,R,sizeof(int)*N);
  memcpy(m,M,sizeof(int)*N);
  memcpy(d,D,sizeof(int)*N);
  memcpy(c,C,sizeof(char*)*N*32);
  memcpy(cn,CN,sizeof(int)*N);

  for(i=0;i<N;i++) {
    if(d[i]) continue;
    S[j]=s[i];
    R[j]=r[i];
    M[j]=m[i];
    D[j]=d[i];
    memcpy(C[j],c[i],sizeof(c[i]));
    CN[j]=cn[i];
    j++;
  }
  N=j;

  free(s); free(r); free(m); free(d); free(cn);
}

static void resequence() {
  int i,j,k=-1,n;
  for(i=0;i<N;i++) {
    if(S[i]==k) continue;
    k++;
    if(S[i]==k) continue;
    n=S[i];
    for(j=0;j<N;j++) if(S[j]==n) S[j]=k;
    for(j=0;j<TN;j++) if(TS[j]==n) TS[j]=k;
    for(j=0;j<TN;j++) if(TG[j]==n) TG[j]=k;
  }
  SN=k+1;
}

void pglalr() {
  int i,j,k,f=1;
  for(i=0;i<SN;i++) {
    for(j=i+1;j<SN;j++) {
      if(cmpcore(i,j)) {
        mergectx(i,j);
        updatetrans(i,j);
        for(k=0;k<N;k++) if(S[k]==j) D[k]=1;
      }
    }
  }
  sorttrans();
  purgeds();
  resequence();
}
