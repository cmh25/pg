@echo off
setlocal EnableExtensions

set "failed=0"
set "base=%TEMP%\pg-ex-test-%RANDOM%-%RANDOM%"
set "lr_input=%base%-lr.in"
set "ll_input=%base%-ll.in"
set "lr_expected=%base%-lr.expected"
set "ll_expected=%base%-ll.expected"
set "flat_expected=%base%-flat.expected"
set "actual=%base%-actual"
set "normalized=%base%-normalized"

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

>"%lr_expected%" echo 2
>>"%lr_expected%" echo 5
>>"%lr_expected%" echo 10
>>"%lr_expected%" echo 14
>>"%lr_expected%" echo 20
>>"%lr_expected%" echo 2

>"%ll_expected%" echo 14
>>"%ll_expected%" echo 10
>>"%ll_expected%" echo 20
>>"%ll_expected%" echo 6
>>"%ll_expected%" echo 4
>>"%ll_expected%" echo 2
>>"%ll_expected%" echo 7
>>"%ll_expected%" echo 10

>"%flat_expected%" echo 14
>>"%flat_expected%" echo 14
>>"%flat_expected%" echo 20
>>"%flat_expected%" echo 6
>>"%flat_expected%" echo 4
>>"%flat_expected%" echo 2
>>"%flat_expected%" echo 7
>>"%flat_expected%" echo 10

call :check 000 "%lr_input%" "%lr_expected%"
call :check 000.eunitr "%lr_input%" "%lr_expected%"
call :check 021.ll1 "%ll_input%" "%ll_expected%"
call :check 022.ll1 "%ll_input%" "%flat_expected%"

call :cleanup
exit /b %failed%

:check
"%~1\p.exe" <"%~2" >"%actual%"
if errorlevel 1 (
  echo %~1: fail ^(program^)
  set "failed=1"
  exit /b 0
)

>"%normalized%" (
  for /f "usebackq tokens=*" %%L in ("%actual%") do echo %%L
)

fc /b "%~3" "%normalized%" >NUL
if errorlevel 1 (
  echo %~1: fail
  echo expected:
  type "%~3"
  echo actual:
  type "%normalized%"
  set "failed=1"
) else (
  echo %~1: pass
)
exit /b 0

:cleanup
del /q "%lr_input%" "%ll_input%" "%lr_expected%" "%ll_expected%" >NUL 2>&1
del /q "%flat_expected%" "%actual%" "%normalized%" >NUL 2>&1
exit /b 0
