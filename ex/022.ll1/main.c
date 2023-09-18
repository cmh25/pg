#include "p.h"
#include <stdio.h>
#include <stdlib.h>

int main() {
  int c;
  size_t i,m=2;
  char *b=malloc(m);
  printf("  ");
  for(i=0;;i=0) {
    while((c=fgetc(stdin))&&c!='\n') {
      b[i++]=c;
      if(i==m) { m<<=1; b=realloc(b,m+2); }
    }
    b[i++]='\n'; b[i]=0;
    pgparse(b);
    printf("  ");
  }
  return 0;
}
