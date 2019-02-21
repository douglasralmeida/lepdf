package lePdf;
/* 
 * lePdf - Componente para transformar arquivos textos gerados no Prisma em PDF
 * Março de 2019
 * 
 */

import java.awt.Desktop;
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.net.URI;
import java.net.URL;
import java.util.Locale;
import java.util.ResourceBundle;

import javax.swing.JOptionPane;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;

import com.itextpdf.io.image.ImageDataFactory;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfName;
import com.itextpdf.kernel.pdf.PdfString;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Image;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.property.HorizontalAlignment;

public class lePdf {
  static String usuario = System.getProperty("user.name");
  static float tamFonte = 0.0F;
  static String logo = "resources/logoINSS.jpg";
  static String diretorio = "C:/CNISLINHA/";
  ResourceBundle ptC = ResourceBundle.getBundle("resources.palavrasAcentuadas", new Locale("pt", "BR"));
  static final String[] acentuados = { "a `", "a '", "a &", 
    "a ~", "e `", "e '", "e &", "i `", "i '", "i &", "o `", "o '", 
    "o &", "o ~", "u `", "u '", "u &", "c ,", "A `", "A '", "A &", 
    "A ~", "E `", "E '", "E &", "I `", "I '", "I ^", "O `", "O '", 
    "O &", "O ~", "U `", "U '", "U &", "C ," };
  static final String[] trocados = { "à", "á", "â", "ã", "è", 
    "é", "ê", "ì", "í", "î", "ò", "ó", "ô", "õ", "ù", "ù", "û", "ç", 
    "À", "Á", "Â", "Ã", "È", "É", "Ê", "Ì", "Í", "Î", "Ò", "Ó", "Ô", 
    "Õ", "Ù", "Ú", "Û", "Ç" };
  
  public static float calculaFonte(String arquivo) {
    int tamanhoMaiorLinha = 0;
    String linha = null;
    BufferedReader input;    
      
    try {
      input = new BufferedReader(new FileReader(arquivo));
      while ((linha = input.readLine()) != null) {
        if ((linha.trim() != null) && (linha.length() > tamanhoMaiorLinha)) {
          tamanhoMaiorLinha = linha.length();
        }
      }
      input.close();
      if (tamanhoMaiorLinha <= 86) {
        tamFonte = 11.0F;
      } else if (tamanhoMaiorLinha <= 106) {
        tamFonte = 9.0F;
      } else {
    	tamFonte = 6.5F;
      }
      return tamFonte;
    }
    catch (Exception e) {
      JOptionPane.showMessageDialog(null, "Erro a calcular tamanho da fonte: " + e.getMessage());
    }
    return tamFonte;
  }
  
  public static void processaTexto(String entrada, String saida) {
	BufferedReader input = null;
	PdfDocument pdf = null;
	PdfFont fonte = null;
    Document doc = null;
    String line = "";

    try {
      input = new BufferedReader(new FileReader(entrada));
      pdf = new PdfDocument(new PdfWriter(saida));
      pdf.setDefaultPageSize(PageSize.A4);
      fonte = PdfFontFactory.createFont("C:/Windows/Fonts/consola.ttf", true);
      doc = new Document(pdf);
      doc.setMargins(30.0F, 20.0F, 20.0F, 40.0F);
      doc.setFont(fonte);
      
      pdf.getCatalog().put(PdfName.Author, new PdfString("Sistema Prisma"));
      pdf.getCatalog().put(PdfName.Subject, new PdfString(usuario + " " + entrada));
      pdf.getCatalog().put(PdfName.Title, new PdfString(saida));
      
      URL url = lePdf.class.getResource(logo);
      Image img = new Image(ImageDataFactory.create(url));
//      img.scaleAbsolute(86.0F, 50.0F);
      doc.add(img);
      
      while ((line = input.readLine()) != null) {
        char NP = '\f';
        byte np = (byte)NP;
        if (line.indexOf(np) != -1) {
          pdf.addNewPage();
          doc.add(img);
        }
        String nvline = null;
        nvline = limpaLinha(line);
        
        String resto = nvline.replaceAll("[^a-zA-Z ]", " ");
        resto = resto.trim();
        resto = resto.concat(" ");
        while (resto.indexOf(" ") != -1) {
          int pos = resto.indexOf(" ");
          String palavra = resto.substring(0, pos);
          String palavraCorrigida = null;
          if ((palavra.length() >= 3) && (palavra.length() < 16)) {
            palavraCorrigida = palavra;
            if (!palavraCorrigida.equals("")) {
              nvline = nvline.replace(palavra, palavraCorrigida);
            }
          }
          resto = resto.substring(pos + 1, resto.length());
        }
        Paragraph p = new Paragraph(nvline.toString()).setFontSize(tamFonte);
        p.setHorizontalAlignment(HorizontalAlignment.LEFT);
        doc.add(p);
      }
      doc.close();
      input.close();
    }
    catch (Exception e) {
      JOptionPane.showMessageDialog(null, "Erro de processameto: " + e.getMessage());
    }
  }
  
  public static void processaPDF(String saida) {
    try {
      Desktop.getDesktop().browse(new URI(saida));
 
      return;
    }
    catch (Exception e) {
      JOptionPane.showMessageDialog(null, e.getMessage());
      BufferedInputStream reader = new BufferedInputStream(System.in);
      try {
        reader.read();
      }
      catch (IOException ex) {
        ex.printStackTrace();
      }
    }
  }
    
  public static String limpaLinha(String dado) {
    dado = dado.replace('\b', ' ');
    dado = dado.replace('^', '&');
    dado = dado.replaceAll("\033Y5!", "");
    for (int i = 0; i < acentuados.length; i++) {
      int x = dado.indexOf(acentuados[i]);
      if (x != -1) {
        dado = dado.replaceAll(acentuados[i], trocados[i]);
      }
    }
    for (int i = 0; i <= 31; i++) {
      dado = dado.replace((char)i, '\000');
    }
    return dado;
  }
    
  static class StreamReader extends Thread {
    private InputStream is;
    private StringWriter sw = new StringWriter();
    
    public StreamReader(InputStream is) {
      this.is = is;
    }
    
    public void run() {
      try {
        int c;
        while ((c = this.is.read()) != -1) {
          this.sw.write(c);
        }
      }
      catch (IOException localIOException) {}
    }
    
    public String getResult() {
      return this.sw.toString();
    }
  }
  
  private static void setAppTheme() {
	try {
	  UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
	} catch (ClassNotFoundException | InstantiationException | IllegalAccessException
	       | UnsupportedLookAndFeelException e1) {
	  e1.printStackTrace();
	  return;
	}
  }
  
  public static void main(String[] args) {
	//setAppTheme();
    if (args.length < 3) {
      JOptionPane.showMessageDialog(null, "Erro no lePdf: Argumentos insuficientes.");
      System.exit(1);
    }
    String entrada = args[0];
	String saida = args[1];
	String processo = args[2];	
	boolean processaMaisUm = args.length > 3;
	if (processo.equals("I")) {
	  tamFonte = calculaFonte(diretorio + entrada);
	  if (tamFonte == 0.0F) {
	    tamFonte = 11.0F;
	  }
	  processaTexto(diretorio + entrada, diretorio + saida);
	  if (processaMaisUm)
	    processaPDF(diretorio + saida);
	}
	if (processo.equals("E")) {
	  processaPDF(diretorio + saida);
	  System.runFinalization();
	  System.exit(0);
    }
	if (processo.equals("D")) {
	  System.runFinalization();
      System.exit(0);
	}
	System.runFinalization();
	System.exit(0);
  }
}