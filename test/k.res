n: $e g s e o
t: $a '\n' ';' Q V N '(' ')'
-------------------------
 0. $a > g
 1. g >
 2. g > g s
 3. s > '\n'
 4. s > e '\n'
 5. s > e ';'
 6. s > Q '\n'
 7. e > o
 8. e > o V e
 9. e > V e
10. o > N
11. o > '(' e ')'
---------- state 0 ----------
$a > . g
g > .
g > . g s
---------- state 1 ----------
$a > g .
g > g . s
s > . '\n'
s > . e '\n'
s > . e ';'
s > . Q '\n'
e > . o
e > . o V e
e > . V e
o > . N
o > . '(' e ')'
---------- state 2 ----------
g > g s .
---------- state 3 ----------
s > '\n' .
---------- state 4 ----------
s > e . '\n'
s > e . ';'
---------- state 5 ----------
s > Q . '\n'
---------- state 6 ----------
e > o .
e > o . V e
---------- state 7 ----------
e > V . e
e > . o
e > . o V e
e > . V e
o > . N
o > . '(' e ')'
---------- state 8 ----------
o > N .
---------- state 9 ----------
o > '(' . e ')'
e > . o
e > . o V e
e > . V e
o > . N
o > . '(' e ')'
---------- state 10 ----------
s > e '\n' .
---------- state 11 ----------
s > e ';' .
---------- state 12 ----------
s > Q '\n' .
---------- state 13 ----------
e > o V . e
e > . o
e > . o V e
e > . V e
o > . N
o > . '(' e ')'
---------- state 14 ----------
e > V e .
---------- state 15 ----------
o > '(' e . ')'
---------- state 16 ----------
e > o V e .
---------- state 17 ----------
o > '(' e ')' .
state token action goto rule 
----- ----- ------ ---- ---- 
    0 g          2    1    0 
    0            0    0    1 
    1            0    0    0 
    1 s          2    2    2 
    1 '\n'       1    3    3 
    1 e          2    4    4 
    1 Q          1    5    6 
    1 o          2    6    7 
    1 V          1    7    9 
    1 N          1    8   10 
    1 '('        1    9   11 
    2            0    0    2 
    3            0    0    3 
    4 '\n'       1   10    4 
    4 ';'        1   11    5 
    5 '\n'       1   12    6 
    6            0    0    7 
    6 V          1   13    8 
    7 e          2   14    9 
    7 o          2    6    7 
    7 V          1    7    9 
    7 N          1    8   10 
    7 '('        1    9   11 
    8            0    0   10 
    9 e          2   15   11 
    9 o          2    6    7 
    9 V          1    7    9 
    9 N          1    8   10 
    9 '('        1    9   11 
   10            0    0    4 
   11            0    0    5 
   12            0    0    6 
   13 e          2   16    8 
   13 o          2    6    7 
   13 V          1    7    9 
   13 N          1    8   10 
   13 '('        1    9   11 
   14            0    0    9 
   15 ')'        1   17   11 
   16            0    0    8 
   17            0    0   11 
