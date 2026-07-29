@echo off
setlocal

set "mode=%~1"
set "extra=%~2"
set "failed=0"
set "list=tests.%mode%%extra%"

if not exist "%list%" (
  echo error: test list not found: %list% 1>&2
  exit /b 1
)

for /f "usebackq tokens=*" %%t in ("%list%") do call :run "%%t"
exit /b %failed%

:run
set "grammar=%~1"
if "%grammar%"=="" exit /b 0

if "%extra%"=="" (
  ..\pg "%grammar%" printstates "%mode%" >"%grammar%.%mode%.out"
) else (
  ..\pg "%grammar%" printstates "%mode%" "%extra%" >"%grammar%.%mode%%extra%.out"
)
if errorlevel 1 (
  echo %grammar%: fail ***** ^(generator^)
  set "failed=1"
  exit /b 0
)

comp /a /l /m "%grammar%.%mode%%extra%.res" "%grammar%.%mode%%extra%.out" >NUL
if errorlevel 1 (
  echo %grammar%: fail *****
  set "failed=1"
) else (
  echo %grammar%: pass
  del "%grammar%.%mode%%extra%.out"
)
exit /b 0
