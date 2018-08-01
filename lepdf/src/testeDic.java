import java.io.IOException;
import java.util.Locale;
import java.util.ResourceBundle;

class testeDic {
  public static void main(String[] args) throws IOException {
    ResourceBundle ptC = ResourceBundle.getBundle("resources.palavrasAcentuadas", new Locale("pt", "BR"));
    System.out.println(ptC.getString("braco"));
  }
}
