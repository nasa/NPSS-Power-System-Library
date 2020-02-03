@echo off

pushd %~dp0
cd ..

for %%f in (%CD%\run\*.run) do (
    echo.
    echo ========================== %%~nf ========================== 
    call runnpss -I model -I run -I src -I view %%~f
)

popd