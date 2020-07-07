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
**  Para torna-lo compatível com Java 9 ou superior, este aplicativo
**	refaz a chamada para o javaw.exe disponível no subsistema Java.
**
**  É necessário configurar no diretório onde o Java 6 deveria estar
**  instalado um softlink para este carregador. Assim, ele é incompatível
**  com o Java 6.
**  
*/
#include <stdlib.h>
#include <windows.h>
#include "main.h"

/* substitui o arg. -jar lepdf.jar por -m lePdf/lePdf.lePdf */
void alterarArg(wchar_t* arg, wchar_t* novoarg) {
  wchar_t* p;

  /* adiciona uma otimização Java */
  
  wcscpy(novoarg, L"-Xshare:auto ");
  wcscpy(novoarg, L"-m lePdf/lePdf.lePdf");

  /* elimina os dois primeiros argumentos */
  p = wcschr(arg, L' ');
  p = wcschr(p+2, L' ');

  /* concatena o restante */
  wcscat(novoarg, p);
}

/* executa a aplicação Java */
void chamarSubsistemaJava(wchar_t* arg) {
  wchar_t* javaexe = L"javaw.exe";
  wchar_t novoarg[256] = {0};
  wchar_t javapath[MAX_PATH];

  alterarArg(arg, novoarg);
  setJavaPath(javapath);
  ShellExecute(NULL, L"open", javaexe, novoarg, javapath, SW_SHOWNORMAL);
}

/* exibe mensagens de erro na tela */
void exibirMensagem(const wchar_t* msg) {
  MessageBoxW(0, msg, L"Erro", 0x00000000L | 0x00000040L);
}

/* obtém do registro do Windows a pasta de instalação do PDF Prisma */
void getPrismaPDFPath(wchar_t* path) {
  HKEY hKey;
  const wchar_t* erromsg = L"Ocorreu um erro ao encontrar o componente Prisma PDF. Reinstale o aplicativo e tente novamente.";
  const wchar_t* chave = L"SOFTWARE\\INSS\\Prisma";
  const wchar_t* nome = L"Pasta";
  DWORD tamanho;
  DWORD tipo;

  if (RegOpenKeyExW(HKEY_LOCAL_MACHINE, chave, 0, KEY_QUERY_VALUE, &hKey) != ERROR_SUCCESS) {
    exibirMensagem(erromsg);
    exit(EXIT_FAILURE);
  }

  if (RegQueryValueExW(hKey, nome, NULL, &tipo, NULL, &tamanho) != ERROR_SUCCESS || tipo != REG_SZ) {
    RegCloseKey(hKey);
    exibirMensagem(erromsg);
    exit(EXIT_FAILURE);
  }

  if (RegQueryValueExW(hKey, nome, NULL, &tipo, (LPBYTE)path, &tamanho) != ERROR_SUCCESS) {
    RegCloseKey(hKey);
    exibirMensagem(erromsg);
    exit(EXIT_FAILURE);
  }
  RegCloseKey(hKey);
}

/* define o caminho do java runtime */
void setJavaPath(wchar_t* path) {
  //GetModuleFileName(0, exepath, MAX_PATH+1);
  //_wsplitpath(exepath, NULL, path, NULL, NULL);
  getPrismaPDFPath(path);
  wcscat(path, L"\\jre\\bin");
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPWSTR lpCmdLine, int nCmdShow) {
  if (wcslen(lpCmdLine) == 0) {
    exibirMensagem(L"Este programa não deve ser executado de forma independente.");
    exit(EXIT_FAILURE);
  }
  chamarSubsistemaJava(lpCmdLine);
  exit(EXIT_SUCCESS);    
}
