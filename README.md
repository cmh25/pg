# pg
a simple parser generator in c

Takes a grammar spec as input and outputs the parse states and shift/reduce action table. Defaults to slr(1), but also supports lr(1), lalr(1), lr(0), and ll(1). Run without any arguments to see synopsis.
```
cmh@ubuntu20:~/pg$ ./pg
usage: ./pg <file> [pretty] [genhc]
   <file>: grammar definition
    [lr0]: build lr(0) parse table
    [slr]: build slr(1) parse table (*default*)
    [lr1]: build lr(1) parse table
   [lalr]: build lalr(1) parse table
    [ll1]: build ll(1) parse table
 [pretty]: pretty print action table
  [genhc]: generate p.h and p.c
  [first]: print first() for each token
 [follow]: print follow() for each token
 [eunitr]: eliminate unit reductions (*experimental*)
 [fullst]: print the full state table
  [showd]: show deleted states and transitions
```

```
cmh@ubuntu20:~/pg$ cat test/000
# dragon book example
e > e '+' t
e > t
t > t '*' f
t > f
f > '(' e ')'
f > n
cmh@ubuntu20:~/pg$
cmh@ubuntu20:~/pg$ ./pg test/000 printstates pretty
n: $a e t f
t: '+' '*' '(' ')' n $e
-------------------------
 0. $a > e
 1. e > e '+' t
 2. e > t
 3. t > t '*' f
 4. t > f
 5. f > '(' e ')'
 6. f > n
---------- state 0 ----------
$a > . e
e > . e '+' t
e > . t
t > . t '*' f
t > . f
f > . '(' e ')'
f > . n
---------- state 1 ----------
$a > e .
e > e . '+' t
---------- state 2 ----------
e > t .
t > t . '*' f
---------- state 3 ----------
t > f .
---------- state 4 ----------
f > '(' . e ')'
e > . e '+' t
e > . t
t > . t '*' f
t > . f
f > . '(' e ')'
f > . n
---------- state 5 ----------
f > n .
---------- state 6 ----------
e > e '+' . t
t > . t '*' f
t > . f
f > . '(' e ')'
f > . n
---------- state 7 ----------
t > t '*' . f
f > . '(' e ')'
f > . n
---------- state 8 ----------
f > '(' e . ')'
e > e . '+' t
---------- state 9 ----------
e > e '+' t .
t > t . '*' f
---------- state 10 ----------
t > t '*' f .
---------- state 11 ----------
f > '(' e ')' .

state '+' '*' '(' ')' n  $e $a e  t  f
----- --- --- --- --- -- -- -- -- -- --
    0         s4      s5        1  2  3
    1 s6                 r0
    2 r2  s7      r2     r2
    3 r4  r4      r4     r4
    4         s4      s5        8  2  3
    5 r6  r6      r6     r6
    6         s4      s5           9  3
    7         s4      s5             10
    8 s6          s11
    9 r1  s7      r1     r1
   10 r3  r3      r3     r3
   11 r5  r5      r5     r5

```
