@echo off
:: -----------------------------------------------------------------------------
:: |                                                                           |
:: | File Name:     runnpss-psl.bat                                            |
:: | Author(s):     Michael Stich                                              |
:: | Date(s):       March 2023                                                 |
:: |                                                                           |
:: | Description:   Batch script to run NPSS Test files.                       |
:: |                                                                           |
:: -----------------------------------------------------------------------------

:: If no argument, run all the models.
if "%~1" == "" goto RunAll

:: Else, echo back which model you are running, and run it.
echo.
echo =========== %~n1 ===========
echo.

call runnpss -I src -I include -I view -I utils -I test -iclodfirst %1
goto Done

:: You got down here, so run all models in the model folder.
:RunAll
set /p=You are running testnpss.bat without an argument. This will run all models in test file. Hit ENTER to run first model
for %%i in (test\test_run\*) do (call runnpss -I src -I include -I model -I view -I utils -I test -iclodfirst %%i & set /p=Finished %%i, Hit ENTER to continue )
echo Finished running all tests
:Done