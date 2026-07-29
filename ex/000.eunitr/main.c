#include "p.h"
#include <stdio.h>
#include <stdlib.h>

int main() {
  int c,eof;
  size_t i,m=2;
  char *b=malloc(m+2);
  printf("  ");
  for(;;) {
    i=0; eof=0;
    while((c=fgetc(stdin))!=EOF&&c!='\n') {
      b[i++]=c;
      if(i==m) { m<<=1; b=realloc(b,m+2);}
    }
    if(c==EOF) eof=1;
    if(eof&&!i) break;
    b[i++]='\n'; b[i]=0;
    pgparse(b);
    if(eof) break;
    printf("  ");
  }
  return 0;
}
