@echo off
for /f "tokens=*" %%t in (tests.%1%2) do call :run %%t %1 %2
:run
if "%1"=="" goto end
if "%2"=="" goto end
if "%2"=="eunitr" if "%3"=="" goto end
::if "%3"=="" goto end
..\pg %1 %2 %3 printstates > %1.%2%3.out
comp /a /l /m %1.%2%3.res %1.%2%3.out >NUL
if "%errorlevel%"=="0" (echo %1: pass) else echo %1: fail *****
:end