/*
**	Wrapper para Java 8/10
**	O Prisma chama o aplicativo lePdf atraves do comando
**
**  Para torna-lo compatível com Java 8 ou superior este aplicativo
**	refaz a chamada.
**  Isso o torna incompatível com Java 6.
*/

#include <stdlib.h>
#include <windows.h>

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPWSTR lpCmdLine, int nCmdShow) {
    MessageBox(NULL, lpCmdLine, L"Java Wrapper", 0);
	exit(EXIT_SUCCESS);
}
