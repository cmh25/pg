n: $a <Lines> <Statements> <Statement> <Access> <ID List> <Value List> <Constant List> <Integer List> <Expression List> <Print List> <Expression> <And Exp> <Not Exp> <Compare Exp> <Add Exp> <Mult Exp> <Negate Exp> <Power Exp> <Value> <Constant>
t: Integer NewLine ':' CLOSE '#' DATA DIM ID '(' ')' END FOR '=' TO STEP GOTO GOSUB IF THEN INPUT ',' LET NEXT OPEN AS POKE PRINT READ RETURN RESTORE RUN STOP SYS WAIT Remark OUTPUT ';' OR AND NOT '<>' '><' '>' '>=' '<' '<=' '+' '-' '*' '/' '^' String Real $e
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
16. <Statement> ::= LET ID '=' <Expression>
17. <Statement> ::= NEXT <ID List>
18. <Statement> ::= OPEN <Value> FOR <Access> AS '#' Integer
19. <Statement> ::= POKE <Value List>
20. <Statement> ::= PRINT <Print List>
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
31. <Access> ::= OUTPUT
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
<Statement> ::= . LET ID '=' <Expression>
<Statement> ::= . NEXT <ID List>
<Statement> ::= . OPEN <Value> FOR <Access> AS '#' Integer
<Statement> ::= . POKE <Value List>
<Statement> ::= . PRINT <Print List>
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
<Statement> ::= LET . ID '=' <Expression>
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
<Statement> ::= PRINT . <Print List>
<Statement> ::= PRINT . '#' Integer ',' <Print List>
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
<Statement> ::= . LET ID '=' <Expression>
<Statement> ::= . NEXT <ID List>
<Statement> ::= . OPEN <Value> FOR <Access> AS '#' Integer
<Statement> ::= . POKE <Value List>
<Statement> ::= . PRINT <Print List>
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
<Statement> ::= LET ID . '=' <Expression>
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
<Statement> ::= PRINT <Print List> .
---------- state 62 ----------
<Statement> ::= PRINT '#' . Integer ',' <Print List>
---------- state 63 ----------
<Print List> ::= <Expression> . ';' <Print List>
<Print List> ::= <Expression> .
---------- state 64 ----------
<Statement> ::= READ <ID List> .
---------- state 65 ----------
<Statement> ::= SYS <Value> .
---------- state 66 ----------
<Statement> ::= WAIT <Value List> .
---------- state 67 ----------
<Lines> ::= Integer <Statements> NewLine <Lines> .
---------- state 68 ----------
<Statements> ::= <Statement> ':' <Statements> .
---------- state 69 ----------
<Statement> ::= CLOSE '#' Integer .
---------- state 70 ----------
<Constant List> ::= <Constant> ',' . <Constant List>
<Constant List> ::= . <Constant> ',' <Constant List>
<Constant List> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 71 ----------
<Statement> ::= DIM ID '(' . <Integer List> ')'
<Integer List> ::= . Integer ',' <Integer List>
<Integer List> ::= . Integer
---------- state 72 ----------
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
---------- state 73 ----------
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
---------- state 74 ----------
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
---------- state 75 ----------
<Not Exp> ::= NOT <Compare Exp> .
---------- state 76 ----------
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
---------- state 77 ----------
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
---------- state 78 ----------
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
---------- state 79 ----------
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
---------- state 80 ----------
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
---------- state 81 ----------
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
---------- state 82 ----------
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
---------- state 83 ----------
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
---------- state 84 ----------
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
---------- state 85 ----------
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
---------- state 86 ----------
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
---------- state 87 ----------
<Negate Exp> ::= '-' <Power Exp> .
<Power Exp> ::= <Power Exp> . '^' <Value>
---------- state 88 ----------
<Power Exp> ::= <Power Exp> '^' . <Value>
<Value> ::= . '(' <Expression> ')'
<Value> ::= . ID
<Value> ::= . ID '(' <Expression List> ')'
<Value> ::= . <Constant>
<Constant> ::= . Integer
<Constant> ::= . String
<Constant> ::= . Real
---------- state 89 ----------
<Value> ::= '(' <Expression> . ')'
---------- state 90 ----------
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
---------- state 91 ----------
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
<Statement> ::= . LET ID '=' <Expression>
<Statement> ::= . NEXT <ID List>
<Statement> ::= . OPEN <Value> FOR <Access> AS '#' Integer
<Statement> ::= . POKE <Value List>
<Statement> ::= . PRINT <Print List>
<Statement> ::= . PRINT '#' Integer ',' <Print List>
<Statement> ::= . READ <ID List>
<Statement> ::= . RETURN
<Statement> ::= . RESTORE
<Statement> ::= . RUN
<Statement> ::= . STOP
<Statement> ::= . SYS <Value>
<Statement> ::= . WAIT <Value List>
<Statement> ::= . Remark
---------- state 92 ----------
<Statement> ::= INPUT '#' Integer . ',' <ID List>
---------- state 93 ----------
<ID List> ::= ID ',' . <ID List>
<ID List> ::= . ID ',' <ID List>
<ID List> ::= . ID
---------- state 94 ----------
<Statement> ::= LET ID '=' . <Expression>
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
---------- state 95 ----------
<Statement> ::= OPEN <Value> FOR . <Access> AS '#' Integer
<Access> ::= . INPUT
<Access> ::= . OUTPUT
---------- state 96 ----------
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
---------- state 97 ----------
<Statement> ::= PRINT '#' Integer . ',' <Print List>
---------- state 98 ----------
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
---------- state 99 ----------
<Constant List> ::= <Constant> ',' <Constant List> .
---------- state 100 ----------
<Statement> ::= DIM ID '(' <Integer List> . ')'
---------- state 101 ----------
<Integer List> ::= Integer . ',' <Integer List>
<Integer List> ::= Integer .
---------- state 102 ----------
<Statement> ::= FOR ID '=' <Expression> . TO <Expression>
<Statement> ::= FOR ID '=' <Expression> . TO <Expression> STEP Integer
---------- state 103 ----------
<Expression> ::= <And Exp> OR <Expression> .
---------- state 104 ----------
<And Exp> ::= <Not Exp> AND <And Exp> .
---------- state 105 ----------
<Compare Exp> ::= <Add Exp> '=' <Compare Exp> .
---------- state 106 ----------
<Compare Exp> ::= <Add Exp> '<>' <Compare Exp> .
---------- state 107 ----------
<Compare Exp> ::= <Add Exp> '><' <Compare Exp> .
---------- state 108 ----------
<Compare Exp> ::= <Add Exp> '>' <Compare Exp> .
---------- state 109 ----------
<Compare Exp> ::= <Add Exp> '>=' <Compare Exp> .
---------- state 110 ----------
<Compare Exp> ::= <Add Exp> '<' <Compare Exp> .
---------- state 111 ----------
<Compare Exp> ::= <Add Exp> '<=' <Compare Exp> .
---------- state 112 ----------
<Add Exp> ::= <Mult Exp> '+' <Add Exp> .
---------- state 113 ----------
<Add Exp> ::= <Mult Exp> '-' <Add Exp> .
---------- state 114 ----------
<Mult Exp> ::= <Negate Exp> '*' <Mult Exp> .
---------- state 115 ----------
<Mult Exp> ::= <Negate Exp> '/' <Mult Exp> .
---------- state 116 ----------
<Power Exp> ::= <Power Exp> '^' <Value> .
---------- state 117 ----------
<Value> ::= '(' <Expression> ')' .
---------- state 118 ----------
<Value> ::= ID '(' <Expression List> . ')'
---------- state 119 ----------
<Expression List> ::= <Expression> . ',' <Expression List>
<Expression List> ::= <Expression> .
---------- state 120 ----------
<Statement> ::= IF <Expression> THEN <Statement> .
---------- state 121 ----------
<Statement> ::= INPUT '#' Integer ',' . <ID List>
<ID List> ::= . ID ',' <ID List>
<ID List> ::= . ID
---------- state 122 ----------
<ID List> ::= ID ',' <ID List> .
---------- state 123 ----------
<Statement> ::= LET ID '=' <Expression> .
---------- state 124 ----------
<Statement> ::= OPEN <Value> FOR <Access> . AS '#' Integer
---------- state 125 ----------
<Access> ::= INPUT .
---------- state 126 ----------
<Access> ::= OUTPUT .
---------- state 127 ----------
<Value List> ::= <Value> ',' <Value List> .
---------- state 128 ----------
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
---------- state 129 ----------
<Print List> ::= <Expression> ';' <Print List> .
---------- state 130 ----------
<Statement> ::= DIM ID '(' <Integer List> ')' .
---------- state 131 ----------
<Integer List> ::= Integer ',' . <Integer List>
<Integer List> ::= . Integer ',' <Integer List>
<Integer List> ::= . Integer
---------- state 132 ----------
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
---------- state 133 ----------
<Value> ::= ID '(' <Expression List> ')' .
---------- state 134 ----------
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
---------- state 135 ----------
<Statement> ::= INPUT '#' Integer ',' <ID List> .
---------- state 136 ----------
<Statement> ::= OPEN <Value> FOR <Access> AS . '#' Integer
---------- state 137 ----------
<Statement> ::= PRINT '#' Integer ',' <Print List> .
---------- state 138 ----------
<Integer List> ::= Integer ',' <Integer List> .
---------- state 139 ----------
<Statement> ::= FOR ID '=' <Expression> TO <Expression> .
<Statement> ::= FOR ID '=' <Expression> TO <Expression> . STEP Integer
---------- state 140 ----------
<Expression List> ::= <Expression> ',' <Expression List> .
---------- state 141 ----------
<Statement> ::= OPEN <Value> FOR <Access> AS '#' . Integer
---------- state 142 ----------
<Statement> ::= FOR ID '=' <Expression> TO <Expression> STEP . Integer
---------- state 143 ----------
<Statement> ::= OPEN <Value> FOR <Access> AS '#' Integer .
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
    4 NewLine                0    0    4
    4 ':'                    1   28    3
    5 '#'                    1   29    5
    6 <Constant List>        2   30    6
    6 <Constant>             2   31   36
    6 Integer                1   32   73
    6 String                 1   33   74
    6 Real                   1   34   75
    7 ID                     1   35    7
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
   14 ID                     1   56   16
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
   18 ':'                    0    0   44
   18 NewLine                0    0   44
   18 <Print List>           2   61   20
   18 '#'                    1   62   21
   18 <Expression>           2   63   42
   18 <And Exp>              2   38   45
   18 <Not Exp>              2   39   47
   18 NOT                    1   40   49
   18 <Compare Exp>          2   41   50
   18 <Add Exp>              2   42   51
   18 <Mult Exp>             2   43   59
   18 <Negate Exp>           2   44   62
   18 '-'                    1   45   65
   18 <Power Exp>            2   46   66
   18 <Value>                2   47   68
   18 '('                    1   48   69
   18 ID                     1   49   70
   18 <Constant>             2   50   72
   18 Integer                1   32   73
   18 String                 1   33   74
   18 Real                   1   34   75
   19 <ID List>              2   64   22
   19 ID                     1   55   32
   20 ':'                    0    0   23
   20 NewLine                0    0   23
   21 ':'                    0    0   24
   21 NewLine                0    0   24
   22 ':'                    0    0   25
   22 NewLine                0    0   25
   23 ':'                    0    0   26
   23 NewLine                0    0   26
   24 <Value>                2   65   27
   24 '('                    1   48   69
   24 ID                     1   49   70
   24 <Constant>             2   50   72
   24 Integer                1   32   73
   24 String                 1   33   74
   24 Real                   1   34   75
   25 <Value List>           2   66   28
   25 <Value>                2   60   34
   25 '('                    1   48   69
   25 ID                     1   49   70
   25 <Constant>             2   50   72
   25 Integer                1   32   73
   25 String                 1   33   74
   25 Real                   1   34   75
   26 ':'                    0    0   29
   26 NewLine                0    0   29
   27 $e                     0    0    2
   27 <Lines>                2   67    1
   27 Integer                1    2    1
   28 <Statements>           2   68    3
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
   29 Integer                1   69    5
   30 ':'                    0    0    6
   30 NewLine                0    0    6
   31 ':'                    0    0   37
   31 NewLine                0    0   37
   31 ','                    1   70   36
   32 ','                    0    0   73
   32 ':'                    0    0   73
   32 NewLine                0    0   73
   32 FOR                    0    0   73
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
   32 '^'                    0    0   73
   32 ')'                    0    0   73
   33 ','                    0    0   74
   33 ':'                    0    0   74
   33 NewLine                0    0   74
   33 FOR                    0    0   74
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
   33 '^'                    0    0   74
   33 ')'                    0    0   74
   34 ','                    0    0   75
   34 ':'                    0    0   75
   34 NewLine                0    0   75
   34 FOR                    0    0   75
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
   34 '^'                    0    0   75
   34 ')'                    0    0   75
   35 '('                    1   71    7
   36 '='                    1   72    9
   37 ':'                    0    0   11
   37 NewLine                0    0   11
   38 TO                     0    0   46
   38 ':'                    0    0   46
   38 NewLine                0    0   46
   38 STEP                   0    0   46
   38 THEN                   0    0   46
   38 ','                    0    0   46
   38 ';'                    0    0   46
   38 ')'                    0    0   46
   38 OR                     1   73   45
   39 OR                     0    0   48
   39 TO                     0    0   48
   39 ':'                    0    0   48
   39 NewLine                0    0   48
   39 STEP                   0    0   48
   39 THEN                   0    0   48
   39 ','                    0    0   48
   39 ';'                    0    0   48
   39 ')'                    0    0   48
   39 AND                    1   74   47
   40 <Compare Exp>          2   75   49
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
   41 AND                    0    0   50
   41 OR                     0    0   50
   41 TO                     0    0   50
   41 ':'                    0    0   50
   41 NewLine                0    0   50
   41 STEP                   0    0   50
   41 THEN                   0    0   50
   41 ','                    0    0   50
   41 ';'                    0    0   50
   41 ')'                    0    0   50
   42 AND                    0    0   58
   42 OR                     0    0   58
   42 TO                     0    0   58
   42 ':'                    0    0   58
   42 NewLine                0    0   58
   42 STEP                   0    0   58
   42 THEN                   0    0   58
   42 ','                    0    0   58
   42 ';'                    0    0   58
   42 ')'                    0    0   58
   42 '='                    1   76   51
   42 '<>'                   1   77   52
   42 '><'                   1   78   53
   42 '>'                    1   79   54
   42 '>='                   1   80   55
   42 '<'                    1   81   56
   42 '<='                   1   82   57
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
   43 ':'                    0    0   61
   43 NewLine                0    0   61
   43 STEP                   0    0   61
   43 THEN                   0    0   61
   43 ','                    0    0   61
   43 ';'                    0    0   61
   43 ')'                    0    0   61
   43 '+'                    1   83   59
   43 '-'                    1   84   60
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
   44 ':'                    0    0   64
   44 NewLine                0    0   64
   44 STEP                   0    0   64
   44 THEN                   0    0   64
   44 ','                    0    0   64
   44 ';'                    0    0   64
   44 ')'                    0    0   64
   44 '*'                    1   85   62
   44 '/'                    1   86   63
   45 <Power Exp>            2   87   65
   45 <Value>                2   47   68
   45 '('                    1   48   69
   45 ID                     1   49   70
   45 <Constant>             2   50   72
   45 Integer                1   32   73
   45 String                 1   33   74
   45 Real                   1   34   75
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
   46 ':'                    0    0   66
   46 NewLine                0    0   66
   46 STEP                   0    0   66
   46 THEN                   0    0   66
   46 ','                    0    0   66
   46 ';'                    0    0   66
   46 ')'                    0    0   66
   46 '^'                    1   88   67
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
   47 ':'                    0    0   68
   47 NewLine                0    0   68
   47 STEP                   0    0   68
   47 THEN                   0    0   68
   47 ','                    0    0   68
   47 ';'                    0    0   68
   47 '^'                    0    0   68
   47 ')'                    0    0   68
   48 <Expression>           2   89   69
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
   49 FOR                    0    0   70
   49 ':'                    0    0   70
   49 NewLine                0    0   70
   49 ','                    0    0   70
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
   49 '^'                    0    0   70
   49 ')'                    0    0   70
   49 '('                    1   90   71
   50 FOR                    0    0   72
   50 ':'                    0    0   72
   50 NewLine                0    0   72
   50 ','                    0    0   72
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
   50 '^'                    0    0   72
   50 ')'                    0    0   72
   51 ':'                    0    0   12
   51 NewLine                0    0   12
   52 THEN                   1   91   13
   53 ':'                    0    0   14
   53 NewLine                0    0   14
   54 Integer                1   92   15
   55 ':'                    0    0   33
   55 NewLine                0    0   33
   55 ','                    1   93   32
   56 '='                    1   94   16
   57 ':'                    0    0   17
   57 NewLine                0    0   17
   58 FOR                    1   95   18
   59 ':'                    0    0   19
   59 NewLine                0    0   19
   60 ':'                    0    0   35
   60 NewLine                0    0   35
   60 ','                    1   96   34
   61 ':'                    0    0   20
   61 NewLine                0    0   20
   62 Integer                1   97   21
   63 ':'                    0    0   43
   63 NewLine                0    0   43
   63 ';'                    1   98   42
   64 ':'                    0    0   22
   64 NewLine                0    0   22
   65 ':'                    0    0   27
   65 NewLine                0    0   27
   66 ':'                    0    0   28
   66 NewLine                0    0   28
   67 $e                     0    0    1
   68 NewLine                0    0    3
   69 ':'                    0    0    5
   69 NewLine                0    0    5
   70 <Constant List>        2   99   36
   70 <Constant>             2   31   36
   70 Integer                1   32   73
   70 String                 1   33   74
   70 Real                   1   34   75
   71 <Integer List>         2  100    7
   71 Integer                1  101   38
   72 <Expression>           2  102    9
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
   73 <Expression>           2  103   45
   73 <And Exp>              2   38   45
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
   74 <And Exp>              2  104   47
   74 <Not Exp>              2   39   47
   74 NOT                    1   40   49
   74 <Compare Exp>          2   41   50
   74 <Add Exp>              2   42   51
   74 <Mult Exp>             2   43   59
   74 <Negate Exp>           2   44   62
   74 '-'                    1   45   65
   74 <Power Exp>            2   46   66
   74 <Value>                2   47   68
   74 '('                    1   48   69
   74 ID                     1   49   70
   74 <Constant>             2   50   72
   74 Integer                1   32   73
   74 String                 1   33   74
   74 Real                   1   34   75
   75 AND                    0    0   49
   75 OR                     0    0   49
   75 TO                     0    0   49
   75 ':'                    0    0   49
   75 NewLine                0    0   49
   75 STEP                   0    0   49
   75 THEN                   0    0   49
   75 ','                    0    0   49
   75 ';'                    0    0   49
   75 ')'                    0    0   49
   76 <Compare Exp>          2  105   51
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
   77 <Compare Exp>          2  106   52
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
   78 <Compare Exp>          2  107   53
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
   79 <Compare Exp>          2  108   54
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
   80 <Compare Exp>          2  109   55
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
   81 <Compare Exp>          2  110   56
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
   82 <Compare Exp>          2  111   57
   82 <Add Exp>              2   42   51
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
   83 <Add Exp>              2  112   59
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
   84 <Add Exp>              2  113   60
   84 <Mult Exp>             2   43   59
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
   85 <Mult Exp>             2  114   62
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
   86 <Mult Exp>             2  115   63
   86 <Negate Exp>           2   44   62
   86 '-'                    1   45   65
   86 <Power Exp>            2   46   66
   86 <Value>                2   47   68
   86 '('                    1   48   69
   86 ID                     1   49   70
   86 <Constant>             2   50   72
   86 Integer                1   32   73
   86 String                 1   33   74
   86 Real                   1   34   75
   87 '*'                    0    0   65
   87 '/'                    0    0   65
   87 '+'                    0    0   65
   87 '-'                    0    0   65
   87 '='                    0    0   65
   87 '<>'                   0    0   65
   87 '><'                   0    0   65
   87 '>'                    0    0   65
   87 '>='                   0    0   65
   87 '<'                    0    0   65
   87 '<='                   0    0   65
   87 AND                    0    0   65
   87 OR                     0    0   65
   87 TO                     0    0   65
   87 ':'                    0    0   65
   87 NewLine                0    0   65
   87 STEP                   0    0   65
   87 THEN                   0    0   65
   87 ','                    0    0   65
   87 ';'                    0    0   65
   87 ')'                    0    0   65
   87 '^'                    1   88   67
   88 <Value>                2  116   67
   88 '('                    1   48   69
   88 ID                     1   49   70
   88 <Constant>             2   50   72
   88 Integer                1   32   73
   88 String                 1   33   74
   88 Real                   1   34   75
   89 ')'                    1  117   69
   90 <Expression List>      2  118   71
   90 <Expression>           2  119   40
   90 <And Exp>              2   38   45
   90 <Not Exp>              2   39   47
   90 NOT                    1   40   49
   90 <Compare Exp>          2   41   50
   90 <Add Exp>              2   42   51
   90 <Mult Exp>             2   43   59
   90 <Negate Exp>           2   44   62
   90 '-'                    1   45   65
   90 <Power Exp>            2   46   66
   90 <Value>                2   47   68
   90 '('                    1   48   69
   90 ID                     1   49   70
   90 <Constant>             2   50   72
   90 Integer                1   32   73
   90 String                 1   33   74
   90 Real                   1   34   75
   91 <Statement>            2  120   13
   91 CLOSE                  1    5    5
   91 DATA                   1    6    6
   91 DIM                    1    7    7
   91 END                    1    8    8
   91 FOR                    1    9    9
   91 GOTO                   1   10   11
   91 GOSUB                  1   11   12
   91 IF                     1   12   13
   91 INPUT                  1   13   14
   91 LET                    1   14   16
   91 NEXT                   1   15   17
   91 OPEN                   1   16   18
   91 POKE                   1   17   19
   91 PRINT                  1   18   20
   91 READ                   1   19   22
   91 RETURN                 1   20   23
   91 RESTORE                1   21   24
   91 RUN                    1   22   25
   91 STOP                   1   23   26
   91 SYS                    1   24   27
   91 WAIT                   1   25   28
   91 Remark                 1   26   29
   92 ','                    1  121   15
   93 <ID List>              2  122   32
   93 ID                     1   55   32
   94 <Expression>           2  123   16
   94 <And Exp>              2   38   45
   94 <Not Exp>              2   39   47
   94 NOT                    1   40   49
   94 <Compare Exp>          2   41   50
   94 <Add Exp>              2   42   51
   94 <Mult Exp>             2   43   59
   94 <Negate Exp>           2   44   62
   94 '-'                    1   45   65
   94 <Power Exp>            2   46   66
   94 <Value>                2   47   68
   94 '('                    1   48   69
   94 ID                     1   49   70
   94 <Constant>             2   50   72
   94 Integer                1   32   73
   94 String                 1   33   74
   94 Real                   1   34   75
   95 <Access>               2  124   18
   95 INPUT                  1  125   30
   95 OUTPUT                 1  126   31
   96 <Value List>           2  127   34
   96 <Value>                2   60   34
   96 '('                    1   48   69
   96 ID                     1   49   70
   96 <Constant>             2   50   72
   96 Integer                1   32   73
   96 String                 1   33   74
   96 Real                   1   34   75
   97 ','                    1  128   21
   98 ':'                    0    0   44
   98 NewLine                0    0   44
   98 <Print List>           2  129   42
   98 <Expression>           2   63   42
   98 <And Exp>              2   38   45
   98 <Not Exp>              2   39   47
   98 NOT                    1   40   49
   98 <Compare Exp>          2   41   50
   98 <Add Exp>              2   42   51
   98 <Mult Exp>             2   43   59
   98 <Negate Exp>           2   44   62
   98 '-'                    1   45   65
   98 <Power Exp>            2   46   66
   98 <Value>                2   47   68
   98 '('                    1   48   69
   98 ID                     1   49   70
   98 <Constant>             2   50   72
   98 Integer                1   32   73
   98 String                 1   33   74
   98 Real                   1   34   75
   99 ':'                    0    0   36
   99 NewLine                0    0   36
  100 ')'                    1  130    7
  101 ')'                    0    0   39
  101 ','                    1  131   38
  102 TO                     1  132    9
  103 TO                     0    0   45
  103 ':'                    0    0   45
  103 NewLine                0    0   45
  103 STEP                   0    0   45
  103 THEN                   0    0   45
  103 ','                    0    0   45
  103 ';'                    0    0   45
  103 ')'                    0    0   45
  104 OR                     0    0   47
  104 TO                     0    0   47
  104 ':'                    0    0   47
  104 NewLine                0    0   47
  104 STEP                   0    0   47
  104 THEN                   0    0   47
  104 ','                    0    0   47
  104 ';'                    0    0   47
  104 ')'                    0    0   47
  105 AND                    0    0   51
  105 OR                     0    0   51
  105 TO                     0    0   51
  105 ':'                    0    0   51
  105 NewLine                0    0   51
  105 STEP                   0    0   51
  105 THEN                   0    0   51
  105 ','                    0    0   51
  105 ';'                    0    0   51
  105 ')'                    0    0   51
  106 AND                    0    0   52
  106 OR                     0    0   52
  106 TO                     0    0   52
  106 ':'                    0    0   52
  106 NewLine                0    0   52
  106 STEP                   0    0   52
  106 THEN                   0    0   52
  106 ','                    0    0   52
  106 ';'                    0    0   52
  106 ')'                    0    0   52
  107 AND                    0    0   53
  107 OR                     0    0   53
  107 TO                     0    0   53
  107 ':'                    0    0   53
  107 NewLine                0    0   53
  107 STEP                   0    0   53
  107 THEN                   0    0   53
  107 ','                    0    0   53
  107 ';'                    0    0   53
  107 ')'                    0    0   53
  108 AND                    0    0   54
  108 OR                     0    0   54
  108 TO                     0    0   54
  108 ':'                    0    0   54
  108 NewLine                0    0   54
  108 STEP                   0    0   54
  108 THEN                   0    0   54
  108 ','                    0    0   54
  108 ';'                    0    0   54
  108 ')'                    0    0   54
  109 AND                    0    0   55
  109 OR                     0    0   55
  109 TO                     0    0   55
  109 ':'                    0    0   55
  109 NewLine                0    0   55
  109 STEP                   0    0   55
  109 THEN                   0    0   55
  109 ','                    0    0   55
  109 ';'                    0    0   55
  109 ')'                    0    0   55
  110 AND                    0    0   56
  110 OR                     0    0   56
  110 TO                     0    0   56
  110 ':'                    0    0   56
  110 NewLine                0    0   56
  110 STEP                   0    0   56
  110 THEN                   0    0   56
  110 ','                    0    0   56
  110 ';'                    0    0   56
  110 ')'                    0    0   56
  111 AND                    0    0   57
  111 OR                     0    0   57
  111 TO                     0    0   57
  111 ':'                    0    0   57
  111 NewLine                0    0   57
  111 STEP                   0    0   57
  111 THEN                   0    0   57
  111 ','                    0    0   57
  111 ';'                    0    0   57
  111 ')'                    0    0   57
  112 '='                    0    0   59
  112 '<>'                   0    0   59
  112 '><'                   0    0   59
  112 '>'                    0    0   59
  112 '>='                   0    0   59
  112 '<'                    0    0   59
  112 '<='                   0    0   59
  112 AND                    0    0   59
  112 OR                     0    0   59
  112 TO                     0    0   59
  112 ':'                    0    0   59
  112 NewLine                0    0   59
  112 STEP                   0    0   59
  112 THEN                   0    0   59
  112 ','                    0    0   59
  112 ';'                    0    0   59
  112 ')'                    0    0   59
  113 '='                    0    0   60
  113 '<>'                   0    0   60
  113 '><'                   0    0   60
  113 '>'                    0    0   60
  113 '>='                   0    0   60
  113 '<'                    0    0   60
  113 '<='                   0    0   60
  113 AND                    0    0   60
  113 OR                     0    0   60
  113 TO                     0    0   60
  113 ':'                    0    0   60
  113 NewLine                0    0   60
  113 STEP                   0    0   60
  113 THEN                   0    0   60
  113 ','                    0    0   60
  113 ';'                    0    0   60
  113 ')'                    0    0   60
  114 '+'                    0    0   62
  114 '-'                    0    0   62
  114 '='                    0    0   62
  114 '<>'                   0    0   62
  114 '><'                   0    0   62
  114 '>'                    0    0   62
  114 '>='                   0    0   62
  114 '<'                    0    0   62
  114 '<='                   0    0   62
  114 AND                    0    0   62
  114 OR                     0    0   62
  114 TO                     0    0   62
  114 ':'                    0    0   62
  114 NewLine                0    0   62
  114 STEP                   0    0   62
  114 THEN                   0    0   62
  114 ','                    0    0   62
  114 ';'                    0    0   62
  114 ')'                    0    0   62
  115 '+'                    0    0   63
  115 '-'                    0    0   63
  115 '='                    0    0   63
  115 '<>'                   0    0   63
  115 '><'                   0    0   63
  115 '>'                    0    0   63
  115 '>='                   0    0   63
  115 '<'                    0    0   63
  115 '<='                   0    0   63
  115 AND                    0    0   63
  115 OR                     0    0   63
  115 TO                     0    0   63
  115 ':'                    0    0   63
  115 NewLine                0    0   63
  115 STEP                   0    0   63
  115 THEN                   0    0   63
  115 ','                    0    0   63
  115 ';'                    0    0   63
  115 ')'                    0    0   63
  116 '*'                    0    0   67
  116 '/'                    0    0   67
  116 '+'                    0    0   67
  116 '-'                    0    0   67
  116 '='                    0    0   67
  116 '<>'                   0    0   67
  116 '><'                   0    0   67
  116 '>'                    0    0   67
  116 '>='                   0    0   67
  116 '<'                    0    0   67
  116 '<='                   0    0   67
  116 AND                    0    0   67
  116 OR                     0    0   67
  116 TO                     0    0   67
  116 ':'                    0    0   67
  116 NewLine                0    0   67
  116 STEP                   0    0   67
  116 THEN                   0    0   67
  116 ','                    0    0   67
  116 ';'                    0    0   67
  116 '^'                    0    0   67
  116 ')'                    0    0   67
  117 FOR                    0    0   69
  117 ':'                    0    0   69
  117 NewLine                0    0   69
  117 ','                    0    0   69
  117 '*'                    0    0   69
  117 '/'                    0    0   69
  117 '+'                    0    0   69
  117 '-'                    0    0   69
  117 '='                    0    0   69
  117 '<>'                   0    0   69
  117 '><'                   0    0   69
  117 '>'                    0    0   69
  117 '>='                   0    0   69
  117 '<'                    0    0   69
  117 '<='                   0    0   69
  117 AND                    0    0   69
  117 OR                     0    0   69
  117 TO                     0    0   69
  117 STEP                   0    0   69
  117 THEN                   0    0   69
  117 ';'                    0    0   69
  117 '^'                    0    0   69
  117 ')'                    0    0   69
  118 ')'                    1  133   71
  119 ')'                    0    0   41
  119 ','                    1  134   40
  120 ':'                    0    0   13
  120 NewLine                0    0   13
  121 <ID List>              2  135   15
  121 ID                     1   55   32
  122 ':'                    0    0   32
  122 NewLine                0    0   32
  123 ':'                    0    0   16
  123 NewLine                0    0   16
  124 AS                     1  136   18
  125 AS                     0    0   30
  126 AS                     0    0   31
  127 ':'                    0    0   34
  127 NewLine                0    0   34
  128 ':'                    0    0   44
  128 NewLine                0    0   44
  128 <Print List>           2  137   21
  128 <Expression>           2   63   42
  128 <And Exp>              2   38   45
  128 <Not Exp>              2   39   47
  128 NOT                    1   40   49
  128 <Compare Exp>          2   41   50
  128 <Add Exp>              2   42   51
  128 <Mult Exp>             2   43   59
  128 <Negate Exp>           2   44   62
  128 '-'                    1   45   65
  128 <Power Exp>            2   46   66
  128 <Value>                2   47   68
  128 '('                    1   48   69
  128 ID                     1   49   70
  128 <Constant>             2   50   72
  128 Integer                1   32   73
  128 String                 1   33   74
  128 Real                   1   34   75
  129 ':'                    0    0   42
  129 NewLine                0    0   42
  130 ':'                    0    0    7
  130 NewLine                0    0    7
  131 <Integer List>         2  138   38
  131 Integer                1  101   38
  132 <Expression>           2  139    9
  132 <And Exp>              2   38   45
  132 <Not Exp>              2   39   47
  132 NOT                    1   40   49
  132 <Compare Exp>          2   41   50
  132 <Add Exp>              2   42   51
  132 <Mult Exp>             2   43   59
  132 <Negate Exp>           2   44   62
  132 '-'                    1   45   65
  132 <Power Exp>            2   46   66
  132 <Value>                2   47   68
  132 '('                    1   48   69
  132 ID                     1   49   70
  132 <Constant>             2   50   72
  132 Integer                1   32   73
  132 String                 1   33   74
  132 Real                   1   34   75
  133 FOR                    0    0   71
  133 ':'                    0    0   71
  133 NewLine                0    0   71
  133 ','                    0    0   71
  133 '*'                    0    0   71
  133 '/'                    0    0   71
  133 '+'                    0    0   71
  133 '-'                    0    0   71
  133 '='                    0    0   71
  133 '<>'                   0    0   71
  133 '><'                   0    0   71
  133 '>'                    0    0   71
  133 '>='                   0    0   71
  133 '<'                    0    0   71
  133 '<='                   0    0   71
  133 AND                    0    0   71
  133 OR                     0    0   71
  133 TO                     0    0   71
  133 STEP                   0    0   71
  133 THEN                   0    0   71
  133 ';'                    0    0   71
  133 '^'                    0    0   71
  133 ')'                    0    0   71
  134 <Expression List>      2  140   40
  134 <Expression>           2  119   40
  134 <And Exp>              2   38   45
  134 <Not Exp>              2   39   47
  134 NOT                    1   40   49
  134 <Compare Exp>          2   41   50
  134 <Add Exp>              2   42   51
  134 <Mult Exp>             2   43   59
  134 <Negate Exp>           2   44   62
  134 '-'                    1   45   65
  134 <Power Exp>            2   46   66
  134 <Value>                2   47   68
  134 '('                    1   48   69
  134 ID                     1   49   70
  134 <Constant>             2   50   72
  134 Integer                1   32   73
  134 String                 1   33   74
  134 Real                   1   34   75
  135 ':'                    0    0   15
  135 NewLine                0    0   15
  136 '#'                    1  141   18
  137 ':'                    0    0   21
  137 NewLine                0    0   21
  138 ')'                    0    0   38
  139 ':'                    0    0    9
  139 NewLine                0    0    9
  139 STEP                   1  142   10
  140 ')'                    0    0   40
  141 Integer                1  143   18
  142 Integer                1  144   10
  143 ':'                    0    0   18
  143 NewLine                0    0   18
  144 ':'                    0    0   10
  144 NewLine                0    0   10
