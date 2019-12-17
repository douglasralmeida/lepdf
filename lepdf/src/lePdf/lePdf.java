package lePdf;
/* 
 * lePdf - Componente para transformar arquivos textos gerados no Prisma em PDF
 * Novembro de 2019
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
import com.sun.jna.platform.win32.Shell32Util;
import com.sun.jna.platform.win32.ShlObj;

import winapi.Mensagem;
import winapi.Shell;

public class lePdf {
  static Config config = new Config();
  static String usuario = System.getProperty("user.name");
  static float tamFonte = 0.0F;
  static String arquivoFonte;
  static String logo = "/resources/logoINSS.jpg";
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
	BufferedReader entrada;
    int tamanhoMaiorLinha = 0;
    String linha = null;
      
    try {
      entrada = new BufferedReader(new FileReader(arquivo, StandardCharsets.UTF_8));
      while ((linha = entrada.readLine()) != null) {
        if ((linha.trim() != null) && (linha.length() > tamanhoMaiorLinha))
          tamanhoMaiorLinha = linha.length();
      }
      entrada.close();
      if (tamanhoMaiorLinha <= 86)
        tamFonte = 11.0F;
      else if (tamanhoMaiorLinha <= 106)
        tamFonte = 9.0F;
      else
    	tamFonte = 6.5F;
    }
    catch (Exception e) {
      exibirMsg("Erro a calcular tamanho do texto: " + e.getMessage());
      tamFonte = 11.0F;
    }
  }
  
  public static void exibirMsg(String msg) {
	  Mensagem.exibir(msg, "Processador PDF");
  }

  public static String processarLinha(String linha) {
    String linhaProcessada;

    linhaProcessada = limparLinha(linha);
    String resto = linhaProcessada.replaceAll("[^a-zA-Z ]", " ").trim().concat(" ");
    if (config.excluirNome && config.nomeAExcluir.length() > 0) {
    	if (resto.toLowerCase().contains(config.nomeAExcluir.toLowerCase()))
    		return "";
    }
    while (resto.indexOf(" ") != -1) {
      int pos = resto.indexOf(" ");
      String palavra = resto.substring(0, pos);
      String palavraCorrigida = null;
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
	BufferedReader input = null;
	PdfDocument pdf = null;
	PdfFont fonte = null;
	StringBuilder sb;
    Document doc = null;
    String linha = "";

    try {
      input = new BufferedReader(new FileReader(entrada, StandardCharsets.UTF_8));
      pdf = new PdfDocument(new PdfWriter(saida));
      pdf.setDefaultPageSize(PageSize.A4);
  
      InputStream fs = lePdf.class.getResourceAsStream(arquivoFonte);
      FontProgram fp = FontProgramFactory.createFont(fs.readAllBytes());
      fonte = PdfFontFactory.createFont(fp, PdfEncodings.IDENTITY_H);
      
      doc = new Document(pdf);
      doc.setMargins(30.0F, 20.0F, 20.0F, 40.0F);
      doc.setFont(fonte);
      
      pdf.getCatalog().put(PdfName.Author, new PdfString("Sistema Prisma"));
      pdf.getCatalog().put(PdfName.Subject, new PdfString(usuario + " " + entrada));
      pdf.getCatalog().put(PdfName.Title, new PdfString(saida));
      
      URL url = lePdf.class.getResource(logo);
      Image img = new Image(ImageDataFactory.create(url));
      img.setHorizontalAlignment(HorizontalAlignment.CENTER);
      img.scaleAbsolute(86.0F, 50.0F);
      doc.add(img);
      doc.setProperty(Property.LEADING, new Leading(Leading.MULTIPLIED, 0.40f));
      
      while ((linha = input.readLine()) != null) {
        if (linha.indexOf('\f') > -1) {
          doc.add(new AreaBreak(AreaBreakType.NEXT_PAGE));
          doc.add(img);
          continue;
        }
        sb = new StringBuilder(processarLinha(linha));
        int i = 7;
        while (i < sb.length() && sb.charAt(i) == ' ') {
          sb.setCharAt(i, '\u00A0');
          i++;
        }
        Paragraph p = new Paragraph(sb.toString()).setFontSize(tamFonte);
        doc.add(p);
      }
      doc.close();	
      input.close();
    }
    catch (Exception e) {
      exibirMsg("Erro de processameto: " + e.getMessage());
    }
  }
  
  public static void exibirPDF(String saida) {
    try {
      Shell.abrir(saida, config.modoGeracao);
      
      return;
    }
    catch (Exception e) {
      exibirMsg(e.getMessage());
    }
  }
  
  public static void enviarParaPDF24(String saida) {
	  String pdf24exe = "pdf24-Creator.exe";
	  
	  try {
		  Shell.executar(config.arquivoPDF24, pdf24exe, saida);
	  }
	  catch (Exception e) {
		  exibirMsg(e.getMessage());
	  }
  }
    
  public static String limparLinha(String dado) {
    dado = dado.replace('\b', ' ');
    dado = dado.replace('^', '&');
    dado = dado.replaceAll("\033Y5!", "");
    for (int i = 0; i < acentuados.length; i++) {
      int x = dado.indexOf(acentuados[i]);
      if (x != -1)
        dado = dado.replaceAll(acentuados[i], trocados[i]);
    }
    for (int i = 0; i <= 31; i++)
      dado = dado.replace((char)i, '\000');

    return dado;
  }
   
  public static void main(String[] args) {
    if (args.length < 3) {
      exibirMsg("Erro ao abrir o componente de processamento PDF: Argumentos insuficientes.");
      System.exit(1);
    }
    arquivoFonte = "/resources/" + config.nomeFonte;
    String entrada = args[0];
	String saida = args[1];
	String processo = args[2];
	boolean processaMaisUm = args.length > 3;
	if (processo.equals("I")) {
	  calcularFonte(diretorio + entrada);
	  processarTexto(diretorio + entrada, diretorio + saida);
	  if (processaMaisUm)
		  if (config.modoGeracao == TipoGeracao.TIPOGERACAO_DIRETA)
			  enviarParaPDF24(diretorio + saida);
		  else
		      exibirPDF(diretorio + saida);
	} else if (processo.equals("E")) {
		exibirPDF(diretorio + saida);
    }
	System.runFinalization();
	System.exit(0);
  }
}