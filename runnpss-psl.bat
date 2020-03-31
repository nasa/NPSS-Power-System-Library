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

call runnpss -I src -I include -I model -I view -I utils %1
goto Done

:: You got down here, so run all models in the model folder.
:RunAll
set /p=You are running runnpss-psl.bat without an argument. This will run all models. Hit ENTER to run first model
for %%i in (run\*) do (call runnpss -I src -I include -I model -I view -I utils %%i & set /p=Finished %%i, Hit ENTER to continue )
echo Finished running all models
:Done
