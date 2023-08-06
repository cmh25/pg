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
  int i,j,n,k=0,b=0,m,f;
  for(i=0;i<c;i++) {
    if(ist(p[i])) { F[k++]=p[i]; return k; }
    n=firsti(p[i]);
    for(j=0;j<FC[n];j++) {
      if(!FV[n][j]) { F[k++]=FV[n][j]; b=1; }
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
  for(i=0;i<TN;i++) {
    if(TS[i]==s&&TT[i]==t&&a>TA[i]) {
      /* overwrite default reduce follow() entries */
      TA[i]=a;
      TG[i]=g;
      TR[i]=r;
      return;
    }
  }
  for(i=0;i<TN;i++) if(TS[i]==s&&TT[i]==t) return;
  TS[TN]=s;
  TT[TN]=t;
  TA[TN]=a;
  TG[TN]=g;
  TR[TN++]=r;
}

static void goto_(int s, char *p) {
  int i,j,k,f=0,b,c=0,f2;
  char *rs,*nta[128];
  rule *rp;
  GN=N; /* in case this state is not added */
  GTN=TN; /* in case this state is not added */
  for(i=0;i<N;i++) {
    if(S[i]!=s) continue;
    rp=&RA[R[i]];
    rs=rp->rhs[M[i]];
    if(rp->rhsi==M[i]) { /* default reduce rule */
      addtrans(s,rs?rs:str("$e"),0,0,R[i]);
      j=followi(rp->lhs);
      if(j!=-1) for(k=0;k<AC[j];k++) addtrans(s,AV[j][k],0,0,R[i]);
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

static void star(char *q, char *s) {
  char *t,*z,*u,*v;
  if(!s) return;
  t=strdup(s);
  u=split(t,' ',&z); 
  while(u) {
    if(1<strlen(u) && u[strlen(u)-1]=='*') {
      v=strdup(u);
      v[strlen(v)-1]=0;
      sprintf(RA[RN].r,"%s %s",u,q);
      cs(RA[RN++].r);
      sprintf(RA[RN].r,"%s %s %s %s",u,q,u,v);
      cs(RA[RN++].r);
      free(v);
    }
    u=split(0,' ',&z);
  }
  free(t);
}
static void plus(char *q, char *s) {
  char *t,*z,*u,*v;
  if(!s) return;
  t=strdup(s);
  u=split(t,' ',&z); 
  while(u) {
    if(1<strlen(u) && u[strlen(u)-1]=='+') {
      v=strdup(u);
      v[strlen(v)-1]=0;
      sprintf(RA[RN].r,"%s %s %s",u,q,v);
      cs(RA[RN++].r);
      sprintf(RA[RN].r,"%s %s %s %s",u,q,u,v);
      cs(RA[RN++].r);
      free(v);
    }
    u=split(0,' ',&z);
  }
  free(t);
}
static void question(char *q, char *s) {
  char *t,*z,*u,*v;
  if(!s) return;
  t=strdup(s);
  u=split(t,' ',&z); 
  while(u) {
    if(1<strlen(u) && u[strlen(u)-1]=='?') {
      v=strdup(u);
      v[strlen(v)-1]=0;
      sprintf(RA[RN].r,"%s %s",u,q);
      cs(RA[RN++].r);
      sprintf(RA[RN].r,"%s %s %s",u,q,v);
      cs(RA[RN++].r);
      free(v);
    }
    u=split(0,' ',&z);
  }
  free(t);
}
static void cond(char *q, char *s) {
  char *t,*z,*u,*v;
  if(!s) return;
  t=strdup(s);
  u=split(t,' ',&z); 
  while(u) {
    if(1<strlen(u) && *u=='[' && u[strlen(u)-1]==']') {
      v=strdup(u);
      v[strlen(v)-1]=0;
      sprintf(RA[RN].r,"%s %s",u,q);
      cs(RA[RN++].r);
      sprintf(RA[RN].r,"%s %s %s",u,q,v+1);
      cs(RA[RN++].r);
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
    if('|'==*b) strcpy(r,b+1);
    else {
      strcpy(p,split(b,' ',&z));
      strcpy(q,split(0,' ',&z));
      strcpy(r,b+strlen(p)+strlen(q)+2);
    }
    s=split(r,'|',&z);
    while(s) {
      sprintf(RA[RN].r,"%s %s %s",p,q,s?s:"");
      cs(RA[RN++].r);
      star(q,s);
      plus(q,s);
      question(q,s);
      cond(q,s);
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
    strncpy(b,RA[i].r,1024);
    p=split(b,' ',&z); if(!p) continue; addnt(str(p));
  }
  for(i=0;i<RN;i++) {
    strncpy(b,RA[i].r,1024);
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

static char* getaction(int s, char *t) {
  int i;
  char *r;
  for(i=0;i<TN;i++) {
    if(TS[i]!=s) continue;
    if(TT[i]==t) break;
  }
  r=malloc(8);
  if(i==TN) r[0]=0;
  else if(TA[i]==0) {
    if(TR[i]) sprintf(r,"r%d",TR[i]);
    else if(TA[i]==0 && TG[i]==0) sprintf(r,"acc");
    else r[0]=0;
  }
  else if(TA[i]==1) sprintf(r,"s%d",TG[i]);
  else if(TA[i]==2) sprintf(r,"%2d",TG[i]);
  return r;
}
void pgprintt2() {
  int i,j,k,*s,*t,cn;
  char *a,**c;
  void **v;
  cn=TC+NTC;
  v=malloc(sizeof(void*)*cn);
  t=(int*)malloc(sizeof(int)*cn);
  s=(int*)malloc(sizeof(int)*cn);
  c=(char**)malloc(sizeof(char*)*cn);
  for(i=0;i<SN;i++) s[i]=i;
  t[0]=1; for(i=1;i<cn;i++) t[i]=4;
  c[0]="state";
  for(j=1,i=0;i<TC;i++) c[j++]=T[i];
  for(i=1;i<NTC;i++) c[j++]=NT[i];
  v[0]=s;
  for(j=1,i=1;i<=cn;i++,j++) {
    v[j]=(char**)malloc(sizeof(char*)*SN);
    for(k=0;k<SN;k++) ((char**)v[j])[k]=getaction(k,c[i]);
  }

  a=show(cn,SN,c,t,v);
  if(a) { printf("\n%s",a); free(a); }
}

static char TL[256][256];
static char NTL[256][256];
static int TLE[256];
static int NTLE[256];
void pgh() {
  int i,j=0,n=256;
  FILE *fp;
  if(!(fp=fopen("p.h","w+"))) { fprintf(stderr,"error: failed to create p.h\n"); exit(1); }
  fprintf(fp,"#ifndef P_H\n#define P_H\n");
  for(i=0;i<TC;i++) {
    if(*T[i]=='\'') {
      TLE[j]=T[i][1];
      sprintf(TL[j++],"%d",T[i][1]);
      fprintf(fp,"#define T%03d %3d /* %s */\n",T[i][1],T[i][1],T[i]);
    }
    else {
      TLE[j]=n;
      sprintf(TL[j++],"T%03d",n);
      fprintf(fp,"#define T%03d %3d /* %s */\n",n,n,T[i]);
      ++n;
    }
  }
  for(j=0,i=0;i<NTC;i++) {
    NTLE[j]=n;
    sprintf(NTL[j++],"N%03d",n);
    fprintf(fp,"#define N%03d %d /* %s */\n",n,n,NT[i]);
    ++n;
  }
  fprintf(fp,"#endif /* P_H */\n");
  fclose(fp);
}

static void a2c(FILE *fp, char *k, int *v, int n) {
  int i,b=0;
  fprintf(fp,"int %s[%d]={",k,n);
  for(b=0,i=0;i<n;i++) {
    if(b) fprintf(fp,","); else b=1;
    fprintf(fp,"%d",v[i]);
  }
  fprintf(fp,"};\n");
}

void pgc() {
  int i,j,k,*t,n;
  FILE *fp;
  if(!(fp=fopen("p.c","w+"))) { fprintf(stderr,"error: failed to create p.c\n"); exit(1); }
  fprintf(fp,"#include \"p.h\"\n\n");

  for(j=256,i=0;i<TC;i++) if(*T[i]!='\'') j++;
  j+=NTC;
  t=malloc(sizeof(int)*j);
  fprintf(fp,"int sr[%d][%d]={\n",SN,j);
  for(i=0;i<SN;i++) {
    fprintf(fp,"{");
    memset(t,-1,j*sizeof(int));
    for(k=0;k<TN;k++) {
      if(TS[k]!=i) continue;
      if(ist(TT[k])) {
        for(n=0;n<TC;n++) if(T[n]==TT[k]) break;
        t[TLE[n]]=k;
      }
      else {
        for(n=0;n<NTC;n++) if(NT[n]==TT[k]) break;
        t[NTLE[n]]=k;
      }
    }
    for(k=0;k<j;k++) fprintf(fp,"%d%s",t[k],k==j-1?"":",");
    fprintf(fp,"}%s\n",i==SN-1?"":",");
  }
  fprintf(fp,"};\n\n");

  a2c(fp,"TS",TS,TN);

  fprintf(fp,"int TT[%d]={",TN);
  for(i=0;i<TN;i++) {
    if(ist(TT[i])) {
      for(j=0;j<TC;j++) if(T[j]==TT[i]) break;
      fprintf(fp,"%s%s",TL[j],i==TN-1?"":",");
    }
    else {
      for(j=0;j<NTC;j++) if(NT[j]==TT[i]) break;
      fprintf(fp,"%s%s",NTL[j],i==TN-1?"":",");
    }
  }
  fprintf(fp,"};\n");

  a2c(fp,"TA",TA,TN);
  a2c(fp,"TG",TG,TN);
  a2c(fp,"TR",TR,TN);

  fprintf(fp,"\n");
  for(i=0;i<RN;i++) fprintf(fp,"void r%03d(void *v) { /* %s */\n}\n",i,RA[i].r);
  fclose(fp);
}
