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
$a > . e ,
e > . e '+' t ,
e > . t ,
t > . t '*' f ,
t > . f ,
f > . '(' e ')' ,
f > . n ,
---------- state 1 ----------
$a > e . ,
e > e . '+' t ,
---------- state 2 ----------
e > t . ,
t > t . '*' f ,
---------- state 3 ----------
t > f . ,
---------- state 4 ----------
f > '(' . e ')' ,
e > . e '+' t ,
e > . t ,
t > . t '*' f ,
t > . f ,
f > . '(' e ')' ,
f > . n ,
---------- state 5 ----------
f > n . ,
---------- state 6 ----------
e > e '+' . t ,
t > . t '*' f ,
t > . f ,
f > . '(' e ')' ,
f > . n ,
---------- state 7 ----------
t > t '*' . f ,
f > . '(' e ')' ,
f > . n ,
---------- state 8 ----------
f > '(' e . ')' ,
e > e . '+' t ,
---------- state 9 ----------
e > t . ,
t > t . '*' f ,
---------- state 10 ----------
t > f . ,
---------- state 11 ----------
f > '(' . e ')' ,
e > . e '+' t ,
e > . t ,
t > . t '*' f ,
t > . f ,
f > . '(' e ')' ,
f > . n ,
---------- state 12 ----------
f > n . ,
---------- state 13 ----------
e > e '+' t . ,
t > t . '*' f ,
---------- state 14 ----------
t > t '*' f . ,
---------- state 15 ----------
f > '(' e ')' . ,
---------- state 16 ----------
e > e '+' . t ,
t > . t '*' f ,
t > . f ,
f > . '(' e ')' ,
f > . n ,
---------- state 17 ----------
t > t '*' . f ,
f > . '(' e ')' ,
f > . n ,
---------- state 18 ----------
f > '(' e . ')' ,
e > e . '+' t ,
---------- state 19 ----------
e > e '+' t . ,
t > t . '*' f ,
---------- state 20 ----------
t > t '*' f . ,
---------- state 21 ----------
f > '(' e ')' . ,
state token action goto rule
----- ----- ------ ---- ----
    0 e          2    1    0
    0 t          2    2    2
    0 f          2    3    4
    0 '('        1    4    5
    0 n          1    5    6
    1 $e         0    0    0
    1 '+'        1    6    1
    2 $e         0    0    2
    2 '+'        0    0    2
    2 '*'        1    7    3
    3 $e         0    0    4
    3 '+'        0    0    4
    3 '*'        0    0    4
    4 e          2    8    5
    4 t          2    9    2
    4 f          2   10    4
    4 '('        1   11    5
    4 n          1   12    6
    5 $e         0    0    6
    5 '+'        0    0    6
    5 '*'        0    0    6
    6 t          2   13    1
    6 f          2    3    4
    6 '('        1    4    5
    6 n          1    5    6
    7 f          2   14    3
    7 '('        1    4    5
    7 n          1    5    6
    8 ')'        1   15    5
    8 '+'        1   16    1
    9 ')'        0    0    2
    9 '+'        0    0    2
    9 '*'        1   17    3
   10 ')'        0    0    4
   10 '+'        0    0    4
   10 '*'        0    0    4
   11 e          2   18    5
   11 t          2    9    2
   11 f          2   10    4
   11 '('        1   11    5
   11 n          1   12    6
   12 ')'        0    0    6
   12 '+'        0    0    6
   12 '*'        0    0    6
   13 $e         0    0    1
   13 '+'        0    0    1
   13 '*'        1    7    3
   14 $e         0    0    3
   14 '+'        0    0    3
   14 '*'        0    0    3
   15 $e         0    0    5
   15 '+'        0    0    5
   15 '*'        0    0    5
   16 t          2   19    1
   16 f          2   10    4
   16 '('        1   11    5
   16 n          1   12    6
   17 f          2   20    3
   17 '('        1   11    5
   17 n          1   12    6
   18 ')'        1   21    5
   18 '+'        1   16    1
   19 ')'        0    0    1
   19 '+'        0    0    1
   19 '*'        1   17    3
   20 ')'        0    0    3
   20 '+'        0    0    3
   20 '*'        0    0    3
   21 ')'        0    0    5
   21 '+'        0    0    5
   21 '*'        0    0    5
