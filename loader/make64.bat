SET "TOOLCHAINDIR=D:\mingw64\bin"
SET "MAKEEXE=%TOOLCHAINDIR%\mingw32-make.exe"

%MAKEEXE% CC=x86_64-w64-mingw32-gcc WRES="%TOOLCHAINDIR%\windres.exe -Iinclude/" PROJECTNAME=loader64