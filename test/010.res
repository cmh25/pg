n: $a G A B C
t: b d e $e
-------------------------
 0. $a > G
 1. G > A b
 2. G > B d
 3. A > C
 4. B > C
 5. C > e e
warning: reduce/reduce conflict state[4] token[$e]
         B > C .
         A > C .
---------- state 0 ----------
$a > . G
G > . A b
G > . B d
A > . C
B > . C
C > . e e
---------- state 1 ----------
$a > G .
---------- state 2 ----------
G > A . b
---------- state 3 ----------
G > B . d
---------- state 4 ----------
A > C .
B > C .
---------- state 5 ----------
C > e . e
---------- state 6 ----------
G > A b .
---------- state 7 ----------
G > B d .
---------- state 8 ----------
C > e e .
state token action goto rule 
----- ----- ------ ---- ---- 
    0 G          2    1    0 
    0 A          2    2    1 
    0 B          2    3    2 
    0 C          2    4    3 
    0 e          1    5    5 
    1 $e         0    0    0 
    2 b          1    6    1 
    3 d          1    7    2 
    4 $e         0    0    3 
    4 b          0    0    3 
    4 d          0    0    4 
    5 e          1    8    5 
    6 $e         0    0    1 
    7 $e         0    0    2 
    8 $e         0    0    5 
    8 b          0    0    5 
    8 d          0    0    5 
