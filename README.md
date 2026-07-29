# pg
A small parser generator in C.

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
 [eunitr]: eliminate unit reductions from an LR parser
 [strict]: return failure when the grammar has conflicts
  [quiet]: suppress the grammar, table, and individual conflict reports
 [fullst]: print the full state table
  [showd]: show deleted states and transitions
```

Grammar rules have the form `lhs operator rhs`. The operator is retained for
display, so both `>` and `::=` may be used. Alternatives can be placed after
`|`, an empty alternative denotes epsilon, and a line beginning with `|` extends
the previous rule. Symbols appearing on a left-hand side are nonterminals; all
other symbols are terminals. Inline comments begin with `#` outside quotes.
`//` comments are also accepted.

The `*`, `+`, `?`, and `[symbol]` shorthands create helper productions. For
example, `items > item*` permits zero or more `item` symbols.

A rule whose `::=` is followed by a newline uses multiline EBNF. Parenthesized
groups, nested alternatives, and postfix `*`, `+`, and `?` are lowered to BNF:

```
arguments ::=
  expression ( comma expression )*
```

Grammar rules, symbols, LR items, transitions, and lookahead sets grow
dynamically. LALR lookaheads are propagated directly over the LR(0) machine
instead of constructing a canonical LR(1) machine first.

`eunitr` applies Pager's unit-production elimination algorithm to a completed LR
machine. It should only be used on a conflict-free LR grammar. Generated
semantic actions for unit productions are omitted, so do not use it when those
unit reductions need observable semantic actions.

`make test` runs the table snapshots, behavioral regression tests, and examples.
`make testv` runs the snapshot matrix under Valgrind.
From a Visual Studio developer command prompt, `make.bat test` builds `pg` and
runs the snapshot, behavioral, and example regression tests with MSVC.

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
