n: $a E EP T TP F
t: $e '+' '*' '(' ')' id
-------------------------
 0. $a > E
 1. E > T EP
 2. EP >
 3. EP > '+' T EP
 4. T > F TP
 5. TP >
 6. TP > '*' F TP
 7. F > '(' E ')'
 8. F > id
---------- state 0 ----------
$a > . E
E > . T EP
T > . F TP
F > . '(' E ')'
F > . id
---------- state 1 ----------
$a > E .
---------- state 2 ----------
E > T . EP
EP > .
EP > . '+' T EP
---------- state 3 ----------
T > F . TP
TP > .
TP > . '*' F TP
---------- state 4 ----------
F > '(' . E ')'
E > . T EP
T > . F TP
F > . '(' E ')'
F > . id
---------- state 5 ----------
F > id .
---------- state 6 ----------
E > T EP .
---------- state 7 ----------
EP > '+' . T EP
T > . F TP
F > . '(' E ')'
F > . id
---------- state 8 ----------
T > F TP .
---------- state 9 ----------
TP > '*' . F TP
F > . '(' E ')'
F > . id
---------- state 10 ----------
F > '(' E . ')'
---------- state 11 ----------
EP > '+' T . EP
EP > .
EP > . '+' T EP
---------- state 12 ----------
TP > '*' F . TP
TP > .
TP > . '*' F TP
---------- state 13 ----------
F > '(' E ')' .
---------- state 14 ----------
EP > '+' T EP .
---------- state 15 ----------
TP > '*' F TP .
state token action goto rule 
----- ----- ------ ---- ---- 
    0 E          2    1    0 
    0 T          2    2    1 
    0 F          2    3    4 
    0 '('        1    4    7 
    0 id         1    5    8 
    1 $e         0    0    0 
    2 EP         2    6    1 
    2 $e         0    0    2 
    2 ')'        0    0    2 
    2 '+'        1    7    3 
    3 TP         2    8    4 
    3 $e         0    0    5 
    3 '+'        0    0    5 
    3 ')'        0    0    5 
    3 '*'        1    9    6 
    4 E          2   10    7 
    4 T          2    2    1 
    4 F          2    3    4 
    4 '('        1    4    7 
    4 id         1    5    8 
    5 $e         0    0    8 
    5 '*'        0    0    8 
    5 '+'        0    0    8 
    5 ')'        0    0    8 
    6 $e         0    0    1 
    6 ')'        0    0    1 
    7 T          2   11    3 
    7 F          2    3    4 
    7 '('        1    4    7 
    7 id         1    5    8 
    8 $e         0    0    4 
    8 '+'        0    0    4 
    8 ')'        0    0    4 
    9 F          2   12    6 
    9 '('        1    4    7 
    9 id         1    5    8 
   10 ')'        1   13    7 
   11 EP         2   14    3 
   11 $e         0    0    2 
   11 ')'        0    0    2 
   11 '+'        1    7    3 
   12 TP         2   15    6 
   12 $e         0    0    5 
   12 '+'        0    0    5 
   12 ')'        0    0    5 
   12 '*'        1    9    6 
   13 $e         0    0    7 
   13 '*'        0    0    7 
   13 '+'        0    0    7 
   13 ')'        0    0    7 
   14 $e         0    0    3 
   14 ')'        0    0    3 
   15 $e         0    0    6 
   15 '+'        0    0    6 
   15 ')'        0    0    6 
