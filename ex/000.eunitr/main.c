#include "p.h"
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

char b[256],*p=b;;

static void gn() {
  char *s=p;
  if(*p=='-')p++;
  while(*p&&isdigit(*p++));
  p--;
  pgta[pgi]=T004;
  pgva[pgi++]=atoi(s);
}

static int gt() {
  while(*p==' ') p++;
  if(!*p) return 0;
  if(isdigit(*p)||(*p=='-'&&isdigit(p[1]))) gn();
  else if(*p=='+') { ++p; pgta[pgi]=T000; pgva[pgi++]=0; }
  else if(*p=='*') { ++p; pgta[pgi]=T001; pgva[pgi++]=0; }
  else if(*p=='(') { ++p; pgta[pgi]=T002; pgva[pgi++]=0; }
  else if(*p==')') { ++p; pgta[pgi]=T003; pgva[pgi++]=0; }
  else if(*p=='\n') { pgta[pgi]=T005; pgva[pgi++]=0; return 0; }
  else if(*p=='\\'&&*(p+1)=='\\') exit(0);
  else { printf("parse\n"); return 0; }
  return 1;
}

int main() {
  printf("  ");
  while(fgets(b,256,stdin)) {
    pgi=0;
    while(gt());
    parse();
    p=b;
    printf("  ");
  }
  return 0;
}
