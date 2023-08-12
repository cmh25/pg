@echo off
if "%1%"=="test" goto test
if "%1%"=="ex" goto ex 
cl main.c pg.c show.c /Fe:pg
exit /b 0
:test
pg test\000 > test\000.out
pg test\001 > test\001.out
pg test\002 > test\002.out
pg test\003 > test\003.out
pg test\004 > test\004.out
pg test\005 > test\005.out
pg test\006 > test\006.out
pg test\007 > test\007.out
pg test\008 > test\008.out
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
exit /b 0
:ex
cd ex
cd 000; cl main.c p.c /Fe:p cd ..
cd ..
