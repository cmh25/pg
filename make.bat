@echo off
if "%1%"=="test" goto test
cl main.c pg.c show.c /Fe:pg
exit /b 0
:test
pg test\000 > test\000.out
pg test\001 > test\001.out
pg test\002 > test\002.out
pg test\003 > test\003.out
pg test\004 > test\004.out
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