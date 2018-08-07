SET "TOOLCHAINDIR=D:\mingw32\bin"
SET "MAKEEXE=%TOOLCHAINDIR%\mingw32-make.exe"

%MAKEEXE% CC=i686-w64-mingw32-gcc WRES="%TOOLCHAINDIR%\windres.exe -Iinclude/" PROJECTNAME=java32