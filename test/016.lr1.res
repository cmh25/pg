n: $a S A
t: a b $e
-------------------------
 0. $a > S
 1. S > A A
 2. A > a A
 3. A > b
---------- state 0 ----------
$a > . S , $e
S > . A A , $e
A > . a A , a b
A > . b , a b
---------- state 1 ----------
$a > S . , $e
---------- state 2 ----------
S > A . A , $e
A > . a A , $e
A > . b , $e
---------- state 3 ----------
A > a . A , a b
A > . a A , a b
A > . b , a b
---------- state 4 ----------
A > b . , a b
---------- state 5 ----------
S > A A . , $e
---------- state 6 ----------
A > a . A , $e
A > . a A , $e
A > . b , $e
---------- state 7 ----------
A > b . , $e
---------- state 8 ----------
A > a A . , a b
---------- state 9 ----------
A > a A . , $e
state token action goto rule
----- ----- ------ ---- ----
    0 S          2    1    0
    0 A          2    2    1
    0 a          1    3    2
    0 b          1    4    3
    1 $e         0    0    0
    2 A          2    5    1
    2 a          1    6    2
    2 b          1    7    3
    3 A          2    8    2
    3 a          1    3    2
    3 b          1    4    3
    4 a          0    0    3
    4 b          0    0    3
    5 $e         0    0    1
    6 A          2    9    2
    6 a          1    6    2
    6 b          1    7    3
    7 $e         0    0    3
    8 a          0    0    2
    8 b          0    0    2
    9 $e         0    0    2
