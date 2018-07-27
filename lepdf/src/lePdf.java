/* 
 * lePdf
 * versão 1.0.4
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
import java.io.File;
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
  static String pathAdobe = null;
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
    try {
      BufferedReader input = null;
      input = new BufferedReader(new FileReader(arquivo));
      int tam = 0;
      String line = null;
      while ((line = input.readLine()) != null) {
        if ((line.trim() != null) && (line.length() > tam)) {
          tam = line.length();
        }
      }
      input.close();
      if (tam <= 100) {
        tamFonte = 10.0F;
      }
      if ((tam > 100) && (tam < 110)) {
        tamFonte = 8.0F;
      }
      if (tam > 132) {
        tamFonte = 6.0F;
      }
      return tamFonte;
    }
    catch (Exception e) {
      JOptionPane.showMessageDialog(null, e.getMessage());
    }
    return tamFonte;
  }
  
  public static void processaTexto(String entrada, String saida) {
    try {
      BufferedReader input = null;
      Document output = null;
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
      System.out.println("pressione enter para continuar...");
      BufferedInputStream reader = new BufferedInputStream(System.in);
      try {
        reader.read();
      }
      catch (IOException ex) {
        ex.printStackTrace();
      }
    }
  }
  
  public static void removeArquivos(String arqtxt, final String arqpdf) {
    new Thread(new Runnable() {
      public void run() {
        try {
          Thread.sleep(2000L);
        }
        catch (InterruptedException e) {
          e.printStackTrace();
        }
        File dir = new File(lePdf.diretorio);
        File[] arquivos = dir.listFiles();
        if (arquivos != null) {
          int length = arquivos.length;
          for (int i = 0; i < length; i++) {
            File f = arquivos[i];
            if (f.isFile() && !f.getName().toString().equals(arqpdf)) {
                 if (f.getName().indexOf("ARQTXT") != -1) {
                   f.delete();
                   f.deleteOnExit();
                 }
                 if (f.getName().indexOf("ARQPDF") != -1) {
                   f.delete();
                   f.deleteOnExit();
                 }
            }
          }
        }
      }
    }).start();
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
  
  public static String corrigePalavra(String dadoOri) throws Exception {
    try {
      ResourceBundle ptC = ResourceBundle.getBundle("resources.palavrasAcentuadas", new Locale("pt", "BR"));
      String palavra = null;
      Boolean carac = Boolean.valueOf(true);
      Boolean OES = Boolean.valueOf(false);
      Boolean oes = Boolean.valueOf(false);
      Boolean plural = Boolean.valueOf(false);
      if (dadoOri.lastIndexOf("oes") != -1) {
        dadoOri = dadoOri.replace("oes", "ao");
        oes = Boolean.valueOf(true);
      }
      if (dadoOri.lastIndexOf("OES") != -1) {
        dadoOri = dadoOri.replace("OES", "AO");
        OES = Boolean.valueOf(true);
      }
      String comp = dadoOri.substring(dadoOri.length() - 1);
      String letra = dadoOri.substring(dadoOri.length() - 1);
      if ((comp.equalsIgnoreCase("S")) && 
         (!oes.booleanValue()) &&
         (!OES.booleanValue())) {
        plural = Boolean.valueOf(true);
        dadoOri = dadoOri.substring(0, dadoOri.length() - 1);
      }
      if (carac.booleanValue()) {
        String mcu = dadoOri.toUpperCase();
        String mcl = dadoOri.toLowerCase();
        String mct = mcl.substring(0, 1).toUpperCase().concat(
          mcl.substring(1, mcl.length()));
        if (ptC.containsKey(mcl)) {
          String palavramcl = ptC.getString(mcl);
          String palavramcu = palavramcl.toUpperCase();
          String palavramct = palavramcl.substring(0, 1)
            .toUpperCase().concat(palavramcl.substring(1, palavramcl.length()));
          if (mcu.equals(dadoOri)) {
            if (OES.booleanValue()) {
              palavramcu = palavramcu.replace("ÃO", "ÕES");
            }
            palavra = palavramcu;
          }
          if (mcl.equals(dadoOri)) {
            if (oes.booleanValue()) {
              palavramcl = palavramcl.replace("ão", "ões");
            }
            palavra = palavramcl;
          }
          if (mct.equals(dadoOri)) {
            if (oes.booleanValue()) {
              palavramct = palavramct.replace("ão", "ões");
            }
            palavra = palavramct;
          }
          if (plural.booleanValue()) {
            if (mcl.equals(dadoOri)) {
              palavra = palavramcl.concat("s");
            }
            if (mcu.equals(dadoOri)) {
              palavra = palavramcu.concat("S");
            }
            if (mct.equals(dadoOri)) {
              palavra = palavramcl.concat("s");
            }
            System.out.println(dadoOri + "  " + palavra);
          }
        }
      }
      if (palavra == null) {
        if (plural.booleanValue()) {
          palavra = dadoOri.concat(letra);
        }
      }
      return dadoOri;
    }
    catch (Exception e) {}
    return dadoOri;
  }
  
  public static final String readRegistry(String location) {
    try {
      Process process = Runtime.getRuntime().exec(
        "reg query \"" + location);
      StreamReader reader = new StreamReader(process.getInputStream());
      reader.start();
      process.waitFor();
      reader.join();
      String output = reader.getResult();
      String[] parsed = output.split("\t");
      
      return parsed[(parsed.length - 1)];
    }
    catch (Exception e) {}
    return null;
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
      System.out.println("Erro lePdf: Argumentos insuficientes.");
      System.exit(1);
    }
    String entrada = args[0];
	String saida = args[1];
	String processo = args[2];	
	boolean processaMaisUm = args.length > 3;
	if (processo.equals("I")) {
	  removeArquivos(entrada, saida);
	  tamFonte = calculaFonte(diretorio + entrada);
	  if (tamFonte == 0.0F) {
	    tamFonte = 10.0F;
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
	  removeArquivos(entrada, saida);
	  System.runFinalization();
      System.exit(0);
	}
	System.runFinalization();
	System.exit(0);
  }
}