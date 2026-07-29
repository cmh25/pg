@echo off
if "%1%"=="test" goto test
if "%1%"=="ex" goto ex 
cl main.c pg.c show.c /Fe:pg || exit /b 1
exit /b 0
:test
cl main.c pg.c show.c /Fe:pg || exit /b 1
set failed=0
cd test
echo slr:
call test.bat slr || set failed=1
echo slr eunitr:
call test.bat slr eunitr || set failed=1
echo lr1:
call test.bat lr1 || set failed=1
echo lalr:
call test.bat lalr || set failed=1
echo lr0:
call test.bat lr0 || set failed=1
echo ll1:
call test.bat ll1 || set failed=1
cd ..
echo behavior:
cl /nologo test\behavior.c /Fe:test\behavior.exe /Fo:test\behavior.obj
if errorlevel 1 (
  set failed=1
) else (
  test\behavior.exe || set failed=1
)
exit /b %failed%
:ex
cd ex
call make.bat
set status=%errorlevel%
cd ..
exit /b %status%
