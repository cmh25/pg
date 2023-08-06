n: $a <Lines> <Statements> <Statement> <Access> <ID List> <Value List> <Constant List> <Integer List> <Expression List> <Print List> <Expression> <And Exp> <Not Exp> <Compare Exp> <Add Exp> <Mult Exp> <Negate Exp> <Power Exp> <Value> <Constant>
t: Integer NewLine ':' CLOSE '#' DATA DIM ID '(' ')' END FOR '=' TO STEP GOTO GOSUB IF THEN INPUT ',' LET Id NEXT OPEN AS POKE PRINT <Print list> READ RETURN RESTORE RUN STOP SYS WAIT Remark OUPUT ';' OR AND NOT '<>' '><' '>' '>=' '<' '<=' '+' '-' '*' '/' '^' String Real $e
-------------------------
 0. $a ::= <Lines>
 1. <Lines> ::= Integer <Statements> NewLine <Lines>
 2. <Lines> ::= Integer <Statements> NewLine
 3. <Statements> ::= <Statement> ':' <Statements>
 4. <Statements> ::= <Statement>
 5. <Statement> ::= CLOSE '#' Integer
 6. <Statement> ::= DATA <Constant List>
 7. <Statement> ::= DIM ID '(' <Integer List> ')'
 8. <Statement> ::= END
 9. <Statement> ::= FOR ID '=' <Expression> TO <Expression>
10. <Statement> ::= FOR ID '=' <Expression> TO <Expression> STEP Integer
11. <Statement> ::= GOTO <Expression>
12. <Statement> ::= GOSUB <Expression>
13. <Statement> ::= IF <Expression> THEN <Statement>
14. <Statement> ::= INPUT <ID List>
15. <Statement> ::= INPUT '#' Integer ',' <ID List>
16. <Statement> ::= LET Id '=' <Expression>
17. <Statement> ::= NEXT <ID List>
18. <Statement> ::= OPEN <Value> FOR <Access> AS '#' Integer
19. <Statement> ::= POKE <Value List>
20. <Statement> ::= PRINT <Print list>
21. <Statement> ::= PRINT '#' Integer ',' <Print List>
22. <Statement> ::= READ <ID List>
23. <Statement> ::= RETURN
24. <Statement> ::= RESTORE
25. <Statement> ::= RUN
26. <Statement> ::= STOP
27. <Statement> ::= SYS <Value>
28. <Statement> ::= WAIT <Value List>
29. <Statement> ::= Remark
30. <Access> ::= INPUT
31. <Access> ::= OUPUT
32. <ID List> ::= ID ',' <ID List>
33. <ID List> ::= ID
34. <Value List> ::= <Value> ',' <Value List>
35. <Value List> ::= <Value>
36. <Constant List> ::= <Constant> ',' <Constant List>
37. <Constant List> ::= <Constant>
38. <Integer List> ::= Integer ',' <Integer List>
39. <Integer List> ::= Integer
40. <Expression List> ::= <Expression> ',' <Expression List>
41. <Expression List> ::= <Expression>
42. <Print List> ::= <Expression> ';' <Print List>
43. <Print List> ::= <Expression>
44. <Print List> ::=
45. <Expression> ::= <And Exp> OR <Expression>
46. <Expression> ::= <And Exp>
47. <And Exp> ::= <Not Exp> AND <And Exp>
48. <And Exp> ::= <Not Exp>
49. <Not Exp> ::= NOT <Compare Exp>
50. <Not Exp> ::= <Compare Exp>
51. <Compare Exp> ::= <Add Exp> '=' <Compare Exp>
52. <Compare Exp> ::= <Add Exp> '<>' <Compare Exp>
53. <Compare Exp> ::= <Add Exp> '><' <Compare Exp>
54. <Compare Exp> ::= <Add Exp> '>' <Compare Exp>
55. <Compare Exp> ::= <Add Exp> '>=' <Compare Exp>
56. <Compare Exp> ::= <Add Exp> '<' <Compare Exp>
57. <Compare Exp> ::= <Add Exp> '<=' <Compare Exp>
58. <Compare Exp> ::= <Add Exp>
59. <Add Exp> ::= <Mult Exp> '+' <Add Exp>
60. <Add Exp> ::= <Mult Exp> '-' <Add Exp>
61. <Add Exp> ::= <Mult Exp>
62. <Mult Exp> ::= <Negate Exp> '*' <Mult Exp>
63. <Mult Exp> ::= <Negate Exp> '/' <Mult Exp>
64. <Mult Exp> ::= <Negate Exp>
65. <Negate Exp> ::= '-' <Power Exp>
66. <Negate Exp> ::= <Power Exp>
67. <Power Exp> ::= <Power Exp> '^' <Value>
68. <Power Exp> ::= <Value>
69. <Value> ::= '(' <Expression> ')'
70. <Value> ::= ID
71. <Value> ::= ID '(' <Expression List> ')'
72. <Value> ::= <Constant>
73. <Constant> ::= Integer
74. <Constant> ::= String
75. <Constant> ::= Real
---------- state 0 ----------
$a ::= . <Lines>
<Lines> ::= . Integer <Statements> NewLine <Lines>
<Lines> ::= . Integer <Statements> NewLine
---------- state 1 ----------
$a ::= <Lines> .
---------- state 2 ----------
<Lines> ::= Integer . <Statements> NewLine <Lines>
<Lines> ::= Integer . <Statements> NewLine
<Statements> ::= . <Statement> ':' <Statements>
<Statements> ::= . <Statement>
<Statement> ::= . CLOSE '#' Integer
<Statement> ::= . DATA <Constant List>
<Statement> ::= . DIM ID '(' <Integer List> ')'
<Statement> ::= . END
<Statement> ::= . FOR ID '=' <Expression> TO <Expression>
<Statement> ::= . FOR ID '=' <Expression> TO <Expression> STEP Integer
<Statement> ::= . GOTO <Expression>
<Statement> ::= . GOSUB <Expression>
<Statement> ::= . IF <Expression> THEN <Statement>
<Statement> ::= . INPUT <ID List>
<Statement> ::= . INPUT '#' Integer ',' <ID List>
<Statement> ::= . LET Id '=' <Expression>
<Statement> ::= . NEXT <ID List>
<Statement> ::= . OPEN <Value> FOR <Access> AS '#' Integer
<Statement> ::= . POKE <Value List>
<Statement> ::= . PRINT <Print list>
<Statement> ::= . PRINT '#' Integer ',' <Print List>
<Statement> ::= . READ <ID List>
<Statement> ::= . RETURN
<Statement> ::= . RESTORE
<Statement> ::= . RUN
<Statement> ::= . STOP
<Statement> ::= . SYS <Value>
<Statement> ::= . WAIT <Value List>
<Statement> ::= . Remark
---------- state 3 ----------
<Lines> ::= Integer <Statements> . NewLine <Lines>
<Lines> ::= Integer <Statements> . NewLine
---------- state 4 ----------
<Statements> ::= <Statement> . ':' <Statements>
<Statements> ::= <Statement> .
---------- state 5 ----------
<Statement> ::= CLOSE . '#' Integer
---------- state 6 ----------
<Statement> ::= DATA . <Constant List>
<Constant List> ::= . <Constant> ',' <Constant List>
<Constant List> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 7 ----------
<Statement> ::= DIM . ID '(' <Integer List> ')'
---------- state 8 ----------
<Statement> ::= END .
---------- state 9 ----------
<Statement> ::= FOR . ID '=' <Expression> TO <Expression>
<Statement> ::= FOR . ID '=' <Expression> TO <Expression> STEP Integer
---------- state 10 ----------
<Statement> ::= GOTO . <Expression>
<Expression> ::= . <And Exp> OR <Expression>
<Expression> ::= . <And Exp>
<And Exp> ::= . <Not Exp> AND <And Exp>
<And Exp> ::= . <Not Exp>
<Not Exp> ::= . NOT <Compare Exp>
<Not Exp> ::= . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 11 ----------
<Statement> ::= GOSUB . <Expression>
<Expression> ::= . <And Exp> OR <Expression>
<Expression> ::= . <And Exp>
<And Exp> ::= . <Not Exp> AND <And Exp>
<And Exp> ::= . <Not Exp>
<Not Exp> ::= . NOT <Compare Exp>
<Not Exp> ::= . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 12 ----------
<Statement> ::= IF . <Expression> THEN <Statement>
<Expression> ::= . <And Exp> OR <Expression>
<Expression> ::= . <And Exp>
<And Exp> ::= . <Not Exp> AND <And Exp>
<And Exp> ::= . <Not Exp>
<Not Exp> ::= . NOT <Compare Exp>
<Not Exp> ::= . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 13 ----------
<Statement> ::= INPUT . <ID List>
<Statement> ::= INPUT . '#' Integer ',' <ID List>
<ID List> ::= . ID ',' <ID List>
<ID List> ::= . ID
---------- state 14 ----------
<Statement> ::= LET . Id '=' <Expression>
---------- state 15 ----------
<Statement> ::= NEXT . <ID List>
<ID List> ::= . ID ',' <ID List>
<ID List> ::= . ID
---------- state 16 ----------
<Statement> ::= OPEN . <Value> FOR <Access> AS '#' Integer
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 17 ----------
<Statement> ::= POKE . <Value List>
<Value List> ::= . <Value> ',' <Value List>
<Value List> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 18 ----------
<Statement> ::= PRINT . <Print list>
<Statement> ::= PRINT . '#' Integer ',' <Print List>
---------- state 19 ----------
<Statement> ::= READ . <ID List>
<ID List> ::= . ID ',' <ID List>
<ID List> ::= . ID
---------- state 20 ----------
<Statement> ::= RETURN .
---------- state 21 ----------
<Statement> ::= RESTORE .
---------- state 22 ----------
<Statement> ::= RUN .
---------- state 23 ----------
<Statement> ::= STOP .
---------- state 24 ----------
<Statement> ::= SYS . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 25 ----------
<Statement> ::= WAIT . <Value List>
<Value List> ::= . <Value> ',' <Value List>
<Value List> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 26 ----------
<Statement> ::= Remark .
---------- state 27 ----------
<Lines> ::= Integer <Statements> NewLine . <Lines>
<Lines> ::= Integer <Statements> NewLine .
<Lines> ::= . Integer <Statements> NewLine <Lines>
<Lines> ::= . Integer <Statements> NewLine
---------- state 28 ----------
<Statements> ::= <Statement> ':' . <Statements>
<Statements> ::= . <Statement> ':' <Statements>
<Statements> ::= . <Statement>
<Statement> ::= . CLOSE '#' Integer
<Statement> ::= . DATA <Constant List>
<Statement> ::= . DIM ID '(' <Integer List> ')'
<Statement> ::= . END
<Statement> ::= . FOR ID '=' <Expression> TO <Expression>
<Statement> ::= . FOR ID '=' <Expression> TO <Expression> STEP Integer
<Statement> ::= . GOTO <Expression>
<Statement> ::= . GOSUB <Expression>
<Statement> ::= . IF <Expression> THEN <Statement>
<Statement> ::= . INPUT <ID List>
<Statement> ::= . INPUT '#' Integer ',' <ID List>
<Statement> ::= . LET Id '=' <Expression>
<Statement> ::= . NEXT <ID List>
<Statement> ::= . OPEN <Value> FOR <Access> AS '#' Integer
<Statement> ::= . POKE <Value List>
<Statement> ::= . PRINT <Print list>
<Statement> ::= . PRINT '#' Integer ',' <Print List>
<Statement> ::= . READ <ID List>
<Statement> ::= . RETURN
<Statement> ::= . RESTORE
<Statement> ::= . RUN
<Statement> ::= . STOP
<Statement> ::= . SYS <Value>
<Statement> ::= . WAIT <Value List>
<Statement> ::= . Remark
---------- state 29 ----------
<Statement> ::= CLOSE '#' . Integer
---------- state 30 ----------
<Statement> ::= DATA <Constant List> .
---------- state 31 ----------
<Constant List> ::= <Constant> . ',' <Constant List>
<Constant List> ::= <Constant> .
---------- state 32 ----------
<Constant> ::= Integer .
---------- state 33 ----------
<Constant> ::= String .
---------- state 34 ----------
<Constant> ::= Real .
---------- state 35 ----------
<Statement> ::= DIM ID . '(' <Integer List> ')'
---------- state 36 ----------
<Statement> ::= FOR ID . '=' <Expression> TO <Expression>
<Statement> ::= FOR ID . '=' <Expression> TO <Expression> STEP Integer
---------- state 37 ----------
<Statement> ::= GOTO <Expression> .
---------- state 38 ----------
<Expression> ::= <And Exp> . OR <Expression>
<Expression> ::= <And Exp> .
---------- state 39 ----------
<And Exp> ::= <Not Exp> . AND <And Exp>
<And Exp> ::= <Not Exp> .
---------- state 40 ----------
<Not Exp> ::= NOT . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 41 ----------
<Not Exp> ::= <Compare Exp> .
---------- state 42 ----------
<Compare Exp> ::= <Add Exp> . '=' <Compare Exp>
<Compare Exp> ::= <Add Exp> . '<>' <Compare Exp>
<Compare Exp> ::= <Add Exp> . '><' <Compare Exp>
<Compare Exp> ::= <Add Exp> . '>' <Compare Exp>
<Compare Exp> ::= <Add Exp> . '>=' <Compare Exp>
<Compare Exp> ::= <Add Exp> . '<' <Compare Exp>
<Compare Exp> ::= <Add Exp> . '<=' <Compare Exp>
<Compare Exp> ::= <Add Exp> .
---------- state 43 ----------
<Add Exp> ::= <Mult Exp> . '+' <Add Exp>
<Add Exp> ::= <Mult Exp> . '-' <Add Exp>
<Add Exp> ::= <Mult Exp> .
---------- state 44 ----------
<Mult Exp> ::= <Negate Exp> . '*' <Mult Exp>
<Mult Exp> ::= <Negate Exp> . '/' <Mult Exp>
<Mult Exp> ::= <Negate Exp> .
---------- state 45 ----------
<Negate Exp> ::= '-' . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 46 ----------
<Negate Exp> ::= <Power Exp> .
<Power Exp> ::= <Power Exp> . '^' <Value>
---------- state 47 ----------
<Power Exp> ::= <Value> .
---------- state 48 ----------
<Value> ::= '(' . <Expression> ')'
<Expression> ::= . <And Exp> OR <Expression>
<Expression> ::= . <And Exp>
<And Exp> ::= . <Not Exp> AND <And Exp>
<And Exp> ::= . <Not Exp>
<Not Exp> ::= . NOT <Compare Exp>
<Not Exp> ::= . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 49 ----------
<Value> ::= ID .
<Value> ::= ID . '(' <Expression List> ')'
---------- state 50 ----------
<Value> ::= <Constant> .
---------- state 51 ----------
<Statement> ::= GOSUB <Expression> .
---------- state 52 ----------
<Statement> ::= IF <Expression> . THEN <Statement>
---------- state 53 ----------
<Statement> ::= INPUT <ID List> .
---------- state 54 ----------
<Statement> ::= INPUT '#' . Integer ',' <ID List>
---------- state 55 ----------
<ID List> ::= ID . ',' <ID List>
<ID List> ::= ID .
---------- state 56 ----------
<Statement> ::= LET Id . '=' <Expression>
---------- state 57 ----------
<Statement> ::= NEXT <ID List> .
---------- state 58 ----------
<Statement> ::= OPEN <Value> . FOR <Access> AS '#' Integer
---------- state 59 ----------
<Statement> ::= POKE <Value List> .
---------- state 60 ----------
<Value List> ::= <Value> . ',' <Value List>
<Value List> ::= <Value> .
---------- state 61 ----------
<Statement> ::= PRINT <Print list> .
---------- state 62 ----------
<Statement> ::= PRINT '#' . Integer ',' <Print List>
---------- state 63 ----------
<Statement> ::= READ <ID List> .
---------- state 64 ----------
<Statement> ::= SYS <Value> .
---------- state 65 ----------
<Statement> ::= WAIT <Value List> .
---------- state 66 ----------
<Lines> ::= Integer <Statements> NewLine <Lines> .
---------- state 67 ----------
<Statements> ::= <Statement> ':' <Statements> .
---------- state 68 ----------
<Statement> ::= CLOSE '#' Integer .
---------- state 69 ----------
<Constant List> ::= <Constant> ',' . <Constant List>
<Constant List> ::= . <Constant> ',' <Constant List>
<Constant List> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 70 ----------
<Statement> ::= DIM ID '(' . <Integer List> ')'
<Integer List> ::= . Integer ',' <Integer List>
<Integer List> ::= . Integer
---------- state 71 ----------
<Statement> ::= FOR ID '=' . <Expression> TO <Expression>
<Statement> ::= FOR ID '=' . <Expression> TO <Expression> STEP Integer
<Expression> ::= . <And Exp> OR <Expression>
<Expression> ::= . <And Exp>
<And Exp> ::= . <Not Exp> AND <And Exp>
<And Exp> ::= . <Not Exp>
<Not Exp> ::= . NOT <Compare Exp>
<Not Exp> ::= . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 72 ----------
<Expression> ::= <And Exp> OR . <Expression>
<Expression> ::= . <And Exp> OR <Expression>
<Expression> ::= . <And Exp>
<And Exp> ::= . <Not Exp> AND <And Exp>
<And Exp> ::= . <Not Exp>
<Not Exp> ::= . NOT <Compare Exp>
<Not Exp> ::= . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 73 ----------
<And Exp> ::= <Not Exp> AND . <And Exp>
<And Exp> ::= . <Not Exp> AND <And Exp>
<And Exp> ::= . <Not Exp>
<Not Exp> ::= . NOT <Compare Exp>
<Not Exp> ::= . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 74 ----------
<Not Exp> ::= NOT <Compare Exp> .
---------- state 75 ----------
<Compare Exp> ::= <Add Exp> '=' . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 76 ----------
<Compare Exp> ::= <Add Exp> '<>' . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 77 ----------
<Compare Exp> ::= <Add Exp> '><' . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 78 ----------
<Compare Exp> ::= <Add Exp> '>' . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 79 ----------
<Compare Exp> ::= <Add Exp> '>=' . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 80 ----------
<Compare Exp> ::= <Add Exp> '<' . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 81 ----------
<Compare Exp> ::= <Add Exp> '<=' . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 82 ----------
<Add Exp> ::= <Mult Exp> '+' . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 83 ----------
<Add Exp> ::= <Mult Exp> '-' . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 84 ----------
<Mult Exp> ::= <Negate Exp> '*' . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 85 ----------
<Mult Exp> ::= <Negate Exp> '/' . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 86 ----------
<Negate Exp> ::= '-' <Power Exp> .
<Power Exp> ::= <Power Exp> . '^' <Value>
---------- state 87 ----------
<Power Exp> ::= <Power Exp> '^' . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 88 ----------
<Value> ::= '(' <Expression> . ')'
---------- state 89 ----------
<Value> ::= ID '(' . <Expression List> ')'
<Expression List> ::= . <Expression> ',' <Expression List>
<Expression List> ::= . <Expression>
<Expression> ::= . <And Exp> OR <Expression>
<Expression> ::= . <And Exp>
<And Exp> ::= . <Not Exp> AND <And Exp>
<And Exp> ::= . <Not Exp>
<Not Exp> ::= . NOT <Compare Exp>
<Not Exp> ::= . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 90 ----------
<Statement> ::= IF <Expression> THEN . <Statement>
<Statement> ::= . CLOSE '#' Integer
<Statement> ::= . DATA <Constant List>
<Statement> ::= . DIM ID '(' <Integer List> ')'
<Statement> ::= . END
<Statement> ::= . FOR ID '=' <Expression> TO <Expression>
<Statement> ::= . FOR ID '=' <Expression> TO <Expression> STEP Integer
<Statement> ::= . GOTO <Expression>
<Statement> ::= . GOSUB <Expression>
<Statement> ::= . IF <Expression> THEN <Statement>
<Statement> ::= . INPUT <ID List>
<Statement> ::= . INPUT '#' Integer ',' <ID List>
<Statement> ::= . LET Id '=' <Expression>
<Statement> ::= . NEXT <ID List>
<Statement> ::= . OPEN <Value> FOR <Access> AS '#' Integer
<Statement> ::= . POKE <Value List>
<Statement> ::= . PRINT <Print list>
<Statement> ::= . PRINT '#' Integer ',' <Print List>
<Statement> ::= . READ <ID List>
<Statement> ::= . RETURN
<Statement> ::= . RESTORE
<Statement> ::= . RUN
<Statement> ::= . STOP
<Statement> ::= . SYS <Value>
<Statement> ::= . WAIT <Value List>
<Statement> ::= . Remark
---------- state 91 ----------
<Statement> ::= INPUT '#' Integer . ',' <ID List>
---------- state 92 ----------
<ID List> ::= ID ',' . <ID List>
<ID List> ::= . ID ',' <ID List>
<ID List> ::= . ID
---------- state 93 ----------
<Statement> ::= LET Id '=' . <Expression>
<Expression> ::= . <And Exp> OR <Expression>
<Expression> ::= . <And Exp>
<And Exp> ::= . <Not Exp> AND <And Exp>
<And Exp> ::= . <Not Exp>
<Not Exp> ::= . NOT <Compare Exp>
<Not Exp> ::= . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 94 ----------
<Statement> ::= OPEN <Value> FOR . <Access> AS '#' Integer
<Access> ::= . INPUT
<Access> ::= . OUPUT
---------- state 95 ----------
<Value List> ::= <Value> ',' . <Value List>
<Value List> ::= . <Value> ',' <Value List>
<Value List> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 96 ----------
<Statement> ::= PRINT '#' Integer . ',' <Print List>
---------- state 97 ----------
<Constant List> ::= <Constant> ',' <Constant List> .
---------- state 98 ----------
<Statement> ::= DIM ID '(' <Integer List> . ')'
---------- state 99 ----------
<Integer List> ::= Integer . ',' <Integer List>
<Integer List> ::= Integer .
---------- state 100 ----------
<Statement> ::= FOR ID '=' <Expression> . TO <Expression>
<Statement> ::= FOR ID '=' <Expression> . TO <Expression> STEP Integer
---------- state 101 ----------
<Expression> ::= <And Exp> OR <Expression> .
---------- state 102 ----------
<And Exp> ::= <Not Exp> AND <And Exp> .
---------- state 103 ----------
<Compare Exp> ::= <Add Exp> '=' <Compare Exp> .
---------- state 104 ----------
<Compare Exp> ::= <Add Exp> '<>' <Compare Exp> .
---------- state 105 ----------
<Compare Exp> ::= <Add Exp> '><' <Compare Exp> .
---------- state 106 ----------
<Compare Exp> ::= <Add Exp> '>' <Compare Exp> .
---------- state 107 ----------
<Compare Exp> ::= <Add Exp> '>=' <Compare Exp> .
---------- state 108 ----------
<Compare Exp> ::= <Add Exp> '<' <Compare Exp> .
---------- state 109 ----------
<Compare Exp> ::= <Add Exp> '<=' <Compare Exp> .
---------- state 110 ----------
<Add Exp> ::= <Mult Exp> '+' <Add Exp> .
---------- state 111 ----------
<Add Exp> ::= <Mult Exp> '-' <Add Exp> .
---------- state 112 ----------
<Mult Exp> ::= <Negate Exp> '*' <Mult Exp> .
---------- state 113 ----------
<Mult Exp> ::= <Negate Exp> '/' <Mult Exp> .
---------- state 114 ----------
<Power Exp> ::= <Power Exp> '^' <Value> .
---------- state 115 ----------
<Value> ::= '(' <Expression> ')' .
---------- state 116 ----------
<Value> ::= ID '(' <Expression List> . ')'
---------- state 117 ----------
<Expression List> ::= <Expression> . ',' <Expression List>
<Expression List> ::= <Expression> .
---------- state 118 ----------
<Statement> ::= IF <Expression> THEN <Statement> .
---------- state 119 ----------
<Statement> ::= INPUT '#' Integer ',' . <ID List>
<ID List> ::= . ID ',' <ID List>
<ID List> ::= . ID
---------- state 120 ----------
<ID List> ::= ID ',' <ID List> .
---------- state 121 ----------
<Statement> ::= LET Id '=' <Expression> .
---------- state 122 ----------
<Statement> ::= OPEN <Value> FOR <Access> . AS '#' Integer
---------- state 123 ----------
<Access> ::= INPUT .
---------- state 124 ----------
<Access> ::= OUPUT .
---------- state 125 ----------
<Value List> ::= <Value> ',' <Value List> .
---------- state 126 ----------
<Statement> ::= PRINT '#' Integer ',' . <Print List>
<Print List> ::= . <Expression> ';' <Print List>
<Print List> ::= . <Expression>
<Print List> ::= .
<Expression> ::= . <And Exp> OR <Expression>
<Expression> ::= . <And Exp>
<And Exp> ::= . <Not Exp> AND <And Exp>
<And Exp> ::= . <Not Exp>
<Not Exp> ::= . NOT <Compare Exp>
<Not Exp> ::= . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 127 ----------
<Statement> ::= DIM ID '(' <Integer List> ')' .
---------- state 128 ----------
<Integer List> ::= Integer ',' . <Integer List>
<Integer List> ::= . Integer ',' <Integer List>
<Integer List> ::= . Integer
---------- state 129 ----------
<Statement> ::= FOR ID '=' <Expression> TO . <Expression>
<Statement> ::= FOR ID '=' <Expression> TO . <Expression> STEP Integer
<Expression> ::= . <And Exp> OR <Expression>
<Expression> ::= . <And Exp>
<And Exp> ::= . <Not Exp> AND <And Exp>
<And Exp> ::= . <Not Exp>
<Not Exp> ::= . NOT <Compare Exp>
<Not Exp> ::= . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 130 ----------
<Value> ::= ID '(' <Expression List> ')' .
---------- state 131 ----------
<Expression List> ::= <Expression> ',' . <Expression List>
<Expression List> ::= . <Expression> ',' <Expression List>
<Expression List> ::= . <Expression>
<Expression> ::= . <And Exp> OR <Expression>
<Expression> ::= . <And Exp>
<And Exp> ::= . <Not Exp> AND <And Exp>
<And Exp> ::= . <Not Exp>
<Not Exp> ::= . NOT <Compare Exp>
<Not Exp> ::= . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 132 ----------
<Statement> ::= INPUT '#' Integer ',' <ID List> .
---------- state 133 ----------
<Statement> ::= OPEN <Value> FOR <Access> AS . '#' Integer
---------- state 134 ----------
<Statement> ::= PRINT '#' Integer ',' <Print List> .
---------- state 135 ----------
<Print List> ::= <Expression> . ';' <Print List>
<Print List> ::= <Expression> .
---------- state 136 ----------
<Integer List> ::= Integer ',' <Integer List> .
---------- state 137 ----------
<Statement> ::= FOR ID '=' <Expression> TO <Expression> .
<Statement> ::= FOR ID '=' <Expression> TO <Expression> . STEP Integer
---------- state 138 ----------
<Expression List> ::= <Expression> ',' <Expression List> .
---------- state 139 ----------
<Statement> ::= OPEN <Value> FOR <Access> AS '#' . Integer
---------- state 140 ----------
<Print List> ::= <Expression> ';' . <Print List>
<Print List> ::= . <Expression> ';' <Print List>
<Print List> ::= . <Expression>
<Print List> ::= .
<Expression> ::= . <And Exp> OR <Expression>
<Expression> ::= . <And Exp>
<And Exp> ::= . <Not Exp> AND <And Exp>
<And Exp> ::= . <Not Exp>
<Not Exp> ::= . NOT <Compare Exp>
<Not Exp> ::= . <Compare Exp>
<Compare Exp> ::= . <Add Exp> '=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '><' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '>=' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<' <Compare Exp>
<Compare Exp> ::= . <Add Exp> '<=' <Compare Exp>
<Compare Exp> ::= . <Add Exp>
<Add Exp> ::= . <Mult Exp> '+' <Add Exp>
<Add Exp> ::= . <Mult Exp> '-' <Add Exp>
<Add Exp> ::= . <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '*' <Mult Exp>
<Mult Exp> ::= . <Negate Exp> '/' <Mult Exp>
<Mult Exp> ::= . <Negate Exp>
<Negate Exp> ::= . '-' <Power Exp>
<Negate Exp> ::= . <Power Exp>
<Power Exp> ::= . <Power Exp> '^' <Value>
<Power Exp> ::= . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 141 ----------
<Statement> ::= FOR ID '=' <Expression> TO <Expression> STEP . Integer
---------- state 142 ----------
<Statement> ::= OPEN <Value> FOR <Access> AS '#' Integer .
---------- state 143 ----------
<Print List> ::= <Expression> ';' <Print List> .
---------- state 144 ----------
<Statement> ::= FOR ID '=' <Expression> TO <Expression> STEP Integer .
state token             action goto rule 
----- ----------------- ------ ---- ---- 
    0 <Lines>                2    1    0 
    0 Integer                1    2    1 
    1 $e                     0    0    0 
    2 <Statements>           2    3    1 
    2 <Statement>            2    4    3 
    2 CLOSE                  1    5    5 
    2 DATA                   1    6    6 
    2 DIM                    1    7    7 
    2 END                    1    8    8 
    2 FOR                    1    9    9 
    2 GOTO                   1   10   11 
    2 GOSUB                  1   11   12 
    2 IF                     1   12   13 
    2 INPUT                  1   13   14 
    2 LET                    1   14   16 
    2 NEXT                   1   15   17 
    2 OPEN                   1   16   18 
    2 POKE                   1   17   19 
    2 PRINT                  1   18   20 
    2 READ                   1   19   22 
    2 RETURN                 1   20   23 
    2 RESTORE                1   21   24 
    2 RUN                    1   22   25 
    2 STOP                   1   23   26 
    2 SYS                    1   24   27 
    2 WAIT                   1   25   28 
    2 Remark                 1   26   29 
    3 NewLine                1   27    1 
    4 ':'                    1   28    3 
    4 $e                     0    0    4 
    4 NewLine                0    0    4 
    5 '#'                    1   29    5 
    6 <Constant List>        2   30    6 
    6 <Constant>             2   31   36 
    6 Integer                1   32   73 
    6 String                 1   33   74 
    6 Real                   1   34   75 
    7 ID                     1   35    7 
    8 $e                     0    0    8 
    8 ':'                    0    0    8 
    8 NewLine                0    0    8 
    9 ID                     1   36    9 
   10 <Expression>           2   37   11 
   10 <And Exp>              2   38   45 
   10 <Not Exp>              2   39   47 
   10 NOT                    1   40   49 
   10 <Compare Exp>          2   41   50 
   10 <Add Exp>              2   42   51 
   10 <Mult Exp>             2   43   59 
   10 <Negate Exp>           2   44   62 
   10 '-'                    1   45   65 
   10 <Power Exp>            2   46   66 
   10 <Value>                2   47   68 
   10 '('                    1   48   69 
   10 ID                     1   49   70 
   10 <Constant>             2   50   72 
   10 Integer                1   32   73 
   10 String                 1   33   74 
   10 Real                   1   34   75 
   11 <Expression>           2   51   12 
   11 <And Exp>              2   38   45 
   11 <Not Exp>              2   39   47 
   11 NOT                    1   40   49 
   11 <Compare Exp>          2   41   50 
   11 <Add Exp>              2   42   51 
   11 <Mult Exp>             2   43   59 
   11 <Negate Exp>           2   44   62 
   11 '-'                    1   45   65 
   11 <Power Exp>            2   46   66 
   11 <Value>                2   47   68 
   11 '('                    1   48   69 
   11 ID                     1   49   70 
   11 <Constant>             2   50   72 
   11 Integer                1   32   73 
   11 String                 1   33   74 
   11 Real                   1   34   75 
   12 <Expression>           2   52   13 
   12 <And Exp>              2   38   45 
   12 <Not Exp>              2   39   47 
   12 NOT                    1   40   49 
   12 <Compare Exp>          2   41   50 
   12 <Add Exp>              2   42   51 
   12 <Mult Exp>             2   43   59 
   12 <Negate Exp>           2   44   62 
   12 '-'                    1   45   65 
   12 <Power Exp>            2   46   66 
   12 <Value>                2   47   68 
   12 '('                    1   48   69 
   12 ID                     1   49   70 
   12 <Constant>             2   50   72 
   12 Integer                1   32   73 
   12 String                 1   33   74 
   12 Real                   1   34   75 
   13 <ID List>              2   53   14 
   13 '#'                    1   54   15 
   13 ID                     1   55   32 
   14 Id                     1   56   16 
   15 <ID List>              2   57   17 
   15 ID                     1   55   32 
   16 <Value>                2   58   18 
   16 '('                    1   48   69 
   16 ID                     1   49   70 
   16 <Constant>             2   50   72 
   16 Integer                1   32   73 
   16 String                 1   33   74 
   16 Real                   1   34   75 
   17 <Value List>           2   59   19 
   17 <Value>                2   60   34 
   17 '('                    1   48   69 
   17 ID                     1   49   70 
   17 <Constant>             2   50   72 
   17 Integer                1   32   73 
   17 String                 1   33   74 
   17 Real                   1   34   75 
   18 <Print list>           1   61   20 
   18 '#'                    1   62   21 
   19 <ID List>              2   63   22 
   19 ID                     1   55   32 
   20 $e                     0    0   23 
   20 ':'                    0    0   23 
   20 NewLine                0    0   23 
   21 $e                     0    0   24 
   21 ':'                    0    0   24 
   21 NewLine                0    0   24 
   22 $e                     0    0   25 
   22 ':'                    0    0   25 
   22 NewLine                0    0   25 
   23 $e                     0    0   26 
   23 ':'                    0    0   26 
   23 NewLine                0    0   26 
   24 <Value>                2   64   27 
   24 '('                    1   48   69 
   24 ID                     1   49   70 
   24 <Constant>             2   50   72 
   24 Integer                1   32   73 
   24 String                 1   33   74 
   24 Real                   1   34   75 
   25 <Value List>           2   65   28 
   25 <Value>                2   60   34 
   25 '('                    1   48   69 
   25 ID                     1   49   70 
   25 <Constant>             2   50   72 
   25 Integer                1   32   73 
   25 String                 1   33   74 
   25 Real                   1   34   75 
   26 $e                     0    0   29 
   26 ':'                    0    0   29 
   26 NewLine                0    0   29 
   27 <Lines>                2   66    1 
   27 $e                     0    0    2 
   27 Integer                1    2    1 
   28 <Statements>           2   67    3 
   28 <Statement>            2    4    3 
   28 CLOSE                  1    5    5 
   28 DATA                   1    6    6 
   28 DIM                    1    7    7 
   28 END                    1    8    8 
   28 FOR                    1    9    9 
   28 GOTO                   1   10   11 
   28 GOSUB                  1   11   12 
   28 IF                     1   12   13 
   28 INPUT                  1   13   14 
   28 LET                    1   14   16 
   28 NEXT                   1   15   17 
   28 OPEN                   1   16   18 
   28 POKE                   1   17   19 
   28 PRINT                  1   18   20 
   28 READ                   1   19   22 
   28 RETURN                 1   20   23 
   28 RESTORE                1   21   24 
   28 RUN                    1   22   25 
   28 STOP                   1   23   26 
   28 SYS                    1   24   27 
   28 WAIT                   1   25   28 
   28 Remark                 1   26   29 
   29 Integer                1   68    5 
   30 $e                     0    0    6 
   30 ':'                    0    0    6 
   30 NewLine                0    0    6 
   31 ','                    1   69   36 
   31 $e                     0    0   37 
   31 ':'                    0    0   37 
   31 NewLine                0    0   37 
   32 $e                     0    0   73 
   32 ','                    0    0   73 
   32 ':'                    0    0   73 
   32 NewLine                0    0   73 
   32 FOR                    0    0   73 
   32 '^'                    0    0   73 
   32 '*'                    0    0   73 
   32 '/'                    0    0   73 
   32 '+'                    0    0   73 
   32 '-'                    0    0   73 
   32 '='                    0    0   73 
   32 '<>'                   0    0   73 
   32 '><'                   0    0   73 
   32 '>'                    0    0   73 
   32 '>='                   0    0   73 
   32 '<'                    0    0   73 
   32 '<='                   0    0   73 
   32 AND                    0    0   73 
   32 OR                     0    0   73 
   32 TO                     0    0   73 
   32 STEP                   0    0   73 
   32 THEN                   0    0   73 
   32 ';'                    0    0   73 
   32 ')'                    0    0   73 
   33 $e                     0    0   74 
   33 ','                    0    0   74 
   33 ':'                    0    0   74 
   33 NewLine                0    0   74 
   33 FOR                    0    0   74 
   33 '^'                    0    0   74 
   33 '*'                    0    0   74 
   33 '/'                    0    0   74 
   33 '+'                    0    0   74 
   33 '-'                    0    0   74 
   33 '='                    0    0   74 
   33 '<>'                   0    0   74 
   33 '><'                   0    0   74 
   33 '>'                    0    0   74 
   33 '>='                   0    0   74 
   33 '<'                    0    0   74 
   33 '<='                   0    0   74 
   33 AND                    0    0   74 
   33 OR                     0    0   74 
   33 TO                     0    0   74 
   33 STEP                   0    0   74 
   33 THEN                   0    0   74 
   33 ';'                    0    0   74 
   33 ')'                    0    0   74 
   34 $e                     0    0   75 
   34 ','                    0    0   75 
   34 ':'                    0    0   75 
   34 NewLine                0    0   75 
   34 FOR                    0    0   75 
   34 '^'                    0    0   75 
   34 '*'                    0    0   75 
   34 '/'                    0    0   75 
   34 '+'                    0    0   75 
   34 '-'                    0    0   75 
   34 '='                    0    0   75 
   34 '<>'                   0    0   75 
   34 '><'                   0    0   75 
   34 '>'                    0    0   75 
   34 '>='                   0    0   75 
   34 '<'                    0    0   75 
   34 '<='                   0    0   75 
   34 AND                    0    0   75 
   34 OR                     0    0   75 
   34 TO                     0    0   75 
   34 STEP                   0    0   75 
   34 THEN                   0    0   75 
   34 ';'                    0    0   75 
   34 ')'                    0    0   75 
   35 '('                    1   70    7 
   36 '='                    1   71    9 
   37 $e                     0    0   11 
   37 ':'                    0    0   11 
   37 NewLine                0    0   11 
   38 OR                     1   72   45 
   38 $e                     0    0   46 
   38 TO                     0    0   46 
   38 STEP                   0    0   46 
   38 THEN                   0    0   46 
   38 ','                    0    0   46 
   38 ';'                    0    0   46 
   38 ')'                    0    0   46 
   38 ':'                    0    0   46 
   38 NewLine                0    0   46 
   39 AND                    1   73   47 
   39 $e                     0    0   48 
   39 OR                     0    0   48 
   39 TO                     0    0   48 
   39 STEP                   0    0   48 
   39 THEN                   0    0   48 
   39 ','                    0    0   48 
   39 ';'                    0    0   48 
   39 ')'                    0    0   48 
   39 ':'                    0    0   48 
   39 NewLine                0    0   48 
   40 <Compare Exp>          2   74   49 
   40 <Add Exp>              2   42   51 
   40 <Mult Exp>             2   43   59 
   40 <Negate Exp>           2   44   62 
   40 '-'                    1   45   65 
   40 <Power Exp>            2   46   66 
   40 <Value>                2   47   68 
   40 '('                    1   48   69 
   40 ID                     1   49   70 
   40 <Constant>             2   50   72 
   40 Integer                1   32   73 
   40 String                 1   33   74 
   40 Real                   1   34   75 
   41 $e                     0    0   50 
   41 AND                    0    0   50 
   41 OR                     0    0   50 
   41 TO                     0    0   50 
   41 STEP                   0    0   50 
   41 THEN                   0    0   50 
   41 ','                    0    0   50 
   41 ';'                    0    0   50 
   41 ')'                    0    0   50 
   41 ':'                    0    0   50 
   41 NewLine                0    0   50 
   42 '='                    1   75   51 
   42 $e                     0    0   58 
   42 AND                    0    0   58 
   42 OR                     0    0   58 
   42 TO                     0    0   58 
   42 STEP                   0    0   58 
   42 THEN                   0    0   58 
   42 ','                    0    0   58 
   42 ';'                    0    0   58 
   42 ')'                    0    0   58 
   42 ':'                    0    0   58 
   42 NewLine                0    0   58 
   42 '<>'                   1   76   52 
   42 '><'                   1   77   53 
   42 '>'                    1   78   54 
   42 '>='                   1   79   55 
   42 '<'                    1   80   56 
   42 '<='                   1   81   57 
   43 '+'                    1   82   59 
   43 $e                     0    0   61 
   43 '='                    0    0   61 
   43 '<>'                   0    0   61 
   43 '><'                   0    0   61 
   43 '>'                    0    0   61 
   43 '>='                   0    0   61 
   43 '<'                    0    0   61 
   43 '<='                   0    0   61 
   43 AND                    0    0   61 
   43 OR                     0    0   61 
   43 TO                     0    0   61 
   43 STEP                   0    0   61 
   43 THEN                   0    0   61 
   43 ','                    0    0   61 
   43 ';'                    0    0   61 
   43 ')'                    0    0   61 
   43 ':'                    0    0   61 
   43 NewLine                0    0   61 
   43 '-'                    1   83   60 
   44 '*'                    1   84   62 
   44 $e                     0    0   64 
   44 '+'                    0    0   64 
   44 '-'                    0    0   64 
   44 '='                    0    0   64 
   44 '<>'                   0    0   64 
   44 '><'                   0    0   64 
   44 '>'                    0    0   64 
   44 '>='                   0    0   64 
   44 '<'                    0    0   64 
   44 '<='                   0    0   64 
   44 AND                    0    0   64 
   44 OR                     0    0   64 
   44 TO                     0    0   64 
   44 STEP                   0    0   64 
   44 THEN                   0    0   64 
   44 ','                    0    0   64 
   44 ';'                    0    0   64 
   44 ')'                    0    0   64 
   44 ':'                    0    0   64 
   44 NewLine                0    0   64 
   44 '/'                    1   85   63 
   45 <Power Exp>            2   86   65 
   45 <Value>                2   47   68 
   45 '('                    1   48   69 
   45 ID                     1   49   70 
   45 <Constant>             2   50   72 
   45 Integer                1   32   73 
   45 String                 1   33   74 
   45 Real                   1   34   75 
   46 $e                     0    0   66 
   46 '*'                    0    0   66 
   46 '/'                    0    0   66 
   46 '+'                    0    0   66 
   46 '-'                    0    0   66 
   46 '='                    0    0   66 
   46 '<>'                   0    0   66 
   46 '><'                   0    0   66 
   46 '>'                    0    0   66 
   46 '>='                   0    0   66 
   46 '<'                    0    0   66 
   46 '<='                   0    0   66 
   46 AND                    0    0   66 
   46 OR                     0    0   66 
   46 TO                     0    0   66 
   46 STEP                   0    0   66 
   46 THEN                   0    0   66 
   46 ','                    0    0   66 
   46 ';'                    0    0   66 
   46 ')'                    0    0   66 
   46 ':'                    0    0   66 
   46 NewLine                0    0   66 
   46 '^'                    1   87   67 
   47 $e                     0    0   68 
   47 '^'                    0    0   68 
   47 '*'                    0    0   68 
   47 '/'                    0    0   68 
   47 '+'                    0    0   68 
   47 '-'                    0    0   68 
   47 '='                    0    0   68 
   47 '<>'                   0    0   68 
   47 '><'                   0    0   68 
   47 '>'                    0    0   68 
   47 '>='                   0    0   68 
   47 '<'                    0    0   68 
   47 '<='                   0    0   68 
   47 AND                    0    0   68 
   47 OR                     0    0   68 
   47 TO                     0    0   68 
   47 STEP                   0    0   68 
   47 THEN                   0    0   68 
   47 ','                    0    0   68 
   47 ';'                    0    0   68 
   47 ')'                    0    0   68 
   47 ':'                    0    0   68 
   47 NewLine                0    0   68 
   48 <Expression>           2   88   69 
   48 <And Exp>              2   38   45 
   48 <Not Exp>              2   39   47 
   48 NOT                    1   40   49 
   48 <Compare Exp>          2   41   50 
   48 <Add Exp>              2   42   51 
   48 <Mult Exp>             2   43   59 
   48 <Negate Exp>           2   44   62 
   48 '-'                    1   45   65 
   48 <Power Exp>            2   46   66 
   48 <Value>                2   47   68 
   48 '('                    1   48   69 
   48 ID                     1   49   70 
   48 <Constant>             2   50   72 
   48 Integer                1   32   73 
   48 String                 1   33   74 
   48 Real                   1   34   75 
   49 $e                     0    0   70 
   49 FOR                    0    0   70 
   49 ','                    0    0   70 
   49 ':'                    0    0   70 
   49 NewLine                0    0   70 
   49 '^'                    0    0   70 
   49 '*'                    0    0   70 
   49 '/'                    0    0   70 
   49 '+'                    0    0   70 
   49 '-'                    0    0   70 
   49 '='                    0    0   70 
   49 '<>'                   0    0   70 
   49 '><'                   0    0   70 
   49 '>'                    0    0   70 
   49 '>='                   0    0   70 
   49 '<'                    0    0   70 
   49 '<='                   0    0   70 
   49 AND                    0    0   70 
   49 OR                     0    0   70 
   49 TO                     0    0   70 
   49 STEP                   0    0   70 
   49 THEN                   0    0   70 
   49 ';'                    0    0   70 
   49 ')'                    0    0   70 
   49 '('                    1   89   71 
   50 $e                     0    0   72 
   50 FOR                    0    0   72 
   50 ','                    0    0   72 
   50 ':'                    0    0   72 
   50 NewLine                0    0   72 
   50 '^'                    0    0   72 
   50 '*'                    0    0   72 
   50 '/'                    0    0   72 
   50 '+'                    0    0   72 
   50 '-'                    0    0   72 
   50 '='                    0    0   72 
   50 '<>'                   0    0   72 
   50 '><'                   0    0   72 
   50 '>'                    0    0   72 
   50 '>='                   0    0   72 
   50 '<'                    0    0   72 
   50 '<='                   0    0   72 
   50 AND                    0    0   72 
   50 OR                     0    0   72 
   50 TO                     0    0   72 
   50 STEP                   0    0   72 
   50 THEN                   0    0   72 
   50 ';'                    0    0   72 
   50 ')'                    0    0   72 
   51 $e                     0    0   12 
   51 ':'                    0    0   12 
   51 NewLine                0    0   12 
   52 THEN                   1   90   13 
   53 $e                     0    0   14 
   53 ':'                    0    0   14 
   53 NewLine                0    0   14 
   54 Integer                1   91   15 
   55 ','                    1   92   32 
   55 $e                     0    0   33 
   55 ':'                    0    0   33 
   55 NewLine                0    0   33 
   56 '='                    1   93   16 
   57 $e                     0    0   17 
   57 ':'                    0    0   17 
   57 NewLine                0    0   17 
   58 FOR                    1   94   18 
   59 $e                     0    0   19 
   59 ':'                    0    0   19 
   59 NewLine                0    0   19 
   60 ','                    1   95   34 
   60 $e                     0    0   35 
   60 ':'                    0    0   35 
   60 NewLine                0    0   35 
   61 $e                     0    0   20 
   61 ':'                    0    0   20 
   61 NewLine                0    0   20 
   62 Integer                1   96   21 
   63 $e                     0    0   22 
   63 ':'                    0    0   22 
   63 NewLine                0    0   22 
   64 $e                     0    0   27 
   64 ':'                    0    0   27 
   64 NewLine                0    0   27 
   65 $e                     0    0   28 
   65 ':'                    0    0   28 
   65 NewLine                0    0   28 
   66 $e                     0    0    1 
   67 $e                     0    0    3 
   67 NewLine                0    0    3 
   68 $e                     0    0    5 
   68 ':'                    0    0    5 
   68 NewLine                0    0    5 
   69 <Constant List>        2   97   36 
   69 <Constant>             2   31   36 
   69 Integer                1   32   73 
   69 String                 1   33   74 
   69 Real                   1   34   75 
   70 <Integer List>         2   98    7 
   70 Integer                1   99   38 
   71 <Expression>           2  100    9 
   71 <And Exp>              2   38   45 
   71 <Not Exp>              2   39   47 
   71 NOT                    1   40   49 
   71 <Compare Exp>          2   41   50 
   71 <Add Exp>              2   42   51 
   71 <Mult Exp>             2   43   59 
   71 <Negate Exp>           2   44   62 
   71 '-'                    1   45   65 
   71 <Power Exp>            2   46   66 
   71 <Value>                2   47   68 
   71 '('                    1   48   69 
   71 ID                     1   49   70 
   71 <Constant>             2   50   72 
   71 Integer                1   32   73 
   71 String                 1   33   74 
   71 Real                   1   34   75 
   72 <Expression>           2  101   45 
   72 <And Exp>              2   38   45 
   72 <Not Exp>              2   39   47 
   72 NOT                    1   40   49 
   72 <Compare Exp>          2   41   50 
   72 <Add Exp>              2   42   51 
   72 <Mult Exp>             2   43   59 
   72 <Negate Exp>           2   44   62 
   72 '-'                    1   45   65 
   72 <Power Exp>            2   46   66 
   72 <Value>                2   47   68 
   72 '('                    1   48   69 
   72 ID                     1   49   70 
   72 <Constant>             2   50   72 
   72 Integer                1   32   73 
   72 String                 1   33   74 
   72 Real                   1   34   75 
   73 <And Exp>              2  102   47 
   73 <Not Exp>              2   39   47 
   73 NOT                    1   40   49 
   73 <Compare Exp>          2   41   50 
   73 <Add Exp>              2   42   51 
   73 <Mult Exp>             2   43   59 
   73 <Negate Exp>           2   44   62 
   73 '-'                    1   45   65 
   73 <Power Exp>            2   46   66 
   73 <Value>                2   47   68 
   73 '('                    1   48   69 
   73 ID                     1   49   70 
   73 <Constant>             2   50   72 
   73 Integer                1   32   73 
   73 String                 1   33   74 
   73 Real                   1   34   75 
   74 $e                     0    0   49 
   74 AND                    0    0   49 
   74 OR                     0    0   49 
   74 TO                     0    0   49 
   74 STEP                   0    0   49 
   74 THEN                   0    0   49 
   74 ','                    0    0   49 
   74 ';'                    0    0   49 
   74 ')'                    0    0   49 
   74 ':'                    0    0   49 
   74 NewLine                0    0   49 
   75 <Compare Exp>          2  103   51 
   75 <Add Exp>              2   42   51 
   75 <Mult Exp>             2   43   59 
   75 <Negate Exp>           2   44   62 
   75 '-'                    1   45   65 
   75 <Power Exp>            2   46   66 
   75 <Value>                2   47   68 
   75 '('                    1   48   69 
   75 ID                     1   49   70 
   75 <Constant>             2   50   72 
   75 Integer                1   32   73 
   75 String                 1   33   74 
   75 Real                   1   34   75 
   76 <Compare Exp>          2  104   52 
   76 <Add Exp>              2   42   51 
   76 <Mult Exp>             2   43   59 
   76 <Negate Exp>           2   44   62 
   76 '-'                    1   45   65 
   76 <Power Exp>            2   46   66 
   76 <Value>                2   47   68 
   76 '('                    1   48   69 
   76 ID                     1   49   70 
   76 <Constant>             2   50   72 
   76 Integer                1   32   73 
   76 String                 1   33   74 
   76 Real                   1   34   75 
   77 <Compare Exp>          2  105   53 
   77 <Add Exp>              2   42   51 
   77 <Mult Exp>             2   43   59 
   77 <Negate Exp>           2   44   62 
   77 '-'                    1   45   65 
   77 <Power Exp>            2   46   66 
   77 <Value>                2   47   68 
   77 '('                    1   48   69 
   77 ID                     1   49   70 
   77 <Constant>             2   50   72 
   77 Integer                1   32   73 
   77 String                 1   33   74 
   77 Real                   1   34   75 
   78 <Compare Exp>          2  106   54 
   78 <Add Exp>              2   42   51 
   78 <Mult Exp>             2   43   59 
   78 <Negate Exp>           2   44   62 
   78 '-'                    1   45   65 
   78 <Power Exp>            2   46   66 
   78 <Value>                2   47   68 
   78 '('                    1   48   69 
   78 ID                     1   49   70 
   78 <Constant>             2   50   72 
   78 Integer                1   32   73 
   78 String                 1   33   74 
   78 Real                   1   34   75 
   79 <Compare Exp>          2  107   55 
   79 <Add Exp>              2   42   51 
   79 <Mult Exp>             2   43   59 
   79 <Negate Exp>           2   44   62 
   79 '-'                    1   45   65 
   79 <Power Exp>            2   46   66 
   79 <Value>                2   47   68 
   79 '('                    1   48   69 
   79 ID                     1   49   70 
   79 <Constant>             2   50   72 
   79 Integer                1   32   73 
   79 String                 1   33   74 
   79 Real                   1   34   75 
   80 <Compare Exp>          2  108   56 
   80 <Add Exp>              2   42   51 
   80 <Mult Exp>             2   43   59 
   80 <Negate Exp>           2   44   62 
   80 '-'                    1   45   65 
   80 <Power Exp>            2   46   66 
   80 <Value>                2   47   68 
   80 '('                    1   48   69 
   80 ID                     1   49   70 
   80 <Constant>             2   50   72 
   80 Integer                1   32   73 
   80 String                 1   33   74 
   80 Real                   1   34   75 
   81 <Compare Exp>          2  109   57 
   81 <Add Exp>              2   42   51 
   81 <Mult Exp>             2   43   59 
   81 <Negate Exp>           2   44   62 
   81 '-'                    1   45   65 
   81 <Power Exp>            2   46   66 
   81 <Value>                2   47   68 
   81 '('                    1   48   69 
   81 ID                     1   49   70 
   81 <Constant>             2   50   72 
   81 Integer                1   32   73 
   81 String                 1   33   74 
   81 Real                   1   34   75 
   82 <Add Exp>              2  110   59 
   82 <Mult Exp>             2   43   59 
   82 <Negate Exp>           2   44   62 
   82 '-'                    1   45   65 
   82 <Power Exp>            2   46   66 
   82 <Value>                2   47   68 
   82 '('                    1   48   69 
   82 ID                     1   49   70 
   82 <Constant>             2   50   72 
   82 Integer                1   32   73 
   82 String                 1   33   74 
   82 Real                   1   34   75 
   83 <Add Exp>              2  111   60 
   83 <Mult Exp>             2   43   59 
   83 <Negate Exp>           2   44   62 
   83 '-'                    1   45   65 
   83 <Power Exp>            2   46   66 
   83 <Value>                2   47   68 
   83 '('                    1   48   69 
   83 ID                     1   49   70 
   83 <Constant>             2   50   72 
   83 Integer                1   32   73 
   83 String                 1   33   74 
   83 Real                   1   34   75 
   84 <Mult Exp>             2  112   62 
   84 <Negate Exp>           2   44   62 
   84 '-'                    1   45   65 
   84 <Power Exp>            2   46   66 
   84 <Value>                2   47   68 
   84 '('                    1   48   69 
   84 ID                     1   49   70 
   84 <Constant>             2   50   72 
   84 Integer                1   32   73 
   84 String                 1   33   74 
   84 Real                   1   34   75 
   85 <Mult Exp>             2  113   63 
   85 <Negate Exp>           2   44   62 
   85 '-'                    1   45   65 
   85 <Power Exp>            2   46   66 
   85 <Value>                2   47   68 
   85 '('                    1   48   69 
   85 ID                     1   49   70 
   85 <Constant>             2   50   72 
   85 Integer                1   32   73 
   85 String                 1   33   74 
   85 Real                   1   34   75 
   86 $e                     0    0   65 
   86 '*'                    0    0   65 
   86 '/'                    0    0   65 
   86 '+'                    0    0   65 
   86 '-'                    0    0   65 
   86 '='                    0    0   65 
   86 '<>'                   0    0   65 
   86 '><'                   0    0   65 
   86 '>'                    0    0   65 
   86 '>='                   0    0   65 
   86 '<'                    0    0   65 
   86 '<='                   0    0   65 
   86 AND                    0    0   65 
   86 OR                     0    0   65 
   86 TO                     0    0   65 
   86 STEP                   0    0   65 
   86 THEN                   0    0   65 
   86 ','                    0    0   65 
   86 ';'                    0    0   65 
   86 ')'                    0    0   65 
   86 ':'                    0    0   65 
   86 NewLine                0    0   65 
   86 '^'                    1   87   67 
   87 <Value>                2  114   67 
   87 '('                    1   48   69 
   87 ID                     1   49   70 
   87 <Constant>             2   50   72 
   87 Integer                1   32   73 
   87 String                 1   33   74 
   87 Real                   1   34   75 
   88 ')'                    1  115   69 
   89 <Expression List>      2  116   71 
   89 <Expression>           2  117   40 
   89 <And Exp>              2   38   45 
   89 <Not Exp>              2   39   47 
   89 NOT                    1   40   49 
   89 <Compare Exp>          2   41   50 
   89 <Add Exp>              2   42   51 
   89 <Mult Exp>             2   43   59 
   89 <Negate Exp>           2   44   62 
   89 '-'                    1   45   65 
   89 <Power Exp>            2   46   66 
   89 <Value>                2   47   68 
   89 '('                    1   48   69 
   89 ID                     1   49   70 
   89 <Constant>             2   50   72 
   89 Integer                1   32   73 
   89 String                 1   33   74 
   89 Real                   1   34   75 
   90 <Statement>            2  118   13 
   90 CLOSE                  1    5    5 
   90 DATA                   1    6    6 
   90 DIM                    1    7    7 
   90 END                    1    8    8 
   90 FOR                    1    9    9 
   90 GOTO                   1   10   11 
   90 GOSUB                  1   11   12 
   90 IF                     1   12   13 
   90 INPUT                  1   13   14 
   90 LET                    1   14   16 
   90 NEXT                   1   15   17 
   90 OPEN                   1   16   18 
   90 POKE                   1   17   19 
   90 PRINT                  1   18   20 
   90 READ                   1   19   22 
   90 RETURN                 1   20   23 
   90 RESTORE                1   21   24 
   90 RUN                    1   22   25 
   90 STOP                   1   23   26 
   90 SYS                    1   24   27 
   90 WAIT                   1   25   28 
   90 Remark                 1   26   29 
   91 ','                    1  119   15 
   92 <ID List>              2  120   32 
   92 ID                     1   55   32 
   93 <Expression>           2  121   16 
   93 <And Exp>              2   38   45 
   93 <Not Exp>              2   39   47 
   93 NOT                    1   40   49 
   93 <Compare Exp>          2   41   50 
   93 <Add Exp>              2   42   51 
   93 <Mult Exp>             2   43   59 
   93 <Negate Exp>           2   44   62 
   93 '-'                    1   45   65 
   93 <Power Exp>            2   46   66 
   93 <Value>                2   47   68 
   93 '('                    1   48   69 
   93 ID                     1   49   70 
   93 <Constant>             2   50   72 
   93 Integer                1   32   73 
   93 String                 1   33   74 
   93 Real                   1   34   75 
   94 <Access>               2  122   18 
   94 INPUT                  1  123   30 
   94 OUPUT                  1  124   31 
   95 <Value List>           2  125   34 
   95 <Value>                2   60   34 
   95 '('                    1   48   69 
   95 ID                     1   49   70 
   95 <Constant>             2   50   72 
   95 Integer                1   32   73 
   95 String                 1   33   74 
   95 Real                   1   34   75 
   96 ','                    1  126   21 
   97 $e                     0    0   36 
   97 ':'                    0    0   36 
   97 NewLine                0    0   36 
   98 ')'                    1  127    7 
   99 ','                    1  128   38 
   99 $e                     0    0   39 
   99 ')'                    0    0   39 
  100 TO                     1  129    9 
  101 $e                     0    0   45 
  101 TO                     0    0   45 
  101 STEP                   0    0   45 
  101 THEN                   0    0   45 
  101 ','                    0    0   45 
  101 ';'                    0    0   45 
  101 ')'                    0    0   45 
  101 ':'                    0    0   45 
  101 NewLine                0    0   45 
  102 $e                     0    0   47 
  102 OR                     0    0   47 
  102 TO                     0    0   47 
  102 STEP                   0    0   47 
  102 THEN                   0    0   47 
  102 ','                    0    0   47 
  102 ';'                    0    0   47 
  102 ')'                    0    0   47 
  102 ':'                    0    0   47 
  102 NewLine                0    0   47 
  103 $e                     0    0   51 
  103 AND                    0    0   51 
  103 OR                     0    0   51 
  103 TO                     0    0   51 
  103 STEP                   0    0   51 
  103 THEN                   0    0   51 
  103 ','                    0    0   51 
  103 ';'                    0    0   51 
  103 ')'                    0    0   51 
  103 ':'                    0    0   51 
  103 NewLine                0    0   51 
  104 $e                     0    0   52 
  104 AND                    0    0   52 
  104 OR                     0    0   52 
  104 TO                     0    0   52 
  104 STEP                   0    0   52 
  104 THEN                   0    0   52 
  104 ','                    0    0   52 
  104 ';'                    0    0   52 
  104 ')'                    0    0   52 
  104 ':'                    0    0   52 
  104 NewLine                0    0   52 
  105 $e                     0    0   53 
  105 AND                    0    0   53 
  105 OR                     0    0   53 
  105 TO                     0    0   53 
  105 STEP                   0    0   53 
  105 THEN                   0    0   53 
  105 ','                    0    0   53 
  105 ';'                    0    0   53 
  105 ')'                    0    0   53 
  105 ':'                    0    0   53 
  105 NewLine                0    0   53 
  106 $e                     0    0   54 
  106 AND                    0    0   54 
  106 OR                     0    0   54 
  106 TO                     0    0   54 
  106 STEP                   0    0   54 
  106 THEN                   0    0   54 
  106 ','                    0    0   54 
  106 ';'                    0    0   54 
  106 ')'                    0    0   54 
  106 ':'                    0    0   54 
  106 NewLine                0    0   54 
  107 $e                     0    0   55 
  107 AND                    0    0   55 
  107 OR                     0    0   55 
  107 TO                     0    0   55 
  107 STEP                   0    0   55 
  107 THEN                   0    0   55 
  107 ','                    0    0   55 
  107 ';'                    0    0   55 
  107 ')'                    0    0   55 
  107 ':'                    0    0   55 
  107 NewLine                0    0   55 
  108 $e                     0    0   56 
  108 AND                    0    0   56 
  108 OR                     0    0   56 
  108 TO                     0    0   56 
  108 STEP                   0    0   56 
  108 THEN                   0    0   56 
  108 ','                    0    0   56 
  108 ';'                    0    0   56 
  108 ')'                    0    0   56 
  108 ':'                    0    0   56 
  108 NewLine                0    0   56 
  109 $e                     0    0   57 
  109 AND                    0    0   57 
  109 OR                     0    0   57 
  109 TO                     0    0   57 
  109 STEP                   0    0   57 
  109 THEN                   0    0   57 
  109 ','                    0    0   57 
  109 ';'                    0    0   57 
  109 ')'                    0    0   57 
  109 ':'                    0    0   57 
  109 NewLine                0    0   57 
  110 $e                     0    0   59 
  110 '='                    0    0   59 
  110 '<>'                   0    0   59 
  110 '><'                   0    0   59 
  110 '>'                    0    0   59 
  110 '>='                   0    0   59 
  110 '<'                    0    0   59 
  110 '<='                   0    0   59 
  110 AND                    0    0   59 
  110 OR                     0    0   59 
  110 TO                     0    0   59 
  110 STEP                   0    0   59 
  110 THEN                   0    0   59 
  110 ','                    0    0   59 
  110 ';'                    0    0   59 
  110 ')'                    0    0   59 
  110 ':'                    0    0   59 
  110 NewLine                0    0   59 
  111 $e                     0    0   60 
  111 '='                    0    0   60 
  111 '<>'                   0    0   60 
  111 '><'                   0    0   60 
  111 '>'                    0    0   60 
  111 '>='                   0    0   60 
  111 '<'                    0    0   60 
  111 '<='                   0    0   60 
  111 AND                    0    0   60 
  111 OR                     0    0   60 
  111 TO                     0    0   60 
  111 STEP                   0    0   60 
  111 THEN                   0    0   60 
  111 ','                    0    0   60 
  111 ';'                    0    0   60 
  111 ')'                    0    0   60 
  111 ':'                    0    0   60 
  111 NewLine                0    0   60 
  112 $e                     0    0   62 
  112 '+'                    0    0   62 
  112 '-'                    0    0   62 
  112 '='                    0    0   62 
  112 '<>'                   0    0   62 
  112 '><'                   0    0   62 
  112 '>'                    0    0   62 
  112 '>='                   0    0   62 
  112 '<'                    0    0   62 
  112 '<='                   0    0   62 
  112 AND                    0    0   62 
  112 OR                     0    0   62 
  112 TO                     0    0   62 
  112 STEP                   0    0   62 
  112 THEN                   0    0   62 
  112 ','                    0    0   62 
  112 ';'                    0    0   62 
  112 ')'                    0    0   62 
  112 ':'                    0    0   62 
  112 NewLine                0    0   62 
  113 $e                     0    0   63 
  113 '+'                    0    0   63 
  113 '-'                    0    0   63 
  113 '='                    0    0   63 
  113 '<>'                   0    0   63 
  113 '><'                   0    0   63 
  113 '>'                    0    0   63 
  113 '>='                   0    0   63 
  113 '<'                    0    0   63 
  113 '<='                   0    0   63 
  113 AND                    0    0   63 
  113 OR                     0    0   63 
  113 TO                     0    0   63 
  113 STEP                   0    0   63 
  113 THEN                   0    0   63 
  113 ','                    0    0   63 
  113 ';'                    0    0   63 
  113 ')'                    0    0   63 
  113 ':'                    0    0   63 
  113 NewLine                0    0   63 
  114 $e                     0    0   67 
  114 '^'                    0    0   67 
  114 '*'                    0    0   67 
  114 '/'                    0    0   67 
  114 '+'                    0    0   67 
  114 '-'                    0    0   67 
  114 '='                    0    0   67 
  114 '<>'                   0    0   67 
  114 '><'                   0    0   67 
  114 '>'                    0    0   67 
  114 '>='                   0    0   67 
  114 '<'                    0    0   67 
  114 '<='                   0    0   67 
  114 AND                    0    0   67 
  114 OR                     0    0   67 
  114 TO                     0    0   67 
  114 STEP                   0    0   67 
  114 THEN                   0    0   67 
  114 ','                    0    0   67 
  114 ';'                    0    0   67 
  114 ')'                    0    0   67 
  114 ':'                    0    0   67 
  114 NewLine                0    0   67 
  115 $e                     0    0   69 
  115 FOR                    0    0   69 
  115 ','                    0    0   69 
  115 ':'                    0    0   69 
  115 NewLine                0    0   69 
  115 '^'                    0    0   69 
  115 '*'                    0    0   69 
  115 '/'                    0    0   69 
  115 '+'                    0    0   69 
  115 '-'                    0    0   69 
  115 '='                    0    0   69 
  115 '<>'                   0    0   69 
  115 '><'                   0    0   69 
  115 '>'                    0    0   69 
  115 '>='                   0    0   69 
  115 '<'                    0    0   69 
  115 '<='                   0    0   69 
  115 AND                    0    0   69 
  115 OR                     0    0   69 
  115 TO                     0    0   69 
  115 STEP                   0    0   69 
  115 THEN                   0    0   69 
  115 ';'                    0    0   69 
  115 ')'                    0    0   69 
  116 ')'                    1  130   71 
  117 ','                    1  131   40 
  117 $e                     0    0   41 
  117 ')'                    0    0   41 
  118 $e                     0    0   13 
  118 ':'                    0    0   13 
  118 NewLine                0    0   13 
  119 <ID List>              2  132   15 
  119 ID                     1   55   32 
  120 $e                     0    0   32 
  120 ':'                    0    0   32 
  120 NewLine                0    0   32 
  121 $e                     0    0   16 
  121 ':'                    0    0   16 
  121 NewLine                0    0   16 
  122 AS                     1  133   18 
  123 $e                     0    0   30 
  123 AS                     0    0   30 
  124 $e                     0    0   31 
  124 AS                     0    0   31 
  125 $e                     0    0   34 
  125 ':'                    0    0   34 
  125 NewLine                0    0   34 
  126 <Print List>           2  134   21 
  126 $e                     0    0   44 
  126 ':'                    0    0   44 
  126 NewLine                0    0   44 
  126 <Expression>           2  135   42 
  126 <And Exp>              2   38   45 
  126 <Not Exp>              2   39   47 
  126 NOT                    1   40   49 
  126 <Compare Exp>          2   41   50 
  126 <Add Exp>              2   42   51 
  126 <Mult Exp>             2   43   59 
  126 <Negate Exp>           2   44   62 
  126 '-'                    1   45   65 
  126 <Power Exp>            2   46   66 
  126 <Value>                2   47   68 
  126 '('                    1   48   69 
  126 ID                     1   49   70 
  126 <Constant>             2   50   72 
  126 Integer                1   32   73 
  126 String                 1   33   74 
  126 Real                   1   34   75 
  127 $e                     0    0    7 
  127 ':'                    0    0    7 
  127 NewLine                0    0    7 
  128 <Integer List>         2  136   38 
  128 Integer                1   99   38 
  129 <Expression>           2  137    9 
  129 <And Exp>              2   38   45 
  129 <Not Exp>              2   39   47 
  129 NOT                    1   40   49 
  129 <Compare Exp>          2   41   50 
  129 <Add Exp>              2   42   51 
  129 <Mult Exp>             2   43   59 
  129 <Negate Exp>           2   44   62 
  129 '-'                    1   45   65 
  129 <Power Exp>            2   46   66 
  129 <Value>                2   47   68 
  129 '('                    1   48   69 
  129 ID                     1   49   70 
  129 <Constant>             2   50   72 
  129 Integer                1   32   73 
  129 String                 1   33   74 
  129 Real                   1   34   75 
  130 $e                     0    0   71 
  130 FOR                    0    0   71 
  130 ','                    0    0   71 
  130 ':'                    0    0   71 
  130 NewLine                0    0   71 
  130 '^'                    0    0   71 
  130 '*'                    0    0   71 
  130 '/'                    0    0   71 
  130 '+'                    0    0   71 
  130 '-'                    0    0   71 
  130 '='                    0    0   71 
  130 '<>'                   0    0   71 
  130 '><'                   0    0   71 
  130 '>'                    0    0   71 
  130 '>='                   0    0   71 
  130 '<'                    0    0   71 
  130 '<='                   0    0   71 
  130 AND                    0    0   71 
  130 OR                     0    0   71 
  130 TO                     0    0   71 
  130 STEP                   0    0   71 
  130 THEN                   0    0   71 
  130 ';'                    0    0   71 
  130 ')'                    0    0   71 
  131 <Expression List>      2  138   40 
  131 <Expression>           2  117   40 
  131 <And Exp>              2   38   45 
  131 <Not Exp>              2   39   47 
  131 NOT                    1   40   49 
  131 <Compare Exp>          2   41   50 
  131 <Add Exp>              2   42   51 
  131 <Mult Exp>             2   43   59 
  131 <Negate Exp>           2   44   62 
  131 '-'                    1   45   65 
  131 <Power Exp>            2   46   66 
  131 <Value>                2   47   68 
  131 '('                    1   48   69 
  131 ID                     1   49   70 
  131 <Constant>             2   50   72 
  131 Integer                1   32   73 
  131 String                 1   33   74 
  131 Real                   1   34   75 
  132 $e                     0    0   15 
  132 ':'                    0    0   15 
  132 NewLine                0    0   15 
  133 '#'                    1  139   18 
  134 $e                     0    0   21 
  134 ':'                    0    0   21 
  134 NewLine                0    0   21 
  135 ';'                    1  140   42 
  135 $e                     0    0   43 
  135 ':'                    0    0   43 
  135 NewLine                0    0   43 
  136 $e                     0    0   38 
  136 ')'                    0    0   38 
  137 $e                     0    0    9 
  137 ':'                    0    0    9 
  137 NewLine                0    0    9 
  137 STEP                   1  141   10 
  138 $e                     0    0   40 
  138 ')'                    0    0   40 
  139 Integer                1  142   18 
  140 <Print List>           2  143   42 
  140 $e                     0    0   44 
  140 ':'                    0    0   44 
  140 NewLine                0    0   44 
  140 <Expression>           2  135   42 
  140 <And Exp>              2   38   45 
  140 <Not Exp>              2   39   47 
  140 NOT                    1   40   49 
  140 <Compare Exp>          2   41   50 
  140 <Add Exp>              2   42   51 
  140 <Mult Exp>             2   43   59 
  140 <Negate Exp>           2   44   62 
  140 '-'                    1   45   65 
  140 <Power Exp>            2   46   66 
  140 <Value>                2   47   68 
  140 '('                    1   48   69 
  140 ID                     1   49   70 
  140 <Constant>             2   50   72 
  140 Integer                1   32   73 
  140 String                 1   33   74 
  140 Real                   1   34   75 
  141 Integer                1  144   10 
  142 $e                     0    0   18 
  142 ':'                    0    0   18 
  142 NewLine                0    0   18 
  143 $e                     0    0   42 
  143 ':'                    0    0   42 
  143 NewLine                0    0   42 
  144 $e                     0    0   10 
  144 ':'                    0    0   10 
  144 NewLine                0    0   10 
