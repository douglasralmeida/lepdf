SETLOCAL

SET "TOOLCHAINDIR=C:\mingw64\bin"
SET "MAKEEXE=mingw32-make.exe"
SET PATH=%TOOLCHAINDIR%

%MAKEEXE% CC=x86_64-w64-mingw32-gcc WRES="%TOOLCHAINDIR%\windres.exe -Iinclude/" PROJECTNAME=loader64

MOVE bin\loader64.exe ..\dist\loader64.exe

ENDLOCAL