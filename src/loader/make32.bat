SETLOCAL

SET "TOOLCHAINDIR=C:\dev\mingw32\bin"
SET "MAKEEXE=mingw32-make.exe"
SET PATH=%TOOLCHAINDIR%

%MAKEEXE% CC=i686-w64-mingw32-gcc WRES="%TOOLCHAINDIR%\windres.exe -Iinclude/" PROJECTNAME=loader32

MOVE bin\loader32.exe ..\..\bin\loader32.exe

ENDLOCAL