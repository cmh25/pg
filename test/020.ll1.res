n: $a E EP T TP F
t: + * ( ) id $e
-------------------------
 0. $a ::= E
 1. E ::= T EP
 2. EP ::= + T EP
 3. EP ::=
 4. T ::= F TP
 5. TP ::= * F TP
 6. TP ::=
 7. F ::= ( E )
 8. F ::= id

   +  *  (  )  id $e
-- -- -- -- -- -- --
$a        0     0   
E         1     1   
EP  2        3     3
T         4     4   
TP  6  5     6     6
F         7     8   
