@echo off

pushd 000
cl main.c p.c /Fe:p
if errorlevel 1 (popd & exit /b 1)
popd

pushd 000.eunitr
cl main.c p.c /Fe:p
if errorlevel 1 (popd & exit /b 1)
popd

pushd 021.ll1
cl main.c p.c /Fe:p
if errorlevel 1 (popd & exit /b 1)
popd

pushd 022.ll1
cl main.c p.c /Fe:p
if errorlevel 1 (popd & exit /b 1)
popd

exit /b 0
