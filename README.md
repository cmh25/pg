# pg
a simple parser generator in c

Takes a grammar spec as input and outputs the parse states and shift/reduce action table.

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
cmh@ubuntu20:~/pg$ ./pg test/000 pretty
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

state '+' '*' '(' ')' n  $e  e  t  f
----- --- --- --- --- -- --- -- -- --
    0         s4      s5      1  2  3
    1 s6                 acc
    2 r2  s7      r2     r2
    3 r4  r4      r4     r4
    4         s4      s5      8  2  3
    5 r6  r6      r6     r6
    6         s4      s5         9  3
    7         s4      s5           10
    8 s6          s11
    9 r1  s7      r1     r1
   10 r3  r3      r3     r3
   11 r5  r5      r5     r5

```
