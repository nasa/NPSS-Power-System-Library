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

if not defined NPSS_PSL_PATH call NPSS-PSL-env.bat

echo.
echo =========== %~n1 ===========

call runnpss -I %NPSS_PSL_PATH%\src  -I %NPSS_PSL_PATH%\include^
 -I %NPSS_PSL_PATH%\model -I %NPSS_PSL_PATH%\view -I %NPSS_PSL_PATH%\utils %1