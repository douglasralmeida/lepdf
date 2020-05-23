package lePdf;
/* 
 * lePdf - Componente para transformar arquivos textos gerados no Prisma em PDF
 * Junho de 2020
 * 
 */

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.InputStream;
import java.net.URL;
import java.nio.charset.StandardCharsets;

import com.itextpdf.io.font.FontProgram;
import com.itextpdf.io.font.FontProgramFactory;
import com.itextpdf.io.font.PdfEncodings;
import com.itextpdf.io.image.ImageDataFactory;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfName;
import com.itextpdf.kernel.pdf.PdfString;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.AreaBreak;
import com.itextpdf.layout.element.Image;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.property.AreaBreakType;
import com.itextpdf.layout.property.HorizontalAlignment;
import com.itextpdf.layout.property.Leading;
import com.itextpdf.layout.property.Property;

import winapi.Mensagem;
import winapi.Shell;

public class lePdf {
  static Config config = new Config();
  static Recursos recursos = new Recursos(config);
  static String usuario = System.getProperty("user.name");
  static float tamanhoFonte = 0.0F;
  static String diretorio = "C:/cnislinha/";
  static final String[] acentuados = { "a `", "a '", "a &", 
    "a ~", "e `", "e '", "e &", "i `", "i '", "i &", "o `", "o '", 
	"o &", "o ~", "u `", "u '", "u &", "c ,", "A `", "A '", "A &", 
	"A ~", "E `", "E '", "E &", "I `", "I '", "I ^", "O `", "O '", 
	"O &", "O ~", "U `", "U '", "U &", "C ," };
  static final String[] trocados = { "à", "á", "â", "ã", "è", 
	"é", "ê", "ì", "í", "î", "ò", "ó", "ô", "õ", "ù", "ù", "û", "ç", 
	"À", "Á", "Â", "Ã", "È", "É", "Ê", "Ì", "Í", "Î", "Ò", "Ó", "Ô", 
	"Õ", "Ù", "Ú", "Û", "Ç" };
  
  public static void calcularFonte(String arquivo) {
	int tamanhoMaiorLinha = 0;
	BufferedReader buffer;
    String linha = null;
      
    try {
      buffer = new BufferedReader(new FileReader(arquivo, StandardCharsets.UTF_8));
      while ((linha = buffer.readLine()) != null) {
        if ((linha.trim() != null) && (linha.length() > tamanhoMaiorLinha))
          tamanhoMaiorLinha = linha.length();
      }
      buffer.close();
      if (tamanhoMaiorLinha <= 86)
        tamanhoFonte = 11.0F;
      else if (tamanhoMaiorLinha <= 106)
        tamanhoFonte = 9.0F;
      else
    	tamanhoFonte = 6.5F;
    }
    catch (Exception e) {
      exibirMsg("Erro a calcular tamanho do texto: " + e.getMessage());
      tamanhoFonte = 11.0F;
    }
  }
  
  public static void exibirMsg(String msg) {
    Mensagem.exibir(msg, "Erro no Processador PDF");
  }

  public static String processarLinha(String linha) {
    String linhaProcessada;
    String palavra;
    String palavraCorrigida;
    String resto;
    int pos;

    linhaProcessada = limparLinha(linha);
    resto = linhaProcessada.replaceAll("[^a-zA-Z ]", " ").trim().concat(" ");
    if (config.excluirNome && config.nomeAExcluir.length() > 0) {
    	if (resto.toLowerCase().contains(config.nomeAExcluir.toLowerCase()))
    		return "";
    }
    while (resto.indexOf(" ") != -1) {
      pos = resto.indexOf(" ");
      palavra = resto.substring(0, pos);
      palavraCorrigida = null;
      if ((palavra.length() >= 3) && (palavra.length() < 16)) {
        palavraCorrigida = palavra;
        if (!palavraCorrigida.equals(""))
          linhaProcessada = linhaProcessada.replace(palavra, palavraCorrigida);
      }
      resto = resto.substring(pos + 1, resto.length());
    }
    return linhaProcessada;
  }
  
  public static void processarTexto(String entrada, String saida) {
	int i;
    String linha = "";	
	BufferedReader buffer = null;
    Document doc = null;	
	PdfDocument pdf = null;
	StringBuilder sb;

    sb = new StringBuilder(256);
    try {
      buffer = new BufferedReader(new FileReader(entrada, StandardCharsets.UTF_8));
      pdf = new PdfDocument(new PdfWriter(saida));
      pdf.setDefaultPageSize(PageSize.A4);
      
      doc = new Document(pdf);
      doc.setMargins(30.0F, 20.0F, 20.0F, 40.0F);
      doc.setFont(recursos.getFonte());
      
      pdf.getCatalog().put(PdfName.Author, new PdfString("Sistema Prisma"));
      pdf.getCatalog().put(PdfName.Subject, new PdfString(usuario + " " + entrada));
      pdf.getCatalog().put(PdfName.Title, new PdfString(saida));
      
      doc.add(recursos.getLogotipo());
      doc.setProperty(Property.LEADING, new Leading(Leading.MULTIPLIED, 0.40f));
      
      while ((linha = buffer.readLine()) != null) {
        if (linha.indexOf('\f') > -1) {
          doc.add(new AreaBreak(AreaBreakType.NEXT_PAGE));
          doc.add(recursos.getLogotipo());
          continue;
        }
        sb.setLength(0);
        sb.append(processarLinha(linha));
        i = 7;
        while (i < sb.length() && sb.charAt(i) == ' ') {
          sb.setCharAt(i, '\u00A0');
          i++;
        }
        Paragraph p = new Paragraph(sb.toString()).setFontSize(tamanhoFonte);
        doc.add(p);
      }
      doc.close();	
      buffer.close();
    }
    catch (Exception e) {
      exibirMsg("Erro de processameto: " + e.getMessage());
    }
  }
  
  public static void exibirPDF(String saida) {
    try {
      Shell.abrir(saida, config.modoGeracao);
	}
	catch (Exception e) {
	  exibirMsg(e.getMessage());
	}
  }
  
  public static void enviarParaPDF24(String saida) {	  
	try {
	  Shell.executar(config.arquivoPDF24, config.exePDF24, saida);
	}
	catch (Exception e) {
	  exibirMsg(e.getMessage());
	}
  }
    
  public static String limparLinha(String dado) {
    int i;
	int x;
	  
	dado = dado.replace('\b', ' ');
	dado = dado.replace('^', '&');
	dado = dado.replaceAll("\033Y5!", "");
	for (i = 0; i < acentuados.length; i++) {
	  x = dado.indexOf(acentuados[i]);
	  if (x != -1)
	    dado = dado.replaceAll(acentuados[i], trocados[i]);
	}
	for (i = 0; i <= 31; i++)
	  dado = dado.replace((char)i, '\000');

	return dado;
  }
   
  public static void main(String[] args) {
    if (args.length < 3) {
      exibirMsg("Erro ao executar o componente de processamento PDF: Parâmetros insuficientes.");
      System.exit(1);
    }
    if (PrimeiroUso.testar())
      if (!PrimeiroUso.processar())
        System.exit(1);    		    
    String entrada = args[0];
	String saida = args[1];
	String processo = args[2];
	boolean exibirArquivoPDF = args.length > 3;
	if (!config.carregar())
	  System.exit(1);
	if (processo.equals("I")) {
	  calcularFonte(diretorio + entrada);
	  processarTexto(diretorio + entrada, diretorio + saida);
	  if (exibirArquivoPDF)
	    if (config.modoGeracao == TipoGeracao.TIPOGERACAO_DIRETA)
		  enviarParaPDF24(diretorio + saida);
		else
		  exibirPDF(diretorio + saida);
	} else if (processo.equals("E"))
	  exibirPDF(diretorio + saida);
	System.runFinalization();
	System.exit(0);
  }
}