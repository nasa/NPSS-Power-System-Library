@echo off
:: -----------------------------------------------------------------------------
:: |                                                                           |
:: | File Name:     runnpss-psl.bat                                            |
:: | Author(s):     Jonathan Fuzaro Alencar                                    |
:: | Date(s):       February 2020                                              |
:: |                                                                           |
:: | Description:   Batch script to run NPSS PSL files.                        |
:: |                                                                           |
:: -----------------------------------------------------------------------------

:: If no argument, run all the models.
if "%~1" == "" goto RunAll

:: Else, echo back which model you are running, and run it.
echo.
echo =========== %~n1 ===========
echo.

call runnpss -I src -I include -I model -I view -I utils -iclodfirst %1
goto Done

:: You got down here, so run all models in the model folder.
:RunAll

for %%i in (run\*) do (call runnpss -I src -I include -I model -I view -I utils -iclodfirst %%i )
echo Finished running all models
:Done
