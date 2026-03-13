@echo off

set NAME=baby2

rem echo.
rem echo ===========================================================================
rem echo Graphics
rem echo ===========================================================================
php -f ./graphics/convert_bgr.php
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ./graphics/convert_font.php
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ./graphics/convert_gra.php
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Code
echo ===========================================================================
php -f ../scripts/preprocess.php %NAME%_cpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11 -ysl 32 -yus -l _%NAME%_cpu.lst _%NAME%_cpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ../scripts/lst2bin.php _%NAME%_cpu.lst %NAME%_cpu.bin bin 1000
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Loader, Packing etc..
echo ===========================================================================
del %NAME%_cpu.zx0
..\scripts\zx0 %NAME%_cpu.bin %NAME%_cpu.zx0
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ../scripts/preprocess.php %NAME%.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11 -ysl 32 -yus -l _%NAME%.lst _%NAME%.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ../scripts/lst2bin.php _%NAME%.lst ./release/%NAME%.bin bbk 1000
if %ERRORLEVEL% NEQ 0 ( exit /b )


del _%NAME%_cpu.mac
del %NAME%_cpu.bin
del %NAME%_cpu.zx0
del _%NAME%.mac
del _%NAME%.lst
rem del _%NAME%_cpu.lst

echo.
start ..\..\bkemu\BK_x64.exe /C BK-0010-01 /B .\release\%NAME%.bin
