@echo off
setlocal EnableExtensions

set "failed=0"
set "base=%TEMP%\pg-ex-test-%RANDOM%-%RANDOM%"
set "lr_input=%base%-lr.in"
set "ll_input=%base%-ll.in"
set "actual=%base%-actual"

>"%lr_input%" echo 2
>>"%lr_input%" echo 2+3
>>"%lr_input%" echo 2*3+4
>>"%lr_input%" echo 2+3*4
>>"%lr_input%" echo ^(2+3^)*4
>>"%lr_input%" echo ^(^(2^)^)

>"%ll_input%" echo 2+3*4
>>"%ll_input%" echo 2*3+4
>>"%ll_input%" echo ^(2+3^)*4
>>"%ll_input%" echo 8-2
>>"%ll_input%" echo 8/2
>>"%ll_input%" echo -3+5
>>"%ll_input%" echo 8-2-1
>>"%ll_input%" echo 20/5/2

call :check 000 "%lr_input%" ",2,5,10,14,20,2"
call :check 000.eunitr "%lr_input%" ",2,5,10,14,20,2"
call :check 021.ll1 "%ll_input%" ",14,10,20,6,4,2,7,10"
call :check 022.ll1 "%ll_input%" ",14,14,20,6,4,2,7,10"

call :cleanup
exit /b %failed%

:check
"%~1\p.exe" <"%~2" >"%actual%"
if errorlevel 1 (
  echo %~1: fail ^(program^)
  set "failed=1"
  exit /b 0
)

set "actual_values="
for /f "usebackq tokens=*" %%L in ("%actual%") do call :append "%%L"
if not "%actual_values%"=="%~3" (
  echo %~1: fail
  echo expected: %~3
  echo actual:   %actual_values%
  set "failed=1"
) else (
  echo %~1: pass
)
exit /b 0

:append
set "actual_values=%actual_values%,%~1"
exit /b 0

:cleanup
del /q "%lr_input%" "%ll_input%" "%actual%" >NUL 2>&1
exit /b 0
