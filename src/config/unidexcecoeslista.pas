unit unidExcecoesLista;

{$mode objfpc}{$H+}

interface

uses
  unidExcecoes;

const
  excecaoCriarDirConfig: TExcecaoDados = (
    Mensagem: 'Não foi possível gerar as configurações padrão do Gerador de Atalhos. Impossível criar a pasta de configurações.';
    AjudaID: 101);

  excecaoCopiarModeloConfig: TExcecaoDados = (
    Mensagem: 'Não foi possível gerar as configurações padrão do Gerador de Atalhos. Impossível copiar configurações padrão.';
    AjudaID: 102);

  excecaoCriarDirPrisma: TExcecaoDados = (
    Mensagem: 'Não foi possível gerar as configurações de acesso a máquina Prisma. Impossível criar a pasta de configurações de acesso.';
    AjudaID: 110);

  excecaoObterModeloPrisma: TExcecaoDados = (
    Mensagem: 'Não foi possível gerar as configurações de acesso a máquina Prisma. Impossível obter o arquivo modelo das configurações de acesso.';
    AjudaID: 111);

  excecaoCriarDirPlanoFundo: TExcecaoDados = (
    Mensagem: 'Não foi possível gerar as configurações de acesso a máquina Prisma. Impossível criar a pasta de imagens de plano de fundo.';
    AjudaID: 112);

  excecaoCriarDirTemasPess: TExcecaoDados = (
    Mensagem: 'Não foi possível instalar o tema selecionado. Impossível criar a pasta de temas do usuário.';
    AjudaID: 113);

  excecaoInstalarTema: TExcecaoDados = (
    Mensagem: 'Não foi possível instalar o tema selecionado. Impossível copiar arquivo para a coleção de temas do usuário.';
    AjudaID: 130);

  excecaoParametrosIncorretos: TExcecaoDados = (
    Mensagem: 'Os parâmetros de inicialização estão incorretos.';
    AjudaID: 150);

  excecaoArquivoNaoExiste: TExcecaoDados = (
    Mensagem: 'O arquivo informado não existe.';
    AjudaID: 150);

  excecaoTemaFormatoInvalido: TExcecaoDados = (
    Mensagem: 'O arquivo de tema selecionado está num formato inválido.';
    AjudaID: 151);

implementation

end.

