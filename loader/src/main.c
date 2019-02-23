/*
**	Carregador do Componente PDF
**	O Prisma chama o aplicativo lePdf atraves do comando:
**
**  C:\Program Files\Java\jre6\bin\java.exe -jar lepdf.jar <args>
**
**  Entretanto, cada versão do Java possui seu diretório individual, o
**  que torna a chamada incompatível com versões posteriores do Java.
**  A chamada correta deveria ser pelo path do sistema ou, pelo menos,
**  pelo javapath definido pela Oracle.
**
**  O Java 6 não é mais suportado pela Oracle e, portanto, não recebe
**  atualizações de segurança.
**
**  Para torna-lo compatível com Java 8 ou superior, este aplicativo
**	refaz a chamada para o javaw.exe disponível no subsistema Java.
**  
**  Como ele deve estar no diretório do Java 6, isso o torna incompatível
**  com esta versão do Java.
*/
#include <stdlib.h>
#include <windows.h>

/* substitui o arg. -jar lepdf.jar */
void alterarArg(wchar_t* novoarg, wchar_t* arg) {
  wchar_t* p;

  wcscpy(novoarg, L"-m lePdf/lePdf.lePdf");
  p = wcspbrk(arg, L" ");
  if (p) {
    p = wcspbrk(p+1, L" ");
    if (p) {
      wcscat(novoarg, p);
    }
  }
}

/* caminho do java */
void setJavaPath(wchar_t* path) {
  wchar_t exepath[MAX_PATH + 1];

  GetModuleFileName(0, exepath, MAX_PATH+1);
  _wsplitpath(exepath, NULL, path, NULL, NULL);
  wcscat(path, L"jre\\bin");
}

void chamarSubsistemaJava(wchar_t* arg) {
  wchar_t* javaexe = L"javaw.exe";
  wchar_t novoarg[256];
  wchar_t javapath[MAX_PATH + 1];

  alterarArg(novoarg, arg);
  setJavaPath(javapath);
  ShellExecute(NULL, L"open", javaexe, novoarg, javapath, SW_SHOWNORMAL);
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPWSTR lpCmdLine, int nCmdShow) {
  chamarSubsistemaJava(lpCmdLine);
  exit(EXIT_SUCCESS);
}