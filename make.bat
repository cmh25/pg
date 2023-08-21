@echo off
if "%1%"=="test" goto test
if "%1%"=="ex" goto ex 
cl main.c pg.c show.c /Fe:pg
exit /b 0
:test
pg test\000 printstates > test\000.out
pg test\001 printstates > test\001.out
pg test\002 printstates > test\002.out
pg test\003 printstates > test\003.out
pg test\004 printstates > test\004.out
pg test\005 printstates > test\005.out
pg test\006 printstates > test\006.out
pg test\007 printstates > test\007.out
pg test\008 printstates > test\008.out
pg test\009 printstates > test\009.out
pg test\010 printstates > test\010.out
pg test\011 printstates > test\011.out
pg test\012 printstates > test\012.out
pg test\013 printstates > test\013.out
comp /a /m test\000.res test\000.out >NUL
if "%errorlevel%"=="0" (echo 000: pass) else echo 000: fail *****
comp /a /m test\001.res test\001.out >NUL
if "%errorlevel%"=="0" (echo 001: pass) else echo 001: fail *****
comp /a /m test\002.res test\002.out >NUL
if "%errorlevel%"=="0" (echo 002: pass) else echo 002: fail *****
comp /a /m test\003.res test\003.out >NUL
if "%errorlevel%"=="0" (echo 003: pass) else echo 003: fail *****
comp /a /m test\004.res test\004.out >NUL
if "%errorlevel%"=="0" (echo 004: pass) else echo 004: fail *****
comp /a /m test\005.res test\005.out >NUL
if "%errorlevel%"=="0" (echo 005: pass) else echo 005: fail *****
comp /a /m test\006.res test\006.out >NUL
if "%errorlevel%"=="0" (echo 006: pass) else echo 006: fail *****
comp /a /m test\007.res test\007.out >NUL
if "%errorlevel%"=="0" (echo 007: pass) else echo 007: fail *****
comp /a /m test\008.res test\008.out >NUL
if "%errorlevel%"=="0" (echo 008: pass) else echo 008: fail *****
comp /a /m test\009.res test\009.out >NUL
if "%errorlevel%"=="0" (echo 009: pass) else echo 009: fail *****
comp /a /m test\010.res test\010.out >NUL
if "%errorlevel%"=="0" (echo 010: pass) else echo 010: fail *****
comp /a /m test\011.res test\011.out >NUL
if "%errorlevel%"=="0" (echo 011: pass) else echo 011: fail *****
comp /a /m test\012.res test\012.out >NUL
if "%errorlevel%"=="0" (echo 012: pass) else echo 012: fail *****
comp /a /m test\013.res test\013.out >NUL
if "%errorlevel%"=="0" (echo 013: pass) else echo 013: fail *****
pg test\000 printstates eunitr > test\000.eunitr.out
pg test\012 printstates eunitr > test\012.eunitr.out
pg test\013 printstates eunitr > test\013.eunitr.out
comp /a /m test\000.eunitr.res test\000.eunitr.out >NUL
if "%errorlevel%"=="0" (echo 000: pass) else echo 000: fail *****
comp /a /m test\012.eunitr.res test\012.eunitr.out >NUL
if "%errorlevel%"=="0" (echo 012: pass) else echo 012: fail *****
comp /a /m test\013.eunitr.res test\013.eunitr.out >NUL
if "%errorlevel%"=="0" (echo 013: pass) else echo 013: fail *****
exit /b 0
:ex
cd ex
cd 000 & cl main.c p.c /Fe:p & cd ..
cd 000.eunitr & cl main.c p.c /Fe:p & cd ..
cd ..
