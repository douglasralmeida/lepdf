# lepdf - Componente PDF para Prisma

O lePdf é uma ferramenta para uso interno no Instituto Nacional do Seguro Social (INSS) que auxilia o sistema legado Prisma a gerar arquivos em PDF.

* [Notas de lançamento](docs/atualizacoes.md)

## Instalando o Componente PDF para Prisma

1. Instale o [JRE 8.0](https://www.java.com/pt_BR/download/) ou superior.
2. Baixe o instalador mais recente disponível em [Release](https://github.com/douglasralmeida/lepdf/releases).
3. Execute o progrma de instalação.

## Ativando a geração de PDF

1. Execute o Prisma através do atalho disponível na sua área de trabalho.
2. Após entrar na sua conta, vá para BENEFÍCIOS.
3. Pressione a tecla *.
4. Pressione a tecla M.
5. Pressione a tecla ? seguido de ENTER.
6. Escolha a impressoa 999 Documento PDF e pressione ENTER.

## Aviso de incompatibilidade

Para torná-lo compatível com o Java 8 ou superior, o componente PDF é incompatível com o Java 6. Desinstale qualquer versão deste JRE do seu computador antes de instalá-lo e remova seu endereço do javapath nas variáveis de sistema.

Ao instalar o JRE 6 em um computador com o Componente PDF instalado o tornará inutilizável.

## Compilação

Para compilar todos os componentes, é necessário:

* IDE Eclipse.
* JRE 8.0 ou superior.
* Compilador GCC.
* MingW-w64.
* Biblioteca itextpdf-5.5.13.jar
* Biblioteca pdfbox-2.0.11.jar
* LaTeX.
* Inno Setup.

Antes de compilar o java6wrapper, altere os arquivos make32 e make64, substituindo a variável makeexe pelo endereço do MingW-Make do seu computador.

## Feedback
* Use o item [Issues](https://github.com/douglasralmeida/lepdf/issues) do Github para fornecer feedback.

## Agradecimentos

A primeira versão do lePdf foi desenvolvida por:
* ???
* ???

## Licença

O lePdf é livre. Sinta a vontade para estudar o código e modificá-lo. Você pode criar um fork do projeto para efetuar suas alterações e testá-las.