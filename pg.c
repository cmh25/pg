#include "pg.h"
#include "show.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdint.h>

static int gmode;

static rule *RA;
static int RN=1;
static int RAM;

/* states */
static int *S; /* state */
static int *R; /* rule */
static int *M; /* mark */
static int *D; /* deleted */
static int N;        /* rowcount */
static int SN;       /* states count */
static char ***C; /* LR(1) lookaheads */
static int *CN,*CM;
static int NM;
static int *SB,*SC,SBM;
static int *SH,SHM,SHN;

/* transitions */
static int   *TS; /* state */
static char **TT; /* token */
static int   *TA; /* action 0=reduce 1=shift 2=goto */
static int   *TG; /* goto state */
static int   *TR; /* rule */
static int   *TM; /* mark */
static int   *TD; /* deleted */
static int   TN;
static int   TNM;

/* goto markers */
static int GN;
static int GTN;

static void die(char *s) {
  fprintf(stderr,"error: %s\n",s);
  exit(1);
}

static void ensurerules(int n) {
  int m;
  rule *p;
  if(n<=RAM) return;
  m=RAM?RAM:128;
  while(m<n) m*=2;
  p=realloc(RA,sizeof(*RA)*m);
  if(!p) die("out of memory");
  memset(p+RAM,0,sizeof(*RA)*(m-RAM));
  RA=p;
  RAM=m;
}

static void ensureitems(int n) {
  int m,i;
  if(n<=NM) return;
  m=NM?NM:1024;
  while(m<n) m*=2;
  S=realloc(S,sizeof(*S)*m);
  R=realloc(R,sizeof(*R)*m);
  M=realloc(M,sizeof(*M)*m);
  D=realloc(D,sizeof(*D)*m);
  C=realloc(C,sizeof(*C)*m);
  CN=realloc(CN,sizeof(*CN)*m);
  CM=realloc(CM,sizeof(*CM)*m);
  if(!S||!R||!M||!D||!C||!CN||!CM) die("out of memory");
  for(i=NM;i<m;i++) {
    S[i]=R[i]=M[i]=0;
    D[i]=0;
    C[i]=0;
    CN[i]=CM[i]=0;
  }
  NM=m;
}

static void ensurecontext(int i, int n) {
  int m;
  if(n<=CM[i]) return;
  m=CM[i]?CM[i]:8;
  while(m<n) m*=2;
  C[i]=realloc(C[i],sizeof(*C[i])*m);
  if(!C[i]) die("out of memory");
  CM[i]=m;
}

static void ensurestates(int n) {
  int m,i;
  if(n<=SBM) return;
  m=SBM?SBM:256;
  while(m<n) m*=2;
  SB=realloc(SB,sizeof(*SB)*m);
  SC=realloc(SC,sizeof(*SC)*m);
  if(!SB||!SC) die("out of memory");
  for(i=SBM;i<m;i++) SB[i]=SC[i]=0;
  SBM=m;
}

static int itemend(int s) {
  return SB[s]+SC[s];
}

static void ensuretransitions(int n) {
  int m,i;
  if(n<=TNM) return;
  m=TNM?TNM:1024;
  while(m<n) m*=2;
  TS=realloc(TS,sizeof(*TS)*m);
  TT=realloc(TT,sizeof(*TT)*m);
  TA=realloc(TA,sizeof(*TA)*m);
  TG=realloc(TG,sizeof(*TG)*m);
  TR=realloc(TR,sizeof(*TR)*m);
  TM=realloc(TM,sizeof(*TM)*m);
  TD=realloc(TD,sizeof(*TD)*m);
  if(!TS||!TT||!TA||!TG||!TR||!TM||!TD) die("out of memory");
  for(i=TNM;i<m;i++) TD[i]=0;
  TNM=m;
}

static void checkitem() {
  ensureitems(N+1);
}

static void checktrans() {
  ensuretransitions(TN+1);
}

/* strings */
static char* str(char *s) {
  static int i,c,m;
  static char **t;
  for(i=0;i<c;i++) if(!strcmp(s,t[i])) return t[i];
  if(c==m) {
    m=m?m*2:1024;
    t=realloc(t,sizeof(*t)*m);
    if(!t) die("out of memory");
  }
  t[c]=strdup(s);
  if(!t[c]) die("out of memory");
  return t[c++];
}

/* nonterminals and terminals */
static char **NT,**T;
static int NTM,TCM;
static int NTC,TC;
static int *NTH,*TH,NTHM,THM,mapsready;
static int **NTR,*NTRN,*NTRM;

static unsigned phash(char *s) {
  uintptr_t p=(uintptr_t)s;
  p^=p>>17;
  p*=UINT64_C(0xed5ad4bb);
  p^=p>>11;
  return (unsigned)p;
}

static int mapfind(int *h, int m, char **v, char *s) {
  unsigned p;
  if(!m) return -1;
  p=phash(s)&(unsigned)(m-1);
  while(h[p]>=0) {
    if(v[h[p]]==s) return h[p];
    p=(p+1)&(unsigned)(m-1);
  }
  return -1;
}

static int ntindex(char *s) {
  int i;
  if(mapsready) return mapfind(NTH,NTHM,NT,s);
  for(i=0;i<NTC;i++) if(s==NT[i]) return i;
  return -1;
}

static int termindex(char *s) {
  int i;
  if(mapsready) return mapfind(TH,THM,T,s);
  for(i=0;i<TC;i++) if(s==T[i]) return i;
  return -1;
}

static int ist(char *s) { return termindex(s)>=0; }
static int isnt(char *s) { return ntindex(s)>=0; }

static void buildmap1(int **hp, int *mp, char **v, int n) {
  int i,m=16;
  unsigned p;
  while(m<n*2) m*=2;
  *hp=malloc(sizeof(**hp)*(size_t)m);
  if(!*hp) die("out of memory");
  *mp=m;
  for(i=0;i<m;i++) (*hp)[i]=-1;
  for(i=0;i<n;i++) {
    p=phash(v[i])&(unsigned)(m-1);
    while((*hp)[p]>=0) p=(p+1)&(unsigned)(m-1);
    (*hp)[p]=i;
  }
}

static void buildsymbolmaps() {
  int i,n;
  buildmap1(&NTH,&NTHM,NT,NTC);
  buildmap1(&TH,&THM,T,TC);
  mapsready=1;
  NTR=calloc((size_t)NTC,sizeof(*NTR));
  NTRN=calloc((size_t)NTC,sizeof(*NTRN));
  NTRM=calloc((size_t)NTC,sizeof(*NTRM));
  if(!NTR||!NTRN||!NTRM) die("out of memory");
  for(i=0;i<RN;i++) {
    n=ntindex(RA[i].lhs);
    if(n<0) die("internal error: rule has an unknown left-hand side");
    if(NTRN[n]==NTRM[n]) {
      NTRM[n]=NTRM[n]?NTRM[n]*2:4;
      NTR[n]=realloc(NTR[n],sizeof(*NTR[n])*NTRM[n]);
      if(!NTR[n]) die("out of memory");
    }
    NTR[n][NTRN[n]++]=i;
  }
}

static void addnt(char *s) {
  if(isnt(s)) return;
  if(NTC==NTM) {
    NTM=NTM?NTM*2:256;
    NT=realloc(NT,sizeof(*NT)*NTM);
    if(!NT) die("out of memory");
  }
  NT[NTC++]=s;
}
static void addt(char *s) {
  if(isnt(s)||ist(s)) return;
  if(TC==TCM) {
    TCM=TCM?TCM*2:256;
    T=realloc(T,sizeof(*T)*TCM);
    if(!T) die("out of memory");
  }
  T[TC++]=s;
}

/* leaf for eunitr */
static char **LF;
static int LFN,LFM;

static int conflicts;
static int eunitr;
static int statebuilding;
static int quiet;

static int derives(char *a, char *b);
static int sdeleted(int s);
static void sorttrans();
static void deduptrans();

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
  char *r = fgets(s, n, f);
  if(r) {
    size_t len = strlen(s);
    if(len==(size_t)n-1 && s[len-1]!='\n' && !feof(f))
      die("grammar line is too long");
    if(len > 0 && (s[len-1] == '\n' || s[len-1] == '\r')) s[--len]=0;
    if(len > 0 && s[len-1] == '\r') s[--len]=0;
    cs(s);
  }
  return r;
}

static void striplinecomment(char *s) {
  int quote=0;
  for(;*s;s++) {
    if(!quote) {
      if(*s=='\''||*s=='"'||*s=='<') quote=*s=='<'?'>':*s;
      else if(*s=='#'||(*s=='/'&&s[1]=='/')) { *s=0; return; }
    }
    else if(*s==quote) quote=0;
  }
}

/* production in state */
static int pins(int s, int r, int m, char **c, int cn) {
  int i,j;
  for(i=SB[s];i<itemend(s);i++) {
    if(R[i]==r&&M[i]==m&&CN[i]==cn) {
      for(j=0;j<cn;j++)
        if(C[i][j]!=c[j]) break;
      if(j==cn) return 1;
    }
  }
  return 0;
}

static int samecontext(int p, int q) {
  int i,j;
  if(CN[p]!=CN[q]) return 0;
  for(i=0;i<CN[p];i++) {
    for(j=0;j<CN[q];j++) if(C[p][i]==C[q][j]) break;
    if(j==CN[q]) return 0;
  }
  return 1;
}

static uint64_t corehash(int s) {
  int i;
  uint64_t h=(uint64_t)SC[s]*UINT64_C(0x9e3779b97f4a7c15);
  for(i=SB[s];i<itemend(s);i++) {
    uint64_t x=((uint64_t)(unsigned)R[i]<<32)|(unsigned)M[i];
    x^=x>>30;
    x*=UINT64_C(0xbf58476d1ce4e5b9);
    x^=x>>27;
    x*=UINT64_C(0x94d049bb133111eb);
    x^=x>>31;
    h+=x;
  }
  return h;
}

static int samecore(int p, int q) {
  int i,j;
  if(SC[p]!=SC[q]) return 0;
  for(i=SB[p];i<itemend(p);i++) {
    for(j=SB[q];j<itemend(q);j++)
      if(R[i]==R[j]&&M[i]==M[j]) break;
    if(j==itemend(q)) return 0;
  }
  return 1;
}

static void statehashinsert(int s);

static void statehashgrow() {
  int i,m=SHM?SHM*2:1024,*old=SH,oldm=SHM;
  SH=malloc(sizeof(*SH)*(size_t)m);
  if(!SH) die("out of memory");
  SHM=m;
  SHN=0;
  for(i=0;i<m;i++) SH[i]=-1;
  for(i=0;i<oldm;i++) if(old[i]>=0) statehashinsert(old[i]);
  free(old);
}

static void statehashinsert(int s) {
  unsigned p;
  if(!SHM||SHN*10>=SHM*7) statehashgrow();
  p=(unsigned)corehash(s)&(unsigned)(SHM-1);
  while(SH[p]>=0) p=(p+1)&(unsigned)(SHM-1);
  SH[p]=s;
  SHN++;
}

static int statehashfind(int s) {
  unsigned p;
  if(!SHM) return -1;
  p=(unsigned)corehash(s)&(unsigned)(SHM-1);
  while(SH[p]>=0) {
    if(samecore(SH[p],s)) return SH[p];
    p=(p+1)&(unsigned)(SHM-1);
  }
  return -1;
}

/* unique first righthand side */
int ufrhs(int s, char **u) {
  int i,j,f,c=0;
  rule *rp;
  for(i=SB[s];i<itemend(s);i++) {
    rp=&RA[R[i]];
    if(M[i]>=rp->rhsi) continue;
    for(f=0,j=0;j<c;j++) if(u[j]==rp->rhs[M[i]]) f=1;
    if(!f) {
      u[c++]=rp->rhs[M[i]];
    }
  }
  return c;
}

/* first() */
static char **FK;
static char ***FV;
static int *FC,*FM;
static int FN;
static char **F;
static int FMEM;
static int firsti(char *p) {
  int i=termindex(p);
  if(i>=0) return i;
  i=ntindex(p);
  if(i>=0) return TC+i;
  return -1;
}
static int infirst(char *p, char *q) {
  int i,j;
  i=firsti(p);
  if(i<0) return 0;
  for(j=0;j<FC[i];j++) if(q==FV[i][j]) return 1;
  return 0;
}
static int addfirst(int i, char *p) {
  int j;
  for(j=0;j<FC[i];j++) if(FV[i][j]==p) return 0;
  if(FC[i]==FM[i]) {
    FM[i]=FM[i]?FM[i]*2:4;
    FV[i]=realloc(FV[i],sizeof(*FV[i])*FM[i]);
    if(!FV[i]) die("out of memory");
  }
  FV[i][FC[i]++]=p;
  return 1;
}
static void firstgen() {
  int i,j,k,f=1,n,m,s,nullable;
  char *p,*q;
  FN=TC+NTC;
  FK=calloc((size_t)FN,sizeof(*FK));
  FV=calloc((size_t)FN,sizeof(*FV));
  FC=calloc((size_t)FN,sizeof(*FC));
  FM=calloc((size_t)FN,sizeof(*FM));
  F=malloc(sizeof(*F)*(size_t)(FN+1));
  FMEM=FN+1;
  if(!FK||!FV||!FC||!FM||!F) die("out of memory");
  FN=0;
  for(i=0;i<TC;i++) {
    FK[FN]=T[i];
    addfirst(FN,T[i]);
    FN++;
  }
  for(i=0;i<NTC;i++) {
    FK[FN]=NT[i];
    for(j=0;j<RN;j++)
      if(NT[i]==RA[j].lhs && !RA[j].rhsi) addfirst(FN,0);
    ++FN;
  }
  while(f) {
    f=0;
    for(j=0;j<RN;j++) {
      p=RA[j].lhs;
      n=firsti(p);
      nullable=1;
      for(k=0;k<RA[j].rhsi;k++) {
        q=RA[j].rhs[k];
        m=firsti(q);
        if(m<0) die("internal error: symbol has no FIRST set");
        for(s=0;s<FC[m];s++)
          if(FV[m][s] && addfirst(n,FV[m][s])) f=1;
        if(!infirst(q,0)) { nullable=0; break; }
      }
      if(nullable && addfirst(n,0)) f=1;
    }
  }
}
static int addf(char *p, int *k) {
  int i;
  for(i=0;i<*k;i++) if(F[i]==p) return 0;
  if(*k==FMEM) {
    FMEM*=2;
    F=realloc(F,sizeof(*F)*FMEM);
    if(!F) die("out of memory");
  }
  F[(*k)++]=p;
  return 1;
}
static int first(char **p, int c) {
  int i,j,n,k=0,nullable=1;
  if(!c) { F[k++]=0; return k; }
  for(i=0;i<c;i++) {
    n=firsti(p[i]);
    if(n<0) die("internal error: symbol has no FIRST set");
    for(j=0;j<FC[n];j++) {
      if(FV[n][j]) addf(FV[n][j],&k);
    }
    if(!infirst(p[i],0)) { nullable=0; break; }
  }
  if(nullable) addf(0,&k);
  return k;
}
void pgprintfirst() {
  int i,j;
  for(i=0;i<FN;i++) {
    if(ist(FK[i])) continue;
    if(FK[i]==str("$a")) continue;
    printf("first(%s) =",FK[i]);
    for(j=0;j<FC[i];j++) printf(" %s",FV[i][j]?FV[i][j]:"<empty>");
    printf("\n");
  }
}

/* follow() */
static char **AK;
static char ***AV;
static int *AC,*AM;
static int followi(char *p) {
  return ntindex(p);
}
static int addfollow(int i, char *p) {
  int j;
  for(j=0;j<AC[i];j++) if(AV[i][j]==p) return 0;
  if(AC[i]==AM[i]) {
    AM[i]=AM[i]?AM[i]*2:4;
    AV[i]=realloc(AV[i],sizeof(*AV[i])*AM[i]);
    if(!AV[i]) die("out of memory");
  }
  AV[i][AC[i]++]=p;
  return 1;
}
static void followgen() {
  int i,j,k,n,s,m,a,f=1,nullable;
  AK=malloc(sizeof(*AK)*(size_t)NTC);
  AV=calloc((size_t)NTC,sizeof(*AV));
  AC=calloc((size_t)NTC,sizeof(*AC));
  AM=calloc((size_t)NTC,sizeof(*AM));
  if(!AK||!AV||!AC||!AM) die("out of memory");
  for(i=0;i<NTC;i++) AK[i]=NT[i];
  if(NTC>0) addfollow(0,str("$e"));
  if(NTC>1) addfollow(1,str("$e"));
  while(f) {
    f=0;
    for(j=0;j<RN;j++) {
      a=followi(RA[j].lhs);
      for(k=0;k<RA[j].rhsi;k++) {
        m=followi(RA[j].rhs[k]);
        if(m<0) continue;
        n=first(&RA[j].rhs[k+1],RA[j].rhsi-k-1);
        nullable=0;
        for(s=0;s<n;s++) {
          if(!F[s]) nullable=1;
          else if(addfollow(m,F[s])) f=1;
        }
        if(nullable && a>=0)
          for(s=0;s<AC[a];s++) if(addfollow(m,AV[a][s])) f=1;
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

static void add2state0(int s, int r, int m) {
  int i;
  ensurestates(s+1);
  for(i=SB[s];i<itemend(s);i++) if(R[i]==r&&M[i]==m) break;
  if(i!=itemend(s)) return;
  checkitem();
  S[N]=s;
  R[N]=r;
  M[N++]=m;
  SC[s]++;
}

static int add2state1(int s, int r, int m, char **c, int cn) {
  int i=0,j,k,u=0;
  ensurestates(s+1);
  for(i=SB[s];i<itemend(s);i++) {
    if(R[i]!=r||M[i]!=m) continue;
    for(j=0;j<cn;j++) {
      for(k=0;k<CN[i];k++) if(C[i][k]==c[j]) break;
      if(k==CN[i]) {
        ensurecontext(i,CN[i]+1);
        C[i][CN[i]++]=c[j];
        u=1;
      }
    }
    return u;
  }
  checkitem();
  S[N]=s;
  R[N]=r;
  M[N]=m;
  ensurecontext(N,cn);
  for(i=0;i<cn;i++) C[N][i]=c[i];
  CN[N]=cn;
  N++;
  SC[s]++;
  return 1;
}

static void closure0(int s) {
  int i,j,k,c,ni,x;
  char **u=malloc(sizeof(*u)*(size_t)(NTC+TC));
  rule *rp;
  if(!u) die("out of memory");
  c=ufrhs(s,u);
  for(i=0;i<c;i++) {
    ni=ntindex(u[i]);
    if(ni<0) continue;
    for(x=0;x<NTRN[ni];x++) {
      j=NTR[ni][x];
      rp=&RA[j];
      if(pins(s,j,0,0,0)) continue;
      add2state0(s,j,0);
      if(rp->rhsi&&isnt(rp->rhs[0])) {
        for(k=0;k<c;k++) if(u[k]==rp->rhs[0]) break;
        if(k==c) u[c++]=rp->rhs[0];
      }
    }
  }
  free(u);
}

static void closure1(int s) {
  int i,j,k,l,ctn,ln,changed=1,maxrhs=0,ni,x;
  rule *r0;
  char **ctx,**look,*n;
  for(i=0;i<RN;i++) if(maxrhs<RA[i].rhsi) maxrhs=RA[i].rhsi;
  ctx=malloc(sizeof(*ctx)*(size_t)(maxrhs+1));
  look=malloc(sizeof(*look)*(size_t)(TC+1));
  if(!ctx||!look) die("out of memory");
  while(changed) {
    changed=0;
    for(i=SB[s];i<itemend(s);i++) {
      r0=&RA[R[i]];
      if(r0->rhsi==M[i]||ist(r0->rhs[M[i]])) continue;
      n=RA[R[i]].rhs[M[i]];
      ln=0;
      if(M[i]+1==r0->rhsi) {
        for(j=0;j<CN[i];j++) look[ln++]=C[i][j];
      }
      else {
        for(j=0;j<CN[i];j++) {
          ctn=0;
          for(k=M[i]+1;k<r0->rhsi;k++) ctx[ctn++]=r0->rhs[k];
          ctx[ctn++]=C[i][j];
          k=first(ctx,ctn);
          for(l=0;l<k;l++) {
            if(!F[l]) continue;
            for(ctn=0;ctn<ln;ctn++) if(look[ctn]==F[l]) break;
            if(ctn==ln) look[ln++]=F[l];
          }
        }
      }
      ni=ntindex(n);
      if(ni<0) continue;
      for(x=0;x<NTRN[ni];x++) {
        j=NTR[ni][x];
        if(add2state1(s,j,0,look,ln)) changed=1;
      }
    }
  }
  free(ctx);
  free(look);
}

static void closure(int s) {
  if(gmode==LR1||gmode==LALR) closure1(s);
  else closure0(s);
}

static char esc[2048];
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

static void printmp(int r, int m, char **c, int cn) {
  int i,j;
  rule *rp=&RA[r];
  printf("%s %s",rp->lhs,rp->op);
  for(j=0;j<rp->rhsi;j++) {
    if(j==m) printf(" .");
    printf(" %s",escape(rp->rhs[j]));
  }
  if(m==rp->rhsi) printf(" .");
  if(gmode==LR1||gmode==LALR) {
    printf(" ,");
    for(i=0;i<cn;i++) printf(" %s",c[i]);
  }
}

static int samekind(int a, int b) {
  return (a==2)==(b==2);
}

static void printaction(int a, int g, int r) {
  if(a==0) printf("reduce %d (%s)",r,RA[r].r);
  else if(a==1) printf("shift %d",g);
  else printf("goto %d",g);
}

static void addtrans(int s, char *t, int a, int g, int r, int m) {
  int i,b=0;
  if(statebuilding) {
    b=TN;
    while(b>0&&TS[b-1]==s) b--;
  }
  for(i=b;i<TN;i++) {
    if(TD[i]||TS[i]!=s||TT[i]!=t||!samekind(TA[i],a)) continue;
    if(a==0&&TA[i]==0&&TR[i]==r) return;
    if((a==1||a==2)&&TA[i]==a&&TG[i]==g) return;
    if(a==2||TA[i]==2) {
      if(!quiet) {
        printf("warning: goto conflict state[%d] token[%s]: ",s,t);
        printaction(TA[i],TG[i],TR[i]);
        printf(" / ");
        printaction(a,g,r);
        printf("\n");
      }
      conflicts++;
      return;
    }
    if(a==1&&TA[i]==1) {
      if(!quiet)
        printf("warning: shift/shift conflict state[%d] token[%s]: s%d / s%d\n",
               s,t,TG[i],g);
      conflicts++;
      return;
    }
    if(a==0&&TA[i]==0) {
      if(!quiet) {
        printf("warning: reduce/reduce conflict state[%d] token[%s]\n",s,t);
        printf("         "); printaction(TA[i],TG[i],TR[i]); printf("\n");
        printf("         "); printaction(a,g,r); printf("\n");
      }
      conflicts++;
      if(r<TR[i]) { TR[i]=r; TM[i]=m; }
      return;
    }
    if(!quiet) {
      printf("warning: shift/reduce conflict state[%d] token[%s]\n",s,t);
      printf("         "); printaction(TA[i],TG[i],TR[i]); printf("\n");
      printf("         "); printaction(a,g,r); printf("\n");
    }
    conflicts++;
    if(a==1) {
      TA[i]=a;
      TG[i]=g;
      TR[i]=r;
      TM[i]=m;
    }
    return;
  }
  checktrans();
  TS[TN]=s;
  TT[TN]=t;
  TA[TN]=a;
  TG[TN]=g;
  TR[TN]=r;
  TM[TN]=m;
  TD[TN++]=0;
}

static void goto0(int s, char *p) {
  int i,j,f=0,b,c=0;
  char *rs,**nta=malloc(sizeof(*nta)*(size_t)(NTC+TC));
  rule *rp;
  if(!nta) die("out of memory");
  GN=N; /* in case this state is not added */
  GTN=TN; /* in case this state is not added */
  ensurestates(SN+1);
  SB[SN]=GN;
  SC[SN]=0;
  for(i=SB[s];i<itemend(s);i++) {
    rp=&RA[R[i]];
    if(M[i]>=rp->rhsi) continue;
    rs=rp->rhs[M[i]];
    if(p==rs) {
      if(pins(SN,R[i],M[i],0,0)) continue;
      f=1;
      add2state0(SN,R[i],M[i]+1);
      if((b=isnt(rs))) {
        for(j=0;j<c;j++) if(nta[j]==rs) break;
        if(j!=c) continue;
        nta[c++]=rs;
      }
      addtrans(s,rs?rs:str(""),b?2:1,SN,R[i],M[i]);
    }
  }
  if(f) closure(SN);
  free(nta);
}

static void goto1(int s, char *p) {
  int i,j,f=0,b,c=0;
  char *rs,**nta=malloc(sizeof(*nta)*(size_t)(NTC+TC));
  rule *rp;
  if(!nta) die("out of memory");
  GN=N; /* in case this state is not added */
  GTN=TN; /* in case this state is not added */
  ensurestates(SN+1);
  SB[SN]=GN;
  SC[SN]=0;
  for(i=SB[s];i<itemend(s);i++) {
    rp=&RA[R[i]];
    if(M[i]>=rp->rhsi) continue;
    rs=rp->rhs[M[i]];
    if(p==rs) {
      if(pins(SN,R[i],M[i]+1,C[i],CN[i])) continue;
      f=1;
      add2state1(SN,R[i],M[i]+1,C[i],CN[i]);
      if((b=isnt(rs))) {
        for(j=0;j<c;j++) if(nta[j]==rs) break;
        if(j!=c) continue;
        nta[c++]=rs;
      }
      addtrans(s,rs?rs:str(""),b?2:1,SN,R[i],M[i]);
    }
  }
  if(f) closure(SN);
  free(nta);
}

static void addreductions(int s) {
  int i,j,k;
  for(i=SB[s];i<itemend(s);i++) {
    if(M[i]!=RA[R[i]].rhsi) continue;
    if(gmode==LR1||gmode==LALR) {
      for(j=0;j<CN[i];j++) addtrans(s,C[i][j],0,0,R[i],M[i]);
    }
    else if(gmode==SLR) {
      if(!R[i]) addtrans(s,str("$e"),0,0,R[i],M[i]);
      else {
        k=followi(RA[R[i]].lhs);
        if(k>=0) for(j=0;j<AC[k];j++)
          addtrans(s,AV[k][j],0,0,R[i],M[i]);
      }
    }
    else if(gmode==LR0) {
      if(!R[i]) addtrans(s,str("$e"),0,0,R[i],M[i]);
      else for(j=0;j<TC;j++) addtrans(s,T[j],0,0,R[i],M[i]);
    }
  }
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
  int n;
  if(!s) return;
  t=strdup(s);
  if(!t) die("out of memory");
  u=split(t,' ',&z);
  while(u) {
    if(1<strlen(u) && u[strlen(u)-1]==m) {
      v=strdup(u);
      if(!v) die("out of memory");
      v[strlen(v)-1]=0;
      ensurerules(RN+2);
      switch(m) {
      case '*':
        n=snprintf(RA[RN++].r,sizeof(RA[0].r),"%s %s",u,q);
        if(n<0||n>=(int)sizeof(RA[0].r)) die("expanded rule is too long");
        n=snprintf(RA[RN++].r,sizeof(RA[0].r),"%s %s %s %s",u,q,u,v);
        if(n<0||n>=(int)sizeof(RA[0].r)) die("expanded rule is too long");
        break;
      case '+':
        n=snprintf(RA[RN++].r,sizeof(RA[0].r),"%s %s %s",u,q,v);
        if(n<0||n>=(int)sizeof(RA[0].r)) die("expanded rule is too long");
        n=snprintf(RA[RN++].r,sizeof(RA[0].r),"%s %s %s %s",u,q,u,v);
        if(n<0||n>=(int)sizeof(RA[0].r)) die("expanded rule is too long");
        break;
      case '?':
        n=snprintf(RA[RN++].r,sizeof(RA[0].r),"%s %s",u,q);
        if(n<0||n>=(int)sizeof(RA[0].r)) die("expanded rule is too long");
        n=snprintf(RA[RN++].r,sizeof(RA[0].r),"%s %s %s",u,q,v);
        if(n<0||n>=(int)sizeof(RA[0].r)) die("expanded rule is too long");
        break;
      case ']':
        n=snprintf(RA[RN++].r,sizeof(RA[0].r),"%s %s",u,q);
        if(n<0||n>=(int)sizeof(RA[0].r)) die("expanded rule is too long");
        n=snprintf(RA[RN++].r,sizeof(RA[0].r),"%s %s %s",u,q,v+1);
        if(n<0||n>=(int)sizeof(RA[0].r)) die("expanded rule is too long");
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
static char *arules;
static size_t arulesn,arulesm;
static void appendgrammar(char *s) {
  size_t n=strlen(s);
  if(arulesn+n+2>arulesm) {
    size_t m=arulesm?arulesm:1024;
    while(arulesn+n+2>m) m*=2;
    arules=realloc(arules,m);
    if(!arules) die("out of memory");
    arulesm=m;
  }
  memcpy(arules+arulesn,s,n);
  arulesn+=n;
  arules[arulesn++]='\n';
  arules[arulesn]=0;
}

enum {
  EN_SYMBOL,
  EN_SEQUENCE,
  EN_ALTERNATIVE,
  EN_OPTIONAL,
  EN_ZERO_MORE,
  EN_ONE_MORE
};

#define EBT_SYMBOL 256

typedef struct enode {
  int kind;
  char *text;
  struct enode **child;
  int n, m;
} enode;

typedef struct {
  char **v;
  int n, m;
} wordvec;

typedef struct {
  char *lhs;
  char *op;
  wordvec rhs;
} eproduction;

typedef struct {
  eproduction *v;
  int n, m;
} prodvec;

static char *ebp,*ebtext;
static int ebtok,ebline,ebhelper;
static char *ebfile;
static char **ebnames;
static int ebnamesn,ebnamesm;

static void eberror(char *s) {
  fprintf(stderr,"error: %s:%d: %s\n",ebfile,ebline,s);
  exit(1);
}

static enode *enew(int kind) {
  enode *n=calloc(1,sizeof(*n));
  if(!n) die("out of memory");
  n->kind=kind;
  return n;
}

static void echild(enode *n, enode *c) {
  if(n->n==n->m) {
    n->m=n->m?n->m*2:4;
    n->child=realloc(n->child,sizeof(*n->child)*n->m);
    if(!n->child) die("out of memory");
  }
  n->child[n->n++]=c;
}

static void ebnext() {
  char *s,*p;
  int quote=0;
  free(ebtext);
  ebtext=0;
  while(*ebp&&isblank((unsigned char)*ebp)) ebp++;
  if(!*ebp) { ebtok=0; return; }
  if(strchr("()|*+?",*ebp)) { ebtok=*ebp++; return; }
  s=ebp;
  if(*ebp=='\''||*ebp=='"'||*ebp=='<') {
    quote=*ebp=='<'?'>':*ebp;
    ebp++;
    while(*ebp&&*ebp!=quote) ebp++;
    if(!*ebp) eberror("unterminated quoted grammar symbol");
    ebp++;
  }
  else {
    while(*ebp&&!isblank((unsigned char)*ebp)&&!strchr("()|*+?",*ebp)) ebp++;
  }
  p=malloc((size_t)(ebp-s)+1);
  if(!p) die("out of memory");
  memcpy(p,s,(size_t)(ebp-s));
  p[ebp-s]=0;
  ebtext=p;
  ebtok=EBT_SYMBOL;
}

static enode *ebalternatives();

static enode *ebprimary() {
  enode *n,*p;
  if(ebtok==EBT_SYMBOL) {
    n=enew(EN_SYMBOL);
    n->text=strdup(ebtext);
    if(!n->text) die("out of memory");
    ebnext();
  }
  else if(ebtok=='(') {
    ebnext();
    n=ebalternatives();
    if(ebtok!=')') eberror("expected ')' in EBNF expression");
    ebnext();
  }
  else eberror("expected a grammar symbol or '('");
  if(ebtok=='*'||ebtok=='+'||ebtok=='?') {
    p=enew(ebtok=='*'?EN_ZERO_MORE:ebtok=='+'?EN_ONE_MORE:EN_OPTIONAL);
    echild(p,n);
    n=p;
    ebnext();
  }
  return n;
}

static enode *ebsequence() {
  enode *n=enew(EN_SEQUENCE);
  while(ebtok&&ebtok!='|'&&ebtok!=')') echild(n,ebprimary());
  if(n->n==1) {
    enode *p=n->child[0];
    free(n->child);
    free(n);
    return p;
  }
  return n;
}

static enode *ebalternatives() {
  enode *n=enew(EN_ALTERNATIVE),*p;
  echild(n,ebsequence());
  while(ebtok=='|') {
    ebnext();
    echild(n,ebsequence());
  }
  if(n->n==1) {
    p=n->child[0];
    free(n->child);
    free(n);
    return p;
  }
  return n;
}

static void efree(enode *n) {
  int i;
  if(!n) return;
  for(i=0;i<n->n;i++) efree(n->child[i]);
  free(n->child);
  free(n->text);
  free(n);
}

static void wadd(wordvec *w, char *s) {
  if(w->n==w->m) {
    w->m=w->m?w->m*2:8;
    w->v=realloc(w->v,sizeof(*w->v)*w->m);
    if(!w->v) die("out of memory");
  }
  w->v[w->n++]=s;
}

static eproduction *padd(prodvec *p, char *lhs, char *op) {
  eproduction *r;
  if(p->n==p->m) {
    p->m=p->m?p->m*2:8;
    p->v=realloc(p->v,sizeof(*p->v)*p->m);
    if(!p->v) die("out of memory");
  }
  r=&p->v[p->n++];
  memset(r,0,sizeof(*r));
  r->lhs=lhs;
  r->op=op;
  return r;
}

static char *ematerialize(enode *n, char *op, prodvec *extra);

static void ewords(enode *n, char *op, prodvec *extra, wordvec *w) {
  int i;
  if(n->kind==EN_SYMBOL) { wadd(w,n->text); return; }
  if(n->kind==EN_SEQUENCE) {
    for(i=0;i<n->n;i++) ewords(n->child[i],op,extra,w);
    return;
  }
  wadd(w,ematerialize(n,op,extra));
}

static void evariants(prodvec *p, char *lhs, char *op, enode *n,
                      char *prefix, prodvec *extra) {
  int i;
  eproduction *r;
  wordvec w={0};
  if(n->kind==EN_ALTERNATIVE) {
    for(i=0;i<n->n;i++) evariants(p,lhs,op,n->child[i],prefix,extra);
    return;
  }
  if(prefix) wadd(&w,prefix);
  ewords(n,op,extra,&w);
  r=padd(p,lhs,op);
  r->rhs=w;
}

static char *ematerialize(enode *n, char *op, prodvec *extra) {
  char b[64],*name;
  snprintf(b,sizeof(b),"$ebnf%d",++ebhelper);
  name=strdup(b);
  if(!name) die("out of memory");
  if(ebnamesn==ebnamesm) {
    ebnamesm=ebnamesm?ebnamesm*2:16;
    ebnames=realloc(ebnames,sizeof(*ebnames)*ebnamesm);
    if(!ebnames) die("out of memory");
  }
  ebnames[ebnamesn++]=name;
  if(n->kind==EN_OPTIONAL) {
    padd(extra,name,op);
    evariants(extra,name,op,n->child[0],0,extra);
  }
  else if(n->kind==EN_ZERO_MORE) {
    padd(extra,name,op);
    evariants(extra,name,op,n->child[0],name,extra);
  }
  else if(n->kind==EN_ONE_MORE) {
    evariants(extra,name,op,n->child[0],0,extra);
    evariants(extra,name,op,n->child[0],name,extra);
  }
  else evariants(extra,name,op,n,0,extra);
  return name;
}

static void eaddproduction(eproduction *p) {
  int i,n;
  size_t used;
  ensurerules(RN+1);
  n=snprintf(RA[RN].r,sizeof(RA[RN].r),"%s %s",p->lhs,p->op);
  if(n<0||n>=(int)sizeof(RA[RN].r)) die("expanded rule is too long");
  used=(size_t)n;
  for(i=0;i<p->rhs.n;i++) {
    n=snprintf(RA[RN].r+used,sizeof(RA[RN].r)-used," %s",p->rhs.v[i]);
    if(n<0||(size_t)n>=sizeof(RA[RN].r)-used) die("expanded rule is too long");
    used+=(size_t)n;
  }
  RN++;
}

static void compileebnf(char *lhs, char *op, char *rhs, char *file, int line) {
  int i;
  enode *n;
  prodvec main={0},extra={0};
  ebp=rhs;
  ebfile=file;
  ebline=line;
  ebnext();
  n=ebalternatives();
  if(ebtok) eberror("unexpected token in EBNF expression");
  evariants(&main,lhs,op,n,0,&extra);
  for(i=0;i<main.n;i++) eaddproduction(&main.v[i]);
  for(i=0;i<extra.n;i++) eaddproduction(&extra.v[i]);
  for(i=0;i<main.n;i++) free(main.v[i].rhs.v);
  for(i=0;i<extra.n;i++) free(extra.v[i].rhs.v);
  free(main.v);
  free(extra.v);
  efree(n);
  for(i=0;i<ebnamesn;i++) free(ebnames[i]);
  free(ebnames);
  ebnames=0;
  ebnamesn=ebnamesm=0;
  free(ebtext);
  ebtext=0;
}

static void appendtext(char **p, size_t *n, size_t *m, char *s) {
  size_t z=strlen(s);
  if(*n+z+2>*m) {
    size_t c=*m?*m:256;
    while(*n+z+2>c) c*=2;
    *p=realloc(*p,c);
    if(!*p) die("out of memory");
    *m=c;
  }
  if(*n) (*p)[(*n)++]=' ';
  memcpy(*p+*n,s,z+1);
  *n+=z;
}

void pgread(char *g) {
  FILE *fp;
  char b[1024],h[1024],p[256]={0},q[256]={0},r[1024],*s,*z,*lhs,*op;
  char *pending=0,plhs[256]={0},pop[256]={0};
  size_t pendingn=0,pendingm=0;
  int havehead=0,n,line=0,pline=0;
  ensurerules(1);
  if(!(fp=fopen(g,"r"))) { fprintf(stderr,"error: file not found\n"); exit(1); }
  while(xfgets(b,1024,fp)) {
    line++;
    appendgrammar(b);
    if(!*b) continue;
    striplinecomment(b);
    cs(b);
    if(!*b) continue;
    strcpy(h,b);
    lhs=split(h,' ',&z);
    op=split(0,' ',&z);
    if(pending) {
      if(lhs&&op&&!strcmp(op,"::=")) {
        compileebnf(plhs,pop,pending,g,pline);
        free(pending);
        pending=0;
        pendingn=pendingm=0;
      }
      else {
        appendtext(&pending,&pendingn,&pendingm,b);
        continue;
      }
    }
    if(lhs&&op&&!strcmp(op,"::=")&&(!z||!*z)) {
      if(strlen(lhs)>=sizeof(plhs)||strlen(op)>=sizeof(pop)) {
        fprintf(stderr,"error: %s:%d: rule head is too long\n",g,line);
        exit(1);
      }
      strcpy(plhs,lhs);
      strcpy(pop,op);
      pline=line;
      appendtext(&pending,&pendingn,&pendingm,"");
      continue;
    }
    if('|'==*b) {
      if(!havehead) {
        fprintf(stderr,"error: %s:%d: continuation without a preceding rule\n",g,line);
        exit(1);
      }
      strcpy(r,b+1);
    }
    else {
      lhs=split(b,' ',&z);
      op=split(0,' ',&z);
      if(!lhs||!*lhs||!op||!*op) {
        fprintf(stderr,"error: %s:%d: expected \"lhs operator rhs\"\n",g,line);
        exit(1);
      }
      if(strlen(lhs)>=sizeof(p)||strlen(op)>=sizeof(q)) {
        fprintf(stderr,"error: %s:%d: rule head is too long\n",g,line);
        exit(1);
      }
      strcpy(p,lhs);
      strcpy(q,op);
      strcpy(r,z?z:"");
      havehead=1;
    }
    s=split(r,'|',&z);
    while(s) {
      ensurerules(RN+1);
      n=snprintf(RA[RN].r,sizeof(RA[RN].r),"%s %s %s",p,q,s);
      if(n<0||n>=(int)sizeof(RA[RN].r)) {
        fprintf(stderr,"error: %s:%d: rule is too long\n",g,line);
        exit(1);
      }
      cs(RA[RN++].r);
      spqc(q,s,'*');
      spqc(q,s,'+');
      spqc(q,s,'?');
      spqc(q,s,']');
      s=split(0,'|',&z);
    }
  }
  if(pending) compileebnf(plhs,pop,pending,g,pline);
  free(pending);
  fclose(fp);
}

void pgparse() {
  int i;
  char *p,b[1024],*z;
  if(RN<=1) die("grammar contains no productions");
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
      if(RA[i].rhsi==RA[i].rhsm) {
        RA[i].rhsm=RA[i].rhsm?RA[i].rhsm*2:8;
        RA[i].rhs=realloc(RA[i].rhs,sizeof(*RA[i].rhs)*RA[i].rhsm);
        if(!RA[i].rhs) die("out of memory");
      }
      RA[i].rhs[RA[i].rhsi++]=str(p);
      addt(str(p));
      p=split(0,' ',&z);
    }
  }
  addt(str("$e"));
  RA[0].lhs=str("$a");
  RA[0].op=RA[1].op;
  RA[0].rhsm=1;
  RA[0].rhs=malloc(sizeof(*RA[0].rhs));
  if(!RA[0].rhs) die("out of memory");
  RA[0].rhs[RA[0].rhsi++]=RA[1].lhs;
  snprintf(RA[0].r,sizeof(RA[0].r),"%s %s %s",RA[0].lhs,RA[0].op,RA[0].rhs[0]);
  buildsymbolmaps();
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

int pgconflicts() {
  return conflicts;
}

void pgsetquiet(int q) {
  quiet=q;
}

/* goto items in states */
static int gins() {
  int i,j,k,newn;
  if(gmode!=LR1&&gmode!=LALR) return statehashfind(SN);
  newn=SC[SN];
  for(i=0;i<SN;i++) {
    if(SC[i]!=newn) continue;
    for(j=SB[i];j<itemend(i);j++) {
      for(k=SB[SN];k<itemend(SN);k++)
        if(R[j]==R[k]&&M[j]==M[k]&&samecontext(j,k)) break;
      if(k==itemend(SN)) break;
    }
    if(j==itemend(i)) return i;
  }
  return -1;
}

/* find the first state that is a combination of the current potential state.
   state s0 is a combination of s1 if s0 has an action A for a symbol P iff
   s1 has an action A for P and A is not a unit reduction. */
static int getcomb() {
  int i,j,k,found;
  for(i=0;i<SN;i++) {
    if(sdeleted(i)) continue;
    for(k=GTN;k<TN;k++) {
      found=0;
      for(j=0;j<GTN;j++) {
        if(TD[j]||TS[j]!=i||TT[j]!=TT[k]||TA[j]!=TA[k]) continue;
        if(TA[j]==0 ? TR[j]==TR[k] : TG[j]==TG[k]) { found=1; break; }
      }
      if(!found) break;
    }
    if(k!=TN) continue;
    for(j=0;j<GTN;j++) {
      if(TD[j]||TS[j]!=i) continue;
      if(TA[j]==0&&RA[TR[j]].rhsi==1&&RA[TR[j]].lhs!=str("$a")) continue;
      for(k=GTN;k<TN;k++) {
        if(TT[j]!=TT[k]||TA[j]!=TA[k]) continue;
        if(TA[j]==0 ? TR[j]==TR[k] : TG[j]==TG[k]) break;
      }
      if(k==TN) break;
    }
    if(j==GTN) return i;
  }
  return -1;
}

typedef struct {
  int to,next;
} pedge;

static void addedge(pedge **edge, int *en, int *em, int *head, int from, int to) {
  int i;
  for(i=head[from];i>=0;i=(*edge)[i].next)
    if((*edge)[i].to==to) return;
  if(*en==*em) {
    *em=*em?*em*2:4096;
    *edge=realloc(*edge,sizeof(**edge)*(size_t)*em);
    if(!*edge) die("out of memory");
  }
  (*edge)[*en].to=to;
  (*edge)[*en].next=head[from];
  head[from]=(*en)++;
}

static int stateitem(int s, int r, int m) {
  int i;
  for(i=SB[s];i<itemend(s);i++)
    if(R[i]==r&&M[i]==m) return i;
  return -1;
}

static int statetarget(int s, char *symbol, int *begin) {
  int i;
  for(i=begin[s];i<begin[s+1];i++)
    if(TT[i]==symbol&&TA[i]!=0) return TG[i];
  return -1;
}

static void rebuildlalrtransitions() {
  int i,s,n=TN;
  int *ts=malloc(sizeof(*ts)*(size_t)n);
  char **tt=malloc(sizeof(*tt)*(size_t)n);
  int *ta=malloc(sizeof(*ta)*(size_t)n);
  int *tg=malloc(sizeof(*tg)*(size_t)n);
  int *tr=malloc(sizeof(*tr)*(size_t)n);
  int *tm=malloc(sizeof(*tm)*(size_t)n);
  int *td=malloc(sizeof(*td)*(size_t)n);
  if(!ts||!tt||!ta||!tg||!tr||!tm||!td) die("out of memory");
  memcpy(ts,TS,sizeof(*ts)*(size_t)n);
  memcpy(tt,TT,sizeof(*tt)*(size_t)n);
  memcpy(ta,TA,sizeof(*ta)*(size_t)n);
  memcpy(tg,TG,sizeof(*tg)*(size_t)n);
  memcpy(tr,TR,sizeof(*tr)*(size_t)n);
  memcpy(tm,TM,sizeof(*tm)*(size_t)n);
  memcpy(td,TD,sizeof(*td)*(size_t)n);
  TN=0;
  statebuilding=1;
  for(s=0;s<SN;s++) {
    addreductions(s);
    for(i=0;i<n;i++) {
      if(td[i]||ts[i]!=s) continue;
      addtrans(ts[i],tt[i],ta[i],tg[i],tr[i],tm[i]);
    }
  }
  statebuilding=0;
  free(ts); free(tt); free(ta); free(tg); free(tr); free(tm); free(td);
}

static void buildlalrcontexts() {
  int i,j,k,l,s,t,ni,x,nullable,en=0,em=0,*head,*begin,*queue,*inq;
  int qhead=0,qtail=0,qcount=0;
  size_t words=(size_t)(TC+63)/64,w,total;
  uint64_t *bits;
  pedge *edge=0;
  head=malloc(sizeof(*head)*(size_t)N);
  begin=calloc((size_t)SN+1,sizeof(*begin));
  queue=malloc(sizeof(*queue)*(size_t)N);
  inq=calloc((size_t)N,sizeof(*inq));
  if(!head||!begin||!queue||!inq) die("out of memory");
  for(i=0;i<N;i++) head[i]=-1;
  for(i=0;i<TN;i++) begin[TS[i]+1]++;
  for(i=1;i<=SN;i++) begin[i]+=begin[i-1];
  if(words&&((size_t)N>SIZE_MAX/words)) die("LALR lookahead table is too large");
  total=(size_t)N*words;
  bits=calloc(total?total:1,sizeof(*bits));
  if(!bits) die("out of memory");

  t=termindex(str("$e"));
  if(t<0) die("internal error: end token is missing");
  bits[(size_t)stateitem(0,0,0)*words+(size_t)t/64]|=
    UINT64_C(1)<<(t%64);

  for(i=0;i<N;i++) {
    rule *rp=&RA[R[i]];
    if(M[i]>=rp->rhsi) continue;
    s=S[i];
    t=statetarget(s,rp->rhs[M[i]],begin);
    if(t<0) die("internal error: missing LR(0) successor");
    j=stateitem(t,R[i],M[i]+1);
    if(j<0) die("internal error: missing LR(0) successor item");
    addedge(&edge,&en,&em,head,i,j);

    ni=ntindex(rp->rhs[M[i]]);
    if(ni<0) continue;
    k=first(&rp->rhs[M[i]+1],rp->rhsi-M[i]-1);
    nullable=0;
    for(l=0;l<k;l++) {
      if(!F[l]) { nullable=1; continue; }
      t=termindex(F[l]);
      if(t<0) die("internal error: FIRST contains a nonterminal");
      for(x=0;x<NTRN[ni];x++) {
        j=stateitem(s,NTR[ni][x],0);
        if(j<0) die("internal error: closure item is missing");
        bits[(size_t)j*words+(size_t)t/64]|=UINT64_C(1)<<(t%64);
      }
    }
    if(nullable)
      for(x=0;x<NTRN[ni];x++) {
        j=stateitem(s,NTR[ni][x],0);
        if(j<0) die("internal error: closure item is missing");
        addedge(&edge,&en,&em,head,i,j);
      }
  }

  for(i=0;i<N;i++) {
    for(w=0;w<words;w++) if(bits[(size_t)i*words+w]) break;
    if(w==words) continue;
    queue[qtail++]=i;
    if(qtail==N) qtail=0;
    qcount++;
    inq[i]=1;
  }
  while(qcount) {
    i=queue[qhead++];
    if(qhead==N) qhead=0;
    qcount--;
    inq[i]=0;
    for(k=head[i];k>=0;k=edge[k].next) {
      j=edge[k].to;
      nullable=0;
      for(w=0;w<words;w++) {
        uint64_t old=bits[(size_t)j*words+w];
        bits[(size_t)j*words+w]|=bits[(size_t)i*words+w];
        if(old!=bits[(size_t)j*words+w]) nullable=1;
      }
      if(nullable&&!inq[j]) {
        queue[qtail++]=j;
        if(qtail==N) qtail=0;
        qcount++;
        inq[j]=1;
      }
    }
  }

  for(i=0;i<N;i++) {
    CN[i]=0;
    for(t=0;t<TC;t++) {
      if(!(bits[(size_t)i*words+(size_t)t/64]&(UINT64_C(1)<<(t%64))))
        continue;
      ensurecontext(i,CN[i]+1);
      C[i][CN[i]++]=T[t];
    }
  }
  free(bits); free(edge); free(head); free(begin); free(queue); free(inq);
  gmode=LALR;
  rebuildlalrtransitions();
}

static int directlalr;

void pgbuild(int m) {
  int i,j,k,c,s,lalr=m==LALR;
  char **u=malloc(sizeof(*u)*(size_t)(NTC+TC));
  if(!u) die("out of memory");
  gmode=lalr?LR0:m;
  statebuilding=1;
  ensureitems(1);
  ensurestates(1);
  N=SN=1;
  SB[0]=0;
  SC[0]=1;
  if(gmode==LR1||gmode==LALR) {
    ensurecontext(0,1);
    C[0][0]=str("$e");
    CN[0]++;
  }
  closure(0);
  if(gmode!=LR1&&gmode!=LALR) statehashinsert(0);
  for(i=0;i<SN;i++) {
    if(!lalr) addreductions(i);
    c=ufrhs(i,u);
    for(j=0;j<c;j++) {
      if(gmode==LR1||gmode==LALR) goto1(i,u[j]);
      else goto0(i,u[j]);
      s=gins();
      if(s<0) {
        if(gmode!=LR1&&gmode!=LALR) statehashinsert(SN);
        SN++;
      }
      else {
        N=GN;
        for(k=TN-1;k>=0&&TS[k]==i;k--) if(TG[k]==SN) TG[k]=s;
      }
    }
  }
  statebuilding=0;
  if(lalr) {
    directlalr=1;
    buildlalrcontexts();
  }
  free(u);
}

void pgprints(int i) {
  int j;
  printf("---------- state %d ----------\n",i);
  for(j=0;j<N;j++) {
    if(S[j]!=i) continue;
    if(!D[j]) { printmp(R[j],M[j],C[j],CN[j]); printf("\n"); }
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
  c=(char**)calloc(1,sizeof(char*)*cn);
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

static char (*TL)[16];
static int *TLE;
static int TLM;
static int TLC;

static void fccomment(FILE *fp, char *s) {
  while(s&&*s) {
    if(s[0]=='*'&&s[1]=='/') { fputs("* /",fp); s+=2; }
    else fputc(*s++,fp);
  }
}

static int symindex(char *s) {
  int i=termindex(s);
  if(i>=0) return i;
  i=ntindex(s);
  if(i>=0) return TC+i;
  return -1;
}

static void buildmap() {
  int i,j,n=TC+NTC;
  char *a,**rep;
  if(n>TLM) {
    TL=realloc(TL,sizeof(*TL)*(size_t)n);
    TLE=realloc(TLE,sizeof(*TLE)*(size_t)n);
    if(!TL||!TLE) die("out of memory");
    TLM=n;
  }
  rep=malloc(sizeof(*rep)*(size_t)n);
  if(!rep) die("out of memory");
  TLC=0;
  for(i=0;i<n;i++) {
    a=i<TC?T[i]:NT[i-TC];
    rep[i]=a;
    if(eunitr&&a!=str("$a"))
      for(j=0;j<LFN;j++) if(derives(a,LF[j])) { rep[i]=LF[j]; break; }
    for(j=0;j<i;j++) if(rep[j]==rep[i]) break;
    TLE[i]=j<i?TLE[j]:TLC++;
    snprintf(TL[i],sizeof(TL[i]),"T%03d",TLE[i]);
  }
  free(rep);
}

void pgh() {
  int i,j,n=0;
  FILE *fp;
  char *a,**ta=malloc(sizeof(*ta)*(size_t)(TC+NTC));
  if(!ta) die("out of memory");
  if(!(fp=fopen("p.h","w+"))) { fprintf(stderr,"error: failed to create p.h\n"); exit(1); }
  buildmap();
  fprintf(fp,"#ifndef P_H\n#define P_H\n\n");
  for(i=0;i<TC;i++) ta[n++]=T[i];
  for(i=0;i<NTC;i++) ta[n++]=NT[i];
  for(i=0;i<n;i++) {
    for(j=0;j<i;j++) if(TLE[j]==TLE[i]) break;
    if(j<i) continue;
    a=ta[i];
    if(eunitr&&a!=str("$a"))
      for(j=0;j<LFN;j++) if(derives(a,LF[j])) { a=LF[j]; break; }
    fprintf(fp,"#define T%03d %3d /* ",TLE[i],TLE[i]);
    fccomment(fp,a);
    fprintf(fp," */\n");
  }
  fprintf(fp,"\n");
  fprintf(fp,"void pgparse(char *p);\n\n");
  fprintf(fp,"#endif /* P_H */\n");
  fclose(fp);
  free(ta);
}

static void a2c(FILE *fp, char *k, int *v, int n) {
  int i;
  fprintf(fp,"static int %s[%d]={",k,n);
  for(i=0;i<n;i++) {
    if(i&&!(i%16)) fprintf(fp,"\n");
    fprintf(fp,"%d%s",v[i],i==n-1?"":",");
  }
  fprintf(fp,"};\n");
}

static void sparsec(FILE *fp, int go) {
  int i,j,n=0,*start,*token,*index;
  char *sn=go?"GS":"AS",*tn=go?"GTI":"AT",*in=go?"GI":"AI";
  for(i=0;i<TN;i++)
    if(!TD[i]&&((TA[i]==2)==go)) n++;
  start=calloc((size_t)SN+1,sizeof(*start));
  token=malloc(sizeof(*token)*(size_t)(n?n:1));
  index=malloc(sizeof(*index)*(size_t)(n?n:1));
  if(!start||!token||!index) die("out of memory");
  n=0;
  for(i=0;i<TN;i++) {
    int s;
    if(TD[i]||((TA[i]==2)!=go)) continue;
    s=symindex(TT[i]);
    if(s<0) die("internal error: transition has an unknown symbol");
    s=TLE[s];
    for(j=n-1;j>=0&&TS[index[j]]==TS[i];j--)
      if(token[j]==s) break;
    if(j>=0&&TS[index[j]]==TS[i]) {
      if(go) {
        if(TG[index[j]]!=TG[i])
          die("unit elimination produced incompatible goto actions");
      }
      else if(!((TA[index[j]]==0&&TA[i]==0&&TR[index[j]]==TR[i]) ||
                (TA[index[j]]==1&&TA[i]==1&&TG[index[j]]==TG[i])))
        die("unit elimination produced incompatible parser actions");
      continue;
    }
    start[TS[i]+1]++;
    token[n]=s;
    index[n++]=i;
  }
  for(i=1;i<=SN;i++) start[i]+=start[i-1];
  a2c(fp,sn,start,SN+1);
  a2c(fp,tn,token,n);
  a2c(fp,in,index,n);
  fprintf(fp,"\n");
  free(start); free(token); free(index);
}

void pgc() {
  int i,j,b=0;
  FILE *fp;
  if(!(fp=fopen("p.c","w+"))) { fprintf(stderr,"error: failed to create p.c\n"); exit(1); }
  fprintf(fp,"#include \"p.h\"\n");
  fprintf(fp,"#include <stdio.h>\n");
  fprintf(fp,"#include <stdlib.h>\n");
  fprintf(fp,"#include <ctype.h>\n\n");

  fprintf(fp,"/*\n");
  fccomment(fp,arules);
  fprintf(fp,"*/\n\n");
  fprintf(fp,"#define PGTOKENS %d\n\n",TLC);

  sparsec(fp,0);
  sparsec(fp,1);

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
        { fprintf(fp,"static void r%03d() { /* ",i); fccomment(fp,RA[i].r); fprintf(fp," */\n}\n"); }
    fprintf(fp,"\nstatic void (*R[%d])()={",RN);
    for(i=0;i<RN;i++)
      if(RA[i].lhs==str("$a")||RA[i].rhsi!=1) fprintf(fp,"%sr%03d",b++?",":"",i);
      else fprintf(fp,"%s%d",b++?",":"",0);
  } else {
    for(i=0;i<RN;i++) {
      fprintf(fp,"static void r%03d() { /* ",i);
      fccomment(fp,RA[i].r);
      fprintf(fp," */\n}\n");
    }
    fprintf(fp,"\nstatic void (*R[%d])()={",RN);
    for(i=0;i<RN;i++) fprintf(fp,"%sr%03d",b++?",":"",i);
  }
  fprintf(fp,"};\n");

  fprintf(fp,"\n"
"static void push(int t, int v) {\n"
"  static size_t m=256;\n"
"  if(!pgta) pgta=(int*)malloc(m*sizeof(int));\n"
"  if(!pgva) pgva=(int*)malloc(m*sizeof(int));\n"
"  if((size_t)pgi==m) {\n"
"    m<<=1;\n"
"    pgta=(int*)realloc(pgta,m*sizeof(int));\n"
"    pgva=(int*)realloc(pgva,m*sizeof(int));\n"
"  }\n"
"  pgta[pgi]=t;\n"
"  pgva[pgi++]=v;\n"
"}\n"
"\n"
"static int lex(char *p) {\n"
"  while(1) {\n"
"    while(*p==' ') ++p;\n"
"    if(!*p) break;\n"
"    if(*p=='\\\\'&&*(p+1)=='\\\\') exit(0);\n"
"    else if(*p=='\\n') break;\n"
"    else { printf(\"lex\\n\"); return 0; }\n"
"  }\n"
"  return 1;\n"
"}\n"
"\n"
"static int lookup(int s, int t, int *start, int *token, int *index) {\n"
"  int i;\n"
"  for(i=start[s];i<start[s+1];i++) if(token[i]==t) return index[i];\n"
"  return -1;\n"
"}\n"
"\n"
"void pgparse(char *p) {\n"
"  int i=0,j,r,g;\n"
"  static int *ss=0;\n"
"  static size_t sm=2;\n"
"  size_t si=0;\n"
"  vi=-1; pgi=0;\n"
"  if(!lex(p)) return;\n"
"  if(!vv) vv=(int*)malloc(vm*sizeof(int));\n"
"  if(!ss) ss=(int*)malloc(sm*sizeof(int));\n"
"  ss[si]=0;\n"
"  while(i<pgi) {\n"
"    if(vi==vm-1) { vm<<=1; vv=(int*)realloc(vv,vm*sizeof(int)); }\n"
"    if(si==sm-2) {\n"
"      sm<<=1;\n"
"      ss=(int*)realloc(ss,sm*sizeof(int));\n"
"    }\n"
"    if(pgta[i]<0||pgta[i]>=PGTOKENS) { printf(\"token\\n\"); return; }\n"
"    j=lookup(ss[si],pgta[i],AS,AT,AI);\n"
"    if(j==-1) { printf(\"parse\\n\"); return; }\n"
"    if(TA[j]) {      /* shift */\n"
"      ss[++si]=TG[j];\n"
"      vv[++vi]=pgva[i++];\n"
"    } else {         /* reduce */\n"
"      r=TR[j];\n"
"      (*R[r])();\n"
"      if(!r) return; /* accept */\n"
"      if(si<(size_t)RPOP[r]) { printf(\"parse2\\n\"); return; }\n"
"      si-=RPOP[r];\n"
"      g=lookup(ss[si],LEFT[r],GS,GTI,GI);\n"
"      if(g!=-1) g=TG[g];\n"
"      if(g==-1) { printf(\"parse2\\n\"); return; }\n"
"      ss[++si]=g;\n"
"    }\n"
"  }\n"
"}\n"
"\n"
"int main() {\n"
"  int c,eof;\n"
"  size_t i,m=2;\n"
"  char *b=malloc(m+2);\n"
"  printf(\"  \");\n"
"  for(;;) {\n"
"    i=0; eof=0;\n"
"    while((c=fgetc(stdin))!=EOF&&c!='\\n') {\n"
"      b[i++]=c;\n"
"      if(i==m) { m<<=1; b=realloc(b,m+2); }\n"
"    }\n"
"    if(c==EOF) eof=1;\n"
"    if(eof&&!i) break;\n"
"    b[i++]='\\n'; b[i]=0;\n"
"    pgparse(b);\n"
"    if(eof) break;\n"
"    printf(\"  \");\n"
"  }\n"
"  return 0;\n"
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
      if(b&&!inleaf(RA[i].rhs[0])) {
        if(LFN==LFM) {
          LFM=LFM?LFM*2:128;
          LF=realloc(LF,sizeof(*LF)*LFM);
          if(!LF) die("out of memory");
        }
        LF[LFN++]=RA[i].rhs[0];
      }
    }
  }
}
static char **DR;
static int DRN,DRM;
static int indr(char *s) {
  int i;
  for(i=0;i<DRN;i++) if(s==DR[i]) return 1;
  return 0;
}
static int derives1(char *a, char *b, int *seen) {
  int i,n;
  if(a==b) return 1;
  if(ist(a)) return 0;
  for(n=0;n<NTC;n++) if(NT[n]==a) break;
  if(n==NTC||seen[n]) return 0;
  seen[n]=1;
  for(i=0;i<RN;i++) {
    if(a!=RA[i].lhs) continue;
    if(RA[i].rhsi!=1) continue;
    if(b==RA[i].rhs[0]) return 1;
    if(derives1(RA[i].rhs[0],b,seen)) return 1;
  }
  return 0;
}

static int derives(char *a, char *b) {
  int r,*seen=calloc((size_t)NTC,sizeof(*seen));
  if(!seen) die("out of memory");
  r=derives1(a,b,seen);
  free(seen);
  return r;
}

static int copytrans(int a, int b) {
  int i,n=TN,r=0;
  for(i=0;i<n;i++) {
    if(TD[i]||a!=TS[i]) continue;
    if(TA[i]==0&&RA[TR[i]].rhsi==1&&RA[TR[i]].lhs!=str("$a")) continue;
    addtrans(b,TT[i],TA[i],TG[i],TR[i],TM[i]);
    r++;
  }
  return r;
}
/* x-successor has unit reduction */
static int xshur(int s, char *x) {
  int i,xs;
  for(i=0;i<TN;i++) {
    if(TD[i]||s!=TS[i]||TA[i]==0) continue;
    if(x==TT[i]) break;
  }
  if(i==TN) return 0;
  xs=TG[i]; /* x-successor */
  for(i=0;i<N;i++) {
    if(xs!=S[i]) continue;
    if(RA[R[i]].rhsi!=1) continue;
    if(M[i]!=RA[R[i]].rhsi) continue;
    if(RA[R[i]].lhs==str("$a")) continue;
    return 1;
  }
  return 0;
}
/* Based on Pager,D. (1977) Eliminating Unit Productions from LR Parsers. Acta Informatica. */
void pgeunitr() {
  int i,j,k,c,p,q,s,b,oldconf;
  int *reachable;
  char **u=malloc(sizeof(*u)*(size_t)(NTC+TC));
  if(!u) die("out of memory");
  eunitr=1;
  if(conflicts) { fprintf(stderr,"error: cannot eliminate unit reductions when there are conflicts.\n"); exit(1); }
  leaf();
  /* 1. for each state, do step 2 for each leaf */
  for(i=0;i<SN;i++) {
    c=ufrhs(i,u); /* successors */
    for(j=0;j<LFN;j++) {
      DRN=0;
      /* 2. combine states */
      if(!xshur(i,LF[j])) continue; /* if x-successor has no unit reduction */
      for(k=0;k<c;k++) if(derives(u[k],LF[j])&&!indr(u[k])) {
        if(DRN==DRM) {
          DRM=DRM?DRM*2:128;
          DR=realloc(DR,sizeof(*DR)*DRM);
          if(!DR) die("out of memory");
        }
        DR[DRN++]=u[k];
      }
      GN=N; GTN=TN;
      ensurestates(SN+1);
      SB[SN]=GN;
      SC[SN]=0;
      oldconf=conflicts;
      for(k=0;k<DRN;k++) {
        for(b=0,p=0;p<TN;p++) {
          if(TD[p]||i!=TS[p]||TA[p]==0) continue;
          if(DR[k]!=TT[p]) continue;
          for(q=0;q<N;q++) {
            if(TG[p]!=S[q]) continue;
            if(gmode==LR1||gmode==LALR)
              add2state1(SN,R[q],M[q],C[q],CN[q]);
            else add2state0(SN,R[q],M[q]);
            b=1;
          }
          if(b) copytrans(TG[p],SN);
        }
      }
      if(conflicts!=oldconf)
        die("unit elimination introduced an action conflict");
      if(N==GN) continue; /* no new state added */
      s=getcomb(); /* T or R */
      if(s<0) s=SN++;
      else { N=GN; TN=GTN; }
      for(k=0;k<TN;k++) {
        if(TD[k]||i!=TS[k]||TA[k]==0) continue;
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
  reachable=calloc(SN,sizeof(int));
  if(!reachable) die("out of memory");
  reachable[0]=1;
  for(b=1;b;) {
    b=0;
    for(i=0;i<TN;i++) {
      if(TD[i]||TA[i]==0||!reachable[TS[i]]||reachable[TG[i]]) continue;
      reachable[TG[i]]=1;
      b=1;
    }
  }
  for(i=0;i<SN;i++) {
    if(reachable[i]) continue;
    for(j=0;j<N;j++) if(i==S[j]) D[j]=1;
    for(j=0;j<TN;j++) if(i==TS[j]) TD[j]=1;
  }
  free(reachable);
  /* 5. replace every reduce action y>w with x>w where x is a leaf and y derives x */
  for(i=0;i<TN;i++) {
    if(TD[i]) continue;
    if(TA[i]!=2) continue;
    if(TT[i]==str("$a")) continue;
    for(j=0;j<LFN;j++) if(derives(TT[i],LF[j])) { TT[i]=LF[j]; break; }
  }
  oldconf=conflicts;
  deduptrans();
  if(conflicts!=oldconf)
    die("unit elimination introduced an action conflict");
  sorttrans();
  free(u);
}

static int cmpcore(int p, int q) {
  int i,j,pn=0,qn=0;
  for(i=0;i<N;i++) if(S[i]==p) pn++;
  for(j=0;j<N;j++) if(S[j]==q) qn++;
  if(pn!=qn) return 1;
  for(i=0;i<N;i++) {
    if(S[i]!=p) continue;
    for(j=0;j<N;j++)
      if(S[j]==q&&R[i]==R[j]&&M[i]==M[j]) break;
    if(j==N) return 1;
  }
  return 0;
}

static void mergectx(int p, int q) {
  int i,j,k,m;
  for(j=0;j<N;j++) {
    if(S[j]!=q) continue;
    for(i=0;i<N;i++)
      if(S[i]==p&&R[i]==R[j]&&M[i]==M[j]) break;
    if(i==N) die("internal error: LALR cores do not match");
    for(k=0;k<CN[j];k++) {
      for(m=0;m<CN[i];m++) if(C[i][m]==C[j][k]) break;
      if(m==CN[i]) {
        ensurecontext(i,CN[i]+1);
        C[i][CN[i]++]=C[j][k];
      }
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

static void deduptrans() {
  int i,n=TN;
  int *ts=malloc(sizeof(int)*n);
  char **tt=malloc(sizeof(char*)*n);
  int *ta=malloc(sizeof(int)*n);
  int *tg=malloc(sizeof(int)*n);
  int *tr=malloc(sizeof(int)*n);
  int *tm=malloc(sizeof(int)*n);
  int *td=malloc(sizeof(int)*n);
  if(!ts||!tt||!ta||!tg||!tr||!tm||!td) die("out of memory");
  memcpy(ts,TS,sizeof(int)*n);
  memcpy(tt,TT,sizeof(char*)*n);
  memcpy(ta,TA,sizeof(int)*n);
  memcpy(tg,TG,sizeof(int)*n);
  memcpy(tr,TR,sizeof(int)*n);
  memcpy(tm,TM,sizeof(int)*n);
  memcpy(td,TD,sizeof(int)*n);
  TN=0;
  for(i=0;i<n;i++)
    if(!td[i]) addtrans(ts[i],tt[i],ta[i],tg[i],tr[i],tm[i]);
  free(ts); free(tt); free(ta); free(tg); free(tr); free(tm); free(td);
}

static void purgeds() {
  int i,j=0,n=N;
  int *s=malloc(sizeof(*s)*(size_t)n);
  int *r=malloc(sizeof(*r)*(size_t)n);
  int *m=malloc(sizeof(*m)*(size_t)n);
  int *d=malloc(sizeof(*d)*(size_t)n);
  char ***c=malloc(sizeof(*c)*(size_t)n);
  int *cn=malloc(sizeof(*cn)*(size_t)n);
  int *cm=malloc(sizeof(*cm)*(size_t)n);
  if(!s||!r||!m||!d||!c||!cn||!cm) die("out of memory");
  for(i=0;i<n;i++) {
    if(D[i]) { free(C[i]); continue; }
    s[j]=S[i];
    r[j]=R[i];
    m[j]=M[i];
    d[j]=0;
    c[j]=C[i];
    cn[j]=CN[i];
    cm[j]=CM[i];
    j++;
  }
  free(S); free(R); free(M); free(D); free(C); free(CN); free(CM);
  S=s; R=r; M=m; D=d; C=c; CN=cn; CM=cm;
  N=NM=j;
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

static void rebuildstateindex() {
  int i;
  ensurestates(SN+1);
  for(i=0;i<=SN;i++) SB[i]=SC[i]=0;
  for(i=0;i<N;i++) {
    if(!SC[S[i]]) SB[S[i]]=i;
    SC[S[i]]++;
  }
}

void pglalr() {
  int i,j,k;
  if(directlalr) return;
  for(i=0;i<SN;i++) {
    if(sdeleted(i)) continue;
    for(j=i+1;j<SN;j++) {
      if(sdeleted(j)) continue;
      if(cmpcore(i,j)) continue;
      mergectx(i,j);
      updatetrans(i,j);
      for(k=0;k<N;k++) if(S[k]==j) D[k]=1;
    }
  }
  deduptrans();
  sorttrans();
  purgeds();
  resequence();
  rebuildstateindex();
}

/* ll(1) */
static int *LL;
#define LLAT(i,j) LL[(size_t)(i)*(size_t)TC+(size_t)(j)]
void pgbuildll() {
  int i,j,k,n,p,cn,*t,e;
  rule *rp;
  char *a,**c,b[256];
  char ***vc;
  void **v;

  LL=malloc(sizeof(*LL)*(size_t)NTC*(size_t)TC);
  if(!LL) die("out of memory");
  for(i=0;i<NTC;i++) for(j=0;j<TC;j++) LLAT(i,j)=-1;
  for(i=0;i<RN;i++) {
    rp=&RA[i];
    n=first(rp->rhs,rp->rhsi);
    e=0;
    for(j=0;j<n;j++) {
      if(!F[j]) { e=1; continue; }
      for(k=0;k<TC;k++) if(F[j]==T[k]) break;
      for(p=0;p<NTC;p++) if(rp->lhs==NT[p]) break;
      if(LLAT(p,k)!=-1) {
        if(!quiet) {
          printf("warning: first/first conflict\n");
          printf("         %d. ",LLAT(p,k)); printmp(LLAT(p,k),-1,0,0); printf("\n");
          printf("         %d. ",i); printmp(i,-1,0,0); printf("\n");
        }
        conflicts++;
      }
      else LLAT(p,k)=i;
    }
    if(!e) continue;
    /* first() had empty */
    n=followi(rp->lhs);
    for(j=0;j<AC[n];j++) {
      for(k=0;k<TC;k++) if(AV[n][j]==T[k]) break;
      for(p=0;p<NTC;p++) if(rp->lhs==NT[p]) break;
      if(LLAT(p,k)!=-1) {
        if(!quiet) {
          printf("warning: first/follow conflict\n");
          printf("         %d. ",LLAT(p,k)); printmp(LLAT(p,k),-1,0,0); printf("\n");
          printf("         %d. ",i); printmp(i,-1,0,0); printf("\n");
        }
        conflicts++;
      }
      else LLAT(p,k)=i;
    }
  }

  if(quiet) return;
  cn=TC+1;
  t=malloc(sizeof(*t)*(size_t)cn);
  c=malloc(sizeof(*c)*(size_t)cn);
  vc=calloc((size_t)cn,sizeof(*vc));
  v=malloc(sizeof(*v)*(size_t)cn);
  if(!t||!c||!vc||!v) die("out of memory");
  c[0]=str("");
  for(i=0;i<TC;i++) c[i+1]=T[i];
  for(i=0;i<cn;i++) t[i]=4;
  v[0]=NT;
  for(i=1;i<cn;i++) {
    vc[i]=malloc(sizeof(*vc[i])*(size_t)NTC);
    if(!vc[i]) die("out of memory");
    for(j=0;j<NTC;j++) {
      if(LLAT(j,i-1)==-1) *b=0;
      else sprintf(b,"%2d",LLAT(j,i-1));
      vc[i][j]=str(b);
    }
    v[i]=vc[i];
  }
  printf("\n");
  a = show(cn,NTC,c,t,v,0);
  if(a) { printf("%s",a); free(a); }
  for(i=1;i<cn;i++) free(vc[i]);
  free(t); free(c); free(vc); free(v);
}

static char *tend,*taccept;
void pghll() {
  int i,n=0;
  FILE *fp;
  char **ta=malloc(sizeof(*ta)*(size_t)(TC+NTC));
  if(!ta) die("out of memory");
  if(TC+NTC>TLM) {
    TL=realloc(TL,sizeof(*TL)*(size_t)(TC+NTC));
    TLE=realloc(TLE,sizeof(*TLE)*(size_t)(TC+NTC));
    if(!TL||!TLE) die("out of memory");
    TLM=TC+NTC;
  }
  if(!(fp=fopen("p.h","w+"))) { fprintf(stderr,"error: failed to create p.h\n"); exit(1); }
  fprintf(fp,"#ifndef P_H\n#define P_H\n\n");
  for(i=0;i<NTC;i++) ta[n++]=NT[i];
  for(i=0;i<TC;i++) ta[n++]=T[i];
  for(i=0;i<n;i++) {
    sprintf(TL[i],"T%03d",i);
    fprintf(fp,"#define T%03d %3d /* ",i,i);
    fccomment(fp,ta[i]);
    fprintf(fp," */\n");
    if(ta[i]==str("$a")) taccept=TL[i];
    if(ta[i]==str("$e")) tend=TL[i];
  }
  fprintf(fp,"\n");
  fprintf(fp,"void pgparse(char *p);\n");
  fprintf(fp,"\n#endif /* P_H */\n");
  fclose(fp);
  free(ta);
}

void pgcll() {
  int i,j,k,b=0,m;
  FILE *fp;
  rule *rp;
  char *c;
  if(!(fp=fopen("p.c","w+"))) { fprintf(stderr,"error: failed to create p.c\n"); exit(1); }
  fprintf(fp,"#include \"p.h\"\n");
  fprintf(fp,"#include <stdio.h>\n");
  fprintf(fp,"#include <stdlib.h>\n");
  fprintf(fp,"#include <string.h>\n");
  fprintf(fp,"#include <ctype.h>\n\n");

  fprintf(fp,"/*\n");
  fccomment(fp,arules);
  fprintf(fp,"*/\n\n");

  fprintf(fp,"static int LL[%d][%d]={\n",NTC,NTC+TC);
  for(i=0;i<NTC;i++) {
    fprintf(fp,"{");
    for(j=0;j<NTC;j++) fprintf(fp,"-1,");
    for(j=0;j<TC;j++) fprintf(fp,"%d%s",LLAT(i,j),j==TC-1?"":",");
    fprintf(fp,"}%s\n",i==NTC-1?"":",");
  }
  fprintf(fp,"};\n\n");

  m=0;
  for(i=0;i<RN;i++) if(m<RA[i].rhsi) m=RA[i].rhsi;
  fprintf(fp,"static int RT[%d][%d]={\n",RN,m);
  for(i=0;i<RN;i++) {
    rp=&RA[i];
    fprintf(fp,"{");
    if(!rp->rhsi) fprintf(fp,"-1");
    for(j=0;j<rp->rhsi;j++) {
      c=rp->rhs[j];
      for(k=0;k<NTC;k++) if(c==NT[k]) break;
      if(k<NTC) fprintf(fp,"%s%s",TL[k],j==rp->rhsi-1?"":",");
      else {
        for(k=0;k<TC;k++) if(c==T[k]) break;
        if(k<TC) { fprintf(fp,"%s%s",TL[k+NTC],j==rp->rhsi-1?"":","); continue; }
      }
    }
    fprintf(fp,"}%s\n",i==RN-1?"":",");
  }
  fprintf(fp,"};\n\n");

  fprintf(fp,"static int RC[%d]={",RN);
  for(i=0;i<RN;i++) fprintf(fp,"%d%s",RA[i].rhsi,i==RN-1?"":",");
  fprintf(fp,"};\n");

  fprintf(fp,"typedef struct { char v; int n; } pn;\n");
  fprintf(fp,"static int S[1024],R[1024];\n");
  fprintf(fp,"static pn V[1024];\n");
  fprintf(fp,"static int si=-1,ri=-1,vi=-1;\n\n");

  for(i=0;i<RN;i++) {
    fprintf(fp,"static void r%03d() { /* ",i);
    fccomment(fp,RA[i].r);
    fprintf(fp," */\n}\n");
  }
  fprintf(fp,"\nstatic void (*F[%d])()={",RN);
  for(i=0;i<RN;i++) fprintf(fp,"%sr%03d",b++?",":"",i);
  fprintf(fp,"};\n");

  fprintf(fp,"\n"
"static int t[1024],ti,tc;\n"
"static int v[1024];\n"
"\n"
"static void push(int tt, int tv) {\n"
"  t[tc]=tt;\n"
"  v[tc++]=tv;\n"
"}\n"
"static int lex(char *p) {\n"
"  while(1) {\n"
"    if(!*p) break;\n"
"    while(*p==' ') ++p;\n"
"    if(*p=='\\\\'&&*(p+1)=='\\\\') exit(0);\n"
"    else if(*p=='\\n') break;\n"
"    else { printf(\"lex\\n\"); return 0; }\n"
"  }\n"
"  return 1;\n"
"}\n"
"\n"
"void pgparse(char *p) {\n"
"  int i,j,r;\n"
"  ti=0;tc=0;si=-1;ri=-1;vi=-1;\n"
"  memset(V,0,sizeof(V));\n"
"  if(!lex(p)||tc<1) return;\n"
"  S[++si]=%s; /* $a */\n"
"  for(i=0;;i++) {\n"
"    if(S[si]==t[ti]) {\n"
"      V[++vi].n=v[ti++];\n"
"      --si;\n"
"    }\n"
"    else {\n"
"      r=LL[S[si--]][t[ti]];\n"
"      if(r==-1) { printf(\"parse\\n\"); break; }\n"
"      R[++ri]=r;\n"
"      S[++si]=-2; /* reduction marker */\n"
"      for(j=RC[r]-1;j>=0;j--) S[++si]=RT[r][j];\n"
"    }\n"
"    while(si>=0&&S[si]==-2) { (*F[R[ri--]])(); --si; }\n"
"    if(si<0) { --vi; break; }\n"
"  }\n"
"}\n"
"\n"
"int main() {\n"
"  int c,eof;\n"
"  size_t i,m=2;\n"
"  char *b=malloc(m+2);\n"
"  printf(\"  \");\n"
"  for(;;) {\n"
"    i=0; eof=0;\n"
"    while((c=fgetc(stdin))!=EOF&&c!='\\n') {\n"
"      b[i++]=c;\n"
"      if(i==m) { m<<=1; b=realloc(b,m+2); }\n"
"    }\n"
"    if(c==EOF) eof=1;\n"
"    if(eof&&!i) break;\n"
"    b[i++]='\\n'; b[i]=0;\n"
"    pgparse(b);\n"
"    if(eof) break;\n"
"    printf(\"  \");\n"
"  }\n"
"  return 0;\n"
"}\n",taccept);

  fclose(fp);
}
