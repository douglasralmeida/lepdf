SETLOCAL

SET "TOOLCHAINDIR=C:\dev\java-12.x86\bin"
SET PATH=%TOOLCHAINDIR%

jlink --add-modules lePdf --module-path lib;bin --launcher gui=lePdf/lePdf.lePdf --output ../../bin/jre32 --strip-debug --compress=0 --no-header-files --no-man-pages --ignore-signing-information

ENDLOCAL