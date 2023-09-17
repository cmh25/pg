#include "p.h"
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

char *b,*p;

static void gn() {
  char c,*s=p;
  if(*p=='-')p++;
  while(*p&&isdigit(*p++));
  c=*--p;
  *p=0;
  pgpush(T005,atoi(s));
  *p=c;
}

static int gt() {
  while(*p==' ') p++;
  if(!*p) return 0;
  if(isdigit(*p)||(*p=='-'&&isdigit(p[1]))) gn();
  else if(*p=='+') { ++p; pgpush(T004,'+'); }
  else if(*p=='-') { ++p; pgpush(T004,'-'); }
  else if(*p=='*') { ++p; pgpush(T004,'*'); }
  else if(*p=='/') { ++p; pgpush(T004,'/'); }
  else if(*p=='(') { ++p; pgpush(T006,0); }
  else if(*p==')') { ++p; pgpush(T007,0); }
  else if(*p=='\n') { pgpush(T008,0); return 0; }
  else if(*p=='\\'&&*(p+1)=='\\') exit(0);
  else { printf("lex\n"); return 0; }
  return 1;
}

int main() {
  int c;
  size_t i,m=2;
  p=b=malloc(m);
  printf("  ");
  while(1) {
    i=0;
    while((c=fgetc(stdin))&&c!='\n') {
      b[i++]=c;
      if(i==m) { m<<=1; b=realloc(b,m); p=b; }
    }
    if(i==m-1) { m+=2; b=realloc(b,m); p=b; }
    b[i++]='\n'; b[i]=0;
    pgreset();
    while(gt());
    pgparse();
    p=b;
    printf("  ");
  }
  return 0;
} 
