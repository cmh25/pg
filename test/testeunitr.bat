@echo off
for /f "tokens=*" %%t in (testseunitr) do call :run %%t
:run
if "%1"=="" goto end
..\pg %1 printstates eunitr > %1.eunitr.out
comp /a /l /m %1.eunitr.res %1.eunitr.out >NUL
if "%errorlevel%"=="0" (echo %1: pass) else echo %1: fail *****
:end
