n: $a A
t: a $e
-------------------------
 0. $a > A
 1. A > a
---------- state 0 ----------
$a > . A
A > . a
---------- state 3 ----------
$a > A .
A > a .
state token action goto rule 
----- ----- ------ ---- ---- 
    0 a          2    3    0 
    0 a          1    3    1 
    3 $e         0    0    0 
