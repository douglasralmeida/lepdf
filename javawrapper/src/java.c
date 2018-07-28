/*
**	Wrapper para Java 8/10
**	O Prisma chama o aplicativo lePdf atraves do comando:
**
**  C:\Program Files\Java\jre6\bin\java.exe -jar lepdf.jar <args>
**
**  Entretanto, cada versão Java possui seu diretório individual, o que
**  torna a chamada incompatível com versões posteriores do Java.
**  A chamada correta deveria ser pelo path do sistema, ou, pelo menos,
**  pelo javapath definido pela Oracle.
**
**  Para torna-lo compatível com Java 8 ou superior, este aplicativo
**	refaz a chamada para o javaw.exe disponível no path do sistema.
**  
**  Como ele fica no diretório do Java 6, isso o torna incompatível com
**  esta versão do Java.
*/

#include <stdlib.h>
#include <windows.h>

void chamarJavaReal(char* arg) {
  char* javaexe = "javaw.exe";
    
  ShellExecuteA(NULL, "open", javaexe, arg, NULL, SW_SHOWNORMAL);
  /*if (res == ERROR_FILE_NOT_FOUND)
    MessageBoxA(NULL, "Java não encontrado.", "Geracao de PDF", 0); */
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
  chamarJavaReal(lpCmdLine);
  exit(EXIT_SUCCESS);
}