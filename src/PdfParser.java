import java.io.File;
import java.io.IOException;
import org.apache.pdfbox.pdfparser.PDFParser;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.pdfbox.io.RandomAccessFile;

public class PdfParser {
  static String enderecoRecurso = null;
 
  public static String getConteudo() {
    File f = new File(enderecoRecurso);
    PDDocument pdfDocument = null;
    try {
      RandomAccessFile randomAccessFile = new RandomAccessFile(f, "r");
      PDFParser parser = new PDFParser(randomAccessFile);
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
	if (args.length < 1) {
	  System.out.println("Erro pdfParser: Argumentos insuficientes.");
	  System.exit(1);
	}
	  
    enderecoRecurso = args[0];
    System.out.println(getConteudo());
  }
}