@echo off
:: -----------------------------------------------------------------------------
:: |                                                                           |
:: | File Name:     runnpss-psl.bat                                            |
:: | Author(s):     Jonathan Fuzaro Alencar                                    |
:: | Date(s):       February 2020                                              |
:: |                                                                           |
:: | Description:   Batch script to run NPSS Power System Library files.       |
:: |                                                                           |
:: -----------------------------------------------------------------------------

echo.
echo =========== %~n1 ===========

call runnpss -I src -I model -I view -I utils %1