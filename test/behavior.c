#ifndef _WIN32
#define _XOPEN_SOURCE 700
#endif

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#define strtok_r strtok_s
#else
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#endif

#define MAX_RULES 128
#define MAX_RHS 32
#define MAX_CELLS 8192
#define MAX_LEAVES 128
#define MAX_TOKEN 64
#define MAX_STACK 10000
#define MAX_TEST_INPUT 8
#define MAX_CHART_ITEMS 8192
#define PATH_CAP 4096

typedef struct {
  int number;
  char lhs[MAX_TOKEN];
  char rhs[MAX_RHS][MAX_TOKEN];
  int rhsn;
} Rule;

typedef struct {
  int state;
  char token[MAX_TOKEN];
  int action;
  int target;
  int rule;
} Cell;

typedef struct {
  Rule rules[MAX_RULES];
  int rulen;
  Cell cells[MAX_CELLS];
  int celln;
  char leaves[MAX_LEAVES][MAX_TOKEN];
  int leafn;
  int optimized;
} Machine;

typedef struct {
  char *output;
  int status;
} Result;

typedef struct {
  int rule;
  int dot;
  int origin;
} Item;

typedef struct {
  Item item[MAX_CHART_ITEMS];
  int count;
} ItemSet;

static char pgpath[PATH_CAP];
static ItemSet *earley_chart;

static void fail(const char *message, const char *detail) {
  fprintf(stderr,"behavior: %s\n",message);
  if(detail&&*detail) fprintf(stderr,"%s\n",detail);
  exit(1);
}

static void require(int condition, const char *message, const char *detail) {
  if(!condition) fail(message,detail);
}

static void *xrealloc(void *p, size_t n) {
  void *q=realloc(p,n);
  if(!q) fail("out of memory",0);
  return q;
}

static char *xstrdup(const char *s) {
  size_t n=strlen(s)+1;
  char *copy=malloc(n);
  if(!copy) fail("out of memory",0);
  memcpy(copy,s,n);
  return copy;
}

static void make_temp_file(char *path, size_t size) {
#ifdef _WIN32
  char directory[PATH_CAP];
  DWORD n=GetTempPathA((DWORD)sizeof(directory),directory);
  (void)size;
  require(n>0&&n<sizeof(directory),"GetTempPath failed",0);
  require(GetTempFileNameA(directory,"pgb",0,path)!=0,
          "GetTempFileName failed",0);
#else
  int fd;
  require(size>=sizeof("/tmp/pg-behavior-XXXXXX"),"temporary path is too small",0);
  strcpy(path,"/tmp/pg-behavior-XXXXXX");
  fd=mkstemp(path);
  require(fd>=0,"mkstemp failed",strerror(errno));
  close(fd);
#endif
}

static void make_temp_directory(char *path, size_t size) {
#ifdef _WIN32
  make_temp_file(path,size);
  require(remove(path)==0,"could not prepare temporary directory",path);
  require(CreateDirectoryA(path,0)!=0,"CreateDirectory failed",path);
#else
  require(size>=sizeof("/tmp/pg-codegen-XXXXXX"),"temporary path is too small",0);
  strcpy(path,"/tmp/pg-codegen-XXXXXX");
  require(mkdtemp(path)!=0,"mkdtemp failed",strerror(errno));
#endif
}

static void remove_directory(const char *path) {
#ifdef _WIN32
  require(RemoveDirectoryA(path)!=0,"RemoveDirectory failed",path);
#else
  require(rmdir(path)==0,"rmdir failed",path);
#endif
}

static int absolute_path(const char *input, char *output, size_t size) {
#ifdef _WIN32
  return _fullpath(output,input,size)!=0;
#else
  (void)size;
  return realpath(input,output)!=0;
#endif
}

#ifdef _WIN32

static void append_argument(char *command, size_t size, const char *argument) {
  size_t used=strlen(command),i;
  require(used+4<size,"Windows command line is too long",0);
  if(used) command[used++]=' ';
  command[used++]='"';
  for(i=0;argument[i];i++) {
    if(argument[i]=='"') {
      require(used+2<size,"Windows command line is too long",0);
      command[used++]='\\';
    }
    require(used+1<size,"Windows command line is too long",0);
    command[used++]=argument[i];
  }
  command[used++]='"';
  command[used]=0;
}

static Result run_argv(char *const argv[], const char *directory) {
  SECURITY_ATTRIBUTES security={sizeof(security),0,TRUE};
  STARTUPINFOA startup;
  PROCESS_INFORMATION process;
  HANDLE output_read,output_write;
  Result r={0};
  size_t n=0,m=4096;
  DWORD count,status;
  char command[32768]="";
  int i;
  for(i=0;argv[i];i++) append_argument(command,sizeof(command),argv[i]);
  require(CreatePipe(&output_read,&output_write,&security,0)!=0,
          "CreatePipe failed",0);
  require(SetHandleInformation(output_read,HANDLE_FLAG_INHERIT,0)!=0,
          "SetHandleInformation failed",0);
  memset(&startup,0,sizeof(startup));
  startup.cb=sizeof(startup);
  startup.dwFlags=STARTF_USESTDHANDLES;
  startup.hStdInput=GetStdHandle(STD_INPUT_HANDLE);
  startup.hStdOutput=output_write;
  startup.hStdError=output_write;
  memset(&process,0,sizeof(process));
  if(!CreateProcessA(0,command,0,0,TRUE,0,0,directory,&startup,&process)) {
    CloseHandle(output_read);
    CloseHandle(output_write);
    fail("CreateProcess failed",command);
  }
  CloseHandle(output_write);
  r.output=malloc(m);
  if(!r.output) fail("out of memory",0);
  for(;;) {
    if(n+2048+1>m) { m*=2; r.output=xrealloc(r.output,m); }
    if(!ReadFile(output_read,r.output+n,(DWORD)(m-n-1),&count,0)||!count) break;
    n+=count;
  }
  CloseHandle(output_read);
  r.output[n]=0;
  WaitForSingleObject(process.hProcess,INFINITE);
  require(GetExitCodeProcess(process.hProcess,&status)!=0,
          "GetExitCodeProcess failed",0);
  r.status=(int)status;
  CloseHandle(process.hThread);
  CloseHandle(process.hProcess);
  return r;
}

#else

static Result collect(pid_t child, int fd) {
  Result r={0};
  size_t n=0,m=4096;
  ssize_t c;
  int status;
  r.output=malloc(m);
  if(!r.output) fail("out of memory",0);
  for(;;) {
    if(n+2048+1>m) { m*=2; r.output=xrealloc(r.output,m); }
    c=read(fd,r.output+n,m-n-1);
    if(c<0) {
      if(errno==EINTR) continue;
      fail("read failed",strerror(errno));
    }
    if(!c) break;
    n+=(size_t)c;
  }
  close(fd);
  r.output[n]=0;
  if(waitpid(child,&status,0)<0) fail("waitpid failed",strerror(errno));
  if(WIFEXITED(status)) r.status=WEXITSTATUS(status);
  else r.status=128;
  return r;
}

static Result run_argv(char *const argv[], const char *directory) {
  int out[2];
  pid_t child;
  if(pipe(out)<0) fail("pipe failed",strerror(errno));
  child=fork();
  if(child<0) fail("fork failed",strerror(errno));
  if(!child) {
    close(out[0]);
    if(dup2(out[1],STDOUT_FILENO)<0||dup2(out[1],STDERR_FILENO)<0) _exit(126);
    close(out[1]);
    if(directory&&chdir(directory)<0) _exit(126);
    execvp(argv[0],argv);
    _exit(127);
  }
  close(out[1]);
  return collect(child,out[0]);
}

#endif

static Result run_pg(const char *grammar, const char *directory,
                     const char **options) {
  char name[PATH_CAP];
  char *argv[16];
  FILE *file;
  int i=0;
  Result r;
  make_temp_file(name,sizeof(name));
  file=fopen(name,"wb");
  require(file!=0,"could not open temporary grammar",name);
  require(fwrite(grammar,1,strlen(grammar),file)==strlen(grammar),
          "could not write temporary grammar",name);
  require(fclose(file)==0,"could not close temporary grammar",name);
  argv[i++]=pgpath;
  argv[i++]=name;
  while(options&&*options) argv[i++]=(char*)*options++;
  argv[i]=0;
  r=run_argv(argv,directory);
  remove(name);
  return r;
}

static void free_result(Result *r) {
  free(r->output);
  r->output=0;
}

static int count_text(const char *text, const char *needle) {
  int n=0;
  size_t len=strlen(needle);
  while((text=strstr(text,needle))) { n++; text+=len; }
  return n;
}

static int has_lhs(Machine *m, const char *symbol) {
  int i;
  for(i=1;i<m->rulen;i++) if(!strcmp(m->rules[i].lhs,symbol)) return 1;
  return 0;
}

static int unit_lhs(Machine *m, const char *symbol) {
  int i;
  for(i=1;i<m->rulen;i++)
    if(m->rules[i].rhsn==1&&!strcmp(m->rules[i].lhs,symbol)) return 1;
  return 0;
}

static int leaf_index(Machine *m, const char *symbol) {
  int i;
  for(i=0;i<m->leafn;i++) if(!strcmp(m->leaves[i],symbol)) return i;
  return -1;
}

static void find_leaves(Machine *m) {
  int i;
  for(i=1;i<m->rulen;i++) {
    Rule *r=&m->rules[i];
    if(r->rhsn!=1||unit_lhs(m,r->rhs[0])||leaf_index(m,r->rhs[0])>=0) continue;
    require(m->leafn<MAX_LEAVES,"too many leaves in test machine",0);
    strcpy(m->leaves[m->leafn++],r->rhs[0]);
  }
}

static void parse_machine(Machine *m, const char *output, int optimized) {
  char *copy=xstrdup(output),*line,*save=0;
  int table=0;
  require(copy!=0,"out of memory",0);
  memset(m,0,sizeof(*m));
  m->optimized=optimized;
  for(line=strtok_r(copy,"\n",&save);line;line=strtok_r(0,"\n",&save)) {
    size_t length=strlen(line);
    int number,state,action,target,rule,fields;
    char lhs[MAX_TOKEN],op[MAX_TOKEN],token[MAX_TOKEN],rest[1024],*p,*word,*wsave=0;
    if(length&&line[length-1]=='\r') line[length-1]=0;
    if(!strncmp(line,"state",5)&&strstr(line,"token")&&
       strstr(line,"action")&&strstr(line,"goto")&&strstr(line,"rule")) {
      table=1;
      continue;
    }
    rest[0]=0;
    fields=sscanf(line," %d. %63s %63s %1023[^\r\n]",
                  &number,lhs,op,rest);
    if(!table&&fields>=3) {
      Rule *r;
      require(number>=0&&number<MAX_RULES,"rule number outside test limits",line);
      r=&m->rules[number];
      memset(r,0,sizeof(*r));
      r->number=number;
      strcpy(r->lhs,lhs);
      p=rest;
      while((word=strtok_r(p," \t",&wsave))) {
        p=0;
        require(r->rhsn<MAX_RHS,"rule RHS outside test limits",line);
        strcpy(r->rhs[r->rhsn++],word);
      }
      if(number>=m->rulen) m->rulen=number+1;
      continue;
    }
    if(table&&sscanf(line," %d %63s %d %d %d",
                     &state,token,&action,&target,&rule)==5) {
      Cell *c;
      require(m->celln<MAX_CELLS,"too many table cells in test machine",0);
      c=&m->cells[m->celln++];
      c->state=state;
      strcpy(c->token,token);
      c->action=action;
      c->target=target;
      c->rule=rule;
    }
  }
  free(copy);
  require(m->rulen>1&&m->celln>0,"could not parse generated machine",output);
  find_leaves(m);
}

static int derives1(Machine *m, const char *from, const char *to,
                    char seen[][MAX_TOKEN], int nseen) {
  int i;
  if(!strcmp(from,to)) return 1;
  if(!has_lhs(m,from)) return 0;
  for(i=0;i<nseen;i++) if(!strcmp(seen[i],from)) return 0;
  if(nseen>=MAX_RULES) return 0;
  strcpy(seen[nseen++],from);
  for(i=1;i<m->rulen;i++) {
    Rule *r=&m->rules[i];
    if(r->rhsn!=1||strcmp(r->lhs,from)) continue;
    if(derives1(m,r->rhs[0],to,seen,nseen)) return 1;
  }
  return 0;
}

static int derives(Machine *m, const char *from, const char *to) {
  char seen[MAX_RULES][MAX_TOKEN];
  return derives1(m,from,to,seen,0);
}

static const char *representative(Machine *m, const char *symbol) {
  int i;
  if(!m->optimized) return symbol;
  for(i=0;i<m->leafn;i++)
    if(derives(m,symbol,m->leaves[i])) return m->leaves[i];
  return symbol;
}

static Cell *action_cell(Machine *m, int state, const char *token) {
  int i;
  Cell *found=0;
  for(i=0;i<m->celln;i++) {
    Cell *c=&m->cells[i];
    if(c->state!=state||c->action==2||strcmp(c->token,token)) continue;
    if(found&&(found->action!=c->action||
       (c->action?found->target!=c->target:found->rule!=c->rule)))
      fail("conflicting actions remained in generated table",token);
    found=c;
  }
  return found;
}

static int goto_state(Machine *m, int state, const char *symbol) {
  int i,target=-1;
  symbol=representative(m,symbol);
  for(i=0;i<m->celln;i++) {
    Cell *c=&m->cells[i];
    if(c->state!=state||c->action!=2||strcmp(c->token,symbol)) continue;
    if(target>=0&&target!=c->target) fail("conflicting gotos remained",symbol);
    target=c->target;
  }
  return target;
}

static int machine_accepts(Machine *m, const char **tokens, int tokenn) {
  int stack[MAX_STACK],sp=0,position=0,steps;
  stack[0]=0;
  for(steps=0;steps<MAX_STACK;steps++) {
    const char *token=position<tokenn?tokens[position]:"$e";
    Cell *c=action_cell(m,stack[sp],token);
    Rule *r;
    int target;
    if(!c) return 0;
    if(c->action==1) {
      if(++sp>=MAX_STACK) fail("test parser stack overflow",0);
      stack[sp]=c->target;
      position++;
      if(position>tokenn) return 0;
      continue;
    }
    if(!c->rule) return position==tokenn;
    r=&m->rules[c->rule];
    if(r->rhsn>sp) return 0;
    sp-=r->rhsn;
    target=goto_state(m,stack[sp],r->lhs);
    if(target<0) return 0;
    stack[++sp]=target;
  }
  fail("test parser did not terminate",0);
  return 0;
}

static int same_item(Item a, Item b) {
  return a.rule==b.rule&&a.dot==b.dot&&a.origin==b.origin;
}

static Item make_item(int rule, int dot, int origin) {
  Item item;
  item.rule=rule;
  item.dot=dot;
  item.origin=origin;
  return item;
}

static void add_item(ItemSet *set, Item item) {
  int i;
  for(i=0;i<set->count;i++) if(same_item(set->item[i],item)) return;
  require(set->count<MAX_CHART_ITEMS,"Earley chart outside test limits",0);
  set->item[set->count++]=item;
}

static int cfg_accepts(Machine *grammar, const char **tokens, int tokenn) {
  ItemSet *chart;
  int position,index,i,accepted=0;
  require(tokenn<=MAX_TEST_INPUT,"test input outside Earley limits",0);
  if(!earley_chart) {
    earley_chart=calloc(MAX_TEST_INPUT+1,sizeof(*earley_chart));
    require(earley_chart!=0,"out of memory",0);
  }
  chart=earley_chart;
  memset(chart,0,((size_t)tokenn+1)*sizeof(*chart));
  add_item(&chart[0],make_item(0,0,0));
  for(position=0;position<=tokenn;position++) {
    for(index=0;index<chart[position].count;index++) {
      Item item=chart[position].item[index];
      Rule *r=&grammar->rules[item.rule];
      if(item.dot<r->rhsn&&has_lhs(grammar,r->rhs[item.dot])) {
        for(i=1;i<grammar->rulen;i++)
          if(!strcmp(grammar->rules[i].lhs,r->rhs[item.dot]))
            add_item(&chart[position],make_item(i,0,position));
      }
      else if(item.dot==r->rhsn) {
        ItemSet *origin=&chart[item.origin];
        for(i=0;i<origin->count;i++) {
          Item parent=origin->item[i];
          Rule *p=&grammar->rules[parent.rule];
          if(parent.dot<p->rhsn&&!strcmp(p->rhs[parent.dot],r->lhs))
            add_item(&chart[position],
                     make_item(parent.rule,parent.dot+1,parent.origin));
        }
      }
    }
    if(position==tokenn) continue;
    for(index=0;index<chart[position].count;index++) {
      Item item=chart[position].item[index];
      Rule *r=&grammar->rules[item.rule];
      if(item.dot<r->rhsn&&!strcmp(r->rhs[item.dot],tokens[position]))
        add_item(&chart[position+1],
                 make_item(item.rule,item.dot+1,item.origin));
    }
  }
  for(i=0;i<chart[tokenn].count;i++) {
    Item item=chart[tokenn].item[i];
    if(item.rule==0&&item.dot==grammar->rules[0].rhsn&&item.origin==0) {
      accepted=1;
      break;
    }
  }
  return accepted;
}

static int has_unit_reduction(Machine *m) {
  int i;
  for(i=0;i<m->celln;i++) {
    Cell *c=&m->cells[i];
    if(c->action==0&&c->rule>0&&m->rules[c->rule].rhsn==1) return 1;
  }
  return 0;
}

static void compare_eunitr(const char *grammar, const char **alphabet,
                           int alphabetn, int maxlen, const char *mode) {
  const char *baseopt[]={mode,0},*unitopt[]={mode,"eunitr",0};
  Result br=run_pg(grammar,0,baseopt),ur=run_pg(grammar,0,unitopt);
  Machine *base=calloc(1,sizeof(*base)),*unit=calloc(1,sizeof(*unit));
  const char *tokens[MAX_TEST_INPUT];
  int length,total,number,i,a,b,e;
  require(base!=0&&unit!=0,"out of memory",0);
  require(br.status==0,"base parser generation failed",br.output);
  require(ur.status==0,"eunitr parser generation failed",ur.output);
  parse_machine(base,br.output,0);
  parse_machine(unit,ur.output,1);
  for(length=0;length<=maxlen;length++) {
    total=1;
    for(i=0;i<length;i++) total*=alphabetn;
    for(number=0;number<total;number++) {
      int value=number;
      for(i=0;i<length;i++) {
        tokens[i]=alphabet[value%alphabetn];
        value/=alphabetn;
      }
      a=machine_accepts(base,tokens,length);
      b=machine_accepts(unit,tokens,length);
      e=cfg_accepts(base,tokens,length);
      if(a!=e||b!=e) {
        char detail[256];
        snprintf(detail,sizeof(detail),
                 "%s length %d case %d: base=%d eunitr=%d grammar=%d",
                 mode,length,number,a,b,e);
        fail("generated parser disagrees with grammar",detail);
      }
    }
  }
  require(!has_unit_reduction(unit),"eunitr left a unit reduction",ur.output);
  free(base);
  free(unit);
  free_result(&br);
  free_result(&ur);
}

static void codegen_comment_test(void) {
  char directory[PATH_CAP];
  const char *options[]={"slr","genhc",0};
#ifdef _WIN32
  char *ccargv[]={"cl","/nologo","/Zs","p.c",0};
#else
  char *ccargv[]={"cc","-std=c11","-fsyntax-only","p.c",0};
#endif
  Result generated,compiled;
  make_temp_directory(directory,sizeof(directory));
  generated=run_pg("S > '*/'\n",directory,options);
  require(generated.status==0,"code generation failed",generated.output);
  compiled=run_argv(ccargv,directory);
  require(compiled.status==0,"generated C did not compile",compiled.output);
  free_result(&generated);
  free_result(&compiled);
  {
    char path[PATH_CAP+16];
    snprintf(path,sizeof(path),"%s/p.c",directory); remove(path);
    snprintf(path,sizeof(path),"%s/p.h",directory); remove(path);
  }
  remove_directory(directory);
}

int main(int argc, char **argv) {
  const char *configured=getenv("PG");
  char default_pg[PATH_CAP+16],executable[PATH_CAP],*slash,*backslash;
  const char *expression=
    "e > e '+' t\n"
    "e > t\n"
    "t > t '*' f\n"
    "t > f\n"
    "f > '(' e ')'\n"
    "f > n\n";
  const char *expralpha[]={"'+'","'*'","'('","')'","n"};
  const char *pager=
    "S > d i A\n"
    "A > A T |\n"
    "T > M | Y | P | B\n"
    "M > r | c\n"
    "Y > x | f\n"
    "P > n | o\n"
    "B > a | e\n";
  const char *pageralpha[]={"d","i","r","c","x","a"};
  Result r,q;
  char longest[1024]="S >",too_long[1024]="S >";
  int i;

  (void)argc;
  if(!configured) {
    require(absolute_path(argv[0],executable,sizeof(executable)),
            "cannot resolve behavior test executable",argv[0]);
    slash=strrchr(executable,'/');
    backslash=strrchr(executable,'\\');
    if(backslash&&(!slash||backslash>slash)) slash=backslash;
    require(slash!=0,"behavior test executable has no directory",executable);
    *slash=0;
#ifdef _WIN32
    snprintf(default_pg,sizeof(default_pg),"%s/../pg.exe",executable);
#else
    snprintf(default_pg,sizeof(default_pg),"%s/../pg",executable);
#endif
    configured=default_pg;
  }
  require(absolute_path(configured,pgpath,sizeof(pgpath)),
          "cannot resolve pg executable",configured);

  {
    const char *options[]={"ll1","first",0};
    r=run_pg("S > A b\nA > | a\n",0,options);
    require(r.status==0,"nullable FIRST generation failed",r.output);
    require(strstr(r.output,"first(S) = b a")!=0,"FIRST(S) is wrong",r.output);
    require(strstr(r.output,"first(S) = <empty>")==0,
            "FIRST(S) incorrectly contains epsilon",r.output);
    free_result(&r);
  }

  {
    const char *options[]={"lr1",0};
    const char *a[]={"x","a"},*b[]={"x","b"},*x[]={"x"};
    Machine *m=calloc(1,sizeof(*m));
    require(m!=0,"out of memory",0);
    r=run_pg("S > A a | A b\nA > B C\nC >\nB > x\n",0,options);
    require(r.status==0,"LR(1) nullable-suffix generation failed",r.output);
    parse_machine(m,r.output,0);
    require(machine_accepts(m,a,2),"LR(1) rejected x a",r.output);
    require(machine_accepts(m,b,2),"LR(1) rejected x b",r.output);
    require(!machine_accepts(m,x,1),"LR(1) accepted x",r.output);
    free(m);
    free_result(&r);
  }

  {
    const char *options[]={"slr","strict",0};
    const char *a[]={"a"},*bbc[]={"b","b","c"},*c[]={"c"};
    Machine *m=calloc(1,sizeof(*m));
    require(m!=0,"out of memory",0);
    r=run_pg("S ::=\n  ( a | b )+ c?\n",0,options);
    require(r.status==0,"multiline EBNF generation failed",r.output);
    parse_machine(m,r.output,0);
    require(machine_accepts(m,a,1),"EBNF rejected a",r.output);
    require(machine_accepts(m,bbc,3),"EBNF rejected b b c",r.output);
    require(!machine_accepts(m,c,1),"EBNF accepted c",r.output);
    require(!machine_accepts(m,0,0),"EBNF accepted empty input",r.output);
    free(m);
    free_result(&r);
  }

  {
    const char *options[]={"slr","strict",0};
    r=run_pg("E > E + E | id\n",0,options);
    require(r.status==2,"strict accepted an ambiguous grammar",r.output);
    require(strstr(r.output,"shift/reduce conflict")!=0,
            "missing shift/reduce warning",r.output);
    free_result(&r);
  }

  {
    const char *grammar=
      "S > a A d | b A e | a B e | b B d\n"
      "A > c\n"
      "B > c\n";
    const char *lr1[]={"lr1","strict",0},*lalr[]={"lalr","strict",0};
    r=run_pg(grammar,0,lr1);
    q=run_pg(grammar,0,lalr);
    require(r.status==0,"canonical LR(1) grammar reported a conflict",r.output);
    require(q.status==2,"non-LALR grammar passed LALR strict mode",q.output);
    require(strstr(q.output,"reduce/reduce conflict")!=0,
            "missing LALR reduce/reduce warning",q.output);
    free_result(&r); free_result(&q);
  }

  compare_eunitr(expression,expralpha,5,5,"slr");
  compare_eunitr(expression,expralpha,5,4,"lr1");
  compare_eunitr(expression,expralpha,5,4,"lalr");
  {
    const char *a[]={"a"};
    compare_eunitr("A > a\n",a,1,2,"slr");
  }
  {
    const char *a[]={"x"};
    compare_eunitr("S > A\nA > B\nB >\n",a,1,2,"slr");
  }
  {
    const char *a[]={"x","y","z"};
    compare_eunitr("S > A z\nA > B | x y\nB > x\n",a,3,4,"slr");
  }
  {
    const char *a[]={"b","d","e"};
    compare_eunitr("G > A b\nG > B d\nA > C\nB > C\nC > e e\n",
                   a,3,4,"slr");
  }
  {
    const char *a[]={"x","c","q"};
    compare_eunitr("S > A q\nA > B c\nB > x\n",a,3,4,"slr");
  }
  compare_eunitr(pager,pageralpha,6,4,"slr");

  {
    const char *base[]={"lr1","printstates",0};
    const char *unit[]={"lr1","eunitr","printstates",0};
    r=run_pg(pager,0,base);
    q=run_pg(pager,0,unit);
    require(r.status==0&&count_text(r.output,"---------- state")==18,
            "Pager example did not produce 18 LR(1) states",r.output);
    require(q.status==0&&count_text(q.output,"---------- state")==6,
            "Pager example did not optimize to 6 states",q.output);
    free_result(&r); free_result(&q);
  }

  {
    const char *options[]={"slr","eunitr",0};
    r=run_pg("E > E + E | id\n",0,options);
    require(r.status!=0,"eunitr accepted a conflicted grammar",r.output);
    require(strstr(r.output,"cannot eliminate unit reductions")!=0,
            "missing conflicted-eunitr error",r.output);
    free_result(&r);
  }

  r=run_pg("# no productions\n",0,0);
  require(r.status!=0&&strstr(r.output,"no productions")!=0,
          "empty grammar was not rejected",r.output);
  free_result(&r);

  for(i=0;i<32;i++) {
    char token[16];
    snprintf(token,sizeof(token)," x%d",i);
    strcat(longest,token);
    strcat(too_long,token);
  }
  strcat(longest,"\n");
  strcat(too_long," x32\n");
  {
    const char *options[]={"slr",0};
    r=run_pg(longest,0,options);
    q=run_pg(too_long,0,options);
    require(r.status==0,"32-symbol RHS was rejected",r.output);
    require(q.status==0,"dynamic 33-symbol RHS was rejected",q.output);
    free_result(&r); free_result(&q);
  }

  {
    const char *options[]={"slr","quiet",0};
    char *large=calloc(1,65536);
    size_t used;
    require(large!=0,"out of memory",0);
    strcpy(large,"S > ok\n");
    used=strlen(large);
    for(i=0;i<1100;i++) {
      int n=snprintf(large+used,65536-used,"N%d > t%d\n",i,i);
      require(n>0&&(size_t)n<65536-used,"large grammar test overflow",0);
      used+=(size_t)n;
    }
    r=run_pg(large,0,options);
    require(r.status==0,"dynamic large grammar was rejected",r.output);
    free_result(&r);
    free(large);
  }

  {
    const char *options[]={"slr","eunitr","pretty",0};
    r=run_pg(expression,0,options);
    require(r.status==0&&strstr(r.output,"state")!=0,
            "pretty eunitr table failed",r.output);
    free_result(&r);
  }

  codegen_comment_test();
  free(earley_chart);
  puts("behavior: pass");
  return 0;
}
