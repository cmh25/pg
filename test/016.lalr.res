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
A > a . A , a b $e
A > . a A , a b $e
A > . b , a b $e
---------- state 4 ----------
A > b . , a b $e
---------- state 5 ----------
S > A A . , $e b
---------- state 6 ----------
A > a A . , a b $e
state token action goto rule
----- ----- ------ ---- ----
    0 S          2    1    0
    0 A          2    2    1
    0 a          1    3    2
    0 b          1    4    3
    1 $e         0    0    0
    2 A          2    5    1
    2 a          1    3    2
    2 b          1    4    3
    3 A          2    6    2
    3 a          1    3    2
    3 b          1    4    3
    3 A          2    6    2
    3 a          1    3    2
    3 b          1    4    3
    4 a          0    0    3
    4 b          0    0    3
    4 $e         0    0    3
    5 $e         0    0    1
    6 a          0    0    2
    6 b          0    0    2
    6 $e         0    0    2
