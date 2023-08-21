n: $a s e o list elist plist
t: ';' Q V N '(' ')' '[' ']' $e
-------------------------
 0. $a > s
 1. s >
 2. s > e
 3. s > e ';'
 4. s > Q
 5. e > o
 6. e > o V e
 7. e > V e
 8. e > V plist
 9. o > N
10. o > '(' e ')'
11. o > list
12. o > plist
13. o > o e
14. list > '(' elist ')'
15. elist >
16. elist > e
17. elist > elist ';' e
18. elist > elist ';'
19. plist > '[' elist ']'
warning: shift/reduce conflict state[4] token[V]
         6. e > o . V e
         5. e > o .
warning: shift/reduce conflict state[4] token[V]
         6. e > o . V e
         5. e > o .
warning: shift/reduce conflict state[4] token[V]
         6. e > o . V e
         5. e > o .
warning: shift/reduce conflict state[4] token[V]
         6. e > o . V e
         5. e > o .
warning: shift/reduce conflict state[4] token[N]
         9. o > . N
         5. e > o .
warning: shift/reduce conflict state[4] token[V]
         6. e > o . V e
         5. e > o .
warning: shift/reduce conflict state[4] token[N]
         9. o > . N
         5. e > o .
warning: shift/reduce conflict state[4] token['(']
         10. o > . '(' e ')'
         5. e > o .
warning: shift/reduce conflict state[4] token[V]
         6. e > o . V e
         5. e > o .
warning: shift/reduce conflict state[4] token[N]
         9. o > . N
         5. e > o .
warning: shift/reduce conflict state[4] token['(']
         10. o > . '(' e ')'
         5. e > o .
warning: shift/reduce conflict state[4] token[V]
         6. e > o . V e
         5. e > o .
warning: shift/reduce conflict state[4] token[N]
         9. o > . N
         5. e > o .
warning: shift/reduce conflict state[4] token['(']
         10. o > . '(' e ')'
         5. e > o .
warning: reduce/reduce conflict state[15] token[$e]
         8. e > V plist .
         12. o > plist .
warning: reduce/reduce conflict state[15] token[V]
         8. e > V plist .
         12. o > plist .
warning: reduce/reduce conflict state[15] token[N]
         8. e > V plist .
         12. o > plist .
warning: reduce/reduce conflict state[15] token['(']
         8. e > V plist .
         12. o > plist .
warning: reduce/reduce conflict state[15] token['[']
         8. e > V plist .
         12. o > plist .
warning: reduce/reduce conflict state[15] token[';']
         8. e > V plist .
         12. o > plist .
warning: reduce/reduce conflict state[15] token[')']
         8. e > V plist .
         12. o > plist .
warning: reduce/reduce conflict state[15] token[$e]
         8. e > V plist .
         12. o > plist .
warning: reduce/reduce conflict state[15] token[']']
         8. e > V plist .
         12. o > plist .
warning: shift/reduce conflict state[16] token[')']
         10. o > '(' e . ')'
         16. elist > e .
warning: shift/reduce conflict state[16] token[')']
         10. o > '(' e . ')'
         16. elist > e .
warning: reduce/reduce conflict state[19] token[$e]
         6. e > o V e .
         7. e > V e .
warning: reduce/reduce conflict state[19] token[';']
         6. e > o V e .
         7. e > V e .
warning: reduce/reduce conflict state[19] token[')']
         6. e > o V e .
         7. e > V e .
warning: reduce/reduce conflict state[19] token[$e]
         6. e > o V e .
         7. e > V e .
warning: reduce/reduce conflict state[19] token[V]
         6. e > o V e .
         7. e > V e .
warning: reduce/reduce conflict state[19] token[N]
         6. e > o V e .
         7. e > V e .
warning: reduce/reduce conflict state[19] token['(']
         6. e > o V e .
         7. e > V e .
warning: reduce/reduce conflict state[19] token['[']
         6. e > o V e .
         7. e > V e .
warning: reduce/reduce conflict state[19] token[']']
         6. e > o V e .
         7. e > V e .
---------- state 0 ----------
$a > . s
s > .
s > . e
s > . e ';'
s > . Q
e > . o
e > . o V e
e > . V e
e > . V plist
o > . N
o > . '(' e ')'
o > . list
o > . plist
o > . o e
list > . '(' elist ')'
plist > . '[' elist ']'
---------- state 1 ----------
$a > s .
---------- state 2 ----------
s > e .
s > e . ';'
---------- state 3 ----------
s > Q .
---------- state 4 ----------
e > o .
e > o . V e
o > o . e
e > . o
e > . o V e
e > . V e
e > . V plist
o > . N
o > . '(' e ')'
o > . list
o > . plist
o > . o e
list > . '(' elist ')'
plist > . '[' elist ']'
---------- state 5 ----------
e > V . e
e > V . plist
e > . o
e > . o V e
e > . V e
e > . V plist
plist > . '[' elist ']'
o > . N
o > . '(' e ')'
o > . list
o > . plist
o > . o e
list > . '(' elist ')'
---------- state 6 ----------
o > N .
---------- state 7 ----------
o > '(' . e ')'
list > '(' . elist ')'
e > . o
e > . o V e
e > . V e
e > . V plist
elist > .
elist > . e
elist > . elist ';' e
elist > . elist ';'
o > . N
o > . '(' e ')'
o > . list
o > . plist
o > . o e
list > . '(' elist ')'
plist > . '[' elist ']'
---------- state 8 ----------
o > list .
---------- state 9 ----------
o > plist .
---------- state 10 ----------
plist > '[' . elist ']'
elist > .
elist > . e
elist > . elist ';' e
elist > . elist ';'
e > . o
e > . o V e
e > . V e
e > . V plist
o > . N
o > . '(' e ')'
o > . list
o > . plist
o > . o e
list > . '(' elist ')'
plist > . '[' elist ']'
---------- state 11 ----------
s > e ';' .
---------- state 12 ----------
e > o V . e
e > V . e
e > V . plist
e > . o
e > . o V e
e > . V e
e > . V plist
plist > . '[' elist ']'
o > . N
o > . '(' e ')'
o > . list
o > . plist
o > . o e
list > . '(' elist ')'
---------- state 13 ----------
o > o e .
---------- state 14 ----------
e > V e .
---------- state 15 ----------
e > V plist .
o > plist .
---------- state 16 ----------
o > '(' e . ')'
elist > e .
---------- state 17 ----------
list > '(' elist . ')'
elist > elist . ';' e
elist > elist . ';'
---------- state 18 ----------
plist > '[' elist . ']'
elist > elist . ';' e
elist > elist . ';'
---------- state 19 ----------
e > o V e .
e > V e .
---------- state 20 ----------
o > '(' e ')' .
---------- state 21 ----------
list > '(' elist ')' .
---------- state 22 ----------
elist > elist ';' . e
elist > elist ';' .
e > . o
e > . o V e
e > . V e
e > . V plist
o > . N
o > . '(' e ')'
o > . list
o > . plist
o > . o e
list > . '(' elist ')'
plist > . '[' elist ']'
---------- state 23 ----------
plist > '[' elist ']' .
---------- state 24 ----------
elist > elist ';' e .
state token action goto rule
----- ----- ------ ---- ----
    0 s          2    1    0
    0 $e         0    0    1
    0 e          2    2    2
    0 Q          1    3    4
    0 o          2    4    5
    0 V          1    5    7
    0 N          1    6    9
    0 '('        1    7   10
    0 list       2    8   11
    0 plist      2    9   12
    0 '['        1   10   19
    1 $e         0    0    0
    2 $e         0    0    2
    2 ';'        1   11    3
    3 $e         0    0    4
    4 $e         0    0    5
    4 ';'        0    0    5
    4 ')'        0    0    5
    4 V          1   12    6
    4 N          1   14    9
    4 '('        1   14   10
    4 '['        1   14   19
    4 ']'        0    0    5
    4 e          2   13   13
    4 o          2    4    5
    4 list       2    8   11
    4 plist      2    9   12
    5 e          2   14    7
    5 plist      2   15    8
    5 o          2    4    5
    5 V          1    5    7
    5 '['        1   10   19
    5 N          1    6    9
    5 '('        1    7   10
    5 list       2    8   11
    6 $e         0    0    9
    6 V          0    0    9
    6 N          0    0    9
    6 '('        0    0    9
    6 '['        0    0    9
    6 ';'        0    0    9
    6 ')'        0    0    9
    6 ']'        0    0    9
    7 e          2   16   10
    7 $e         0    0   15
    7 ')'        0    0   15
    7 ';'        0    0   15
    7 ']'        0    0   15
    7 elist      2   17   14
    7 o          2    4    5
    7 V          1    5    7
    7 N          1    6    9
    7 '('        1    7   10
    7 list       2    8   11
    7 plist      2    9   12
    7 '['        1   10   19
    8 $e         0    0   11
    8 V          0    0   11
    8 N          0    0   11
    8 '('        0    0   11
    8 '['        0    0   11
    8 ';'        0    0   11
    8 ')'        0    0   11
    8 ']'        0    0   11
    9 $e         0    0   12
    9 V          0    0   12
    9 N          0    0   12
    9 '('        0    0   12
    9 '['        0    0   12
    9 ';'        0    0   12
    9 ')'        0    0   12
    9 ']'        0    0   12
   10 elist      2   18   19
   10 $e         0    0   15
   10 ')'        0    0   15
   10 ';'        0    0   15
   10 ']'        0    0   15
   10 e          2   16   16
   10 o          2    4    5
   10 V          1    5    7
   10 N          1    6    9
   10 '('        1    7   10
   10 list       2    8   11
   10 plist      2    9   12
   10 '['        1   10   19
   11 $e         0    0    3
   12 e          2   19    6
   12 plist      2   15    8
   12 o          2    4    5
   12 V          1    5    7
   12 '['        1   10   19
   12 N          1    6    9
   12 '('        1    7   10
   12 list       2    8   11
   13 $e         0    0   13
   13 V          0    0   13
   13 N          0    0   13
   13 '('        0    0   13
   13 '['        0    0   13
   13 ';'        0    0   13
   13 ')'        0    0   13
   13 ']'        0    0   13
   14 $e         0    0    7
   14 ';'        0    0    7
   14 ')'        0    0    7
   14 V          0    0    7
   14 N          0    0    7
   14 '('        0    0    7
   14 '['        0    0    7
   14 ']'        0    0    7
   15 $e         0    0    8
   15 ';'        0    0    8
   15 ')'        0    0    8
   15 V          0    0    8
   15 N          0    0    8
   15 '('        0    0    8
   15 '['        0    0    8
   15 ']'        0    0    8
   16 ')'        1   20   10
   16 $e         0    0   16
   16 ';'        0    0   16
   16 ']'        0    0   16
   17 ')'        1   21   14
   17 ';'        1   22   17
   18 ']'        1   23   19
   18 ';'        1   22   17
   19 $e         0    0    6
   19 ';'        0    0    6
   19 ')'        0    0    6
   19 V          0    0    6
   19 N          0    0    6
   19 '('        0    0    6
   19 '['        0    0    6
   19 ']'        0    0    6
   20 $e         0    0   10
   20 V          0    0   10
   20 N          0    0   10
   20 '('        0    0   10
   20 '['        0    0   10
   20 ';'        0    0   10
   20 ')'        0    0   10
   20 ']'        0    0   10
   21 $e         0    0   14
   21 V          0    0   14
   21 N          0    0   14
   21 '('        0    0   14
   21 '['        0    0   14
   21 ';'        0    0   14
   21 ')'        0    0   14
   21 ']'        0    0   14
   22 e          2   24   17
   22 $e         0    0   18
   22 ')'        0    0   18
   22 ';'        0    0   18
   22 ']'        0    0   18
   22 o          2    4    5
   22 V          1    5    7
   22 N          1    6    9
   22 '('        1    7   10
   22 list       2    8   11
   22 plist      2    9   12
   22 '['        1   10   19
   23 $e         0    0   19
   23 ';'        0    0   19
   23 ')'        0    0   19
   23 V          0    0   19
   23 N          0    0   19
   23 '('        0    0   19
   23 '['        0    0   19
   23 ']'        0    0   19
   24 $e         0    0   17
   24 ')'        0    0   17
   24 ';'        0    0   17
   24 ']'        0    0   17
