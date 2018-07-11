package pdf;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintStream;
import org.apache.pdfbox.pdfparser.PDFParser;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.util.PDFTextStripper;

public class PdfParser {
  static String enderecoRecurso = null;
 
  public static String getConteudo() {
    File f = new File(enderecoRecurso);
    FileInputStream is = null;
    try {
      is = new FileInputStream(f);
    }
    catch (Exception e) {
      System.out.println("ERRO: " + e.getMessage());
      return "erro abertura do arquivo";
    }
    PDDocument pdfDocument = null;
    try {
      PDFParser parser = new PDFParser(is);
      parser.parse();
      pdfDocument = parser.getPDDocument();
      System.out.println(pdfDocument);
      PDFTextStripper stripper = new PDFTextStripper();
      return stripper.getText(pdfDocument);
    }
    catch (IOException e) {
      return "ERRO: Não é possível abrir o stream" + e;
    }
    catch (Throwable e) {
      String str;
      return "ERRO: Um erro ocorreu enquanto tentava obter o conteúdo do PDF " + e.getCause();
    }
    finally {
      if (pdfDocument != null) {
        try {
          pdfDocument.close();
        }
        catch (IOException e) {
          return "ERRO: Não foi possível fechar o PDF." + e;
        }
      }
    }
  }
  
  public static void main(String[] args) {
    enderecoRecurso = args[0];
    System.out.println(getConteudo());
  }
}