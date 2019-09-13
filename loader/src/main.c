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
**  Para torna-lo compatível com Java 11, este aplicativo
**	refaz a chamada para o javaw.exe disponível no subsistema Java.
**
**  É necessário configurar no diretório onde o Java 6 deveria estar
**  instalado um softlink para este carregador. Assim, ele é incompatível
**  com o Java 6.
**  
*/
#include <stdlib.h>
#include <windows.h>

/* substitui o arg. -jar lepdf.jar */
void alterarArg(wchar_t* novoarg, wchar_t* arg) {
  wchar_t* p;
  wchar_t* q;

  wcscpy(novoarg, L"-m lePdf/lePdf.lePdf");

  /* elimina os dois primeiros argumentos */
  p = wcschr(arg, L' ');
  p = wcschr(p+2, L' ');
  
  /* concatena o restante */
  wcscat(novoarg, p);
}

/* caminho do java */
void setJavaPath(wchar_t* path) {
  wchar_t exepath[MAX_PATH + 1];

  GetModuleFileName(0, exepath, MAX_PATH+1);
  _wsplitpath(exepath, NULL, path, NULL, NULL);
  wcscat(path, L"jre\\bin");
}

/* executa a aplicação Java */
void chamarSubsistemaJava(wchar_t* arg) {
  wchar_t* javaexe = L"javaw.exe";
  wchar_t novoarg[256] = {0};
  wchar_t javapath[MAX_PATH + 1];

  alterarArg(novoarg, arg);
  setJavaPath(javapath);
  MessageBoxW(0, arg, L"CmdLine", MB_ICONINFORMATION);
  MessageBoxW(0, novoarg, L"CmdLine", MB_ICONINFORMATION);
  ShellExecute(NULL, L"open", javaexe, novoarg, javapath, SW_SHOWNORMAL);
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPWSTR lpCmdLine, int nCmdShow) {
  chamarSubsistemaJava(lpCmdLine);
  exit(EXIT_SUCCESS);
}