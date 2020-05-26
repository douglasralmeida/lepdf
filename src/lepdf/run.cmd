SETLOCAL

SET "TOOLCHAINDIR=C:\dev\java-14.x86\bin"
SET PATH=%TOOLCHAINDIR%

javaw --add-modules lePdf --module-path lib;bin -m lePdf/lePdf.lePdf

ENDLOCAL