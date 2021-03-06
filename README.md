# lepdf - Componente PrismaPDF

O lePdf é uma ferramenta para uso interno no Instituto Nacional do Seguro Social (INSS) que auxilia o sistema legado Prisma a gerar arquivos em PDF.

* [Notas de lançamento](docs/atualizacoes.md)

## Instalando o Componente PDF para Prisma 2.1

O instalador do Componente PDF está incluso no Instalador do Prisma.

## Ativando a geração de PDF

1. Execute o Prisma através do atalho disponível na sua área de trabalho.
2. Após entrar na sua conta, vá para BENEFÍCIOS.
3. Pressione a tecla *.
4. Pressione a tecla M.
5. Pressione a tecla ? seguido de ENTER.
6. Escolha a impressoa 999 Documento PDF e pressione ENTER.

## Aviso de incompatibilidade

Para torná-lo compatível com o Java 8 ou superior, o componente PDF é incompatível com o Java 6. Desinstale qualquer versão deste JRE do seu computador antes de instalá-lo e remova seu endereço do javapath nas variáveis de sistema.

Instalar o JRE 6 em um computador com o Componente PDF instalado o tornará inutilizável.

## Compilação

Para compilar todos os componentes, é necessário:

* IDE Eclipse 2020.6 ou superior.
* OpenJDK 12.0.2
* Compilador GCC 10.0.
* Lazarus 2.0.8
* MingW-w64.
* Biblioteca itextpdf io 7.1.5
* Biblioteca itextpdf kernel 7.1.5
* Biblioteca itextpdf layout 7.1.5
* Biblioteca Java Native Access 5.5.0
* Biblioteca Java Native Access Platform 5.5.0
* Bibilioteca Simple Logging Facade for Java 1.7.25
* Biblioteca BouncyCastle 1.60
* Biblioteca Ini4j 0.5.4
* LaTeX.

As bibliotecas JAR descritas acima não possuem suporte a modularização do Java 12. Use as versões modificadas disponíveis em loader/lib/.

Antes de compilar o loader, altere os arquivos make32 e make64, substituindo a variável makeexe pelo endereço do MingW-Make do seu computador.

## Feedback
* Use o item [Issues](https://github.com/douglasralmeida/lepdf/issues) do Github para fornecer feedback.

## Agradecimentos

A primeira versão do lePdf foi desenvolvida por:
* ???
* ???

## Licença

O lePdf é livre. Sinta a vontade para estudar o código e modificá-lo. Você pode criar um fork do projeto para efetuar suas alterações e testá-las.