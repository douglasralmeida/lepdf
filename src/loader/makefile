# Makefile

#### Secao dos cabecalhos ####
PROJECTNAME=loader
CC=gcc
DEFS=-D_UNICODE -DUNICODE -D_WIN32_WINNT=0x0600
# Comandos para usar no DEFS
# -D_UNICODE -DUNICODE		Adicona suporte a Unicode.
# -D_WIN32_WINNT=0x0600		O aplicativo requer Windows Vista ou superior.

CFLAGS=-c -Wall -Wextra -Wpedantic $(DEFS) -Iinclude/
DBGFLAGS=-ggdb -fno-inline -fno-omit-frame-pointer 
WRES=windres -Iinclude/
# O comando windres compila os recursos do aplicativo, como ícone, definicao de versao, etc.

LIBS=
LDFLAGS=-mwindows -municode
BINDIR=bin
OBJDIR=obj
OBJFILES=recursos.ro main.o
OBJECTS=$(addprefix $(OBJDIR)/, $(OBJFILES))
RESDIR=res
SOURCEDIR=src
TESTDIR=test

#### Secao das regras ####
$(OBJDIR)/%.o: $(SOURCEDIR)/%.c
	@(echo. && echo Compilando $<...)
	$(CC) $(DBGFLAGS) $(CFLAGS) $< -o $@

$(OBJDIR)/%.ro: $(RESDIR)/%.rc
	@(echo. && echo Compilando $<...)
	$(WRES) $< -o $@

.PHONY: all clean help run debug
# Impede do comando nao ser executado caso exista um arquivo de mesmo nome ja atualizado.

all: clean $(PROJECTNAME).exe
	
$(PROJECTNAME).exe: $(OBJECTS)
	@(echo. && echo Gerando executavel...)
	$(CC) $(LDFLAGS) -o $(BINDIR)/$@ $^ $(LIBS)

clean:
	@echo Executando limpeza...
	del /q $(addprefix $(OBJDIR)\, $(OBJFILES))
	del /q $(BINDIR)\$(PROJECTNAME).exe
	
debug:
	gdb -q -ex 'cd bin' --args $(BINDIR)\$(PROJECTNAME).exe
	
help:
	@(echo Parametros disponiveis: && echo.)
	@echo MAKE 			Compila o aplicativo.
	@echo MAKE CLEAN	Limpa os objetos e executaveis para uma nova compilacao.
	@echo MAKE DEBUG	Executa o aplicativo no modo de depuracao com a supervisao do GDB.
	@echo MAKE HELP		Exibe este menu de ajuda.
	@echo MAKE RUN		Executa o aplicativo ja compilado.
	@echo.

run:
	cd bin && $(PROJECTNAME).exe