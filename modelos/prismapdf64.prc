; Instruções
;
; SequenciaApagar: Indica a sequencia de caracteres que será apagada do relatório
; ModoGeracao: 0  > Gerar o PDF e exibe na tela
;              1  > Gera o PDF numa janela minimizada
;              2  > Gera o PDF e o envia para o PDF 24
;              3  > Gera o PDF e não executa nenhuma ação posterior
; LocalizacaoPDF24: Caminho completo do PDF24 (usar barras duplas '\\')
; ArgumentosPDF24: Indica os argumentos utilizados ao executar o PDF24
; NomeFonte:  Nome da fonte utilizada nos arquivos PDF
; UsarParamINI: 1 > Utiliza pdfparam.ini com parâmetros no modo de execução

[Configuracoes]
SequenciaApagar=NomeQualquer
ModoGeracao=DiretoPDF24
LocalizacaoPDF24=C:\\Program Files (x86)\\PDF24\\pdf24-Creator.exe
ArgumentosPDF24=%s
NomeFonte=CascadiaMono.ttf
UsarParamINI=0

; Parâmetros da interface com o usuário Configurações do Prisma PDF
; 
; PosicaoX: Posição horizontal da janela
; PosicaoY: Posição vertical da janela
;    * -1, indica posição centralizada da janela

[JanelaConfigurador]
PosicaoX=-1
PosicaoY=-1