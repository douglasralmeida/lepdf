package main.java;
/* 
 * lePdf - Componente para transformar arquivos textos gerados no Prisma em PDF
 * Agosto de 2018
 * 
 */

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;
import java.awt.Desktop;
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.FileOutputStream;
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
      JOptionPane.showMessageDialog(null, e.getMessage());
    }
    return tamFonte;
  }
  
  public static void processaTexto(String entrada, String saida) {
	BufferedReader input = null;
    Document output = null;
      
    try {
      input = new BufferedReader(new FileReader(entrada));
      output = new Document(PageSize.A4, 40.0F, 30.0F, 20.0F, 20.0F);
      PdfWriter.getInstance(output, new FileOutputStream(saida));
      output.open();
      output.addAuthor("Sistema Prisma");
      output.addSubject(usuario + " " + entrada);
      output.addTitle(saida);
      
      URL url = lePdf.class.getResource(logo);
      Image img = Image.getInstance(url);
      
      img.scaleAbsolute(86.0F, 50.0F);
      img.getAlignment();
      img.getScaledHeight();
      img.setAlignment(1);
      output.add(img);
      String line = "";
      while ((line = input.readLine()) != null) {
        char NP = '\f';
        byte np = (byte)NP;
        if (line.indexOf(np) != -1) {
          output.newPage();
          output.add(img);
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
        FontFactory.defaultEmbedding = true;
        FontFactory.register("C:/Windows/Fonts/consola.ttf", "Consolas");
        Paragraph p = new Paragraph(nvline.toString(), 
          FontFactory.getFont("Consolas", tamFonte, 0, 
          new BaseColor(0, 0, 0)));
        p.setAlignment(3);
        output.add(p);
      }
      output.close();
      input.close();
    }
    catch (Exception e) {
      JOptionPane.showMessageDialog(null, e.getMessage());
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
	setAppTheme();
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