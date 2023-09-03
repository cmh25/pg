@echo off
for /f "tokens=*" %%t in (tests) do call :run %%t
:run
if "%1"=="" goto end
..\pg %1 printstates > %1.out
comp /a /l /m %1.res %1.out >NUL
if "%errorlevel%"=="0" (echo %1: pass) else echo %1: fail *****
:end