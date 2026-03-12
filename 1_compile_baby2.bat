@echo off

rem echo.
rem echo ===========================================================================
rem echo Graphics
rem echo ===========================================================================
php -f ./graphics/convert_bgr.php
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ./graphics/convert_font.php
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Code
echo ===========================================================================
set NAME=baby2
php -f ../scripts/preprocess.php %NAME%.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11 -ysl 32 -yus -l _%NAME%.lst _%NAME%.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ../scripts/lst2bin.php _%NAME%.lst ./release/%NAME%.bin bbk 1000
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ../scripts/bin2wav.php ./release/%NAME%.bin
if %ERRORLEVEL% NEQ 0 ( exit /b )

del _%NAME%.mac
rem del _%NAME%.lst

echo.
start ..\..\bkemu\BK_x64.exe /C BK-0010-01 /B .\release\%NAME%.bin
