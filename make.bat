@echo off
if "%1%"=="test" goto test
if "%1%"=="ex" goto ex 
cl main.c pg.c show.c /Fe:pg
exit /b 0
:test
cd test
echo slr
cmd /c test.bat slr
echo eunitr:
cmd /c test.bat slr eunitr
echo lr1:
cmd /c test.bat lr1
echo lalr:
cmd /c test.bat lalr
cd ..
exit /b 0
:ex
cd ex
cmd /c make.bat
cd ..
