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

echo.
echo =========== %~n1 ===========
echo.

call runnpss -I src -I include -I model -I view -I util %1