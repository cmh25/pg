@echo off
if "%1%"=="test" goto test
if "%1%"=="ex" goto ex 
cl main.c pg.c show.c /Fe:pg
exit /b 0
:test
cd test
cmd /c test.bat
cd ..
echo eunitr:
cd test
cmd /c testeunitr.bat
cd ..
exit /b 0
:ex
cd ex
cmd /c make.bat
cd ..
