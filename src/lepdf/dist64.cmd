SETLOCAL

SET "TOOLCHAINDIR=C:\dev\java-14.x64\bin"
SET PATH=%TOOLCHAINDIR%

jlink --add-modules lePdf --module-path lib;bin --launcher gui=lePdf/lePdf.lePdf --output ../../bin/jre64 --strip-debug --strip-java-debug-attributes --compress=0 --no-header-files --no-man-pages --ignore-signing-information

ENDLOCAL