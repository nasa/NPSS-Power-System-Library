@echo off
:: -----------------------------------------------------------------------------
:: |                                                                           |
:: | File Name:     NPSS-PSL-env.bat                                           |
:: | Author(s):     Jonathan Fuzaro Alencar                                    |
:: | Date(s):       February 2020                                              |
:: |                                                                           |
:: | Description:   Batch script to configure NPSS PSL environment.            |
:: |                                                                           |
:: -----------------------------------------------------------------------------

setlocal enabledelayedexpansion

:path_request
if defined NPSS_PSL_PATH (
    echo Would you like to reset your NPSS Power System Library path? (current: %NPSS_PSL_PATH%^)
    set /p input="(Y/N) >>> "

    if /i "!input!" == "y" goto :config_path
    if /i "!input!" == "n" (
        goto :add_to_path
    ) else (
        echo [ERROR]: Not a valid response
        endlocal
        goto :eof
    )
) else echo NPSS Power System Library path not set^^!

:config_path
endlocal

echo Please paste the path to NPSS power system library root folder: 
set /p NPSS_PSL_PATH=">>> "

:add_to_path
endlocal
echo %PATH%|find /i "%~dp0bin">nul || set PATH=%PATH%;%~dp0bin