n: $a s ps qs e o j v slist plist klist elist vlist
t: '\n' ';' IF '[' ']' WHILE DO '(' ')' ':' N V AV $e
-------------------------
 0. $a > s
 1. s > ps
 2. s > qs
 3. ps > e '\n'
 4. ps > '\n'
 5. qs > e ';'
 6. qs > ';'
 7. qs > IF '[' slist ']'
 8. qs > WHILE '[' slist ']'
 9. qs > DO '[' slist ']'
10. e > j
11. e > v e
12. e > j e
13. e > o v e
14. e > '(' vlist ')' plist
15. e > v plist
16. e > klist
17. e > ':' '[' slist ']'
18. o > N
19. o > '(' e ')'
20. j > o
21. v > V
22. v > v AV
23. slist > s
24. slist > slist s
25. plist > '[' elist ']'
26. klist > '(' elist ')'
27. elist >
28. elist > e ';' e
29. elist > elist ';' e
30. vlist > v
31. vlist > v vlist
warning: shift/reduce conflict state[12] token[V]
         reduce 20 (j > o)
         shift 29
---------- state 0 ----------
$a > . s
s > . ps
s > . qs
ps > . e '\n'
ps > . '\n'
qs > . e ';'
qs > . ';'
qs > . IF '[' slist ']'
qs > . WHILE '[' slist ']'
qs > . DO '[' slist ']'
e > . j
e > . v e
e > . j e
e > . o v e
e > . '(' vlist ')' plist
e > . v plist
e > . klist
e > . ':' '[' slist ']'
j > . o
v > . V
v > . v AV
o > . N
o > . '(' e ')'
klist > . '(' elist ')'
---------- state 1 ----------
$a > s .
---------- state 2 ----------
s > ps .
---------- state 3 ----------
s > qs .
---------- state 4 ----------
ps > e . '\n'
qs > e . ';'
---------- state 5 ----------
ps > '\n' .
---------- state 6 ----------
qs > ';' .
---------- state 7 ----------
qs > IF . '[' slist ']'
---------- state 8 ----------
qs > WHILE . '[' slist ']'
---------- state 9 ----------
qs > DO . '[' slist ']'
---------- state 10 ----------
e > j .
e > j . e
e > . j
e > . v e
e > . j e
e > . o v e
e > . '(' vlist ')' plist
e > . v plist
e > . klist
e > . ':' '[' slist ']'
j > . o
v > . V
v > . v AV
o > . N
o > . '(' e ')'
klist > . '(' elist ')'
---------- state 11 ----------
e > v . e
e > v . plist
v > v . AV
e > . j
e > . v e
e > . j e
e > . o v e
e > . '(' vlist ')' plist
e > . v plist
e > . klist
e > . ':' '[' slist ']'
plist > . '[' elist ']'
j > . o
v > . V
v > . v AV
o > . N
o > . '(' e ')'
klist > . '(' elist ')'
---------- state 12 ----------
e > o . v e
j > o .
v > . V
v > . v AV
---------- state 13 ----------
e > '(' . vlist ')' plist
o > '(' . e ')'
klist > '(' . elist ')'
vlist > . v
vlist > . v vlist
e > . j
e > . v e
e > . j e
e > . o v e
e > . '(' vlist ')' plist
e > . v plist
e > . klist
e > . ':' '[' slist ']'
elist > .
elist > . e ';' e
elist > . elist ';' e
v > . V
v > . v AV
j > . o
o > . N
o > . '(' e ')'
klist > . '(' elist ')'
---------- state 14 ----------
e > klist .
---------- state 15 ----------
e > ':' . '[' slist ']'
---------- state 16 ----------
v > V .
---------- state 17 ----------
o > N .
---------- state 18 ----------
ps > e '\n' .
---------- state 19 ----------
qs > e ';' .
---------- state 20 ----------
qs > IF '[' . slist ']'
slist > . s
slist > . slist s
s > . ps
s > . qs
ps > . e '\n'
ps > . '\n'
qs > . e ';'
qs > . ';'
qs > . IF '[' slist ']'
qs > . WHILE '[' slist ']'
qs > . DO '[' slist ']'
e > . j
e > . v e
e > . j e
e > . o v e
e > . '(' vlist ')' plist
e > . v plist
e > . klist
e > . ':' '[' slist ']'
j > . o
v > . V
v > . v AV
o > . N
o > . '(' e ')'
klist > . '(' elist ')'
---------- state 21 ----------
qs > WHILE '[' . slist ']'
slist > . s
slist > . slist s
s > . ps
s > . qs
ps > . e '\n'
ps > . '\n'
qs > . e ';'
qs > . ';'
qs > . IF '[' slist ']'
qs > . WHILE '[' slist ']'
qs > . DO '[' slist ']'
e > . j
e > . v e
e > . j e
e > . o v e
e > . '(' vlist ')' plist
e > . v plist
e > . klist
e > . ':' '[' slist ']'
j > . o
v > . V
v > . v AV
o > . N
o > . '(' e ')'
klist > . '(' elist ')'
---------- state 22 ----------
qs > DO '[' . slist ']'
slist > . s
slist > . slist s
s > . ps
s > . qs
ps > . e '\n'
ps > . '\n'
qs > . e ';'
qs > . ';'
qs > . IF '[' slist ']'
qs > . WHILE '[' slist ']'
qs > . DO '[' slist ']'
e > . j
e > . v e
e > . j e
e > . o v e
e > . '(' vlist ')' plist
e > . v plist
e > . klist
e > . ':' '[' slist ']'
j > . o
v > . V
v > . v AV
o > . N
o > . '(' e ')'
klist > . '(' elist ')'
---------- state 23 ----------
e > j e .
---------- state 24 ----------
e > v e .
---------- state 25 ----------
e > v plist .
---------- state 26 ----------
v > v AV .
---------- state 27 ----------
plist > '[' . elist ']'
elist > .
elist > . e ';' e
elist > . elist ';' e
e > . j
e > . v e
e > . j e
e > . o v e
e > . '(' vlist ')' plist
e > . v plist
e > . klist
e > . ':' '[' slist ']'
j > . o
v > . V
v > . v AV
o > . N
o > . '(' e ')'
klist > . '(' elist ')'
---------- state 28 ----------
e > o v . e
v > v . AV
e > . j
e > . v e
e > . j e
e > . o v e
e > . '(' vlist ')' plist
e > . v plist
e > . klist
e > . ':' '[' slist ']'
j > . o
v > . V
v > . v AV
o > . N
o > . '(' e ')'
klist > . '(' elist ')'
---------- state 29 ----------
e > '(' vlist . ')' plist
---------- state 30 ----------
o > '(' e . ')'
elist > e . ';' e
---------- state 31 ----------
klist > '(' elist . ')'
elist > elist . ';' e
---------- state 32 ----------
vlist > v .
vlist > v . vlist
e > v . e
e > v . plist
v > v . AV
vlist > . v
vlist > . v vlist
e > . j
e > . v e
e > . j e
e > . o v e
e > . '(' vlist ')' plist
e > . v plist
e > . klist
e > . ':' '[' slist ']'
plist > . '[' elist ']'
v > . V
v > . v AV
j > . o
o > . N
o > . '(' e ')'
klist > . '(' elist ')'
---------- state 33 ----------
e > ':' '[' . slist ']'
slist > . s
slist > . slist s
s > . ps
s > . qs
ps > . e '\n'
ps > . '\n'
qs > . e ';'
qs > . ';'
qs > . IF '[' slist ']'
qs > . WHILE '[' slist ']'
qs > . DO '[' slist ']'
e > . j
e > . v e
e > . j e
e > . o v e
e > . '(' vlist ')' plist
e > . v plist
e > . klist
e > . ':' '[' slist ']'
j > . o
v > . V
v > . v AV
o > . N
o > . '(' e ')'
klist > . '(' elist ')'
---------- state 34 ----------
qs > IF '[' slist . ']'
slist > slist . s
s > . ps
s > . qs
ps > . e '\n'
ps > . '\n'
qs > . e ';'
qs > . ';'
qs > . IF '[' slist ']'
qs > . WHILE '[' slist ']'
qs > . DO '[' slist ']'
e > . j
e > . v e
e > . j e
e > . o v e
e > . '(' vlist ')' plist
e > . v plist
e > . klist
e > . ':' '[' slist ']'
j > . o
v > . V
v > . v AV
o > . N
o > . '(' e ')'
klist > . '(' elist ')'
---------- state 35 ----------
slist > s .
---------- state 36 ----------
qs > WHILE '[' slist . ']'
slist > slist . s
s > . ps
s > . qs
ps > . e '\n'
ps > . '\n'
qs > . e ';'
qs > . ';'
qs > . IF '[' slist ']'
qs > . WHILE '[' slist ']'
qs > . DO '[' slist ']'
e > . j
e > . v e
e > . j e
e > . o v e
e > . '(' vlist ')' plist
e > . v plist
e > . klist
e > . ':' '[' slist ']'
j > . o
v > . V
v > . v AV
o > . N
o > . '(' e ')'
klist > . '(' elist ')'
---------- state 37 ----------
qs > DO '[' slist . ']'
slist > slist . s
s > . ps
s > . qs
ps > . e '\n'
ps > . '\n'
qs > . e ';'
qs > . ';'
qs > . IF '[' slist ']'
qs > . WHILE '[' slist ']'
qs > . DO '[' slist ']'
e > . j
e > . v e
e > . j e
e > . o v e
e > . '(' vlist ')' plist
e > . v plist
e > . klist
e > . ':' '[' slist ']'
j > . o
v > . V
v > . v AV
o > . N
o > . '(' e ')'
klist > . '(' elist ')'
---------- state 38 ----------
plist > '[' elist . ']'
elist > elist . ';' e
---------- state 39 ----------
elist > e . ';' e
---------- state 40 ----------
e > o v e .
---------- state 41 ----------
e > '(' vlist ')' . plist
plist > . '[' elist ']'
---------- state 42 ----------
o > '(' e ')' .
---------- state 43 ----------
elist > e ';' . e
e > . j
e > . v e
e > . j e
e > . o v e
e > . '(' vlist ')' plist
e > . v plist
e > . klist
e > . ':' '[' slist ']'
j > . o
v > . V
v > . v AV
o > . N
o > . '(' e ')'
klist > . '(' elist ')'
---------- state 44 ----------
klist > '(' elist ')' .
---------- state 45 ----------
elist > elist ';' . e
e > . j
e > . v e
e > . j e
e > . o v e
e > . '(' vlist ')' plist
e > . v plist
e > . klist
e > . ':' '[' slist ']'
j > . o
v > . V
v > . v AV
o > . N
o > . '(' e ')'
klist > . '(' elist ')'
---------- state 46 ----------
vlist > v vlist .
---------- state 47 ----------
e > ':' '[' slist . ']'
slist > slist . s
s > . ps
s > . qs
ps > . e '\n'
ps > . '\n'
qs > . e ';'
qs > . ';'
qs > . IF '[' slist ']'
qs > . WHILE '[' slist ']'
qs > . DO '[' slist ']'
e > . j
e > . v e
e > . j e
e > . o v e
e > . '(' vlist ')' plist
e > . v plist
e > . klist
e > . ':' '[' slist ']'
j > . o
v > . V
v > . v AV
o > . N
o > . '(' e ')'
klist > . '(' elist ')'
---------- state 48 ----------
qs > IF '[' slist ']' .
---------- state 49 ----------
slist > slist s .
---------- state 50 ----------
qs > WHILE '[' slist ']' .
---------- state 51 ----------
qs > DO '[' slist ']' .
---------- state 52 ----------
plist > '[' elist ']' .
---------- state 53 ----------
e > '(' vlist ')' plist .
---------- state 54 ----------
elist > e ';' e .
---------- state 55 ----------
elist > elist ';' e .
---------- state 56 ----------
e > ':' '[' slist ']' .
state token action goto rule
----- ----- ------ ---- ----
    0 s          2    1    0
    0 ps         2    2    1
    0 qs         2    3    2
    0 e          2    4    3
    0 '\n'       1    5    4
    0 ';'        1    6    6
    0 IF         1    7    7
    0 WHILE      1    8    8
    0 DO         1    9    9
    0 j          2   10   10
    0 v          2   11   11
    0 o          2   12   13
    0 '('        1   13   14
    0 klist      2   14   16
    0 ':'        1   15   17
    0 V          1   16   21
    0 N          1   17   18
    1 $e         0    0    0
    2 $e         0    0    1
    2 ']'        0    0    1
    2 '\n'       0    0    1
    2 ';'        0    0    1
    2 IF         0    0    1
    2 WHILE      0    0    1
    2 DO         0    0    1
    2 '('        0    0    1
    2 ':'        0    0    1
    2 N          0    0    1
    2 V          0    0    1
    3 $e         0    0    2
    3 ']'        0    0    2
    3 '\n'       0    0    2
    3 ';'        0    0    2
    3 IF         0    0    2
    3 WHILE      0    0    2
    3 DO         0    0    2
    3 '('        0    0    2
    3 ':'        0    0    2
    3 N          0    0    2
    3 V          0    0    2
    4 '\n'       1   18    3
    4 ';'        1   19    5
    5 $e         0    0    4
    5 ']'        0    0    4
    5 '\n'       0    0    4
    5 ';'        0    0    4
    5 IF         0    0    4
    5 WHILE      0    0    4
    5 DO         0    0    4
    5 '('        0    0    4
    5 ':'        0    0    4
    5 N          0    0    4
    5 V          0    0    4
    6 $e         0    0    6
    6 ']'        0    0    6
    6 '\n'       0    0    6
    6 ';'        0    0    6
    6 IF         0    0    6
    6 WHILE      0    0    6
    6 DO         0    0    6
    6 '('        0    0    6
    6 ':'        0    0    6
    6 N          0    0    6
    6 V          0    0    6
    7 '['        1   20    7
    8 '['        1   21    8
    9 '['        1   22    9
   10 '\n'       0    0   10
   10 ';'        0    0   10
   10 ')'        0    0   10
   10 ']'        0    0   10
   10 e          2   23   12
   10 j          2   10   10
   10 v          2   11   11
   10 o          2   12   13
   10 '('        1   13   14
   10 klist      2   14   16
   10 ':'        1   15   17
   10 V          1   16   21
   10 N          1   17   18
   11 e          2   24   11
   11 plist      2   25   15
   11 AV         1   26   22
   11 j          2   10   10
   11 v          2   11   11
   11 o          2   12   13
   11 '('        1   13   14
   11 klist      2   14   16
   11 ':'        1   15   17
   11 '['        1   27   25
   11 V          1   16   21
   11 N          1   17   18
   12 '\n'       0    0   20
   12 ';'        0    0   20
   12 '('        0    0   20
   12 ':'        0    0   20
   12 N          0    0   20
   12 V          1   16   21
   12 ')'        0    0   20
   12 ']'        0    0   20
   12 v          2   28   13
   13 ']'        0    0   27
   13 ')'        0    0   27
   13 ';'        0    0   27
   13 vlist      2   29   14
   13 e          2   30   19
   13 elist      2   31   26
   13 v          2   32   30
   13 j          2   10   10
   13 o          2   12   13
   13 '('        1   13   14
   13 klist      2   14   16
   13 ':'        1   15   17
   13 V          1   16   21
   13 N          1   17   18
   14 '\n'       0    0   16
   14 ';'        0    0   16
   14 ')'        0    0   16
   14 ']'        0    0   16
   15 '['        1   33   17
   16 '('        0    0   21
   16 ':'        0    0   21
   16 N          0    0   21
   16 V          0    0   21
   16 '['        0    0   21
   16 AV         0    0   21
   16 ')'        0    0   21
   17 V          0    0   18
   17 '\n'       0    0   18
   17 ';'        0    0   18
   17 '('        0    0   18
   17 ':'        0    0   18
   17 N          0    0   18
   17 ')'        0    0   18
   17 ']'        0    0   18
   18 $e         0    0    3
   18 ']'        0    0    3
   18 '\n'       0    0    3
   18 ';'        0    0    3
   18 IF         0    0    3
   18 WHILE      0    0    3
   18 DO         0    0    3
   18 '('        0    0    3
   18 ':'        0    0    3
   18 N          0    0    3
   18 V          0    0    3
   19 $e         0    0    5
   19 ']'        0    0    5
   19 '\n'       0    0    5
   19 ';'        0    0    5
   19 IF         0    0    5
   19 WHILE      0    0    5
   19 DO         0    0    5
   19 '('        0    0    5
   19 ':'        0    0    5
   19 N          0    0    5
   19 V          0    0    5
   20 slist      2   34    7
   20 s          2   35   23
   20 ps         2    2    1
   20 qs         2    3    2
   20 e          2    4    3
   20 '\n'       1    5    4
   20 ';'        1    6    6
   20 IF         1    7    7
   20 WHILE      1    8    8
   20 DO         1    9    9
   20 j          2   10   10
   20 v          2   11   11
   20 o          2   12   13
   20 '('        1   13   14
   20 klist      2   14   16
   20 ':'        1   15   17
   20 V          1   16   21
   20 N          1   17   18
   21 slist      2   36    8
   21 s          2   35   23
   21 ps         2    2    1
   21 qs         2    3    2
   21 e          2    4    3
   21 '\n'       1    5    4
   21 ';'        1    6    6
   21 IF         1    7    7
   21 WHILE      1    8    8
   21 DO         1    9    9
   21 j          2   10   10
   21 v          2   11   11
   21 o          2   12   13
   21 '('        1   13   14
   21 klist      2   14   16
   21 ':'        1   15   17
   21 V          1   16   21
   21 N          1   17   18
   22 slist      2   37    9
   22 s          2   35   23
   22 ps         2    2    1
   22 qs         2    3    2
   22 e          2    4    3
   22 '\n'       1    5    4
   22 ';'        1    6    6
   22 IF         1    7    7
   22 WHILE      1    8    8
   22 DO         1    9    9
   22 j          2   10   10
   22 v          2   11   11
   22 o          2   12   13
   22 '('        1   13   14
   22 klist      2   14   16
   22 ':'        1   15   17
   22 V          1   16   21
   22 N          1   17   18
   23 '\n'       0    0   12
   23 ';'        0    0   12
   23 ')'        0    0   12
   23 ']'        0    0   12
   24 '\n'       0    0   11
   24 ';'        0    0   11
   24 ')'        0    0   11
   24 ']'        0    0   11
   25 '\n'       0    0   15
   25 ';'        0    0   15
   25 ')'        0    0   15
   25 ']'        0    0   15
   26 '('        0    0   22
   26 ':'        0    0   22
   26 N          0    0   22
   26 V          0    0   22
   26 '['        0    0   22
   26 AV         0    0   22
   26 ')'        0    0   22
   27 ']'        0    0   27
   27 ')'        0    0   27
   27 ';'        0    0   27
   27 elist      2   38   25
   27 e          2   39   28
   27 j          2   10   10
   27 v          2   11   11
   27 o          2   12   13
   27 '('        1   13   14
   27 klist      2   14   16
   27 ':'        1   15   17
   27 V          1   16   21
   27 N          1   17   18
   28 e          2   40   13
   28 AV         1   26   22
   28 j          2   10   10
   28 v          2   11   11
   28 o          2   12   13
   28 '('        1   13   14
   28 klist      2   14   16
   28 ':'        1   15   17
   28 V          1   16   21
   28 N          1   17   18
   29 ')'        1   41   14
   30 ')'        1   42   19
   30 ';'        1   43   28
   31 ')'        1   44   26
   31 ';'        1   45   29
   32 ')'        0    0   30
   32 vlist      2   46   31
   32 e          2   24   11
   32 plist      2   25   15
   32 AV         1   26   22
   32 v          2   32   30
   32 j          2   10   10
   32 o          2   12   13
   32 '('        1   13   14
   32 klist      2   14   16
   32 ':'        1   15   17
   32 '['        1   27   25
   32 V          1   16   21
   32 N          1   17   18
   33 slist      2   47   17
   33 s          2   35   23
   33 ps         2    2    1
   33 qs         2    3    2
   33 e          2    4    3
   33 '\n'       1    5    4
   33 ';'        1    6    6
   33 IF         1    7    7
   33 WHILE      1    8    8
   33 DO         1    9    9
   33 j          2   10   10
   33 v          2   11   11
   33 o          2   12   13
   33 '('        1   13   14
   33 klist      2   14   16
   33 ':'        1   15   17
   33 V          1   16   21
   33 N          1   17   18
   34 ']'        1   48    7
   34 s          2   49   24
   34 ps         2    2    1
   34 qs         2    3    2
   34 e          2    4    3
   34 '\n'       1    5    4
   34 ';'        1    6    6
   34 IF         1    7    7
   34 WHILE      1    8    8
   34 DO         1    9    9
   34 j          2   10   10
   34 v          2   11   11
   34 o          2   12   13
   34 '('        1   13   14
   34 klist      2   14   16
   34 ':'        1   15   17
   34 V          1   16   21
   34 N          1   17   18
   35 ']'        0    0   23
   35 '\n'       0    0   23
   35 ';'        0    0   23
   35 IF         0    0   23
   35 WHILE      0    0   23
   35 DO         0    0   23
   35 '('        0    0   23
   35 ':'        0    0   23
   35 N          0    0   23
   35 V          0    0   23
   36 ']'        1   50    8
   36 s          2   49   24
   36 ps         2    2    1
   36 qs         2    3    2
   36 e          2    4    3
   36 '\n'       1    5    4
   36 ';'        1    6    6
   36 IF         1    7    7
   36 WHILE      1    8    8
   36 DO         1    9    9
   36 j          2   10   10
   36 v          2   11   11
   36 o          2   12   13
   36 '('        1   13   14
   36 klist      2   14   16
   36 ':'        1   15   17
   36 V          1   16   21
   36 N          1   17   18
   37 ']'        1   51    9
   37 s          2   49   24
   37 ps         2    2    1
   37 qs         2    3    2
   37 e          2    4    3
   37 '\n'       1    5    4
   37 ';'        1    6    6
   37 IF         1    7    7
   37 WHILE      1    8    8
   37 DO         1    9    9
   37 j          2   10   10
   37 v          2   11   11
   37 o          2   12   13
   37 '('        1   13   14
   37 klist      2   14   16
   37 ':'        1   15   17
   37 V          1   16   21
   37 N          1   17   18
   38 ']'        1   52   25
   38 ';'        1   45   29
   39 ';'        1   43   28
   40 '\n'       0    0   13
   40 ';'        0    0   13
   40 ')'        0    0   13
   40 ']'        0    0   13
   41 plist      2   53   14
   41 '['        1   27   25
   42 V          0    0   19
   42 '\n'       0    0   19
   42 ';'        0    0   19
   42 '('        0    0   19
   42 ':'        0    0   19
   42 N          0    0   19
   42 ')'        0    0   19
   42 ']'        0    0   19
   43 e          2   54   28
   43 j          2   10   10
   43 v          2   11   11
   43 o          2   12   13
   43 '('        1   13   14
   43 klist      2   14   16
   43 ':'        1   15   17
   43 V          1   16   21
   43 N          1   17   18
   44 '\n'       0    0   26
   44 ';'        0    0   26
   44 ')'        0    0   26
   44 ']'        0    0   26
   45 e          2   55   29
   45 j          2   10   10
   45 v          2   11   11
   45 o          2   12   13
   45 '('        1   13   14
   45 klist      2   14   16
   45 ':'        1   15   17
   45 V          1   16   21
   45 N          1   17   18
   46 ')'        0    0   31
   47 ']'        1   56   17
   47 s          2   49   24
   47 ps         2    2    1
   47 qs         2    3    2
   47 e          2    4    3
   47 '\n'       1    5    4
   47 ';'        1    6    6
   47 IF         1    7    7
   47 WHILE      1    8    8
   47 DO         1    9    9
   47 j          2   10   10
   47 v          2   11   11
   47 o          2   12   13
   47 '('        1   13   14
   47 klist      2   14   16
   47 ':'        1   15   17
   47 V          1   16   21
   47 N          1   17   18
   48 $e         0    0    7
   48 ']'        0    0    7
   48 '\n'       0    0    7
   48 ';'        0    0    7
   48 IF         0    0    7
   48 WHILE      0    0    7
   48 DO         0    0    7
   48 '('        0    0    7
   48 ':'        0    0    7
   48 N          0    0    7
   48 V          0    0    7
   49 ']'        0    0   24
   49 '\n'       0    0   24
   49 ';'        0    0   24
   49 IF         0    0   24
   49 WHILE      0    0   24
   49 DO         0    0   24
   49 '('        0    0   24
   49 ':'        0    0   24
   49 N          0    0   24
   49 V          0    0   24
   50 $e         0    0    8
   50 ']'        0    0    8
   50 '\n'       0    0    8
   50 ';'        0    0    8
   50 IF         0    0    8
   50 WHILE      0    0    8
   50 DO         0    0    8
   50 '('        0    0    8
   50 ':'        0    0    8
   50 N          0    0    8
   50 V          0    0    8
   51 $e         0    0    9
   51 ']'        0    0    9
   51 '\n'       0    0    9
   51 ';'        0    0    9
   51 IF         0    0    9
   51 WHILE      0    0    9
   51 DO         0    0    9
   51 '('        0    0    9
   51 ':'        0    0    9
   51 N          0    0    9
   51 V          0    0    9
   52 '\n'       0    0   25
   52 ';'        0    0   25
   52 ')'        0    0   25
   52 ']'        0    0   25
   53 '\n'       0    0   14
   53 ';'        0    0   14
   53 ')'        0    0   14
   53 ']'        0    0   14
   54 ']'        0    0   28
   54 ')'        0    0   28
   54 ';'        0    0   28
   55 ']'        0    0   29
   55 ')'        0    0   29
   55 ';'        0    0   29
   56 '\n'       0    0   17
   56 ';'        0    0   17
   56 ')'        0    0   17
   56 ']'        0    0   17
